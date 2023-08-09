const { decorateConfig } = require('../hypermeine-config')
const {
  decorateHyper: decorateHyperWithUsdBrlConversion,
} = require('../hyper-statusline-usd-brl-conversion')
const {
  decorateHyper: decorateHyperWithJiraCard,
} = require('../hyper-statusline-jira-link')
const {
  decorateHyper: decorateHyperWithSshStatus,
} = require('../hyper-statusline-ssh')
const {
  decorateHyper: decorateHyperWithDockerComposeStatus,
} = require('../hyper-statusline-docker-compose')
const {
  decorateHyper: decorateHyperWithIpAddress,
} = require('../hyper-statusline-ip-address')
const {
  decorateHyper: decorateHyperWithRunningYarnCommand,
} = require('../hyper-statusline-yarn-command')
const {
  decorateHyper: decorateHyperWithGitBranchesHistory,
} = require('../hyper-statusline-git-branches-history')
const {
  decorateHyper: decorateHyperWithLocalhostActivePorts,
} = require('../hyper-statusline-localhost-ports')
const {
  decorateHyper: decorateHyperWithMeineComponentToggler,
} = require('../hyper-statusline-meine-component-toggler')

const { R, resolvers } = require('./store')
const HyperActionType = {
  SessionAdd: 'SESSION_ADD',
  SessionAddData: 'SESSION_ADD_DATA',
  SessionPtyData: 'SESSION_PTY_DATA',
}

const decorate =
  (...decorators) =>
  (Hyper, args) =>
    decorators.reduce(
      (Component, decorator) => decorator(Component, args),
      Hyper,
    )

module.exports = {
  decorateConfig,
  middleware: store => next => action => {
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
  },
  reduceUI: (state, action) => {
    if (action.data) {
      const handler = R[action.type]?.handler
      if (!handler) {
        return state
      }
      return handler(state, action)
    }
    return state
  },
  mapHyperState: (state, map) => {
    return Object.assign(map, {
      yarnCommand: state.ui.yarnCommand,
    })
  },
  decorateHyper: (Hyper, args) =>
    decorate(
      decorateHyperWithMeineComponentToggler,
      decorateHyperWithLocalhostActivePorts,
      decorateHyperWithIpAddress,
      decorateHyperWithGitBranchesHistory,
      decorateHyperWithUsdBrlConversion,
      decorateHyperWithJiraCard,
      decorateHyperWithSshStatus,
      decorateHyperWithDockerComposeStatus,
      decorateHyperWithRunningYarnCommand,
    )(Hyper, args),
}
