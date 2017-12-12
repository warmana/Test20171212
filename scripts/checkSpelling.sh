#!/bin/bash

MARKDOWN_FILES_CHANGED=`(git diff --name-only $TRAVIS_COMMIT_RANGE || true) | grep .md`

echo "Running spelling check for files:"
echo $MARKDOWN_FILES_CHANGED