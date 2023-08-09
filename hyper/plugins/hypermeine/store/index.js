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

const HyperActionType = {
  SessionAdd: 'SESSION_ADD',
  SessionPtyData: 'SESSION_PTY_DATA',
}

const R = {
  [GREP_YARN_RESULT]: grepYarnResult,
  [GREP_DOCKER_COMPOSE_RESULT]: grepDockerResult,
  [GREP_SSH_RESULT]: grepSshResult,
  [GREP_GIT_BRANCHES_RESULT]: grepGitBranchesResult,
  [GREP_ACTIVE_PORTS_RESULT]: grepActivePortsResult,
}
const resolvers = Object.values(R)

module.exports.middleware = store => next => action => {
  switch (action.type) {
    case HyperActionType.SessionAdd:
    case HyperActionType.SessionAddData:
    case HyperActionType.SessionPtyData: {
      for (const { dispatcher } of resolvers) {
        dispatcher(store)
      }
      break
    }
    default: {
      break
    }
  }
  return next(action)
}

module.exports.reduceUI = (state, action) => {
  if (action.data) {
    const handler = R[action.type]?.handler
    if (!handler) {
      return state
    }
    return handler(state, action)
  }
  return state
}

module.exports.mapHyperState = (state, map) => {
  return Object.assign(map, {
    dockerComposeCommand: state.ui.dockerComposeCommand,
    yarnCommand: state.ui.yarnCommand,
    gitBranches: state.ui.gitBranches,
    activePorts: state.ui.activePorts,
    ssh: state.ui.ssh,
  })
}
