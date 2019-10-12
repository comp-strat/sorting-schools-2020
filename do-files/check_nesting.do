***---------------------------------------------------------------
*** CHARTER SCHOOL FULLY NESTED MIXED LINEAR REGRESSION DO-FILE
***
*** Author: Jaren Haber, PhD Candidate
*** URL: https://github.com/URAP-charter/sorting-schools-2019
*** Institution: University of California, Berkeley
*** Project: Charter school identities
*** Date created: February, 2019
***
*** Description: Calculates extent of nesting of each DV in state, CMO, and school district via rho (intraclass correlation coefficient). 
*** Uses FULLY nested (random effects for each DV in each level) mixed-effects linear regression to estimate the effects of 
*** school and community class & race on ed. ideology, and effects of ideology and academics on race & class student composition.
***---------------------------------------------------------------

/* NOTES ON PARAMETERS:
More robust specification: intmethod(mvaghermite)
How to calculate rho by hand: e(sigma_u)^2/(e(sigma_u)^2+e(sigma_e)^2)
Useful stats to include in outreg2--but doesn't work with MI:
addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) */


* INITIALIZE:

* Package for computing intraclass correlation coefficient (rho):
ssc install xtmrho, replace

* Specify current directory:
cd "/hdir/0/jhaber/Projects/charter_data/sorting-schools-2019/"

* Import imputed data (100 imputations with MI):
use "data/charter_schools_data_100_imputations.dta", clear
mi update


log using "logs/nesting_mi_linear_101019.smcl", replace
** -----------------------------------------------------
** CHECK NESTING IN EACH MODEL
** -----------------------------------------------------

** NESTING IN MIXED-EFFECTS LINEAR MODELS PT 1: RACE & POVERTY -> IBL 

* Check nesting without crossed random effects (less accurate):
mi xeq 1 / 5: quietly mixed inquiry_full_log primary middle high age students urban pctpdfs || state: || cmoname: || geodistrict: , nolog cov(unstructured) ; estat ic ; estat icc

* Compare rho for full IBL dictionary (50 terms) from each of five imputations, using mixed linear models:
mi xeq 1 / 5: quietly xtmixed inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || state: || geodistrict: , nolog cov(unstructured) ; xtmrho
mi xeq 1 / 5: quietly xtmixed inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || _all:R.state || cmoname: || geodistrict: , nolog cov(unstructured) ; xtmrho
* Comparing different model parameters. These should all be the same (CMO x state with district nested therein):
mi xeq 1: quietly xtmixed inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , nolog cov(unstructured) ; xtmrho
mi xeq 1: quietly xtmixed inquiry_full_log povertyschoolprop primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , nolog cov(unstructured) ; xtmrho
mi xeq 1: quietly xtmixed inquiry_full_log pocschoolprop primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , nolog cov(unstructured) ; xtmrho
mi xeq 1: quietly xtmixed inquiry_full_log povertysd primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , nolog cov(unstructured) ; xtmrho
mi xeq 1: quietly xtmixed inquiry_full_log pocsd primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , nolog cov(unstructured) ; xtmrho

* Check against other measures of IBL

* Seed dictionary (5 terms)
mi xeq 1: quietly xtmixed inquiry_seed_log primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , nolog cov(unstructured) ; xtmrho
mi xeq 1: quietly xtmixed inquiry_seed_log primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || state: || geodistrict: , nolog cov(unstructured) ; xtmrho
mi xeq 1: quietly xtmixed inquiry_seed_log primary middle high lnage lnstudents urban pctpdfs || _all:R.state || cmoname: || geodistrict: , nolog cov(unstructured) ; xtmrho
* Narrow dictionary (20 terms)
mi xeq 1: quietly xtmixed inquiry_narrow_log primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , nolog cov(unstructured) ; xtmrho
mi xeq 1: quietly xtmixed inquiry_narrow_log primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || state: || geodistrict: , nolog cov(unstructured) ; xtmrho
mi xeq 1: quietly xtmixed inquiry_narrow_log primary middle high lnage lnstudents urban pctpdfs || _all:R.state || cmoname: || geodistrict: , nolog cov(unstructured) ; xtmrho
* Full dictionary without "hands-on" (49 terms)
mi xeq 1: quietly xtmixed inquiry_full_nohands_log primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , nolog cov(unstructured) ; xtmrho
mi xeq 1: quietly xtmixed inquiry_full_nohands_log primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || state: || geodistrict: , nolog cov(unstructured) ; xtmrho
mi xeq 1: quietly xtmixed inquiry_full_nohands_log primary middle high lnage lnstudents urban pctpdfs || _all:R.state || cmoname: || geodistrict: , nolog cov(unstructured) ; xtmrho


** NESTING IN MIXED-EFFECTS LINEAR MODELS PT 2: IBL, ACADEMICS -> POVERTY

* Check nesting without crossed random effects (less accurate):
mi xeq 1 / 5: quietly mixed povertyschoolprop primary middle high age students urban pctpdfs || state: || cmoname: || geodistrict: , nolog cov(unstructured) ; estat ic ; estat icc

