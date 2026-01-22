const http = require('http'), fs = require('fs');
const port = 8080; // 这里的端口必须改为 8080

http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
    try {
        res.end(fs.readFileSync('index.html'));
    } catch (e) {
        res.end('<h1>Monitor System Active</h1>');
    }
}).listen(port, '0.0.0.0', () => console.log('iOS 26 UI Running on 8080'));
