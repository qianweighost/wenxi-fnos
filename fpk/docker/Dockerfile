FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    libgtk-3-0 \
    libayatana-appindicator3-1 \
    libsecret-1-0 \
    libnotify4 \
    gnome-keyring \
    dbus-x11 \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    fonts-noto-cjk \
    pulseaudio \
    mpv \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY bundle/ /app/bundle/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chmod +x /app/bundle/asterlink /app/bundle/asterlink_gopeed

ENV DISPLAY=:99
ENV ASTERLINK_JS_LIBRARY=/app/bundle/lib/libasterlink_js.so
ENV HOME=/config

EXPOSE 6080

ENTRYPOINT ["/entrypoint.sh"]
