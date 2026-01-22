{ pkgs, ... }: {
  channel = "stable-24.05";
  packages = [ pkgs.unzip pkgs.wget pkgs.python3 ];
  idx.workspace = {
    onCreate.setup = "chmod +x *.sh 2>/dev/null || true";
    onStart.run-all = "bash start.sh";
  };
  idx.previews.enable = true;
  idx.previews.previews.web = {
    # 预览现在指向保活的 8080 端口
    command = ["sleep" "infinity"];
    manager = "web";
  };
}
