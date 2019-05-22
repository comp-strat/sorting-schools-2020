***---------------------------------------------------------------
*** CHARTER SCHOOL MIXED LINEAR REGRESSION: ROBUSTNESS CHECKS DO-FILE
***
*** Author: Jaren Haber, PhD Candidate
*** URL: https://github.com/jhaber-zz
*** Institution: University of California, Berkeley
*** Project: Charter school identities
***
*** Date created: February, 2019
*** Date modified: April 17, 2019
***
*** Description: Checks validity of mixed linear regression using various robustness checks,
*** some including filtered data sets (to deal with outliers) and some with alternative measures.
***---------------------------------------------------------------

* INITIALIZE:

ssc install labvars, replace

* Specify current directory:
cd "/hdir/0/jhaber/Projects/charter_data/stats_team/"

* Import and modify data:
use "data/stats_data_2015_mi5_keepschpov.dta", clear
/*drop povertyschoolcount
gen povertyschoolcount = round(povertyschool/100 * students)
quietly mi xeq 1/ 5: drop if missing(students) | missing(lnstudents) | students==0 | lnstudents==.z
quietly mi xeq 1/ 5: drop if pocschoolcount==-12 | pocschoolcount==-54 | missing(povertyschoolcount)
quietly mi xeq: drop if missing(pocschool) | missing(pocschoolcount)
replace pocsd = pocsd/100
replace povertysd = povertysd/100
replace readall14 = readall14/100
replace mathall14 = mathall14/100
gen povertyschoolprop = povertyschool/100
gen pocschoolprop = pocschoolcount/students
labvars inquirycount "IBL emphasis (#)" inquiryprop "IBL emphasis (%)" disciplinecount "FD emphasis (#)" disciplineprop "FD emphasis (%)" ///
pocschool "% students of color (school)" pocschoolprop "% students of color (school)" pocschoolcount "# students of color" ///
povertyschool "% students in poverty (school)" povertyschoolprop "% students in poverty (school)" povertyschoolcount "# students in poverty" ///
pocsd "% people of color (school district)" povertysd "% people in poverty (school district)" ///
cmoname "CMO" state "State" geodistrict "School district" ///
readall14 "% proficiency in RLA" mathall14 "% proficiency in math" readlevel14 "RLA prof. precision" mathlevel14 "Math prof. precision" ///
primary "Primary school (binary)" middle "Middle school (binary)" high "High school (binary)" otherlevel "Other school level (binary)" ///
age "Years open" lnage "Years open (log)" students "# students" lnstudents "# students (log)" teachers "# teachers" lnteachers "# teachers (log)" ///
urban "Urban locale" pctpdfs "% PDF pages" numwords "# words", ///
alternate
*/

* Double-check all continuous vars are scaled the same:
mi xeq 0 1: tabstat inquiryprop readall14 mathall14 pocschoolprop povertyschoolprop pocsd povertysd pctpdfs, stat(n mean median min max sd)


/* ROBUSTNESS CHECKS TO IMPLEMENT: 

Use lagged academic quality: 2013-14 and 2014-15 scores (instead of 2015-16) 

Filtered data set, only for those schools with:
    precise academic data: readlevel14 & mathlevel14 == 1
    inquirycount < 100000
    numwords > 10
    numpages < 100
    students > 10
    
*/


** -----------------------------------------------------
** RUN WITH LAGGED ACADEMIC VARIABLES
** -----------------------------------------------------

log using "logs/robust_laggedscores_mi5_linear_042919.smcl", replace

* RE-RUN LINEAR MIXED MODELS USING LAGGED ACADEMIC SCORES: 2013-14

* PT 2: 
* 2. academic performance
*mi xeq 1/ 5: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop readall13 mathall13 primary middle high lnage lnstudents urban readlevel13 mathlevel13 || geodistrict: , cov(unstructured)
* 3. fully specified
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop inquiryprop readall13 mathall13 primary middle high lnage lnstudents urban pctpdfs readlevel13 mathlevel13 || geodistrict: , cov(unstructured)

