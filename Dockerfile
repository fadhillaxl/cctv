FROM alpine:3.20

# Install Nginx, FFmpeg, bash, tzdata
RUN apk add --no-cache nginx ffmpeg bash ca-certificates tzdata

ENV TZ=Asia/Jakarta

WORKDIR /app

# Salin konfigurasi Nginx dan file website
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY index.html /usr/share/nginx/html/index.html
COPY camera-2/index.html /usr/share/nginx/html/camera-2/index.html

# Salin scripts
COPY scripts/stream.sh /app/stream.sh
COPY scripts/entrypoint-allinone.sh /app/entrypoint.sh
RUN chmod +x /app/stream.sh /app/entrypoint.sh

# Expose web port
EXPOSE 80

ENTRYPOINT ["/app/entrypoint.sh"]
