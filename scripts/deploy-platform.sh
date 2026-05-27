#!/bin/bash

set -e

echo "======================================="
echo "BVR PLATFORM DEPLOYMENT"
echo "======================================="

echo ""
echo "[1/6] Building frontend..."

cd ~/bvr-infra-platform

npm run build

echo ""
echo "[2/6] Cleaning nginx root..."

sudo rm -rf /var/www/platform/*

echo ""
echo "[3/6] Copying frontend build..."

sudo cp -r dist/* /var/www/platform/

echo ""
echo "[4/6] Restarting nginx..."

sudo systemctl restart nginx

echo ""
echo "[5/6] Verifying deployed bundle..."

curl -s https://platform.bvrinfra.in | grep assets

echo ""
echo "[6/6] Deployment completed successfully."

echo ""
echo "======================================="
