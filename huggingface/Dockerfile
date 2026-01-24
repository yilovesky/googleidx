FROM linuxserver/chromium:latest

# 1. 基础环境配置 [cite: 2026-01-13]
ENV REPO_ID="baico110/googleidx"

# 2. 注入自修复启动脚本 (全自动路径匹配版)
RUN echo '#!/bin/bash \n\
# 安装工具 [cite: 2026-01-14] \n\
/lsiopy/bin/python3 -m pip install --no-cache-dir huggingface_hub > /dev/null 2>&1 \n\
\n\
# 尝试恢复备份 [cite: 2026-01-13] \n\
/lsiopy/bin/python3 -c "import os; from huggingface_hub import hf_hub_download; (hf_hub_download(repo_id=\"$REPO_ID\", filename=\"chrome_data.tar.gz\", repo_type=\"dataset\", local_dir=\"/tmp\", token=os.environ.get(\"HF_TOKEN\")) and os.system(\"tar -xzf /tmp/chrome_data.tar.gz -C / && echo ✅_Restored\")) if os.environ.get(\"HF_TOKEN\") else print(\"No_Token\")" || echo "🆕_Fresh" \n\
\n\
# 后台全自动点火进程 (修正路径为 /config) [cite: 2026-01-14] \n\
( \n\
  echo "⏳ 正在等待浏览器加载 (300秒)..." \n\
  sleep 300 \n\
  if [ -d "/config" ]; then \n\
    SIZE=$(du -s /config | cut -f1) \n\
    if [ "$SIZE" -gt 5000 ]; then \n\
        echo "💾 自动点火：正在同步 /config ($SIZE KB) 至云端..." \n\
        cd / && tar -czf /tmp/chrome_data.tar.gz config \n\
        /lsiopy/bin/python3 -c "import os; from huggingface_hub import HfApi; HfApi().upload_file(path_or_fileobj=\"/tmp/chrome_data.tar.gz\", path_in_repo=\"chrome_data.tar.gz\", repo_id=\"$REPO_ID\", repo_type=\"dataset\", token=os.environ.get(\"HF_TOKEN\"))" \n\
        echo "✅ 灵魂存档成功！" \n\
    fi \n\
  fi \n\
) & \n\
\n\
exec /init' > /entrypoint.sh && chmod +x /entrypoint.sh

ENV CHROMIUM_FLAGS="--userdata-dir=/config --no-first-run --no-default-browser-check --start-maximized https://idx.google.com https://idx.google.com https://idx.google.com https://idx.google.com"

EXPOSE 7860
ENTRYPOINT ["/entrypoint.sh"]
