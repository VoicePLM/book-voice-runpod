FROM runpod/pytorch:2.1.0-py3.10-cuda12.1.1-devel-ubuntu22.04
RUN pip install git+https://github.com/myshell-ai/OpenVoice.git soundfile pydub
COPY . /workspace
WORKDIR /workspace
CMD python handler.py
