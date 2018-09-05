#!/usr/bin/awk -f
##**********************************************************************
## Convert genomic coordinates to transcriptomic coordinates.
##   							-- by xiaolong125
## Note:
##		1. refFlat.txt is required (download from UCSC genome browser)
##		2. Input file format (bed): genome_chr genome_start genome_end
##		3. Output file format: genome_chr genome_start genome_end \
##                             transcript_name transcript_start transcript_end \
##                             strand	gene_name
##		
## Usage:
##	awk -f Genomic2Transcriptomic.awk input.bed refFlat.txt >output.txt
##**********************************************************************


BEGIN{
	FS=OFS="\t"
}

## store intervals into hashes
NR==FNR{
	Chrom[NR]=$1
	GStart[NR]=$2
	GEnd[NR]=$3
	IntervalNum++
}

## coordinates conversion
NR>FNR{
	for(i=1;i<=IntervalNum;i++){
		## check position
		if(Chrom[i]==$3 && GStart[i]>=$5 && GEnd[i]<=$6){
			## initiate variables
			IntervalStart=0
			IntervalEnd=0
			gsub(/,$/,"",$10)
			gsub(/,$/,"",$11)
			split($10,ExonStart,",")
			split($11,ExonEnd,",")
			## exon index for bed
			for(j=1;j<=$9;j++){
				if(ExonStart[j]<=GStart[i] && ExonEnd[j]>=GStart[i]){
					IntervalStart=j
				}
			}
			for(l=1;l<=$9;l++){
				if(ExonStart[l]<=GEnd[i] && ExonEnd[l]>=GEnd[i]){
					IntervalEnd=l
				}
			}
			## generate transcript coordinates
			if(IntervalStart!=0 && IntervalEnd!=0){
				if($4=="+"){
					TStart=GStart[i]-ExonStart[IntervalStart]
					TEnd=GEnd[i]-ExonStart[IntervalEnd]
					for(k=1;k<IntervalStart;k++){
						TStart+=(ExonEnd[k]-ExonStart[k])
					}	
					for(m=1;m<IntervalEnd;m++){
						TEnd+=(ExonEnd[m]-ExonStart[m])
					}	
				}
				if($4=="-"){
					TStart=ExonEnd[IntervalEnd]-GEnd[i]
					TEnd=ExonEnd[IntervalStart]-GStart[i]
					for(k=1;k<($9-IntervalEnd+1);k++){
						TStart+=(ExonEnd[$9-k+1]-ExonStart[$9-k+1])
					}	
					for(m=1;m<($9-IntervalStart+1);m++){
						TEnd+=(ExonEnd[$9-m+1]-ExonStart[$9-m+1])
					}	
				}
			## output transcript coordinates
				print Chrom[i],GStart[i],GEnd[i],$2,TStart,TEnd,$4,$1
			}
		}
	}
}
