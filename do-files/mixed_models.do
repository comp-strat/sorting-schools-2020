***---------------------------------------------------------------
*** CHARTER SCHOOL MIXED LINEAR REGRESSION DO-FILE
***
*** Author: Jaren Haber, PhD Candidate
*** URL: https://github.com/jhaber-zz
*** Institution: University of California, Berkeley
*** Project: Charter school identities
***
*** Date created: February, 2019
*** Date modified: April 17, 2019
***
*** Description: Prepares data for analysis by modifying variables,
*** then uses mixed-effects negative binomial regression to estimate
*** the effects of school and community class & race on ed. ideology.
***---------------------------------------------------------------

* INITIALIZE:

* Packages for intraclass correlation coefficient (rho), k-fold cross-validation, saving reg output to doc:
ssc install xtmrho, replace
ssc install crossfold.pkg, replace
ssc install outreg2, replace
ssc install asdoc, replace

* Specify current directory:
cd "/hdir/0/jhaber/Projects/charter_data/stats_team/"

* Import data:
use "data/stats_data_2015_mi100_keepschpov.dta", clear
mi update

/*
* Create new passive variables within MI (can use defaults because using mlong style):
drop povertyschoolcount
gen povertyschoolcount = round(povertyschool/100 * students)

* Drop if still missing key variables:
quietly mi xeq 1 / 100: drop if missing(students) | missing(lnstudents) | students==0 | lnstudents==.z
quietly mi xeq 1 / 100: drop if pocschoolcount==-12 | pocschoolcount==-54 | missing(povertyschoolcount)
quietly mi xeq: drop if missing(pocschool) | missing(pocschoolcount)

* Double check these lines if MI data recently modified:
* Rescale SD variables so commensurate with dichotomous variables:
replace pocsd = pocsd/100
replace povertysd = povertysd/100
replace readall15 = readall15/100
replace mathall15 = mathall15/100
gen povertyschoolprop = povertyschool/100
gen pocschoolprop = pocschoolcount/students

* Label variables:
labvars inquirycount "IBL emphasis (#)" inquiryprop "IBL emphasis (%)" disciplinecount "FD emphasis (#)" disciplineprop "FD emphasis (%)" ///
pocschool "% students of color (school)" pocschoolprop "% students of color (school)" pocschoolcount "# students of color" ///
povertyschool "% students in poverty (school)" povertyschoolprop "% students in poverty (school)" povertyschoolcount "# students in poverty" ///
pocsd "% people of color (school district)" povertysd "% people in poverty (school district)" ///
cmoname "CMO" state "State" geodistrict "School district" ///
readall15 "% proficiency in RLA" mathall15 "% proficiency in math" readlevel15 "RLA prof. precision" mathlevel15 "Math prof. precision" ///
primary "Primary school (binary)" middle "Middle school (binary)" high "High school (binary)" otherlevel "Other school level (binary)" ///
age "Years open" lnage "Years open (log)" students "# students" lnstudents "# students (log)" teachers "# teachers" lnteachers "# teachers (log)" ///
urban "Urban locale" pctpdfs "% PDF pages" numwords "# words", ///
alternate
*/

mi xeq 0 1: tabstat inquiryprop readall15 mathall15 pocschoolprop povertyschoolprop pocsd povertysd pctpdfs, stat(n mean median min max sd)

/*
log using "logs/nesting_mi_linear_043019.smcl", replace
** -----------------------------------------------------
** CHECK NESTING IN EACH MODEL
** -----------------------------------------------------

* Best way--Check against LINEAR without crossed random effects (doesn't work):
*mi est, dots post: mixed inquirycount primary middle high age students urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , nolog ; estat icc
*mi est, dots post: mixed povertyschoolprop primary middle high age students urban pctpdfs || cmoname: || _all:R.cmoname || _all:R.state || geodistrict: , nolog ; estat icc
*mi est, dots post: mixed pocschoolcount primary middle high age students urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , nolog ; estat icc

* Next best thing--Compare rho from each of five imputations, using mixed linear models:
mi xeq 1 / 5: quietly xtmixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || _all: R.cmoname || _all:R.cmoname || _all:R.state || geodistrict: , nolog ; xtmrho
mi xeq 1 / 5: quietly xtmixed inquiryprop povertyschoolprop primary middle high lnage lnstudents urban pctpdfs || _all: R.cmoname || _all:R.cmoname || _all:R.state || geodistrict: , nolog ; xtmrho
mi xeq 1 / 5: quietly xtmixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || _all: R.cmoname || _all:R.cmoname || _all:R.state || geodistrict: , nolog ; xtmrho
mi xeq 1 / 5: quietly xtmixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || _all: R.cmoname || _all:R.cmoname || _all:R.state || geodistrict: , nolog ; xtmrho
mi xeq 1 / 5: quietly xtmixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || _all: R.cmoname || _all:R.cmoname || _all:R.state || geodistrict: , nolog ; xtmrho

mi xeq 1 / 5: quietly xtmixed povertyschoolprop primary middle high lnage lnstudents urban || _all: R.cmoname || _all:R.cmoname || _all:R.state || geodistrict: , nolog ; xtmrho
mi xeq 1 / 5: quietly xtmixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || _all: R.cmoname || _all:R.cmoname || _all:R.state || geodistrict: , nolog ; xtmrho
mi xeq 1 / 5: quietly xtmixed povertyschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || _all: R.cmoname || _all:R.cmoname || _all:R.state || geodistrict: , nolog ; xtmrho
mi xeq 1 / 5: quietly xtmixed povertyschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || _all: R.cmoname || _all:R.cmoname || _all:R.state || geodistrict: , nolog ; xtmrho

mi xeq 1 / 5: quietly xtmixed pocschoolprop primary middle high lnage lnstudents urban || _all: R.cmoname || _all:R.cmoname || _all:R.state || geodistrict: , nolog ; xtmrho
mi xeq 1 / 5: quietly xtmixed pocschoolprop inquiry prop primary middle high lnage lnstudents urban pctpdfs || _all: R.cmoname || _all:R.cmoname || _all:R.state || geodistrict: , nolog ; xtmrho
mi xeq 1 / 5: quietly xtmixed pocschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || _all: R.cmoname || _all:R.cmoname || _all:R.state || geodistrict: , nolog ; xtmrho
mi xeq 1 / 5: quietly xtmixed pocschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 pctpdfs || _all: R.cmoname || _all:R.cmoname || _all:R.state || geodistrict: , nolog ; xtmrho

log close
*/


