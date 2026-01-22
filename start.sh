#!/bin/bash

# 1. 强制清理旧进程
pkill -9 nezha-agent
pkill -9 python3
pkill -9 argosbx
sleep 1

# 2. 【核心】在这里注入所有变量，脚本才能通过“未安装”检查
export USER=root
export agk="eyJhIjoiNDc4NmQyMjRkZTJkNmM2YTcwOWRkNTIwYjZhMzczOTMiLCJ0IjoiOWJlZmZiM2YtMTc2Mi00MGU0LWJhNDgtYjEyNTU4NjM0MjQxIiwicyI6Ik5qWXhNV1ZqTW1ZdE0yVTFOQzAwTTJNMExXSmhNbVF0TkRNeE5XTTRNMkZsT1dVdyJ9"
export agn="idx.113.de5.net"
export argo="vwpt"
export vwpt="8001"

# 3. 启动保活 Web 服务
nohup python3 -m http.server 8001 > web.log 2>&1 &

# 4. 启动哪吒
nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &

# 5. 【关键】带着变量启动 argosbx，并自动选择 1 开启功能
# 这样它就不会提示“未安装”了
bash argosbx.sh <<EOF
1
1
EOF

# 6. 生成订阅
bash argosbx.sh list | grep -E 'vless://|vmess://|trojan://' > sub.txt
