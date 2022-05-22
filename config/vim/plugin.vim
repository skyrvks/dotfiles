" Plugin manager
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, {'on': [], 'for': [] })
endfunction

function! DownloadVimClap()
  if systemlist("uname -m")[0] == "x86_64"
    call clap#installer#force_download()
  else
    call clap#installer#install(v:false)
  endif
endfunction

function! InitCommonPlugins()
  Plug 'cespare/vim-toml'
  Plug 'easymotion/vim-easymotion', Cond(!has('nvim-0.5'))
  Plug 'ggandor/lightspeed.nvim'
  Plug 'honza/vim-snippets'
  Plug 'justinmk/vim-dirvish'
  Plug 'liuchengxu/vim-clap', { 'do': { -> DownloadVimClap() } }
  Plug 'liuchengxu/vista.vim'
  Plug 'mhinz/vim-signify', Cond(has('patch-8.0.902'))
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'phaazon/hop.nvim', Cond(has('nvim-0.5'))
  Plug 'preservim/nerdcommenter'
  Plug 'rust-lang/rust.vim'
  Plug 'sakhnik/nvim-gdb'
  Plug 'tomasiser/vim-code-dark'
  Plug 'vim-utils/vim-husk'
endfunction

call plug#begin('~/.vim/plugged')
call InitCommonPlugins()
call plug#end()

function! s:init_vim_signify()
  let g:signify_vcs_list = ['perforce', 'git']
endfunction

function s:init_vim_easymotion()
  if !has('nvim-0.5')
    let g:EasyMotion_smartcase = 1
    nmap <leader>f <Plug>(easymotion-bd-w)
    nmap <Leader>s <Plug>(easymotion-s2)
    nmap <Leader>l <Plug>(easymotion-bd-jk)
  endif
endfunction

function s:init_vim_dirvish() abort
  let g:dirvish_mode = ':sort | sort ,^.*[^/]$, r'
endfunction

function s:init_vim_clap()
  let g:clap_layout = { 'relative': 'editor' }
  let sources = systemlist('chezmoi managed --include files') 
  call map(sources, '"~/" . v:val')
  let g:clap_provider_dotfiles = {
        \ 'source': sources,
        \ 'sink': 'e',
        \ 'description': 'dotfiles',
        \ }
  let g:clap_provider_alias = { 'dotfiles': 'dotfiles' }
  nnoremap <leader>pf <cmd>Clap files<cr>
  nnoremap <leader>pg <cmd>Clap grep2<cr>
  nnoremap <leader>pl <cmd>Clap blines<cr>
  nnoremap <leader>pm <cmd>Clap recent_files<cr>
endfunction

function! s:init_coc_nvim()
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  nmap <silent> <a-[> <Plug>(coc-diagnostic-prev)
  nmap <silent> <a-]> <Plug>(coc-diagnostic-next)
  nmap <silent> <leader>g[ <Plug>(coc-diagnostic-prev)
  nmap <silent> <leader>g] <Plug>(coc-diagnostic-next)
  nmap <silent> <leader>gd <Plug>(coc-definition)
  nmap <silent> <leader>gy <Plug>(coc-type-definition)
  nmap <silent> <leader>gi <Plug>(coc-implementation)
  nmap <silent> <leader>gr <Plug>(coc-references)
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

  " Install when they aren't installed
  let g:coc_global_extensions = [
        \ 'coc-diagnostic',
        \ 'coc-jedi',
        \ 'coc-json',
        \ 'coc-pyright',
        \ 'coc-rust-analyzer',
        \ 'coc-sh',
        \ 'coc-snippets',
        \ 'coc-vimlsp',
        \ ]
endfunction

function! s:init_hop_nvim()
  if has('nvim-0.5')
    lua require('hop').setup()
    nmap <leader>f <cmd>HopWord<cr>
  endif
endfunction

function! s:init_nerdcommenter()
  " Only keep one comment keybinding
  let g:NERDCreateDefaultMappings = 0
  let g:NERDSpaceDelims = 1
  let g:NERDDefaultAlign = 'left'
  let g:NERDCommentEmptyLines = 1
  let g:NERDTrimTrailingWhitespace = 1
  let g:NERDToggleCheckAllLines = 1
  nmap <leader>c<space> <Plug>NERDCommenterToggle
endfunction

" Example to enable nvim-gdb in CLI after s:setup_plugins() is invoked
" nvim -c ':autocmd VimEnter * :GdbStart gdb -q ./a.out'
function! s:init_nvim_gdb()
  if !has('nvim') | return | endif
  let g:nvimgdb_disable_start_keymaps = 1
  let g:nvimgdb_use_cmake_to_find_executables = 0

  nnoremap <leader>dd :GdbStart gdb -q<space>

  " A hook function to set keymaps in the code window
  function! NvimGdbSetKeymaps()
    " First set up the stock keymaps
    lua NvimGdb.i().keymaps:set()

    function! s:nvimGdbGetTBufnr()
      for nr in tabpagebuflist()
        if getbufvar(nr, '&filetype') == 'nvimgdb'
          return nr
        endif
      endfor
    endfunction

    function! s:nvimGdbGoTerminal()
      call win_gotoid(win_findbuf(s:nvimGdbGetTBufnr())[0])
      call feedkeys('i', 'in')
    endfunction

    set updatetime=50
    nnoremap P <cmd>GdbEvalWord<cr>
    nmap i <cmd>call <SID>nvimGdbGoTerminal()<cr>
  endfunction

  " A hook function to unset keymaps in the code window
  function! NvimGdbUnsetKeymaps()
    nunmap P
    nunmap i
    set updatetime=1000

    " Final unset the stock keymaps
    lua NvimGdb.i().keymaps:unset()
  endfunction

  " A hook function to set keymaps in the terminal window
  function! NvimGdbSetTKeymaps()
    " We're going to define single-letter keymaps, so don't try to define them
    " in the terminal window.  The debugger CLI should continue accepting text commands.
    " lua NvimGdb.i().keymaps:set_t()

    tnoremap <silent> <buffer> <esc> <c-\><c-n>
    tnoremap jk <c-\><c-n><c-w>p
  endfunction

  let g:nvimgdb_config_override = {
        \ 'key_next': 'n',
        \ 'key_step': 's',
        \ 'key_continue': 'c',
        \ 'key_breakpoint': 'b',
        \ 'set_keymaps': 'NvimGdbSetKeymaps',
        \ 'set_tkeymaps': "NvimGdbSetTKeymaps",
        \ 'unset_keymaps': 'NvimGdbUnsetKeymaps',
        \ 'termwin_command': 'belowright vnew',
        \ 'codewin_command': 'vnew'
        \ }
endfunction

function! s:setup_plugins()
  call s:init_coc_nvim()
  call s:init_hop_nvim()
  call s:init_nerdcommenter()
  call s:init_nvim_gdb()
  call s:init_vim_clap()
  call s:init_vim_dirvish()
  call s:init_vim_easymotion()
  call s:init_vim_signify()
endfunction

augroup SetupCommonPlugins
  autocmd!
  autocmd! VimEnter * call s:setup_plugins()
augroup END
