FROM ghcr.io/astral-sh/uv:python3.11-bookworm-slim

ARG GITHUB_TOKEN
ENV GITHUB_TOKEN=${GITHUB_TOKEN}

RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN uv sync --frozen --no-cache

CMD [ "uv", "run", "main.py" ]
