#!/bin/bash

# 1. 自动架构下载哪吒 (保持 A 代码逻辑)
ARCH=$(uname -m)
[ "$ARCH" = "x86_64" ] && URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_amd64.zip" || URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_arm64.zip"

if [ ! -f "nezha-agent" ]; then
    wget -O nezha-agent.zip $URL && unzip -o nezha-agent.zip && chmod +x nezha-agent
    rm -f nezha-agent.zip
fi
pkill -9 nezha-agent
nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &

# 2. 启动监控网页 (端口 8003)
pkill -9 python3
nohup python3 -m http.server 8003 > web.log 2>&1 &
echo "✅ iOS 监控页运行在 8003 端口"

# 3. 统一变量配置 (必须包含 vmag)
export vwpt="8001"
export agn="idxtw.113.de5.net" 
export agk="eyJhIjoiNDc4NmQyMjRkZTJkNmM2YTcwOWRkNTIwYjZhMzczOTMiLCJ0IjoiOWJlZmZiM2YtMTc2Mi00MGU0LWJhNDgtYjEyNTU4NjM0MjQxIiwicyI6Ik5qWXhNV1ZqTW1ZdE0yVTFOQzAwTTJNMExXSmhNbVF0TkRNeE5XTTRNMkZsT1dVdyJ9"
export argo="vwpt"
export vmag="yes"
export USER=root
export fun="funtw.113.de5.net"

# 4. 运行 argosbx 逻辑
chmod +x argosbx.sh
# 【核心修正】：先执行 rep 命令清理旧的配置标记，强制重新识别变量
bash argosbx.sh rep <<EOF
1
1
EOF

echo "🚀 双路由启动完毕"
echo "🌐 节点地址: $agn"
echo "🌐 网页地址: $fun"
