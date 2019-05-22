***---------------------------------------------------------------
*** CHARTER SCHOOL ANALYSIS SET-UP DO-FILE
***
*** Author: Jaren Haber, PhD Candidate
*** URL: https://github.com/jhaber-zz
*** Institution: University of California, Berkeley
*** Project: Charter school identities
***
*** Date created: January 3, 2019
*** Date modified: April 17, 2019
***
*** Description: Prepares data for analysis by modifying variables,
*** performing multiple imputation, and saving data set for later use.
***---------------------------------------------------------------

* Install package for labeling multiple variables at once:
ssc install labvars, replace

* Specify current directory:
cd "/hdir/0/jhaber/Projects/charter_data/stats_team/"

log using "logs/charter_setup_mi5_keepschpov.smcl", replace

* Import data:
*import delimited data/stats_data_2015.csv, clear 
use data/stats_data_2015_original.dta, clear


** -----------------------------------------------------
** CREATE LAGGED TEST SCORE VARIABLES: 2013-14
** -----------------------------------------------------

* Create variables to store accuracy level of scores data and all scores data:
gen readlevel13 = .
gen mathlevel13 = .
gen readall13 = .
gen mathall13 = .
gen readingscore = reading1314
gen mathscore = math1314

* Fix >=99 value:
replace readingscore = "99" if readingscore == "GE99"
replace mathscore = "99" if mathscore == "GE99"

* Create var for percentile scores:
gen readpct = real(readingscore)
gen mathpct = real(mathscore)
* Merge with readall13/mathall13:
replace readall13 = readpct if readpct != .
replace mathall13 = mathpct if mathpct != .
* Record accuracy level of score:
replace readlevel13 = 1 if readpct != .
replace mathlevel13 = 1 if mathpct != .

* Create var for quintile scores and record level, merge with readall13/mathall13:
gen read5 = .
gen math5 = .

replace read5 = 2 if readingscore == "LE5"
replace read5 = 7 if readingscore == "6-9"
replace read5 = 12 if readingscore == "10-14"
replace read5 = 17 if readingscore == "15-19"
replace read5 = 22 if readingscore == "20-24"
replace read5 = 27 if readingscore == "25-29"
replace read5 = 32 if readingscore == "30-34"
replace read5 = 37 if readingscore == "35-39"
replace read5 = 42 if readingscore == "40-44"
replace read5 = 47 if readingscore == "45-49"
replace read5 = 52 if readingscore == "50-54"
replace read5 = 57 if readingscore == "55-59"
replace read5 = 62 if readingscore == "60-64"
replace read5 = 67 if readingscore == "65-69"
replace read5 = 72 if readingscore == "70-74"
replace read5 = 77 if readingscore == "75-79"
replace read5 = 82 if readingscore == "80-84"
replace read5 = 87 if readingscore == "85-89"
replace read5 = 92 if readingscore == "90-94"
replace read5 = 97 if readingscore == "GE95"

replace math5 = 2 if mathscore == "LE5"
replace math5 = 7 if mathscore == "6-9"
replace math5 = 12 if mathscore == "10-14"
replace math5 = 17 if mathscore == "15-19"
replace math5 = 22 if mathscore == "20-24"
replace math5 = 27 if mathscore == "25-29"
replace math5 = 32 if mathscore == "30-34"
replace math5 = 37 if mathscore == "35-39"
replace math5 = 42 if mathscore == "40-44"
replace math5 = 44 if mathscore == "45-49"
replace math5 = 52 if mathscore == "50-54"
replace math5 = 57 if mathscore == "55-59"
replace math5 = 62 if mathscore == "60-64"
replace math5 = 67 if mathscore == "65-69"
replace math5 = 72 if mathscore == "70-74"
replace math5 = 77 if mathscore == "75-79"
replace math5 = 82 if mathscore == "80-84"
replace math5 = 87 if mathscore == "85-89"
replace math5 = 92 if mathscore == "90-94"
replace math5 = 97 if mathscore == "GE95"

