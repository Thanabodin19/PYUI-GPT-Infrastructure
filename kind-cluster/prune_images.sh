#!/bin/bash

# ค้นหา CONTAINER ID ของ container ที่มีชื่อขึ้นต้นด้วย "pyui-gpt-"
CONTAINERS=$(docker ps --filter "name=pyui-gpt-" --format "{{.ID}}")

# ตรวจสอบว่ามี container ตรงกับเงื่อนไขหรือไม่
if [ -z "$CONTAINERS" ]; then
  echo "No containers found with name starting with 'pyui-gpt-'"
  exit 1
fi

# วนลูปเพื่อเข้าไป prune images ในทุก container
for CONTAINER in $CONTAINERS; do
  echo "Running image prune in container: $CONTAINER"
  docker exec -it "$CONTAINER" ctr -n k8s.io image prune --all
done

echo "Image pruning completed in all matching containers."
