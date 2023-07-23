const { shell } = require('electron')

const { getExistingCustomChildren, classNameToSelector } = require('../utils')

module.exports.decorateHyper = (Hyper, { React }) => {
  const SECOND = 1_000

  const componentClassName = 'component_component component_usd_brl_conv'
  const componentSelector = classNameToSelector(componentClassName)
  const conversionInterval = SECOND * 30

  return class extends React.PureComponent {
    constructor(props) {
      super(props)

      this.state = {
        usdBrlConversion: 0,
        lastConversion: null,
      }
    }

    render() {
      const props = this.props
      const { usdBrlConversion, lastConversion } = this.state
      if (!lastConversion) {
        return React.createElement(Hyper, props)
      }
      const existingChildren = getExistingCustomChildren(props)

      return React.createElement(
        Hyper,
        Object.assign({}, props, {
          customChildren: existingChildren.concat(
            React.createElement(
              'div',
              {
                className: componentClassName,
              },
              React.createElement(
                'div',
                {
                  className: 'component_item item_clickable',
                  style: { marginLeft: '10px' },
                  onClick: this.handleConversionClick.bind(this),
                },
                'USD: R$',
                Number(usdBrlConversion).toFixed(2),
                lastConversion
                  ? React.createElement(
                      'small',
                      {},
                      ` (${lastConversion.toLocaleTimeString()})`,
                    )
                  : null,
              ),
            ),
          ),
        }),
      )
    }

    handleConversionClick() {
      shell.openExternal('https://www.google.com/search?q=usd+brl')
    }

    async fetchUsdBrlConversion() {
      const response = await fetch(
        'https://economia.awesomeapi.com.br/last/USD-BRL',
      )
      const { USDBRL } = await response.json()
      this.setState({
        usdBrlConversion: USDBRL.bid,
        lastConversion: new Date(),
      })
    }

    componentDidUpdate() {
      const footerGroup = document.querySelector(
        '.footer_footer .footer_group:first-of-type',
      )
      const components = document.querySelectorAll(componentSelector)
      if (footerGroup && components) {
        const [component, ...rest] = components
        footerGroup.appendChild(component)
        // TODO: Figure out why this is necessary
        for (const extraRenders of rest) {
          extraRenders.remove()
        }
      }
    }

    componentDidMount() {
      this.fetchUsdBrlConversion()
      this.interval = setInterval(
        this.fetchUsdBrlConversion.bind(this),
        conversionInterval,
      )
    }

    componentWillUnmount() {
      clearInterval(this.interval)
    }
  }
}
