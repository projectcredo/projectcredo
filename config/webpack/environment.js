const { environment } = require('@rails/webpacker')
const vue = require('./loaders/vue')
const { resolve } = require('path')
const webpack = require('webpack')

const babelLoader = environment.loaders.get('babel')
babelLoader.exclude = []
babelLoader.include = [resolve('app/javascript'), resolve('node_modules/vue-multiselect')]

environment.plugins.append(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery',
  }),
)

environment.plugins.append(
  'CommonsChunkVendor',
  new webpack.optimize.CommonsChunkPlugin({
    name: 'vendor',
    minChunks: module => {
      // this assumes your vendor imports exist in the node_modules directory
      return module.context && module.context.indexOf('node_modules') !== -1
    },
  }),
)

environment.plugins.append(
  'CommonsChunkManifest',
  new webpack.optimize.CommonsChunkPlugin({
    name: 'manifest',
    minChunks: Infinity,
  }),
)

environment.loaders.append('vue', vue)

environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader',
})

module.exports = environment
