#!/bin/bash
# Clean up Docker resources

set -e

echo "========================================="
echo "  Cleaning up Docker Resources"
echo "========================================="

read -p "Remove all stopped containers? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  docker container prune -f
  echo "✓ Removed stopped containers"
fi

read -p "Remove unused images? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  docker image prune -f
  echo "✓ Removed unused images"
fi

read -p "Remove unused volumes? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  docker volume prune -f
  echo "✓ Removed unused volumes"
fi

read -p "Remove unused networks? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  docker network prune -f
  echo "✓ Removed unused networks"
fi

echo ""
echo "Docker system status:"
docker system df
