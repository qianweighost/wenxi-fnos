#!/bin/bash
# 文析助手 fnOS 容器入口：Xvfb 虚拟显示 + VNC + noVNC 网页 + 应用本体
set -x

export DISPLAY=:99

mkdir -p /config /config/data

# 1. 虚拟显示
Xvfb :99 -screen 0 1440x900x24 -ac -nolisten tcp &
sleep 1

# 2. DBus（GTK 应用与 keyring 依赖）
if command -v dbus-launch >/dev/null 2>&1; then
  eval "$(dbus-launch --sh-syntax)" || true
fi

# 3. 解锁的 keyring（flutter_secure_storage 需要）
eval "$(echo -n 'asterlink-fnos' | gnome-keyring-daemon --unlock --replace 2>/dev/null)" || true
gnome-keyring-daemon --start --components=secrets >/dev/null 2>&1 || true

# 4. 音频（空输出，避免播放器因无音频后端报错）
pulseaudio --start --exit-idle-time=-1 2>/dev/null || \
  pulseaudio --start --exit-idle-time=-1 --load="module-null-sink sink_name=dummy" 2>/dev/null || true

# 5. VNC 服务
x11vnc -display :99 -forever -shared -nopass -rfbport 5900 -quiet -noxdamage &

# 6. 应用本体
cd /app/bundle
nohup ./asterlink >/config/app.log 2>&1 &

# 7. noVNC 网页入口（前台进程，保持容器存活）
exec websockify --web /usr/share/novnc/ 6080 localhost:5900
