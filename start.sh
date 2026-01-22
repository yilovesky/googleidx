#!/bin/bash

# [cite_start]1. 自动架构下载哪吒 (保持 A 代码逻辑 [cite: 1, 4])
ARCH=$(uname -m)
[ "$ARCH" = "x86_64" ] && URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_amd64.zip" || URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_arm64.zip"

if [ ! -f "nezha-agent" ]; then
    wget -O nezha-agent.zip $URL && unzip -o nezha-agent.zip && chmod +x nezha-agent
    rm -f nezha-agent.zip
fi

# 启动哪吒
pkill -9 nezha-agent
nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &

# 2. 启动监控网页 (端口 8003)
pkill -9 python3
# [cite_start]确保 index.html 存在 [cite: 4]
nohup python3 -m http.server 8003 > web.log 2>&1 &
echo "✅ iOS 监控页运行在 8003 端口"

# [cite_start]3. 统一变量配置 (覆盖原有 env.conf 的 ARGO 信息 [cite: 1])
export vwpt="8001"
export agn="idxus.113.de5.net" 
export agk="eyJhIjoiNDc4NmQyMjRkZTJkNmM2YTcwOWRkNTIwYjZhMzczOTMiLCJ0IjoiOWJlZmZiM2YtMTc2Mi00MGU0LWJhNDgtYjEyNTU4NjM0MjQxIiwicyI6Ik5qWXhNV1ZqTW1ZdE0yVTFOQzAwTTJNMExXSmhNbVF0TkRNeE5XTTRNMkZsT1dVdyJ9"
export argo="vwpt"
export USER=root

export fun="funus.113.de5.net"

# 4. 运行 argosbx 脚本逻辑
chmod +x argosbx.sh
bash argosbx.sh <<EOF
1
1
EOF

echo "🚀 双路由启动完毕"
echo "🌐 节点地址: $agn"
echo "🌐 网页地址: $fun"
