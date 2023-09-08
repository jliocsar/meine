const { withMeineStyles } = require('./styles')

module.exports.baseConfig = withMeineStyles({
  hyperTabs: {
    trafficButtons: true,
    border: true,
    closeAlign: 'right',
    activityPulse: false,
  },
  // choose either `'stable'` for receiving highly polished,
  // or `'canary'` for less polished but more frequent updates
  updateChannel: 'stable',
  // set custom startup directory (must be an absolute path)
  workingDirectory: '',
  // if you're using a Linux setup which show native menus, set to false
  // default: `true` on Linux, `true` on Windows, ignored on macOS
  showHamburgerMenu: false,
  // set to `false` (without backticks and without quotes) if you want to hide the minimize, maximize and close buttons
  // additionally, set to `'left'` if you want them on the left, like in Ubuntu
  // default: `true` (without backticks and without quotes) on Windows and Linux, ignored on macOS
  showWindowControls: true,
  // Supported Options:
  //  1. 'SOUND' -> Enables the bell as a sound
  //  2. false: turns off the bell
  bell: false,
  // An absolute file path to a sound file on the machine.
  // bellSoundURL: '/path/to/sound/file',
  // if `true` (without backticks and without quotes), selected text will automatically be copied to the clipboard
  copyOnSelect: false,
  // if `true` (without backticks and without quotes), hyper will be set as the default protocol client for SSH
  defaultSSHApp: true,
  // if `true` (without backticks and without quotes), on right click selected text will be copied or pasted if no
  // selection is present (`true` by default on Windows and disables the context menu feature)
  quickEdit: false,
  // choose either `'vertical'`, if you want the column mode when Option key is hold during selection (Default)
  // or `'force'`, if you want to force selection regardless of whether the terminal is in mouse events mode
  // (inside tmux or vim with mouse mode enabled for example).
  macOptionSelectionMode: 'vertical',
  // Whether to use the WebGL renderer. Set it to false to use canvas-based
  // rendering (slower, but supports transparent backgrounds)
  webGLRenderer: true,
  // keypress required for weblink activation: [ctrl|alt|meta|shift]
  // todo: does not pick up config changes automatically, need to restart terminal :/
  webLinksActivationKey: '',
  // if `false` (without backticks and without quotes), Hyper will use ligatures provided by some fonts
  disableLigatures: true,
  // set to true to disable auto updates
  disableAutoUpdates: false,
  // set to true to enable screen reading apps (like NVDA) to read the contents of the terminal
  screenReaderMode: false,
  // set to true to preserve working directory when creating splits or tabs
  preserveCWD: true,
  // for advanced config flags please refer to https://hyper.is/#cfg
})
