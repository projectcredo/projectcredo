process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const webpackConfig = require('./base')

console.log(JSON.stringify(webpackConfig, null, 2))

module.exports = webpackConfig
