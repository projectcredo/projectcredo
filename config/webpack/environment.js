const { environment } = require('@rails/webpacker')
const vue = require('./loaders/vue')
const { resolve } = require('path')
const webpack = require('webpack')
const { VueLoaderPlugin } = require('vue-loader')

const babelLoader = environment.loaders.get('babel')
babelLoader.exclude = []
babelLoader.include = [resolve('app/javascript'), resolve('node_modules/vue-multiselect')]

environment.plugins.append(
  'VueLoaderPlugin',
  new VueLoaderPlugin()
)

environment.plugins.append(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery',
  }),
)

environment.loaders.append('vue', vue)

environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader',
})

module.exports = environment
