module.exports.MEINE_COMPONENT_CLASS_NAME = 'meine_component'

const componentClassName = className =>
  `${this.MEINE_COMPONENT_CLASS_NAME} ${className}`

// #region Meine components
module.exports.JIRA_LINK_COMPONENT_CLASS_NAME = 'component_jira_link'
module.exports.USD_BRL_CONVERSION_COMPONENT_CLASS_NAME =
  'component_usd_brl_conv'
module.exports.SSH_COMPONENT_CLASS_NAME = 'component_ssh'
module.exports.DOCKER_COMPOSE_COMPONENT_CLASS_NAME = 'component_docker_compose'
module.exports.IP_ADDRESS_COMPONENT_CLASS_NAME = 'component_ip_address'
module.exports.YARN_COMMAND_COMPONENT_CLASS_NAME = 'component_yarn'
module.exports.GIT_BRANCHES_HISTORY_COMPONENT_CLASS_NAME =
  'component_git_branches_history'
module.exports.LOCALHOST_PORTS_COMPONENT_CLASS_NAME =
  'component_localhost_ports'
module.exports.MEINE_COMPONENT_TOGGLER_COMPONENT_CLASS_NAME =
  'component_meine_component_toggler'
// #endregion

// #region Other components
module.exports.COMPONENT_CWD_CLASS_NAME = 'component_cwd'
// #endregion

module.exports.MeineComponentClassNameMap = {
  Default: this.MEINE_COMPONENT_CLASS_NAME,
  Cwd: this.COMPONENT_CWD_CLASS_NAME,
  Jira: componentClassName(this.JIRA_LINK_COMPONENT_CLASS_NAME),
  UsdBrlConversion: componentClassName(
    this.USD_BRL_CONVERSION_COMPONENT_CLASS_NAME,
  ),
  Ssh: componentClassName(this.SSH_COMPONENT_CLASS_NAME),
  DockerCompose: componentClassName(this.DOCKER_COMPOSE_COMPONENT_CLASS_NAME),
  IpAddress: componentClassName(this.IP_ADDRESS_COMPONENT_CLASS_NAME),
  Yarn: componentClassName(this.YARN_COMMAND_COMPONENT_CLASS_NAME),
  GitBranchesHistory: componentClassName(
    this.GIT_BRANCHES_HISTORY_COMPONENT_CLASS_NAME,
  ),
  ComponentToggler: componentClassName(
    this.MEINE_COMPONENT_TOGGLER_COMPONENT_CLASS_NAME,
  ),
  LocalhostPorts: componentClassName(this.LOCALHOST_PORTS_COMPONENT_CLASS_NAME),
}
module.exports.MeineComponentLabelMap = {
  [this.DOCKER_COMPOSE_COMPONENT_CLASS_NAME]: 'docker-compose',
  [this.GIT_BRANCHES_HISTORY_COMPONENT_CLASS_NAME]: 'Git branches',
  [this.IP_ADDRESS_COMPONENT_CLASS_NAME]: 'IP Addresses',
  [this.JIRA_LINK_COMPONENT_CLASS_NAME]: 'Jira Ticket',
  [this.SSH_COMPONENT_CLASS_NAME]: 'SSH Instances',
  [this.YARN_COMMAND_COMPONENT_CLASS_NAME]: 'Yarn Command',
  [this.USD_BRL_CONVERSION_COMPONENT_CLASS_NAME]: 'USD/BRL Conversion',
  [this.LOCALHOST_PORTS_COMPONENT_CLASS_NAME]: 'Localhost Ports',
  [this.COMPONENT_CWD_CLASS_NAME]: 'Current folder',
}

module.exports.FOOTER_SELECTOR = '.footer_footer'
module.exports.LEFT_FOOTER_GROUP_SELECTOR = `${this.FOOTER_SELECTOR} .footer_group:first-child`
module.exports.RIGHT_FOOTER_GROUP_SELECTOR = `${this.FOOTER_SELECTOR} .footer_group:last-child`
