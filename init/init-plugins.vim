"======================================================================
"
" init-plugins.vim -
"
" Created by skywind on 2018/05/31
" Last Modified: 2018/06/10 23:11
"
"======================================================================
" vim: set ts=4 sw=4 tw=78 noet :



"----------------------------------------------------------------------
" 默认情况下的分组，可以再前面覆盖之
"----------------------------------------------------------------------
if !exists('g:bundle_group')
	let g:bundle_group = ['basic', 'colorscheme' , 'enhanced', 'filetypes', 'textobj']
	" let g:bundle_group += ['lightline' , 'ale','leaderf']
	let g:bundle_group += ['comments','async','wei-self','lua']
  " 'coc','coc-explore','coc-lsp','async']
endif
"'nerdtree'

"----------------------------------------------------------------------
" 计算当前 vim-init 的子路径
"----------------------------------------------------------------------
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')

function! s:path(path)
	let path = expand(s:home . '/' . a:path )
	return substitute(path, '\\', '/', 'g')
endfunc


"----------------------------------------------------------------------
" 在 ~/.nvim/bundles 下安装插件
"----------------------------------------------------------------------
call plug#begin(get(g:, 'bundle_home', '~/.config/nvim-plugins'))


"----------------------------------------------------------------------
" 默认插件
"----------------------------------------------------------------------

" 全文快速移动，<leader><leader>f{char} 即可触发
Plug 'easymotion/vim-easymotion'

" 文件浏览器，代替 netrw
" Plug 'justinmk/vim-dirvish'

" 表格对齐，使用命令 Tabularize
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }

" Diff 增强，支持 histogram / patience 等更科学的 diff 算法
Plug 'chrisbra/vim-diff-enhanced'

