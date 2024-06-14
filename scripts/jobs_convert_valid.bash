#! /usr/bin/env bash

curl \
  -X POST \
  -H "Content-Type: application/json" \
  ${1}:4000/api/jobs/convert \
  -d "@./test/data/jobs_resolve_valid.json"
