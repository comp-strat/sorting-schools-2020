# Sorting Schools:
## A Computational Analysis of Charter School Identities and Stratification
- Author: Jaren Haber, PhD
- Article forthcoming in [_Sociology of Education_](https://journals.sagepub.com/home/soe)
- [Post-print through Open Science Foundation](http://bit.ly/OSF-postprint-SocEd)

## Paper Abstract
Research shows that charter schools are more segregated by race and class than traditional public schools. I investigate an under-examined mechanism for this segregation: Charter schools project identities corresponding to parents’ race- and class-specific parenting styles and educational values. I use computational text analysis to detect the emphasis on inquiry-based learning in the websites of all charter schools operating in the 2015-16 school year. I then estimate mixed linear regression models to test the relationships between ideological emphasis and school- and district-level poverty and ethnicity. I thereby transcend methodological problems in scholarship on charter school identities by collecting contemporary, valid, population-wide data, as well as by blending text analysis with hypothesis testing. Findings suggest that charter school identities are both race- and class-specific, lending weight to arguments for further regulating charter school enrollments. This project contributes to literatures on school choice, educational stratification, and organizational identity.

## Public Data Sources
- School directory and demographics: [Common Core of Data, Public School Universe Survey (CCD PSUS), 2015-16](https://nces.ed.gov/ccd/pubschuniv.asp)
- School district demographics: [American Community Survey (ACS), 2012-16](https://www.census.gov/programs-surveys/acs/data/summary-file.html)
- School academic performance: [EdFacts Assessment Proficiency, 2015-16](https://www2.ed.gov/about/inits/ed/edfacts/data-files/index.html) 
- Additional school information (not used in analysis): [Civil Rights Data Collection (CRDC), 2015-16](https://www2.ed.gov/about/offices/list/ocr/docs/crdc-2015-16.html)
- Charter Management Organization (CMO) directory (supplemented by author): Stanford [Center for Research on Education Outcomes](https://credo.stanford.edu/pdfs/CMO%20FINAL.pdf)
- School district child poverty information (not used in analysis):[Small Area Income and Poverty Estimates (SAIPE) Program](https://www.census.gov/programs-surveys/saipe.html)

## Notes
See `codebook.csv` for detailed information on all variables in data files. For comprehensiveness, variables not used in final analysis (see `mixed_models.do`) are retained.

Data files (.dta and .csv)--other than CMO and URL lists--are post-processing (see `data_preparation.do`).

Web-crawling speeds were throttled to prevent server overload, and web-crawled site data is kept private pursuant to school website copyrights. 

## Guide to inspecting robustness checks via log files

1. Alternative Measures I: Lagged academic proficiency rates (2013-14 and 2015-16 instead of 2014-15):
</br> `logs/robust_laggedscores_mi5_linear_101019.smcl`

2. Alternative Measures II: Narrow dictionaries of IBL rather than 50-term full dictionary: seed (5 terms), narrow (20 terms), and full w/o “hands-on” term (49 terms)
</br> `logs/robustness_check_dictionary_size.pdf`

3. Alternative Measures III: Race/class differentials between district and school
</br> `logs/robustness_check_district_differentials.pdf`

4. Fully nested mixed-effects linear models (100 imputations) 
-	pt. 1: Race & poverty -> IBL
</br> `logs/robustness_check_fully_nested_models_1.pdf`
- pt. 2: IBL, academic proficiency -> Poverty
</br> `logs/robustness_check_fully_nested_models_2.pdf`
- pt. 3: IBL, academic proficiency -> Race
</br> `logs/robustness_check_fully_nested_models_3.pdf`

5. Filter Dataset: Restrict sample to only those schools with:
- precise academic data: readlevel14 & mathlevel14 == 1
</br> `logs/robustness_check_precise_scores.pdf`
- above-average district poverty
 </br> `logs/robustness_check_high_poverty_districts.pdf`
- above-average district POC
 </br> `logs/robustness_check_high_POC_districts.pdf`
- above-average district population density
</br> `logs/robustness_check_high_density_districts.pdf`
- inquiry_full_count < 10000
</br> `logs/robustness_check_ibl_outliers.pdf`
- numpages < 100
</br> `logs/robustness_check_large_websites.pdf`
- students > 10
</br> `logs/robustness_check_small_schools.pdf`
    
## Acknowledgments
I give special thanks to Heather Haveman for her encouragement and constructive criticism, which after many drafts have greatly improved this paper; and to the UC Berkeley Data-Intensive Social Science Lab (D-Lab) community for teaching me to code and to embrace not knowing. I also thank Sam Lucas, Calvin Morrill, Bruce Fuller, David Bamman, Ben Gebre-Medhin, and Caroline Le Pennec-Caldichoury for their feedback and insightful comments; Aaron Culich, Carl Mason, and the Cloud Working Group for help with web data collection and computing infrastructure; and my family and partner for their generosity and tolerance. This complex project wouldn’t have been possible without the contributions of 30 research assistants from the Undergraduate Research Apprentice Program and Data Science Discovery Program, especially Brad Afzali, Kanika Ahluwalia, Kaan Dogusoy, Yoon Sung Hong, Elaine Huynh, Harshayu Girase, Krutika Ingale, Akshat Gokhale, Brian Yimin Lei, Ji Shi, Sarah Solieman, Arjun Srinivasan, and Jiahua Zou. Previous versions of this paper and its methods were presented at the Berkeley Institute for Data Science’s 2018 Text Across Domains (TextXD) symposium; the D-Lab’s Computational Text Analysis Working Group in 2017-18; the 2018 Making Text Research-Ready symposium; the 2018 Graduate School of Education Research Day; and the American Sociology Association’s Sociology of Education Section in 2017 and 2018. This work used the Extreme Science and Engineering Discovery Environment (XSEDE), which is supported by National Science Foundation grant number ACI-1548562, as well as the Berkeley Demography Lab cloud computing facility. Financial support was provided by the UC Berkeley Dissertation Completion Fellowship and the Bridge Lowenthal Fellowship. I declare no conflict of interest in doing this research.

## Contact 
jhaber@berkeley.edu
