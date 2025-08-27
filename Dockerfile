FROM nvidia/cuda:11.8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

RUN apt-get update && apt-get install -y \
    python3 python3-pip git ffmpeg \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
RUN pip3 install runpod soundfile pydub
RUN pip3 install git+https://github.com/myshell-ai/OpenVoice.git

COPY . /workspace
WORKDIR /workspace

CMD ["python3", "handler.py"]
