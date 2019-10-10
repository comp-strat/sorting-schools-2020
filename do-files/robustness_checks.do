***---------------------------------------------------------------
*** CHARTER SCHOOL MIXED LINEAR REGRESSION: ROBUSTNESS CHECKS DO-FILE
***
*** Author: Jaren Haber, PhD Candidate
*** URL: https://github.com/jhaber-zz
*** Institution: University of California, Berkeley
*** Project: Charter school identities
***
*** Date created: February, 2019
*** Date modified: October 10, 2019
***
*** Description: Checks validity of mixed linear regression using various robustness checks,
*** some including filtered data sets (to deal with outliers) and some with alternative measures.
***---------------------------------------------------------------

* INITIALIZE:

* Specify current directory:
cd "/hdir/0/jhaber/Projects/charter_data/sorting-schools-2019/"

* Import and modify data:
use "data/charters_schools_data.dta", clear
mi update

* Double-check all continuous vars are scaled the same:
mi xeq 0 1: tabstat inquiryprop readall14 mathall14 pocschoolprop povertyschoolprop pocsd povertysd pctpdfs, stat(n mean median min max sd)

* Make sure original and imputed variables have same summary stats:
mi xeq 0 1: tabstat inquiry_seed_log inquiry_narrow_log inquiry_full_log inquiry_full_nohands_log readall15 mathall15 pocschoolprop povertyschoolprop pocsd povertysd pctpdfs, stat(n mean median min max sd)


/* ROBUSTNESS CHECKS TO IMPLEMENT: 

1. Use lagged academic quality scores (instead of 2015-16) :
    A. 2013-14 scores
    B. 2014-15 scores

2. Filtered data set, only for those schools with:
    A. precise academic data: readlevel14 & mathlevel14 == 1
    B. inquiry_full_count < 10000
    C. numwords > 10
    D. numpages < 100
    E. students > 10
    
*/


log using "logs/robust_laggedscores_mi5_linear_042919.smcl", replace
** -----------------------------------------------------
** 1. RUN WITH LAGGED ACADEMIC VARIABLES
** -----------------------------------------------------

*
* 1A. RE-RUN LINEAR MIXED MODELS USING LAGGED ACADEMIC SCORES: 2013-14
*

* PT 2: 
* 2. academic performance
*mi xeq 1/ 5: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , 
mi est, dots post: mixed povertyschoolprop readall13 mathall13 primary middle high lnage lnstudents urban readlevel13 mathlevel13 || geodistrict: , 
* 3. fully specified
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , 
mi est, dots post: mixed povertyschoolprop inquiryprop readall13 mathall13 primary middle high lnage lnstudents urban pctpdfs readlevel13 mathlevel13 || geodistrict: , 

* PT 3:
* 2. academic performance
*mi xeq 1/ 5: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop readall13 mathall13 primary middle high lnage lnstudents urban readlevel13 mathlevel13 || state: || geodistrict: , 
* 3. fully specified
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop inquiryprop readall13 mathall13 primary middle high lnage lnstudents urban pctpdfs readlevel13 mathlevel13 || state: || geodistrict: , 


*
* 1B. RE-RUN LINEAR MIXED MODELS USING LAGGED ACADEMIC SCORES: 2014-15
*

* PT 2: 
* 2. academic performance
*mi xeq 1/ 5: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , 
mi est, dots post: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , 
* 3. fully specified
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , 
mi est, dots post: mixed povertyschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , 

* PT 3:
* 2. academic performance
*mi xeq 1/ 5: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , 
* 3. fully specified
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , 

log close


log using "logs/robust_filtscores_mi5_linear_042919.smcl", replace
** -----------------------------------------------------
** 2. RUN WITH FILTERED DATA
** -----------------------------------------------------

*
* 2A. RE-RUN LINEAR MIXED MODELS USING FILTERED DATA: PRECISE ACADEMIC DATA ONLY
*

mi xeq: drop if readlevel15 != 1 | mathlevel15 != 1

* PT 1:
* 0. controls only
*mi xeq 1/ 5: mixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 1. school poverty
*mi xeq 1/ 5: mixed inquiryprop povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 2. school race
*mi xeq 1/ 5: mixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 3. school district poverty
*mi xeq 1/ 5: mixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 4. school district race
*mi xeq 1/ 5: mixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 

* PT 2: 
* 0. controls only
*mi xeq 1/ 5: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , 
mi est, dots post: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , 
* 1. IBL
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || geodistrict: , 
mi est, dots post: mixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || geodistrict: , 
* 2. academic performance
*mi xeq 1/ 5: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , 
mi est, dots post: mixed povertyschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || geodistrict: , 
* 3. fully specified
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , 
mi est, dots post: mixed povertyschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || geodistrict: , 

* PT 3:
* 0. controls only
*mi xeq 1/ 5: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , 
* 1. IBL
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , 
* 2. academic performance
*mi xeq 1/ 5: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || state: || geodistrict: , 
* 3. fully specified
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || state: || geodistrict: , 

log close


log using "logs/robust_filtibl_mi5_linear_042919.smcl", replace
*
* 2B. RE-RUN LINEAR MIXED MODELS USING FILTERED DATA: REMOVING HUGE WEBSITE OUTLIERS
*

