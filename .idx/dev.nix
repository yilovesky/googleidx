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
        # 核心改动：使用 process.env.PORT。这会让程序自动匹配 IDX 分配的 9000 或 8080 端口。
        command = ["node" "-e" "const http = require('http'), fs = require('fs'); http.createServer((req, res) => { res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'}); try { res.end(fs.readFileSync('index.html')); } catch(e) { res.end('<h1>Index.html Not Found</h1>'); } }).listen(process.env.PORT || 8080, '0.0.0.0');"];
        manager = "web";
      };
    };
  };
}
