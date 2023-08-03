module.exports.buildTooltip = ({ React }) =>
  class extends React.PureComponent {
    constructor(props) {
      super(props)
    }

    render() {
      return React.createElement('div', {
        ...this.props,
        className: 'meine_tooltip',
      })
    }
  }
