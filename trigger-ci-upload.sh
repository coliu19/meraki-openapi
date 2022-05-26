#! /bin/bash
set -ex

tag=v0.0-default
if [ -n "$1" ]; then
  tag="$1"
fi

git push origin --delete "$tag" || true
git tag -d "$tag" || true
git tag "$tag"
git push origin "$tag"
