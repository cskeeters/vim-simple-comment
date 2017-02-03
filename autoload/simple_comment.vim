let s:cpo_save = &cpo
set cpo&vim

function! simple_comment#CommentChars()
    return get(b:, 'comment_chars', '//')
endfunction

function! simple_comment#CommentOpenChars()
    return get(b:, 'comment_open_chars', '/*')
endfunction

function! simple_comment#CommentCloseChars()
    return get(b:, 'comment_close_chars', '*/')
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
    if getline(a:line) =~ "^\s*".simple_comment#CommentChars()
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

" This works for one line or multiple by typing a count before the mapping
" 3<leader>c
function! simple_comment#ToggleComment()
    let isCommented=simple_comment#IsCommented(".")
    let lineno=line(".")
    let repeat=v:count1
    while l:repeat > 0
        if l:isCommented
            call simple_comment#UnComment(l:lineno)
        else
            call simple_comment#Comment(l:lineno)
        endif
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
" rather than uncomment those lines.
function! simple_comment#ToggleAllComment()
    let comment_chars=simple_comment#CommentChars()

    let start=line("'<")
    let end=line("'>")
    let current=l:start

    if simple_comment#IsCommented("'<")
        while l:current <= l:end
            call simple_comment#UnComment(l:current)
            let current += 1
        endwhile
    else
        while l:current <= l:end
            " Don't comment line with only whitespace
            if getline(l:current) !~ "^\s*$"
                call simple_comment#Comment(l:current)
            endif
            let current += 1
        endwhile
    endif
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
