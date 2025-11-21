#!/bin/bash

# Auto reload script for Flutter web development
# Watches for file changes and triggers hot reload automatically

WATCH_DIR="/Users/mertunluer/StudioProjects/mnr_petrol_web/lib"

echo "🔥 Auto Reload başlatıldı..."
echo "📁 İzlenen klasör: $WATCH_DIR"
echo "🔄 Kod değişikliklerini otomatik olarak algılayıp hot reload yapacak..."
echo ""

# Find the Flutter process PID
get_flutter_pid() {
    pgrep -f "flutter run" | head -1
}

# Send 'r' command to Flutter process
trigger_reload() {
    local PID=$(get_flutter_pid)
    if [ ! -z "$PID" ]; then
        echo "🔥 Hot Reload tetikleniyor..."
        # Send 'r' character to the Flutter process stdin
        echo "r" > /proc/$PID/fd/0 2>/dev/null || true
    fi
}

# Watch for file changes using fswatch (if installed) or basic loop
if command -v fswatch &> /dev/null; then
    echo "✅ fswatch kullanılıyor (önerilen)"
    fswatch -o "$WATCH_DIR" | while read; do
        echo "📝 Dosya değişikliği algılandı!"
        trigger_reload
    done
else
    echo "⚠️  fswatch bulunamadı, temel file watching kullanılıyor"
    echo "💡 Daha iyi performans için: brew install fswatch"
    echo ""
    
    # Basic file watching using stat
    LAST_MODIFIED=$(stat -f %m "$WATCH_DIR/main.dart" 2>/dev/null || echo "0")
    
    while true; do
        sleep 1
        CURRENT_MODIFIED=$(stat -f %m "$WATCH_DIR/main.dart" 2>/dev/null || echo "0")
        
        if [ "$CURRENT_MODIFIED" != "$LAST_MODIFIED" ]; then
            echo "📝 main.dart değişti!"
            trigger_reload
            LAST_MODIFIED=$CURRENT_MODIFIED
        fi
    done
fi

