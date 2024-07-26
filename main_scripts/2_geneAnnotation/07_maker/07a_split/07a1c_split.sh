#!/bin/bash

ref=../data/Ch7-2v1.fasta
if [ -d split ]; then
	rm -rf split
fi
mkdir split
# split
pushd split
split.fasta.pl --num 1 --decrease --prefix all ../$ref
popd

