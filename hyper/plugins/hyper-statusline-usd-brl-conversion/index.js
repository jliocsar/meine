const { shell } = require('electron')

const {
  MeineComponentClassNameMap,
  classNameToSelector,
} = require('../../hyper-base')
const { getExistingCustomChildren } = require('../utils')
const { HypermeineStatusline } = require('../base-hypermeine-status')

module.exports.decorateHyper = (Hyper, { React }) => {
  const SECOND = 1_000

  const conversionInterval = SECOND * 30
  const componentClassName = `component_component ${MeineComponentClassNameMap.UsdBrlConversion}`
  const componentSelector = classNameToSelector(componentClassName)

  return class extends HypermeineStatusline({ React, componentSelector }) {
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
                  onClick: this.handleConversionClick.bind(this),
                },
                React.createElement(
                  'span',
                  { className: 'component_icon logo_icon' },
                  '💵',
                ),
                'R$',
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
