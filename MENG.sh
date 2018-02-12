#!/bin/bash
##*************************************************************************
## MENG: mRNA enrichment-based next generation sequencing analysis toolkit
##
## Note:
##      1. This wrapper script generates peak frequency summary, peak location 
##         summary and enrichment summary for each dataset;
##      2. Input files: refFlat.txt, peak.bed, IP.bam, Input.bam.
##
## Usage: bash MENG.sh -r refFlat.txt -p peak.bed -t IP.bam -c Input.bam
##*************************************************************************

function usage(){
	echo
	echo "    Usage: MENG.sh [-r refFlat.txt] [-p peak.bed] [-t IP.bam] [-c Input.bam]"
	echo 
	echo "           -r      refFlat file for annotation" 
	echo "           -p      peak file for enriched mRNA regions"
	echo "           -t      BAM file for treatment group"
	echo "           -c      BAM file for control group"
	echo
	exit 1
}

if [ -z $1 ];then
	usage
fi

while getopts r:p:t:c: option;do
	case $option in
		r) Ref=$OPTARG ;;
		p) Peak=$OPTARG ;;
		t) IP=$OPTARG ;;
		c) Input=$OPTARG ;;
		*) usage;;
	esac
done

## filter refFlat files with no more than 3 transcripts for each gene
ColCount.awk $Ref | awk '$1<=3' | cut -f2- >${Ref}.f

## generate mRNA bins
mRNAbinBed.awk ${Ref}.f >${Ref}.bed

## count overlaps between mRNA bins and mRNA peaks
bedtools intersect -a ${Ref}.bed -b $Peak -wa -c >${Peak}.bin

## peak frequency summary
cut -d: -f 2 ${Peak}.bin | ColMean.awk -v col=2 cat=1 | tail -n +2 | sort -k1,1V | ColPerc.awk -v col=2 cat=1 | awk '{print $2"\t"$1/100}' >${Peak}.freq

## peak location summary
sed 's/_/\t/' ${Peak}.freq | ColMean.awk -v cat=1 col=3 | cut -f1-2 >${Peak}.loc

## enrichment summary
bedtools intersect -a ${Ref}.bed -b $IP -wa -c >${IP}.bin
bedtools intersect -a ${Ref}.bed -b $Input -wa -c >${Input}.bin
paste ${IP}.bin ${Input}.bin | awk 'BEGIN{FS=OFS="\t"}{print $1,$2,$3,$4,$5-$10}' | sort -k5,5n | tail -n 100000 >${IP}.enr
ColStep.awk -v row=100000 col=5 ${IP}.enr >${IP}.step
TotalReads=`tail -n 1 ${IP}.step | cut -f 3`
tail -n +2 ${IP}.step | awk -v TR=$TotalReads '{print $1"\t"$3/TR}'>${IP}.${Input}.qc

## clean up
rm ${Ref}.f ${Ref}.bed ${Peak}.bin ${IP}.bin ${Input}.bin ${IP}.enr ${IP}.step
echo "--------------------------------------------------------"
echo "Analysis finished! Here are the result files:"
echo
echo "peak frequency summary              ${Peak}.freq"
echo "peak location summary               ${Peak}.loc"
echo "enrichment summary                  ${IP}.${Input}.qc"
echo "--------------------------------------------------------"
