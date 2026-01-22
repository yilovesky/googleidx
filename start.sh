#!/bin/bash

# 1. 环境大扫除：杀掉所有可能占用端口的进程（哪吒、Python、Argo）
pkill -9 nezha-agent
pkill -9 python3
pkill -9 argosbx
sleep 2  # 等待 2 秒确保端口释放

# 2. 启动哪吒监控
nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &

# 3. 注入核心变量
export USER=root 
export agk="eyJhIjoiNDc4NmQyMjRkZTJkNmM2YTcwOWRkNTIwYjZhMzczOTMiLCJ0IjoiOWJlZmZiM2YtMTc2Mi00MGU0LWJhNDgtYjEyNTU4NjM0MjQxIiwicyI6Ik5qWXhNV1ZqTW1ZdE0yVTFOQzAwTTJNMExXSmhNbVF0TkRNeE5XTTRNMkZsT1dVdyJ9" 
export agn="idx.113.de5.net" 
export argo="vwpt" 
export vwpt="8001"

# 4. 启动 Python 保活服务器 (放在后台，占住 8001)
nohup python3 -m http.server 8001 > web.log 2>&1 &
sleep 2

# 5. 运行 argosbx.sh 生成节点 (自动选择 1 开启功能)
bash argosbx.sh <<EOF
1
1
EOF

# 6. 提取节点到 sub.txt
bash argosbx.sh list | grep -E 'vless://|vmess://|trojan://' > sub.txt
echo "--------------------------------------"
echo "✅ 环境已就绪，节点已写入 sub.txt"
echo "--------------------------------------"
