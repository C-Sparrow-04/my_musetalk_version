# CUDA base image compatible with PyTorch 2.0.1
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

# Avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# System deps
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    git \
    ffmpeg \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Make python default
RUN ln -s /usr/bin/python3.10 /usr/bin/python

WORKDIR /workspace

# Upgrade pip
RUN pip install --upgrade pip

# Install PyTorch CUDA build
RUN pip install torch==2.0.1 torchvision==0.15.2 torchaudio==2.0.2 \
    --index-url https://download.pytorch.org/whl/cu118

# Install Python deps
COPY requirements.txt .
RUN pip install -r requirements.txt

# Install MMLab ecosystem
RUN python3 -m pip install --no-cache-dir -U openmim && \
    python3 -m pip install --no-cache-dir https://huggingface.co/camenduru/phalp/resolve/main/chumpy-0.70-py3-none-any.whl && \
    python3 -m mim install mmengine && \
    python3 -m mim install "mmcv==2.0.1" && \
    python3 -m mim install "mmdet==3.1.0" && \
    python3 -m mim install "mmpose==1.1.0"

# Copy the rest of the repo (excluding models due to .dockerignore)
COPY . .

# Default command (can be overridden)
CMD ["bash"]