replace readall13 = read5 if read5 != .
replace mathall13 = math5 if math5 != .

replace readlevel13 = 5 if read5 != .
replace mathlevel13 = 5 if math5 != .

* Create var for decile scores and record level:
gen read10 = .
gen math10 = .

replace read10 = 5 if readingscore == "LE10"
replace read10 = 15 if readingscore == "11-19"
replace read10 = 25 if readingscore == "20-29"
replace read10 = 35 if readingscore == "30-39"
replace read10 = 45 if readingscore == "40-49"
replace read10 = 55 if readingscore == "50-59"
replace read10 = 65 if readingscore == "60-69"
replace read10 = 75 if readingscore == "70-79"
replace read10 = 85 if readingscore == "80-89"
replace read10 = 95 if readingscore == "GE90"

replace math10 = 5 if mathscore == "LE10"
replace math10 = 15 if mathscore == "11-19"
replace math10 = 25 if mathscore == "20-29"
replace math10 = 35 if mathscore == "30-39"
replace math10 = 45 if mathscore == "40-49"
replace math10 = 55 if mathscore == "50-59"
replace math10 = 65 if mathscore == "60-69"
replace math10 = 75 if mathscore == "70-79"
replace math10 = 85 if mathscore == "80-89"
replace math10 = 95 if mathscore == "GE90"

replace readall13 = read10 if read10 != .
replace mathall13 = math10 if math10 != .

replace readlevel13 = 10 if read10 != .
replace mathlevel13 = 10 if math10 != .

* Create var for ventile scores and record level:
gen read20 = .
gen math20 = .
replace read20 = 10 if readingscore == "LE20"
replace read20 = 30 if readingscore == "21-39"
replace read20 = 50 if readingscore == "40-59"
replace read20 = 70 if readingscore == "60-79"
replace read20 = 90 if readingscore == "GE80"

replace math20 = 10 if mathscore == "LE20"
replace math20 = 30 if mathscore == "21-39"
replace math20 = 50 if mathscore == "40-59"
replace math20 = 70 if mathscore == "60-79"
replace math20 = 90 if mathscore == "GE80"

replace readall13 = read20 if read20 != .
replace mathall13 = math20 if math20 != .

replace readlevel13 = 20 if read20 != .
replace mathlevel13 = 20 if math20 != .

* Create var for median scores and record level:
gen read50 = .
gen math50 = .

replace read50 = 25 if readingscore == "LT50"
replace read50 = 75 if readingscore == "GE50"

replace math50 = 25 if mathscore == "LT50"
replace math50 = 75 if mathscore == "GE50"

replace readall13 = read50 if read50 != .
replace mathall13 = math50 if math50 != .

replace readlevel13 = 50 if read50 != .
replace mathlevel13 = 50 if math50 != .

drop readingscore mathscore readpct mathpct read5 math5 read10 math10 read20 math20 read50 math50


** -----------------------------------------------------
** CREATE LAGGED TEST SCORE VARIABLES: 2014-15
** -----------------------------------------------------

* Create variables to store accuracy level of scores data and all scores data:
gen readlevel14 = .
gen mathlevel14 = .
gen readall14 = .
gen mathall14 = .
gen readingscore = reading1415
gen mathscore = math1415

* Fix >=99 value:
replace readingscore = "99" if readingscore == "GE99"
replace mathscore = "99" if mathscore == "GE99"

* Create var for percentile scores:
gen readpct = real(readingscore)
gen mathpct = real(mathscore)
* Merge with readall14/mathall14:
replace readall14 = readpct if readpct != .
replace mathall14 = mathpct if mathpct != .
* Record accuracy level of score:
replace readlevel14 = 1 if readpct != .
replace mathlevel14 = 1 if mathpct != .

* Create var for quintile scores and record level, merge with readall14/mathall14:
gen read5 = .
gen math5 = .

