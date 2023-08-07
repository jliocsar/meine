const { grepSsh } = require('../../hyper-statusline-ssh')

module.exports = {
  dispatcher: grepSsh,
  handler: (state, action) => {
    const { ssh } = action.data
    return state.set('ssh', ssh)
  },
}
