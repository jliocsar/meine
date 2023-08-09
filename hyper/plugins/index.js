module.exports = {
  decorateHyperWithUsdBrlConversion:
    require('./hyper-statusline-usd-brl-conversion').decorateHyper,
  decorateHyperWithJiraCard: require('./hyper-statusline-jira-link')
    .decorateHyper,
  decorateHyperWithSshStatus: require('./hyper-statusline-ssh').decorateHyper,
  decorateHyperWithDockerComposeStatus:
    require('./hyper-statusline-docker-compose').decorateHyper,
  decorateHyperWithIpAddress: require('./hyper-statusline-ip-address')
    .decorateHyper,
  decorateHyperWithRunningYarnCommand:
    require('./hyper-statusline-yarn-command').decorateHyper,
  decorateHyperWithGitBranchesHistory:
    require('./hyper-statusline-git-branches-history').decorateHyper,
  decorateHyperWithLocalhostActivePorts:
    require('./hyper-statusline-localhost-ports').decorateHyper,
  decorateHyperWithMeineComponentToggler:
    require('./hyper-statusline-meine-component-toggler').decorateHyper,
}
