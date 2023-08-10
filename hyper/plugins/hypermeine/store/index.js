const fs = require('fs')
const path = require('path')

const { defaultHyperMeineConfig } = require('../../../constants')
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

const HYPER_CONFIG_PATH = path.resolve(process.env.HOME, '.hyper.js')

const MEINE_CONFIG = 'MEINE_CONFIG'
const meineConfigReducer = {
  dispatcher: store =>
    // TODO: Find a better way to handle this
    fs.readFile(HYPER_CONFIG_PATH, (error, buffer) => {
      if (error) {
        console.error(error)
      }
      const data = JSON.parse(
        buffer
          .toString()
          .match(/meine:\s?{(.|\n)*?}/g)[0]
          .replace(/meine:\s?/, '')
          .replace(/(\w+):/g, '"$1":')
          .replace(/[\s\n]/g, '')
          .replace(/,}$/, '}'),
      )
      return store.dispatch({
        data,
        type: MEINE_CONFIG,
      })
    }),
  reducer: (state, action) =>
    state.set(
      'meineConfig',
      Object.assign({}, defaultHyperMeineConfig, action.data),
    ),
}

const HyperActionType = {
  SessionAdd: 'SESSION_ADD',
  SessionPtyData: 'SESSION_PTY_DATA',
  ConfigReload: 'CONFIG_RELOAD',
}

const R = {
  [MEINE_CONFIG]: meineConfigReducer,
  [GREP_YARN_RESULT]: grepYarnResult,
  [GREP_DOCKER_COMPOSE_RESULT]: grepDockerResult,
  [GREP_SSH_RESULT]: grepSshResult,
  [GREP_GIT_BRANCHES_RESULT]: grepGitBranchesResult,
  [GREP_ACTIVE_PORTS_RESULT]: grepActivePortsResult,
}
const resolvers = Object.values(R).slice(1)

module.exports.middleware = store => next => action => {
  const actionType = action.type
  const isReloadingConfig = [
    HyperActionType.ConfigReload,
    HyperActionType.SessionAdd,
  ].includes(actionType)
  const isAddingData = [
    HyperActionType.SessionAdd,
    HyperActionType.SessionPtyData,
  ].includes(actionType)
  if (isReloadingConfig) {
    R[MEINE_CONFIG].dispatcher(store)
  }
  if (isAddingData) {
    for (const { dispatcher } of resolvers) {
      dispatcher(store)
    }
  }
  return next(action)
}

module.exports.reduceUI = (state, action) => {
  if (action.data) {
    const reducer = R[action.type]?.reducer
    if (!reducer) {
      return state
    }
    return reducer(state, action)
  }
  return state
}

// TODO: Check if this is really necessary
module.exports.mapHyperState = (state, map) => {
  return Object.assign(map, {
    meineConfig: state.ui.meineConfig,
    dockerComposeCommand: state.ui.dockerComposeCommand,
    yarnCommand: state.ui.yarnCommand,
    gitBranches: state.ui.gitBranches,
    activePorts: state.ui.activePorts,
    ssh: state.ui.ssh,
  })
}
