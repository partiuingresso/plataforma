const { environment } = require('@rails/webpacker')

const erb =  require('./loaders/erb')
environment.loaders.prepend('erb', erb)

environment.config.delete('output.chunkFilename')
environment.config.set('output.chunkFilename', '[name].bundle.js')

module.exports = environment
