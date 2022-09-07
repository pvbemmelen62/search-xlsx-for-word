#!/bin/sh

CMDNAME=$(basename $0)
USAGE="Usage: $CMDNAME --word <word> <file> [<file> ...]

Copies each file into a tmp/excel.jar,
changes dir into tmp, extracts excel.jar, and then searches xl/sharedStrings.xml .
Afterwards changes one dir up, and deletes subdir tmp ."

if [ $# -le 2 ]; then
  echo "$USAGE" 1>&2
  exit 1
fi

option=$1
shift 1

if [ "$option" != "--word" ] ; then
  echo "$USAGE" 1>&2
  exit 1
fi

word=$1
shift 1

if [[ -f tmp || -d tmp ]] ; then
  echo File or directory "tmp" already exists\; delete it first.
  exit 1
fi

for i in "$@" ; do
  # echo "$i"
  if [ ! -f "$i" ]; then
    echo "$i" does not exist: skipping.
    continue
  fi
  mkdir tmp
  cp "$i" tmp/excel.jar
  cd tmp > /dev/null
  jar xvf excel.jar > /dev/null
  lines=`cat xl/sharedStrings.xml | xmllint --format - | grep $word`
  if [ "" != "$lines" ] ; then
    echo "$i"
    echo "$lines"
  fi
  cd .. > /dev/null
  rm -rf tmp
done
