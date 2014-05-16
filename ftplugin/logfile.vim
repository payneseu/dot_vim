
" Vim filetype plugin file

if exists("b:did_ftplugin") | finish | endif

"set syntax=none
"syntax on
setlocal nowrap
"setlocal guifont=courier_new:h11
syn match logError /\(ERROR.*\)\@<=\[[^[]*\] - .*$/
syn match logWarn /\(WARN.*\)\@<=\[[^[]*\] - .*$/
syn match logInfo /\(INFO.*\)\@<=\[[^[]*\] - .*$/
syn match logDebug /\(DEBUG.*\)\@<=\[[^[]*\] - .*$/

syn match logCsfEccApi /\[csf.ecc.api\]/
syn match logCsfEccEvt /\[csf.ecc.evt\]/

hi def link logError ErrorMsg
hi def link logWarn  WarningMsg
hi def link logInfo  SpecialChar 
hi def link logDebug Normal

hi def link logCsfEccApi Underlined
hi def link logCsfEccEvt Type

let b:current_syntax = "logfile"

function! FoldEvents(linenum)
  if getline(a:linenum) =~ '\[csf\.ecc\.evt\]'
    return '>1'
  else
    return 1
  endif
endfunction

function! FoldVcmApi(linenum)
  if getline(a:linenum) =~ '\[csf\.ecc\.vcm\.api\]'
    return '>1'
  else
    return 1
  endif
endfunction

function! FoldApi(linenum)
  if getline(a:linenum) =~ '\[csf\.ecc\.api\]'
    return '>1'
  else
    return 1
  endif
endfunction

function! FoldCallSetup(linenum)
  if getline(a:linenum) =~ '\[csf\.ecc\.evt\].*CCAPI_CALL_EV_CREATED.*ONHOOK'
    return '>1'
  elseif getline(a:linenum) =~ '\[csf\.ecc\.api\].*createCall()'
    return '>1'
  elseif getline(a:linenum) =~ '\[csf\.ecc\.evt\].*STATE.*ONHOOK.*CapabilitySet:[^A-Za-z]*$'
    return '>1'
  else
    return 1
  endif
endfunction

function! FoldConnect(linenum)
  if getline(a:linenum) =~ '#### Enhanced Call Control Version: '
    return '>1'
  elseif getline(a:linenum) =~ '\[csf\.ecc\.api\].*\:\:\(set\|authenticate\|connect\|disconnect\|switchMode\)'
    return '>1'
  else
    return '1'
  endif
endfunction

function! FoldLogText()
  let line = getline(v:foldstart)
  let editedline = substitute(line, '^\d\d\d\d-\d\d-\d\d ', '', 'g')
  let editedline2 = substitute(editedline, ' \[[^\]]*(\d*)\]', '', '')
  return '+-' . v:folddashes . ' ' . printf('%5d', 1 + v:foldend - v:foldstart) . ' lines ' . editedline2
endfunction

function Reformat()
"  execute '%s/\r$//'
  execute 'g/^[ \t]*$/d'
  execute 'g/\[csf\.ecc/call AutoHighlightThread()'
endfunction

function! AutoHighlightThread()
  let threadId = substitute(getline('.'), '^.*\[\(0x\x\{8,7\}\)\].*$', '\1', '')
  let colors = ['Red', 'Green', 'Blue', 'DarkRed', 'DarkGreen', 'DarkBlue', 'Brown']
  if ! has_key(b:highlightThreads, threadId)
	let b:highlightColors[threadId] = colors[len(b:highlightThreads) % len(colors)]
	let b:highlightThreads[threadId] = 'highlightThread' . len(b:highlightThreads)
  endif
  execute 'syn match' b:highlightThreads[threadId] '/\[' . threadId . '\]/'
"  execute 'hi' b:highlightThreads[threadId] 'guifg=' . b:highlightColors[threadId]
endfunction

function! HighlightThread(color)
  let threadId = substitute(getline('.'), '^.*\[\(0x\x\{8\}\)\].*$', '\1', '')
  if ! has_key(b:highlightThreads, threadId)
	let b:highlightThreads[threadId] = 'highlightThread' . len(b:highlightThreads)
  endif
  let b:highlightColors[threadId] = a:color
  execute 'syn match' b:highlightThreads[threadId] '/\[' . threadId . '\]/'
  execute 'hi' b:highlightThreads[threadId] 'guifg=' . a:color
endfunction

let b:highlightThreads = {}
let b:highlightColors = {}

set foldmethod=expr
set foldexpr=FoldConnect(v:lnum)
set foldtext=FoldLogText()
"call Reformat()
"execute '%s/\r$//'
"execute 'g/^[ \t]*$/d'
"execute 'g/\[csf\.ecc/call AutoHighlightThread()'
let b:did_ftplugin = 1
