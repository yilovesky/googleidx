#!/bin/bash

# 1. 自动架构下载哪吒 (保持 A 代码逻辑)
ARCH=$(uname -m)
[ "$ARCH" = "x86_64" ] && URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_amd64.zip" || URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_arm64.zip"

if [ ! -f "nezha-agent" ]; then
    wget -O nezha-agent.zip $URL && unzip -o nezha-agent.zip && chmod +x nezha-agent
    rm -f nezha-agent.zip
fi

# 启动哪吒
pkill -9 nezha-agent
nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &

# 2. 锁定目录并强制导出变量
cd "$(dirname "$0")"
if [ -f "env.conf" ]; then
    # 强制 source 并导出
    set -a # 开启自动导出所有变量
    source env.conf
    set +a
    echo "✅ 变量已强制注入环境"
fi

# 3. 启动监控网页并显式调用 index.html
pkill -9 python3
if [ -f "index.html" ]; then
    # 确保在 8003 端口提供网页服务
    nohup python3 -m http.server "$fun_port" > web.log 2>&1 &
    echo "✅ 网页 index.html 已调用，端口: $fun_port"
else
    echo "❌ 警告：当前目录下未找到 index.html"
fi

# 4. 运行 argosbx 逻辑 (确保识别到 agk 和 agn)
chmod +x argosbx.sh
bash argosbx.sh <<EOF
1
1
EOF

echo "🚀 双路由强制启动完毕"
echo "🌐 节点地址: $agn"
echo "🌐 网页地址: $fun_agn"
