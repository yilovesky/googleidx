{ pkgs, ... }: {
  channel = "stable-24.05";
  packages = [ pkgs.unzip pkgs.wget pkgs.python3 ];
  idx.workspace = {
    onCreate.setup = "chmod +x *.sh 2>/dev/null || true";
    onStart.run-all = "bash start.sh";
  };
  idx.previews = {
    enable = true;
    previews = {
      web = {
        # 预览指向 8080 端口
        command = ["python3" "-m" "http.server" "8080"];
        manager = "web";
      };
    };
  };
}
