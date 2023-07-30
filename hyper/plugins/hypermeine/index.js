const {
  decorateConfig,
} = require('/home/jungledevs/.meine/hyper/plugins/hypermeine-config')
const {
  decorateHyper: decorateHyperWithUsdBrlConversion,
} = require('/home/jungledevs/.meine/hyper/plugins/hyper-statusline-usd-brl-conversion')
const {
  decorateHyper: decorateHyperWithJiraCard,
} = require('/home/jungledevs/.meine/hyper/plugins/hyper-statusline-jira-link')
const {
  decorateHyper: decorateHyperWithSshStatus,
} = require('/home/jungledevs/.meine/hyper/plugins/hyper-statusline-ssh')
const {
  decorateHyper: decorateHyperWithDockerComposeStatus,
} = require('/home/jungledevs/.meine/hyper/plugins/hyper-statusline-docker-compose')
const {
  decorateHyper: decorateHyperWithIpAddress,
} = require('/home/jungledevs/.meine/hyper/plugins/hyper-statusline-ip-address')
const {
  decorateHyper: decorateHyperWithRunningYarnCommand,
} = require('/home/jungledevs/.meine/hyper/plugins/hyper-statusline-yarn-command')
const {
  decorateHyper: decorateHyperWithGitBranchesHistory,
} = require('/home/jungledevs/.meine/hyper/plugins/hyper-statusline-git-branches-history')

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
      decorateHyperWithIpAddress,
      decorateHyperWithUsdBrlConversion,
      decorateHyperWithGitBranchesHistory,
      decorateHyperWithJiraCard,
      decorateHyperWithSshStatus,
      decorateHyperWithDockerComposeStatus,
      decorateHyperWithRunningYarnCommand,
    )(Hyper, args),
}
