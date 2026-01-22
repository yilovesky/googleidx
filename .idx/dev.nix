{ pkgs, ... }: {
  channel = "stable-24.05";
  packages = [ pkgs.unzip pkgs.wget pkgs.python3 ];
  
  # 所有的核心参数全在这里，实现“一个文件管全家”
  env = {
    USER = "root";
    # 哪吒配置参数
    NZ_SERVER = "nz.117.de5.net:443";
    NZ_SECRET = "p3joFK1jc3Z31YXqMXfNPvjjxx1lQknL";
    NZ_UUID = "ada9d899-a9d8-43ee-593b-308ac850fd3e";
    # Argo 节点参数
    agk = "eyJhIjoiNDc4NmQyMjRkZTJkNmM2YTcwOWRkNTIwYjZhMzczOTMiLCJ0IjoiOWJlZmZiM2YtMTc2Mi00MGU0LWJhNDgtYjEyNTU4NjM0MjQxIiwicyI6Ik5qWXhNV1ZqTW1ZdE0yVTFOQzAwTTJNMExXSmhNbVF0TkRNeE5XTTRNMkZsT1dVdyJ9";
    agn = "idx.113.de5.net";
    argo = "vwpt";
    vwpt = "8001";
  };

  idx = {
    workspace = {
      onCreate = {
        setup = "chmod +x *.sh";
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
