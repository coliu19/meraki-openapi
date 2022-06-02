#! /bin/bash
set -ex

cp v0.1-rev2/catalogue.json openapi/
# git diff
git --no-pager diff

git add openapi/catalogue.json
git commit -m "fix catalogue api" || true
git push

./trigger-ci-upload.sh v0.1-2
