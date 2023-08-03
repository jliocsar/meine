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
  decorateHyper: decorateHyperWithMeineComponentToggler,
} = require('../hyper-statusline-meine-component-toggler')

const decorate =
  (...decorators) =>
  (Hyper, args) =>
    decorators.reduce(
      (Component, decorator) => decorator(Component, args),
      Hyper,
    )

module.exports = {
  decorateConfig,
  decorateHyper: (Hyper, args) =>
    decorate(
      decorateHyperWithMeineComponentToggler,
      decorateHyperWithIpAddress,
      decorateHyperWithUsdBrlConversion,
      decorateHyperWithGitBranchesHistory,
      decorateHyperWithJiraCard,
      decorateHyperWithSshStatus,
      decorateHyperWithDockerComposeStatus,
      decorateHyperWithRunningYarnCommand,
    )(Hyper, args),
}
