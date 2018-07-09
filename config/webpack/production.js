const environment = require('./environment')
const merge = require('webpack-merge')

module.exports = merge(environment.toWebpackConfig(), {
  externals: {
    jquery: 'jQuery',
  },
})
