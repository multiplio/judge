const PORT = 3000
const ADDRESS = `localhost:${PORT}`
const request = require('supertest')(ADDRESS)

const { create, kill } = require('./docker')
const mock = require('./endpoint-mock')
