const { MeineComponentClassNameMap } = require('./constants')

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
module.exports.queryMeineComponents = ({
  filterClassNames = [],
  filterHidden = true,
} = {}) => {
  const components = Array.from(
    document.querySelectorAll(`.${MeineComponentClassNameMap.Default}`),
  )
  return components.filter(
    component =>
      (filterHidden && component.style.display !== 'none') ||
      !filterClassNames.includes(component.className),
  )
}

module.exports.classNameToSelector = names =>
  names
    .split(' ')
    .map(className => `.${className}`)
    .join('')
module.exports.px = size => size + 'px'
