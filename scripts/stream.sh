#!/bin/bash
set -e

CAMERA_NAME="${CAMERA_NAME:-CCTV Camera}"
RTSP_URL="${RTSP_URL:-rtsp://admin:password@192.168.123.106:554/Streaming/Channels/102}"
OUTPUT_DIR="${OUTPUT_DIR:-/streams/camera-2}"
VIDEO_CODEC="${VIDEO_CODEC:-libx264}"
PRESET="${PRESET:-ultrafast}"
BITRATE="${BITRATE:-1000k}"
HLS_TIME="${HLS_TIME:-2}"
HLS_LIST_SIZE="${HLS_LIST_SIZE:-5}"

mkdir -p "$OUTPUT_DIR"

echo "=========================================================="
echo "  CCTV HLS STREAMER STARTING"
echo "  Kamera       : $CAMERA_NAME"
echo "  RTSP Source  : $RTSP_URL"
echo "  Output Dir   : $OUTPUT_DIR"
echo "  Codec/Bitrate: $VIDEO_CODEC ($BITRATE)"
echo "=========================================================="

while true; do
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Memulai proses FFmpeg..."

    ffmpeg \
        -nostats \
        -loglevel warning \
        -rtsp_transport tcp \
        -rtsp_flags prefer_tcp \
        -i "$RTSP_URL" \
        -map 0:v:0 \
        -an \
        -c:v "$VIDEO_CODEC" \
        -preset "$PRESET" \
        -tune zerolatency \
        -b:v "$BITRATE" \
        -f hls \
        -hls_time "$HLS_TIME" \
        -hls_list_size "$HLS_LIST_SIZE" \
        -hls_delete_threshold 1 \
        -hls_flags delete_segments+append_list+independent_segments+omit_endlist \
        -hls_segment_filename "$OUTPUT_DIR/segment_%05d.ts" \
        "$OUTPUT_DIR/index.m3u8" || true

    EXIT_CODE=$?
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] FFmpeg terputus (exit code: $EXIT_CODE). Menghubungkan ulang dalam 3 detik..."
    sleep 3
done
