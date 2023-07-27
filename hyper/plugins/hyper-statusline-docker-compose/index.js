const { exec } = require('child_process')

const {
  MeineComponentClassNameMap,
  classNameToSelector,
} = require('../../hyper-base')
const { getExistingCustomChildren } = require('../utils')
const { HypermeineStatusline } = require('../base-hypermeine-status')

module.exports.decorateHyper = (Hyper, { React }) => {
  const componentClassName = `component_component ${MeineComponentClassNameMap.DockerCompose}`
  const componentSelector = classNameToSelector(componentClassName)

  return class extends HypermeineStatusline({ React, componentSelector }) {
    constructor(props) {
      super(props)

      this.state = {
        isRunning: false,
      }
    }

    render() {
      const props = this.props
      const { isRunning } = this.state
      const existingChildren = getExistingCustomChildren(props)
      return React.createElement(
        Hyper,
        Object.assign({}, props, {
          customChildren: existingChildren.concat(
            React.createElement(
              'div',
              {
                className: componentClassName,
                ...(!isRunning && {
                  style: {
                    display: 'none',
                  },
                }),
              },
              React.createElement(
                'div',
                { className: 'component_item' },
                isRunning
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
                            fontSize: 22,
                          },
                        },
                        '󰡨',
                      ),
                      'dcup',
                    )
                  : null,
              ),
            ),
          ),
        }),
      )
    }

    grepDockerCompose() {
      exec('ps -ef | grep "docker-compose up"', (err, stdout) => {
        if (err) {
          console.error(err)
          return
        }
        const [isRunning] = stdout
          .split('\n')
          .filter(line => line && !line.includes('grep'))
        this.setState({ isRunning: !!isRunning })
      })
    }

    componentDidMount() {
      this.interval = setInterval(this.grepDockerCompose.bind(this), 100)
    }

    componentWillUnmount() {
      clearInterval(this.interval)
    }
  }
}
