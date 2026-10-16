#!/usr/bin/env bash

set -euo pipefail

# The workspace is a mounted volume; Yarn's global cache lives on another filesystem.
export USE_HARD_LINKS=false
# Skip runtime binaries (Playwright browsers, Electron, and sentry-cli). The npm packages still install.
export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
export ELECTRON_SKIP_BINARY_DOWNLOAD=1
export SENTRYCLI_SKIP_DOWNLOAD=1
# Root postinstall compiles workspace packages. This step only fetches dependencies.
export SKIP_CALYPSO_POSTINSTALL=true
# node-gyp uses the headers shipped in the Node image instead of downloading them.
if [[ ! -f /usr/local/include/node/node.h ]]; then
	echo "Node headers were not found at /usr/local/include/node." >&2
	exit 1
fi
export npm_config_nodedir=/usr/local

# Persistent directory already mounted into the agent. Subdirectory keeps this
# cache separate from anything else stored on that volume.
export YARN_CACHE_FOLDER=/var/cache/buildkite/yarn
mkdir -p "$YARN_CACHE_FOLDER"

# Checked-in Yarn 4.0.2. The Node image only ships Yarn 1.22.
echo "--- :yarn: Installing dependencies..."
.yarn/releases/yarn-4.0.2.cjs install --immutable --inline-builds
