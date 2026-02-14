
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
  " let Vundle manage Vundle, required
  Plugin 'VundleVim/Vundle.vim'

  " Git
  " Plugin 'tpope/vim-fugitive' # mostly commands I dont use
  "Plugin 'airblade/vim-gitgutter' " shows to the left, markers of added/changed lines

  " Visuals
  Plugin 'vim-airline/vim-airline' " vim status bar at the bottom
  " Plugin 'altercation/vim-colors-solarized'
  Plugin 'flazz/vim-colorschemes' "ref: https://github.com/flazz/vim-colorschemes/tree/master/colors

  " Misc
  " Plugin 'tpope/vim-surround' " might remove
  " Plugin 'scrooloose/nerdtree' "might remove
  " let NERDTreeShowHidden=1

  " Plugin 'kien/ctrlp.vim'
  " Plugin 'editorconfig/editorconfig-vim' "might remove
  " Plugin 'ajh17/vimcompletesme' minimal, use below
  " Plugin 'ycm-core/youcompleteme' needs further compiling, a bit slow
  " Plugin 'lifepillar/vim-mucomplete' "should work well with jedi-vim, needs configs
  " Plugin 'delimitMate.vim' " auto-inserts closing curly braces, brackets, quotes etc

  " Plugin 'dense-analysis/ale' " linting

  Plugin 'junegunn/fzf'

  " not a fan, too slow
  "Plugin 'davidhalter/jedi-vim' 
  "Plugin 'ervandew/supertab' " works well with jedi-vim

  " Plugin 'yuratomo/w3m.vim'

  " expands html, div#header to <div id="header"></div>
  " Plugin 'rstacruz/sparkup', {'rtp': 'vim/'} 
  "
  " Plugin 'mileszs/ack.vim'  " might remove

  " Language
  Plugin 'sheerun/vim-polyglot' " this is a good one
  " Plugin 'fatih/vim-go' " supposed to provide better syntax highlight plus some commands that i dont use

  " Needs further config
  " Plugin 'scrooloose/syntastic'

  " Indentation
  " Detect indentation automatically (tab|space) to set shiftwidth and expandtab
  " Plugin 'tpope/vim-sleuth'
  
  " Plugin 'github/copilot.vim' " basic code completion
  " Plugin 'nvim-lua/plenary.nvim' " required for chat plugin below
  " Plugin 'CopilotC-Nvim/CopilotChat.nvim'

  " All of your Plugins must be added before the following line
call vundle#end()            " required

" lua << EOF
" require("CopilotChat").setup {
"   -- See Configuration section for options
" }
" EOF


"""""""""""""""
" NerdTREE
map <C-n> :NERDTreeToggle<CR>



"""""""""""""""
" Completion
set completeopt+=menuone,noselect,noinsert,preview
" Automatic-dropdown
let g:mucomplete#enable_auto_at_startup = 1

set belloff+=ctrlg " turn off some bleeping


"""""""""""""""
" ale options (linter)
let g:ale_linters = {
      \   'python': ['flake8', 'pylint'],
      \   'javascript': ['eslint'],
      \}
"let g:ale_linters = {
"      \   'python': ['flake8'],
"      \   'javascript': ['eslint'],
"      \}
"
" autofix using github.com/google/yapf
let g:ale_fixers = {
      \    'python': ['yapf'],
      \}
nmap <F10> :ALEFix<CR>
" format on save
let g:ale_fix_on_save = 1

"""""""""""""""
" Misc
set relativenumber
set number 
" set spell
"set autoindent "follows identation of previous line
" set smartindent
set hlsearch "highlight search results
set incsearch "search as you type
set smartcase
set nohidden
set confirm
set showcmd
set autoread "When a file has been detected to have been changed outside of Vim and it has not been changed inside of Vim, automatically read it again.
syntax enable
set background=dark
colorscheme molokai

" Enable Mouse interaction
set mouse=a

set clipboard=unnamed

set shortmess-=S
set tabstop=4 "tab width

" set textwidth=80

" Tab navigation
"map <C-up> :tabr<cr>
"map <C-down> :tabl<cr>
map <C-left> :tabp<cr>
map <C-right> :tabn<cr>

" VIM FZF
nmap <C-P> :FZF<CR>
" If installed using Homebrew
"set rtp+=/usr/local/opt/fzf
set rtp+=/opt/homebrew/bin/fzf
" If installed using git
" set rtp+=~/.fzf
"

" interactive shell (:!...)
" needed for loading your aliases
"set shellcmdflag=-ic

set colorcolumn=80
"set cursorline " highlights current line, can cause slowness

" uses the NFA regex engine, faster in some situations, mostly with typescript files
" see `:help 're'` for details
set re=2

set shell=/bin/bash
set nowrap
