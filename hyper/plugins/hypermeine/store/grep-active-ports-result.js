const { debounce } = require('../../../utils')
const { grepActivePorts } = require('../../hyper-statusline-localhost-ports')

module.exports = {
  dispatcher: debounce(grepActivePorts),
  reducer: (state, action) => {
    const { activePorts } = action.data
    return state.set('activePorts', activePorts)
  },
}
