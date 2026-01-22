#!/bin/bash

# 1. 物理清理所有旧进程
pkill -9 nezha-agent
pkill -9 cloudflared
pkill -9 xray
pkill -9 node
sleep 2

# 2. 启动哪吒监控 (NK架构核心)
# 请确保你的 config.yml 就在根目录，且内容正确
if [ -f "config.yml" ]; then
    nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &
    echo "✅ 哪吒启动指令已发出"
fi
sleep 3

# 3. 启动 iOS 26 网页 (在 8080 端口)
nohup node server.js > web.log 2>&1 &
echo "✅ 网页服务已在 8080 启动"
sleep 2

# 4. 运行 Argosbx (它会自动通过 8001 端口打通隧道)
if [ -f "env.conf" ]; then
    source env.conf
    echo "✅ 已载入 env.conf 变量"
fi

# 这里的逻辑是 1 1 (即安装并运行)
bash argosbx.sh <<EOF
1
1
EOF

# 5. 订阅更新
sleep 5
bash argosbx.sh list | grep -E 'vless://|vmess://|trojan://' > sub.txt
echo "✅ 订阅已生成，所有任务完成"
