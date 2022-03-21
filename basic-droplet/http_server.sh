#!/usr/bin/env bash
DROPLET_ID=$(curl http://169.254.169.254/metadata/v1/id)

mkdir -p app
echo "<!doctype html><html><head><meta charset=\"utf-8\"><title>Droplet</title></head><body><h1>Hello droplet ${DROPLET_ID}!</h1></body></html>" > app/index.html
cd app && python3 -m http.server 80