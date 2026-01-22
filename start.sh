#!/bin/bash

# 1. 环境清理：清理所有可能冲突的进程
pkill -9 nezha-agent
pkill -9 cloudflared
pkill -9 xray
pkill -9 node
sleep 2

# 2. 启动 iOS 26 UI (Node.js 监听 8001)
nohup node server.js > web.log 2>&1 &
echo "✅ iOS 26 UI 已在 8001 端口启动"
sleep 3

# 3. 启动哪吒监控 (保持原逻辑)
# 确保 config.yml 已在根目录
nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &
echo "✅ 哪吒 Agent 已启动"
sleep 3

# 4. 载入变量并运行 argosbx (仅启用 Xray 逻辑)
if [ -f "env.conf" ]; then
    source env.conf
    echo "✅ 已载入 env.conf 变量"
fi

# 这里的逻辑是确保 8001 被 argo 映射，同时让 xray 跑起来
bash argosbx.sh <<EOF
1
1
EOF

# 5. 生成订阅 (保持原样)
sleep 5
bash argosbx.sh list | grep -E 'vless://|vmess://|trojan://' > sub.txt
echo "✅ 订阅文件已同步"
