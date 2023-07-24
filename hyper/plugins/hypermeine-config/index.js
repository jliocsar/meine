const { baseConfig } = require('../../hyper-base')

module.exports.decorateConfig = config => {
  const updatedConfig = Object.assign({}, config, baseConfig)
  if (config.css) {
    updatedConfig.css = config.css + '\n' + baseConfig.css
  }
  if (config.termCSS) {
    updatedConfig.termCSS = config.termCSS + '\n' + baseConfig.termCSS
  }
  if (config.colors) {
    updatedConfig.colors = Object.assign({}, config.colors, baseConfig.colors)
  }
  return updatedConfig
}
