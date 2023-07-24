const { queryLeftFooterGroup, queryRightFooterGroup } = require('./utils')

module.exports.HypermeineStatusline = ({ React, componentSelector }) => {
  return class extends React.PureComponent {
    constructor(props) {
      super(props)
    }

    componentDidUpdate() {
      if (this.hasAppended) {
        return
      }
      const footerGroup = this.leftFooterGroup
      const components = document.querySelectorAll(componentSelector)
      if (footerGroup && components.length) {
        const [component, ...rest] = components
        footerGroup.appendChild(component)
        // TODO: Figure out why this is necessary
        for (const extraRenders of rest) {
          extraRenders.remove()
        }
      }
      this.hasAppended = true
    }

    get leftFooterGroup() {
      return queryLeftFooterGroup()
    }

    get rightFooterGroup() {
      return queryRightFooterGroup()
    }
  }
}
