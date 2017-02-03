if exists('g:loaded_simple_comment')
    finish
endif
let g:loaded_simple_comment = 1

let s:cpo_save = &cpo
set cpo&vim

" Commands for changing which characters to comment with
command! CommentSlash call simple_comment#CommentSlash()
command! CommentQuote call simple_comment#CommentQuote()
command! CommentHash call simple_comment#CommentHash()
command! CommentMultiSlash call simple_comment#CommentMultiSlash()
command! CommentMultiXml call simple_comment#CommentMultiXml()

noremap <SID>ToggleComment  :<C-U>call simple_comment#ToggleComment()<CR>
noremap <unique> <script> <Plug>ToggleComment  <SID>ToggleComment
command! ToggleComment call simple_comment#ToggleComment()

noremap <SID>ToggleAllComment  :<C-U>call simple_comment#ToggleAllComment()<CR>
noremap <unique> <script> <Plug>ToggleAllComment  <SID>ToggleAllComment
noremenu <script> Plugin.ToggleAllComment <SID>ToggleAllComment

noremap <SID>MultiLineComment  :<C-U>call simple_comment#MultiLineComment()<CR>
noremap <unique> <script> <Plug>MultiLineComment  <SID>MultiLineComment
noremenu <script> Plugin.MultiLineComment <SID>MultiLineComment

let &cpo = s:cpo_save
unlet s:cpo_save
