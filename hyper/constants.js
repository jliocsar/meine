const MEINE_COMPONENT_CLASS_NAME = 'meine_component'

const componentClassName = className =>
  `${MEINE_COMPONENT_CLASS_NAME} ${className}`

const JIRA_LINK_COMPONENT_CLASS_NAME = 'component_jira_link'
const USD_BRL_CONVERSION_COMPONENT_CLASS_NAME = 'component_usd_brl_conv'
const SSH_COMPONENT_CLASS_NAME = 'component_ssh'
const DOCKER_COMPOSE_COMPONENT_CLASS_NAME = 'component_docker_compose'
const IP_ADDRESS_COMPONENT_CLASS_NAME = 'component_ip_address'
const YARN_COMMAND_COMPONENT_CLASS_NAME = 'component_yarn'
const GIT_BRANCHES_HISTORY_COMPONENT_CLASS_NAME =
  'component_git_branches_history'
const MEINE_COMPONENT_TOGGLER_COMPONENT_CLASS_NAME =
  'component_meine_component_toggler'

module.exports.plugins = [
  'hyper-statusline',
  'hyper-hide-scroll',
  'hyperminimal',
  'hyperterm-safepaste',
]
module.exports.localPlugins = ['hypermeine']
module.exports.MeineComponentClassNameMap = {
  Default: MEINE_COMPONENT_CLASS_NAME,
  Jira: componentClassName(JIRA_LINK_COMPONENT_CLASS_NAME),
  UsdBrlConversion: componentClassName(USD_BRL_CONVERSION_COMPONENT_CLASS_NAME),
  Ssh: componentClassName(SSH_COMPONENT_CLASS_NAME),
  DockerCompose: componentClassName(DOCKER_COMPOSE_COMPONENT_CLASS_NAME),
  IpAddress: componentClassName(IP_ADDRESS_COMPONENT_CLASS_NAME),
  Yarn: componentClassName(YARN_COMMAND_COMPONENT_CLASS_NAME),
  GitBranchesHistory: componentClassName(
    GIT_BRANCHES_HISTORY_COMPONENT_CLASS_NAME,
  ),
  ComponentToggler: componentClassName(
    MEINE_COMPONENT_TOGGLER_COMPONENT_CLASS_NAME,
  ),
}
module.exports.MeineComponentLabelMap = {
  [DOCKER_COMPOSE_COMPONENT_CLASS_NAME]: 'docker-compose',
  [GIT_BRANCHES_HISTORY_COMPONENT_CLASS_NAME]: 'Git branches',
  [IP_ADDRESS_COMPONENT_CLASS_NAME]: 'IP Addresses',
  [JIRA_LINK_COMPONENT_CLASS_NAME]: 'Jira Ticket',
  [SSH_COMPONENT_CLASS_NAME]: 'SSH Instances',
  [YARN_COMMAND_COMPONENT_CLASS_NAME]: 'Yarn Command',
  [USD_BRL_CONVERSION_COMPONENT_CLASS_NAME]: 'USD/BRL Conversion',
}
