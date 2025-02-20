FROM jlesage/baseimage-gui:ubuntu-18.04

RUN apt-get update && apt-get install -y wget libnss3 libgtk-3-0 libxss1 libasound2 libgbm1
RUN useradd --shell /sbin/nologin --home /app --uid 1000  -G users appuser
RUN mkdir /app && chown appuser -Rfv /app
USER appuser
RUN echo $USER
WORKDIR /app
RUN wget -O - https://raw.githubusercontent.com/CatalinGB/docker-MQTT-Explorer/master/MQTT-Explorer_install_and_update.sh >/app/install-MQTT-Explorer.sh && chmod +x /app/install-MQTT-Explorer.sh
RUN TERM=xterm /app/install-MQTT-Explorer.sh --allow-root --force
RUN /app/.MQTT-Explorer/MQTT-Explorer.AppImage --appimage-extract
ENV APPDIR=/app/squashfs-root
ADD startapp.sh /startapp.sh
USER root
ADD https://github.com/thomasnordquist/MQTT-Explorer/raw/master/icon.png /app/MQTT-Explorer-logo.png
RUN APP_ICON_URL=file:///app/MQTT-Explorer-logo.png && install_app_icon.sh "$APP_ICON_URL"
ENV APP_NAME="MQTT-Explorer"
