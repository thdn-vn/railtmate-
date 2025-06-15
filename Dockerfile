FROM ubuntu:22.04

# Cài các phụ thuộc
RUN apt update && \
    apt install -y software-properties-common wget curl git openssh-client tmate python3 && \
    apt clean

# Tạo thư mục ứng dụng
RUN mkdir -p /app
WORKDIR /app

# Tạo script khởi động tmate + web server
RUN echo '#!/bin/bash\n\
set -e\n\
echo "Starting HTTP server..."\n\
python3 -m http.server 8080 &\n\
\n\
echo "Starting tmate..."\n\
tmate -S /app/tmate.sock new-session -d\n\
sleep 3\n\
tmate -S /app/tmate.sock wait tmate-ready\n\
tmate -S /app/tmate.sock display -p "🔐 SSH: #{tmate_ssh}"\n\
tmate -S /app/tmate.sock display -p "🌐 Web: #{tmate_web}"\n\
\n\
# Giữ container sống mãi mãi\n\
tail -f /dev/null' > /app/start.sh

RUN chmod +x /app/start.sh

# Mở port giả để Railway giữ container sống
EXPOSE 8080

# Chạy script khởi động
CMD ["/app/start.sh"]
