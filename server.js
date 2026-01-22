cat <<EOF > server.js
const http = require('http');
const fs = require('fs');
const port = process.env.PORT || 8080;

const server = http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
    try {
        const data = fs.readFileSync('index.html');
        res.end(data);
    } catch (err) {
        res.end('<h1>Index.html 丢失，请重新生成</h1>');
    }
});

server.listen(port, '0.0.0.0', () => {
    console.log('iOS 26 监控中心已在端口 ' + port + ' 启动成功');
});
EOF