mi xeq 1 / 5: quietly xtmixed povertyschoolprop primary middle high lnage lnstudents urban || _all:R.cmoname || _all:R.state || geodistrict: , nolog cov(unstructured) ; xtmrho
mi xeq 1: quietly xtmixed povertyschoolprop inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , nolog cov(unstructured) ; xtmrho
mi xeq 1: quietly xtmixed povertyschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || _all:R.cmoname || _all:R.state || geodistrict: , nolog cov(unstructured) ; xtmrho
mi xeq 1: quietly xtmixed povertyschoolprop inquiry_full_log readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || _all:R.cmoname || _all:R.state || geodistrict: , nolog cov(unstructured) ; xtmrho


** NESTING IN MIXED-EFFECTS LINEAR MODELS PT 3: IBL, ACADEMICS -> RACE

* Check nesting without crossed random effects (less accurate):
mi xeq 1 / 5: quietly mixed pocschoolcount primary middle high age students urban pctpdfs || state: || cmoname: || geodistrict: , nolog cov(unstructured) ; estat ic ; estat icc

mi xeq 1 / 5: quietly xtmixed pocschoolprop primary middle high lnage lnstudents urban || _all:R.cmoname || _all:R.state || geodistrict: , nolog cov(unstructured) ; xtmrho
mi xeq 1: quietly xtmixed pocschoolprop inquiry_full_log prop primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , nolog cov(unstructured) ; xtmrho
mi xeq 1: quietly xtmixed pocschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || _all:R.cmoname || _all:R.state || geodistrict: , nolog cov(unstructured) ; xtmrho
mi xeq 1: quietly xtmixed pocschoolprop inquiry_full_log readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , nolog cov(unstructured) ; xtmrho

log close
translate "logs/nesting_mi_linear_101019.smcl" "logs/nesting_mi_linear_101019.pdf"


log using "logs/results_quickpass_mi100_linear_clusts_101019.smcl", replace
** -----------------------------------------------------
** FULLY NESTED MODELS: QUICK PASS OF ONE IMPUTATION EACH
** -----------------------------------------------------

** FULLY NESTED MIXED-EFFECTS LINEAR MODELS PT 1: RACE & POVERTY -> IBL

* 0. controls only
mi xeq 1: mixed inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
* 1. school poverty
mi xeq 1: mixed inquiry_full_log povertyschool primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
* 2. school race
mi xeq 1: mixed inquiry_full_log pocschoolprop primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
* 3. school district poverty
mi xeq 1: mixed inquiry_full_log povertysd primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
* 4. school district race
mi xeq 1: mixed inquiry_full_log pocsd primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)


** FULLY NESTED MIXED-EFFECTS LINEAR MODELS PT 2: IBL, ACADEMICS -> POVERTY

* 0. controls only
mi xeq 1: mixed povertyschoolprop primary middle high lnage lnstudents urban || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
* 1. IBL
mi xeq 1: mixed povertyschoolprop inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
* 2. academic performance
mi xeq 1 : mixed povertyschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
* 3. fully specified
mi xeq 1 : mixed povertyschoolprop inquiry_full_log readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)


** FULLY NESTED MIXED-EFFECTS LINEAR MODELS PT 3: IBL, ACADEMICS -> RACE

* 0. controls only
mi xeq 1: mixed pocschoolprop primary middle high lnage lnstudents urban || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
* 1. IBL
mi xeq 1: mixed pocschoolprop inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
* 2. academic performance
mi xeq 1: mixed pocschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
* 3. fully specified
mi xeq 1: mixed pocschoolprop inquiry_full_log readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)

log close
translate "logs/results_quickpass_mi100_linear_clusts_101019.smcl" "logs/results_quickpass_mi100_linear_clusts_101019.pdf"


log using "logs/results_1_ibl_mi100_linear_clusts_101019.smcl", replace

** -----------------------------------------------------
** FULLY NESTED MIXED-EFFECTS LINEAR MODELS (100 IMPUTATIONS) PT 1: RACE & POVERTY -> IBL
** -----------------------------------------------------

* 0. controls only
*mi xeq 1 / 5: mixed inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store ibl0
est save "models/1a_ibl_controls_mi100_linear_clusts.ster", replace
outreg2 using "tables/1a_ibl_controls_mi100_linear_clusts.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
addnote("", "Sources: American Community Survey 2012-16 (U.S. Census Bureau 2018), Common Core of Data 2015-16 (NCES 2018), and the author's data collection.") ///
title("TABLE 2", "Mixed Effects Models: Effects of Poverty & Race on IBL Emphasis") ///
ctitle("M0: Controls only")

* 1. school poverty
*mi xeq 1 / 5: mixed inquiry_full_log povertyschool primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed inquiry_full_log povertyschool primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store ibl1
est save "models/1b_ibl_povsch_mi100_linear_clusts.ster", replace
outreg2 using "tables/1b_ibl_povsch_mi100_linear_clusts.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M1: School poverty")

* 2. school race
*mi xeq 1 / 5: mixed inquiry_full_log pocschoolprop primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed inquiry_full_log pocschoolprop primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store ibl2
est save "models/1c_ibl_pocsch_mi100_linear_clusts.ster", replace
outreg2 using "tables/1c_ibl_pocsch_mi100_linear_clusts.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M2: School race")

