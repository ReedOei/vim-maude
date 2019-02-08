" This file looks for Maude sorts/ops and highlights their names dynamically
" on every read/write of files with the maude filetype
" Author: Reed Oei <me@reedoei.com>

function! maude#FindKeyword(keyword)
    let file = readfile(expand("%:p"))

    let res = []
    for line in file
        let match = matchlist(line, '^ *' . a:keyword . ' \([^ ]\+\).*$')

        if match != []
            let res = res + [match[1]]
        endif
    endfor

    return res
endfunction

function! maude#DynamicHighlight(k, synGroup, highlight)
    if hlID(a:synGroup) != 0
        execute "syn clear " . a:synGroup
    endif

    let list = maude#FindKeyword(a:k)
    let wordList = []

    for i in list
        let wordList = wordList + ["\\<" . i . "\\>"]
    endfor

    let regex = join(wordList, "\\|")

    if regex != ""
        execute "syn match " . a:synGroup . " \"" . regex . "\""
        execute "hi def link " . a:synGroup . " " . a:highlight
    endif
endfunction

function! maude#ReloadMaudeIds()
    call maude#DynamicHighlight("sort", "dynMaudeSorts", "Type")
    call maude#DynamicHighlight("op", "dynMaudeOps", "Identifier")
endfunction

