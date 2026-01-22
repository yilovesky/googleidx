#!/bin/bash

# 1. 清理
pkill -9 nezha-agent
pkill -9 python3
pkill -9 argosbx
sleep 2

# 2. 极速启动哪吒 (不再需要 config.yml)
# 使用环境变量直接注入参数
nohup ./nezha-agent -s ${NZ_SERVER} -p ${NZ_SECRET} --uuid ${NZ_UUID} --tls > nezha.log 2>&1 &
echo "✅ 哪吒已通过环境变量启动"

# 3. 启动保活 Python
nohup python3 -m http.server 8001 > web.log 2>&1 &
sleep 2

# 4. 启动 argosbx 节点
(bash argosbx.sh <<EOF
1
1
EOF
) > /dev/null 2>&1 &

echo "正在生成节点..."
sleep 8

# 5. 更新订阅
bash argosbx.sh list | grep -E 'vless://|vmess://|trojan://' > sub.txt
echo "✅ 订阅已更新至 sub.txt"
