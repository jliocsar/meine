const fs = require('node:fs')
const path = require('path')
const { env, stdout } = require('node:process')

const { plugins, localPlugins } = require('./hyper/constants')

const HYPER_JS_FILE_PATH = path.resolve(env.HOME, '.hyper.js')

const createJsObjectArrayKeyMatcher = key =>
  new RegExp(
    `${key}:\\s?\\[(\\n?(\\s*["'][a-z-]+["']\\,?\\n?)+)*\\n?(\\s+)?\\]`,
    'g',
  )
const createJsObjectArrayKeyStringValue = value =>
  JSON.stringify(value, null, 4).replace(/"/g, "'").replace(']', '  ]')

const pluginsMatchRegex = createJsObjectArrayKeyMatcher('plugins')
const localPluginsMatchRegex = createJsObjectArrayKeyMatcher('localPlugins')

fs.readFile(HYPER_JS_FILE_PATH, (error, data) => {
  if (error) {
    throw error
  }
  const pkg = data.toString()
  const [currentPlugins] = pkg.match(pluginsMatchRegex)
  const [currentLocalPlugins] = pkg.match(localPluginsMatchRegex)
  if (!currentPlugins) {
    throw new Error('No plugins found')
  }
  const stringifiedPlugins = createJsObjectArrayKeyStringValue(plugins)
  const stringifiedLocalPlugins =
    createJsObjectArrayKeyStringValue(localPlugins)
  const updatedHyperJs = pkg
    .replace(currentPlugins, `plugins: ${stringifiedPlugins}`)
    .replace(currentLocalPlugins, `localPlugins: ${stringifiedLocalPlugins}`)
  fs.writeFile(HYPER_JS_FILE_PATH, updatedHyperJs, error => {
    if (error) {
      throw error
    }
    stdout.write('Hyper.js config updated\n')
  })
})
