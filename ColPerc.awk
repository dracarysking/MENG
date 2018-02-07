#!/usr/bin/awk -f
##********************************************************************************
## Calculate percentages for a specific column and put them as the first column.
##
## Usage: awk -f ColPerc.awk TargetFile
##        awk -f ColPerc.awk -v col=3 TargetFile
##
## Parameters:
##        col      column to calculate percentages (default: 1)
##********************************************************************************

BEGIN{
	FS=OFS="\t"
	if(!col)col=1
}

{
	SumCol+=$col
	ColArray[NR]=$col
	RowArray[NR]=$0
}

END{
	if(SumCol!=0){
		for(i=1;i<=NR;i++){
			print 100*ColArray[i]/SumCol,RowArray[i]
		}
	}else{
		print "Sum is zero!"
	}
}
