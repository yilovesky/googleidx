#!/bin/bash

# 1. 自动识别架构并下载/更新哪吒 (监控保活)
ARCH=$(uname -m)
[ "$ARCH" = "x86_64" ] && URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_amd64.zip" || URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_arm64.zip"

if [ ! -f "nezha-agent" ]; then
    wget -O nezha-agent.zip $URL && unzip -o nezha-agent.zip && chmod +x nezha-agent
fi

# 2. 启动哪吒监控 (确保 config.yml 里的密钥是 client_secret)
pkill -9 nezha-agent
nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &

# 3. 注入核心变量（只留你必须固定的，让 UUID 自动生成）
export USER=root 
export agk="eyJhIjoiNDc4NmQyMjRkZTJkNmM2YTcwOWRkNTIwYjZhMzczOTMiLCJ0IjoiOWJlZmZiM2YtMTc2Mi00MGU0LWJhNDgtYjEyNTU4NjM0MjQxIiwicyI6Ik5qWXhNV1ZqTW1ZdE0yVTFOQzAwTTJNMExXSmhNbVF0TkRNeE5XTTRNMkZsT1dVdyJ9" 
export agn="idx.113.de5.net" 
export argo="vwpt" 
export vwpt="8001"

# 4. 运行主脚本 (它会因为找不到 UUID 变量而启动自带的自动生成逻辑)
bash argosbx.sh
