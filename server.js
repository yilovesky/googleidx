const http = require('http'), fs = require('fs');
const port = 8001; // 对接 env.conf 中的 vwpt

http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
    try {
        res.end(fs.readFileSync('index.html'));
    } catch (e) {
        res.end('<h1>Monitor Active</h1><p>iOS 26 UI file not found.</p>');
    }
}).listen(port, '0.0.0.0');
