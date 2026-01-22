#!/bin/bash

# 1. 下载并启动哪吒 (保持 NK 架构逻辑不变) [cite: 3]
ARCH=$(uname -m)
[ "$ARCH" = "x86_64" ] && URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_amd64.zip" || URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_arm64.zip"

if [ ! -f "nezha-agent" ]; then
    wget -O nezha-agent.zip $URL && unzip -o nezha-agent.zip && chmod +x nezha-agent
    rm -f nezha-agent.zip
fi

pkill -9 nezha-agent
nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &

# 2. 载入新的 fun.conf 变量
if [ -f "fun.conf" ]; then
    source fun.conf
    echo "✅ 已载入新 Argo 变量: $fun_agn"
fi

# 3. 启动 iOS 监控中心网页在 8003 端口
pkill -9 python3
nohup python3 -m http.server $fun_port > web.log 2>&1 &
echo "✅ 监控页已在端口 $fun_port 启动"

# 4. 运行节点穿透逻辑 (保持 env.conf 原逻辑不变) [cite: 1, 3]
if [ -f "env.conf" ]; then
    source env.conf
fi
chmod +x argosbx.sh
bash argosbx.sh <<EOF
1
1
EOF

# 5. 特外手动启动第二个固定 Argo 隧道用于 fun 域名
# 这样不影响原有的 argosbx 脚本运行
nohup ./agsbx/cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token "$fun_agk" > fun_argo.log 2>&1 &
