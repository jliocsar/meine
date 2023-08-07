const { debounce } = require('../../../utils')
const { grepYarn } = require('../../hyper-statusline-yarn-command')

module.exports = {
  dispatcher: debounce(grepYarn),
  handler: (state, action) => {
    const { command, commandArgs } = action.data
    return state.set('yarnCommand', {
      command,
      commandArgs,
    })
  },
}
