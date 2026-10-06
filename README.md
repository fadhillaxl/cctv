# CCTV HLS Live Stream (Docker Setup)

Sistem streaming CCTV berbasis HLS (HTTP Live Streaming) dengan dashboard web modern dan auto-reconnect FFmpeg.

## Struktur Project

```text
├── docker-compose.yml       # Konfigurasi multi-container (Nginx + FFmpeg)
├── Dockerfile               # All-in-one image (Nginx + FFmpeg dalam 1 container)
├── Dockerfile.streamer      # Image ringan untuk FFmpeg streamer service
├── .env                     # File konfigurasi IP kamera & port
├── index.html               # Web Dashboard CCTV Surveillance
├── camera-2/                # Folder output stream Kamera 2 & standalone player
├── nginx/
│   └── nginx.conf           # Konfigurasi Nginx optimal untuk HLS & CORS
└── scripts/
    ├── stream.sh            # Script loop FFmpeg dengan auto-reconnect
    └── entrypoint-allinone.sh
```

---

## Cara Menjalankan dengan Docker Compose (Direkomendasikan)

### 1. Sesuaikan Konfigurasi di `.env`
Buka file `.env` dan pastikan URL RTSP kamera Anda sudah sesuai:
```env
PORT=8000
RTSP_URL_CAM1=rtsp://admin:password@192.168.123.107:554/Streaming/Channels/102
RTSP_URL_CAM2=rtsp://admin:password@192.168.123.106:554/Streaming/Channels/102
```

### 2. Jalankan Container
```bash
docker compose up -d
```

### 3. Cek Status & Log
- Melihat status container:
  ```bash
  docker compose ps
  ```
- Melihat log live streaming FFmpeg:
  ```bash
  docker compose logs -f stream-cam2
  ```

### 4. Buka di Browser
- **Dashboard Utama:** `http://IP_SERVER:8000`
- **Player Kamera 2:** `http://IP_SERVER:8000/camera-2/`

### 5. Menghentikan Container
```bash
docker compose down
```

---

## Opsi: Menjalankan Single Container (All-in-One)

Jika ingin build 1 image mandiri tanpa docker-compose:
```bash
# Build image
docker build -t cctv-allinone .

# Jalankan container
docker run -d \
  --name cctv-live \
  -p 8000:80 \
  -e RTSP_URL="rtsp://admin:password@192.168.123.106:554/Streaming/Channels/102" \
  --restart unless-stopped \
  cctv-allinone
```
