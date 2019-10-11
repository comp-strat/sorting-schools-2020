***---------------------------------------------------------------
*** CHARTER SCHOOL ANALYSIS MULTIPLE IMPUTATION DO-FILE
***
*** Author: Jaren Haber, PhD Candidate
*** URL: https://github.com/URAP-charter/sorting-schools-2019
*** Institution: University of California, Berkeley
*** Project: Charter school identities
*** Date created: October 10, 2019
***
*** Description: Prepares data for analysis by
*** performing multiple imputation. Saves data set for later use.
***---------------------------------------------------------------

* Install package for labeling multiple variables at once:
ssc install labvars, replace

* Specify current directory:
cd "/hdir/0/jhaber/Projects/charter_data/sorting-schools-2019/"

log using "logs/multiple_imputation_100_101019.smcl", replace

* Import prepared data (not yet imputed):
use "data/charter_schools_data_no_imputations.dta", clear

* Drop vars we don't impute directly
drop povertyschoolcount

* Make original zeros hard-missing (.z), this way they won't be imputed and can be restored later:
replace lnage = .z if lnage==. & age!=.
replace lnstudents = .z if lnstudents==. & students!=.
replace lnteachers = .z if lnteachers==. & teachers!=.


** -----------------------------------------------------
** PERFORM MULTIPLE IMPUTATION 
** -----------------------------------------------------

* Look at variables missing cases:
*mvpatterns inquiry_seed_log inquiry_narrow_log inquiry_full_log inquiry_full_nohands_log povertyschool pocschool povertysd pocsd primary middle high otherlevel age students urban cmo titlei readall13 readall14 readall15 mathall13 mathall14 mathall15 expulsions suspensions incidents lawreferrals lepratio disabledratio approgram teachers teacherratio certcount certrate

/* List of vars to impute, both those used in models and those that help with multiple imputation:
* School students and controls:
pocschoolcount lepcount disabledcount students primary middle high otherlevel age urban titlei cmo
* School quality/discipline:
readall13 readall14 readall15 mathall13 mathall14 mathall15 teachers certcount suspensions expulsions incidents lawreferrals
* School district level (add publicdensity charterdensity ??)
povertysd pocsd childpovertysd collegesd popdensity unemployment foreignborn closerate publicdensity
*/

* Declare MI data using memory-efficient style best-suited to modifying variables (rather than cases):
mi set mlong

* Register as imputed those variables missing any cases:
mi register imputed lnage lnstudents lnteachers readall13 readall14 readall15 mathall13 mathall14 mathall15 povertyschool povertysd pocsd readlevel13 readlevel14 readlevel15 mathlevel13 mathlevel14 mathlevel15

* Register as regular those vars with complete observations (may be used to help in imputation equations):
mi register regular closerate publicdensity charterdensity urban titlei ///
cmo cmonum state statenum geodistrict numwords numpages numpdfs ///
inquiry_seed_count inquiry_seed_prop inquiry_seed_log inquiry_narrow_count inquiry_narrow_prop inquiry_narrow_log ///
inquiry_full_count inquiry_full_prop inquiry_full_log inquiry_full_nohands_count inquiry_full_nohands_prop inquiry_full_nohands_log ///
traditional_prop progressive_prop ///
pocschool pocschoolcount ///
ethnicisolated99 ethnicisolated95 ethnicisolated90 ethnicisolated80 ethnicisolated70

mi register passive pctpdfs

* For reproducibility, set random seed:
set seed 43
* Increase maximum variable limit:
set matsize 5000