"----------------------------------------------------------------------
" Dirvish 设置：自动排序并隐藏文件，同时定位到相关文件
" 这个排序函数可以将目录排在前面，文件排在后面，并且按照字母顺序排序
" 比默认的纯按照字母排序更友好点。
"----------------------------------------------------------------------
function! s:setup_dirvish()
	if &buftype != 'nofile' && &filetype != 'dirvish'
		return
	endif
	if has('nvim')
		return
	endif
	" 取得光标所在行的文本（当前选中的文件名）
	let text = getline('.')
	if ! get(g:, 'dirvish_hide_visible', 0)
		exec 'silent keeppatterns g@\v[\/]\.[^\/]+[\/]?$@d _'
	endif
	" 排序文件名
	exec 'sort ,^.*[\/],'
	let name = '^' . escape(text, '.*[]~\') . '[/*|@=|\\*]\=\%($\|\s\+\)'
	" 定位到之前光标处的文件
	call search(name, 'wc')
	noremap <silent><buffer> ~ :Dirvish ~<cr>
	noremap <buffer> % :e %
endfunc

augroup MyPluginSetup
	autocmd!
	autocmd FileType dirvish call s:setup_dirvish()
augroup END


"----------------------------------------------------------------------
" 基础插件
"----------------------------------------------------------------------
if index(g:bundle_group, 'basic') >= 0

	" 支持库，给其他插件用的函数库
	Plug 'xolox/vim-misc'

	" 用于在侧边符号栏显示 marks （ma-mz 记录的位置）
	Plug 'kshenoy/vim-signature'

	" 用于在侧边符号栏显示 git/svn 的 diff
	" Plug 'mhinz/vim-signify'

	" 根据 quickfix 中匹配到的错误信息，高亮对应文件的错误行
	" 使用 :RemoveErrorMarkers 命令或者 <space>ha 清除错误
	" Plug 'mh21/errormarker.vim'

	" 使用 ALT+e 会在不同窗口/标签上显示 A/B/C 等编号，然后字母直接跳转
	Plug 't9md/vim-choosewin'

	" 提供基于 TAGS 的定义预览，函数参数预览，quickfix 预览
  " Plug 'skywind3000/vim-quickui'
	" Plug 'skywind3000/vim-preview'

	" Git 支持
	Plug 'tpope/vim-fugitive'

	" 使用 ALT+E 来选择窗口
	nmap <m-e> <Plug>(choosewin)

	" 使用 <space>ha 清除 errormarker 标注的错误
	noremap <silent><space>ha :RemoveErrorMarkers<cr>

	" signify 调优
	let g:signify_vcs_list = ['git', 'svn']
	let g:signify_sign_add               = '+'
	let g:signify_sign_delete            = '_'
	let g:signify_sign_delete_first_line = '‾'
	let g:signify_sign_change            = '~'
	let g:signify_sign_changedelete      = g:signify_sign_change

	" git 仓库使用 histogram 算法进行 diff
	let g:signify_vcs_cmds = {
			\ 'git': 'git diff --no-color --diff-algorithm=histogram --no-ext-diff -U0 -- %f',
			\}
endif

if index(g:bundle_group, 'basic') >= 0

	" " 展示开始画面，显示最近编辑过的文件
  " Plug 'mhinz/vim-startify'
  "
	" " 默认不显示 startify
	" let g:startify_disable_at_vimenter = 1
	" let g:startify_session_dir = '~/.nvim/session'
  "
  " let g:startify_update_oldfiles = 1
  " let g:startify_session_autoload = 1
  " let g:startify_session_persistence = 1
  " let g:startify_change_to_dir = 1
  " let g:startify_change_to_vcs_root = 1
  " let g:startify_session_sort = 1
  " let g:startify_relative_path = 1
  " let g:startify_padding_left = 2
  "
  " let g:startify_lists = [
  "         \ { 'type': 'sessions',  'header': ['   Sessions']       },
  "         \ { 'type': 'files',     'header': ['   MRU']            },
  "         \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
  "         \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
  "         \ { 'type': 'commands',  'header': ['   Commands']       },
  "         \ ]
  " hi StartifyBracket ctermfg=240
  " hi StartifyFile    ctermfg=147
  " hi StartifyFooter  ctermfg=240
  " hi StartifyHeader  ctermfg=114
  " hi StartifyNumber  ctermfg=215
  " hi StartifyPath    ctermfg=245
  " hi StartifySlash   ctermfg=240
  " hi StartifySpecial ctermfg=240
endif

if index(g:bundle_group, 'basic') >= 0

	" 一次性安装一大堆 colorscheme
	" Plug 'flazz/vim-colorschemes'
	Plug 'morhetz/gruvbox'
  Plug 'sainnhe/gruvbox-material'
  Plug 'ayu-theme/ayu-vim' 
	" Plug 'itchyny/landscape.vim'
	" Plug 'kaicataldo/material.vim'
	" Plug 'rakr/vim-one'
	" Plug 'NLKNguyen/papercolor-theme'
	" Plug 'sonph/onehalf', { 'rtp': 'vim' }
  "
	" let g:PaperColor_Theme_Options = {
	"   \   'theme': {
	"   \     'default': {
	"   \       'allow_bold': 1,
	"   \		'allow_italic' : 1
	"   \     }
	"   \   },
	"   \'language' : {
	"     \'python':{
	"     \   'highlight_builtins' : 1
	"     \},
	"     \'cpp':{
	"     \	'highlight_standard_library': 1
	"     \},
	"     \'c':{
	"     \	'highlight_builtins' : 1
	"     \}
	"   \}
	" \}
endif

"----------------------------------------------------------------------
" 增强插件
"----------------------------------------------------------------------
if index(g:bundle_group, 'enhanced') >= 0

	" 用 v 选中一个区域后，ALT_+/- 按分隔符扩大/缩小选区
	" Plug 'terryma/vim-expand-region'

	" 快速文件搜索
	" Plug 'junegunn/fzf'

	" 给不同语言提供字典补全，插入模式下 c-x c-k 触发
	Plug 'asins/vim-dict'

	" " 使用 :FlyGrep 命令进行实时 grep
	" Plug 'wsdjeg/FlyGrep.vim'
  "
	" " 使用 :CtrlSF 命令进行模仿 sublime 的 grep
	" Plug 'dyng/ctrlsf.vim'

	" 配对括号和引号自动补全
	" Plug 'Raimondi/delimitMate'

	" 提供 gist 接口
	" Plug 'lambdalisue/vim-gista', { 'on': 'Gista' }

	" ALT_+/- 用于按分隔符扩大缩小 v 选区
	" map <m-=> <Plug>(expand_region_expand)
	" map <m--> <Plug>(expand_region_shrink)
endif


"----------------------------------------------------------------------
" 自动生成 ctags/gtags，并提供自动索引功能
" 不在 git/svn 内的项目，需要在项目根目录 touch 一个空的 .root 文件
" 详细用法见：https://zhuanlan.zhihu.com/p/36279445
"----------------------------------------------------------------------
if index(g:bundle_group, 'tags') >= 0

	" 提供 ctags/gtags 后台数据库自动更新功能
	Plug 'ludovicchabant/vim-gutentags'

	" 提供 GscopeFind 命令并自动处理好 gtags 数据库切换
	" 支持光标移动到符号名上：<leader>cg 查看定义，<leader>cs 查看引用
	Plug 'skywind3000/gutentags_plus'

	" 设定项目目录标志：除了 .git/.svn 外，还有 .root 文件
	let g:gutentags_project_root = ['.root']
	let g:gutentags_ctags_tagfile = '.tags'

	" 默认生成的数据文件集中到 ~/.cache/tags 避免污染项目目录，好清理
	let g:gutentags_cache_dir = expand('~/.cache/tags')

	" 默认禁用自动生成
	let g:gutentags_modules = []

	" 如果有 ctags 可执行就允许动态生成 ctags 文件
	if executable('ctags')
		let g:gutentags_modules += ['ctags']
	endif

	" 如果有 gtags 可执行就允许动态生成 gtags 数据库
	if executable('gtags') && executable('gtags-cscope')
		let g:gutentags_modules += ['gtags_cscope']
	endif

	" 设置 ctags 的参数
	let g:gutentags_ctags_extra_args = []
	let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
	let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
	let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

	" 使用 universal-ctags 的话需要下面这行，请反注释
	let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

	" 禁止 gutentags 自动链接 gtags 数据库
	let g:gutentags_auto_add_gtags_cscope = 0

	let g:gutentags_plus_nomap = 1
	" Find symbol (reference) under cursor
	noremap <silent> <leader>gs :GscopeFind s <C-R><C-W><cr> 
	" Find symbol definition under cursor
	noremap <silent> <leader>gg :GscopeFind g <C-R><C-W><cr>
	" Functions called by this function
	noremap <silent> <leader>gd :GscopeFind d <C-R><C-W><cr>
	" Functions calling this function
	noremap <silent> <leader>gc :GscopeFind c <C-R><C-W><cr>
	" Find text string under cursor
	noremap <silent> <leader>gt :GscopeFind t <C-R><C-W><cr>
	" Find egrep pattern under cursor
	noremap <silent> <leader>ge :GscopeFind e <C-R><C-W><cr>
	" Find file name under cursor
	noremap <silent> <leader>gf :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>
	" Find files #including the file name under cursor
	noremap <silent> <leader>gi :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>
	" Find places where current symbol is assigned
	noremap <silent> <leader>ga :GscopeFind a <C-R><C-W><cr>
	" Find current word in ctags database
	noremap <silent> <leader>gz :GscopeFind z <C-R><C-W><cr>
endif


"----------------------------------------------------------------------
" 文本对象：textobj 全家桶
"----------------------------------------------------------------------
if index(g:bundle_group, 'textobj') >= 0

	" 基础插件：提供让用户方便的自定义文本对象的接口
	Plug 'kana/vim-textobj-user'

	" indent 文本对象：ii/ai 表示当前缩进，vii 选中当缩进，cii 改写缩进
	Plug 'kana/vim-textobj-indent'

	" 语法文本对象：iy/ay 基于语法的文本对象
	Plug 'kana/vim-textobj-syntax'

	" 函数文本对象：if/af 支持 c/c++/vim/java
	Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim', 'java'] }

	" 参数文本对象：i,/a, 包括参数或者列表元素
	Plug 'sgur/vim-textobj-parameter'

	" 提供 python 相关文本对象，if/af 表示函数，ic/ac 表示类
	Plug 'bps/vim-textobj-python', {'for': 'python'}

	" 提供 uri/url 的文本对象，iu/au 表示
	Plug 'jceb/vim-textobj-uri'
endif


"----------------------------------------------------------------------
" 文件类型扩展
"----------------------------------------------------------------------
if index(g:bundle_group, 'filetypes') >= 0

	" " syntax highlight
	" Plug 'pboettch/vim-cmake-syntax'
	" Plug 'plasticboy/vim-markdown'
	" Plug 'elzr/vim-json'
	" Plug 'pangloss/vim-javascript'
  " Plug 'fatih/vim-go'
  "
	" " powershell 脚本文件的语法高亮
	" Plug 'pprovost/vim-ps1', { 'for': 'ps1' }
  "
	" " lua 语法高亮增强
	" Plug 'tbastos/vim-lua', { 'for': 'lua' }
  "
	" " C++ 语法高亮增强，支持 11/14/17 标准
	" Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }
	"
	" " 额外语法文件
	" Plug 'justinmk/vim-syntax-extra', { 'for': ['c', 'bison', 'flex', 'cpp'] }
  "
	" " python 语法文件增强
	" Plug 'vim-python/python-syntax', { 'for': ['python'] }
  "
	" " rust 语法增强
	" Plug 'rust-lang/rust.vim', { 'for': 'rust' }
  "
	" " vim org-mode
	" Plug 'jceb/vim-orgmode', { 'for': 'org' }
endif


"----------------------------------------------------------------------
" airline
"----------------------------------------------------------------------
if index(g:bundle_group, 'airline') >= 0
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	let g:airline_theme = 'fruit_punch'
	let g:airline_left_sep = ''
	let g:airline_left_alt_sep = ''
	let g:airline_right_sep = ''
	let g:airline_right_alt_sep = ''
	let g:airline_powerline_fonts = 0
	let g:airline_exclude_preview = 1
	let g:airline_section_b = '%n'
	"let g:airline_theme='deus'
	let g:airline#extensions#branch#enabled = 0
	let g:airline#extensions#syntastic#enabled = 0
	let g:airline#extensions#fugitiveline#enabled = 0
	let g:airline#extensions#csv#enabled = 0
	let g:airline#extensions#vimagit#enabled = 0
endif

"----------------------------------------------------------------------
" lightline
"----------------------------------------------------------------------

if index(g:bundle_group, 'lightline') >= 0
	 Plug 'itchyny/lightline.vim'
	 Plug 'maximbaz/lightline-ale'
	 
		function! CocCurrentFunction()
			    return get(b:, 'coc_current_function', '')
		endfunction

	 let g:lightline = {
	  \ 'colorscheme': 'gruvbox_material',
    \ 'enable' : {'statusline':1 , 'tabline':1},
    \ 'separator' : { 'left': '', 'right': '' },
    \ 'subseparator' : { 'left': '|', 'right': '|' },
	  \ 'active': {
	  \   'left': [ [ 'mode', 'paste' ],
	  \             [ 'readonly', 'filename'],[ 'modified'],['bufstate'],
	  \				['gitbranch'],['cocstatus']],
	  \   'right': [ ['lineinfo' ],
	  \              [ 'percent' ],
	  \              [ 'fileformat', 'fileencoding', 'filetype'],
	  \				 [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ],['coc_current_function']],
	  \ },
	  \ 'component': {
	  \  'bufstate':'[%1*%M%*%n%R%H]',
	  \  'lineinfo':'%l:%c > %L'
	  \},
	  \ 'component_function': {
		\   'coc_current_function':'CocCurrentFunction',
	  \   'cocstatus': 'coc#status',
	  \   'gitbranch': 'FugitiveHead',
		\		'gitblame' : 'LightlineGitBlame',
	  \ },
	  \ 'component_expand': {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_infos': 'lightline#ale#infos',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ },
	  \ 'component_type' : {
      \     'linter_checking': 'right',
      \     'linter_infos': 'right',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'right',
      \ }
	  \ }	

	  autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

		function! LightlineGitBlame() abort
			let blame = get(b:, 'coc_git_blame', '')
			" return blame
			return winwidth(0) > 100 ? blame : 'blame info over 100'
		endfunction

 endif

"----------------------------------------------------------------------
" NERDTree
"----------------------------------------------------------------------
if index(g:bundle_group, 'nerdtree') >= 0
	Plug 'scrooloose/nerdtree', {'on': ['NERDTree', 'NERDTreeFocus', 'NERDTreeToggle', 'NERDTreeCWD', 'NERDTreeFind'] }
	Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
	let g:NERDTreeMinimalUI = 1
	let g:NERDTreeDirArrows = 1
	let g:NERDTreeHijackNetrw = 0
	noremap <space>nn :NERDTree<cr>
	noremap <space>no :NERDTreeFocus<cr>
	noremap <space>nm :NERDTreeMirror<cr>
	noremap <space>nt :NERDTreeToggle<cr>
endif


"----------------------------------------------------------------------
" LanguageTool 语法检查
"----------------------------------------------------------------------
if index(g:bundle_group, 'grammer') >= 0
	Plug 'rhysd/vim-grammarous'
	noremap <space>rg :GrammarousCheck --lang=en-US --no-move-to-first-error --no-preview<cr>
	map <space>rr <Plug>(grammarous-open-info-window)
	map <space>rv <Plug>(grammarous-move-to-info-window)
	map <space>rs <Plug>(grammarous-reset)
	map <space>rx <Plug>(grammarous-close-info-window)
	map <space>rm <Plug>(grammarous-remove-error)
	map <space>rd <Plug>(grammarous-disable-rule)
	map <space>rn <Plug>(grammarous-move-to-next-error)
	map <space>rp <Plug>(grammarous-move-to-previous-error)
endif


"----------------------------------------------------------------------
" ale：动态语法检查
"----------------------------------------------------------------------
if index(g:bundle_group, 'ale') >= 0
	Plug 'dense-analysis/ale'

	let g:ale_disable_lsp = 1

	" 设定延迟和提示信息
	let g:ale_completion_delay = 500
	let g:ale_echo_delay = 20
	let g:ale_lint_delay = 500
	let g:ale_echo_msg_format = '[%linter%] %code: %%s'

	" 设定检测的时机：normal 模式文字改变，或者离开 insert模式
	" 禁用默认 INSERT 模式下改变文字也触发的设置，太频繁外，还会让补全窗闪烁
	let g:ale_lint_on_text_changed = 'normal'
	let g:ale_lint_on_insert_leave = 1

	" 在 linux/mac 下降低语法检查程序的进程优先级（不要卡到前台进程）
	if has('win32') == 0 && has('win64') == 0 && has('win32unix') == 0
		let g:ale_command_wrapper = 'nice -n5'
	endif

	" 允许 airline 集成
	"let g:airline#extensions#ale#enabled = 1

	" 编辑不同文件类型需要的语法检查器
	let g:ale_linters = {
				\ 'c': ['gcc', 'cppcheck'],
				\ 'cpp': ['gcc', 'cppcheck'],
				\ 'python': ['flake8', 'pylint'],
				\ 'lua': ['luac'],
				\ 'go': ['go build', 'gofmt'],
				\ 'java': ['javac'],
				\ 'javascript': ['eslint'],
				\ 'rust' : ['rls','cargo','rustc']
				\ }


	" 获取 pylint, flake8 的配置文件，在 vim-init/tools/conf 下面
	function s:lintcfg(name)
		let conf = s:path('tools/conf/')
		let path1 = conf . a:name
		let path2 = expand('~/.vim/linter/'. a:name)
		if filereadable(path2)
			return path2
		endif
		return shellescape(filereadable(path2)? path2 : path1)
	endfunc

	" 设置 flake8/pylint 的参数
	let g:ale_python_flake8_options = '--conf='.s:lintcfg('flake8.conf')
	let g:ale_python_pylint_options = '--rcfile='.s:lintcfg('pylint.conf')
	let g:ale_python_pylint_options .= ' --disable=W'
	let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
	let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
	let g:ale_c_cppcheck_options = ''
	let g:ale_cpp_cppcheck_options = ''

	let g:ale_linters.text = ['textlint', 'write-good', 'languagetool']

	" 如果没有 gcc 只有 clang 时（FreeBSD）
	if executable('gcc') == 0 && executable('clang')
		let g:ale_linters.c += ['clang']
		let g:ale_linters.cpp += ['clang']
	endif
endif


"----------------------------------------------------------------------
" echodoc：搭配 YCM/deoplete 在底部显示函数参数
"----------------------------------------------------------------------
if index(g:bundle_group, 'echodoc') >= 0
	Plug 'Shougo/echodoc.vim'
	set noshowmode
	let g:echodoc#enable_at_startup = 1
endif


"----------------------------------------------------------------------
" LeaderF：CtrlP / FZF 的超级代替者，文件模糊匹配，tags/函数名 选择
"----------------------------------------------------------------------
if index(g:bundle_group, 'leaderf') >= 0
	" 如果 vim 支持 python 则启用  Leaderf
	if has('python') || has('python3')
		Plug 'Yggdroot/LeaderF'

		" CTRL+p 打开文件模糊匹配
		let g:Lf_ShortcutF = '<c-p>'

		" ALT+n 打开 buffer 模糊匹配
		let g:Lf_ShortcutB = '<m-n>'

		" CTRL+n 打开最近使用的文件 MRU，进行模糊匹配
		noremap <c-n> :LeaderfMru<cr>

		" ALT+p 打开函数列表，按 i 进入模糊匹配，ESC 退出
		noremap <m-p> :LeaderfFunction!<cr>

		" ALT+SHIFT+p 打开 tag 列表，i 进入模糊匹配，ESC退出
		noremap <m-P> :LeaderfBufTag!<cr>

		" ALT+n 打开 buffer 列表进行模糊匹配
		noremap <m-n> :LeaderfBuffer<cr>

		" ALT+m 全局 tags 模糊匹配
		noremap <m-m> :LeaderfTag<cr>

		" 最大历史文件保存 2048 个
		let g:Lf_MruMaxFiles = 2048

		" ui 定制
		let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }

		" 如何识别项目目录，从当前文件目录向父目录递归知道碰到下面的文件/目录
		let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
		let g:Lf_WorkingDirectoryMode = 'Ac'
		let g:Lf_WindowHeight = 0.30
		let g:Lf_CacheDirectory = expand('~/.vim/cache')

		" 显示绝对路径
		let g:Lf_ShowRelativePath = 0

		" 隐藏帮助
		let g:Lf_HideHelp = 1

		" 模糊匹配忽略扩展名
		let g:Lf_WildIgnore = {
					\ 'dir': ['.svn','.git','.hg'],
					\ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
					\ }

		" MRU 文件忽略扩展名
		let g:Lf_MruFileExclude = ['*.so', '*.exe', '*.py[co]', '*.sw?', '~$*', '*.bak', '*.tmp', '*.dll']
		let g:Lf_StlColorscheme = 'powerline'

		" 禁用 function/buftag 的预览功能，可以手动用 p 预览
		let g:Lf_PreviewResult = {'Function':0, 'BufTag':0}

		" 使用 ESC 键可以直接退出 leaderf 的 normal 模式
		let g:Lf_NormalMap = {
				\ "File":   [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
				\ "Buffer": [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<cr>']],
				\ "Mru": [["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<cr>']],
				\ "Tag": [["<ESC>", ':exec g:Lf_py "tagExplManager.quit()"<cr>']],
				\ "BufTag": [["<ESC>", ':exec g:Lf_py "bufTagExplManager.quit()"<cr>']],
				\ "Function": [["<ESC>", ':exec g:Lf_py "functionExplManager.quit()"<cr>']],
				\ }

	else
		" 不支持 python ，使用 CtrlP 代替
		Plug 'ctrlpvim/ctrlp.vim'

		" 显示函数列表的扩展插件
		Plug 'tacahiroy/ctrlp-funky'

		" 忽略默认键位
		let g:ctrlp_map = ''

		" 模糊匹配忽略
		let g:ctrlp_custom_ignore = {
		  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
		  \ 'file': '\v\.(exe|so|dll|mp3|wav|sdf|suo|mht)$',
		  \ 'link': 'some_bad_symbolic_links',
		  \ }

		" 项目标志
		let g:ctrlp_root_markers = ['.project', '.root', '.svn', '.git']
		let g:ctrlp_working_path = 0

		" CTRL+p 打开文件模糊匹配
		noremap <c-p> :CtrlP<cr>

		" CTRL+n 打开最近访问过的文件的匹配
		noremap <c-n> :CtrlPMRUFiles<cr>

		" ALT+p 显示当前文件的函数列表
		noremap <m-p> :CtrlPFunky<cr>

		" ALT+n 匹配 buffer
		noremap <m-n> :CtrlPBuffer<cr>
	endif
endif

if index(g:bundle_group, 'comments') >= 0
	" Plug 'preservim/nerdcommenter'
  "
	" " Add spaces after comment delimiters by default
	" let g:NERDSpaceDelims = 1
	" " Use compact syntax for prettified multi-line comments
	" let g:NERDCompactSexyComs = 1
	" " Align line-wise comment delimiters flush left instead of following code indentation
	" let g:NERDDefaultAlign = 'left'
	" " Set a language to use its alternate delimiters by default
	" let g:NERDAltDelims_java = 1
	" " Add your own custom formats or override the defaults
	" let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
	" " Allow commenting and inverting empty lines (useful when commenting a region)
	" let g:NERDCommentEmptyLines = 1
	" " Enable trimming of trailing whitespace when uncommenting
	" let g:NERDTrimTrailingWhitespace = 1
	" " Enable NERDCommenterToggle to check all selected lines is commented or not
	" let g:NERDToggleCheckAllLines = 1

  Plug 'numToStr/Comment.nvim'
endif

if index(g:bundle_group, 'wei-self') >= 0
	"=== vim中文文档
	"Plug 'yianwillis/vimcdoc'
	"=== nvim terminal 插件
	"ALT + =: toggle terminal below.
	"ALT + SHIFT + h: move to the window on the left.
	"ALT + SHIFT + l: move to the window on the right.
	"ALT + SHIFT + j: move to the window below.
	"ALT + SHIFT + k: move to the window above.
	"ALT + SHIFT + p: move to the previous window.
	"ALT + -: paste register 0 to terminal.
	"ALT + q: switch to terminal normal mode.
	Plug 'skywind3000/vim-terminal-help'
  let g:terminal_pos = 'rightbelow'
  let g:terminal_cwd = 1 
  let g:terminal_height = 16
	let g:terminal_shell = 'bash'
  " :terminal bash 新tab页启动终端  

	" 括号显示
	" Plug 'luochen1990/rainbow'
	" let g:rainbow_active = 1
	" let g:rainbow_conf = {
	" \	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
	" \	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
	" \	'operators': '_,_',
	" \	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
	" \	'separately': {
	" \		'*': {},
	" \		'tex': {
	" \			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
	" \		},
	" \		'lisp': {
	" \			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
	" \		},
	" \		'vim': {
	" \			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
	" \		},
	" \		'html': {
	" \			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
	" \		},
	" \		'css': 0,
	" \	}
	" \}
  "
	" " 缩进显示
	" Plug 'Yggdroot/indentLine'
  "
	" ccls callHierarchy
	Plug 'm-pilia/vim-ccls'
	let g:ccls_size = 30
	let g:ccls_position = 'botright'
	let g:ccls_orientation = 'horizontal'

  Plug 'sbdchd/neoformat'
  let g:neoformat_cpp_clangformat = {
    \ 'exe': 'clang-format',
    \ 'args': ['--style="{
    \           BasedOnStyle: LLVM,
    \           AccessModifierOffset: -2,
    \           AlignEscapedNewlines: Left,
    \           AlignOperands : true,
    \           AlwaysBreakTemplateDeclarations: true,
    \           BinPackArguments: true,
    \           BinPackParameters: false,
    \           BreakBeforeBinaryOperators: NonAssignment,
    \           Standard: Auto,
    \           IndentWidth: 2,
    \           BreakBeforeBraces: Custom,
    \           BraceWrapping:
    \              {AfterClass:      false,
    \              AfterControlStatement: false,
    \              AfterEnum:       false,
    \              AfterFunction:   true,
    \              AfterNamespace:  false,
    \              AfterObjCDeclaration: false,
    \              AfterStruct:     false,
    \              AfterUnion:      false,
    \              AfterExternBlock: false,
    \              BeforeCatch:     false,
    \              BeforeElse:      false,
    \              IndentBraces:    false,
    \              SplitEmptyFunction: false,
    \              SplitEmptyRecord: false,
    \              SplitEmptyNamespace: false},
    \           ColumnLimit: 100,
    \           AllowAllParametersOfDeclarationOnNextLine: false,
    \           AlignAfterOpenBracket: true}"'],
    \ 'stdin' : 1,
    \ 'stderr' : 1,
  \}
  let g:neoformat_enabled_cpp = ['clangformat']
  let g:neoformat_enabled_c = ['clangformat']
endif

if index(g:bundle_group,'coc') >= 0
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'jackguo380/vim-lsp-cxx-highlight'
	let g:coc_config_home = s:path("tools/coc_config/")
	let g:coc_global_extensions = ['coc-lists','coc-json','coc-marketplace','coc-vimlsp','coc-cmake','coc-snippets','coc-tag']
	let g:coc_global_extensions += ['coc-highlight','coc-git']

  set updatetime=300
  autocmd CursorHold * silent call CocActionAsync('highlight')
  autocmd CursorHoldI * silent call CocActionAsync('showSignatureHelp')

	" Use tab for trigger completion with characters ahead and navigate.
	" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
	" other plugin before putting this into your config.
	inoremap <silent><expr> <TAB>
	      \ pumvisible() ? "\<C-n>" :
	      \ <SID>check_back_space() ? "\<TAB>" :
	      \ coc#refresh()
	inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

	function! s:check_back_space() abort
	  let col = col('.') - 1
	  return !col || getline('.')[col - 1]  =~# '\s'
	endfunction

	" Use <c-space> to trigger completion.
	if has('nvim')
	  inoremap <silent><expr> <c-space> coc#refresh()
	else
	  inoremap <silent><expr> <c-@> coc#refresh()
	endif

	" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
	" position. Coc only does snippet and additional edit on confirm.
	" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
	if exists('*complete_info')
	  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
	else
	  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
	endif

	" Use `[g` and `]g` to navigate diagnostics
	" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
	" nmap <silent> [g <Plug>(coc-diagnostic-prev)
	" nmap <silent> ]g <Plug>(coc-diagnostic-next)

	" GoTo code navigation.
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gc <Plug>(coc-declaration) 
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references-used)

  " "   " bases
  nn <silent> xb :call CocLocations('ccls','$ccls/inheritance')<cr>
  " " " bases of up to 3 levels
  nn <silent> xB :call CocLocations('ccls','$ccls/inheritance',{'levels':3})<cr>
  " " " derived
  nn <silent> xd :call CocLocations('ccls','$ccls/inheritance',{'derived':v:true})<cr>
  " " " derived of up to 3 levels
  nn <silent> xD :call CocLocations('ccls','$ccls/inheritance',{'derived':v:true,'levels':3})<cr>

  " " " caller
  nn <silent> xc :call CocLocations('ccls','$ccls/call')<cr>
  " " " callee
  nn <silent> xC :call CocLocations('ccls','$ccls/call',{'callee':v:true})<cr>

  " " " $ccls/member
  " " " member variables / variables in a namespace
  nn <silent> xm :call CocLocations('ccls','$ccls/member')<cr>
  " " " member functions / functions in a namespace
  nn <silent> xf :call CocLocations('ccls','$ccls/member',{'kind':3})<cr>
  " " " nested classes / types in a namespace
  nn <silent> xs :call CocLocations('ccls','$ccls/member',{'kind':2})<cr>

  nn <silent> xv :call CocLocations('ccls','$ccls/vars')<cr>
  nn <silent> xV :call CocLocations('ccls','$ccls/vars',{'kind':1})<cr>

  nn xx x

  nn <silent><buffer> <leader><l> :call CocLocations('ccls','$ccls/navigate',{'direction':'D'})<cr>
  nn <silent><buffer> <leader><k> :call CocLocations('ccls','$ccls/navigate',{'direction':'L'})<cr>
  nn <silent><buffer> <leader><j> :call CocLocations('ccls','$ccls/navigate',{'direction':'R'})<cr>
  nn <silent><buffer> <leader><h> :call CocLocations('ccls','$ccls/navigate',{'direction':'U'})<cr>


	" Use K to show documentation in preview window.
	nnoremap <silent> K :call <SID>show_documentation()<CR>

	function! s:show_documentation()
	  if (index(['vim','help'], &filetype) >= 0)
	    execute 'h '.expand('<cword>')
	  else
	    call CocAction('doHover')
	  endif
	endfunction

	" Symbol renaming.
	nmap <leader>rn <Plug>(coc-rename)

	" Formatting selected code.
	xmap <leader>f  <Plug>(coc-format-selected)
	nmap <leader>f  <Plug>(coc-format-selected)

	augroup mygroup
	  autocmd!
	  " Setup formatexpr specified filetype(s).
	  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
	  " Update signature help on jump placeholder.
	  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
	augroup end

	" Applying codeAction to the selected region.
	" Example: `<leader>aap` for current paragraph
	xmap <leader>a  <Plug>(coc-codeaction-selected)
	nmap <leader>a  <Plug>(coc-codeaction-selected)

	" Remap keys for applying codeAction to the current buffer.
	nmap <leader>ac  <Plug>(coc-codeaction)
	" Apply AutoFix to problem on the current line.
	nmap <leader>qf  <Plug>(coc-fix-current)

	" Map function and class text objects
	" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
	xmap if <Plug>(coc-funcobj-i)
	omap if <Plug>(coc-funcobj-i)
	xmap af <Plug>(coc-funcobj-a)
	omap af <Plug>(coc-funcobj-a)
	xmap ic <Plug>(coc-classobj-i)
	omap ic <Plug>(coc-classobj-i)
	xmap ac <Plug>(coc-classobj-a)
	omap ac <Plug>(coc-classobj-a)

	" Use CTRL-S for selections ranges.
	" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
	nmap <silent> <C-s> <Plug>(coc-range-select)
	xmap <silent> <C-s> <Plug>(coc-range-select)

	" Add `:Format` command to format current buffer.
	command! -nargs=0 Format :call CocAction('format')

	" Add `:Fold` command to fold current buffer.
	command! -nargs=? Fold :call     CocAction('fold', <f-args>)

	" Add `:OR` command for organize imports of the current buffer.
	command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

	" Add (Neo)Vim's native statusline support.
	" NOTE: Please see `:h coc-status` for integrations with external plugins that
	" provide custom statusline: lightline.vim, vim-airline.
	set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

	" Mappings for CoCList
	" Show all diagnostics.
	" nnoremap <silent><nowait> <space>d  :<C-u>CocList diagnostics<cr>
	" Manage extensions.
	nnoremap <silent><nowait> <space>m  :<C-u>CocList marketplace<cr>
	" Show commands.
	nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
	" Find symbol of current document.
	nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
  " show jump locations
	nnoremap <silent><nowait> <space>l :<C-u>CocList location<cr>
	" Search workspace symbols.
	nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
	" Search git files
	nnoremap <silent><nowait> <space>f  :<C-u>CocList gfiles<cr>
	" Do default action for next item.
	nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
	" Do default action for previous item.
	nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
	" Resume latest coc list.
	nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

endif

if index(g:bundle_group,'coc-explore') >= 0
	let g:coc_global_extensions+= ['coc-explorer']
	nnoremap <space>e :CocCommand explorer<CR>
endif

if index(g:bundle_group, 'coc-lsp') >= 0
	let g:coc_global_extensions+= ['coc-go','coc-rls']
endif

" $(VIM_FILEPATH)    # 当前 buffer 的文件名全路径
" $(VIM_FILENAME)    # 当前 buffer 的文件名（没有前面的路径）
" $(VIM_FILEDIR)     # 当前 buffer 的文件所在路径
" $(VIM_FILEEXT)     # 当前 buffer 的扩展名
" $(VIM_FILENOEXT)   # 当前 buffer 的主文件名（没有前面路径和后面扩展名）
" $(VIM_PATHNOEXT)   # 带路径的主文件名（$VIM_FILEPATH 去掉扩展名）
" $(VIM_CWD)         # 当前 Vim 目录（:pwd 命令返回的）
" $(VIM_RELDIR)      # 相对于当前路径的文件名
" $(VIM_RELNAME)     # 相对于当前路径的文件路径
" $(VIM_ROOT)        # 当前 buffer 的项目根目录
" $(VIM_CWORD)       # 光标下的单词
" $(VIM_CFILE)       # 光标下的文件名
" $(VIM_CLINE)       # 光标停留在当前文件的多少行（行号）
" $(VIM_GUI)         # 是否在 GUI 下面运行？
" $(VIM_VERSION)     # Vim 版本号
" $(VIM_COLUMNS)     # 当前屏幕宽度
" $(VIM_LINES)       # 当前屏幕高度
" $(VIM_SVRNAME)     # v:servername 的值
" $(VIM_DIRNAME)     # 当前文件夹目录名，比如 vim 在 ~/github/prj1/src，那就是 src
" $(VIM_PRONAME)     # 当前项目目录名，比如项目根目录在 ~/github/prj1，那就是 prj1
" $(VIM_INIFILE)     # 当前任务的 ini 文件名
" $(VIM_INIHOME)     # 当前任务的 ini 文件的目录（方便调用一些和配置文件位置相关的脚本）
" :AsyncTaskMacro
if index(g:bundle_group, 'async') >= 0
	Plug 'skywind3000/asynctasks.vim'
	Plug 'skywind3000/asyncrun.vim'
	let g:asyncrun_open = 6
  let g:asynctasks_term_pos = 'tab'
  let g:asynctasks_term_reuse = 1
endif

if index(g:bundle_group, 'lua') >= 0
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'
  
  " For vsnip users.
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'

  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

  Plug 'kyazdani42/nvim-web-devicons' " for file icons
  Plug 'kyazdani42/nvim-tree.lua'
  let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
  let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
  let g:nvim_tree_highlight_opened_files = 1 "0 by default, will enable folder and file icon highlight for opened files/directories.
  let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
  let g:nvim_tree_add_trailing = 1 "0 by default, append a trailing slash to folder names
  let g:nvim_tree_group_empty = 1 " 0 by default, compact folders that only contain a single folder into one node in the file tree
  let g:nvim_tree_icon_padding = ' ' "one space by default, used for rendering the space between the icon and the filename. Use with caution, it could break rendering if you set an empty string depending on your font.
  let g:nvim_tree_symlink_arrow = ' >> ' " defaults to ' ➛ '. used as a separator between symlinks' source and target.
  let g:nvim_tree_respect_buf_cwd = 1 "0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
  let g:nvim_tree_create_in_closed_folder = 1 "0 by default, When creating files, sets the path of a file when cursor is on a closed folder to the parent folder when 0, and inside the folder when 1.
  let g:nvim_tree_special_files = { 'README.md': 1, 'Makefile': 1, 'MAKEFILE': 1 } " List of filenames that gets highlighted with NvimTreeSpecialFile
  let g:nvim_tree_show_icons = {
      \ 'git': 1,
      \ 'folders': 0,
      \ 'files': 0,
      \ 'folder_arrows': 0,
      \ }
  "If 0, do not show the icons for one of 'git' 'folder' and 'files'
  "1 by default, notice that if 'files' is 1, it will only display
  "if nvim-web-devicons is installed and on your runtimepath.
  "if folder is 1, you can also tell folder_arrows 1 to show small arrows next to the folder icons.
  "but this will not work when you set indent_markers (because of UI conflict)
  
  " default will show icon by default if no icon is provided
  " default shows no icon by default
  let g:nvim_tree_icons = {
      \ 'default': '',
      \ 'symlink': '',
      \ 'git': {
      \   'unstaged': "✗",
      \   'staged': "✓",
      \   'unmerged': "",
      \   'renamed': "➜",
      \   'untracked': "★",
      \   'deleted': "",
      \   'ignored': "◌"
      \   },
      \ 'folder': {
      \   'arrow_open': "",
      \   'arrow_closed': "",
      \   'default': "",
      \   'open': "",
      \   'empty': "",
      \   'empty_open': "",
      \   'symlink': "",
      \   'symlink_open': "",
      \   }
      \ }
  
  nnoremap <C-n> :NvimTreeToggle<CR>
  nnoremap <leader>r :NvimTreeRefresh<CR>
  nnoremap <leader>n :NvimTreeFindFile<CR>
  " More available functions:
  " NvimTreeOpen
  " NvimTreeClose
  " NvimTreeFocus
  " NvimTreeFindFileToggle
  " NvimTreeResize
  " NvimTreeCollapse
  " NvimTreeCollapseKeepBuffers
  " a list of groups can be found at `:help nvim_tree_highlight`
  highlight NvimTreeFolderIcon guibg=blue

  Plug 'nvim-lualine/lualine.nvim'
  Plug 'arkav/lualine-lsp-progress'

  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'GustavoKatel/telescope-asynctasks.nvim'

  Plug 'nvim-telescope/telescope-file-browser.nvim'

  Plug 'lewis6991/spellsitter.nvim'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'p00f/nvim-ts-rainbow'

  Plug 'lukas-reineke/indent-blankline.nvim'

  Plug 'glepnir/dashboard-nvim'
  let g:dashboard_default_executive = 'telescope'
  let g:dashboard_session_directory = '~/.cache/nvim/session'
  let g:dashboard_custom_header = [
        \'',
    \'',
    \'        ⢀⣴⡾⠃⠄⠄⠄⠄⠄⠈⠺⠟⠛⠛⠛⠛⠻⢿⣿⣿⣿⣿⣶⣤⡀  ',
    \'      ⢀⣴⣿⡿⠁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣸⣿⣿⣿⣿⣿⣿⣿⣷ ',
    \'     ⣴⣿⡿⡟⡼⢹⣷⢲⡶⣖⣾⣶⢄⠄⠄⠄⠄⠄⢀⣼⣿⢿⣿⣿⣿⣿⣿⣿⣿ ',
    \'    ⣾⣿⡟⣾⡸⢠⡿⢳⡿⠍⣼⣿⢏⣿⣷⢄⡀⠄⢠⣾⢻⣿⣸⣿⣿⣿⣿⣿⣿⣿ ',
    \'  ⣡⣿⣿⡟⡼⡁⠁⣰⠂⡾⠉⢨⣿⠃⣿⡿⠍⣾⣟⢤⣿⢇⣿⢇⣿⣿⢿⣿⣿⣿⣿⣿ ',
    \' ⣱⣿⣿⡟⡐⣰⣧⡷⣿⣴⣧⣤⣼⣯⢸⡿⠁⣰⠟⢀⣼⠏⣲⠏⢸⣿⡟⣿⣿⣿⣿⣿⣿ ',
    \' ⣿⣿⡟⠁⠄⠟⣁⠄⢡⣿⣿⣿⣿⣿⣿⣦⣼⢟⢀⡼⠃⡹⠃⡀⢸⡿⢸⣿⣿⣿⣿⣿⡟ ',
    \' ⣿⣿⠃⠄⢀⣾⠋⠓⢰⣿⣿⣿⣿⣿⣿⠿⣿⣿⣾⣅⢔⣕⡇⡇⡼⢁⣿⣿⣿⣿⣿⣿⢣ ',
    \' ⣿⡟⠄⠄⣾⣇⠷⣢⣿⣿⣿⣿⣿⣿⣿⣭⣀⡈⠙⢿⣿⣿⡇⡧⢁⣾⣿⣿⣿⣿⣿⢏⣾ ',
    \' ⣿⡇⠄⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⢻⠇⠄⠄⢿⣿⡇⢡⣾⣿⣿⣿⣿⣿⣏⣼⣿ ',
    \' ⣿⣷⢰⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⢰⣧⣀⡄⢀⠘⡿⣰⣿⣿⣿⣿⣿⣿⠟⣼⣿⣿ ',
    \' ⢹⣿⢸⣿⣿⠟⠻⢿⣿⣿⣿⣿⣿⣿⣿⣶⣭⣉⣤⣿⢈⣼⣿⣿⣿⣿⣿⣿⠏⣾⣹⣿⣿ ',
    \' ⢸⠇⡜⣿⡟⠄⠄⠄⠈⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟⣱⣻⣿⣿⣿⣿⣿⠟⠁⢳⠃⣿⣿⣿ ',
    \'  ⣰⡗⠹⣿⣄⠄⠄⠄⢀⣿⣿⣿⣿⣿⣿⠟⣅⣥⣿⣿⣿⣿⠿⠋  ⣾⡌⢠⣿⡿⠃ ',
    \' ⠜⠋⢠⣷⢻⣿⣿⣶⣾⣿⣿⣿⣿⠿⣛⣥⣾⣿⠿⠟⠛⠉            ',
    \'',
    \'',
    \]

    Plug 'haringsrob/nvim_context_vt'
    Plug 'SmiteshP/nvim-gps'
endif

"----------------------------------------------------------------------
" 结束插件安装
"----------------------------------------------------------------------
call plug#end()


"----------------------------------------------------------------------
" Lua config
"----------------------------------------------------------------------

if index(g:bundle_group, 'lua') >= 0

set completeopt=menu,menuone,noselect

lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
     ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it. 
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  local opts = { noremap=true, silent=true }
  -- vim.api.nvim_set_keymap('n', '<space>d', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<leader>d', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  
  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  local util = require 'lspconfig.util'
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig').ccls.setup {
    on_attach = on_attach;
    cmd ={"ccls"};
    filetypes = {"c", "cpp", "ipp", "cuda","ic","objc", "objcpp"};
    root_dir = util.root_pattern("compile_commands.json", ".ccls",".git",".svn");
    init_options = {
      cache= {
											directory=".tmp/ccls_cache/";
                               retainInMemory= 1;
															 format ="json";
															 hierarchicalPath = false
                               };
                             clang={
                    pathMappings={}
										};
                    index = {
                      trackDependency = 1;
                              threads = 4
                              };
                    completion = {
                              caseSensitivity= 2;
                              detailedLabel=true;
                              filterAndSort=true
                            };
                    highlight = {
                              lsRanges= true
                            };
						client = {
											snippetSupport=true
										};
                  }
  }

  -- Setup nvim-tree
  require'nvim-tree'.setup {
    -- 关闭文件时自动关闭
    auto_close = true,
    open_on_tab = false,
    open_on_setup = false,
    disable_netrw = true,
    update_focused_file = {
      enable      = true,
      update_cwd  = false,
      ignore_list = {}
    },
    -- 不显示 git 状态图标
    git = {
        enable = true
    }
  }

  require'nvim-web-devicons'.setup {
    -- your personnal icons can go here (to override)
    -- you can specify color or cterm_color instead of specifying both of them
    -- DevIcon will be appended to `name`
    -- override = {
    --  zsh = {
    --    icon = "",
    --    color = "#428850",
    --    cterm_color = "65",
    --    name = "Zsh"
    --  }
    -- };
    -- globally enable default icons (default to false)
    -- will get overriden by `get_icons` option
    default = false;
  }   

  require('telescope').setup{
    --local opts = {noremap = true, slient = true}
    defaults = {
      -- Default configuration for telescope goes here:
      -- config_key = value,
      -- path_display = "smart";
            color_devicons = false,
            -- Format path as "file.txt (path\to\file\)"
            path_display = function(opts, path)
              -- local tail = require("telescope.utils").path_tail(path)
              local smart = require("telescope.utils").path_smart(path)
              return string.format("%s", smart)
            end,
      mappings = {
        i = {
          -- map actions.which_key to <C-h> (default: <C-/>)
          -- actions.which_key shows the mappings for your picker,
          -- e.g. git_{create, delete, ...}_branch for the git_branches picker
          -- ["<C-h>"] = "which_key"
        },
        n = {
          -- ["gd"] = require('telescope.builtin'.lsp_definitions{}
        }
      }
    },
    pickers = {
      -- Default configuration for builtin pickers goes here:
      -- picker_name = {
      --   picker_config_key = value,
      --   ...
      -- }
      -- Now the picker_config_key will be applied every time you call this
      -- builtin picker
    },
    extensions = {
      -- Your extension configuration goes here:
      -- extension_name = {
      --   extension_config_key = value,
      -- }
      -- please take a look at the readme of the extension you want to configure
      fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
      },
      file_browser = {
        theme = "ivy",
        -- picker = {
        --   cwd_to_path = true,
        -- },
        mappings = {
          ["i"] = {
            -- your custom insert mode mappings
          },
          ["n"] = {
            -- your custom normal mode mappings
          },
        },
      },
    }
  }
  require('telescope').load_extension('fzf')
  require("telescope").load_extension "file_browser"
  -- require("telescope").extensions.file_browser.picker_.file_browser{
  --  cwd_to_path = true; 
  -- }

  local gps = require("nvim-gps")
  require('lualine').setup {
    options = {
      icons_enabled = false,
      theme = 'horizon',
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
      disabled_filetypes = {},
      always_divide_middle = true,
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'filename', { gps.get_location, cond = gps.is_available },'lsp_progress'},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    extensions = {}
  }

  require'nvim-treesitter.configs'.setup {
    -- One of "all", "maintained" (parsers with maintainers), or a list of languages
    -- ensure_installed = "maintained",
    ensure_installed = {"c","cpp","bash"},

    -- Install languages synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- List of parsers to ignore installing
    ignore_install = { "" },

    highlight = {
      -- `false` will disable the whole extension
      enable = true,

      -- list of language that will be disabled
      disable = {},

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        -- init_selection = "gnn",
        -- node_incremental = "grn",
        -- scope_incremental = "grc",
        -- node_decremental = "grm",
      }
    },
    indent = {
      enable = true
    },
    rainbow = {
      enable = true,
      -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
      extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
      max_file_lines = nil, -- Do not enable for files with more than n lines, int
      -- colors = {}, -- table of hex strings
      -- termcolors = {} -- table of colour name strings
    }
  }

  require('spellsitter').setup {
    -- Whether enabled, can be a list of filetypes, e.g. {'python', 'lua'}
    enable = true,
    }

  require('gitsigns').setup {
    signs = {
      add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
      change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
      delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
      topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
      changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    },
    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
    linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
      interval = 1000,
      follow_files = true
    },
    attach_to_untracked = true,
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000,
    preview_config = {
      -- Options passed to nvim_open_win
      border = 'single',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1
    },
    yadm = {
      enable = false
    },
  }

  vim.opt.listchars:append("eol:↴")
  
  require("indent_blankline").setup {
    enabled = false,
    use_treesitter = true,
    show_current_context = true,
    show_current_context_start = true,
    char_list = {'|', '¦', '┆', '┊'}

  }

  require('Comment').setup()

  require('nvim_context_vt').setup({
    -- Enable by default. You can disable and use :NvimContextVtToggle to maually enable.
    -- Default: true
    enabled = true,
  
    -- Override default virtual text prefix
    -- Default: '-->'
    prefix = '->',
  
    -- Override the internal highlight group name
    -- Default: 'ContextVt'
    -- highlight = 'CustomContextVt',
  
    -- Disable virtual text for given filetypes
    -- Default: { 'markdown' }
    disable_ft = { 'markdown' },
  
    -- Disable display of virtual text below blocks for indentation based languages like Python
    -- Default: false
    disable_virtual_lines = false,
  
    -- Same as above but only for spesific filetypes
    -- Default: {}
    disable_virtual_lines_ft = { 'yaml' },
  
    -- How many lines required after starting position to show virtual text
    -- Default: 1 (equals two lines total)
    min_rows = 1,
  
    -- Same as above but only for spesific filetypes
    -- Default: {}
    min_rows_ft = {},
  
  -- -- Custom virtual text node parser callback
  -- -- Default: nil
  -- custom_parser = function(node, ft, opts)
  --   local ts_utils = require('nvim-treesitter.ts_utils')

  --   -- If you return `nil`, no virtual text will be displayed.
  --   if node:type() == 'function' then
  --     return nil
  --   end

  --   -- This is the standard text
  --   return '--> ' .. ts_utils.get_node_text(node)[1]
  -- end,

  -- -- Custom node validator callback
  -- -- Default: nil
  -- custom_validator = function(node, ft, opts)
  --   -- Internally a node is matched against min_rows and configured targets
  --   local default_validator = require('nvim_context_vt.utils').default_validator
  --   if default_validator(node, ft) then
  --     -- Custom behaviour after using the internal validator
  --     if node:type() == 'function' then
  --       return false
  --     end
  --   end

  --   return true
  -- end,

  -- -- Custom node virtual text resolver callback
  -- -- Default: nil
  -- custom_resolver = function(nodes, ft, opts)
  --   -- By default the last node is used
  --   return nodes[#nodes]
  -- end,
  })


  require("nvim-gps").setup({

	  disable_icons = true,           -- Setting it to true will disable all icons

	  icons = {
	  	["class-name"] = ' ',      -- Classes and class-like objects
	  	["function-name"] = ' ',   -- Functions
	  	["method-name"] = ' ',     -- Methods (functions inside class-like objects)
	  	["container-name"] = '⛶ ',  -- Containers (example: lua tables)
	  	["tag-name"] = '炙'         -- Tags (example: html tags)
	  },

	  -- Add custom configuration per language or
	  -- Disable the plugin for a language
	  -- Any language not disabled here is enabled by default
	  languages = {

	  	-- Disable for particular languages
	  	-- ["bash"] = false, -- disables nvim-gps for bash
	  	-- ["go"] = false,   -- disables nvim-gps for golang

	  	-- Override default setting for particular languages
	  	-- ["ruby"] = {
	  	--	separator = '|', -- Overrides default separator with '|'
	  	--	icons = {
	  	--		-- Default icons not specified in the lang config
	  	--		-- will fallback to the default value
	  	--		-- "container-name" will fallback to default because it's not set
	  	--		["function-name"] = '',    -- to ensure empty values, set an empty string
	  	--		["tag-name"] = ''
	  	--		["class-name"] = '::',
	  	--		["method-name"] = '#',
	  	--	}
	  	--}
	  },

	  separator = ' @ ',

	  -- limit for amount of context shown
	  -- 0 means no limit
	  depth = 1,

	  -- indicator used when context hits depth limit
	  depth_limit_indicator = "..."
  })  
EOF

nnoremap gd <cmd>lua require'telescope.builtin'.lsp_definitions{}<CR>
nnoremap gr <cmd>lua require'telescope.builtin'.lsp_references{}<CR>
nnoremap gD <cmd>lua require'telescope.builtin'.lsp_declaration{}<CR>
nnoremap K <cmd>lua require'telescope.builtin'.lsp_hover{}<CR>
nnoremap gi <cmd>lua require'telescope.builtin'.lsp_implementations{}<CR>
nnoremap gy <cmd>lua require'telescope.builtin'.lsp_type_definitions{}<CR>
nnoremap <space>d <cmd>lua require'telescope.builtin'.diagnostics{}<CR>
nnoremap <space>o <cmd>lua require'telescope.builtin'.lsp_document_symbols{}<CR>
nnoremap <space>w <cmd>lua require'telescope.builtin'.lsp_workspace_symbols{}<CR>
nnoremap <space>f <cmd>lua require'telescope.builtin'.find_files({cwd=vim.call("asyncrun#get_root","%")})<CR>
nnoremap <space>g <cmd>lua require'telescope.builtin'.git_files{}<CR>
nnoremap <space>b <cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find{}<CR>
nnoremap <space>h <cmd>lua require'telescope.builtin'.oldfiles{}<CR>
nnoremap <space>s <cmd>lua require'telescope.builtin'.live_grep{}<CR>
nnoremap <space>t <cmd>lua require('telescope').extensions.asynctasks.all()<CR>
nnoremap <space>e <cmd>lua require "telescope".extensions.file_browser.file_browser({cwd_to_path=true,path=vim.call("expand","%:p:h")})<CR>

endif
