source ~/.zinit/zinit.zsh

 # 快速目录跳转
 zinit ice lucid wait='1'
 zinit light skywind3000/z.lua

 # 语法高亮
 zinit ice lucid wait='0' atinit='zpcompinit'
 zinit light zdharma/fast-syntax-highlighting

 # 自动建议
 zinit ice lucid wait="0" atload='_zsh_autosuggest_start'
 zinit light zsh-users/zsh-autosuggestions

 # 补全
 zinit ice lucid wait='0'
 zinit light zsh-users/zsh-completions

 # 加载 OMZ 框架及部分插件
 zinit snippet OMZ::lib/completion.zsh
 zinit snippet OMZ::lib/history.zsh
 zinit snippet OMZ::lib/key-bindings.zsh
 zinit snippet OMZ::lib/theme-and-appearance.zsh
 zinit snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh
 zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh

 zinit ice svn
 zinit snippet OMZ::plugins/extract

 zinit ice lucid wait='1'
 zinit snippet OMZ::plugins/git/git.plugin.zsh
 zinit snippet PZT::modules/helper/init.zsh

 zinit snippet OMZ::lib/theme-and-appearance.zsh
 zinit snippet OMZ::lib/git.zsh
 zinit snippet OMZ::themes/ys.zsh-theme
