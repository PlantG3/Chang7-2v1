#!/bin/bash
#SBATCH --time=3-00:00:00

out=Ch72.maker.output
if [ ! -d $out ]; then
	mkdir $out
fi

if [ ! -d $out/Ch72_datastore ]; then
	mkdir $out/Ch72_datastore
fi


pushd $out

for src in ../Ch72*/Ch72.maker.output/Ch72_datastore/*/*; do
	des=`echo $src | sed 's/.*Ch72.maker.output\///g'`
	echo $src
	path1=`echo $des | sed 's/Ch72_datastore\///g' | sed 's/\/.*//g'`
	
	if [ ! -d Ch72_datastore/$path1 ]; then
		mkdir Ch72_datastore/$path1
	fi
	
	path2=`echo $des | sed 's/Ch72_datastore\///g' | sed 's/.*\///g'`
	if [ ! -d Ch72_datastore/$path1/$path2 ]; then
		mkdir Ch72_datastore/$path1/$path2
	fi

	cp -r $src/* Ch72_datastore/$path1/$path2/
done

popd

