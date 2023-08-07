const { debounce } = require('../../../utils')
const { grepDockerCompose } = require('../../hyper-statusline-docker-compose')

module.exports = {
  dispatcher: debounce(grepDockerCompose),
  handler: (state, action) => {
    const { isRunning } = action.data
    return state.set('dockerComposeCommand', { isRunning })
  },
}
