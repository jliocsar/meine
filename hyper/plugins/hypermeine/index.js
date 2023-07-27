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

module.exports = {
  decorateConfig,
  decorateHyper: (Hyper, args) =>
    decorateHyperWithDockerComposeStatus(
      decorateHyperWithSshStatus(
        decorateHyperWithJiraCard(
          decorateHyperWithUsdBrlConversion(Hyper, args),
          args,
        ),
        args,
      ),
      args,
    ),
}
