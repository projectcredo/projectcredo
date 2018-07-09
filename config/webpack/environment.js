const { environment } = require('@rails/webpacker')
const vue =  require('./loaders/vue')
const { resolve } = require('path')

// const babelLoader = environment.loaders.get('babel')
// babelLoader.include = [resolve('app/javascript'), resolve('node_modules/vue-multiselect')]

environment.config.merge({
  externals: {
    jquery: 'jQuery',
  },
})

environment.loaders.append('vue', vue)

module.exports = environment
