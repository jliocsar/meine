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
      console.error(error)
      return
    }

    const activePorts = Array.from(stdout.match(/127\.0\.0\.1:\d+/)).map(
      address => Number(address.replace('127.0.0.1:', '')),
    )
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
                onMouseLeave: () => this.setState({ showActivePorts: false }),
                className: componentClassName,
                style: {
                  display: 'none',
                },
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
                    style: { marginRight: 0 },
                  },
                  '󱠞',
                ),
              ),
              showActivePorts
                ? React.createElement(
                    Tooltip,
                    tooltipProps,
                    React.createElement(
                      'ul',
                      {},
                      activePorts.map(port =>
                        React.createElement(
                          'li',
                          {
                            onClick: () => this.handleActivePortClick(port),
                          },
                          port,
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
