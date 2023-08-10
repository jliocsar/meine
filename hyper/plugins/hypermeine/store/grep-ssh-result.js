const { grepSsh } = require('../../hyper-statusline-ssh')

module.exports = {
  dispatcher: grepSsh,
  reducer: (state, action) => {
    const { ssh } = action.data
    return state.set('ssh', ssh)
  },
}
