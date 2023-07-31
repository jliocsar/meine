const { shell } = require('electron')

const {
  MeineComponentClassNameMap,
  classNameToSelector,
} = require('../../hyper-base')
const { getExistingCustomChildren, queryMeineComponents } = require('../utils')
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
        shouldRender: false,
        showLastConversion: false,
      }
    }

    render() {
      const props = this.props
      const {
        usdBrlConversion,
        lastConversion,
        shouldRender,
        showLastConversion,
      } = this.state
      const existingChildren = getExistingCustomChildren(props)

      return React.createElement(
        Hyper,
        Object.assign({}, props, {
          customChildren: existingChildren.concat(
            React.createElement(
              'div',
              {
                onMouseEnter: () => this.setState({ showLastConversion: true }),
                onMouseLeave: () =>
                  this.setState({ showLastConversion: false }),
                className: componentClassName,
                ...(!shouldRender && {
                  style: {
                    display: 'none',
                  },
                }),
              },
              React.createElement(
                'div',
                {
                  className: 'component_item item_clickable',
                  onClick: this.handleConversionClick.bind(this),
                },
                React.createElement(
                  'span',
                  {
                    ...(lastConversion && {
                      title: `Last conversion at ${lastConversion.toLocaleTimeString()}`,
                    }),
                    className: 'component_icon logo_icon',
                  },
                  '🇺🇸🇧🇷',
                ),
                'R$',
                Number(usdBrlConversion).toFixed(2),
              ),
              lastConversion && showLastConversion
                ? React.createElement(
                    'div',
                    {
                      className: 'meine_tooltip',
                      style: { flexDirection: 'row' },
                    },
                    'Last conversion at',
                    React.createElement(
                      'span',
                      { className: 'conversion_text' },
                      lastConversion.toLocaleTimeString(),
                    ),
                  )
                : null,
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
      this.renderInterval = setInterval(() => {
        const currentMeineComponents = queryMeineComponents({
          filterClassNames: [componentClassName],
        })
        const shouldRender = currentMeineComponents.length < 3
        this.setState({ shouldRender })
      }, 100)
      this.fetchInterval = setInterval(
        this.fetchUsdBrlConversion.bind(this),
        conversionInterval,
      )
    }

    componentWillUnmount() {
      clearInterval(this.renderInterval)
      clearInterval(this.fetchInterval)
    }
  }
}