replace read5 = 2 if readingscore == "LE5"
replace read5 = 7 if readingscore == "6-9"
replace read5 = 12 if readingscore == "10-14"
replace read5 = 17 if readingscore == "15-19"
replace read5 = 22 if readingscore == "20-24"
replace read5 = 27 if readingscore == "25-29"
replace read5 = 32 if readingscore == "30-34"
replace read5 = 37 if readingscore == "35-39"
replace read5 = 42 if readingscore == "40-44"
replace read5 = 47 if readingscore == "45-49"
replace read5 = 52 if readingscore == "50-54"
replace read5 = 57 if readingscore == "55-59"
replace read5 = 62 if readingscore == "60-64"
replace read5 = 67 if readingscore == "65-69"
replace read5 = 72 if readingscore == "70-74"
replace read5 = 77 if readingscore == "75-79"
replace read5 = 82 if readingscore == "80-84"
replace read5 = 87 if readingscore == "85-89"
replace read5 = 92 if readingscore == "90-94"
replace read5 = 97 if readingscore == "GE95"

replace math5 = 2 if mathscore == "LE5"
replace math5 = 7 if mathscore == "6-9"
replace math5 = 12 if mathscore == "10-14"
replace math5 = 17 if mathscore == "15-19"
replace math5 = 22 if mathscore == "20-24"
replace math5 = 27 if mathscore == "25-29"
replace math5 = 32 if mathscore == "30-34"
replace math5 = 37 if mathscore == "35-39"
replace math5 = 42 if mathscore == "40-44"
replace math5 = 44 if mathscore == "45-49"
replace math5 = 52 if mathscore == "50-54"
replace math5 = 57 if mathscore == "55-59"
replace math5 = 62 if mathscore == "60-64"
replace math5 = 67 if mathscore == "65-69"
replace math5 = 72 if mathscore == "70-74"
replace math5 = 77 if mathscore == "75-79"
replace math5 = 82 if mathscore == "80-84"
replace math5 = 87 if mathscore == "85-89"
replace math5 = 92 if mathscore == "90-94"
replace math5 = 97 if mathscore == "GE95"

replace readall14 = read5 if read5 != .
replace mathall14 = math5 if math5 != .

replace readlevel14 = 5 if read5 != .
replace mathlevel14 = 5 if math5 != .

* Create var for decile scores and record level:
gen read10 = .
gen math10 = .

replace read10 = 5 if readingscore == "LE10"
replace read10 = 15 if readingscore == "11-19"
replace read10 = 25 if readingscore == "20-29"
replace read10 = 35 if readingscore == "30-39"
replace read10 = 45 if readingscore == "40-49"
replace read10 = 55 if readingscore == "50-59"
replace read10 = 65 if readingscore == "60-69"
replace read10 = 75 if readingscore == "70-79"
replace read10 = 85 if readingscore == "80-89"
replace read10 = 95 if readingscore == "GE90"

replace math10 = 5 if mathscore == "LE10"
replace math10 = 15 if mathscore == "11-19"
replace math10 = 25 if mathscore == "20-29"
replace math10 = 35 if mathscore == "30-39"
replace math10 = 45 if mathscore == "40-49"
replace math10 = 55 if mathscore == "50-59"
replace math10 = 65 if mathscore == "60-69"
replace math10 = 75 if mathscore == "70-79"
replace math10 = 85 if mathscore == "80-89"
replace math10 = 95 if mathscore == "GE90"

replace readall14 = read10 if read10 != .
replace mathall14 = math10 if math10 != .

replace readlevel14 = 10 if read10 != .
replace mathlevel14 = 10 if math10 != .

* Create var for ventile scores and record level:
gen read20 = .
gen math20 = .
replace read20 = 10 if readingscore == "LE20"
replace read20 = 30 if readingscore == "21-39"
replace read20 = 50 if readingscore == "40-59"
replace read20 = 70 if readingscore == "60-79"
replace read20 = 90 if readingscore == "GE80"

replace math20 = 10 if mathscore == "LE20"
replace math20 = 30 if mathscore == "21-39"
replace math20 = 50 if mathscore == "40-59"
replace math20 = 70 if mathscore == "60-79"
replace math20 = 90 if mathscore == "GE80"

