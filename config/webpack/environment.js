const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')

const erb =  require('./loaders/erb')
const worker = require('./loaders/worker')
environment.loaders.prepend('erb', erb)
environment.loaders.prepend('worker', worker)

environment.config.delete('output.chunkFilename')
environment.config.set('output.chunkFilename', '[name].[contenthash].bundle.js')

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
module.exports = environment
