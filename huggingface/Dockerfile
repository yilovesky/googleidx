# 1. 基础环境
FROM linuxserver/chromium:latest

# 2. 你的权限与端口配置 [cite: 2026-01-14]
ENV CUSTOM_PORT=7860
EXPOSE 7860
ENV PUID=1000
ENV PGID=1000
ENV TZ=Asia/Shanghai
ENV REPO_ID="baico110/googleidx"

# 3. 
ENV CHROMIUM_FLAGS="--userdata-dir=/config --no-sandbox --disable-dev-shm-usage --disable-gpu --no-first-run --start-maximized"

# 4. 注入 备份 逻辑 (开机恢复 + 5分钟后唯一备份)
RUN mkdir -p /custom-cont-init.d && echo '#!/bin/bash \n\
/lsiopy/bin/python3 -m pip install --no-cache-dir huggingface_hub > /dev/null 2>&1 \n\
\n\
# 【恢复】自动恢复所有 Cookies 和书签 \n\
if [ -n "$HF_TOKEN" ]; then \n\
    echo "🔄 正在载入您的登录备份与书签..." \n\
    /lsiopy/bin/python3 -c "import os; from huggingface_hub import hf_hub_download; (hf_hub_download(repo_id=\"$REPO_ID\", filename=\"chrome_data.tar.gz\", repo_type=\"dataset\", local_dir=\"/tmp\", token=os.environ.get(\"HF_TOKEN\")) and os.system(\"tar -xzf /tmp/chrome_data.tar.gz -C / && echo ✅_回魂成功\"))" \n\
fi \n\
\n\
# 【防锁死】清理单例锁 [cite: 2026-01-14] \n\
rm -rf /config/Singleton* /config/lock \n\
\n\
# 【唯一同步】5分钟后执行存盘 \n\
( \n\
  echo "⏳ 5分钟“备份固化”计时开始。请在此期间完成登录并添加书签。" \n\
  sleep 300 \n\
  SIZE=$(du -s /config | cut -f1) \n\
  if [ "$SIZE" -gt 5000 ]; then \n\
      echo "💾 正在捕捉已登录备份 ($SIZE KB)..." \n\
      # 备份前最后删一次锁，确保下次部署顺滑 \n\
      rm -rf /config/Singleton* /config/lock \n\
      cd / && tar -czf /tmp/chrome_data.tar.gz config \n\
      /lsiopy/bin/python3 -c "import os; from huggingface_hub import HfApi; HfApi().upload_file(path_or_fileobj=\"/tmp/chrome_data.tar.gz\", path_in_repo=\"chrome_data.tar.gz\", repo_id=\"$REPO_ID\", repo_type=\"dataset\", token=os.environ.get(\"HF_TOKEN\"))" \n\
      echo "✅ 备份已永久固化。您的 Cookies 和书签已安全存档。" \n\
  fi \n\
) &' > /custom-cont-init.d/nk_final.sh && chmod +x /custom-cont-init.d/nk_final.sh

# 5. 启动入口
ENTRYPOINT ["/init"]
