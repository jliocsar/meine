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
                      {},
                      history.map((entry, index) =>
                        React.createElement(
                          'li',
                          {},
                          index + 1,
                          '. ',
                          React.createElement(
                            'span',
                            { className: 'arg_arg' },
                            entry,
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
        const commandsLength = gitBranchesCommands.length
        const history = gitBranchesCommands
          .reduce((acc, commandHistory) => {
            const commandMatchRegex = new RegExp(`^${commandMatch}`)
            const command = commandHistory.replace(/:\s\d+:0;/, '')
            const isGitBranchCommand = commandMatchRegex.test(command)
            if (isGitBranchCommand) {
              acc.push(command.replace(commandMatchRegex, '').trim())
            }
            return acc
          }, [])
          .reverse()
          .slice(commandsLength - 12)
        return this.setState({ history })
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
