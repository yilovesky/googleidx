{ pkgs, ... }: {
  channel = "stable-24.05";
  packages = [ pkgs.unzip pkgs.wget pkgs.python3 ];
  
  # 所有的核心参数全在这里，实现“一个文件管全家”
  env = {
    USER = "root";
    # 哪吒配置 (对应官方环境变量)
    NZ_SERVER = "nz.117.de5.net:443";
    NZ_CLIENT_SECRET = "p3joFK1jc3Z31YXqMXfNPvjjxx1lQknL";
    NZ_TLS = "true";
    # Argo 节点参数 (对应 argosbx.sh 源码变量名)
    vwpt = "8001"; 
    agn = "idx.113.de5.net";
    agk = "eyJhIjoiNDc4NmQyMjRkZTJkNmM2YTcwOWRkNTIwYjZhMzczOTMiLCJ0IjoiOWJlZmZiM2YtMTc2Mi00MGU0LWJhNDgtYjEyNTU4NjM0MjQxIiwicyI6Ik5qWXhNV1ZqTW1ZdE0yVTFOQzAwTTJNMExXSmhNbVF0TkRNeE5XTTRNMkZsT1dVdyJ9";
    argo = "vwpt";
  };

  idx = {
    workspace = {
      onCreate = {
        # 预设权限
        setup = "chmod +x *.sh nezha-agent 2>/dev/null || true";
      };
      onStart = {
        # 启动唯一的指挥官脚本
        run-all = "bash start.sh";
      };
    };
    previews = {
      enable = true;
      previews = {
        web = {
          command = ["sleep" "infinity"]; 
          manager = "web";
        };
      };
    };
  };
}
