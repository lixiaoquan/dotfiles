#!/usr/bin/env bash

title="$(git log -n 1 $1 --format="%s")"

id=$1

message() {
  echo "[Revert] \"$title\"" > tmp_message
  echo "" >> tmp_message
  echo "Project:DLI_SW" >> tmp_message
  echo "BugId:" >> tmp_message
  echo "Desc:" >> tmp_message
  echo "  This reverts commit $id" >> tmp_message
  echo "Tests:" >> tmp_message
}

message

git revert --no-commit $id
git commit -eF tmp_message
rm tmp_message
