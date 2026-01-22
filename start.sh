#!/bin/bash

# 1. 自动架构下载哪吒 (保持 A 代码逻辑)
ARCH=$(uname -m)
[ "$ARCH" = "x86_64" ] && URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_amd64.zip" || URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_arm64.zip"

if [ ! -f "nezha-agent" ]; then
    wget -O nezha-agent.zip $URL && unzip -o nezha-agent.zip && chmod +x nezha-agent
    rm -f nezha-agent.zip
fi
pkill -9 nezha-agent
nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &

# 2. 调用变量文件并锁定工作目录
cd "$(dirname "$0")" # 确保脚本在哪个目录，就在哪个目录运行
if [ -f "env.conf" ]; then
    source env.conf
    echo "✅ 已载入变量配置"
fi

# 3. 核心：确保 index.html 存在并启动网页服务
pkill -9 python3
if [ -f "index.html" ]; then
    # 强制在包含 index.html 的当前目录启动
    nohup python3 -m http.server $fun_port > web.log 2>&1 &
    echo "✅ 监控网页 index.html 已调用，运行在 $fun_port 端口"
else
    echo "❌ 错误：当前目录未找到 index.html，网页无法正常显示！"
fi

# 4. 运行 argosbx 脚本逻辑
chmod +x argosbx.sh
bash argosbx.sh <<EOF
1
1
EOF

echo "🚀 双路由启动完毕"
echo "🌐 节点地址: $agn"
echo "🌐 网页地址: $fun_agn"
