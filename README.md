# vim-lark-syntax

Plugin to add syntax highlighting to grammar files of the python 
package lark-parser.

Files must have extension **.lark**

![screenshot](https://github.com/omega16/vim-lark-syntax/blob/master/example.png)

## Installation

### Manual installation

Clone this repository to your own vim plugins folder 

```
cd your_vim_plugin_path; git clone https://github.com/lark-parser/vim-lark-syntax
```

### Plugin manager

Probably add to your .vimrc something like 

```
MANAGER_NAME 'lark-parser/vim-lark-syntax'
```


## TODO

- [x] Correct regex patterns highlight
    + [x] Disable highlight of **()[]{}** if they 
  are preceded by odd number of **\\**.
    + [x] Highlight **\***,**+**,**?** 
- [x] Highlight **,** inside templates 

