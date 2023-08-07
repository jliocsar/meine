const { exec } = require('child_process')

const {
  classNameToSelector,
  getExistingCustomChildren,
} = require('../../utils')
const { buildTooltip } = require('../../components/tooltip')
const { MeineComponentClassNameMap } = require('../../constants')
const { HypermeineStatusline } = require('../base-hypermeine-status')

const COMMAND_MATCH = 'gc[ob]'

const grepGitBranchesHistory = () =>
  exec(`cat ~/.zsh_history | grep ":0;${COMMAND_MATCH}"`, (err, stdout) => {
    if (err) {
      console.error(err)
      return
    }
    const gitBranchesCommands = stdout.split('\n')
    const history = gitBranchesCommands.reduce((acc, commandHistory, index) => {
      const commandMatchRegex = new RegExp(`^${COMMAND_MATCH}`)
      const command = commandHistory.replace(/:\s\d+:0;/, '')
      const isGitBranchCommand = commandMatchRegex.test(command)
      if (isGitBranchCommand) {
        const branchName = command.replace(commandMatchRegex, '').trim()
        if (branchName && !/^-/.test(branchName)) {
          acc.push({ branchName, index })
        }
      }
      return acc
    }, [])
    return store.dispatch({
      type: this.GREP_GIT_BRANCHES_RESULT,
      data: {
        history: history.slice(history.length - 10),
      },
    })
  })

module.exports.GREP_GIT_BRANCHES_RESULT = 'GREP_GIT_BRANCHES_RESULT'
module.exports.grepGitBranchesHistory = grepGitBranchesHistory
module.exports.decorateHyper = (Hyper, { React }) => {
  const componentClassName = `component_component ${MeineComponentClassNameMap.GitBranchesHistory}`
  const componentSelector = classNameToSelector(componentClassName)
  const Tooltip = buildTooltip({ React })

  return class extends HypermeineStatusline({ React, componentSelector }) {
    constructor(props) {
      super(props)

      this.state = {
        showHistory: false,
      }
    }

    render() {
      const props = this.props
      const { gitBranches: { history } = {} } = store.getState().ui
      const { showHistory } = this.state
      const existingChildren = getExistingCustomChildren(props)

      const handleMouseEnter = () =>
        this.setState({ showHistory: !!history?.length })
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
                onMouseLeave: () => this.setState({ showHistory: false }),
                className: componentClassName,
                ...(!history?.length && {
                  style: {
                    display: 'none',
                  },
                }),
              },
              React.createElement(
                'div',
                {
                  ...tooltipProps,
                  style: {
                    display: 'flex',
                    alignItems: 'center',
                  },
                  className: 'component_item',
                },
                React.createElement(
                  'span',
                  {
                    className: 'component_icon logo_icon',
                    style: {
                      fontSize: 20,
                    },
                  },
                  '󰘬',
                ),
                'Branches',
              ),
              showHistory
                ? React.createElement(
                    Tooltip,
                    tooltipProps,
                    React.createElement(
                      'ol',
                      { style: { listStyleType: 'none' } },
                      history.map(({ branchName, index }) =>
                        React.createElement(
                          'li',
                          {},
                          index + 1,
                          '. ',
                          React.createElement(
                            'span',
                            { className: 'arg_arg' },
                            branchName,
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
