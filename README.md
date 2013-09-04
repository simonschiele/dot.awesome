
# Simons awesome awesome config (-:

This is my little awesome config. I tried to wrap a few of the most common awesome features into a simple config file.

If you want to use it regulary and be able to update this config, create your own myconfig.lua and myapplications.lua (by copying myconfig.lua-example and applications.lua).

you are very welcome to use and improve this config set. send patches, improvements or ideas to [<simon.codingmonkey@googlemail.com>](mailto:simon.codingmonkey@googlemail.com "mailto:simon.codingmonkey@googlemail.com").

## Available clone paths:
    * [https://github.com/simonschiele/awesome.git](https://github.com/simonschiele/awesome.git "view repo on github")
    * [http://simon.psaux.de/git/awesome.git](http://simon.psaux.de/git/awesome.git "view repo on simons cgit")
    * ssh://git@simon.psaux.de/awesome.git (send public key via [email](mailto:simon.codingmonkey@googlemail.com "mailto:simon.codingmonkey@googlemail.com") for write access)

## Versions / Branches
There are two active branches:

    * [master](https://github.com/simonschiele/awesome "master branch on github") (for awesome 3.4)
      Use this one for debian, ubuntu, ...
    * [v3.5](https://github.com/simonschiele/awesome/tree/v3.5 "v3.5 branch on github") (for awesome 3.5) 
      Use this one for awesome from git, arch, debian experimental,...

## Included subrepos:
 * lib/obvious (http://git.mercenariesguild.net/?p=obvious.git;a=summary)
 * lib/vicious (http://git.sysphere.org/vicious/)
 * lib/flaw (https://github.com/dsoulayrol/flaw)
 * lib/bashets (http://gitorious.org/bashets)
 * lib/blingbling (https://github.com/cedlemo/blingbling)


## Usage / Setup:
    
    # Go in your config dir and move away old awesome-config:
    cd ~/.config/
    mv awesome/ awesome-old/
    
    # Clone Repo for awesome 3.4 (see 'clone paths' above):
    git clone <clone-path> awesome/
    
    # If you want config for awesome 3.5, checkout branch v3.5 instead:
    git clone -b v3.5 <clone-path> awesome/
    
    # Checkout the submodules
    cd awesome/
    git submodule init
    git submodule update
    
    # Make a copy of myconfig.lua and edit to your needs:
    cp myconfig.lua-example myconfig.lua
    vim myconfig.lua

## This Configs Default Keysetting:

    # "Windows" (aka clients)
    Mouse Btn 1 + Win/Alt       - Move window
    Mouse Btn 3 + Win/Alt       - Resize window
    Win + n                     - Minimize window
    Win + m                     - Maximize window
    Win + f                     - Set window Fullscreen
    Win + control + space       - Set window Floating
    Win + j/k                   - Switch to next/prev window on screen
    Alt + Tab                   - Switch to next window on screen
    Win + Tab                   - Switch to last active window
    Win + x                     - Close Window
    Win + Shift + x             - xkill
    Win + o                     - Move window to next screen

    # Screens and "Workspaces" (aka Tags)
    Win + ( Shift + ) Space     - next/(last) layout
    Win + Shift + h/l           - Switch "sublayout" of layout
    Win + 1-9                   - Switch to Tag 1-9
    Win + left/right            - Switch to next/prev Tag
    Win + Esc                   - Switch to last used Tag
    Win + Shift + 1-9           - Move window to Tag 1-6
    Win + a                     - Move Cursor (and focus) to next screen
    Win + u                     - Jump to "urgent" (use with mail, IM, irc, ...)

    # Prompts & Tools
    Win + p                     - Menubar Launcher (>= awesome 3.5)
    Win + Enter                 - Terminal
    Win + e/r                   - execute cmd
    Win + Shift + e             - lua prompt
    Win + s                     - ssh
    Win + Shift + s             - ssh (with X11 forwarding)
    Win + F9                    - next keyboard layout (needs config switch)
    Win + F11/F12               - lock screen

    # Awesome itself
    Win + Shift + r             - redraw awesome
    Win + Control + r           - restart awesome
    Win + Control + q           - quit awesome (back to dm/shell)

## Authors

**Simon Schiele**

 * [http://simon.psaux.de/](http://simon.psaux.de/)
 * mailto:[<simon.codingmonkey@googlemail.com>](mailto:simon.codingmonkey@googlemail.com "mailto:simon.codingmonkey@googlemail.com").


