# Python Semantic Release - Upload to GitHub Release Action

This GitHub Action runs `semantic-release publish` using
[`python-semantic-release`](https://github.com/python-semantic-release/python-semantic-release).
Full documentation is available in the
[documentation](https://python-semantic-release.readthedocs.io/en/latest/) for Python
Semantic Release.

> **WARNING**: This Action is intended to be used in conjunction with Python
> Semantic Release configuration of the same version! Using this Action with
> a different version of Python Semantic Release may result in unexpected errors.

## Example usage

```yaml
name: CI/CD

on:
  push:
    branches:
      - main

jobs:
  release:
    runs-on: ubuntu-latest
    concurrency: release

    permissions:
      id-token: write

    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Python Semantic Release
        id: release
        uses: python-semantic-release/python-semantic-release@v9.7.3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          # <other options here>

      - name: Publish package to PyPI
        uses: pypa/gh-action-pypi-publish@v1
        if: ${{ steps.release.outputs.released }} == 'true'

      - name: Publish package to GitHub Release
        uses: python-semantic-release/upload-to-gh-release@v9.7.3
        if: ${{ steps.release.outputs.released }} == 'true'
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          tag: ${{ steps.release.outputs.tag }}
```

## Options

See [action.yml](./action.yml) for a description of the available options.
