require("plugins").setup()

function ToggleMouse()
  -- attributes in opt are tables
  local table = vim.opt.mouse:get();
  if table.a then
    vim.opt.mouse = ""
  else
    vim.opt.mouse = "a"
  end
end
vim.keymap.set('n', '<F3>', ':lua ToggleMouse()<CR>', {noremap = true, silent = true})


local api = vim.api
local g = vim.g
local opt = vim.opt

opt.termguicolors = true -- Enable colors in terminal
opt.hlsearch = true --Set highlight on search
opt.number = true --Make line numbers default
--opt.mouse = "a" --Enable mouse mode
opt.breakindent = true --Enable break indent
opt.undofile = true --Save undo history
opt.ignorecase = true --Case insensitive searching unless /C or capital in search
opt.smartcase = true -- Smart case
opt.updatetime = 250 --Decrease update time
opt.signcolumn = "yes" -- Always show sign column
--opt.relativenumber = true --Make relative number default
--opt.clipboard = "unnamedplus" -- Access system clipboard

local o = vim.o
o.expandtab = true
o.smartindent = true
o.tabstop = 2
o.shiftwidth = 2

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

--[[ for debug 
function TablePrint(t)
  for k,v in pairs(t)  do
    if type(v)=="table" then
      print(k)
      TablePrint(v)
    else 
      print('\t',k,v)
    end
  end      
end
]]--
