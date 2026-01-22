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

# 2. 载入新变量并启动监控中心网站
if [ -f "fun.conf" ]; then
    source fun.conf
    echo "✅ 已载入新固定 ARGO 变量: $fun_agn"
fi

# 确保网页文件存在并启动服务 (使用 8003 端口)
pkill -9 python3
# 将监控页 index.html 运行在 8003 端口
nohup python3 -m http.server $fun_port > web.log 2>&1 &
echo "✅ iOS 26 监控网页已运行在 $fun_port 端口"

# 3. 运行原有 argosbx 逻辑 (保活原来的 8001 节点) 
if [ -f "env.conf" ]; then
    source env.conf
fi
chmod +x argosbx.sh
bash argosbx.sh <<EOF
1
1
EOF

# 4. 关键：启动第二个 Cloudflared 进程连接新域名
# 这里使用你提供的新 Token 将 8003 端口透出到 fun.113.de5.net
nohup ./agsbx/cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token "$fun_agk" > fun_argo.log 2>&1 &
echo "🚀 网站已通过 $fun_agn 发布"
