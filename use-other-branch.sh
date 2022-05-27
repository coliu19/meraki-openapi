#! /bin/bash
set -x

git branch -D demo
git push origin --delete demo
git checkout -b demo
git push --set-upstream origin demo
