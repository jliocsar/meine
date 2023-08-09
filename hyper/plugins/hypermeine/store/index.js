const {
  GREP_DOCKER_COMPOSE_RESULT,
} = require('../../hyper-statusline-docker-compose')
const {
  GREP_GIT_BRANCHES_RESULT,
} = require('../../hyper-statusline-git-branches-history')
const {
  GREP_ACTIVE_PORTS_RESULT,
} = require('../../hyper-statusline-localhost-ports')
const { GREP_SSH_RESULT } = require('../../hyper-statusline-ssh')
const { GREP_YARN_RESULT } = require('../../hyper-statusline-yarn-command')
const grepActivePortsResult = require('./grep-active-ports-result')

const grepDockerResult = require('./grep-docker-result')
const grepGitBranchesResult = require('./grep-git-branches-result')
const grepSshResult = require('./grep-ssh-result')
const grepYarnResult = require('./grep-yarn-result')

module.exports.R = {
  [GREP_YARN_RESULT]: grepYarnResult,
  [GREP_DOCKER_COMPOSE_RESULT]: grepDockerResult,
  [GREP_SSH_RESULT]: grepSshResult,
  [GREP_GIT_BRANCHES_RESULT]: grepGitBranchesResult,
  [GREP_ACTIVE_PORTS_RESULT]: grepActivePortsResult,
}
module.exports.resolvers = Object.values(this.R)
