{ pkgs, ... }: {
  channel = "stable-24.05";
  packages = [
    pkgs.unzip
    pkgs.wget
    pkgs.python3
  ];
  idx = {
    workspace = {
      # 核心：自动复活脚本
      onStart = {
        run-agent = "bash up.sh";
      };
    };
    previews = {
      enable = true;
      previews = {
        web = {
          # 核心：开启 8001 端口供外部访问保活
          command = ["python3" "-m" "http.server" "8001"];
          manager = "web";
        };
      };
    };
  };
}
