#!/bin/bash

# 1. 设置环境变量（必须在运行脚本前完成，脚本才能通过“未安装”检查）
export USER=root
export agk="eyJhIjoiNDc4NmQyMjRkZTJkNmM2YTcwOWRkNTIwYjZhMzczOTMiLCJ0IjoiOWJlZmZiM2YtMTc2Mi00MGU0LWJhNDgtYjEyNTU4NjM0MjQxIiwicyI6Ik5qWXhNV1ZqTW1ZdE0yVTFOQzAwTTJNMExXSmhNbVF0TkRNeE5XTTRNMkZsT1dVdyJ9"
export agn="idx.113.de5.net"
export argo="vwpt"
export vwpt="8001"

# 2. 启动哪吒监控（使用你最稳的方式）
pkill -9 nezha-agent
chmod +x nezha-agent
nohup ./nezha-agent -s nz.117.de5.net:443 -p p3joFK1jc3Z31YXqMXfNPvjjxx1lQknL --uuid ada9d899-a9d8-43ee-593b-308ac850fd3e --tls > nezha.log 2>&1 &
echo "✅ 哪吒已启动"

# 3. 启动保活 Python 服务器
pkill -9 python3
nohup python3 -m http.server 8001 > web.log 2>&1 &

# 4. 【核心步骤】运行 argosbx 脚本
# 我们先通过变量注入让它进入“自动模式”，然后输入 1 开启
pkill -9 argosbx
bash argosbx.sh <<EOF
1
1
EOF

# 5. 生成 sub.txt
sleep 10
bash argosbx.sh list | grep -E 'vless://|vmess://|trojan://' > sub.txt
echo "✅ 节点列表已同步到 sub.txt"
