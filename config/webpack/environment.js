const { environment } = require('@rails/webpacker')

const erb =  require('./loaders/erb')
const worker = require('./loaders/worker')
environment.loaders.prepend('erb', erb)
environment.loaders.prepend('worker', worker)

environment.config.delete('output.chunkFilename')
environment.config.set('output.chunkFilename', '[name].[contenthash].bundle.js')

module.exports = environment
