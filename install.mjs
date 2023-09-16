#!/usr/bin/env zx
import 'zx/globals'
import {
  ensureCommand,
  ensureHomeDir,
  mecho,
  HOME,
  ensureHomeFile,
} from './utils.mjs'
import { plugins, localPlugins } from './hyper/plugins.js'

const aptdeps = ['zsh', 'bat', 'tree', 'python3-venv']

mecho`Installing dependencies...`
await $`sudo apt install -y ${aptdeps} > /dev/null`
echo`done`

if (await ensureHomeDir('.oh-my-zsh')) {
  mecho`oh-my-zsh already installed.`
} else {
  mecho`Installing oh-my-zsh...`
  await $`sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
}

if (await ensureCommand('zinit')) {
  mecho`Zinit already installed.`
} else {
  mecho`Zinit not found, installing...`
  await $`bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"`
}

if (await ensureCommand('nvim')) {
  mecho`nvim already installed.`
} else {
  mecho`Neovim not found, installing...`
  await $`curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage`
  await $`chmod u+x ./nvim.appimage`
  await $`sudo mv ./nvim.appimage /usr/bin/nvim`
}

if (await ensureHomeDir('.nvm')) {
  mecho`nvm already installed.`
} else {
  mecho`Installing nvm...`
  await $`curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash`
}

mecho`Remember to install spaceship-prompt and set ZSH_THEME="spaceship" in the .zshrc file`
mecho`Also install \`Cascadia Code\`, Nerd Fonts (Font Awesome etc), Hyper (https://hyper.is/) etc`
echo`https://github.com/spaceship-prompt/spaceship-prompt`
echo`https://github.com/microsoft/cascadia-code`

await $`sed -i '/zsh_custom_config/d' $HOME/.zshrc`
await $`echo 'source $HOME/.meine/zsh_custom_config.zsh' >> $HOME/.zshrc`

mecho`Creating shared Hyper stuff...`
const hyperLocalPluginsPath = path.resolve(HOME, '.hyper_plugins', 'local')
await $`rm -rf ${hyperLocalPluginsPath}`
await $`mkdir -p ${hyperLocalPluginsPath}`
mecho`Creating symlink to hypermeine...`
await $`ln -s ${HOME}/.meine/hyper/plugins/hypermeine ${HOME}/.hyper_plugins/local/hypermeine`

const { value: hyperJsPath } = await ensureHomeFile('.hyper.js')

if (hyperJsPath) {
  mecho`Patching .hyper.js with local plugins...`
  const pluginsJson = JSON.stringify(plugins)
  const localPluginsJson = JSON.stringify(localPlugins)
  const pluginsMatch = `s/plugins:\\s*\\n*\\[.*\\s*\\n*\\]/plugins: ${pluginsJson}/g`
  const localPluginsMatch = `s/localPlugins:\\s*\\n*\\[.*\\s*\\n*\\]/localPlugins: ${localPluginsJson}/g`
  await Promise.all([
    $`sed -i ${pluginsMatch} ${hyperJsPath}`,
    $`sed -i ${localPluginsMatch} ${hyperJsPath}`,
  ])
}

// TODO: Add nvim section

mecho`All done!`
