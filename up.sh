#!/bin/bash

# 1. 检查并下载哪吒客户端 (如果不存在)
if [ ! -f "nezha-agent" ]; then
    echo "正在下载哪吒客户端..."
    wget -O nezha-agent_linux_amd64.zip https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_amd64.zip
    unzip -o nezha-agent_linux_amd64.zip
    chmod +x nezha-agent
    rm nezha-agent_linux_amd64.zip
fi

# 2. 杀掉可能残余的进程
pkill -9 nezha-agent

# 3. 启动哪吒监控 (后台运行)
echo "正在启动哪吒..."
nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &

# 4. 启动节点脚本
echo "正在启动 Argo 节点..."
export USER=root agk="eyJhIjoiNDc4NmQyMjRkZTJkNmM2YTcwOWRkNTIwYjZhMzczOTMiLCJ0IjoiOWJlZmZiM2YtMTc2Mi00MGU0LWJhNDgtYjEyNTU4NjM0MjQxIiwicyI6Ik5qWXhNV1ZqTW1ZdE0yVTFOQzAwTTJNMExXSmhNbVF0TkRNeE5XTTRNMkZsT1dVdyJ9" agn="idx.113.de5.net" uuid="846afa77-bb60-4194-ba50-4d533da97756" argo="vwpt" vwpt="8001"
bash argosbx.sh
