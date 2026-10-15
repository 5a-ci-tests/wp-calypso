#!/usr/bin/env bash

set -euo pipefail

# The workspace is a mounted volume; Yarn's global cache lives on another filesystem.
export USE_HARD_LINKS=false
export COREPACK_ENABLE_DOWNLOAD_PROMPT=0
# Root postinstall compiles workspace packages. This step only fetches dependencies.
export SKIP_CALYPSO_POSTINSTALL=true

corepack enable
corepack prepare yarn@4.0.2 --activate

yarn install --immutable --inline-builds
