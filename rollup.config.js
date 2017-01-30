var purs = require('rollup-plugin-purs');
var resolve = require('rollup-plugin-node-resolve');

export default {
  entry: 'src/Main.purs',
  dest: 'app.js',
  format: 'es',
  sourceMap: true,
  treeshake: true,
  plugins: [
    purs({
      outputDir: 'output',
      inline: true,
      uncurry: true
    }),
    resolve()
  ]
};