log using "logs/results_1_ibl_mi100_linear_clusts_043019.smcl", replace
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
mi xeq 1 / 5: mixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
* estat ic
* fitstat
* ereturn list
est store ibl0
est save "models/1a_ibl_controls_mi100_linear.ster", replace
outreg2 using "tables/1a_ibl_controls_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
addnote("", "Sources: American Community Survey 2012-16 (U.S. Census Bureau 2018), Common Core of Data 2015-16 (NCES 2018), and the author's data collection.") ///
title("TABLE 2", "Mixed Effects Models: Effects of Poverty & Race on IBL Emphasis") ///
ctitle("M0: Controls only")
mi xeq 1: quietly mixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || state: || geodistrict: , cov(unstructured); estat ic; estat icc
mi xeq 1: quietly xtmixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || state: || geodistrict: , cov(unstructured); xtmrho

* 1. school poverty
mi xeq 1 / 5: mixed inquiryprop povertyschool primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed inquiryprop povertyschool primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store ibl1
est save "models/1b_ibl_povsch_mi100_linear.ster", replace
outreg2 using "tables/1b_ibl_povsch_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M1: School poverty")
mi xeq 1: quietly mixed inquiryprop povertyschool primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || state: || geodistrict: , cov(unstructured); estat ic; estat icc

* 2. school race
mi xeq 1 / 5: mixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store ibl2
est save "models/1c_ibl_pocsch_mi100_linear.ster", replace
outreg2 using "tables/1c_ibl_pocsch_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M2: School race")
mi xeq 1: quietly mixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || state: || geodistrict: , cov(unstructured); estat ic; estat icc

* 3. school district poverty
mi xeq 1 / 5: mixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store ibl3
est save "models/1d_ibl_povsd_mi100_linear.ster", replace
outreg2 using "tables/1d_ibl_povsd_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M3: School district poverty")
mi xeq 1: quietly mixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || state: || geodistrict: , cov(unstructured); estat ic; estat icc

* 4. school district race
mi xeq 1 / 5: mixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store ibl4
est save "models/1e_ibl_pocsd_mi100_linear.ster", replace
outreg2 using "tables/1e_ibl_pocsd_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M4: School district race")
mi xeq 1: quietly mixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || state: || geodistrict: , cov(unstructured); estat ic; estat icc

log close


log using "logs/results_2_schpov_mi100_linear_clusts_043019.smcl", replace
** -----------------------------------------------------
** MIXED-EFFECTS LINEAR MODELS PT 2: IBL, ACADEMICS -> POVERTY
** -----------------------------------------------------

* Sequence of models:
* 0. controls only
* 1. IBL
* 2. academic performance
* 3. fully specified

* FULL MI ESTIMATION (rather than just one imputation)
* mi est, dots post:

* 0. controls only
mi xeq 1 / 5: mixed povertyschoolprop primary middle high lnage lnstudents urban || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop primary middle high lnage lnstudents urban || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store pov0
est save "models/2a_schpov_controls_mi100_linear.ster", replace
outreg2 using "tables/2a_schpov_controls_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
addnote("", "Sources: American Community Survey 2012-16 (U.S. Census Bureau 2018), Common Core of Data 2015-16 (NCES 2018), EdFacts Achievement Results for State Assessments (USDE 2018), and the author's data collection.") ///
title("TABLE 3", "Mixed Effects Models: Effects of IBL Emphasis and Academic Proficiency on Number of Poor Students") ///
ctitle("M0: Controls only")
mi xeq 1: quietly mixed povertyschoolprop primary middle high lnage lnstudents urban || _all:R.cmoname || state: || geodistrict: , cov(unstructured); estat ic; estat icc
mi xeq 1: quietly xtmixed povertyschoolprop primary middle high lnage lnstudents urban || _all:R.cmoname || state: || geodistrict: , cov(unstructured); xtmrho

