const http = require('http'), fs = require('fs');
const port = 8080; // 修改这里，避开隧道的 8001

http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
    try {
        res.end(fs.readFileSync('index.html'));
    } catch (e) {
        res.end('<h1>Monitor Active</h1>');
    }
}).listen(port, '0.0.0.0', () => console.log('UI Web running on 8080'));
