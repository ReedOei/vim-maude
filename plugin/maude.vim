" This file looks for Maude sorts/ops and highlights their names dynamically
" on every read/write of files with the maude filetype
" Author: Reed Oei <me@reedoei.com>

au BufNewFile,BufReadPost,BufWritePost *.maude :call maude#ReloadMaudeIds()

