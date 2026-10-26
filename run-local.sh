#!/usr/bin/env bash
# 本地签到运行脚本
# 用法：
#   ./run-local.sh          # 执行签到
#   crontab -e 添加一行可在每天定时运行：
#   0 12 * * * cd /root/Glados-Railgun-checkin && ./run-local.sh >> /root/glados-checkin.log 2>&1
set -euo pipefail

cd "$(dirname "$0")"

if [ ! -f .env ]; then
  echo "未找到 .env 文件，请先复制 .env.example 为 .env 并填入 Cookie" >&2
  exit 1
fi

set -a
# shellcheck disable=SC1091
source .env
set +a

exec python3 checkin.py
