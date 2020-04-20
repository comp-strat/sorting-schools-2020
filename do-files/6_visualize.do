***---------------------------------------------------------------
*** CHARTER SCHOOL ANALYSIS VISUALIZATION DO-FILE
***
*** Author: Jaren Haber, PhD Candidate
*** URL: https://github.com/URAP-charter/sorting-schools-2019
*** Institution: University of California, Berkeley
*** Project: Charter school identities
*** Date created: April 29, 2019
***
*** Visualizes mixed linear regression results using coefplot 
*** based on models saved as .ster objects.
***---------------------------------------------------------------

* Install packages
ssc install labvars, replace
ssc install grstyle, replace
ssc install palettes, replace

* Set working directory
cd "/hdir/0/jhaber/Projects/charter_data/sorting-schools-2019/"

* Set visualization options: grayscale
grstyle init
grstyle set plain, horizontal
grstyle set color mono 


** -----------------------------------------------------
** SETUP FOR VISUALIZING UNIVARIATE AND BIVARIATE DISTRIBUTIONS
** -----------------------------------------------------

* Import data:
use "data/charter_schools_data_no_imputations.dta", clear

* set variables for visualization (designate year of test scores)
gen readall = readall14
gen mathall = mathall14
gen readlevel = readlevel14
gen mathlevel = mathlevel14
replace pocschool = pocschool/100
replace povertyschool = povertyschool/100

* Label variables:
labvars inquiry_full_count "IBL emphasis (#)" inquiry_full_prop "IBL emphasis (%)" inquiry_full_log "IBL emphasis (log)" ///
pocschool "% SOC (schl.)" pocschoolcount "# SOC (schl.)" ///
povertyschool "% poor students" povertyschoolcount "# poor students" ///
pocsd "% POC (SD)" povertysd "% poor (SD)" ///
cmoname "CMO" state "State" geodistrict "School district" ///
readall "% proficiency in RLA" mathall "% proficiency in math" ///
readlevel "RLA prof. precision" mathlevel "Math prof. precision" ///
primary "Primary school" middle "Middle school" high "High school" ///
otherlevel "Other school level" age "Years open" lnage "Years open (log)" students "# students" ///
lnstudents "# students (log)" teachers "# teachers" lnteachers "# teachers (log)" urban "Urban locale" ///
pctpdfs "% PDF pages" numwords "# words", alternate


** -----------------------------------------------------
** UNIVARIATE DISTRIBUTIONS
** -----------------------------------------------------

/*
local varlist inquiry_full_log povertyschool pocschool povertysd pocsd readall mathall ///
lnage lnstudents urban numwords numpages pctpdfs

foreach var of inquiry_full_log {
	kdensity `var', nograph gen(x fx)
	line fx x, sort ytitle(Density)
	graph export "visuals/univar_`var'.png", replace width(2160) height(1440)
} */

* IBL alone
kdensity inquiry_full_log, gen(x fx) title("")
graph export "visuals/univar_IBL.png", replace width(2160) height(1440)

* School race and poverty
lab var povertyschool "% enrolled students"
kdensity povertyschool, nograph gen(x2 fx2)
lab var fx2 "% students in poverty"
kdensity pocschool, nograph gen(fx3) at(x2)
lab var fx3 "% students of color"
line fx2 fx3 x2, sort ytitle(Density)
graph export "visuals/univar_school_race_poverty.png", replace width(2160) height(1440)

* School district race and poverty
lab var pocsd "% district population"
kdensity pocsd, nograph gen(x4 fx4)
lab var fx4 "% people of color"
kdensity povertysd, nograph gen(fx5) at(x4)
lab var fx5 "% people in poverty"
line fx4 fx5 x4, sort ytitle(Density)
graph export "visuals/univar_district_race_poverty.png", replace width(2160) height(1440)

* Reading and math proficiency
lab var readall "% students proficient"
kdensity readall, nograph gen(x6 fx6)
lab var fx6 "% proficiency in RLA"
kdensity mathall, nograph gen(fx7) at(x6)
lab var fx7 "% proficient in math"
line fx6 fx7 x6, sort ytitle(Density)
graph export "visuals/univar_reading_math_proficiency.png", replace width(2160) height(1440)


