#! /bin/bash
# use UTF-8 cue.
shntool split -f $1.cue -t "%n-%t" -o flac $1.ape
