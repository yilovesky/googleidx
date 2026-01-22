#!/bin/bash

# 1. 彻底清理
pkill -9 nezha-agent
pkill -9 cloudflared
pkill -9 xray
pkill -9 node
sleep 2

# 2. 启动哪吒 (使用 nohup 确保不挂掉)
# 请检查你的 config.yml 路径是否正确
if [ -f "config.yml" ]; then
    nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &
    echo "✅ 哪吒 Agent 启动指令已发出"
else
    echo "❌ 找不到 config.yml，哪吒无法启动"
fi
sleep 3

# 3. 启动 iOS 26 UI (在 8080 端口)
nohup node server.js > web.log 2>&1 &
echo "✅ iOS 26 UI 运行在 8080"
sleep 2

# 4. 加载变量并启动 Argosbx
# 这里 vwpt=8001，它会把 8001 给隧道
source env.conf
bash argosbx.sh <<EOF
1
1
EOF

# 5. 生成订阅
sleep 10
bash argosbx.sh list | grep -E 'vless://|vmess://|trojan://' > sub.txt
