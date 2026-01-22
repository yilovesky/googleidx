#!/bin/bash

# 1. 自动识别架构并下载正确的哪吒客户端
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    DOWNLOAD_URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_amd64.zip"
elif [ "$ARCH" = "aarch64" ]; then
    DOWNLOAD_URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_arm64.zip"
fi

# 2. 如果文件不存在或架构不对，重新下载
if [ ! -f "nezha-agent" ] || [ "$1" = "force" ]; then
    echo "正在为 $ARCH 架构下载正确的哪吒客户端..."
    wget -O nezha-agent.zip $DOWNLOAD_URL
    unzip -o nezha-agent.zip
    chmod +x nezha-agent
    rm nezha-agent.zip
fi

# 3. 杀掉旧进程并启动
pkill -9 nezha-agent
echo "正在启动哪吒监控..."
nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &

# 4. 启动节点脚本
echo "正在启动 Argo 节点..."
export USER=root agk="eyJhIjoiNDc4NmQyMjRkZTJkNmM2YTcwOWRkNTIwYjZhMzczOTMiLCJ0IjoiOWJlZmZiM2YtMTc2Mi00MGU0LWJhNDgtYjEyNTU4NjM0MjQxIiwicyI6Ik5qWXhNV1ZqTW1ZdE0yVTFOQzAwTTJNMExXSmhNbVF0TkRNeE5XTTRNMkZsT1dVdyJ9" agn="idx.113.de5.net" uuid="846afa77-bb60-4194-ba50-4d533da97756" argo="vwpt" vwpt="8001"
bash argosbx.sh
