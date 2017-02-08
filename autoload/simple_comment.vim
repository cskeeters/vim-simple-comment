let s:cpo_save = &cpo
set cpo&vim

function! simple_comment#CommentChars()
    return get(b:, 'comment_chars', matchstr(&commentstring, '.*\ze%s'))
endfunction

function! simple_comment#CommentOpenChars()
    let default="/*"
    if &commentstring =~ '--'
        let default="<!--"
    endif
    return get(b:, 'comment_open_chars', l:default)
endfunction

function! simple_comment#CommentCloseChars()
    let default="*/"
    if &commentstring =~ '--'
        let default="-->"
    endif
    return get(b:, 'comment_close_chars', l:default)
endfunction


" Functions to override variables in the current buffer.  Called in ftplugin scripts
function! simple_comment#CommentSlash()
    unlet b:comment_chars
endfunction
function! simple_comment#CommentQuote()
    let b:comment_chars='"'
endfunction

function! simple_comment#CommentHash()
    let b:comment_chars='#'
endfunction

function! simple_comment#CommentMultiSlash()
    unlet b:comment_open_chars
    unlet b:comment_close_chars
endfunction
function! simple_comment#CommentMultiXml()
    let b:comment_open_chars="<!--"
    let b:comment_close_chars="-->"
endfunction

function! simple_comment#IsCommented(line)
    if getline(a:line) =~ '^\s*'.simple_comment#CommentChars()
        return 1
    else
        return 0
    endif
endfunction

" Will put comment chars at the front of the current line or at the line
" number passed as an argument
function! simple_comment#Comment(...)
    let line=""
    if a:0 > 0
        let line=a:1." "
    endif
    execute l:line."normal! I".simple_comment#CommentChars()
endfunction

" Will remove comment chars at the front of the current line or at the line
" number passed as an argument
function! simple_comment#UnComment(...)
    let line=""
    if a:0 > 0
        let line=a:1." "
    endif
    execute l:line."normal! ^".len(simple_comment#CommentChars())."x"
endfunction

" Convenience method for others
function! simple_comment#CommentIf(isCommented, lineno)
    if a:isCommented
        call simple_comment#UnComment(a:lineno)
    else
        call simple_comment#Comment(a:lineno)
    endif
endfunction

" This works for one line or multiple by typing a count before the mapping
" 3<leader>c
function! simple_comment#ToggleComment()
    let isCommented=simple_comment#IsCommented(".")
    let lineno=line(".")
    let repeat=v:count1
    while l:repeat > 0
        call simple_comment#CommentIf(l:isCommented, l:lineno)
        let repeat-=1
        let lineno+=1
    endwhile
endfunction

function! simple_comment#MultiLineComment()
    let comment_open_chars=simple_comment#CommentOpenChars()
    let comment_close_chars=simple_comment#CommentCloseChars()

    let start=line("'<")
    let end=line("'>")

    execute l:end "normal o".l:comment_close_chars
    execute l:start "normal O".l:comment_open_chars
endfunction


" This is like ToggleComment except when operating on a range of lines (from
" visual mode, we want to double comment lines that are already commented
" rather than uncomment those lines.  Parameters make this opfunc compatible.
function! simple_comment#ToggleAllComment(type)
    echom a:type
    if a:type == "V" " Invoked from Visual mode
        let start=line("'<")
        let end=line("'>")
    elseif a:type == 'line' " Invoked via opfunc
        let start=line("'[")
        let end=line("']")
    elseif a:type == 'char' " Invoked via opfunc
        " We still only care about lines, not characters, but this way /
        " (search) motions work.
        let start=line("'[")
        let end=line("']")
    else
        return
    endif

    let isCommented=simple_comment#IsCommented(l:start)
    let lineno=l:start

    while l:lineno <= l:end
        " Don't comment line with only whitespace
        if isCommented || getline(l:lineno) !~ '^\s*$'
            call simple_comment#CommentIf(l:isCommented, l:lineno)
        endif
        let lineno += 1
    endwhile
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
