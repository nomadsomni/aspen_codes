const http = require('http');
const fs = require('fs');
const path = require('path');

const port = Number(process.env.PORT || 8080);
const root = process.cwd();
const defaultPage = process.env.DEFAULT_PAGE || 'TERMINAL.html';
const mime = {
  '.html': 'text/html',
  '.js': 'text/javascript',
  '.css': 'text/css',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.svg': 'image/svg+xml',
  '.json': 'application/json',
};

const server = http.createServer((req, res) => {
  let u = decodeURIComponent(req.url.split('?')[0]);
  if (u === '/' || u === '') u = `/${defaultPage}`;
  const fp = path.join(root, u);
  fs.readFile(fp, (err, data) => {
    if (err) {
      res.statusCode = 404;
      return res.end('Not found');
    }
    const ext = path.extname(fp).toLowerCase();
    if (mime[ext]) res.setHeader('Content-Type', mime[ext]);
    res.end(data);
  });
});

server.listen(port, () => {
  console.log(`server listening on http://localhost:${port}/`);
  console.log(`default page: ${defaultPage}`);
});
