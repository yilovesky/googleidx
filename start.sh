#!/bin/bash

# 1. 下载并启动哪吒
ARCH=$(uname -m)
[ "$ARCH" = "x86_64" ] && URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_amd64.zip" || URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_arm64.zip"

if [ ! -f "nezha-agent" ]; then
    wget -O nezha-agent.zip $URL && unzip -o nezha-agent.zip && chmod +x nezha-agent
    rm -f nezha-agent.zip
fi
pkill -9 nezha-agent
nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &

# 2. 启动监控网页 (端口 8003)
pkill -9 python3
nohup python3 -m http.server 8003 > web.log 2>&1 &
echo "✅ iOS 监控页运行在 8003 端口"

# 3. 统一变量配置 (补全 vmag 开关)
export vwpt="8001"
export agn="idxus.113.de5.net" 
export agk="eyJhIjoiNDc4NmQyMjRkZTJkNmM2YTcwOWRkNTIwYjZhMzczOTMiLCJ0IjoiOWJlZmZiM2YtMTc2Mi00MGU0LWJhNDgtYjEyNTU4NjM0MjQxIiwicyI6Ik5qWXhNV1ZqTW1ZdE0yVTFOQzAwTTJNMExXSmhNbVF0TkRNeE5XTTRNMkZsT1dVdyJ9"
export argo="vwpt"
export vmag="yes"    # ⚠️ 必须有这个，脚本才会输出带 ARGO 域名的节点！
export USER=root
export fun="funus.113.de5.net"

# 4. 运行 argosbx 逻辑
# 清理缓存，确保脚本重新识别变量
rm -rf $HOME/agsbx/sbargoym.log $HOME/agsbx/sbargotoken.log $HOME/agsbx/jh.txt

chmod +x argosbx.sh
bash argosbx.sh <<EOF
1
1
EOF

echo "🚀 双路由启动完毕"
echo "🌐 节点地址: $agn"
echo "🌐 网页地址: $fun"
