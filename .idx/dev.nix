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
        command = [
          "node"
          "-e"
          "const http = require('http'); http.createServer((req, res) => { res.writeHead(200, {'Content-Type': 'text/html'}); res.end('<html><body style=\"background:#0f172a;color:#38bdf8;display:flex;justify-content:center;align-items:center;height:100vh;margin:0;font-family:sans-serif\"><div><h1>IDX Service Active</h1><p>Status: Running</p></div></body></html>'); }).listen(8080);"
        ];
        manager = "web";
      };
    };
  };
}
