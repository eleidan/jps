#! /usr/bin/env bash

curl \
  -X POST \
  -H "Content-Type: application/json" \
  ${1}:4000/api/jobs/resolve \
  -d "@test/data/jobs_resolve_invalid_with_task_duplication.json"
