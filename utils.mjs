export const HOME = os.homedir()

export const tryCatch = async cb => {
  try {
    return { ok: true, value: await cb() }
  } catch (error) {
    return { ok: false, error }
  }
}

export const mecho = (...args) => echo('🐗', ...args)

export const ensureHomeDir = dir =>
  tryCatch(async () => {
    const dirPath = path.resolve(HOME, dir)
    await fs.ensureDir(dirPath)
    return dirPath
  })

export const ensureHomeFile = file =>
  tryCatch(async () => {
    const filePath = path.resolve(HOME, file)
    await fs.ensureFile(filePath)
    return filePath
  })

export const ensureCommand = cmd => tryCatch(() => $`command -v ${cmd}`)
