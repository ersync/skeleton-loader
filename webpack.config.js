const path = require('path');

module.exports = [
  {
    name: 'umd',
    mode: 'production',
    entry: './app/javascript/skeleton_loader.js',
    output: {
      filename: 'skeleton_loader.js',
      path: path.resolve(__dirname, 'app/assets/javascripts'),
      library: 'SkeletonLoader',
      libraryTarget: 'umd',
      libraryExport: 'default',
      globalObject: 'this'
    },
    module: {
      rules: [
        {
          test: /\.js$/,
          exclude: /node_modules/,
          use: {
            loader: 'babel-loader',
            options: {
              presets: ['@babel/preset-env'],
              plugins: [
                '@babel/plugin-proposal-class-properties',
                '@babel/plugin-proposal-private-methods',
                '@babel/plugin-proposal-private-property-in-object'
              ]
            }
          }
        }
      ]
    }
  },
  {
    name: 'esm',
    mode: 'production',
    entry: './app/javascript/skeleton_loader.js',
    output: {
      filename: 'skeleton_loader.js',
      path: path.resolve(__dirname, 'dist'),
      library: {
        type: 'module'
      },
      clean: true
    },
    module: {
      rules: [
        {
          test: /\.js$/,
          exclude: /node_modules/,
          use: {
            loader: 'babel-loader',
            options: {
              presets: ['@babel/preset-env'],
              plugins: [
                '@babel/plugin-proposal-class-properties',
                '@babel/plugin-proposal-private-methods',
                '@babel/plugin-proposal-private-property-in-object'
              ]
            }
          }
        }
      ]
    },
    experiments: {
      outputModule: true
    }
  }
];