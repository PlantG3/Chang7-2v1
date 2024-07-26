#!/bin/bash
for i in `seq 1 1550`; do
	dirfound=noOUT
	gfffound=noGFF
	if [ -d Ch72_all.${i} ]; then
		dirfound=yesOUT
		gff=`find Ch72_all.${i}/Ch72.maker.output/Ch72_datastore/*/*/*/*gff 2>/dev/null`;
		if [ ! -z $gff ]; then
			gfffound=yesGFF
		fi
	fi
	echo -e "large\t"$i"\t"$dirfound"\t"$gfffound
done

