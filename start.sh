#!/bin/bash

# 1. 自动识别架构并下载/更新哪吒
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_amd64.zip"
else
    URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_arm64.zip"
fi

if [ ! -f "nezha-agent" ]; then
    echo "正在根据架构 ($ARCH) 下载哪吒 Agent..."
    wget -O nezha-agent.zip $URL && unzip -o nezha-agent.zip && chmod +x nezha-agent
    rm -f nezha-agent.zip
fi

# 2. 启动哪吒监控 (读取 config.yml)
pkill -9 nezha-agent
nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &
echo "✅ 哪吒已通过 config.yml 启动"

# 3. 加载变量并启动节点
if [ -f "env.conf" ]; then
    source env.conf
    echo "✅ 已载入 env.conf 变量"
fi

# 启动保活 Web
pkill -9 python3
nohup python3 -m http.server 8001 > web.log 2>&1 &

# 交互式模式启动：因为已 source 变量，脚本会直接跳过报错进入安装逻辑
bash argosbx.sh <<EOF
1
1
EOF

# 4. 自动更新 sub.txt 方便查看
sleep 10
bash argosbx.sh list | grep -E 'vless://|vmess://|trojan://' > sub.txt
echo "✅ 订阅文件已更新"
