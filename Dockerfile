FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-devel
RUN apt-get update && apt-get install -y git ffmpeg && rm -rf /var/lib/apt/lists/*
RUN pip install git+https://github.com/myshell-ai/OpenVoice.git soundfile pydub
COPY . /workspace
WORKDIR /workspace
CMD python handler.py
