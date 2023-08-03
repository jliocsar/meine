const { exec } = require('child_process')

const {
  classNameToSelector,
  getExistingCustomChildren,
  queryMeineComponents,
} = require('../../utils')
const { MeineComponentClassNameMap } = require('../../constants')
const { buildTooltip } = require('../../components/tooltip')
const { HypermeineStatusline } = require('../base-hypermeine-status')

module.exports.decorateHyper = (Hyper, { React }) => {
  const MAX_COMMAND_CHARACTERS_LENGTH = 26
  const componentClassName = `component_component ${MeineComponentClassNameMap.Yarn}`
  const componentSelector = classNameToSelector(componentClassName)

  return class extends HypermeineStatusline({ React, componentSelector }) {
    constructor(props) {
      super(props)

      this.state = {
        command: '',
        commandArgs: [],
        showCommandArgs: false,
      }
    }

    render() {
      const props = this.props
      const { command, commandArgs, showCommandArgs } = this.state
      const existingChildren = getExistingCustomChildren(props)
      const Tooltip = buildTooltip({ React })

      const handleMouseEnter = () =>
        this.setState({ showCommandArgs: !!commandArgs.length })
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
                className: componentClassName,
                ...((!command ||
                  !commandArgs ||
                  command.length > MAX_COMMAND_CHARACTERS_LENGTH) && {
                  style: {
                    display: 'none',
                  },
                }),
              },
              React.createElement(
                'div',
                {
                  ...(commandArgs && {
                    ...tooltipProps,
                    onMouseLeave: () =>
                      this.setState({ showCommandArgs: false }),
                  }),
                  className: 'component_item',
                  style: {
                    display: 'flex',
                    alignItems: 'center',
                    lineHeight: 1,
                  },
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
                        fontSize: 20,
                      },
                    },
                    '',
                  ),
                  command,
                ),
              ),
              showCommandArgs
                ? React.createElement(
                    Tooltip,
                    tooltipProps,
                    'Arguments:',
                    React.createElement(
                      'ol',
                      { style: { marginTop: 2 } },
                      commandArgs.map((arg, index) =>
                        React.createElement(
                          'li',
                          {},
                          index + 1,
                          '. ',
                          React.createElement(
                            'span',
                            { className: 'arg_arg' },
                            `'${arg}'`,
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

    grepYarn() {
      exec('ps -ef | grep "/bin/yarn"', (error, stdout) => {
        if (error) {
          console.error(error)
          return
        }
        const [runningCommandMatch] = stdout
          .split('\n')
          .filter(line => line && !line.includes('grep'))
        if (!runningCommandMatch) {
          return this.setState({ command: '' })
        }
        const [command, ...commandArgs] = runningCommandMatch
          .replace(/.*\/bin\/yarn\s/, '')
          .split(' ')
        return this.setState({
          command,
          commandArgs,
        })
      })
    }

    componentDidMount() {
      this.grepInterval = setInterval(this.grepYarn.bind(this), 100)
    }

    componentWillUnmount() {
      clearInterval(this.grepInterval)
    }
  }
}
