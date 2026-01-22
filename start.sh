#!/bin/bash

# 1. 自动架构下载哪吒 (按你要求的逻辑)
ARCH=$(uname -m)
[ "$ARCH" = "x86_64" ] && URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_amd64.zip" || URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_arm64.zip"

if [ ! -f "nezha-agent" ]; then
    echo "正在下载哪吒 Agent ($ARCH)..."
    wget -O nezha-agent.zip $URL && unzip -o nezha-agent.zip && chmod +x nezha-agent
    rm -f nezha-agent.zip
fi

# 2. 启动哪吒
pkill -9 nezha-agent
nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &
echo "✅ 哪吒已启动"

# 3. 启动保活 Web (移到 8080 端口，不再占用 8001)
pkill -9 python3
nohup python3 -m http.server 8080 > web.log 2>&1 &
echo "✅ 保活服务器运行在 8080 端口"

# 4. 加载变量并安装节点
if [ -f "env.conf" ]; then
    source env.conf
    echo "✅ 已载入 env.conf 变量"
fi

# 确保执行权限
chmod +x argosbx.sh
mkdir -p $HOME/bin

# 自动运行 (此时 8001 是空的，argosbx 可以顺利占用它)
bash argosbx.sh <<EOF
1
1
EOF

# 5. 生成订阅
sleep 10
bash argosbx.sh list | grep -E 'vless://|vmess://|trojan://' > sub.txt
echo "✅ 订阅文件已更新"
