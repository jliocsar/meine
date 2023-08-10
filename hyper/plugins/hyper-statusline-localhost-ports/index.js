const { exec } = require('child_process')
const { shell } = require('electron')

const {
  classNameToSelector,
  getExistingCustomChildren,
} = require('../../utils')
const { MeineComponentClassNameMap } = require('../../constants')
const { buildTooltip } = require('../../components/tooltip')
const { HypermeineStatusline } = require('../base-hypermeine-status')

const grepActivePorts = store =>
  exec('ss -nltp | grep pid', (error, stdout) => {
    if (error) {
      return
    }

    const activePorts = stdout.split('\n').reduce((ports, proc) => {
      const match = proc.match(/127\.0\.0\.1:(\d+).*"(.*)",pid=/)
      if (!match) {
        return ports
      }
      const [, port, command] = match
      return ports.concat({
        command,
        port: Number(port),
      })
    }, [])
    store.dispatch({
      type: this.GREP_ACTIVE_PORTS_RESULT,
      data: { activePorts },
    })
  })

module.exports.GREP_ACTIVE_PORTS_RESULT = 'GREP_ACTIVE_PORTS_RESULT'
module.exports.grepActivePorts = grepActivePorts
module.exports.decorateHyper = (Hyper, { React }) => {
  const componentClassName = `component_component ${MeineComponentClassNameMap.LocalhostPorts}`
  const componentSelector = classNameToSelector(componentClassName)
  const Tooltip = buildTooltip({ React })

  return class extends HypermeineStatusline({ React, componentSelector }) {
    constructor(props) {
      super(props)

      this.state = {
        showActivePorts: false,
      }
    }

    render() {
      const props = this.props
      const { activePorts = [] } = store.getState().ui
      const { showActivePorts } = this.state
      const existingChildren = getExistingCustomChildren(props)
      const hasPorts = !!activePorts.length

      const handleMouseEnter = () => this.setState({ showActivePorts: true })
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
                ...(!hasPorts && {
                  style: {
                    display: 'none',
                  },
                }),
                onMouseLeave: () => this.setState({ showActivePorts: false }),
                className: componentClassName,
              },
              React.createElement(
                'div',
                {
                  ...tooltipProps,
                  className: 'component_item',
                },
                React.createElement(
                  'span',
                  {
                    className: 'component_icon logo_icon',
                    style: {
                      fontSize: 20,
                      marginRight: 0,
                      marginBottom: 1,
                    },
                  },
                  '󱠞',
                ),
              ),
              hasPorts && showActivePorts
                ? React.createElement(
                    Tooltip,
                    tooltipProps,
                    React.createElement(
                      'ul',
                      {
                        style: {
                          listStyleType: 'none',
                        },
                      },
                      activePorts.map(({ port, command }) =>
                        React.createElement(
                          'li',
                          {
                            className: 'item_clickable',
                            style: {
                              display: 'flex',
                              alignItems: 'center',
                            },
                            onClick: () => this.handleActivePortClick(port),
                          },
                          React.createElement(
                            'p',
                            { className: 'arg_num' },
                            'localhost:',
                            port,
                            ` (${command})`,
                            React.createElement(
                              'span',
                              {
                                className: 'arg_default',
                                style: {
                                  fontSize: 12,
                                  marginLeft: 4,
                                },
                              },
                              '',
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

    handleActivePortClick(port) {
      shell.openExternal(`http://localhost:${port}`)
    }
  }
}
