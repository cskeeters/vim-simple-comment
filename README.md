This plugin was designed for use in vim 7.0 where NERDCommenter won't run.

This plugin allows you to bind keys to essentially run `I//` or select lines (`vip`) and run `:norm I//` ...maybe a bit more.

# Configuration

The following mappings are suggested:

Toggle comment on the current line.

```vim
nmap <leader>c <Plug>ToggleComment
```

Comment each line that is selected.

```vim
vmap <leader>c <Plug>ToggleAllComment
```

Comment all lines included in motion (`:help map-operator`)

```vim
nmap <leader>C <Plug>CommentOperator
```

Insert a multi-line comment start before selected range and multi-line
comment stop after the selected range.

```vim
vmap <leader><leader>c <Plug>MultiLineComment
```

See the [help documentation](doc/simple_commit.vim) for more details.
