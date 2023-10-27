#!/bin/bash

set -euo pipefail

docker build --platform linux/amd64 -t dotfiles .
docker run --platform linux/amd64 --mount type=bind,source="$(pwd)",target=/dotfiles --rm -it dotfiles:latest bash
