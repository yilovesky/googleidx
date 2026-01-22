{ pkgs, ... }: {
  channel = "stable-24.05";
  packages = [ pkgs.unzip pkgs.wget pkgs.python3 ];
  idx = {
    workspace = {
      onStart = {
        # 核心：每次开机自动运行镜像脚本
        run-agent = "bash up.sh";
      };
    };
    previews = {
      enable = true;
      previews = {
        web = {
          # 核心：开启 8001 端口供 UptimeRobot 访问保活
          command = ["python3" "-m" "http.server" "8001"];
          manager = "web";
        };
      };
    };
  };
}
