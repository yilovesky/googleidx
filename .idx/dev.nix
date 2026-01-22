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
        # 强制 Node.js 读取 index.html 吐出流，解决 http-server 的权限转圈 Bug
        command = ["node" "-e" "const http = require('http'), fs = require('fs'); http.createServer((req, res) => { res.writeHead(200, {'Content-Type': 'text/html'}); try { res.end(fs.readFileSync('index.html')); } catch(e) { res.end('<h1>Index.html Not Found</h1>'); } }).listen(8080);"];
        manager = "web";
      };
    };
  };
}
