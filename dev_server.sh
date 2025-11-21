#!/bin/bash

# Development server with auto-rebuild on file changes
# Her kod değişikliğinde otomatik build alır, sadece browser refresh yeterli!

PROJECT_DIR="/Users/mertunluer/StudioProjects/mnr_petrol_web"
WATCH_DIR="$PROJECT_DIR/lib"
BUILD_DIR="$PROJECT_DIR/build/web"
PORT=8080

cd "$PROJECT_DIR"

echo "🚀 MNR Petrol Web - Development Server"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📂 Proje: $PROJECT_DIR"
echo "👀 İzleniyor: $WATCH_DIR"
echo "🌐 Server: http://localhost:$PORT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# İlk build'i al
echo "🔨 İlk build alınıyor..."
flutter build web --release
echo "✅ Build tamamlandı!"
echo ""

# HTTP server'ı başlat (background)
echo "🌐 HTTP Server başlatılıyor..."
cd "$BUILD_DIR"
python3 -m http.server $PORT > /dev/null 2>&1 &
SERVER_PID=$!
cd "$PROJECT_DIR"
echo "✅ Server başladı: http://localhost:$PORT"
echo "   PID: $SERVER_PID"
echo ""

# Cleanup function
cleanup() {
    echo ""
    echo "🛑 Server durduruluyor..."
    kill $SERVER_PID 2>/dev/null
    echo "✅ Temizlik tamamlandı!"
    exit 0
}

trap cleanup SIGINT SIGTERM

# File watcher
echo "👀 Dosya değişiklikleri izleniyor..."
echo "💡 Kod değiştir → Kaydet → Browser'da F5"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

LAST_MODIFIED=0

while true; do
    # Check all dart files in lib directory
    CURRENT_MODIFIED=$(find "$WATCH_DIR" -name "*.dart" -type f -exec stat -f %m {} \; 2>/dev/null | sort -rn | head -1)
    
    if [ ! -z "$CURRENT_MODIFIED" ] && [ "$CURRENT_MODIFIED" != "$LAST_MODIFIED" ] && [ "$LAST_MODIFIED" != "0" ]; then
        echo "📝 [$(date '+%H:%M:%S')] Kod değişikliği algılandı!"
        echo "🔨 Build başlatılıyor..."
        
        if flutter build web --release 2>&1 | grep -q "Built build/web"; then
            echo "✅ [$(date '+%H:%M:%S')] Build başarılı! Browser'da F5 ile yenile."
        else
            echo "❌ [$(date '+%H:%M:%S')] Build hatası! Loglara bak."
        fi
        echo ""
    fi
    
    LAST_MODIFIED=$CURRENT_MODIFIED
    sleep 2
done

