const http = require('http'), fs = require('fs');
const port = process.env.PORT || 8080;

http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
    try { 
        // 这里读取的是同目录下的 index.html
        res.end(fs.readFileSync('index.html')); 
    } catch (e) { 
        res.end('<h1>Error: index.html Not Found</h1>'); 
    }
}).listen(port, '0.0.0.0', () => console.log('Server is running on ' + port));
