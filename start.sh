#!/bin/bash

# 1. 强力清理环境
pkill -9 nezha-agent
pkill -9 python3
pkill -9 argosbx
sleep 2

# 2. 智能启动哪吒 (如果有文件就直接跑，没文件才下载)
if [ ! -f "nezha-agent" ]; then
    echo "正在下载哪吒 Agent..."
    ARCH=$(uname -m)
    [ "$ARCH" = "x86_64" ] && URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_amd64.zip" || URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_arm64.zip"
    wget -O nezha-agent.zip $URL && unzip -o nezha-agent.zip && chmod +x nezha-agent
fi

# 启动哪吒
nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &
echo "✅ 哪吒已启动"

# 3. 注入核心变量
export USER=root
export agk="eyJhIjoiNDc4NmQyMjRkZTJkNmM2YTcwOWRkNTIwYjZhMzczOTMiLCJ0IjoiOWJlZmZiM2YtMTc2Mi00MGU0LWJhNDgtYjEyNTU4NjM0MjQxIiwicyI6Ik5qWXhNV1ZqTW1ZdE0yVTFOQzAwTTJNMExXSmhNbVF0TkRNeE5XTTRNMkZsT1dVdyJ9"
export agn="idx.113.de5.net"
export argo="vwpt"
export vwpt="8001"

# 4. 启动 Python 保活服务 (占住 8001 端口)
nohup python3 -m http.server 8001 > web.log 2>&1 &
sleep 2

# 5. 强制安装并拉起节点进程
# 使用 <<EOF 自动点击“1”开启功能
bash argosbx.sh <<EOF
1
1
EOF

# 6. 生成订阅 sub.txt
sleep 5
bash argosbx.sh list | grep -E 'vless://|vmess://|trojan://' > sub.txt
echo "✅ 节点已生成到 sub.txt"
