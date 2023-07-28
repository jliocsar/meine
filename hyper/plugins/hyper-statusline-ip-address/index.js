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
  const componentClassName = `component_component ${MeineComponentClassNameMap.IpAddress}`
  const componentSelector = classNameToSelector(componentClassName)
  const publicIpUrl = 'ifconfig.me'
  const nets = networkInterfaces()
  delete nets.lo
  const { address: ip } = Object.values(nets)
    .flat()
    .find(({ family }) => family === 'IPv4')

  return class extends HypermeineStatusline({ React, componentSelector }) {
    constructor(props) {
      super(props)

      this.state = {
        publicIp: '',
      }
    }

    render() {
      const props = this.props
      const { publicIp } = this.state
      const existingChildren = getExistingCustomChildren(props)
      return React.createElement(
        Hyper,
        Object.assign({}, props, {
          customChildren: existingChildren.concat(
            React.createElement(
              'div',
              {
                className: componentClassName,
                ...((!ip || !publicIp) && {
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
                    '󰩟',
                  ),
                  React.createElement(
                    'div',
                    {
                      style: {
                        display: 'flex',
                        flexDirection: 'column',
                      },
                    },
                    React.createElement(
                      'p',
                      { style: { fontSize: 10 } },
                      'Home: ',
                      ip,
                    ),
                    React.createElement(
                      'p',
                      {
                        className: 'item_clickable',
                        style: { fontSize: 10 },
                        onClick: () =>
                          shell.openExternal(`https://${publicIpUrl}`),
                      },
                      'Public: ',
                      publicIp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        }),
      )
    }

    fetchPublicIp() {
      exec(`curl ${publicIpUrl}`, (error, stdout) => {
        if (error) {
          console.error(error)
          return
        }
        const publicIp = stdout.trim()
        this.setState({ publicIp })
      })
    }

    componentDidMount() {
      this.fetchPublicIp()
    }
  }
}
