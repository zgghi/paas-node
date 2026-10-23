FROM alpine:3.24.2
RUN apk add --no-cache curl unzip ca-certificates && cd /tmp && curl -fsSL -o xray.zip https://github.com/XTLS/Xray-core/releases/download/v26.2.6/Xray-linux-64.zip && unzip -o xray.zip >/dev/null && chmod +x xray && rm xray.zip
COPY start.sh /start.sh
RUN chmod +x /start.sh
EXPOSE 8080
CMD ["/start.sh"]
