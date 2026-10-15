#!/usr/bin/env bash

set -euo pipefail

# The workspace is a mounted volume; Yarn's global cache lives on another filesystem.
export USE_HARD_LINKS=false
# Root postinstall compiles workspace packages. This step only fetches dependencies.
export SKIP_CALYPSO_POSTINSTALL=true

# Checked-in Yarn 4.0.2. The Node image only ships Yarn 1.22.
.yarn/releases/yarn-4.0.2.cjs install --immutable --inline-builds
