const { shell } = require('electron')

const { classNameToSelector, getExistingCustomChildren } = require('../utils')
const { HypermeineStatusline } = require('../base-hypermeine-status')

module.exports.decorateHyper = (Hyper, { React }) => {
  const componentClassName = 'component_component component_jira_link'
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
              },
              React.createElement(
                'div',
                {
                  className: 'component_item item_clickable',
                  style: { marginLeft: '10px' },
                  onClick: this.handleJiraCardClick.bind(this),
                },
                card ? 'Jira' : '',
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
        if (match) {
          const [, card] = match
          this.setState({ card })
        }
      }, 1_000)
    }

    componentWillUnmount() {
      clearInterval(this.interval)
    }
  }
}