** -----------------------------------------------------
** BIVARIATE DISTRIBUTIONS 
** -----------------------------------------------------

* Key vars:
* inquiry_full_log povertyschool pocschool povertysd pocsd readall mathall

** TWO UNIVARIATE DISTRIBUTIONS (FOR REFERENCE)

* IBL x school poverty
lab var inquiry_full_log "IBL emphasis (log)"
kdensity inquiry_full_log, nograph gen(x8 fx8)
lab var fx8 "All schools"
kdensity inquiry_full_log if povertyschool > 0.9, nograph gen(fx9) at(x8)
lab var fx9 "Schools with >90% student poverty"
line fx8 fx9 x8, sort ytitle(Density)
graph export "visuals/univar_2_IBL_school_poverty.png", replace width(2160) height(1440)

* IBL x school race
lab var inquiry_full_log "IBL emphasis (log)"
kdensity inquiry_full_log, nograph gen(x10 fx10)
lab var fx10 "All schools"
kdensity inquiry_full_log if pocschool > 0.9, nograph gen(fx11) at(x10)
lab var fx11 "Schools with >90% students of color"
line fx10 fx11 x10, sort ytitle(Density)
graph export "visuals/univar_2_IBL_school_race.png", replace width(2160) height(1440)


** LINE OF BEST FIT

labvars povertyschool "% poor students" pocsd "% POC (SD)" readall "% proficiency in RLA", alternate

* IBL x race and class
graph twoway lfitci inquiry_full_log povertyschool, ytitle("IBL emphasis (log)") xtitle("% students in poverty") ciplot(rline)
graph export "visuals/bivar_IBL_school_poverty.png", replace width(2160) height(1440)
graph twoway lfitci inquiry_full_log pocschool, ytitle("IBL emphasis (log)") xtitle("% students of color") ciplot(rline)
graph export "visuals/bivar_IBL_school_race.png", replace width(2160) height(1440)
graph twoway lfitci inquiry_full_log povertysd, ytitle("IBL emphasis (log)") xtitle("% people in poverty (school district)") ciplot(rline)
graph export "visuals/bivar_IBL_sd_poverty.png", replace width(2160) height(1440)
graph twoway lfitci inquiry_full_log pocsd, ytitle("IBL emphasis (log)") xtitle("% people of color (school district)") ciplot(rline)
graph export "visuals/bivar_IBL_sd_race.png", replace width(2160) height(1440)

* reading and math proficiency x race and class
graph twoway lfitci readall povertyschool, ytitle("% proficiency in RLA") xtitle("% students in poverty") ciplot(rline)
graph export "visuals/bivar_RLA_proficiency_school_poverty.png", replace width(2160) height(1440)
graph twoway lfitci readall pocschool, ytitle("% proficiency in RLA") xtitle("% students of color") ciplot(rline)
graph export "visuals/bivar_RLA_proficiency_school_race.png", replace width(2160) height(1440)
graph twoway lfitci readall povertysd, ytitle("% proficiency in RLA") xtitle("% people in poverty (school district)") ciplot(rline)
graph export "visuals/bivar_RLA_proficiency_sd_poverty.png", replace width(2160) height(1440)
graph twoway lfitci readall pocsd, ytitle("% proficiency in RLA") xtitle("% people of color (school district)") ciplot(rline)
graph export "visuals/bivar_RLA_proficiency_sd_race.png", replace width(2160) height(1440)
graph twoway lfitci mathall povertyschool, ytitle("% proficiency in math") xtitle("% students in poverty") ciplot(rline)
graph export "visuals/bivar_math_proficiency_school_poverty.png", replace width(2160) height(1440)
graph twoway lfitci mathall pocschool, ytitle("% proficiency in math") xtitle("% students of color") ciplot(rline)
graph export "visuals/bivar_math_proficiency_school_race.png", replace width(2160) height(1440)
graph twoway lfitci mathall povertysd, ytitle("% proficiency in math") xtitle("% people in poverty (school district)") ciplot(rline)
graph export "visuals/bivar_math_proficiency_district_poverty.png", replace width(2160) height(1440)
graph twoway lfitci mathall pocsd, ytitle("% proficiency in math") xtitle("% people of color (school district)") ciplot(rline)
graph export "visuals/bivar_math_proficiency_district_race.png", replace width(2160) height(1440)