mi xeq: drop if inquiry_full_count > 10000

* PT 1:
* 0. controls only
*mi xeq 1/ 5: mixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 1. school poverty
*mi xeq 1/ 5: mixed inquiryprop povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 2. school race
*mi xeq 1/ 5: mixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 3. school district poverty
*mi xeq 1/ 5: mixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 4. school district race
*mi xeq 1/ 5: mixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 

* PT 2: 
* 0. controls only
*mi xeq 1/ 5: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , 
mi est, dots post: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , 
* 1. IBL
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || geodistrict: , 
mi est, dots post: mixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || geodistrict: , 
* 2. academic performance
*mi xeq 1/ 5: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , 
mi est, dots post: mixed povertyschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || geodistrict: , 
* 3. fully specified
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , 
mi est, dots post: mixed povertyschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || geodistrict: , 

* PT 3:
* 0. controls only
*mi xeq 1/ 5: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , 
* 1. IBL
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , 
* 2. academic performance
*mi xeq 1/ 5: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || state: || geodistrict: , 
* 3. fully specified
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || state: || geodistrict: , 

log close



log using "logs/robust_filtnumwords_mi5_linear_042919.smcl", replace
*
* 2C. RE-RUN LINEAR MIXED MODELS USING FILTERED DATA: NUMBER WORDS
*

mi xeq: drop if numwords < 10

* PT 1:
* 0. controls only
*mi xeq 1/ 5: mixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 1. school poverty
*mi xeq 1/ 5: mixed inquiryprop povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 2. school race
*mi xeq 1/ 5: mixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 3. school district poverty
*mi xeq 1/ 5: mixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 4. school district race
*mi xeq 1/ 5: mixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 

* PT 2: 
* 0. controls only
*mi xeq 1/ 5: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , 
mi est, dots post: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , 
* 1. IBL
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || geodistrict: , 
mi est, dots post: mixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || geodistrict: , 
* 2. academic performance
*mi xeq 1/ 5: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , 
mi est, dots post: mixed povertyschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || geodistrict: , 
* 3. fully specified
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , 
mi est, dots post: mixed povertyschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || geodistrict: , 

* PT 3:
* 0. controls only
*mi xeq 1/ 5: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , 
* 1. IBL
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , 
* 2. academic performance
*mi xeq 1/ 5: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || state: || geodistrict: , 
* 3. fully specified
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || state: || geodistrict: , 

log close


log using "logs/robust_filtnumpages_mi5_linear_042919.smcl", replace
*
* 2D. RE-RUN LINEAR MIXED MODELS USING FILTERED DATA: NUMBER PAGES
*

mi xeq: drop if numpages > 100

* PT 1:
* 0. controls only
*mi xeq 1/ 5: mixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 1. school poverty
*mi xeq 1/ 5: mixed inquiryprop povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 2. school race
*mi xeq 1/ 5: mixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 3. school district poverty
*mi xeq 1/ 5: mixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 4. school district race
*mi xeq 1/ 5: mixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 

* PT 2: 
* 0. controls only
*mi xeq 1/ 5: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , 
mi est, dots post: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , 
* 1. IBL
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || geodistrict: , 
mi est, dots post: mixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || geodistrict: , 
* 2. academic performance
*mi xeq 1/ 5: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , 
mi est, dots post: mixed povertyschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || geodistrict: , 
* 3. fully specified
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , 
mi est, dots post: mixed povertyschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || geodistrict: , 

* PT 3:
* 0. controls only
*mi xeq 1/ 5: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , 
* 1. IBL
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , 
* 2. academic performance
*mi xeq 1/ 5: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || state: || geodistrict: , 
* 3. fully specified
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || state: || geodistrict: , 

log close


log using "logs/robust_filtstudents_mi5_linear_042919.smcl", replace
*
* 2E. RE-RUN LINEAR MIXED MODELS USING FILTERED DATA: SCHOOL SIZE (# STUDENTS)
*

mi xeq: drop if students < 10

* PT 1:
* 0. controls only
*mi xeq 1/ 5: mixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 1. school poverty
*mi xeq 1/ 5: mixed inquiryprop povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 2. school race
*mi xeq 1/ 5: mixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 3. school district poverty
*mi xeq 1/ 5: mixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
* 4. school district race
*mi xeq 1/ 5: mixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 

* PT 2: 
* 0. controls only
*mi xeq 1/ 5: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , 
mi est, dots post: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , 
* 1. IBL
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || geodistrict: , 
mi est, dots post: mixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || geodistrict: , 
* 2. academic performance
*mi xeq 1/ 5: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , 
mi est, dots post: mixed povertyschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || geodistrict: , 
* 3. fully specified
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , 
mi est, dots post: mixed povertyschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || geodistrict: , 

* PT 3:
* 0. controls only
*mi xeq 1/ 5: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , 
* 1. IBL
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , 
* 2. academic performance
*mi xeq 1/ 5: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || state: || geodistrict: , 
* 3. fully specified
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || state: || geodistrict: , 

log close
