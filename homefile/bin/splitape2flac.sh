#! /bin/bash
iconv -f GBK -t UTF-8 $1.cue > temp.cue
shntool split -f temp.cue -t "%n-%t" -o flac $1.ape
rm temp.cue
