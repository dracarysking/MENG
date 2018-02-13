
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
The wrapper script is fully annotated and very flexible, so you can just use part of the wrapper script to finish part of the job.

The output of the script contain 3 files: `*.freq` file, `*.loc` file, and `*.qc` file:
- `*.freq`：peaks distribution across the transcript bins, which can be used to generate peak frequency plot;
- `*.loc`: peaks distribution summary, which can be used to generate pie chart;
- `*.qc`: enrichment efficiency quality control, which can be used to generate fingerprint plot.

Enrichment efficiency quality control for MeRIP-Seq is a very important issue but less well studied. We usually ask "Did my MeRIP-Seq work?", or "How can I distinguish between IP and Input samples?". We cannot fully rely on the "GGACU" motif in the peaks, which is only suitable for m6A-Seq, and strongly affected by the chosen "background" sequences. What we need is a simple and robust tool to assess the enrichment efficiency for MeRIP-Seq.

I borrowed the idea for ChIP-Seq quality control from [Diaz et al.](https://github.com/songlab/chance/wiki/CHANCE-Manual#checking-the-strength-of-enrichment-in-the-ip) and [Fidel et al.](https://deeptools.readthedocs.io/en/latest/content/tools/plotFingerprint.html). For ChIP-Seq, an ideal input sample should have a uniform reads distribution across the genome, while an ideal IP sample should have few bins with relatively large numbers of reads. However, MeRIP-Seq is quite different as there is another variable which can strongly affect the reads distribution across the transcriptome: gene expression. So a simple idea is to normalize the gene expression effect using an input sample, such as IP1-Input1, IP2-Input2, Input2-Input1. Then we can assess the enrichment efficiency easily.

Here is an example of m6A-Seq fingerprint plot. You can download the raw data from [GSE46705](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE46705), or just get the processed data from [my google drive](https://drive.google.com/drive/folders/1CxDysblxT3GojH7RTn3naY7gxYqo5gKA?usp=sharing). Just use your favorate plotting tool on `*.qc` files. I used `ggplot2` to generate this:

![fingerprint](https://github.com/dracarysking/MENG/blob/master/PNG_QC.png)

## Contact
Please contact me if you have any questions, problems, or suggestions.
