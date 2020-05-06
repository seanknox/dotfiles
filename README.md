# dotfiles
dotfiles and helpful stuff.

I use [strap](https://github.com/MikeMcQuaid/strap) which uses this repo to automate setup of my Mac system. It will:

- Homebrew packages defined in [.Brewfile](./.Brewfile)
- Configure [hyper](https://hyper.is/) terminal with plugins and settings defined in [.hyper.js](./hyper.js)
- Install latest stable version of node with [nvm](https://github.com/nvm-sh/nvm)
- Install latest stable version of ruby with [rbenv](https://github.com/rbenv/rbenv)
- Setup a fancy zsh prompt with [spaceship-prompt](https://github.com/denysdovhan/spaceship-prompt)
- Add :rainbow: to `ls` with [colorls](https://github.com/athityakumar/colorls)
- Setup a number of MacOS settings helpful for developers (faster key repeat rate, don't put computer into sleep mode, etc.)

Everything aside from Homebrew installation is run at the end of the strap process via [strap-after-setup](./script/strap-after-setup).
