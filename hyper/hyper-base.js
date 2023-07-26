'use strict'
// Future versions of Hyper may add additional config options,
// which will not automatically be merged into this file.
// See https://hyper.is#cfg for all currently supported options.
const px = size => size + 'px'

const FONT_SIZE = 14
const FONT_FAMILY = '"Cascadia Code", "Symbols Nerd Font", monospace'
const JIRA_LINK_COMPONENT_CLASS_NAME = 'component_jira_link'
const USD_BRL_CONVERSION_COMPONENT_CLASS_NAME = 'component_usd_brl_conv'
const MIN_TERMINAL_WINDOW_WIDTH_SIZE = px(1024)

const Color = {
  black: '#1F1F28',
  red: '#E46A78',
  green: '#98BC6D',
  yellow: '#E5C283',
  blue: '#7EB3C9',
  magenta: '#957FB8',
  cyan: '#7EB3C9',
  white: '#DDD8BB',
  lightBlack: '#3C3C51',
  lightRed: '#EC818C',
  lightGreen: '#9EC967',
  lightYellow: '#F1C982',
  lightBlue: '#7BC2DF',
  lightMagenta: '#A98FD2',
  lightCyan: '#7BC2DF',
  lightWhite: '#A8A48D',
  limeGreen: '#9EC967',
  lightCoral: '#A98FD2',
}

module.exports.JIRA_LINK_COMPONENT_CLASS_NAME = JIRA_LINK_COMPONENT_CLASS_NAME
module.exports.USD_BRL_CONVERSION_COMPONENT_CLASS_NAME =
  USD_BRL_CONVERSION_COMPONENT_CLASS_NAME
module.exports.plugins = [
  'hyper-statusline',
  'hyper-hide-scroll',
  'hyperminimal',
]
module.exports.localPlugins = ['hypermeine']

module.exports.baseConfig = {
  // choose either `'stable'` for receiving highly polished,
  // or `'canary'` for less polished but more frequent updates
  updateChannel: 'stable',
  // default font size in pixels for all tabs
  fontSize: FONT_SIZE,
  // font family with optional fallbacks
  fontFamily: FONT_FAMILY,
  // default font weight: 'normal' or 'bold'
  fontWeight: 'normal',
  // font weight for bold characters: 'normal' or 'bold'
  fontWeightBold: 'normal',
  // line height as a relative unit
  lineHeight: 1,
  // letter spacing as a relative unit
  letterSpacing: 0,
  // terminal cursor background color and opacity (hex, rgb, hsl, hsv, hwb or cmyk)
  cursorColor: '#E6E0C2',
  // terminal text color under BLOCK cursor
  cursorAccentColor: '#1F1F28',
  // `'BEAM'` for |, `'UNDERLINE'` for _, `'BLOCK'` for █
  cursorShape: 'BLOCK',
  // set to `true` (without backticks and without quotes) for blinking cursor
  cursorBlink: false,
  // color of the text
  foregroundColor: '#DDD8BB',
  // terminal background color
  // opacity is only supported on macOS
  backgroundColor: '#1F1F28',
  // terminal selection color
  selectionColor: '#49473E',
  // border color (window, tabs)
  borderColor: '#000',
  // custom CSS to embed in the main window
  css: /* css */ `
& {
  --gtk-border-color: #454445;
  --component-margin-size: 12px;

  border: 2px solid var(--gtk-border-color);
  height: 100vh;

  .tab_tab {
    background: rgba(0, 0, 0, .2);
    border-color: var(--gtk-border-color) !important;
    border-top: 1px solid var(--gtk-border-color);
    border-bottom: 0;
  }

  .tab_tab:first-of-type {
    border-left: 1px solid var(--gtk-border-color);
  }

  .tab_tab:last-of-type {
    border-right: 1px solid var(--gtk-border-color);
  }

  .tab_hasActivity {
    color: ${Color.lightCyan};
  }

  .tab_active {
    background: ${Color.lightBlack};
  }

  .footer_footer {
    background: rgba(0, 0, 0, .2);
    opacity: 1;
    border-right: 1px solid var(--gtk-border-color);
    border-left: 1px solid var(--gtk-border-color);
    border-bottom: 1px solid var(--gtk-border-color);

    div {
      font-family: ${FONT_FAMILY};
      font-size: ${px(FONT_SIZE)};
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      color: #E6E0C2;
    }

    .logo_icon {
      font-size: ${px(FONT_SIZE + 2)};
      margin-right: 8px;
    }

    .${JIRA_LINK_COMPONENT_CLASS_NAME},
    .${USD_BRL_CONVERSION_COMPONENT_CLASS_NAME} {
      padding: 0 var(--component-margin-size);
    }

    .component_component:first-of-type {
      padding-right: var(--component-margin-size);
    }

    .${JIRA_LINK_COMPONENT_CLASS_NAME} {
      background-color: #0052CC;

      div {
        color: #FFF;
      }

      @media (max-width: ${MIN_TERMINAL_WINDOW_WIDTH_SIZE}) {
        display: none;
      }
    }

    .${USD_BRL_CONVERSION_COMPONENT_CLASS_NAME} {
      background-color: ${Color.lightBlack}88;

      @media (max-width: ${MIN_TERMINAL_WINDOW_WIDTH_SIZE}) {
        display: none;
      }
    }
  }
}
*/
`,
  // custom CSS to embed in the terminal window
  termCSS: '',
  // set custom startup directory (must be an absolute path)
  workingDirectory: '',
  // if you're using a Linux setup which show native menus, set to false
  // default: `true` on Linux, `true` on Windows, ignored on macOS
  showHamburgerMenu: true,
  // set to `false` (without backticks and without quotes) if you want to hide the minimize, maximize and close buttons
  // additionally, set to `'left'` if you want them on the left, like in Ubuntu
  // default: `true` (without backticks and without quotes) on Windows and Linux, ignored on macOS
  showWindowControls: true,
  // custom padding (CSS format, i.e.: `top right bottom left`)
  padding: '20px 20px 0',
  // the full list. if you're going to provide the full color palette,
  // including the 6 x 6 color cubes and the grayscale map, just provide
  // an array here instead of a color map object
  colors: Color,
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
}
