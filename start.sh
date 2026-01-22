#!/bin/bash

# 1. 载入变量
[ -f "env.conf" ] && source env.conf

# 2. 哪吒启动 (读取 config.yml)
pkill -9 nezha-agent
chmod +x nezha-agent
nohup ./nezha-agent -c config.yml > /dev/null 2>&1 &

# 3. 启动保活 Web
pkill -9 python3
nohup python3 -m http.server 8001 > /dev/null 2>&1 &

# 4. 运行 argosbx (此时因为它已经 source 了 env.conf，变量已在内存)
# 脚本会检测到 vwpt="8001"，从而自动开始安装，不再提示“未安装”
bash argosbx.sh
