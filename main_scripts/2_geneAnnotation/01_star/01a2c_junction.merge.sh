#!/bin/bash
awk -f 01a2m_sjCollapseSamples.awk *SJ.out.tab | sort -k1,1V -k2,2n -k3,3n > 01a2o_SJ.all
awk '$7>=10' 01a2o_SJ.all > 01a2o_SJ.all.gte10