replace readall14 = read20 if read20 != .
replace mathall14 = math20 if math20 != .

replace readlevel14 = 20 if read20 != .
replace mathlevel14 = 20 if math20 != .

* Create var for median scores and record level:
gen read50 = .
gen math50 = .

replace read50 = 25 if readingscore == "LT50"
replace read50 = 75 if readingscore == "GE50"

replace math50 = 25 if mathscore == "LT50"
replace math50 = 75 if mathscore == "GE50"

replace readall14 = read50 if read50 != .
replace mathall14 = math50 if math50 != .

replace readlevel14 = 50 if read50 != .
replace mathlevel14 = 50 if math50 != .

drop readingscore mathscore readpct mathpct read5 math5 read10 math10 read20 math20 read50 math50


** -----------------------------------------------------
** RECODE TEST SCORE VARIABLES: 2015-16
** -----------------------------------------------------

* Create variables to store accuracy level of scores data and all scores data:
gen readlevel15 = .
gen mathlevel15 = .
gen readall15 = .
gen mathall15 = .
gen readingscore = reading1516
gen mathscore = math1516

* Fix >=99 value:
replace readingscore = "99" if readingscore == "GE99"
replace mathscore = "99" if mathscore == "GE99"

* Create var for percentile scores:
gen readpct = real(readingscore)
gen mathpct = real(mathscore)
* Merge with readall15/mathall15:
replace readall15 = readpct if readpct != .
replace mathall15 = mathpct if mathpct != .
* Record accuracy level of score:
replace readlevel15 = 1 if readpct != .
replace mathlevel15 = 1 if mathpct != .

* Create var for quintile scores and record level, merge with readall15/mathall15:
gen read5 = .
gen math5 = .

replace read5 = 2 if readingscore == "LE5"
replace read5 = 7 if readingscore == "6-9"
replace read5 = 12 if readingscore == "10-14"
replace read5 = 17 if readingscore == "15-19"
replace read5 = 22 if readingscore == "20-24"
replace read5 = 27 if readingscore == "25-29"
replace read5 = 32 if readingscore == "30-34"
replace read5 = 37 if readingscore == "35-39"
replace read5 = 42 if readingscore == "40-44"
replace read5 = 47 if readingscore == "45-49"
replace read5 = 52 if readingscore == "50-54"
replace read5 = 57 if readingscore == "55-59"
replace read5 = 62 if readingscore == "60-64"
replace read5 = 67 if readingscore == "65-69"
replace read5 = 72 if readingscore == "70-74"
replace read5 = 77 if readingscore == "75-79"
replace read5 = 82 if readingscore == "80-84"
replace read5 = 87 if readingscore == "85-89"
replace read5 = 92 if readingscore == "90-94"
replace read5 = 97 if readingscore == "GE95"

replace math5 = 2 if mathscore == "LE5"
replace math5 = 7 if mathscore == "6-9"
replace math5 = 12 if mathscore == "10-14"
replace math5 = 17 if mathscore == "15-19"
replace math5 = 22 if mathscore == "20-24"
replace math5 = 27 if mathscore == "25-29"
replace math5 = 32 if mathscore == "30-34"
replace math5 = 37 if mathscore == "35-39"
replace math5 = 42 if mathscore == "40-44"
replace math5 = 44 if mathscore == "45-49"
replace math5 = 52 if mathscore == "50-54"
replace math5 = 57 if mathscore == "55-59"
replace math5 = 62 if mathscore == "60-64"
replace math5 = 67 if mathscore == "65-69"
replace math5 = 72 if mathscore == "70-74"
replace math5 = 77 if mathscore == "75-79"
replace math5 = 82 if mathscore == "80-84"
replace math5 = 87 if mathscore == "85-89"
replace math5 = 92 if mathscore == "90-94"
replace math5 = 97 if mathscore == "GE95"

replace readall15 = read5 if read5 != .
replace mathall15 = math5 if math5 != .

