***---------------------------------------------------------------
*** CHARTER SCHOOL MIXED LINEAR REGRESSION DO-FILE
***
*** Author: Jaren Haber, PhD Candidate
*** URL: https://github.com/URAP-charter/sorting-schools-2019
*** Institution: University of California, Berkeley
*** Project: Charter school identities
*** Date created: February, 2019
***
*** Description: Uses mixed-effects linear regression to estimate the effects of school and community
*** class & race on ed. ideology (part 1), and of ed. ideology and academic proficiency on 
*** student composition in terms of poverty (part 2) and students of color (part 3).
***---------------------------------------------------------------

/* NOTES ON COMMANDS:
To estimate a model in one or more imputations individually: 
`mi xeq 1 2 3: command` or `mi xeq 1 / 3: command`
To estimate a model using ALL imputations (time-consuming):
`mi est, dots post: command` 
Commands for showing reg output: 
estat ic, fitstat, ereturn list (used below) */


* INITIALIZE:

* Packages for saving reg output to doc:
ssc install outreg2, replace
ssc install asdoc, replace

* Specify current directory:
cd "/hdir/0/jhaber/Projects/charter_data/sorting-schools-2019/"

* Import imputed data (100 imputations with MI):
use "data/charter_schools_data_100_imputations.dta", clear
mi update


log using "logs/results_1_ibl_mi100_linear_101019.smcl", replace
** -----------------------------------------------------
** MIXED-EFFECTS LINEAR MODELS PT 1: RACE & POVERTY -> IBL
** -----------------------------------------------------

* Sequence of models:
* 0. controls only
* 1. school poverty
* 2. school race
* 3. school district poverty
* 4. school district race


* 0. controls only
mi xeq 1 / 5: mixed inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
est store ibl0
ereturn list
est save "model_estimates/1a_ibl_controls_mi100_linear.ster", replace
outreg2 using "tables/1a_ibl_controls_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
addnote("", "Sources: American Community Survey 2012-16 (U.S. Census Bureau 2018), Common Core of Data 2015-16 (NCES 2018), and the author's data collection.") ///
title("TABLE 2", "Mixed Effects Models: Effects of Poverty & Race on IBL Emphasis") ///
ctitle("M0: Controls only")

* 1. school poverty
mi xeq 1 / 5: mixed inquiry_full_log povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiry_full_log povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
est store ibl1
ereturn list
est save "model_estimates/1b_ibl_povsch_mi100_linear.ster", replace
outreg2 using "tables/1b_ibl_povsch_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M1: School poverty")

* 2. school race
mi xeq 1 / 5: mixed inquiry_full_log pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiry_full_log pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
est store ibl2
ereturn list
est save "model_estimates/1c_ibl_pocsch_mi100_linear.ster", replace
outreg2 using "tables/1c_ibl_pocsch_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M2: School race")

* 3. school district poverty
mi xeq 1 / 5: mixed inquiry_full_log povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiry_full_log povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
est store ibl3
ereturn list
est save "model_estimates/1d_ibl_povsd_mi100_linear.ster", replace
outreg2 using "tables/1d_ibl_povsd_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M3: School district poverty")

* 4. school district race
mi xeq 1 / 5: mixed inquiry_full_log pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
mi est, dots post: mixed inquiry_full_log pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , 
est store ibl4
ereturn list
est save "model_estimates/1e_ibl_pocsd_mi100_linear.ster", replace
outreg2 using "tables/1e_ibl_pocsd_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M4: School district race")

log close
translate "logs/results_1_ibl_mi100_linear_101019.smcl" "logs/results_1_ibl_mi100_linear_101019.pdf"


log using "logs/results_2_schpov_mi100_linear_101019.smcl", replace
** -----------------------------------------------------
** MIXED-EFFECTS LINEAR MODELS PT 2: IBL, ACADEMICS -> POVERTY
** -----------------------------------------------------

* Sequence of models:
* 0. controls only
* 1. IBL
* 2. academic performance
* 3. fully specified

