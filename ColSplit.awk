#!/usr/bin/awk -f
##********************************************************************
## Split one file into separated files based on items in certain column.
##
## Usage: awk -f ColSplit.awk TargetFile
##        awk -f ColSplit.awk -v col=3 TargetFile
##
## Parameters:
##        col      column used to separate file (default: 1)
##********************************************************************


BEGIN{
	FS=OFS="\t"
	if(!col)col=1
}

{
	print >$col ".txt"
}
