#!/bin/bash
set -e

echo "=========================================================="
echo "  MEMULAI CCTV ALL-IN-ONE CONTAINER"
echo "=========================================================="

# Buat folder stream jika belum ada
mkdir -p /usr/share/nginx/html/camera-2 /usr/share/nginx/html/camera-1

# Jalankan Nginx di background
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Menjalankan Nginx di port 80..."
nginx

# Jalankan Streamer FFmpeg
export OUTPUT_DIR="/usr/share/nginx/html/camera-2"
exec /app/stream.sh
