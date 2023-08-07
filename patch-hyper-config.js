const fs = require('node:fs')
const path = require('node:path')
const { env, stdout } = require('node:process')
const { plugins, localPlugins } = require('./hyper/plugins')

const HYPER_JS_FILE_PATH = path.resolve(env.HOME, '.hyper.js')

const pipe =
  (...fns) =>
  x =>
    fns.reduce((y, f) => f(y), x)
const toJsArray = array => `[${array.map(item => `'${item}'`).join(', ')}]`
const hyperJsConfigKeyReplace = (key, value) => hyperJs =>
  hyperJs.replace(new RegExp(`${key}:\\s?\\[(\\s|.)*?\\s?\\]`), value)

fs.readFile(HYPER_JS_FILE_PATH, (error, data) => {
  if (error) {
    throw error
  }
  const hyperJs = data.toString()
  const updatedHyperJs = pipe(
    hyperJsConfigKeyReplace('plugins', `plugins: ${toJsArray(plugins)}`),
    hyperJsConfigKeyReplace(
      'localPlugins',
      `localPlugins: ${toJsArray(localPlugins)}`,
    ),
  )(hyperJs)

  fs.writeFile(HYPER_JS_FILE_PATH, updatedHyperJs, error => {
    if (error) {
      throw error
    }
    stdout.write('Hyper.js config updated\n')
  })
})
