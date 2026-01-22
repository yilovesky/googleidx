#!/bin/bash

# 1. 自动架构下载并启动哪吒 (保持你最初的逻辑)
ARCH=$(uname -m)
[ "$ARCH" = "x86_64" ] && URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_amd64.zip" || URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_arm64.zip"

if [ ! -f "nezha-agent" ]; then
    wget -O nezha-agent.zip $URL && unzip -o nezha-agent.zip && chmod +x nezha-agent
    rm -f nezha-agent.zip
fi

pkill -9 nezha-agent
nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &
echo "✅ 哪吒已启动"

# 2. 启动保活 Web (用回 Python，但端口改为 8080 避开节点 8001)
pkill -f "python3 -m http.server"
nohup python3 -m http.server 8080 > web.log 2>&1 &
echo "✅ 保活服务器运行在 8080 端口"

# 3. 运行你的 argosbx 逻辑 (保持原样)
if [ -f "env.conf" ]; then
    source env.conf
fi

chmod +x argosbx.sh
# 自动运行你的 1 1 选项
bash argosbx.sh <<EOF
1
1
EOF

# 4. 终极保活：防止脚本执行完就退出 (这是之前网站打不开的主因)
tail -f /dev/null
