#!/bin/bash

# 1. 强杀旧进程，确保环境干净
pkill -9 nezha-agent
pkill -9 argosbx

# 2. 启动哪吒监控 (利用 config.yml)
nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &

# 3. 注入节点核心变量
export USER=root 
export agk="eyJhIjoiNDc4NmQyMjRkZTJkNmM2YTcwOWRkNTIwYjZhMzczOTMiLCJ0IjoiOWJlZmZiM2YtMTc2Mi00MGU0LWJhNDgtYjEyNTU4NjM0MjQxIiwicyI6Ik5qWXhNV1ZqTW1ZdE0yVTFOQzAwTTJNMExXSmhNbVF0TkRNeE5XTTRNMkZsT1dVdyJ9" 
export agn="idx.113.de5.net" 
export argo="vwpt" 
export vwpt="8001"

# 4. 强制运行脚本并生成节点
# 这里使用 <<EOF 模拟人工输入，自动选择 1 开启功能
bash argosbx.sh <<EOF
1
1
EOF

# 5. 【核心修改】提取节点链接到 sub.txt
# 运行 list 命令，过滤出 vless/vmess/trojan 开头的行并保存
bash argosbx.sh list | grep -E 'vless://|vmess://|trojan://' > sub.txt

# 6. 打印提示
echo "--------------------------------------"
echo "节点已自动同步至 sub.txt 文件"
echo "--------------------------------------"
