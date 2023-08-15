const {
  decorateHyperWithMeineComponentToggler,
  decorateHyperWithLocalhostActivePorts,
  decorateHyperWithIpAddress,
  decorateHyperWithGitBranchesHistory,
  decorateHyperWithUsdBrlConversion,
  decorateHyperWithJiraCard,
  decorateHyperWithSshStatus,
  decorateHyperWithDockerComposeStatus,
  decorateHyperWithRunningYarnCommand,
  decorateHyperWithGraphQLInspector,
} = require('..')
const { decorateConfig } = require('../hypermeine-config')
const { middleware, reduceUI, mapHyperState } = require('./store')

const decorate =
  (...decorators) =>
  (Hyper, args) =>
    decorators.reduce(
      (Component, decorator) => decorator(Component, args),
      Hyper,
    )

module.exports = {
  decorateHyper: (Hyper, args) =>
    decorate(
      decorateHyperWithMeineComponentToggler,
      decorateHyperWithLocalhostActivePorts,
      decorateHyperWithGraphQLInspector,
      decorateHyperWithIpAddress,
      decorateHyperWithGitBranchesHistory,
      decorateHyperWithUsdBrlConversion,
      decorateHyperWithJiraCard,
      decorateHyperWithSshStatus,
      decorateHyperWithDockerComposeStatus,
      decorateHyperWithRunningYarnCommand,
    )(Hyper, args),
  decorateConfig,
  middleware,
  reduceUI,
  mapHyperState,
}
