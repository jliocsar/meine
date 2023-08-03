const { MeineComponentClassNameMap } = require('./constants')
const { classNameToSelector, px } = require('./utils')
const { KanagawaTheme } = require('./themes')

const FONT_SIZE = 14
const FONT_FAMILY = '"Cascadia Code", "Symbols Nerd Font", monospace'

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
/* .terms_termsShifted {
  margin-top: 0 !important;
} */

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
    backdrop-filter: blur(2px);
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
    background: ${Color.lightBlack}bb;
  }

  .meine_tooltip {
    display: flex;
    flex-direction: column;
    position: absolute;
    bottom: 24px;
    padding: 12px;
    background: ${Color.black}88;
    border-radius: 8px 8px 8px 0;
    font-size: 12px;
    backdrop-filter: blur(4px);
    box-shadow: 0 0 8px rgba(0, 0, 0, 0.6);
    border: 1px solid rgba(255, 255, 255, 0.15);
    transform: translateX(4px);
    user-select: none;
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

    .meine_component {
      padding: 0 var(--component-margin-size);
    }

    .component_component:first-of-type {
      padding-right: var(--component-margin-size);
    }

    .arg_arg {
      color: ${Color.green};
      user-select: all;
    }

    .conversion_text {
      color: ${Color.lightCyan};
      margin-left: 8px;
    }

    ${classNameToSelector(MeineComponentClassNameMap.ComponentToggler)} {
      padding-left: 0;

      .component_icon {
        cursor: pointer;
        transition: color 200ms ease-in-out;
        color: ${Color.lightBlack};

        &:hover {
          color: ${Color.white};
        }
      }
    }

    ${classNameToSelector(MeineComponentClassNameMap.GitBranchesHistory)} {
      background-color: #333A41;

      .logo_icon {
        color: #959DA5;
      }

      div {
        color: #FFF;
      }
    }

    ${classNameToSelector(MeineComponentClassNameMap.UsdBrlConversion)} {
      background-color: ${Color.lightBlack}88;
    }

    ${classNameToSelector(MeineComponentClassNameMap.Jira)} {
      background-color: #0052CC;

      div {
        color: #FFF;
      }
    }

    ${classNameToSelector(MeineComponentClassNameMap.Ssh)} {
      background-color: #111;

      div {
        color: #FFF;
      }
    }

    ${classNameToSelector(MeineComponentClassNameMap.DockerCompose)} {
      background-color: #0db7ed; 

      div {
        color: #FFF;
      }
    }

    ${classNameToSelector(MeineComponentClassNameMap.Yarn)} {
      background-color: #2C8EBB;

      div {
        color: #FFF;
      }
    }
  }
}`,
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
  colors: KanagawaTheme,
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
