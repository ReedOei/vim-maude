" This file looks for Maude sorts/ops and highlights their names dynamically
" on every read/write of files with the maude filetype
" Author: Reed Oei <me@reedoei.com>

" From: https://stackoverflow.com/questions/4478891/is-there-a-vimscript-equivalent-for-rubys-strip-strip-leading-and-trailing-s
function! maude#Trim(input_string)
    return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! maude#FindKeyword(keyword)
    if ! filereadable(expand("%:p"))
        return []
    endif

    let file = readfile(expand("%:p"))

    let res = []
    for line in file
        " Do this because vim doesn't seem to like repeating capture groups
        let id = '\([^ :]\+ \)\='
        let ids = id . id . id . id . id . id . id . id . id
        let match = matchlist(line, '^ *' . a:keyword . ' ' . ids . '[:.].*$')

        if match != []
            for m in match[1:]
                let trimmed = escape(maude#Trim(m), "\\")

                if trimmed != ""
                    let res = res + [trimmed]
                endif
            endfor
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
    call maude#DynamicHighlight("ops\\=", "dynMaudeOps", "Function")
    call maude#DynamicHighlight("vars\\=", "dynMaudeVar", "Type")
    " This should be last, sorts should have the highest precedence (not
    " ideal, but without a smarter script, this is hard to improve on)
    call maude#DynamicHighlight("sorts\\=", "dynMaudeSorts", "Todo")
endfunction

