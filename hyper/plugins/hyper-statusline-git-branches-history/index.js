const { exec } = require('child_process')

const {
  MeineComponentClassNameMap,
  classNameToSelector,
} = require('../../hyper-base')
const { getExistingCustomChildren } = require('../utils')
const { HypermeineStatusline } = require('../base-hypermeine-status')

module.exports.decorateHyper = (Hyper, { React }) => {
  const componentClassName = `component_component ${MeineComponentClassNameMap.GitBranchesHistory}`
  const componentSelector = classNameToSelector(componentClassName)

  return class extends HypermeineStatusline({ React, componentSelector }) {
    constructor(props) {
      super(props)

      this.state = {
        history: [],
        showHistory: false,
      }
    }

    render() {
      const props = this.props
      const { history, showHistory } = this.state
      const existingChildren = getExistingCustomChildren(props)

      return React.createElement(
        Hyper,
        Object.assign({}, props, {
          customChildren: existingChildren.concat(
            React.createElement(
              'div',
              {
                onMouseEnter: () => this.setState({ showHistory: true }),
                onMouseLeave: () => this.setState({ showHistory: false }),
                className: componentClassName,
                ...(!history.length && {
                  style: {
                    display: 'none',
                  },
                }),
              },
              React.createElement(
                'div',
                {
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
                    'div',
                    { className: 'meine_tooltip' },
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

    grepGitBranchesHistory(commandMatch = 'gc[ob]') {
      exec(`cat ~/.zsh_history | grep ":0;${commandMatch}"`, (err, stdout) => {
        if (err) {
          console.error(err)
          return
        }
        const gitBranchesCommands = stdout.split('\n')
        const history = gitBranchesCommands.reduce(
          (acc, commandHistory, index) => {
            const commandMatchRegex = new RegExp(`^${commandMatch}`)
            const command = commandHistory.replace(/:\s\d+:0;/, '')
            const isGitBranchCommand = commandMatchRegex.test(command)
            if (isGitBranchCommand) {
              const branchName = command.replace(commandMatchRegex, '').trim()
              if (branchName && !/^-/.test(branchName)) {
                acc.push({ branchName, index })
              }
            }
            return acc
          },
          [],
        )
        return this.setState({
          history: history.slice(history.length - 10),
        })
      })
    }

    componentDidMount() {
      this.interval = setInterval(this.grepGitBranchesHistory.bind(this), 100)
    }

    componentWillUnmount() {
      clearInterval(this.interval)
    }
  }
}
