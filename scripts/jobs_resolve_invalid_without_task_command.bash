#! /usr/bin/env bash

curl \
  -X POST \
  -H "Content-Type: application/json" \
  ${1:-localhost}:4000/api/jobs/resolve \
  -d "@test/data/jobs_resolve_invalid_without_task_command.json"
