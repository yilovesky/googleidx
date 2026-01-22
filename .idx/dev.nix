{ pkgs, ... }: {
  channel = "stable-24.05";
  packages = [ pkgs.unzip pkgs.wget pkgs.python3 ];
  idx.workspace = {
    onCreate.setup = "chmod +x *.sh 2>/dev/null || true";
    onStart.run-all = "bash start.sh"; # 这里会启动 start.sh，进而执行 fun.conf 的逻辑 
  };
  idx.previews.enable = true;
  idx.previews.previews.web = {
    # 预览现在指向你新设定的 8003 端口
    command = ["sleep" "infinity"];
    manager = "web";
    env = {
      PORT = "8003"; # 明确指定预览监听 8003
    };
  };
}
