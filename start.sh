#!/bin/bash

# 1. 物理清理（防止重启时进程冲突）
pkill -9 nezha-agent
pkill -9 cloudflared
pkill -9 xray
pkill -9 python3
sleep 2

# 2. 哪吒监控：下载并启动
ARCH=$(uname -m)
[ "$ARCH" = "x86_64" ] && URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_amd64.zip" || URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_arm64.zip"

if [ ! -f "nezha-agent" ]; then
    wget -O nezha-agent.zip $URL && unzip -o nezha-agent.zip && chmod +x nezha-agent
    rm -f nezha-agent.zip
fi

# 使用你的 config.yml 启动
nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &
echo "✅ 哪吒 Agent 已启动"

# 3. 保活网页：使用 8080 端口，避开 8001
nohup python3 -m http.server 8080 > web.log 2>&1 &
echo "✅ 保活服务器运行在 8080 端口"

# 4. 加载变量并运行 Argosbx (使用 8001 固定隧道)
if [ -f "env.conf" ]; then
    source env.conf
    echo "✅ 已载入 env.conf 变量"
fi

# 交互式执行 argosbx 自动化安装
bash argosbx.sh <<EOF
1
1
EOF

# 5. 防止脚本退出导致进程被杀
echo "🚀 所有服务已部署，请通过固定域名访问。"
tail -f /dev/null
