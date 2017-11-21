const { environment } = require('@rails/webpacker')
const { resolve } = require('path')
const babelLoader = require('@rails/webpacker/package/loaders/babel')

babelLoader.exclude = []
babelLoader.include = [resolve('app/javascript'), resolve('node_modules/vue-multiselect')]
environment.loaders.set('babel', babelLoader)

module.exports = environment