* 0. controls only
mi xeq 1 / 5: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , 
mi est, dots post: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , 
est store pov0
ereturn list
est save "model_estimates/2a_schpov_controls_mi100_linear.ster", replace
outreg2 using "tables/2a_schpov_controls_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
addnote("", "Sources: American Community Survey 2012-16 (U.S. Census Bureau 2018), Common Core of Data 2015-16 (NCES 2018), EdFacts Achievement Results for State Assessments (USDE 2018), and the author's data collection.") ///
title("TABLE 3", "Mixed Effects Models: Effects of IBL Emphasis and Academic Proficiency on Number of Poor Students") ///
ctitle("M0: Controls only")

* 1. IBL
mi xeq 1 / 5: mixed povertyschoolprop inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || geodistrict: , 
mi est, dots post: mixed povertyschoolprop inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || geodistrict: , 
est store pov1
ereturn list
est save "model_estimates/2b_schpov_ibl_mi100_linear.ster", replace
outreg2 using "tables/2b_schpov_ibl_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M1: IBL emphasis")

* 2. academic performance
mi xeq 1 / 5: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , 
mi est, dots post: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , 
est store pov2
ereturn list
est save "model_estimates/2c_schpov_acad_mi100_linear.ster", replace
outreg2 using "tables/2c_schpov_acad_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M2: Academic proficiency")

* 3. fully specified
mi xeq 1 / 5: mixed povertyschoolprop inquiry_full_log readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , 
mi est, dots post: mixed povertyschoolprop inquiry_full_log readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , 
est store pov3
ereturn list
est save "model_estimates/2d_schpov_full_mi100_linear.ster", replace
outreg2 using "tables/2d_schpov_full_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M3: Fully specified")

log close
translate "logs/results_2_schpov_mi100_linear_101019.smcl" "logs/results_2_schpov_mi100_linear_101019.pdf"


log using "logs/results_3_schpoc_mi100_linear_101019.smcl", replace
** -----------------------------------------------------
** MIXED-EFFECTS LINEAR MODELS PT 3: IBL, ACADEMICS -> RACE
** -----------------------------------------------------

* Sequence of models:
* 0. controls only
* 1. IBL
* 2. academic performance
* 3. fully specified

* 0. controls only
mi xeq 1 / 5: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , 
est store poc0
ereturn list
est save "model_estimates/3a_schpoc_controls_mi100_linear.ster", replace
outreg2 using "tables/3a_schpoc_controls_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
addnote("", "Sources: American Community Survey 2012-16 (U.S. Census Bureau 2018), Common Core of Data 2015-16 (NCES 2018), EdFacts Achievement Results for State Assessments (USDE 2018), and the author's data collection.") ///
title("TABLE 4", "Mixed Effects Models: Effects of IBL Emphasis and Academic Proficiency on Number of Students of Color") ///
ctitle("M0: Controls only")

* 1. IBL
mi xeq 1 / 5: mixed pocschoolprop inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop inquiry_full_log primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , 
est store poc1
ereturn list
est save "model_estimates/3b_schpoc_ibl_mi100_linear.ster", replace
outreg2 using "tables/3b_schpoc_ibl_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M1: IBL emphasis")

* 2. academic performance
mi xeq 1 / 5: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , 
est store poc2
ereturn list
est save "model_estimates/3c_schpoc_acad_mi100_linear.ster", replace
outreg2 using "tables/3c_schpoc_acad_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M2: Academic proficiency")

* 3. fully specified
mi xeq 1 / 5: mixed pocschoolprop inquiry_full_log readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , 
mi est, dots post: mixed pocschoolprop inquiry_full_log readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , 
est store poc3
ereturn list
est save "model_estimates/3d_schpoc_full_mi100_linear.ster", replace
outreg2 using "tables/3d_schpoc_full_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M3: Fully specified")

log close
translate "logs/results_3_schpoc_mi100_linear_101019.smcl" "logs/results_3_schpoc_mi100_linear_101019.pdf"
