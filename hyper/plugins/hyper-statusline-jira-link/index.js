const { shell } = require('electron')

const { classNameToSelector, getExistingCustomChildren } = require('../utils')

module.exports.decorateHyper = (Hyper, { React }) => {
  const componentClassName = 'component_component component_jira_link'
  const componentSelector = classNameToSelector(componentClassName)

  return class extends React.PureComponent {
    constructor(props) {
      super(props)

      this.state = {
        card: '',
      }
    }

    render() {
      const props = this.props
      const { card } = this.state
      if (!card) {
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