* 1. IBL
mi xeq 1 / 5: mixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store pov1
est save "models/2b_schpov_ibl_mi100_linear.ster", replace
outreg2 using "tables/2b_schpov_ibl_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M1: IBL emphasis")
mi xeq 1: quietly mixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || state: || geodistrict: , cov(unstructured); estat ic; estat icc

* 2. academic performance
mi xeq 1 / 5: mixed povertyschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store pov2
est save "models/2c_schpov_acad_mi100_linear.ster", replace
outreg2 using "tables/2c_schpov_acad_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M2: Academic proficiency")
mi xeq 1: quietly mixed povertyschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || _all:R.cmoname || state: || geodistrict: , cov(unstructured); estat ic; estat icc

* 3. fully specified
mi xeq 1 / 5: mixed povertyschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store pov3
est save "models/2d_schpov_full_mi100_linear.ster", replace
outreg2 using "tables/2d_schpov_full_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M3: Fully specified")
mi xeq 1: quietly mixed povertyschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || _all:R.cmoname || state: || geodistrict: , cov(unstructured); estat ic; estat icc

log close


log using "logs/results_3_schpoc_mi100_linear_clusts_043019.smcl", replace
** -----------------------------------------------------
** MIXED-EFFECTS LINEAR MODELS PT 3: IBL, ACADEMICS -> RACE
** -----------------------------------------------------

* Sequence of models:
* 0. controls only
* 1. IBL
* 2. academic performance
* 3. fully specified

* 0. controls only
mi xeq 1 / 5: mixed pocschoolprop primary middle high lnage lnstudents urban || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop primary middle high lnage lnstudents urban || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store poc0
est save "models/3a_schpoc_controls_mi100_linear.ster", replace
outreg2 using "tables/3a_schpoc_controls_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
addnote("", "Sources: American Community Survey 2012-16 (U.S. Census Bureau 2018), Common Core of Data 2015-16 (NCES 2018), EdFacts Achievement Results for State Assessments (USDE 2018), and the author's data collection.") ///
title("TABLE 4", "Mixed Effects Models: Effects of IBL Emphasis and Academic Proficiency on Number of Students of Color") ///
ctitle("M0: Controls only")
mi xeq 1: quietly mixed pocschoolprop primary middle high lnage lnstudents urban || _all:R.cmoname || state: || geodistrict: , cov(unstructured); estat ic; estat icc
mi xeq 1: quietly xtmixed pocschoolprop primary middle high lnage lnstudents urban || _all:R.cmoname || state: || geodistrict: , cov(unstructured); xtmrho

* 1. IBL
mi xeq 1 / 5: mixed pocschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store poc1
est save "models/3b_schpoc_ibl_mi100_linear.ster", replace
outreg2 using "tables/3b_schpoc_ibl_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M1: IBL emphasis")
mi xeq 1: quietly mixed pocschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || _all:R.cmoname || state: || geodistrict: , cov(unstructured); estat ic; estat icc

* 2. academic performance
mi xeq 1 / 5: mixed pocschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store poc2
est save "models/3c_schpoc_acad_mi100_linear.ster", replace
outreg2 using "tables/3c_schpoc_acad_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M2: Academic proficiency")
mi xeq 1: quietly mixed pocschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || _all:R.cmoname || state: || geodistrict: , cov(unstructured); estat ic; estat icc

* 3. fully specified
mi xeq 1 / 5: mixed pocschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || _all:R.cmoname || _all:R.state || geodistrict: , cov(unstructured)
est store poc3
est save "models/3d_schpoc_full_mi100_linear.ster", replace
outreg2 using "tables/3d_schpoc_full_mi100_linear.rtf", replace word label onecol addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) ///
alpha(.001, .01, .05) symbol(***, **, *) ///
ctitle("M3: Fully specified")
mi xeq 1: quietly mixed pocschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || _all:R.cmoname || state: || geodistrict: , cov(unstructured); estat ic; estat icc

log close


/* ROBUSTNESS CHECKS TO IMPLEMENT: 

other imputed versions:
    100 MI
    5 MI
    1 MI
    0 MI (original)
    imputed IBL,
    schpov NOT imputed
different model specifications:
    mvaghermite vs laplace integration method,
    cov(unstructured),
    random slopes for key IVs (and IBL),
    crossfold (reg)
filtered data set:
    pt 2-3: schools w precise scores only, 
    numwords > 1, 
    inqcount < 100K 
pt 2-3: lagged academic quality: 2013-14, 14-15, vs 15-16


NOTES:
More robust specification: intmethod(mvaghermite)
How to calculate rho: e(sigma_u)^2/(e(sigma_u)^2+e(sigma_e)^2)
Useful stats to include in outreg2--but doesn't work with MI:
addstat(Log-Likelihood, e(ll), chi-square test, r(chi2), F-test, e(p), Prob > F, r(p), R-squared, e(r2)) */
