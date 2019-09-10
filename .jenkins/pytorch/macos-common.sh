#!/bin/bash

# Common prelude for macos-build.sh and macos-test.sh

# shellcheck disable=SC2034
COMPACT_JOB_NAME="${BUILD_ENVIRONMENT}"

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
export PATH="/usr/local/bin:$PATH"
export WORKSPACE_DIR="${HOME}/workspace"
mkdir -p ${WORKSPACE_DIR}

# If a local installation of conda doesn't exist, we download and install conda
if [ ! -d "${WORKSPACE_DIR}/miniconda3" ]; then
  mkdir -p ${WORKSPACE_DIR}
  curl https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -o ${WORKSPACE_DIR}/miniconda3.sh
  bash ${WORKSPACE_DIR}/miniconda3.sh -b -p ${WORKSPACE_DIR}/miniconda3
fi
export PATH="${WORKSPACE_DIR}/miniconda3/bin:$PATH"
source ${WORKSPACE_DIR}/miniconda3/bin/activate
conda install -y mkl mkl-include numpy pyyaml setuptools cmake cffi ninja

# Building with USE_DISTRIBUTED=1 requires libuv (for Gloo).
conda install -y libuv pkg-config

# Image commit tag is used to persist the build from the build job
# and to retrieve the build from the test job.
export IMAGE_COMMIT_TAG=${BUILD_ENVIRONMENT}-${IMAGE_COMMIT_ID}
