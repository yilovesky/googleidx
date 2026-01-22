#!/bin/bash

# 1. 自动架构下载哪吒 (保持 A 代码逻辑 [cite: 1, 4])
ARCH=$(uname -m)
[ "$ARCH" = "x86_64" ] && URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_amd64.zip" || URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_arm64.zip"

if [ ! -f "nezha-agent" ]; then
    wget -O nezha-agent.zip $URL && unzip -o nezha-agent.zip && chmod +x nezha-agent
    rm -f nezha-agent.zip
fi

# 启动哪吒
pkill -9 nezha-agent
nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &

# 2. 调用变量文件 
if [ -f "env.conf" ]; then
    source env.conf
    echo "✅ 已载入变量配置"
fi

# 3. 启动监控网页 (使用变量 fun_port [cite: 4])
pkill -9 python3
nohup python3 -m http.server $fun_port > web.log 2>&1 &
echo "✅ 监控页运行在 $fun_port 端口"

# 4. 运行 argosbx 脚本逻辑 (自动使用 env.conf 导出的变量 )
chmod +x argosbx.sh
bash argosbx.sh <<EOF
1
1
EOF

echo "🚀 双路由启动完毕"
echo "🌐 节点地址: $agn"
echo "🌐 网页地址: $fun_agn"
