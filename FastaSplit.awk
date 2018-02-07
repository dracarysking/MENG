#!/usr/bin/awk -f
##******************************************************************
## Split a fasta file into small files.
##
## Usage: awk -f FastaSplit.awk TargetFile
##        awk -f FastaSplit.awk -v N=1000 TargetFile
##
## Parameters:
##        N      number of fasta sequences per file (default: 10000)
##******************************************************************

BEGIN{
	if(!N)N=10000
	count=0
}

## skip empty lines
/^$/{next}

## print sequence header
/^>/{
### point to the output file
	if(count % N ==0){
		if(output)close(output)
		output=sprintf("%07d.fa",count)
	}
	print >output
	count++
	next	
}

## write sequence body
{
	print >output
}