* PT 3:
* 2. academic performance
*mi xeq 1/ 5: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop readall13 mathall13 primary middle high lnage lnstudents urban readlevel13 mathlevel13 || state: || geodistrict: , cov(unstructured)
* 3. fully specified
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop inquiryprop readall13 mathall13 primary middle high lnage lnstudents urban pctpdfs readlevel13 mathlevel13 || state: || geodistrict: , cov(unstructured)


* RE-RUN LINEAR MIXED MODELS USING LAGGED ACADEMIC SCORES: 2014-15

* PT 2: 
* 2. academic performance
*mi xeq 1/ 5: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , cov(unstructured)
* 3. fully specified
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , cov(unstructured)

* PT 3:
* 2. academic performance
*mi xeq 1/ 5: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , cov(unstructured)
* 3. fully specified
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , cov(unstructured)

log close




** -----------------------------------------------------
** RUN WITH FILTERED DATA
** -----------------------------------------------------


* 1. precise academic data: readlevel15 & mathlevel15 == 1

* Import and modify data:
use "data/stats_data_2015_mi5_keepschpov.dta", clear
/*drop povertyschoolcount
gen povertyschoolcount = round(povertyschool/100 * students)
quietly mi xeq 1/ 5: drop if missing(students) | missing(lnstudents) | students==0 | lnstudents==.z
quietly mi xeq 1/ 5: drop if pocschoolcount==-12 | pocschoolcount==-54 | missing(povertyschoolcount)
quietly mi xeq: drop if missing(pocschool) | missing(pocschoolcount)
replace pocsd = pocsd/100
replace povertysd = povertysd/100
replace readall15 = readall15/100
replace mathall15 = mathall15/100
gen povertyschoolprop = povertyschool/100
gen pocschoolprop = pocschoolcount/students
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


log using "logs/robust_filtscores_mi5_linear_042919.smcl", replace

* RE-RUN LINEAR MIXED MODELS USING FILTERED DATA: PRECISE ACADEMIC DATA ONLY

mi xeq: drop if readlevel15 != 1 | mathlevel15 != 1

* PT 1:
* 0. controls only
*mi xeq 1/ 5: mixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
* 1. school poverty
*mi xeq 1/ 5: mixed inquiryprop povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
* 2. school race
*mi xeq 1/ 5: mixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
* 3. school district poverty
*mi xeq 1/ 5: mixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
* 4. school district race
*mi xeq 1/ 5: mixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)

* PT 2: 
* 0. controls only
*mi xeq 1/ 5: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , cov(unstructured)
* 1. IBL
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || geodistrict: , cov(unstructured)
* 2. academic performance
*mi xeq 1/ 5: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || geodistrict: , cov(unstructured)
* 3. fully specified
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || geodistrict: , cov(unstructured)

* PT 3:
* 0. controls only
*mi xeq 1/ 5: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , cov(unstructured)
* 1. IBL
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , cov(unstructured)
* 2. academic performance
*mi xeq 1/ 5: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || state: || geodistrict: , cov(unstructured)
* 3. fully specified
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || state: || geodistrict: , cov(unstructured)

log close



* 2. inquirycount < 100000

* Import and modify data:
use "data/stats_data_2015_mi5_keepschpov.dta", clear
/*drop povertyschoolcount
gen povertyschoolcount = round(povertyschool/100 * students)
quietly mi xeq 1/ 5: drop if missing(students) | missing(lnstudents) | students==0 | lnstudents==.z
quietly mi xeq 1/ 5: drop if pocschoolcount==-12 | pocschoolcount==-54 | missing(povertyschoolcount)
quietly mi xeq: drop if missing(pocschool) | missing(pocschoolcount)
replace pocsd = pocsd/100
replace povertysd = povertysd/100
replace readall15 = readall15/100
replace mathall15 = mathall15/100
gen povertyschoolprop = povertyschool/100
gen pocschoolprop = pocschoolcount/students
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


log using "logs/robust_filtibl_mi5_linear_042919.smcl", replace

* RE-RUN LINEAR MIXED MODELS USING FILTERED DATA: REMOVING HUGE WEBSITE OUTLIERS

mi xeq: drop if inquirycount > 100000

* PT 1:
* 0. controls only
*mi xeq 1/ 5: mixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
* 1. school poverty
*mi xeq 1/ 5: mixed inquiryprop povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
* 2. school race
*mi xeq 1/ 5: mixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
* 3. school district poverty
*mi xeq 1/ 5: mixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
* 4. school district race
*mi xeq 1/ 5: mixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)

* PT 2: 
* 0. controls only
*mi xeq 1/ 5: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , cov(unstructured)
* 1. IBL
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || geodistrict: , cov(unstructured)
* 2. academic performance
*mi xeq 1/ 5: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || geodistrict: , cov(unstructured)
* 3. fully specified
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || geodistrict: , cov(unstructured)

* PT 3:
* 0. controls only
*mi xeq 1/ 5: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , cov(unstructured)
* 1. IBL
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , cov(unstructured)
* 2. academic performance
*mi xeq 1/ 5: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || state: || geodistrict: , cov(unstructured)
* 3. fully specified
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || state: || geodistrict: , cov(unstructured)

log close



* 3. numwords > 10

* Import and modify data:
use "data/stats_data_2015_mi5_keepschpov.dta", clear
/*drop povertyschoolcount
gen povertyschoolcount = round(povertyschool/100 * students)
quietly mi xeq 1/ 5: drop if missing(students) | missing(lnstudents) | students==0 | lnstudents==.z
quietly mi xeq 1/ 5: drop if pocschoolcount==-12 | pocschoolcount==-54 | missing(povertyschoolcount)
quietly mi xeq: drop if missing(pocschool) | missing(pocschoolcount)
replace pocsd = pocsd/100
replace povertysd = povertysd/100
replace readall15 = readall15/100
replace mathall15 = mathall15/100
gen povertyschoolprop = povertyschool/100
gen pocschoolprop = pocschoolcount/students
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


log using "logs/robust_filtnumwords_mi5_linear_042919.smcl", replace

* RE-RUN LINEAR MIXED MODELS USING FILTERED DATA: NUMBER WORDS

mi xeq: drop if numwords < 10

* PT 1:
* 0. controls only
*mi xeq 1/ 5: mixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
* 1. school poverty
*mi xeq 1/ 5: mixed inquiryprop povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
* 2. school race
*mi xeq 1/ 5: mixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
* 3. school district poverty
*mi xeq 1/ 5: mixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
* 4. school district race
*mi xeq 1/ 5: mixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)

* PT 2: 
* 0. controls only
*mi xeq 1/ 5: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , cov(unstructured)
* 1. IBL
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || geodistrict: , cov(unstructured)
* 2. academic performance
*mi xeq 1/ 5: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || geodistrict: , cov(unstructured)
* 3. fully specified
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || geodistrict: , cov(unstructured)

* PT 3:
* 0. controls only
*mi xeq 1/ 5: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , cov(unstructured)
* 1. IBL
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , cov(unstructured)
* 2. academic performance
*mi xeq 1/ 5: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || state: || geodistrict: , cov(unstructured)
* 3. fully specified
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || state: || geodistrict: , cov(unstructured)

log close



* 4. numpages < 100

* Import and modify data:
use "data/stats_data_2015_mi5_keepschpov.dta", clear
/*drop povertyschoolcount
gen povertyschoolcount = round(povertyschool/100 * students)
quietly mi xeq 1/ 5: drop if missing(students) | missing(lnstudents) | students==0 | lnstudents==.z
quietly mi xeq 1/ 5: drop if pocschoolcount==-12 | pocschoolcount==-54 | missing(povertyschoolcount)
quietly mi xeq: drop if missing(pocschool) | missing(pocschoolcount)
replace pocsd = pocsd/100
replace povertysd = povertysd/100
replace readall15 = readall15/100
replace mathall15 = mathall15/100
gen povertyschoolprop = povertyschool/100
gen pocschoolprop = pocschoolcount/students
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


log using "logs/robust_filtnumpages_mi5_linear_042919.smcl", replace

* RE-RUN LINEAR MIXED MODELS USING FILTERED DATA: NUMBER PAGES

mi xeq: drop if numpages > 100

* PT 1:
* 0. controls only
*mi xeq 1/ 5: mixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
* 1. school poverty
*mi xeq 1/ 5: mixed inquiryprop povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
* 2. school race
*mi xeq 1/ 5: mixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
* 3. school district poverty
*mi xeq 1/ 5: mixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
* 4. school district race
*mi xeq 1/ 5: mixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)

* PT 2: 
* 0. controls only
*mi xeq 1/ 5: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , cov(unstructured)
* 1. IBL
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || geodistrict: , cov(unstructured)
* 2. academic performance
*mi xeq 1/ 5: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || geodistrict: , cov(unstructured)
* 3. fully specified
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || geodistrict: , cov(unstructured)

* PT 3:
* 0. controls only
*mi xeq 1/ 5: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , cov(unstructured)
* 1. IBL
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , cov(unstructured)
* 2. academic performance
*mi xeq 1/ 5: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || state: || geodistrict: , cov(unstructured)
* 3. fully specified
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || state: || geodistrict: , cov(unstructured)

log close



* 5. students > 10

* Import and modify data:
use "data/stats_data_2015_mi5_keepschpov.dta", clear
/*drop povertyschoolcount
gen povertyschoolcount = round(povertyschool/100 * students)
quietly mi xeq 1/ 5: drop if missing(students) | missing(lnstudents) | students==0 | lnstudents==.z
quietly mi xeq 1/ 5: drop if pocschoolcount==-12 | pocschoolcount==-54 | missing(povertyschoolcount)
quietly mi xeq: drop if missing(pocschool) | missing(pocschoolcount)
replace pocsd = pocsd/100
replace povertysd = povertysd/100
replace readall15 = readall15/100
replace mathall15 = mathall15/100
gen povertyschoolprop = povertyschool/100
gen pocschoolprop = pocschoolcount/students
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


log using "logs/robust_filtstudents_mi5_linear_042919.smcl", replace

* RE-RUN LINEAR MIXED MODELS USING FILTERED DATA: SCHOOL SIZE (# STUDENTS)

mi xeq: drop if students < 10

* PT 1:
* 0. controls only
*mi xeq 1/ 5: mixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
* 1. school poverty
*mi xeq 1/ 5: mixed inquiryprop povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop povertyschool primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
* 2. school race
*mi xeq 1/ 5: mixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop pocschoolprop primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
* 3. school district poverty
*mi xeq 1/ 5: mixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop povertysd primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
* 4. school district race
*mi xeq 1/ 5: mixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)
mi est, dots post: mixed inquiryprop pocsd primary middle high lnage lnstudents urban pctpdfs || cmoname: , cov(unstructured)

* PT 2: 
* 0. controls only
*mi xeq 1/ 5: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop primary middle high lnage lnstudents urban || geodistrict: , cov(unstructured)
* 1. IBL
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || geodistrict: , cov(unstructured)
* 2. academic performance
*mi xeq 1/ 5: mixed povertyschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || geodistrict: , cov(unstructured)
* 3. fully specified
*mi xeq 1/ 5: mixed povertyschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || geodistrict: , cov(unstructured)
mi est, dots post: mixed povertyschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || geodistrict: , cov(unstructured)

* PT 3:
* 0. controls only
*mi xeq 1/ 5: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop primary middle high lnage lnstudents urban || state: || geodistrict: , cov(unstructured)
* 1. IBL
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop inquiryprop primary middle high lnage lnstudents urban pctpdfs || state: || geodistrict: , cov(unstructured)
* 2. academic performance
*mi xeq 1/ 5: mixed pocschoolprop readall14 mathall14 primary middle high lnage lnstudents urban readlevel14 mathlevel14 || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop readall15 mathall15 primary middle high lnage lnstudents urban readlevel15 mathlevel15 || state: || geodistrict: , cov(unstructured)
* 3. fully specified
*mi xeq 1/ 5: mixed pocschoolprop inquiryprop readall14 mathall14 primary middle high lnage lnstudents urban pctpdfs readlevel14 mathlevel14 || state: || geodistrict: , cov(unstructured)
mi est, dots post: mixed pocschoolprop inquiryprop readall15 mathall15 primary middle high lnage lnstudents urban pctpdfs readlevel15 mathlevel15 || state: || geodistrict: , cov(unstructured)

log close
