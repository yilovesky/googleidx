#!/bin/bash

# 1. 下载并启动哪吒 (保持 A 代码逻辑)
ARCH=$(uname -m)
[ "$ARCH" = "x86_64" ] && URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_amd64.zip" || URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_arm64.zip"

if [ ! -f "nezha-agent" ]; then
    wget -O nezha-agent.zip $URL && unzip -o nezha-agent.zip && chmod +x nezha-agent
    rm -f nezha-agent.zip
fi
pkill -9 nezha-agent
nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &

# 2. 核心：进入目录并调用变量
cd "$(dirname "$0")"
if [ -f "env.conf" ]; then
    source env.conf
    # 强制将变量导出给全局环境，防止 argosbx 读取不到
    export vwpt agn agk argo USER fun_port fun_agn
    echo "✅ 变量已强制注入环境"
fi

# 3. 启动监控网页并显式调用 index.html
pkill -9 python3
if [ -f "index.html" ]; then
    # 在 8003 端口启动，提供 index.html 服务
    nohup python3 -m http.server $fun_port > web.log 2>&1 &
    echo "✅ 监控页 index.html 已就绪，端口: $fun_port"
else
    echo "❌ 警告：未找到 index.html"
fi

# 4. 运行 argosbx 逻辑 (NK 架构)
# 必须先赋予权限
chmod +x argosbx.sh
# 传入 1 1 确保它执行安装并启动固定隧道
bash argosbx.sh <<EOF
1
1
EOF

echo "🚀 双路由强制启动完毕"
echo "🌐 节点域名: $agn"
echo "🌐 网页地址: $fun_agn"
