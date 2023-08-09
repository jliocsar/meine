const {
  classNameToSelector,
  getExistingCustomChildren,
  queryMeineComponents,
} = require('../../utils')
const {
  MeineComponentClassNameMap,
  MeineComponentLabelMap,
  IP_ADDRESS_COMPONENT_CLASS_NAME,
  USD_BRL_CONVERSION_COMPONENT_CLASS_NAME,
  GIT_BRANCHES_HISTORY_COMPONENT_CLASS_NAME,
  COMPONENT_CWD_CLASS_NAME,
  LOCALHOST_PORTS_COMPONENT_CLASS_NAME,
} = require('../../constants')
const { buildTooltip } = require('../../components/tooltip')
const { HypermeineStatusline } = require('../base-hypermeine-status')

const TOGGLEABLE_COMPONENTS = [
  IP_ADDRESS_COMPONENT_CLASS_NAME,
  USD_BRL_CONVERSION_COMPONENT_CLASS_NAME,
  GIT_BRANCHES_HISTORY_COMPONENT_CLASS_NAME,
  LOCALHOST_PORTS_COMPONENT_CLASS_NAME,
]

module.exports.decorateHyper = (Hyper, { React }) => {
  const componentClassName = `component_component ${MeineComponentClassNameMap.ComponentToggler}`
  const componentSelector = classNameToSelector(componentClassName)
  const Tooltip = buildTooltip({ React })

  const getToggleableComponentClassName = className =>
    className.replace(/.*\s/g, '')

  return class extends HypermeineStatusline({
    React,
    componentSelector,
    prepend: true,
  }) {
    constructor(props) {
      super(props)

      this.state = {
        components: null,
        showToggleableComponents: false,
        toggled: {},
      }
    }

    render() {
      const props = this.props
      const { showToggleableComponents, toggled } = this.state
      const existingChildren = getExistingCustomChildren(props)

      const handleInput = event => {
        const { name } = event.target
        const { components } = this
        const component = components.find(component =>
          component.classList.contains(name),
        )
        const display = component.style.display
        component.style.display = display === 'none' ? 'flex' : 'none'
        this.setState({
          toggled: {
            ...this.state.toggled,
            [name]: !this.state.toggled[name],
          },
        })
      }
      const handleClick = event => {
        event.stopPropagation()
        let initialToggled
        if (!this.components) {
          this.components = queryMeineComponents({
            classNames: TOGGLEABLE_COMPONENTS,
          }).concat(
            document.querySelector(
              `.component_component.${COMPONENT_CWD_CLASS_NAME}`,
            ),
          )
          initialToggled = this.components.reduce((initial, component) => {
            return {
              ...initial,
              [getToggleableComponentClassName(component.className)]:
                component.style.display !== 'none',
            }
          }, {})
        }
        this.setState({
          showToggleableComponents: !this.state.showToggleableComponents,
          ...(initialToggled && { toggled: initialToggled }),
        })
      }
      const tooltipProps = {}

      return React.createElement(
        Hyper,
        Object.assign({}, props, {
          customChildren: existingChildren.concat(
            React.createElement(
              'div',
              {
                ...tooltipProps,
                onMouseLeave: () =>
                  this.setState({ showToggleableComponents: false }),
                className: componentClassName,
              },
              React.createElement(
                'div',
                {
                  onClick: handleClick,
                  className: 'component_item',
                  style: { marginTop: -1 },
                },
                React.createElement(
                  'span',
                  {
                    className: 'component_icon',
                    style: { fontSize: 20 },
                  },
                  '󱉯',
                ),
              ),
              showToggleableComponents
                ? React.createElement(
                    Tooltip,
                    tooltipProps,
                    this.components.length
                      ? React.createElement(
                          'ul',
                          {
                            style: {
                              listStyleType: 'none',
                            },
                          },
                          this.components.map(component => {
                            const className = getToggleableComponentClassName(
                              component.className,
                            )
                            return React.createElement(
                              'li',
                              {},
                              React.createElement('input', {
                                type: 'checkbox',
                                name: className,
                                checked: toggled[className],
                                onInput: handleInput,
                                style: {
                                  marginRight: 4,
                                  position: 'relative',
                                  zIndex: 2,
                                },
                              }),
                              MeineComponentLabelMap[className],
                            )
                          }),
                        )
                      : null,
                  )
                : null,
            ),
          ),
        }),
      )
    }
  }
}
