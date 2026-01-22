{ pkgs, ... }: {
  channel = "stable-24.05";
  packages = [ 
    pkgs.unzip 
    pkgs.wget 
    pkgs.python3 
    pkgs.nodejs
    pkgs.lsof  # 用于 start.sh 里的端口清理逻辑
  ];
  idx.workspace = {
    onCreate.setup = "chmod +x *.sh 2>/dev/null || true";
    onStart.run-all = "bash start.sh";
  };
  idx.previews = {
    enable = true;
    previews = {
      web = {
        # 既然 start.sh 里已经启动了 node server.js，
        # 这里直接通过环境变量锁定端口 8001。
        command = ["node" "server.js"]; 
        manager = "web";
        env = {
          PORT = "8001"; 
        };
      };
    };
  };
}
