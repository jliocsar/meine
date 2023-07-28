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
        ssh: '',
      }
    }

    render() {
      const props = this.props
      const { ssh } = this.state
      const existingChildren = getExistingCustomChildren(props)
      return React.createElement(
        Hyper,
        Object.assign({}, props, {
          customChildren: existingChildren.concat(
            React.createElement(
              'div',
              {
                className: componentClassName,
                ...(!ssh && {
                  style: {
                    display: 'none',
                  },
                }),
              },
              React.createElement(
                'div',
                { className: 'component_item' },
                ssh
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
                      ssh,
                    )
                  : null,
              ),
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
        const [ssh] = stdout
          .split('\n')
          .filter(line => line && !line.includes('grep'))
        if (ssh) {
          const parts = ssh.split(' ')
          const lastPart = parts[parts.length - 1]
          if (this.state.ssh !== lastPart) {
            this.setState({ ssh: lastPart })
          }
          return
        }
        this.setState({ ssh: '' })
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
