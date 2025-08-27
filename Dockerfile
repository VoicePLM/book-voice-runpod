FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git ffmpeg \
    && rm -rf /var/lib/apt/lists/*

RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
RUN pip install runpod soundfile pydub
RUN pip install git+https://github.com/myshell-ai/OpenVoice.git

COPY . /workspace
WORKDIR /workspace

CMD ["python", "handler.py"]
