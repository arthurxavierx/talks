var path = require('path');
var webpack = require('webpack');
var HtmlWebpackPlugin = require('html-webpack-plugin');
var CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
  entry: [ path.join(__dirname, 'index.js') ],
  output: {
    path: path.resolve('../dist/front-end-fp-elm'),
    filename: '[name]-[hash].min.js'
  },
  module: {
    loaders: [
      {
        test: /\.purs$/,
        loader: 'purs-loader',
        exclude: /node_modules/,
        query: {
          psc: 'psa',
          bundle: true,
          warnings: false
        }
      }
    ],
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify('production')
    }),
    new webpack.optimize.OccurrenceOrderPlugin(true),
    new webpack.LoaderOptionsPlugin({
      minimize: true,
      debug: false
    }),
    new HtmlWebpackPlugin({
      template: './index.html',
      inject: 'body',
      filename: 'index.html'
    }),
    new CopyWebpackPlugin([{ from: './static', to: './' }])
  ],
  resolveLoader: {
    modules: [
      path.join(__dirname, 'node_modules')
    ]
  },
  resolve: {
    modules: [
      'node_modules',
      'bower_components'
    ],
    extensions: ['.js', '.purs']
  }
};
