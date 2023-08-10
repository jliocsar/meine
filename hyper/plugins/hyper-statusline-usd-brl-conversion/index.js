const { shell } = require('electron')

const {
  classNameToSelector,
  getExistingCustomChildren,
} = require('../../utils')
const { MeineComponentClassNameMap } = require('../../constants')
const { buildTooltip } = require('../../components/tooltip')
const { HypermeineStatusline } = require('../base-hypermeine-status')

module.exports.decorateHyper = (Hyper, { React }) => {
  const SECOND = 1_000

  const conversionInterval = SECOND * 30
  const componentClassName = `component_component ${MeineComponentClassNameMap.UsdBrlConversion}`
  const componentSelector = classNameToSelector(componentClassName)
  const Tooltip = buildTooltip({ React })

  return class extends HypermeineStatusline({ React, componentSelector }) {
    constructor(props) {
      super(props)

      this.state = {
        usdBrlConversion: 0,
        lastConversion: null,
        showLastConversion: false,
      }
    }

    render() {
      const props = this.props
      const { meineConfig = {} } = store.getState().ui
      const { usdBrlConversion, lastConversion, showLastConversion } =
        this.state
      const existingChildren = getExistingCustomChildren(props)

      const handleMouseEnter = () => this.setState({ showLastConversion: true })
      const tooltipProps = {
        onMouseEnter: handleMouseEnter,
      }

      return React.createElement(
        Hyper,
        Object.assign({}, props, {
          customChildren: existingChildren.concat(
            React.createElement(
              'div',
              {
                ...(!meineConfig.usdBrlConversion && {
                  style: { display: 'none' },
                }),
                onMouseLeave: () =>
                  this.setState({ showLastConversion: false }),
                className: componentClassName,
              },
              React.createElement(
                'div',
                {
                  ...tooltipProps,
                  className: 'component_item item_clickable',
                  onClick: this.handleConversionClick.bind(this),
                },
                React.createElement(
                  'span',
                  { className: 'component_icon logo_icon' },
                  '🇺🇸🇧🇷',
                ),
                'R$',
                Number(usdBrlConversion).toFixed(4),
              ),
              lastConversion && showLastConversion
                ? React.createElement(
                    Tooltip,
                    {
                      ...tooltipProps,
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
      this.fetchInterval = setInterval(
        this.fetchUsdBrlConversion.bind(this),
        conversionInterval,
      )
    }

    componentWillUnmount() {
      clearInterval(this.fetchInterval)
    }
  }
}