replace readlevel15 = 5 if read5 != .
replace mathlevel15 = 5 if math5 != .

* Create var for decile scores and record level:
gen read10 = .
gen math10 = .

replace read10 = 5 if readingscore == "LE10"
replace read10 = 15 if readingscore == "11-19"
replace read10 = 25 if readingscore == "20-29"
replace read10 = 35 if readingscore == "30-39"
replace read10 = 45 if readingscore == "40-49"
replace read10 = 55 if readingscore == "50-59"
replace read10 = 65 if readingscore == "60-69"
replace read10 = 75 if readingscore == "70-79"
replace read10 = 85 if readingscore == "80-89"
replace read10 = 95 if readingscore == "GE90"

replace math10 = 5 if mathscore == "LE10"
replace math10 = 15 if mathscore == "11-19"
replace math10 = 25 if mathscore == "20-29"
replace math10 = 35 if mathscore == "30-39"
replace math10 = 45 if mathscore == "40-49"
replace math10 = 55 if mathscore == "50-59"
replace math10 = 65 if mathscore == "60-69"
replace math10 = 75 if mathscore == "70-79"
replace math10 = 85 if mathscore == "80-89"
replace math10 = 95 if mathscore == "GE90"

replace readall15 = read10 if read10 != .
replace mathall15 = math10 if math10 != .

replace readlevel15 = 10 if read10 != .
replace mathlevel15 = 10 if math10 != .

* Create var for ventile scores and record level:
gen read20 = .
gen math20 = .
replace read20 = 10 if readingscore == "LE20"
replace read20 = 30 if readingscore == "21-39"
replace read20 = 50 if readingscore == "40-59"
replace read20 = 70 if readingscore == "60-79"
replace read20 = 90 if readingscore == "GE80"

replace math20 = 10 if mathscore == "LE20"
replace math20 = 30 if mathscore == "21-39"
replace math20 = 50 if mathscore == "40-59"
replace math20 = 70 if mathscore == "60-79"
replace math20 = 90 if mathscore == "GE80"

replace readall15 = read20 if read20 != .
replace mathall15 = math20 if math20 != .

replace readlevel15 = 20 if read20 != .
replace mathlevel15 = 20 if math20 != .

* Create var for median scores and record level:
gen read50 = .
gen math50 = .

replace read50 = 25 if readingscore == "LT50"
replace read50 = 75 if readingscore == "GE50"

replace math50 = 25 if mathscore == "LT50"
replace math50 = 75 if mathscore == "GE50"

replace readall15 = read50 if read50 != .
replace mathall15 = math50 if math50 != .

replace readlevel15 = 50 if read50 != .
replace mathlevel15 = 50 if math50 != .


** -----------------------------------------------------
** CREATE AND MODIFY VARIABLES
** -----------------------------------------------------

* Use "None" to cluster missing CMOs:
replace cmoname = "None" if missing(cmoname)

* Drop if missing level variables or inquiry/discipline variables:
drop if missing(primary) | missing(middle) | missing(high) | missing(otherlevel)
drop if missing(inquirycount) | missing(disciplinecount) | missing(numwords) | numwords==0
drop if missing(pocschoolcount)

* Replace with missing any remaining odd codes:
replace pocschoolcount = . if pocschoolcount==-12 | pocschoolcount==-54

* Drop vars we don't impute directly
drop povertyschoolcount inquiryprop

* Convert number PDF pages to percentage:
gen pctpdfs = numpdfs/numpages

* Convert CMO and state variables into numeric with labels:
encode cmoname, gen(cmonum)
encode state, gen(statenum)

* Revised teacher count to later create student/teacher ratio:
gen teachers = teachersccd if teachersccd != .
replace teachers = teacherscrdc if teachersccd == . & teacherscrdc != .

* Create log-scaled vars to account for time-shifted effects:
gen lnage = ln(age) 
gen lnstudents = ln(students)
gen lnteachers = ln(teachers)

