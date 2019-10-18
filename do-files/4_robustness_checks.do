***---------------------------------------------------------------
*** CHARTER SCHOOL MIXED LINEAR REGRESSION: ROBUSTNESS CHECKS DO-FILE
***
*** Author: Jaren Haber, PhD Candidate
*** URL: https://github.com/jhaber-zz
*** Institution: University of California, Berkeley
*** Project: Charter school identities
*** Date created: February, 2019
***
*** Description: Checks validity of mixed linear regression using various robustness checks,
*** some including filtered data sets (to deal with outliers) and some with alternative measures.
***---------------------------------------------------------------

* INITIALIZE:

* Specify current directory:
cd "/hdir/0/jhaber/Projects/charter_data/sorting-schools-2019/"

* Import and modify data:
use "data/charter_schools_data_5_imputations.dta", clear
mi update


/* ROBUSTNESS CHECKS TO IMPLEMENT: 

1. Alternative Measures I: Lagged academic proficiency rates (instead of 2014-15) :
    A. 2013-14 scores
    B. 2015-16 scores

2. Alternative Measures II: Narrow dictionaries of IBL (rather than 50-term inquiry_full_log):
    A. Seed dictionary = 5 terms (inquiry_seed_log)
    B. Narrow dictionary = 20 terms (inquiry_narrow_log)
    C. Full dictionary without "hands-on" term = 49 terms (inquiry_full_nohands_log)

3. Filter Dataset: Restrict sample to only those schools with:
    A. precise academic data: readlevel14 & mathlevel14 == 1
    B. inquiry_full_count < 10000
    C. numpages < 100
    D. students > 10
    
*/


log using "logs/robust_laggedscores_mi5_linear_101019.smcl", replace
** -----------------------------------------------------
** 1. ALTERNATIVE MEASURES I: LAGGED/NOT ACADEMIC PROFICIENCY RATES
** -----------------------------------------------------

*
* 1A. RE-RUN LINEAR MIXED MODELS USING LAGGED ACADEMIC SCORES: 2013-14
*

* PT 2: 
* 2. academic performance
*mi xeq 1/ 5: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , 
mi est, dots post: mixed povertyschoolprop readall13 mathall13 primary middle high lnage lnstudents urban readlevel13 mathlevel13 || geodistrict: , 
* 3. fully specified
mi est, dots post: mixed povertyschoolprop inquiry_full_log readall13 mathall13 primary middle high lnage lnstudents urban pctpdfs readlevel13 mathlevel13 || geodistrict: , 

* PT 3:
* 2. academic performance
mi est, dots post: mixed pocschoolprop readall13 mathall13 primary middle high lnage lnstudents urban readlevel13 mathlevel13 || state: || geodistrict: , 
* 3. fully specified
mi est, dots post: mixed pocschoolprop inquiry_full_log readall13 mathall13 primary middle high lnage lnstudents urban pctpdfs readlevel13 mathlevel13 || state: || geodistrict: , 


*
* 1B. RE-RUN LINEAR MIXED MODELS USING NOT-LAGGED ACADEMIC SCORES: 2015-16
*

* PT 2: 
* 2. academic performance
mi est, dots post: mixed povertyschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || geodistrict: , 
* 3. fully specified
mi est, dots post: mixed povertyschoolprop inquiry_full_log readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || geodistrict: , 

* PT 3:
* 2. academic performance
mi est, dots post: mixed pocschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || state: || geodistrict: , 
* 3. fully specified
mi est, dots post: mixed pocschoolprop inquiry_full_log readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || state: || geodistrict: , 

log close
translate "logs/robust_laggedscores_mi5_linear_101019.smcl" "logs/robustness_check_proficiency_year.pdf"


log using "logs/robust_narrowibl_mi5_linear_101019.smcl", replace
** -----------------------------------------------------
** 2. ALTERNATIVE MEASURES II: NARROW DICTIONARIES OF IBL
** -----------------------------------------------------

*
* 2A. RE-RUN LINEAR MIXED MODELS USING SEED IBL DICTIONARY (5 TERMS)
*

* PT 1:
* 0. controls only
mi est, dots: mixed inquiry_seed_log primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 1. school poverty
mi est, dots: mixed inquiry_seed_log povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 2. school race
mi est, dots: mixed inquiry_seed_log pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 3. school district poverty
mi est, dots: mixed inquiry_seed_log povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 4. school district race
mi est, dots: mixed inquiry_seed_log pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 

