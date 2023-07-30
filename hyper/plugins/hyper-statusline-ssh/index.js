const { exec } = require('child_process')

const {
  MeineComponentClassNameMap,
  classNameToSelector,
} = require('../../hyper-base')
const { getExistingCustomChildren } = require('../utils')
const { HypermeineStatusline } = require('../base-hypermeine-status')

module.exports.decorateHyper = (Hyper, { React }) => {
  const componentClassName = `component_component ${MeineComponentClassNameMap.Ssh}`
  const componentSelector = classNameToSelector(componentClassName)

  return class extends HypermeineStatusline({ React, componentSelector }) {
    constructor(props) {
      super(props)

      this.state = {
        ssh: {},
        showInstances: false,
      }
    }

    render() {
      const props = this.props
      const { ssh, showInstances } = this.state
      const existingChildren = getExistingCustomChildren(props)
      const openSshInstances = Object.entries(ssh)
      const hasRunningInstances = !!openSshInstances?.length
      return React.createElement(
        Hyper,
        Object.assign({}, props, {
          customChildren: existingChildren.concat(
            React.createElement(
              'div',
              {
                onMouseEnter: () => this.setState({ showInstances: true }),
                onMouseLeave: () => this.setState({ showInstances: false }),
                className: componentClassName,
                ...(!hasRunningInstances && {
                  style: {
                    display: 'none',
                  },
                }),
              },
              React.createElement(
                'div',
                { className: 'component_item' },
                hasRunningInstances
                  ? React.createElement(
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
                          },
                        },
                        '󰣀',
                      ),
                      openSshInstances.map(([sshInstance, instances], index) =>
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
                      ),
                    )
                  : null,
              ),
              showInstances
                ? React.createElement(
                    'div',
                    { className: 'meine_tooltip' },
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

    grepSsh() {
      exec('ps -ef | grep "ssh .*"', (err, stdout) => {
        if (err) {
          console.error(err)
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
        return this.setState({ ssh })
      })
    }

    componentDidMount() {
      this.interval = setInterval(this.grepSsh.bind(this), 100)
    }

    componentWillUnmount() {
      clearInterval(this.interval)
    }
  }
}
