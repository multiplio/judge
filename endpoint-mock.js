/* eslint-disable */

const http = require('http')
const events = require('events')

function create() {
  const requests = new events.EventEmitter()

  const onRequest = (req, res) => {
    console.log('serve: ' + req.url);

    const ip = res.socket.remoteAddress;
    const port = res.socket.remotePort;
    res.end(`Your IP address is ${ip} and your source port is ${port}.`);
  }
  http
    .createServer(onRequest)
    .listen(3002, '127.0.0.1', () => console.log('http proxy up'))

  // const proxy = http.createServer((req, res) => {
  //   console.log('mock : ' + req.url)
  //   requests.emit(req.method, req.path)

  //   res.writeHead(200, { 'Content-Type': 'text/plain' })
  //   res.end('okay')
  // })
  // const server = proxy.listen(
  //   3002,
  //   '127.0.0.1',
  //   () => console.log('http proxy running')
  // )

  function expect(method, expectedPath) {
    return new Promise((resolve, reject) => {
      requests.on(method, (path) => {
        if (path === expectedPath) {
          resolve(req)
        }
      })
    })
  }

  return {
    expect,
    kill: () => { server.close() },
  }
}

module.exports = create