* 3. school district poverty
*mi xeq 1 / 5: mixed inquiry_full_log povertysd primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed inquiry_full_log povertysd primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store ibl3
est save "models/1d_ibl_povsd_mi100_linear_clusts.ster", replace
outreg2 using "tables/1d_ibl_povsd_mi100_linear_clusts.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M3: School district poverty")

* 4. school district race
*mi xeq 1 / 5: mixed inquiry_full_log pocsd primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed inquiry_full_log pocsd primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store ibl4
est save "models/1e_ibl_pocsd_mi100_linear_clusts.ster", replace
outreg2 using "tables/1e_ibl_pocsd_mi100_linear_clusts.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M4: School district race")

log close
translate "logs/results_1_ibl_mi100_linear_clusts_101019.smcl" "logs/results_1_ibl_mi100_linear_clusts_101019.pdf"


log using "logs/results_2_schpov_mi100_linear_clusts_101019.smcl", replace
** -----------------------------------------------------
** FULLY NESTED MIXED-EFFECTS LINEAR MODELS (100 IMPUTATIONS) PT 2: IBL, ACADEMICS -> POVERTY
** -----------------------------------------------------

* 0. controls only
*mi xeq 1 / 5: mixed povertyschoolprop primary middle high lnage lnstudents urban || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop primary middle high lnage lnstudents urban || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store pov0
est save "models/2a_schpov_controls_mi100_linear_clusts.ster", replace
outreg2 using "tables/2a_schpov_controls_mi100_linear_clusts.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
addnote("", "Sources: American Community Survey 2012-16 (U.S. Census Bureau 2018), Common Core of Data 2015-16 (NCES 2018), EdFacts Achievement Results for State Assessments (USDE 2018), and the author's data collection.") ///
title("TABLE 3", "Mixed Effects Models: Effects of IBL Emphasis and Academic Proficiency on Number of Poor Students") ///
ctitle("M0: Controls only")

* 1. IBL
*mi xeq 1 / 5: mixed povertyschoolprop inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store pov1
est save "models/2b_schpov_ibl_mi100_linear_clusts.ster", replace
outreg2 using "tables/2b_schpov_ibl_mi100_linear_clusts.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M1: IBL emphasis")

* 2. academic performance
*mi xeq 1 / 5: mixed povertyschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store pov2
est save "models/2c_schpov_acad_mi100_linear_clusts.ster", replace
outreg2 using "tables/2c_schpov_acad_mi100_linear_clusts.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M2: Academic proficiency")

* 3. fully specified
*mi xeq 1 / 5: mixed povertyschoolprop inquiry_full_log readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop inquiry_full_log readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store pov3
est save "models/2d_schpov_full_mi100_linear_clusts.ster", replace
outreg2 using "tables/2d_schpov_full_mi100_linear_clusts.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M3: Fully specified")

log close
translate "logs/results_2_schpov_mi100_linear_clusts_101019.smcl" "logs/results_2_schpov_mi100_linear_clusts_101019.pdf"


log using "logs/results_3_schpoc_mi100_linear_clusts_101019.smcl", replace
** -----------------------------------------------------
** FULLY NESTED MIXED-EFFECTS LINEAR MODELS (100 IMPUTATIONS) PT 3: IBL, ACADEMICS -> RACE
** -----------------------------------------------------

* 0. controls only
*mi xeq 1 / 5: mixed pocschoolprop primary middle high lnage lnstudents urban || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop primary middle high lnage lnstudents urban || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store poc0
est save "models/3a_schpoc_controls_mi100_linear_clusts.ster", replace
outreg2 using "tables/3a_schpoc_controls_mi100_linear_clusts.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
addnote("", "Sources: American Community Survey 2012-16 (U.S. Census Bureau 2018), Common Core of Data 2015-16 (NCES 2018), EdFacts Achievement Results for State Assessments (USDE 2018), and the author's data collection.") ///
title("TABLE 4", "Mixed Effects Models: Effects of IBL Emphasis and Academic Proficiency on Number of Students of Color") ///
ctitle("M0: Controls only")

* 1. IBL
*mi xeq 1 / 5: mixed pocschoolprop inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store poc1
est save "models/3b_schpoc_ibl_mi100_linear_clusts.ster", replace
outreg2 using "tables/3b_schpoc_ibl_mi100_linear_clusts.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M1: IBL emphasis")

* 2. academic performance
*mi xeq 1: mixed pocschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store poc2
est save "models/3c_schpoc_acad_mi100_linear_clusts.ster", replace

* 3. fully specified
*mi xeq 1: mixed pocschoolprop inquiry_full_log readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop inquiry_full_log readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store poc3
est save "models/3d_schpoc_full_mi100_linear_clusts.ster", replace
outreg2 using "tables/3d_schpoc_full_mi100_linear_clusts.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M3: Fully specified")

log close
translate "logs/results_3_schpoc_mi100_linear_clusts_101019.smcl" "logs/results_3_schpoc_mi100_linear_clusts_101019.pdf"
