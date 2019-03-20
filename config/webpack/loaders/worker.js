module.exports = {
  test: /\.worker.js/,
  use: [{
    loader: 'worker-loader',
  }]
}