* PT 2: 
* 0. controls only
mi est, dots: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , 
* 1. IBL
mi est, dots: mixed povertyschoolprop inquiry_seed_log primary middle high lnage lnstudents urban pctpdfs || geodistrict: , 
* 2. academic performance
mi est, dots: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , 
* 3. fully specified
mi est, dots: mixed povertyschoolprop inquiry_seed_log readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , 

* PT 3:
* 0. controls only
mi est, dots: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , 
* 1. IBL
mi est, dots: mixed pocschoolprop inquiry_seed_log primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , 
* 2. academic performance
mi est, dots: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , 
* 3. fully specified
mi est, dots: mixed pocschoolprop inquiry_seed_log readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , 


*
* 2B. RE-RUN LINEAR MIXED MODELS USING NARROW IBL DICTIONARY (20 TERMS)
*

* PT 1:
* 0. controls only
mi est, dots: mixed inquiry_narrow_log primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 1. school poverty
mi est, dots: mixed inquiry_narrow_log povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 2. school race
mi est, dots: mixed inquiry_narrow_log pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 3. school district poverty
mi est, dots: mixed inquiry_narrow_log povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 4. school district race
mi est, dots: mixed inquiry_narrow_log pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 

* PT 2: 
* 0. controls only
mi est, dots: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , 
* 1. IBL
mi est, dots: mixed povertyschoolprop inquiry_narrow_log primary middle high lnage lnstudents urban pctpdfs || geodistrict: , 
* 2. academic performance
mi est, dots: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , 
* 3. fully specified
mi est, dots: mixed povertyschoolprop inquiry_narrow_log readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , 

* PT 3:
* 0. controls only
mi est, dots: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , 
* 1. IBL
mi est, dots: mixed pocschoolprop inquiry_narrow_log primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , 
* 2. academic performance
mi est, dots: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , 
* 3. fully specified
mi est, dots: mixed pocschoolprop inquiry_narrow_log readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , 


*
* 2C. RE-RUN LINEAR MIXED MODELS USING FULL IBL DICTIONARY WITHOUT "HANDS-ON" TERM (49 TERMS)
*

* PT 1:
* 0. controls only
mi est, dots: mixed inquiry_full_nohands_log primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 1. school poverty
mi est, dots: mixed inquiry_full_nohands_log povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 2. school race
mi est, dots: mixed inquiry_full_nohands_log pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 3. school district poverty
mi est, dots: mixed inquiry_full_nohands_log povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 4. school district race
mi est, dots: mixed inquiry_full_nohands_log pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 

* PT 2: 
* 0. controls only
mi est, dots: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , 
* 1. IBL
mi est, dots: mixed povertyschoolprop inquiry_full_nohands_log primary middle high lnage lnstudents urban pctpdfs || geodistrict: , 
* 2. academic performance
mi est, dots: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , 
* 3. fully specified
mi est, dots: mixed povertyschoolprop inquiry_full_nohands_log readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , 

* PT 3:
* 0. controls only
mi est, dots: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , 
* 1. IBL
mi est, dots: mixed pocschoolprop inquiry_full_nohands_log primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , 
* 2. academic performance
mi est, dots: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , 
* 3. fully specified
mi est, dots: mixed pocschoolprop inquiry_full_nohands_log readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , 

log close
translate "logs/robust_narrowibl_mi5_linear_101019.smcl" "logs/robustness_check_dictionary_size.pdf"


log using "logs/robust_filtscores_mi5_linear_101019.smcl", replace
** -----------------------------------------------------
** 3. RUN WITH FILTERED DATA
** -----------------------------------------------------

*
* 3A. RE-RUN LINEAR MIXED MODELS USING FILTERED DATA: PRECISE ACADEMIC DATA ONLY
*

mi xeq: drop if readlevel14 != 1 | mathlevel14 != 1

* PT 1:
* 0. controls only
mi est, dots: mixed inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 1. school poverty
mi est, dots: mixed inquiry_full_log povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 2. school race
mi est, dots: mixed inquiry_full_log pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 3. school district poverty
mi est, dots: mixed inquiry_full_log povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 4. school district race
mi est, dots: mixed inquiry_full_log pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 

* PT 2: 
* 0. controls only
mi est, dots: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , 
* 1. IBL
mi est, dots: mixed povertyschoolprop inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || geodistrict: , 
* 2. academic performance
mi est, dots: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , 
* 3. fully specified
mi est, dots: mixed povertyschoolprop inquiry_full_log readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , 

* PT 3:
* 0. controls only
mi est, dots: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , 
* 1. IBL
mi est, dots: mixed pocschoolprop inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , 
* 2. academic performance
mi est, dots: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , 
* 3. fully specified
mi est, dots: mixed pocschoolprop inquiry_full_log readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , 

