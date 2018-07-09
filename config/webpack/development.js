const environment = require('./environment')
const merge = require('webpack-merge')

module.exports = merge(environment.toWebpackConfig(), {
  devServer: {
    watchOptions: {
      poll: 1000,
    }
  },
  externals: {
    jquery: 'jQuery',
  },
})
