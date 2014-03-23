# QFEnter

QFEnter allows you to open a Quickfix item in a window you choose.
You can choose the window by giving it a focus just before jumping to Quickfix window.
You can also open multiple items at once by including them in the visual block.

A normal mode example:
![qfenter](https://f.cloud.github.com/assets/5915359/1632228/bb76dc72-5774-11e3-83d1-2933b95d5b81.gif)

A visual mode example:
![qfentervisualopt](https://f.cloud.github.com/assets/5915359/2006385/61c6f720-8717-11e3-806b-d0f276af3ef9.gif)

## Usage

In Quickfix window,

**\<Enter\>**, **\<2-LeftMouse\>**  
*Normal mode* : Open an item under cursor in a previously focused window.  
*Visual mode* : Open items in visual block in a previously focused window. As a result, the last item appears in the window. 

**\<Leader\>\<Enter\>**  
*Normal mode* : Open an item under cursor in a new vertical split from a previously focused window.  
*Visual mode* : Open items in visual block in a sequence of new vertical splits from a previously focused window.

**\<Leader\>\<Space\>**  
*Normal mode* : Open an item under cursor in a new horizontal split from a previously focused window.  
*Visual mode* : Open items in visual block in a sequence of new horizontal splits from a previously focused window.

**\<Leader\>\<Tab\>**  
*Normal mode* : Open an item under cursor in a new tab.  
*Visual mode* : Open items in visual block in a sequence of new tabs.  
Quickfix window is automatically opened in the new tab to help you open other Quickfix items.

You can change the key mappings in your .vimrc. The default setting is, 
```
let g:qfenter_open_map = ['<CR>', '<2-LeftMouse>']
let g:qfenter_vopen_map = ['<Leader><CR>']
let g:qfenter_hopen_map = ['<Leader><Space>']
let g:qfenter_topen_map = ['<Leader><Tab>']
```

## Motivation

Default opening methods for QuickFix items are quite inconvenient,

- You cannot select a window in which a file is opened when you press `<Enter>` in Quickfix.  

  > Hitting the \<Enter\> key or double-clicking the mouse on a line has the same effect. The
file containing the error is opened **in the window above the quickfix window**.  
*`:help quickfix`* 

  It is inconsistent with other Quickfix commands like `:cnext` and `:cprev` which open a file in a previously focused window.

- You also cannot specify the window when you use `Ctrl-W <Enter>`, 
because Vim always create a new horizontal split window above Quickfix window and open a file in it.
There is even no command for 'open in new vertical split window'.

They are confusing and bother me every time, so I wrote a simple plugin to make up for these weak points.
It's name comes from the most basic way to open a file from Quickfix window - the `<Enter>` key.

