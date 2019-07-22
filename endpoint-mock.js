const http = require('http')
const events = require('events')

function create() {
  const requests = new events.EventEmitter()

  const proxy = http.createServer((req, res) => {
    console.log('mock : ' + req.url)
    requests.emit(req.method, req)

    res.writeHead(200, { 'Content-Type': 'text/plain' })
    res.end('okay')
  })
  const server = proxy.listen(
    8000,
    '127.0.0.1',
    () => console.log('http proxy running')
  )

  function expect(method, expectedPath) {
    return new Promise((resolve, reject) => {
      requests.on(method, (req) => {
        if (req.path === expectedPath) {
          resolve(req)
        }
      })
      setTimeout(() => reject(Error('Request timed out')), 5000)
    })
  }

  return {
    expect,
    kill: () => {
      server.close()
    },
  }
}

module.exports = create
