#!/bin/sh
svn propget svn:ignore $1 | grep -v ^$ > svn_ignore.txt
for ignorable in '*.ser' 'logs' 'tmp' '.settings' 'lib' 'dist' 'test-result' 'modules' 'eclipse' '.project' 'precompiled' '.classpath' 'bin' 'target' '*.iml' '*.ipr' '.idea' '.git' '.gitignore'
do
  grep $ignorable svn_ignore.txt
  if [ $? -ne 0 ] ; then echo $ignorable >> svn_ignore.txt ; fi
done
svn propset svn:ignore -F svn_ignore.txt $1
rm -f svn_ignore.txt