log close
translate "logs/robust_filtscores_mi5_linear_101019.smcl" "logs/robustness_check_precise_scores.pdf"


* Load original data for filtering:
use "data/charter_schools_data_5_imputations.dta", clear
mi update

log using "logs/robust_filtibl_mi5_linear_101019.smcl", replace
*
* 3B. RE-RUN LINEAR MIXED MODELS USING FILTERED DATA: REMOVING HUGE WEBSITE OUTLIERS
*

mi xeq: drop if inquiry_full_count > 10000

* PT 1:
* 0. controls only
mi est, dots: mixed inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 1. school poverty
mi est, dots: mixed inquiry_full_log povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 2. school race
mi est, dots: mixed inquiry_full_log pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 3. school district poverty
mi est, dots: mixed inquiry_full_log povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 4. school district race
mi est, dots: mixed inquiry_full_log pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 

* PT 2: 
* 0. controls only
mi est, dots: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , 
* 1. IBL
mi est, dots: mixed povertyschoolprop inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || geodistrict: , 
* 2. academic performance
mi est, dots: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , 
* 3. fully specified
mi est, dots: mixed povertyschoolprop inquiry_full_log readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , 

* PT 3:
* 0. controls only
mi est, dots: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , 
* 1. IBL
mi est, dots: mixed pocschoolprop inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , 
* 2. academic performance
mi est, dots: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , 
* 3. fully specified
mi est, dots: mixed pocschoolprop inquiry_full_log readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , 

log close
translate "logs/robust_filtibl_mi5_linear_101019.smcl" "logs/robustness_check_ibl_outliers.pdf"


* Load original data for filtering:
use "data/charter_schools_data_5_imputations.dta", clear
mi update

log using "logs/robust_filtnumpages_mi5_linear_101019.smcl", replace
*
* 3C. RE-RUN LINEAR MIXED MODELS USING FILTERED DATA: NUMBER PAGES
*

mi xeq: drop if numpages > 100

* PT 1:
* 0. controls only
mi est, dots: mixed inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 1. school poverty
mi est, dots: mixed inquiry_full_log povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 2. school race
mi est, dots: mixed inquiry_full_log pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 3. school district poverty
mi est, dots: mixed inquiry_full_log povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 4. school district race
mi est, dots: mixed inquiry_full_log pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 

* PT 2: 
* 0. controls only
mi est, dots: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , 
* 1. IBL
mi est, dots: mixed povertyschoolprop inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || geodistrict: , 
* 2. academic performance
mi est, dots: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , 
* 3. fully specified
mi est, dots: mixed povertyschoolprop inquiry_full_log readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , 

* PT 3:
* 0. controls only
mi est, dots: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , 
* 1. IBL
mi est, dots: mixed pocschoolprop inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , 
* 2. academic performance
mi est, dots: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , 
* 3. fully specified
mi est, dots: mixed pocschoolprop inquiry_full_log readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , 

log close
translate "logs/robust_filtnumpages_mi5_linear_101019.smcl" "logs/robustness_check_large_websites.pdf"


* Load original data for filtering:
use "data/charter_schools_data_5_imputations.dta", clear
mi update

log using "logs/robust_filtstudents_mi5_linear_101019.smcl", replace
*
* 3D. RE-RUN LINEAR MIXED MODELS USING FILTERED DATA: SCHOOL SIZE (# STUDENTS)
*

mi xeq: drop if students < 10

* PT 1:
* 0. controls only
mi est, dots: mixed inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 1. school poverty
mi est, dots: mixed inquiry_full_log povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 2. school race
mi est, dots: mixed inquiry_full_log pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 3. school district poverty
mi est, dots: mixed inquiry_full_log povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 4. school district race
mi est, dots: mixed inquiry_full_log pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 

* PT 2: 
* 0. controls only
mi est, dots: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , 
* 1. IBL
mi est, dots: mixed povertyschoolprop inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || geodistrict: , 
* 2. academic performance
mi est, dots: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , 
* 3. fully specified
mi est, dots: mixed povertyschoolprop inquiry_full_log readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , 

* PT 3:
* 0. controls only
mi est, dots: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , 
* 1. IBL
mi est, dots: mixed pocschoolprop inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , 
* 2. academic performance
mi est, dots: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , 
* 3. fully specified
mi est, dots: mixed pocschoolprop inquiry_full_log readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , 

log close
translate "logs/robust_filtstudents_mi5_linear_101019.smcl" "logs/robustness_check_small_schools.pdf"
