#!/bin/bash
# get absolute path of executed shell
execDir=$(cd $(dirname $0); pwd)
baseDir=$(dirname ${execDir})
echo "execDir : ${execDir}"
echo "baseDir : ${baseDir}"
