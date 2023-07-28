const { MEINE_COMPONENT_CLASS_NAME } = require('../hyper-base')

module.exports.getExistingCustomChildren = props => {
  const { customChildren } = props
  const existingChildren = customChildren
    ? customChildren instanceof Array
      ? customChildren
      : [customChildren]
    : []
  return existingChildren
}

const footerSelector = '.footer_footer'
const leftFooterGroupSelector = `${footerSelector} .footer_group:first-child`
const rightFooterGroupSelector = `${footerSelector} .footer_group:last-child`

module.exports.queryLeftFooterGroup = () =>
  document.querySelector(leftFooterGroupSelector)
module.exports.queryRightFooterGroup = () =>
  document.querySelector(rightFooterGroupSelector)
module.exports.queryMeineComponents = ({ filterClassNames = [] } = {}) => {
  const components = Array.from(
    document.querySelectorAll(`.${MEINE_COMPONENT_CLASS_NAME}`),
  )
  return components.filter(
    component =>
      component.style.display !== 'none' &&
      !filterClassNames.includes(component.className),
  )
}
