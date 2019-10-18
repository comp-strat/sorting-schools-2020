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

* Import data:
use "data/charter_schools_data_100_imputations.dta", clear

* Set visualization options: grayscale
grstyle init
grstyle set plain, horizontal
grstyle set color mono 

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

* set variables for visualization (designate year of test scores)
gen readall = readall14
gen mathall = mathall14
gen readlevel = readlevel14
gen mathlevel = mathlevel14

* Label variables:
labvars inquiry_full_count "IBL emphasis (#)" inquiry_full_prop "IBL emphasis (%)" inquiry_full_log "IBL emphasis (log)" ///
pocschool "% SOC (schl.)" pocschoolprop "% SOC (schl.)" pocschoolcount "# SOC (schl.)" ///
povertyschool "% poor students" povertyschoolprop "% SOC (schl.)" povertyschoolcount "# poor students" ///
pocsd "% POC (SD)" povertysd "% poor (SD)" ///
cmoname "CMO" state "State" geodistrict "School district" ///
readall "% proficiency in RLA" mathall "% proficiency in math" ///
readlevel "RLA prof. precision" mathlevel "Math prof. precision" ///
primary "Primary school" middle "Middle school" high "High school" ///
otherlevel "Other school level" age "Years open" lnage "Years open (log)" students "# students" ///
lnstudents "# students (log)" teachers "# teachers" lnteachers "# teachers (log)" urban "Urban locale" ///
pctpdfs "% PDF pages" numwords "# words", alternate


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
