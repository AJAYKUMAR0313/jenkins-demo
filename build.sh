#!/bin/bash
echo "=== Jenkins Build ==="
echo "Commit : $GIT_COMMIT"
echo "Branch : $GIT_BRANCH"
echo "Build  : $BUILD_NUMBER"
echo "Date   : $(date)"
echo "Files in repo:"
ls -la
echo "=== Done ==="
