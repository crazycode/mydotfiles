#! /bin/bash
iconv -f GBK -t UTF-8 $1.cue > temp.cue
# :-/_*x Translate ':' to '-', '/' to '_', and '*' to 'x'
shntool split -f temp.cue -t "%n.%p.%t" -m :-/_*x -o flac $1.ape
#rm temp.cue
