#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail

if [ -z "${ROC}" ]; then
  echo "ERROR: The ROC environment variable appears to not have been set set.
    It should point to the `roc` executable, e.g.:
        .../Downloads/roc_nightly-linux_x86_64-2023-10-30-cb00cfb/roc
        or
        .../roc/target/build/release/roc" >&2

  exit 1
fi

EXAMPLES_DIR='./examples'
PACKAGE_DIR='./package'

# Run checks
for ROC_FILE in $PACKAGE_DIR/*.roc; do
    $ROC check $ROC_FILE
done

# Run tests
$ROC test $PACKAGE_DIR/main.roc

# Test building docs
$ROC docs $PACKAGE_DIR/main.roc

