#!/usr/bin/env python3

from pathlib import Path
from re import compile as RegExp
from os import getenv

PROJ_DIR = Path(__file__).resolve().parent.parent
README_FILE = PROJ_DIR / "README.md"

psr_regex = RegExp(r"(uses:.*python-semantic-release)@v\d+\.\d+\.\d+")
uploader_action_regex = RegExp(r"(uses:.*upload-to-gh-release)@v\d+\.\d+\.\d+")
new_version = getenv("NEW_VERSION")

if not new_version:
    print("NEW_VERSION environment variable is not set")
    exit(1)

readme_lines = README_FILE.read_text().splitlines()

for regex in [psr_regex, uploader_action_regex]:
    readme_lines = list(map(
        lambda line, regex=regex: regex.sub(r'\1@v'+new_version, line),
        readme_lines
    ))

print("Bumping version in readme to", new_version)
README_FILE.write_text(str.join("\n", readme_lines) + '\n')
