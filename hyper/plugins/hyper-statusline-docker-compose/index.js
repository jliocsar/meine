const { exec } = require('child_process')

const {
  classNameToSelector,
  getExistingCustomChildren,
} = require('../../utils')
const { MeineComponentClassNameMap } = require('../../constants')
const { HypermeineStatusline } = require('../base-hypermeine-status')

const grepDockerCompose = store =>
  exec('ps -ef | grep "docker-compose up"', (err, stdout) => {
    if (err) {
      console.error(err)
      return
    }
    const [isRunning] = stdout
      .split('\n')
      .filter(line => line && !line.includes('grep'))
    return store.dispatch({
      type: this.GREP_DOCKER_COMPOSE_RESULT,
      data: {
        isRunning: !!isRunning,
      },
    })
  })

module.exports.GREP_DOCKER_COMPOSE_RESULT = 'GREP_DOCKER_COMPOSE_RESULT'
module.exports.grepDockerCompose = grepDockerCompose
module.exports.decorateHyper = (Hyper, { React }) => {
  const componentClassName = `component_component ${MeineComponentClassNameMap.DockerCompose}`
  const componentSelector = classNameToSelector(componentClassName)

  return class extends HypermeineStatusline({ React, componentSelector }) {
    render() {
      const props = this.props
      const { dockerComposeCommand: { isRunning } = {} } = store.getState().ui
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
                        fontSize: 22,
                        ...(!isRunning && {
                          marginRight: 0,
                        }),
                      },
                    },
                    '󰡨',
                  ),
                  isRunning ? 'dcup' : null,
                ),
              ),
            ),
          ),
        }),
      )
    }
  }
}
