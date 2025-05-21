FROM ghcr.io/astral-sh/uv:python3.11-bookworm-slim AS builder

ARG GH_PAT
ENV GH_PAT=${GH_PAT}

RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

RUN git config --global url."https://${GH_PAT}:x-oauth-basic@github.com/".insteadOf "https://github.com/"

RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --locked --no-install-project --no-editable

WORKDIR /app

ADD . /app

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --no-editable

FROM ghcr.io/astral-sh/uv:python3.11-bookworm-slim AS runtime

WORKDIR /app

COPY --from=builder --chown=app:app /app /app

CMD [ "uv", "run", "main.py" ]
