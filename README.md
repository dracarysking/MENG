
MENG (**m**RNA **e**nrichment-based **n**ext **g**eneration sequencing analysis toolkit) collects useful scripts for daily calculation on epitranscriptomes, such as m6A-Seq. The scripts are mainly written in `awk`, fast, and easy to be joined together using pipe. In addition, wrapper scripts are also provided, which can be used simply to generate peak frequency on different mRNA parts, and assess the mRNA enrichment efficiency. 

## System requirements

`bedtools` is required for several wrapper scripts.

## Installation
```
git clone 
cd MENG
chmod a+x *.awk *.sh
export PATH=/path/to/MENG:$PATH
```
