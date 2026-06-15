FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive \
    JUPYTER_ROOT_DIR=/data

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    curl \
    git \
    openjdk-21-jdk \
    tini \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

RUN curl -Ls https://sh.jbang.dev | bash -s - app setup
ENV PATH="/root/.jbang/bin:${PATH}"

RUN jbang trust add https://github.com/jupyter-java \
    && jbang install-kernel@jupyter-java jjava

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh && mkdir -p /data

WORKDIR /data

ENTRYPOINT ["/usr/bin/tini", "-g", "--", "/app/entrypoint.sh"]