* Race x class
graph twoway lfitci povertyschool pocschool, ytitle("% students in poverty") xtitle("% students of color") ciplot(rline)
graph export "visuals/bivar_school_poverty_school_race.png", replace width(2160) height(1440)
graph twoway lfitci povertyschool pocsd, ytitle("% students in poverty") xtitle("% people of color (school district)") ciplot(rline)
graph export "visuals/bivar_school_poverty_district_race.png", replace width(2160) height(1440)
graph twoway lfitci povertyschool povertysd, ytitle("% students in poverty") xtitle("% people in poverty (school district)") ciplot(rline)
graph export "visuals/bivar_school_poverty_district_poverty.png", replace width(2160) height(1440)
graph twoway lfitci pocschool povertysd, ytitle("% students of color") xtitle("% people in poverty (school district)") ciplot(rline)
graph export "visuals/bivar_school_race_district_poverty.png", replace width(2160) height(1440)
graph twoway lfitci pocschool pocsd, ytitle("% students of color") xtitle("% people of color (school district)") ciplot(rline)
graph export "visuals/bivar_school_race_district_race.png", replace width(2160) height(1440)
graph twoway lfitci povertysd pocsd, ytitle("% people in poverty") xtitle("% people of color (school district)") ciplot(rline)
graph export "visuals/bivar_district_poverty_district_race.png", replace width(2160) height(1440)

* IBL x reading and math proficiency
*graph twoway lfitci inquiry_full_log readall, ytitle("IBL emphasis (log)")
*graph twoway lfitci inquiry_full_log mathall, ytitle("IBL emphasis (log)")
*graph twoway lfitci mathall readall, ytitle("% proficient in math")


** -----------------------------------------------------
** SETUP FOR VISUALIZING LINEAR MODELS
** -----------------------------------------------------

* Import data:
use "data/charter_schools_data_100_imputations.dta", clear

* set variables for visualization (designate year of test scores)
gen readall = readall14
gen mathall = mathall14
gen readlevel = readlevel14
gen mathlevel = mathlevel14

* Label variables:
labvars inquiry_full_count "IBL emphasis (#)" inquiry_full_prop "IBL emphasis (%)" inquiry_full_log "IBL emphasis (log)" ///
pocschool "% SOC (schl.)" pocschoolprop "% SOC (schl.)" pocschoolcount "# SOC (schl.)" ///
povertyschool "% poor students" povertyschoolprop "% poor (schl.)" povertyschoolcount "# poor students" ///
pocsd "% POC (SD)" povertysd "% poor (SD)" ///
cmoname "CMO" state "State" geodistrict "School district" ///
readall "% proficiency in RLA" mathall "% proficiency in math" ///
readlevel "RLA prof. precision" mathlevel "Math prof. precision" ///
primary "Primary school" middle "Middle school" high "High school" ///
otherlevel "Other school level" age "Years open" lnage "Years open (log)" students "# students" ///
lnstudents "# students (log)" teachers "# teachers" lnteachers "# teachers (log)" urban "Urban locale" ///
pctpdfs "% PDF pages" numwords "# words", alternate

