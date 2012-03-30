#! /bin/sh
echo $1
iconv -f GBK -t UTF-8 $1 > $1.bak
mv $1.bak $1