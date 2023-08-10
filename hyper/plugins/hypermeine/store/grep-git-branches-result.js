const { debounce } = require('../../../utils')
const {
  grepGitBranchesHistory,
} = require('../../hyper-statusline-git-branches-history')

module.exports = {
  dispatcher: debounce(grepGitBranchesHistory),
  reducer: (state, action) => {
    const { history } = action.data
    return state.set('gitBranches', { history })
  },
}
