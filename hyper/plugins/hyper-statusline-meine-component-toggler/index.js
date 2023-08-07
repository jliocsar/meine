const {
  classNameToSelector,
  getExistingCustomChildren,
  queryMeineComponents,
} = require('../../utils')
const {
  MeineComponentClassNameMap,
  MeineComponentLabelMap,
} = require('../../constants')
const { buildTooltip } = require('../../components/tooltip')
const { HypermeineStatusline } = require('../base-hypermeine-status')

module.exports.decorateHyper = (Hyper, { React }) => {
  const componentClassName = `component_component ${MeineComponentClassNameMap.ComponentToggler}`
  const componentSelector = classNameToSelector(componentClassName)

  return class extends HypermeineStatusline({ React, componentSelector }) {
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
      const Tooltip = buildTooltip({ React })

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
            filterClassNames: [componentClassName],
            filterHidden: false,
          })
          initialToggled = this.components.reduce((initial, component) => {
            const toggleableComponentClassName = component.className.replace(
              /.*\s/,
              '',
            )
            return {
              ...initial,
              [toggleableComponentClassName]:
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
                            const toggleableComponentClassName =
                              component.className.replace(/.*\s/, '')
                            return React.createElement(
                              'li',
                              {},
                              React.createElement('input', {
                                type: 'checkbox',
                                name: toggleableComponentClassName,
                                checked: toggled[toggleableComponentClassName],
                                onInput: handleInput,
                                style: {
                                  marginRight: 4,
                                  position: 'relative',
                                  zIndex: 2,
                                },
                              }),
                              MeineComponentLabelMap[
                                toggleableComponentClassName
                              ],
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