* restoring and using modeling object for plotting
estimate use model_estimates/1a_ibl_controls_mi100_linear.ster
estimate store model1a
estimate use model_estimates/1b_ibl_povsch_mi100_linear.ster
estimate store model1b
estimate use model_estimates/1c_ibl_pocsch_mi100_linear.ster
estimate store model1c
estimate use model_estimates/1d_ibl_povsd_mi100_linear.ster
estimate store model1d
estimate use model_estimates/1e_ibl_pocsd_mi100_linear.ster
estimate store model1e
estimate use model_estimates/2a_schpov_controls_mi100_linear.ster
estimate store model2a
estimate use model_estimates/2b_schpov_ibl_mi100_linear.ster
estimate store model2b
estimate use model_estimates/2c_schpov_acad_mi100_linear.ster
estimate store model2c
estimate use model_estimates/2d_schpov_full_mi100_linear.ster
estimate store model2d
estimate use model_estimates/3a_schpoc_controls_mi100_linear.ster
estimate store model3a
estimate use model_estimates/3b_schpoc_ibl_mi100_linear.ster
estimate store model3b
estimate use model_estimates/3c_schpoc_acad_mi100_linear.ster
estimate store model3c
estimate use model_estimates/3d_schpoc_full_mi100_linear.ster
estimate store model3d


** -----------------------------------------------------
** MIXED-EFFECTS LINEAR MODELS PT 1: RACE & POVERTY -> IBL
** -----------------------------------------------------

* tweak the xsize option below for a desired plot size

* first plot, only drop constant and pctpdfs
coefplot model1b model1c model1d model1e, drop(_cons pctpdfs) ///
order(povertyschool pocschoolprop povertysd pocsd) graphregion(color(white)) ///
bgcolor(white) xtitle(Regression coefficient size) xsize(8)

graph export "visuals/model1_allvars.png", replace width(2160) height(1440)

* 4 most interesting variables
coefplot model1b model1c model1d model1e, drop(_cons pctpdfs middle high lnage lnstudents primary urban) ///
order(povertyschool pocschoolprop povertysd pocsd) graphregion(color(white)) bgcolor(white) ///
xtitle(Regression coefficient size) xsize(6)

graph export "visuals/model1_mainvars.png", replace width(2160) height(1440)


** -----------------------------------------------------
** MIXED-EFFECTS LINEAR MODELS PT 2: IBL, ACADEMICS -> POVERTY
** -----------------------------------------------------

* first plot, only drop constant and pctpdfs
coefplot model2a model2b model2c model2d, drop(_cons pctpdfs) ///
order(inquiry_full_log readall mathall) graphregion(color(white)) ///
bgcolor(white) xtitle(Regression coefficient size) xsize(8)

graph export "visuals/model2_allvars.png", replace width(2160) height(1440)

* 3 most interesting variables
coefplot model2b model2c model2d, drop(_cons pctpdfs middle high lnage lnstudents primary urban readlevel14 mathlevel14) ///
order(inquiry_full_log readall mathall) graphregion(color(white)) bgcolor(white) ///
xtitle(Regression coefficient size) xsize(8)

graph export "visuals/model2_mainvars.png", replace width(2160) height(1440)


** -----------------------------------------------------
** MIXED-EFFECTS LINEAR MODELS PT 3: IBL, ACADEMICS -> RACE
** -----------------------------------------------------

* first plot, only drop constant and pctpdfs
coefplot model3a model3b model3c model3d, drop(_cons pctpdfs) ///
order(inquiry_full_log readall mathall) graphregion(color(white)) ///
bgcolor(white) xtitle(Regression coefficient size) xsize(8)

graph export "visuals/model3_allvars.png", replace width(2160) height(1440)

* 3 most interesting variables
coefplot model3b model3c model3d, drop(_cons pctpdfs middle high lnage lnstudents primary urban readlevel14 mathlevel14) ///
order(inquiry_full_log readall mathall) graphregion(color(white)) bgcolor(white) ///
xtitle(Regression coefficient size) xsize(8)

graph export "visuals/model3_mainvars.png", replace width(2160) height(1440)

* Models 2 and 3: 3 most interesting variable, dropping pocschoolprep
coefplot model2d model3d, ///
drop(_cons pctpdfs middle high lnage lnstudents primary urban pocschoolprop readlevel14 mathlevel14 lnalpha var(_cons[cmoname])) ///
order(inquiry_full_log readall mathall) graphregion(color(white)) bgcolor(white) ///
xtitle(Regression coefficient size) xsize(6)

graph export "visuals/model2d_3d.png", replace width(2160) height(1440)
