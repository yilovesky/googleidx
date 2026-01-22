# 1. 下载并赋予权限（确保哪吒程序存在）
if [ ! -f "nezha-agent" ]; then
    wget -O nezha-agent https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_amd64.zip && unzip -o nezha-agent_linux_amd64.zip && chmod +x nezha-agent
fi

# 2. 启动哪吒监控
nohup ./nezha-agent -c config.yml > nezha.log 2>&1 &

# 3. 启动节点
export USER=root agk="eyJhIjoiNDc4NmQyMjRkZTJkNmM2YTcwOWRkNTIwYjZhMzczOTMiLCJ0IjoiOWJlZmZiM2YtMTc2Mi00MGU0LWJhNDgtYjEyNTU4NjM0MjQxIiwicyI6Ik5qWXhNV1ZqTW1ZdE0yVTFOQzAwTTJNMExXSmhNbVF0TkRNeE5XTTRNMkZsT1dVdyJ9" agn="idx.113.de5.net" uuid="846afa77-bb60-4194-ba50-4d533da97756" argo="vwpt" vwpt="8001"
bash argosbx.sh
