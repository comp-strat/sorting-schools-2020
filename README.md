# sorting-schools-2019
Replication code for "Sorting Schools: A Computational Analysis of Charter School Identities and Stratification" research article by Jaren Haber, UC Berkeley.  Paper investigates the relationships between charter school and school district poverty &amp; race, on one hand, and school ideology and academic performance, on the other.

## Public Data Sources
- School directory and demographics: [Common Core of Data, Public School Universe Survey (CCD PSUS), 2015-16](https://nces.ed.gov/ccd/pubschuniv.asp)
- School district demographics: [American Community Survey (ACS), 2012-16](https://www.census.gov/programs-surveys/acs/data/summary-file.html)
- School academic performance: [EdFacts Assessment Proficiency, 2015-16](https://www2.ed.gov/about/inits/ed/edfacts/data-files/index.html) 
- Additional school information (not used in analysis): [Civil Rights Data Collection (CRDC), 2015-16](https://www2.ed.gov/about/offices/list/ocr/docs/crdc-2015-16.html)
- School district child poverty information (not used in analysis):[Small Area Income and Poverty Estimates (SAIPE) Program](https://www.census.gov/programs-surveys/saipe.html)

See `codebook.csv` for detailed information on all variables in data files. For comprehensiveness, variables not used in final analysis (see `mixed_models.do`) are retained.

Data files (.dta and .csv files) are post-processing (see `data_preparation.do`).
