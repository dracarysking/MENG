#!/usr/bin/awk -f
##***************************************************************
## Calculate item mean or weighted mean for a specific column.
##
## Usage: awk -f ColMean.awk TargetFile
##        awk -f ColMean.awk -v col=3 TargetFile
##        awk -f ColMean.awk -v col=3 w=2 TargetFile
##        awk -f ColMean.awk -v col=3 cat=1 TargetFile
##        awk -f ColMean.awk -v col=3 w=2 cat=1 TargetFile
##
## Parameters:
##        col      column to calculate mean (default: 1)
##        w        weighted column
##        cat      category column
##**************************************************************

BEGIN{
	FS=OFS="\t"
	if(!col)col=1
}

{
	if(!w){W=1}else{W=$w}
	if(!cat){Cat="ALL"}else{Cat=$cat}
	Sum[Cat]+=W*$col
	Num[Cat]+=W
}

END{
	print "Category","Sum","Mean"
	for(i in Sum) print i,Sum[i],Sum[i]/Num[i]
}
