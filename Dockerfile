FROM python:3.12-slim-bookworm
ARG WORK_DIR="/opt/semantic-release"

WORKDIR ${WORK_DIR}

COPY . ./

RUN \
    # Install required os packages
    apt update && apt install -y --no-install-recommends \
        git git-lfs \
    # Fix shell profile to load PATH with user python bin
    && mv /etc/skel/.profile /root/.profile \
    # Update local pip and built tools
    && pip install --upgrade --user --no-cache-dir pip setuptools wheel \
    # Install semantic-release (/root/.local/bin)
    && pip install --pre --user --no-cache-dir -r requirements.txt \
    # Validate binary availability
    && bash -lc 'semantic-release --help' \
    # put action script on PATH as entrypoint
    && ln -s "${WORK_DIR}/action.sh" /root/.local/bin/action-entrypoint \
    # Clean up
    && apt clean && rm -rf /var/lib/apt/lists/* \
    && find /tmp -mindepth 1 -delete

ENTRYPOINT ["bash", "-l", "action-entrypoint"]
