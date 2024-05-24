FROM python:3.12-slim-bookworm
ARG WORK_DIR="/opt/psr"

WORKDIR ${WORK_DIR}

ENV PSR_VENV_BIN="${WORK_DIR}/.venv/bin"

COPY . ./

RUN \
    # Install required os packages
    apt update && apt install -y --no-install-recommends \
        git git-lfs python3-venv \
    # Create virtual environment
    && python3 -m venv "$(dirname "${PSR_VENV_BIN}")" \
    # Update local pip and built tools
    && "${PSR_VENV_BIN}/pip" install --upgrade --no-cache-dir pip setuptools wheel \
    # Install semantic-release (/root/.local/bin)
    && "${PSR_VENV_BIN}/pip" install --pre --no-cache-dir -r requirements.txt \
    # Validate binary availability
    && bash -c "${PSR_VENV_BIN}/semantic-release --help" \
    # make action script executable
    && chmod +x "${WORK_DIR}/action.sh" \
    # Put action script in PATH
    && ln -s "${WORK_DIR}/action.sh" /usr/local/bin/action-entrypoint \
    # Clean up
    && apt clean && rm -rf /var/lib/apt/lists/* \
    && find /tmp -mindepth 1 -delete

ENTRYPOINT ["/usr/local/bin/action-entrypoint"]
