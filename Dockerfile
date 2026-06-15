FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    DEBIAN_FRONTEND=noninteractive \
    PATH="/root/.jbang/bin:${PATH}"

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    openjdk-21-jdk-headless \
    procps \
    tini \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN python -m pip install --upgrade pip && \
    python -m pip install -r requirements.txt

RUN curl -Ls https://sh.jbang.dev | bash -s - app setup && \
    jbang trust add https://github.com/jupyter-java && \
    jbang install-kernel@jupyter-java jjava

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && mkdir -p /data

WORKDIR /data

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
