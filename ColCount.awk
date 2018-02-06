#!/usr/bin/awk -f
##*****************************************************************************
## Calculate item counts for a category column and put them as the first column.
##
## Usage: awk -f ColCount.awk TargetFile
##        awk -f ColCount.awk -v cat=1 TargetFile
##
## Parameters:
##        cat      category column (default: 1)
##*****************************************************************************

BEGIN{
	FS=OFS="\t"
	if(!cat)cat=1
}

{
	Count[$cat]+=1
	RowArray[NR]=$0
}

END{
	for(i=1;i<=NR;i++){
		split(RowArray[i],EachRow,"\t")
		print Count[EachRow[cat]],RowArray[i]
	}
}
