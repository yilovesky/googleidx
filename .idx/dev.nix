{ pkgs, ... }: {
  channel = "stable-24.05";
  packages = [ pkgs.unzip pkgs.wget pkgs.python3 pkgs.nodejs pkgs.lsof ];
  idx.workspace = {
    onCreate.setup = "chmod +x *.sh 2>/dev/null || true";
    onStart.run-all = "bash start.sh"; 
  };
  idx.previews = {
    enable = true;
    previews = {
      web = {
        # 这里的预览指向 8080 端口（网站端口）
        command = ["node" "server.js"];
        manager = "web";
        env = { PORT = "8080"; };
      };
    };
  };
}
