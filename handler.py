import runpod
import tempfile
import os
import base64
from openvoice import se_extractor
from openvoice.api import ToneColorConverter

vc_model = None

def init_model():
    global vc_model
    if vc_model is None:
        cfg_path = "/workspace/checkpoints_v2/converter/config.json"
        ckpt_path = "/workspace/checkpoints_v2/converter/checkpoint.pth"
        vc_model = ToneColorConverter(cfg_path)
        vc_model.load_ckpt(ckpt_path)

def handler(event):
    init_model()
    
    tts_b64 = event["input"]["tts_audio"]
    ref_b64 = event["input"]["ref_audio"]
    
    # Decodificar
    with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as f:
        f.write(base64.b64decode(tts_b64))
        tts_path = f.name
    
    with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as f:
        f.write(base64.b64decode(ref_b64))
        ref_path = f.name
    
    # Extraer SE y convertir
    target_se = se_extractor.get_se(ref_path, vc_model)
    out_path = tempfile.mktemp(suffix=".wav")
    vc_model.convert(audio_src_path=tts_path, se=target_se, output_path=out_path)
    
    # Codificar resultado
    with open(out_path, 'rb') as f:
        result_b64 = base64.b64encode(f.read()).decode()
    
    return {"converted_audio": result_b64}

runpod.serverless.start({"handler": handler})
