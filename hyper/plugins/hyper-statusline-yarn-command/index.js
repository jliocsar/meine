const { exec } = require('child_process')

const {
  classNameToSelector,
  getExistingCustomChildren,
} = require('../../utils')
const { MeineComponentClassNameMap } = require('../../constants')
const { buildTooltip } = require('../../components/tooltip')
const { HypermeineStatusline } = require('../base-hypermeine-status')

const grepYarn = store =>
  exec('ps -ef | grep "/bin/yarn"', (error, stdout) => {
    if (error) {
      console.error(error)
      return
    }
    const [runningCommandMatch] = stdout
      .split('\n')
      .filter(line => line && !line.includes('grep'))
    if (!runningCommandMatch) {
      return store.dispatch({
        type: this.GREP_YARN_RESULT,
        data: {
          command: '',
          commandArgs: [],
        },
      })
    }
    const [command, ...commandArgs] = runningCommandMatch
      .replace(/.*\/bin\/yarn\s/, '')
      .split(' ')
    return store.dispatch({
      type: this.GREP_YARN_RESULT,
      data: {
        command,
        commandArgs,
      },
    })
  })

module.exports.GREP_YARN_RESULT = 'GREP_YARN_RESULT'
module.exports.grepYarn = grepYarn
module.exports.decorateHyper = (Hyper, { React }) => {
  const MAX_COMMAND_CHARACTERS_LENGTH = 26
  const componentClassName = `component_component ${MeineComponentClassNameMap.Yarn}`
  const componentSelector = classNameToSelector(componentClassName)

  return class extends HypermeineStatusline({ React, componentSelector }) {
    constructor(props) {
      super(props)

      this.state = {
        showCommandArgs: false,
      }
    }

    render() {
      const props = this.props
      const { yarnCommand: { command, commandArgs } = {} } = store.getState().ui
      const { showCommandArgs } = this.state
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
                        ...(!command && {
                          marginRight: 0,
                        }),
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
  }
}
