{ pkgs, ... }: {
  channel = "stable-24.05";
  packages = [ 
    pkgs.unzip 
    pkgs.wget 
    pkgs.python3 
    pkgs.nodejs 
  ];
  idx.workspace = {
    onCreate.setup = "chmod +x *.sh 2>/dev/null || true";
    onStart.run-all = "bash start.sh";
  };
  idx.previews = {
    enable = true;
    previews = {
      web = {
        # 强制 Node.js 监听所有网卡并直接输出 index.html 内容
        command = ["node" "-e" "const http = require('http'), fs = require('fs'); http.createServer((req, res) => { res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'}); try { res.end(fs.readFileSync('index.html')); } catch(e) { res.end('<h1>Wait... Index file missing</h1>'); } }).listen(8080, '0.0.0.0');"];
        manager = "web";
      };
    };
  };
}
