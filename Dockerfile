FROM debian:latest

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY pycron/ ./pycron/
COPY examples/config.yaml ./config.yaml
COPY requirements.txt ./requirements.txt
COPY setup.py ./setup.py

RUN python3 -m venv venv && \
    . venv/bin/activate && \
    pip install --upgrade pip && \
    pip install -r requirements.txt

ENV CONFIG_PATH="/app/config.yaml"
ENV VIRTUAL_ENV=/app/venv
ENV PATH="/app/venv/bin:$PATH"

ENTRYPOINT ["python3 -m pycron.scheduler --config /app/config.yaml"]
