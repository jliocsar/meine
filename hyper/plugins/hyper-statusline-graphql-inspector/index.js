const { shell } = require('electron')

const {
  classNameToSelector,
  getExistingCustomChildren,
} = require('../../utils')
const { MeineComponentClassNameMap } = require('../../constants')
const { buildTooltip } = require('../../components/tooltip')
const { HypermeineStatusline } = require('../base-hypermeine-status')

module.exports.decorateHyper = (Hyper, { React }) => {
  const componentClassName = `component_component ${MeineComponentClassNameMap.GraphQLInspector}`
  const componentSelector = classNameToSelector(componentClassName)
  const Tooltip = buildTooltip({ React })

  return class extends HypermeineStatusline({ React, componentSelector }) {
    constructor(props) {
      super(props)

      this.state = {
        showEndpointInput: false,
        submitResult: '',
        form: {
          authorization: '',
          headers: '',
          endpoint: 'http://localhost:4001',
        },
      }
    }

    render() {
      const props = this.props
      const { meineConfig = {} } = store.getState().ui
      const { submitResult, showEndpointInput } = this.state
      const existingChildren = getExistingCustomChildren(props)

      const handleFormChange = event => {
        const { name, value } = event.target
        this.setState(oldState => ({
          ...oldState,
          form: {
            ...oldState.form,
            [name]: value,
          },
        }))
      }
      const handleMouseEnter = () =>
        this.setState(oldState => ({
          ...oldState,
          showEndpointInput: true,
        }))
      const handleMouseLeave = () => {
        this.setState(oldState => ({
          ...oldState,
          showEndpointInput: false,
          submitResult: '',
        }))
      }
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
                ...(!meineConfig.graphqlInspector && {
                  style: {
                    display: 'none',
                  },
                }),
                onMouseLeave: handleMouseLeave,
                className: componentClassName,
              },
              React.createElement(
                'div',
                {
                  ...tooltipProps,
                  className: 'component_item',
                },
                React.createElement(
                  'span',
                  {
                    className: 'component_icon logo_icon',
                    style: {
                      fontSize: 22,
                      marginRight: 0,
                      lineHeight: '28px',
                    },
                  },
                  '󰡷',
                ),
              ),
              showEndpointInput
                ? React.createElement(
                    Tooltip,
                    tooltipProps,
                    React.createElement(
                      'form',
                      {
                        onSubmit: event => {
                          this.setState(oldState => ({
                            ...oldState,
                            submitResult: 'memes',
                          }))
                          return event.preventDefault()
                        },
                        onChange: handleFormChange,
                        style: {
                          display: 'flex',
                          flexDirection: 'column',
                        },
                      },
                      React.createElement('label', {}, 'Headers'),
                      React.createElement('input', {
                        name: 'headers',
                        value: this.state.form.headers,
                        placeholder:
                          '"Auth-Mechanism":"admin","Tenant":"jc-gym"',
                      }),
                      React.createElement('label', {}, 'Authorization'),
                      React.createElement('input', {
                        name: 'authorization',
                        value: this.state.form.authorization,
                        placeholder: 'Bearer xxxxx',
                      }),
                      React.createElement('label', {}, 'Endpoint'),
                      React.createElement('input', {
                        name: 'endpoint',
                        value: this.state.form.endpoint,
                        placeholder: 'Endpoint',
                      }),
                      React.createElement('button', {}, 'Submit'),
                    ),
                    submitResult ? submitResult : null,
                  )
                : null,
            ),
          ),
        }),
      )
    }
  }
}
