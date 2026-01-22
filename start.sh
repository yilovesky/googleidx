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

# 2. 核心：调用外部变量文件
# 确保在脚本所在目录执行
cd "$(dirname "$0")"
if [ -f "env.conf" ]; then
    source env.conf
    echo "✅ 已从 env.conf 载入变量配置"
else
    echo "❌ 错误：未找到 env.conf 文件！"
    exit 1
fi

# 3. 启动监控网页 (使用变量 $fun_port)
pkill -9 python3
# Python 会自动调用当前目录下的 index.html
nohup python3 -m http.server $fun_port > web.log 2>&1 &
echo "✅ iOS 监控网页运行在 $fun_port 端口"

# 4. 运行 argosbx 逻辑 (自动从 env.conf 识别 $agn 和 $agk)
chmod +x argosbx.sh
# 彻底清理旧隧道进程，确保新 Token 生效
pkill -9 cloudflared
bash argosbx.sh <<EOF
1
1
EOF

echo "🚀 双路由启动完毕"
echo "🌐 节点地址: $agn"
echo "🌐 网页地址: $fun_agn"
