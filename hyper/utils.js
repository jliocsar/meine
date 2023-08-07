const { debounce: debounceFn } = require('debounce')

const {
  MeineComponentClassNameMap,
  LEFT_FOOTER_GROUP_SELECTOR,
  RIGHT_FOOTER_GROUP_SELECTOR,
} = require('./constants')

const DEBOUNCE_TIME = 100

module.exports.debounce = (fn, time = DEBOUNCE_TIME) => debounceFn(fn, time)

module.exports.getExistingCustomChildren = props => {
  const { customChildren } = props
  const existingChildren = customChildren
    ? customChildren instanceof Array
      ? customChildren
      : [customChildren]
    : []
  return existingChildren
}

module.exports.queryLeftFooterGroup = () =>
  document.querySelector(LEFT_FOOTER_GROUP_SELECTOR)
module.exports.queryRightFooterGroup = () =>
  document.querySelector(RIGHT_FOOTER_GROUP_SELECTOR)
module.exports.queryMeineComponents = ({ classNames = [] } = {}) => {
  const components = Array.from(
    document.querySelectorAll(`.${MeineComponentClassNameMap.Default}`),
  )
  return components.filter(
    component =>
      classNames.length &&
      classNames.some(className => component.classList.contains(className)),
  )
}

module.exports.classNameToSelector = names =>
  names
    .split(' ')
    .map(className => `.${className}`)
    .join('')
module.exports.px = size => size + 'px'
