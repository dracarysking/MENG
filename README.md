
MENG (**m**RNA **e**nrichment-based **n**ext **g**eneration sequencing analysis toolkit) collects useful scripts for daily calculation on epitranscriptomes, such as m6A-Seq. The scripts are mainly written in `awk`, fast, and easy to be joined together using pipe. In addition, wrapper scripts are also provided, which can be simply used to calculate peak distributions across different mRNA parts, and assess the mRNA enrichment efficiency. 

## Installation
```bash
git clone https://github.com/dracarysking/MENG.git
cd MENG
chmod a+x *.awk *.sh
export PATH=/path/to/MENG:$PATH
```
## Wrapper scripts
All wrapper scripts need `bedtools` installed before use. 

### MENG_peak.sh


### MENG_quality.sh
