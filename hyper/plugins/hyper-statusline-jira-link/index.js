const { shell } = require('electron')

const {
  classNameToSelector,
  getExistingCustomChildren,
} = require('../../utils')
const { MeineComponentClassNameMap } = require('../../constants')
const { HypermeineStatusline } = require('../base-hypermeine-status')

module.exports.decorateHyper = (Hyper, { React }) => {
  const componentClassName = `component_component ${MeineComponentClassNameMap.Jira}`
  const componentSelector = classNameToSelector(componentClassName)

  return class extends HypermeineStatusline({ React, componentSelector }) {
    constructor(props) {
      super(props)

      this.state = {
        card: '',
      }
    }

    render() {
      const props = this.props
      const { card } = this.state
      const existingChildren = getExistingCustomChildren(props)

      return React.createElement(
        Hyper,
        Object.assign({}, props, {
          customChildren: existingChildren.concat(
            React.createElement(
              'div',
              {
                className: componentClassName,
                ...(!card && {
                  style: {
                    display: 'none',
                  },
                }),
              },
              React.createElement(
                'div',
                {
                  className: 'component_item item_clickable',
                  onClick: this.handleJiraCardClick.bind(this),
                },
                card
                  ? React.createElement(
                      'div',
                      {},
                      React.createElement(
                        'span',
                        { className: 'component_icon logo_icon' },
                        '󰌃',
                      ),
                      card,
                    )
                  : null,
              ),
            ),
          ),
        }),
      )
    }

    handleJiraCardClick() {
      const { card } = this.state
      shell.openExternal(`https://hapana.atlassian.net/browse/${card}`)
    }

    componentDidMount() {
      this.interval = setInterval(() => {
        const footerGroup = this.rightFooterGroup
        const match = footerGroup.innerHTML.match(/(CV-\d+)/)
        this.setState({
          card: match ? match[1] : '',
        })
      }, 100)
    }

    componentWillUnmount() {
      clearInterval(this.interval)
    }
  }
}
