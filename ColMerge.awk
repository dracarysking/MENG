#!/usr/bin/awk -f
##***********************************************************************
## Merge two files based on related columns with same items deduplicated.
## 
## Note:
##       1. Only the last item kept. 
##       2. If you want to keep the largest one, just sort before you merge.
##       3. Items only belonging to one file will have "NA" instead. 
##
## Usage: awk -f ColMerge.awk TargetFile1 TargetFile2
##        awk -f ColMerge.awk -v col1=1 col2=1 TargetFile1 TargetFile2
##
## Parameters:
##        col1      TargetFile1 related column (default: 1)
##        col2      TargetFile2 related column (default: 1)
##***********************************************************************

BEGIN{
	FS=OFS="\t"
	if(!col1)col1=1
	if(!col2)col2=1
}

FNR==NR{
	Array1[$col1]=$0
	NF1=NF
	AllName[$col1]=$col1
	next
}

{
	Array2[$col2]=$0
	NF2=NF
	AllName[$col2]=$col2
}

END{
	for(i=1;i<=NF1;i++) Sep1="NA\t"Sep1
	for(i=1;i<=NF2;i++) Sep2="NA\t"Sep2
	gsub("\t$","",Sep1)
	gsub("\t$","",Sep2)
	for(i in AllName){
		if(!Array1[i]) print AllName[i],Sep1,Array2[i]
		else if(!Array2[i]) print AllName[i],Array1[i],Sep2
		else print AllName[i],Array1[i],Array2[i]
	} 
}
