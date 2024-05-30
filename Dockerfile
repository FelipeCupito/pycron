FROM debian:latest

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY pycron/ ./pycron/
COPY examples/config.yaml ./config.yaml
COPY requirements.txt ./requirements.txt
COPY setup.py ./setup.py

RUN pip3 install -r requirements.txt

ENV CONFIG_PATH="/app/config.yaml"

ENTRYPOINT ["python3", "-m", "pycron.scheduler", "--config", "$CONFIG_PATH"]
