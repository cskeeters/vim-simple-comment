*simple_comment.txt*	Plugin for commenting code.

This plugin was designed for use in vim 7.0 where NERDCommenter won't run.


						*simple-comment-design*

This plugin allows you to bind keys to essentially run I// or select lines
(vip) and run :norm I// ...maybe a bit more.

The characters "//" can be substited with # or " by running commands:
>
    CommentSlash
    CommentQuote
    CommentHash
<
Or for multi-line commenting:
>
    CommentMultiSlash
    CommentMultiXml
<
These commands are run automatically by scripts in ftplugin.  They essentially
set a buffer variable comment_chars, comment_open_chars, and
comment_close_chars to values appropriate for commenting within that filetype.
In the case of HTML where style and script sections change what the
comment_chars should be, these commands can be run manually (or via mappings).

						*simple-comment-functions*

This plugin can perform the following functions.

    1. Toggle comment on single line................|simple-comment-single|
    2. Toggle comment on multiple lines.............|simple-comment-multi|
    3. Wrap selected lines with multi-line comments.|simple-comment-wrap|


						*simple-comment-single*

The command :ToggleComment will detect if the current line is already
commented.  If it is, it will uncomment it.  If the current line is not
commented, it will comment it.  Since this plugin is mainly designed for line
commenting, it does not detect if the current line is wrapped in /* */
comments on other lines.

						*simple-comment-multi*

The function <Plug>ToggleAllComment is designed to be used in visual mode with
multiple lines selected.  If the first line is line-commented, it will
uncomment each selected line.  If the first line is not line-commented, it
will comment each line skipping lines comprised only of whitespace.

This function will add comment character(s) to lines that are already
commented.  If the user uncomments the same range of lines, the lines that
were orginally commented once, will still be commented.

						*simple-comment-wrap*

The function <Plug>MultiLineComment will wrap the lines in multi-line comment
characters.
>
    /*
    Selected Line 1
    Selected Line 2
    */
<

Currently this plugin does not support removing these multi-line comment
characters.

						*simple-comment-mappings*

The following mappings are suggested:

    Toggle comment on the current line.
>
        nmap <leader>c :ToggleComment<cr>
<
    Comment each line that is selected.
>
        vmap <leader>c <Plug>ToggleAllComment
<
    Insert a multi-line comment start before selected range and multi-line
    comment stop after the selected range.
>
        vmap <leader><leader>c <Plug>MultiLineComment
<

vim:tw=78:fo=tcq2:ts=8:ft=help:norl:
