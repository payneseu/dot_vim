"=============================================================================
" Copyright (c) 2007-2010 Takeshi NISHIDA
"
"=============================================================================
" LOAD GUARD {{{1

if !l9#guardScriptLoading(expand('<sfile>:p'), 0, 0, [])
  finish
endif

" }}}1
"=============================================================================
" GLOBAL FUNCTIONS {{{1

"
function fuf#marklist#createHandler(base)
  return a:base.concretize(copy(s:handler))
endfunction

"
function fuf#marklist#getSwitchOrder()
  return g:fuf_marklist_switchOrder
endfunction

"
function fuf#marklist#getEditableDataNames()
  return []
endfunction

"
function fuf#marklist#renewCache()
endfunction

"
function fuf#marklist#requiresOnCommandPre()
  return 0
endfunction

"
function fuf#marklist#onInit()
  call fuf#defineLaunchCommand('FufMarkList', s:MODE_NAME, '""', [])
endfunction

" }}}1
"=============================================================================
" LOCAL FUNCTIONS/VARIABLES {{{1

let s:MODE_NAME = expand('<sfile>:t:r')

"
"function s:getMarksLines()
"  redir => result
"  ":silent marks
"  :marks
"  redir END
"  return split(result, "\n")
"endfunction
"
""
function s:parseMarksLine(line, bufnrPrev)
"  "return matchlist(a:line, '^\(.\)\s\+\(\d\+\)\s\(.*\)$')
"  let elements = matchlist(a:line, '\v^\s*(.)\s+(\d+)\s+(\d+)\s*(.*)$')
"  if empty(elements)
"    return {}
"  endif
""  let linePrevBuffer = join(getbufline(a:bufnrPrev, elements[3]))
""  if stridx(linePrevBuffer, elements[5]) >= 0
""    let fname = bufname(a:bufnrPrev)
""    let fname_text  = elements[4]
""  else
""    let fname = elements[4]
""    let text  = join(getbufline('^' . elements[5] . '$', elements[3]))
""  endif
"  return  {
"        \   'prefix': elements[0],
"        \   'count' : elements[1],
"        \   'lnum'  : elements[2],
"        \   'fname_text'  : elements[3],
"        \ }
endfunction

"
function s:makeItem(line, bufnrPrev)
"  let parsed = s:parseMarksLine(a:line, a:bufnrPrev)
"  if empty(parsed)
"    return {}
"  endif
"  let item = fuf#makeNonPathItem(parsed.fname_text, '')
"  let item.abbrPrefix = parsed.prefix
"  let item.lnum = parsed.lnum
"  let item.fname = parsed.fname_text
"  return item
endfunction


function s:findItem(items, word)
  for item in a:items
    if item.word ==# a:word
      return item
    endif
  endfor
  return {}
endfunction



" }}}1
"=============================================================================
" s:handler {{{1

let s:handler = {}

"
function s:handler.getModeName()
  return s:MODE_NAME
endfunction

"
function s:handler.getPrompt()
  return fuf#formatPrompt(g:fuf_marklist_prompt, self.partialMatching, '')
endfunction

"
function s:handler.getPreviewHeight()
  return g:fuf_previewHeight
endfunction

"
function s:handler.isOpenable(enteredPattern)
  return 1
endfunction

"
function s:handler.makePatternSet(patternBase)
  return fuf#makePatternSet(a:patternBase, 's:interpretPrimaryPatternForNonPath',
        \                   self.partialMatching)
endfunction

"
function s:handler.makePreviewLines(word, count)
  let items = filter(copy(self.items), 'v:val.word ==# a:word')
  if empty(items)
    return []
  endif
  let lines = fuf#getFileLines(items[0].fname)
  return fuf#makePreviewLinesAround(
        \ lines, [items[0].lnum - 1], a:count, self.getPreviewHeight())
endfunction

"
function s:handler.getCompleteItems(patternPrimary)
  return self.items
endfunction

"
function s:handler.onOpen(word, mode)
  call fuf#prejump(a:mode)
  "call filter(self.items, 'v:val.word ==# a:word')
"  let item = s:findItem(self.items, a:word)
"  let marks = values(a:word)[0]
"  let mark = matchlist(a:word, '\v^\s*(.).*$')
  let elements = matchlist(a:word, '\v^\s*([^\s])\s+(\d+)\s+(\d+)\s*(.*)$')
"  redir! > ./a_match
"  echo elements[0] 
"  echo elements[1] 
"  echo elements[2] 
"  echo elements[3] 
"  echo elements[4] 
"  redir END 
  execute 'normal `' . elements[1] 
endfunction

"
function s:handler.onModeEnterPre()
"  let self.items = s:getMarksLines()
  redir => result
  :silent marks
  redir END
  let self.items = split(result, "\n")
  call filter(self.items,'v:key>0')
endfunction

"
function s:handler.onModeEnterPost()
"  call map(self.items, 's:makeItem(v:val, self.bufNrPrev)')
  call map(self.items, 'fuf#makeNonPathItem(v:val, "")')
"  call filter(self.items, '!empty(v:val)')
"  call reverse(self.items)
"  let tab = repeat(' ', getbufvar(self.bufNrPrev, '&tabstop'))
  call fuf#mapToSetSerialIndex(self.items, 1)
  call map(self.items, 'fuf#setAbbrWithFormattedWord(v:val, 0)')
endfunction

"
function s:handler.onModeLeavePost(opened)
endfunction

" }}}1
"=============================================================================
" vim: set fdm=marker:

