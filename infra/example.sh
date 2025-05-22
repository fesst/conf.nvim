#!/bin/bash

git checkout -b my-branch && git add . && git commit -m "${1}" && git push -u origin my-branch && gh pr create --fill
