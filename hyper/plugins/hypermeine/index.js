const {
  decorateConfig,
} = require('/home/jungledevs/.meine/hyper/plugins/hypermeine-config')
const {
  decorateHyper: decorateHyperWithUsdBrlConversion,
} = require('/home/jungledevs/.meine/hyper/plugins/hyper-statusline-usd-brl-conversion')
const {
  decorateHyper: decorateHyperWithJiraCard,
} = require('/home/jungledevs/.meine/hyper/plugins/hyper-statusline-jira-link')

module.exports = {
  decorateConfig,
  decorateHyper: (Hyper, args) => {
    const WithUsdBrlConversion = decorateHyperWithUsdBrlConversion(Hyper, args)
    // const WithJiraCard = decorateHyperWithJiraCard(WithUsdBrlConversion, args)
    return WithUsdBrlConversion
  },
}
