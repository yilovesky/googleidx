{ pkgs, ... }: {
  channel = "stable-24.05";
  packages = [ pkgs.unzip pkgs.wget pkgs.python3 ];
  idx = {
    workspace = {
      # onCreate: 只有在第一次从 GitHub 导入仓库时运行
      onCreate = {
        setup = "chmod +x *.sh";
      };
      # onStart: 以后每次点开这个 IDX 网页或重启时都会自动运行
      onStart = {
        # 修改点：将 up.sh 改为 start.sh，因为我们要运行带 sub.txt 逻辑的脚本
        run-agent = "bash start.sh";
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
