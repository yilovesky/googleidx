{ pkgs, ... }: {
  channel = "stable-24.05";
  packages = [ pkgs.unzip pkgs.wget pkgs.python3 ];
  idx = {
    workspace = {
      onCreate = {
        setup = "chmod +x *.sh";
      };
      onStart = {
        # 核心：由这个脚本统一按顺序启动所有功能
        run-all = "bash start.sh";
      };
    };
    previews = {
      enable = true;
      previews = {
        web = {
          # 注意这里：我们不再让 IDX 自动运行 python 命令
          # 我们只需要在这里注册 8001 端口，启动交给 start.sh
          command = ["sleep" "infinity"]; 
          manager = "web";
        };
      };
    };
  };
}
