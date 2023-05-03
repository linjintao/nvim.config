
# Introduction
This is a nvim config for quick startup

# How to use it
- Create a directory for nvim config, and clone this repository
```
mkdir nvim-config
cd nvim-config
git clone https://github.com/linjintao/nvim.config.git nvim
```
- Add align to use this config
```
XDG_DIR=/path/to/nvim-config
alias nv='XDG_DATA_HOME=$XDG_DIR/share XDG_CONFIG_HOME=$XDG_DIR nvim'
```
- start nvim use `nv`, wait nvim to download plugins, then you are free to use it

