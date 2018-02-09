#!/usr/bin/awk -f
##*******************************************************************************
## Generate 5UTR/CDS/3UTR bins (100 for each part) for mRNAs in refFlat format.
## 
## Note: 
##      0. filter header lines, ncRNAs and mRNAs without UTR annotation;
##	1. confirm the CDS start and end exon index; 
##	2. calculate 5UTR/CDS/3UTR length and bin size, filter short transcripts;
##	3. get each bin's coordinates.
## 
## Usage: awk -f mRNAbinBed.awk refFlat.txt >refFlat_mRNAbin.bed
##*******************************************************************************

BEGIN{
	FS=OFS="\t"
}

## remove header lines
$1~/^#/{next}

## discard ncRNAs
$2~/NR_/{next}

## keep only mRNAs with 5UTR and 3UTR annotations 
$5!=$7 && $6!=$8{ 
## remove the last comma in $10 and $11, then split them into array.  
	split(gensub(/,$/,"","g",$10),ExonStart,",")
	split(gensub(/,$/,"","g",$11),ExonEnd,",")

## 1st step
	for (i=1;i<=$9;i++){
		if(ExonStart[i]<=$7 && ExonEnd[i]>=$7){
			CDSstart=i
		}
		if(ExonStart[i]<=$8 && ExonEnd[i]>=$8){
			CDSend=i
		}
	}

## 2nd step
	Tlen=0		## Tlen reset to 0
	for(i=1;i<=$9;i++){
		Tlen=Tlen+ExonEnd[i]-ExonStart[i]
	}
	if ($4=="+"){
		UTR5len=$7-ExonStart[CDSstart]
		for(i=1;i<CDSstart;i++){
			UTR5len=UTR5len+ExonEnd[i]-ExonStart[i]
		}
		UTR3len=ExonEnd[CDSend]-$8
		for(i=$9;i>CDSend;i--){
			UTR3len=UTR3len+ExonEnd[i]-ExonStart[i]
		}
		CDSlen=Tlen-UTR5len-UTR3len
		if(UTR5len<100 || UTR3len<100 || CDSlen<100){
			next
		}
	}
	if ($4=="-"){
		UTR3len=$7-ExonStart[CDSstart]
		for(i=1;i<CDSstart;i++){
			UTR3len=UTR3len+ExonEnd[i]-ExonStart[i]
		}
		UTR5len=ExonEnd[CDSend]-$8
		for(i=$9;i>CDSend;i--){
			UTR5len=UTR5len+ExonEnd[i]-ExonStart[i]
		}
		CDSlen=Tlen-UTR5len-UTR3len
		if(UTR5len<100 || UTR3len<100 || CDSlen<100){
			next
		}
	}
	UTR5bin=int(UTR5len/100)
	UTR3bin=int(UTR3len/100)
	CDSbin=int(CDSlen/100)

### 3rd step
	if ($4=="+"){
		UTR5binStart=$5
		UTR5block=1
		for(i=1;i<=100;i++){
			if((UTR5binStart+UTR5bin)<ExonEnd[UTR5block]){
				print $3,UTR5binStart,UTR5binStart+UTR5bin,$2 ":UTR5_" i
				UTR5binStart+=UTR5bin
			}else if((UTR5binStart+UTR5bin)>=ExonEnd[UTR5block]){
				Junction=UTR5bin-(ExonEnd[UTR5block]-UTR5binStart)+ExonStart[UTR5block+1]
				print $3,UTR5binStart,Junction,$2 ":UTR5_" i
				UTR5binStart=Junction	
				UTR5block++
			}
		}
		UTR3binStart=$8
		UTR3block=CDSend
		for(i=1;i<=100;i++){
			if((UTR3binStart+UTR3bin)<=ExonEnd[UTR3block]){
				print $3,UTR3binStart,UTR3binStart+UTR3bin,$2 ":UTR3_" i
				UTR3binStart+=UTR3bin				
			}else if((UTR3binStart+UTR3bin)>ExonEnd[UTR3block]){
				Junction=UTR3bin-(ExonEnd[UTR3block]-UTR3binStart)+ExonStart[UTR3block+1]
				print $3,UTR3binStart,Junction,$2 ":UTR3_" i
				UTR3binStart=Junction
				UTR3block++
			}
		}
		CDSbinStart=$7
		CDSblock=CDSstart
		for(i=1;i<=100;i++){
			if((CDSbinStart+CDSbin)<ExonEnd[CDSblock]){
				print $3,CDSbinStart,CDSbinStart+CDSbin,$2 ":CDS_" i
				CDSbinStart+=CDSbin
			}else if((CDSbinStart+CDSbin)>=ExonEnd[CDSblock]){
				Junction=CDSbin-(ExonEnd[CDSblock]-CDSbinStart)+ExonStart[CDSblock+1]
				print $3,CDSbinStart,Junction,$2 ":CDS_" i
				CDSbinStart=Junction
				CDSblock++
			}
		}
	}	
	if ($4=="-"){
		UTR5binEnd=$6
		UTR5block=$9
		for(i=1;i<=100;i++){
			if((UTR5binEnd-UTR5bin)>ExonStart[UTR5block]){
				print $3,UTR5binEnd-UTR5bin,UTR5binEnd,$2 ":UTR5_" i
				UTR5binEnd-=UTR5bin
			}else if((UTR5binEnd-UTR5bin)<=ExonStart[UTR5block]){
				Junction=ExonEnd[UTR5block-1]-(UTR5bin-(UTR5binEnd-ExonStart[UTR5block]))
				print $3,Junction,UTR5binEnd,$2 ":UTR5_" i
				UTR5binEnd=Junction	
				UTR5block--
			}
		}
		UTR3binEnd=$7
		UTR3block=CDSstart
		for(i=1;i<=100;i++){
			if((UTR3binEnd-UTR3bin)>=ExonStart[UTR3block]){
				print $3,UTR3binEnd-UTR3bin,UTR3binEnd,$2 ":UTR3_" i
				UTR3binEnd-=UTR3bin				
			}else if((UTR3binEnd-UTR3bin)<ExonStart[UTR3block]){
				Junction=ExonEnd[UTR3block-1]-(UTR3bin-(UTR3binEnd-ExonStart[UTR3block]))
				print $3,Junction,UTR3binEnd,$2 ":UTR3_" i
				UTR3binEnd=Junction
				UTR3block--
			}
		}
		CDSbinEnd=$8
		CDSblock=CDSend
		for(i=1;i<=100;i++){
			if((CDSbinEnd-CDSbin)>ExonStart[CDSblock]){
				print $3,CDSbinEnd-CDSbin,CDSbinEnd,$2 ":CDS_" i
				CDSbinEnd-=CDSbin
			}else if((CDSbinEnd-CDSbin)<=ExonStart[CDSblock]){
				Junction=ExonEnd[CDSblock-1]-(CDSbin-(CDSbinEnd-ExonStart[CDSblock]))
				print $3,Junction,CDSbinEnd,$2 ":CDS_" i
				CDSbinEnd=Junction
				CDSblock--
			}
		}
	}	
}
