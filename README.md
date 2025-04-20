# dotfiles

dotfiles and helpful stuff.

I use [strap](https://github.com/MikeMcQuaid/strap) which uses this repo to automate setup of my Mac system. It will:

- Install Homebrew packages defined in [Brewfile](https://github.com/seanknox/homebrew-brewfile/blob/master/Brewfile)
- Install latest stable version of node with [nvm](https://github.com/nvm-sh/nvm)
- Setup a fancy zsh prompt with [starship](https://starship.rs/)
- Add :rainbow: to `ls` with [lsd](https://github.com/lsd-rs/lsd)
- Install [fnm](https://github.com/Schniz/fnm)
- Install [ghostty](https://ghostty.org/)
- Install my gitconfig preferences
- Setup a number of MacOS settings helpful for developers (faster key repeat rate, don't put computer into sleep mode, etc.)

Everything aside from Homebrew installation is run at the end of the strap process via [strap-after-setup](./script/strap-after-setup).

To use:

1. clone these repos
2. download strap
3. and run.

## Clone 'em

```sh
git clone https://github.com/seanknox/dotfiles ~/.dotfiles
git clone https://github.com/seanknox/homebrew-brewfile ~/.homebrew-brewfile
```

## Download strap

<https://strap.mikemcquaid.com/>

## Run it

```sh
# assuming downloaded to ~/Downloads
bash ~/Downloads/strap.sh
```
