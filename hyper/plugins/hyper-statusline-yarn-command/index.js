const { networkInterfaces } = require('os')
const { exec } = require('child_process')
const { shell } = require('electron')

const {
  MeineComponentClassNameMap,
  classNameToSelector,
} = require('../../hyper-base')
const { getExistingCustomChildren } = require('../utils')
const { HypermeineStatusline } = require('../base-hypermeine-status')

module.exports.decorateHyper = (Hyper, { React }) => {
  const componentClassName = `component_component ${MeineComponentClassNameMap.Yarn}`
  const componentSelector = classNameToSelector(componentClassName)

  return class extends HypermeineStatusline({ React, componentSelector }) {
    constructor(props) {
      super(props)

      this.state = {
        command: '',
      }
    }

    render() {
      const props = this.props
      const { command } = this.state
      const existingChildren = getExistingCustomChildren(props)
      return React.createElement(
        Hyper,
        Object.assign({}, props, {
          customChildren: existingChildren.concat(
            React.createElement(
              'div',
              {
                className: componentClassName,
                ...(!command && {
                  style: {
                    display: 'none',
                  },
                }),
              },
              React.createElement(
                'div',
                {
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
        const command = runningCommandMatch.replace(/.*\/bin\/yarn\s/, '')
        return this.setState({ command })
      })
    }

    componentDidMount() {
      this.interval = setInterval(this.grepYarn.bind(this), 100)
    }

    componentWillUnmount() {
      clearInterval(this.interval)
    }
  }
}
