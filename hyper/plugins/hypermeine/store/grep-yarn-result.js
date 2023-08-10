const { debounce } = require('../../../utils')
const { grepYarn } = require('../../hyper-statusline-yarn-command')

module.exports = {
  dispatcher: debounce(grepYarn),
  reducer: (state, action) => {
    const { command, commandArgs } = action.data
    return state.set('yarnCommand', {
      command,
      commandArgs,
    })
  },
}
