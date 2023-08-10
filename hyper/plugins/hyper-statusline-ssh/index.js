const { exec } = require('child_process')

const {
  classNameToSelector,
  getExistingCustomChildren,
} = require('../../utils')
const { MeineComponentClassNameMap } = require('../../constants')
const { buildTooltip } = require('../../components/tooltip')
const { HypermeineStatusline } = require('../base-hypermeine-status')

const grepSsh = store =>
  exec('ps -ef | grep "ssh .*"', (error, stdout) => {
    if (error) {
      console.error(error)
      return
    }
    const ssh = {}
    const openSshInstances = stdout
      .split('\n')
      .filter(line => line && !line.includes('grep'))
    if (openSshInstances) {
      for (const instance of openSshInstances) {
        const parts = instance.split(' ')
        const lastPart = parts[parts.length - 1].replace(/'/g, '')
        const sshCommand = instance.replace(/.*(?=ssh)/, '')
        if (ssh[lastPart]) {
          ssh[lastPart].push(sshCommand)
        } else {
          ssh[lastPart] = [sshCommand]
        }
      }
    }
    return store.dispatch({
      type: this.GREP_SSH_RESULT,
      data: { ssh },
    })
  })

module.exports.GREP_SSH_RESULT = 'GREP_SSH_RESULT'
module.exports.grepSsh = grepSsh
module.exports.decorateHyper = (Hyper, { React }) => {
  const componentClassName = `component_component ${MeineComponentClassNameMap.Ssh}`
  const componentSelector = classNameToSelector(componentClassName)
  const Tooltip = buildTooltip({ React })

  return class extends HypermeineStatusline({ React, componentSelector }) {
    constructor(props) {
      super(props)

      this.state = {
        showInstances: false,
      }
    }

    render() {
      const props = this.props
      const { ssh = {}, meineConfig = {} } = store.getState().ui
      const { showInstances } = this.state
      const existingChildren = getExistingCustomChildren(props)
      const openSshInstances = Object.entries(ssh)
      const hasRunningInstances = !!openSshInstances?.length

      const handleMouseEnter = () =>
        this.setState({ showInstances: hasRunningInstances })
      const tooltipProps = {
        onMouseEnter: handleMouseEnter,
      }

      return React.createElement(
        Hyper,
        Object.assign({}, props, {
          customChildren: existingChildren.concat(
            React.createElement(
              'div',
              {
                onMouseLeave: () => this.setState({ showInstances: false }),
                className: componentClassName,
                ...((!meineConfig.ssh || !hasRunningInstances) && {
                  style: {
                    display: 'none',
                  },
                }),
              },
              React.createElement(
                'div',
                {
                  ...tooltipProps,
                  className: 'component_item',
                },
                React.createElement(
                  'div',
                  {
                    style: {
                      display: 'flex',
                      alignItems: 'center',
                    },
                  },
                  React.createElement(
                    'span',
                    {
                      className: 'component_icon logo_icon',
                      style: {
                        fontSize: 28,
                        ...(!hasRunningInstances && {
                          marginRight: 0,
                        }),
                      },
                    },
                    '󰣀',
                  ),
                  hasRunningInstances
                    ? openSshInstances.map(([sshInstance, instances], index) =>
                        React.createElement(
                          'p',
                          {
                            style: {
                              fontSize: 12,
                              marginLeft: index ? 8 : 0,
                            },
                          },
                          sshInstance,
                          React.createElement(
                            'small',
                            {
                              style: {
                                fontSize: 10,
                                marginLeft: 4,
                                color: 'rgba(255, 255, 255, 0.5)',
                              },
                            },
                            '(',
                            instances.length,
                            ')',
                          ),
                        ),
                      )
                    : null,
                ),
              ),
              showInstances
                ? React.createElement(
                    Tooltip,
                    tooltipProps,
                    openSshInstances.flatMap(([instanceName, instances]) =>
                      React.createElement(
                        'ol',
                        {},
                        instances.map(instance =>
                          React.createElement(
                            'li',
                            {},
                            instanceName,
                            ': ',
                            React.createElement(
                              'span',
                              { className: 'arg_arg' },
                              `'${instance}'`,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : null,
            ),
          ),
        }),
      )
    }
  }
}
