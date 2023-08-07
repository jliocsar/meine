const { MeineComponentClassNameMap } = require('./constants')
const { classNameToSelector, px } = require('./utils')
const { Default: Theme } = require('./themes')

module.exports.FONT_SIZE = 14
module.exports.FONT_FAMILY = '"Cascadia Code", "Symbols Nerd Font", monospace'

const MeineComponentsStyle = {
  [MeineComponentClassNameMap.GitBranchesHistory]: {
    background: 'linear-gradient(to top, #252A2F, #333A41)',
    iconColor: '#959DA5',
    color: '#FFF',
  },
  [MeineComponentClassNameMap.UsdBrlConversion]: {
    backgroundColor: '#181c3d',
    color: '#b1b6e6',
  },
  [MeineComponentClassNameMap.Jira]: {
    backgroundColor: '#0052CC',
    color: '#FFF',
  },
  [MeineComponentClassNameMap.Ssh]: {
    backgroundColor: '#111',
    color: '#FFF',
  },
  [MeineComponentClassNameMap.DockerCompose]: {
    backgroundColor: '#0db7ed',
    color: '#FFF',
  },
  [MeineComponentClassNameMap.Yarn]: {
    backgroundColor: '#2C8EBB',
    color: '#FFF',
  },
}

const css = /* css */ `
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
    color: ${Theme.lightCyan};
  }

  .tab_active {
    background: ${Theme.lightBlack}44;
  }

  .meine_tooltip {
    display: flex;
    flex-direction: column;
    position: absolute;
    bottom: 24px;
    padding: 12px;
    background: ${Theme.black}88;
    border-radius: 8px 8px 8px 0;
    font-size: 12px;
    backdrop-filter: blur(4px);
    box-shadow: 0 0 8px rgba(0, 0, 0, 0.6);
    border: 1px solid rgba(255, 255, 255, 0.2);
    transform: translateX(4px);
    user-select: none;
  }

  .footer_footer {
    /* background: rgba(0, 0, 0, .2); */
    background: rgba(255, 255, 255, .05);
    opacity: 1;
    border-right: 1px solid var(--gtk-border-color);
    border-left: 1px solid var(--gtk-border-color);
    border-bottom: 1px solid var(--gtk-border-color);

    div {
      font-family: ${this.FONT_FAMILY};
      font-size: ${px(this.FONT_SIZE)};
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      color: ${Theme.white};
    }

    .logo_icon {
      font-size: ${px(this.FONT_SIZE + 2)};
      margin-right: 8px;
    }

    .meine_component {
      padding: 0 var(--component-margin-size);
    }

    .component_component:first-of-type {
      padding-right: var(--component-margin-size);
    }

    .arg_arg {
      color: ${Theme.green};
      user-select: all;
    }

    .conversion_text {
      color: ${Theme.lightCyan};
      margin-left: 8px;
    }

    ${classNameToSelector(MeineComponentClassNameMap.ComponentToggler)} {
      padding-left: 0;

      .component_icon {
        cursor: pointer;
        transition: color 200ms ease-in-out;
        color: ${Theme.lightBlack};

        &:hover {
          color: ${Theme.white};
        }
      }
    }

    ${classNameToSelector(MeineComponentClassNameMap.GitBranchesHistory)} {
      background: ${
        MeineComponentsStyle[MeineComponentClassNameMap.GitBranchesHistory]
          .background
      };

      .logo_icon {
        color: ${
          MeineComponentsStyle[MeineComponentClassNameMap.GitBranchesHistory]
            .iconColor
        };
      }

      div {
        color: ${
          MeineComponentsStyle[MeineComponentClassNameMap.GitBranchesHistory]
            .color
        };
      }
    }

    ${classNameToSelector(MeineComponentClassNameMap.UsdBrlConversion)} {
      background-color: ${
        MeineComponentsStyle[MeineComponentClassNameMap.UsdBrlConversion]
          .backgroundColor
      };

      div {
        color: ${
          MeineComponentsStyle[MeineComponentClassNameMap.UsdBrlConversion]
            .color
        };
      }
    }

    ${classNameToSelector(MeineComponentClassNameMap.Jira)} {
      background-color: ${
        MeineComponentsStyle[MeineComponentClassNameMap.Jira].backgroundColor
      };

      div {
        color: ${MeineComponentsStyle[MeineComponentClassNameMap.Jira].color};
      }
    }

    ${classNameToSelector(MeineComponentClassNameMap.Ssh)} {
      background-color: ${
        MeineComponentsStyle[MeineComponentClassNameMap.Ssh].backgroundColor
      };

      div {
        color: ${MeineComponentsStyle[MeineComponentClassNameMap.Ssh].color};
      }
    }

    ${classNameToSelector(MeineComponentClassNameMap.DockerCompose)} {
      background-color: ${
        MeineComponentsStyle[MeineComponentClassNameMap.DockerCompose]
          .backgroundColor
      }; 

      div {
        color: ${
          MeineComponentsStyle[MeineComponentClassNameMap.DockerCompose].color
        };
      }
    }

    ${classNameToSelector(MeineComponentClassNameMap.Yarn)} {
      background-color: ${
        MeineComponentsStyle[MeineComponentClassNameMap.Yarn].backgroundColor
      };

      div {
        color: ${MeineComponentsStyle[MeineComponentClassNameMap.Yarn].color};
      }
    }
  }
}`

module.exports.withMeineStyles = config => ({
  ...config,
  // custom CSS to embed in the main window
  css,
  // default font weight: 'normal' or 'bold'
  fontWeight: 'normal',
  // font weight for bold characters: 'normal' or 'bold'
  fontWeightBold: 'normal',
  // line height as a relative unit
  lineHeight: 1,
  // letter spacing as a relative unit
  letterSpacing: 0,
  // `'BEAM'` for |, `'UNDERLINE'` for _, `'BLOCK'` for █
  cursorShape: 'BLOCK',
  // set to `true` (without backticks and without quotes) for blinking cursor
  cursorBlink: false,
  // custom CSS to embed in the terminal window
  termCSS: '',
  // default font size in pixels for all tabs
  fontSize: this.FONT_SIZE,
  // font family with optional fallbacks
  fontFamily: this.FONT_FAMILY,
  // terminal cursor background color and opacity (hex, rgb, hsl, hsv, hwb or cmyk)
  cursorColor: Theme.white,
  // terminal text color under BLOCK cursor
  cursorAccentColor: Theme.black,
  // color of the text
  foregroundColor: Theme.white,
  // terminal background color
  // opacity is only supported on macOS
  backgroundColor: Theme.black,
  // terminal selection color
  selectionColor: '#49473E',
  // border color (window, tabs)
  borderColor: Theme.black,
  // custom padding (CSS format, i.e.: `top right bottom left`)
  padding: '20px 20px 0',
  // the full list. if you're going to provide the full color palette,
  // including the 6 x 6 color cubes and the grayscale map, just provide
  // an array here instead of a color map object
  colors: Theme,
})
