
MENG (**m**RNA **e**nrichment-based **n**ext **g**eneration sequencing analysis toolkit) collects useful scripts for daily calculation on epitranscriptomes, such as m6A-Seq. The scripts are mainly written in `awk`, fast, and easy to be joined together using pipe. In addition, several wrapper scripts are also provided, which can be simply used to calculate peak distributions across different mRNA parts, assess the mRNA enrichment efficiency, ... 

## Installation
```bash
git clone https://github.com/dracarysking/MENG.git
cd MENG
chmod a+x *.awk *.sh
export PATH=/path/to/MENG:$PATH
```
## Wrapper scripts

### MENG.sh
`MENG.sh` is the main wrapper script of this package for peak distribution calculation and mRNA enrichment efficiency assessment. Please install `bedtools` before using this script.

```
    Usage: MENG.sh [-r refFlat.txt] [-p peak.bed] [-t IP.bam] [-c Input.bam]

           -r      refFlat file for annotation
           -p      peak file for enriched mRNA regions
           -t      BAM file for treatment group
           -c      BAM file for control group
```

`*.freq` files can be used to generate peak frequency plot. 

![peak_frequency_plot](https://github.com/dracarysking/MENG/blob/master/PNG_Peak.png)

`*.qc` files can be used to generate footprint plot for different datasets quality control.

![footprint](https://github.com/dracarysking/MENG/blob/master/PNG_QC.png)
