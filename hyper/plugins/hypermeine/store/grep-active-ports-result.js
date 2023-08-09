const { grepActivePorts } = require('../../hyper-statusline-localhost-ports')

module.exports = {
  dispatcher: grepActivePorts,
  handler: (state, action) => {
    const { activePorts } = action.data
    return state.set('activePorts', activePorts)
  },
}
