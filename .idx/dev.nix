{ pkgs, ... }: {
  channel = "stable-24.05";
  packages = [ 
    pkgs.unzip 
    pkgs.wget 
    pkgs.python3 
    pkgs.nodejs
    pkgs.lsof
  ];
  idx.workspace = {
    # 权限设置：确保脚本可以执行
    onCreate.setup = "chmod +x *.sh 2>/dev/null || true";
    # 核心：每次工作区启动都自动执行你的 start.sh
    onStart.run-all = "bash start.sh";
  };
  idx.previews = {
    enable = true;
    previews = {
      web = {
        # 预览窗口盯着 8080 端口，不再抢隧道的 8001
        command = ["python3" "-m" "http.server" "8080"];
        manager = "web";
      };
    };
  };
}
