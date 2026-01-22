#!/bin/bash

# 1. 自动架构下载哪吒 (保持原封不动)
ARCH=$(uname -m)
[ "$ARCH" = "x86_64" ] && URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_amd64.zip" || URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_arm64.zip"

if [ ! -f "nezha-agent" ]; then
    echo "正在下载哪吒 Agent ($ARCH)..."
    wget -O nezha-agent.zip $URL && unzip -o nezha-agent.zip && chmod +x nezha-agent
    rm -f nezha-agent.zip
fi

# 2. 启动哪吒 (保持原封不动)
pkill -9 nezha-agent
nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &
echo "✅ 哪吒已启动"

# 3. 启动 iOS 26 极致美学 Web 服务 (替换原 Python 逻辑)
# 端口依然使用你 env.conf 里的 vwpt="8001"
pkill -f "node server.js"
nohup node server.js > web.log 2>&1 &
echo "✅ iOS 26 UI 运行在 8001 端口"

# 4. 加载变量并安装节点 (保持原封不动)
if [ -f "env.conf" ]; then
    source env.conf
    echo "✅ 已载入 env.conf 变量"
fi

chmod +x argosbx.sh
mkdir -p $HOME/bin

# 自动运行 argosbx (对接你的固定隧道 Token)
bash argosbx.sh <<EOF
1
1
EOF

# 5. 生成订阅 (保持原封不动)
sleep 10
bash argosbx.sh list | grep -E 'vless://|vmess://|trojan://' > sub.txt
echo "✅ 订阅文件已更新"
