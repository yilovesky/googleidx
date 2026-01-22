#!/bin/bash

# 1. 下载哪吒 (保持 A 代码逻辑) 
ARCH=$(uname -m)
[ "$ARCH" = "x86_64" ] && URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_amd64.zip" || URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_arm64.zip"

if [ ! -f "nezha-agent" ]; then
    wget -O nezha-agent.zip $URL && unzip -o nezha-agent.zip && chmod +x nezha-agent
    rm -f nezha-agent.zip
fi

pkill -9 nezha-agent
nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &

# 2. 启动 8003 端口的 iOS 监控网页 
if [ -f "fun.conf" ]; then
    source fun.conf
fi
pkill -9 python3
nohup python3 -m http.server $fun_port > web.log 2>&1 &
echo "✅ 监控页运行在 $fun_port 端口"

# 3. 运行原有 argosbx 逻辑 (启动第一个隧道：节点) 
if [ -f "env.conf" ]; then
    source env.conf
fi
chmod +x argosbx.sh
# 这一步会启动 8001 端口的隧道进程 
bash argosbx.sh <<EOF
1
1
EOF

# 4. 强制启动第二个独立进程 (用于网页域名) 
CLOUDFLARE_PATH="$HOME/agsbx/cloudflared"
sleep 5 # 等待第一个进程稳定

if [ -f "$CLOUDFLARE_PATH" ]; then
    echo "✅ 正在启动第二个独立隧道进程..."
    # 使用 --no-autoupdate 且不引用默认 config 路径，确保与第一个进程隔离
    nohup "$CLOUDFLARE_PATH" tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token "$fun_agk" > fun_argo.log 2>&1 &
fi

echo "🚀 节点域名: $agn"
echo "🚀 网站域名: $fun_agn"
