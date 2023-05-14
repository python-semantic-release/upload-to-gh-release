# Python Semantic Release - Upload to GitHub Release Action

This GitHub Action runs `semantic-release publish` using
[`python-semantic-release`](https://github.com/python-semantic-release/python-semantic-release).
Full documentation is available in the [documentation](https://python-semantic-release.readthedocs.io/en/latest/)
for Python Semantic Release.

**NOTE**: This Action is compatible only with Python Semantic Release v8 or higher.

## Example usage

```yaml
---
name: CI

on:
  push:
    branches:
      - main

jobs:
  release:
    runs-on: ubuntu-latest
    concurrency: release

    # NOTE: this enables trusted publishing.
    # See https://github.com/pypa/gh-action-pypi-publish/tree/release/v1#trusted-publishing
    # and https://blog.pypi.org/posts/2023-04-20-introducing-trusted-publishers/
    permissions:
      id-token: write

    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0

      - name: Python Semantic Release
        uses: python-semantic-release/python-semantic-release@v8.0.x
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          # <other options here>

      - name: Publish package to PyPI
        uses: pypa/gh-action-pypi-publish@release/v1

      - name: Publish package to GitHub Release
        uses: python-semantic-release/upload-to-gh-release@main
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

## Options

See [action.yml](./action.yml) for a description of the available options.
