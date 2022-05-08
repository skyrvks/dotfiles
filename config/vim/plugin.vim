" Plugin manager
call plug#begin('~/.vim/plugged')

function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, {'on': [], 'for': [] })
endfunction

Plug 'cespare/vim-toml'
Plug 'easymotion/vim-easymotion', Cond(!has('nvim-0.5'))
Plug 'honza/vim-snippets'
Plug 'justinmk/vim-dirvish'
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }
Plug 'liuchengxu/vista.vim'
Plug 'mhinz/vim-signify'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'phaazon/hop.nvim', Cond(has('nvim-0.5'))
Plug 'preservim/nerdcommenter'
Plug 'rust-lang/rust.vim'
Plug 'tomasiser/vim-code-dark'
Plug 'tomlion/vim-solidity'

call plug#end()

function! s:init_vim_signify()
  let g:signify_vcs_list = ['perforce', 'git']
endfunction

function s:init_vim_easymotion()
  if !has('nvim-0.5')
    nmap <leader>f <Plug>(easymotion-bd-w)
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

  let local_bin_path = $HOME . "/.local/bin/"
  call coc#config("rust-analyzer.server.path", local_bin_path . "rust-analyzer")
endfunction

function! s:init_hop_nvim()
  if has('nvim-0.5')
    lua require('hop').setup()
    nmap <leader>f <cmd>HopWord<cr>
  endif
endfunction

function! s:init_nerdcommenter()
  " Only keep one comment keybinding
  let g:NERDCreateDefaultMapping = 1
  let g:NERDSpaceDelims = 1
  let g:NERDDefaultAlign = 'left'
  let g:NERDCommentEmptyLines = 1
  nmap <leader>c<space> <Plug>NERDCommenterToggle
endfunction

function! s:setup_plugins()
  call s:init_coc_nvim()
  call s:init_hop_nvim()
  call s:init_nerdcommenter()
  call s:init_vim_clap()
  call s:init_vim_dirvish()
  call s:init_vim_easymotion()
  call s:init_vim_signify()
endfunction

autocmd! VimEnter * call s:setup_plugins()
