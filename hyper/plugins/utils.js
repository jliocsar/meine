module.exports.classNameToSelector = names =>
  names
    .split(' ')
    .map(className => `.${className}`)
    .join('')

module.exports.getExistingCustomChildren = props => {
  const { customChildren } = props
  const existingChildren = customChildren
    ? customChildren instanceof Array
      ? customChildren
      : [customChildren]
    : []
  return existingChildren
}
