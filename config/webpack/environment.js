const { environment } = require('@rails/webpacker')
const vue =  require('./loaders/vue')

// const babelLoader = environment.loaders.get('babel')
// babelLoader.include = [resolve('app/javascript'), resolve('node_modules/vue-multiselect')]

environment.config.merge({
  externals: {
    jquery: 'jQuery',
  },
})

environment.loaders.append('vue', vue)

environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader',
})

module.exports = environment
