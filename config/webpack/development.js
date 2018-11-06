process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')
const merge = require('webpack-merge')

module.exports = merge(environment.toWebpackConfig(), {
  devServer: {
    watchOptions: {
      poll: 1000,
      ignored: /node_modules/,
    },
  },
})