* Execute multiple implementation:
mi impute chained ///
///
(pmm, knn(5) omit(i.readlevel13 i.readlevel14 i.readlevel15 i.mathlevel13 i.mathlevel14 i.mathlevel15 lnstudents lnteachers readall13 readall14 readall15 mathall13 mathall14 mathall15)) ///
povertyschool ///
/// 
(pmm, knn(5) omit(lnstudents i.readlevel13 i.readlevel14 i.readlevel15 i.mathlevel13 i.mathlevel14 i.mathlevel15 mathall13 mathall14 mathall15)) ///
povertysd ///
///
(pmm, knn(5) omit(i.readlevel13 i.readlevel14 i.readlevel15 i.mathlevel13 i.mathlevel14 i.mathlevel15 lnstudents readall13 readall14 readall15 mathall13 mathall14 mathall15 lnteachers)) ///
pocsd ///
///
(pmm, knn(5)) lnage ///
///
(pmm, knn(5) omit(lnstudents lnteachers)) ///
readall13 ///
///
(pmm, knn(5) omit(lnage povertysd pocsd lnstudents readall13 readall14 readall15 lnteachers)) ///
mathall13 ///
///
(pmm, knn(5) omit(lnstudents lnteachers)) ///
readall14 ///
///
(pmm, knn(5) omit(lnage povertysd pocsd lnstudents readall13 readall14 readall15 lnteachers)) ///
mathall14 ///
///
(pmm, knn(5) omit(lnstudents lnteachers)) ///
readall15 ///
///
(pmm, knn(5) omit(lnage povertysd pocsd lnstudents readall13 readall14 readall15 lnteachers)) ///
mathall15 ///
///
(pmm, knn(5) omit(lnage povertysd pocsd readall13 readall14 readall15 mathall13 mathall14 mathall15 lnteachers i.readlevel13 i.readlevel14 i.readlevel15 i.mathlevel13 i.mathlevel14 i.mathlevel15)) ///
lnstudents ///
///
(pmm, knn(5) omit(lnage povertysd pocsd lnstudents readall13 readall14 readall15)) ///
lnteachers ///
///
(ologit, omit(lnage povertysd pocsd lnstudents readall13 readall14 readall15 mathall13 mathall14 mathall15 lnteachers)) ///
readlevel13 ///
///
(ologit, omit(lnage povertysd pocsd lnstudents readall13 readall14 readall15 mathall13 mathall14 mathall15 lnteachers)) ///
mathlevel13 ///
///
(ologit, omit(lnage povertysd pocsd lnstudents readall13 readall14 readall15 mathall13 mathall14 mathall15 lnteachers)) ///
readlevel14 ///
///
(ologit, omit(lnage povertysd pocsd lnstudents readall13 readall14 readall15 mathall13 mathall14 mathall15 lnteachers)) ///
mathlevel14 ///
///
(ologit, omit(lnage povertysd pocsd lnstudents readall13 readall14 readall15 mathall13 mathall14 mathall15 lnteachers)) ///
readlevel15 ///
///
(ologit, omit(lnage povertysd pocsd lnstudents readall13 readall14 readall15 mathall13 mathall14 mathall15 lnteachers)) ///
mathlevel15 ///
///
///
= numpdfs numwords numpages pocschoolcount ///
inquiry_full_prop traditional_prop progressive_prop ///
closerate publicdensity charterdensity ///
i.urban statenum cmonum geodistrict, ///
add(100) rseed(43) dots augment


** -----------------------------------------------------
** FINALIZE & SAVE DATA
** -----------------------------------------------------

* Recover variables using imputed natural-logarithmic versions:
replace age = exp(lnage)
replace students = exp(lnstudents)
replace teachers = exp(lnteachers) 
mi register passive age students teachers

* Recreate any original zeros, which were replaced with .z after log transformation: 
replace age = 0 if lnage==.z & age!=.
replace students = 0 if lnstudents==.z & students!=.
replace teachers = 0 if lnteachers==.z & teachers!=.

* Create new passive variables within MI (can use defaults because using mlong style):
gen povertyschoolprop = povertyschool/100
gen povertyschoolcount = round(povertyschool/100 * students)
gen teacherratio = students/teachers
gen upperlevel = middle + high + otherlevel
gen pocschoolprop = pocschoolcount/students
mi register passive pctpdfs povertyschoolprop povertyschoolcount teacherratio upperlevel pocschoolprop

* Drop if still missing key variables:
quietly mi xeq 1 / 100: drop if missing(students) | missing(lnstudents) | students==0 | lnstudents==.z
quietly mi xeq 1 / 100: drop if missing(pocschool) | missing(povertyschoolcount)

* Double-check all continuous vars are scaled the same across original and imputed datasets:
mi xeq 0 1: tabstat inquiry_full_log readall15 mathall15 readall14 mathall14 readall13 mathall13 pocschoolprop povertyschoolprop pocsd povertysd pctpdfs, stat(n mean median min max sd)

* Make sure original and imputed datasets have same summary stats for key variables:
mi xeq 0 1: tabstat inquiry_seed_log inquiry_narrow_log inquiry_full_log inquiry_full_nohands_log readall15 mathall15 pocschoolprop povertyschoolprop pocsd povertysd pctpdfs, stat(n mean median min max sd)

* Label variables: 
labvars pocschoolprop "% students of color (school)" ///
povertyschoolprop "% students in poverty (school)" povertyschoolcount "# students in poverty" ///
upperlevel "middle/high school" teacherratio "student/teacher ratio" ///
alternate

* Save data to disk
save "data/charter_schools_data_100_imputations.dta", replace
export delimited using "data/charter_schools_data_100_imputations.csv", replace

log close
translate "logs/multiple_imputation_100_101019.smcl" "logs/multiple_imputation_100.pdf"