* Make original zeros hard-missing (.z), this way they won't be imputed and can be restored later:
replace lnage = .z if lnage==. & age!=.
replace lnstudents = .z if lnstudents==. & students!=.
replace lnteachers = .z if lnteachers==. & teachers!=.

drop if missing(pocschoolcount)


** -----------------------------------------------------
** PERFORM MULTIPLE IMPUTATION 
** -----------------------------------------------------

* Look at variables missing cases:
*mvpatterns inquiry discipline povertyschool pocschool povertysd pocsd primary middle high otherlevel age students urban cmo titlei readall13 readall14 readall15 mathall13 mathall14 mathall15 expulsions suspensions incidents lawreferrals lepratio disabledratio approgram teachers teacherratio certcount certrate

/* List of vars to impute, both those used in models and those that help with multiple imputation:
* School students and controls:
povertyschoolcount pocschoolcount lepcount disabledcount students primary middle high otherlevel age urban titlei cmo
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
inquirycount disciplineprop traditionalprop progressiveprop ///
pocschool pocschoolcount ///
ethnicisolated99 ethnicisolated95 ethnicisolated90 ethnicisolated80 ethnicisolated70

gen inquiryprop = inquirycount/numwords
mi register passive inquiryprop pctpdfs

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
inquiryprop disciplineprop traditionalprop progressiveprop ///
closerate publicdensity charterdensity ///
i.urban statenum cmonum geodistrict, ///
add(5) rseed(43) dots augment


** -----------------------------------------------------
** FINALIZE & SAVE DATA
** -----------------------------------------------------

* Recover variables using imputed natural-logarithmic versions:
replace age = exp(lnage)
replace students = exp(lnstudents)
replace teachers = exp(lnteachers) 

* Rescale SD & academic variables so commensurate with dichotomous variables:
replace pocsd = pocsd/100
replace povertysd = povertysd/100
replace readall13 = readall13/100
replace mathall13 = mathall13/100
replace readall14 = readall14/100
replace mathall14 = mathall14/100
replace readall15 = readall15/100
replace mathall15 = mathall15/100

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
mi register passive povertyschoolcount upperlevel teacherratio pocschoolprop povertyschoolprop

* Drop if still missing key variables:
quietly mi xeq 1 / 5: drop if missing(students) | missing(lnstudents) | students==0 | lnstudents==.z
quietly mi xeq 1 / 5: drop if missing(pocschool) | missing(povertyschoolcount)

* Label variables:
labvars inquirycount "IBL emphasis (#)" inquiryprop "IBL emphasis (%)" disciplinecount "FD emphasis (#)" disciplineprop "FD emphasis (%)" ///
pocschool "% students of color (school)" pocschoolprop "% students of color (school)" pocschoolcount "# students of color" ///
povertyschool "% students in poverty (school)" povertyschoolprop "% students in poverty (school)"  povertyschoolcount "# students in poverty" ///
pocsd "% people of color (school district)" povertysd "% people in poverty (school district)" ///
cmoname "CMO" state "State" geodistrict "School district" ///
readall13 "% proficiency in RLA 2013-14" readall14 "% proficiency in RLA 2014-15" readall15 "% proficiency in RLA 2015-16" ///
mathall13 "% proficiency in math 2013-14" mathall14 "% proficiency in math 2014-15" mathall15 "% proficiency in math 2015-16" ///
readlevel13 "RLA blurring 2013-14" readlevel14 "RLA blurring 2014-15" readlevel15 "RLA blurring 2015-16" ///
mathlevel13 "Math blurring 2013-14" mathlevel14 "Math blurring 2014-15" mathlevel15 "Math blurring 2015-16" ///
primary "Primary school (binary)" middle "Primary school (binary)" high "Primary school (binary)" otherlevel "Primary school (binary)" ///
age "Years open" lnage "Years open (log)" students "# students" lnstudents "# students (log)" teachers "# teachers" lnteachers "# teachers (log)" ///
urban "Urban locale" pctpdfs "% PDF pages" numwords "# words", ///
alternate


save "data/stats_data_2015_mi5_keepschpov.dta", replace

log close
