ARG PYTHON_VERSION=3.10

FROM python:${PYTHON_VERSION}

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    git-lfs

#install backported stable vesion of git, which supports ssh signing
RUN echo "deb http://deb.debian.org/debian bullseye-backports main" >> /etc/apt/sources.list; \
    apt-get update;\
    apt-get install -y git/bullseye-backports \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*; \
    mkdir /semantic-release

WORKDIR /semantic-release

COPY action.sh /semantic-release/action.sh

RUN pip install --pre --no-cache-dir "python-semantic-release<9"; \
    semantic-release --help

ENTRYPOINT ["/semantic-release/action.sh"]
