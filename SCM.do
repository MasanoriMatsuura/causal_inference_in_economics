clear


// please change your path
global do = "C:\Users\mm_wi\Documents\ntu_agecon\laborecon\Class_Data\do"
global log = "C:\Users\mm_wi\Documents\ntu_agecon\laborecon\Class_Data\\log"
global rawdata = "C:\Users\mm_wi\Documents\ntu_agecon\laborecon\Class_Data\rawdata"
global workdata = "C:\Users\mm_wi\Documents\ntu_agecon\laborecon\Class_Data\workdata"
global pic = "C:\Users\mm_wi\Documents\ntu_agecon\laborecon\Class_Data\pic"
*/

cd $workdata

** single treated case
capture log close
log using "$log\sc_method", replace text
set more off

** Step 0: install packages
net from "https://web.stanford.edu/~jhain/Synth"
net install synth, all replace force

//ssc install synth, replace all
net install synth_runner, from(https://raw.github.com/bquistorff/synth_runner/master/) replace
//findit synth_runner

//sysuse smoking
use $rawdata\smoking_ca.dta,replace

** Step 1: Setup Panel Data
tsset state year

** Step 2: SC Estimation
synth cigsale beer(1984(1)1988) lnincome retprice age15to24 cigsale(1988) cigsale(1980) cigsale(1975), trunit(3) trperiod(1989)

** Step 3: SC Graphs
synth cigsale beer(1984(1)1988) lnincome retprice age15to24 cigsale(1988) cigsale(1980) cigsale(1975), trunit(3) trperiod(1989) figure 

** Step 4: Other Settings
synth cigsale beer(1984(1)1988) lnincome retprice age15to24 cigsale(1988) cigsale(1980) cigsale(1975), trunit(3) trperiod(1989) nested allopt counit(4(1)30) keep("sc_results") replace


** Step 5: Statistical Inference
synth_runner cigsale beer(1984(1)1988) lnincome retprice age15to24 cigsale(1988) cigsale(1980) cigsale(1975), trunit(3) trperiod(1989) pvals1s pre_limit_mult(5) 

** Step 6: Display Effect Graphs (use tempfile)
tempfile keepfile
synth_runner cigsale beer(1984(1)1988) lnincome retprice age15to24 cigsale(1988) cigsale(1980) cigsale(1975), trunit(3) trperiod(1989) keep(`keepfile') pvals1s pre_limit_mult(5)
merge 1:1 state year using "`keepfile'", nogenerate
gen cigsale_synth = cigsale-effect
single_treatment_graphs, trlinediff(-1) effects_ylabels(-30(10)30) effects_ymax(35) effects_ymin(-35)
effect_graphs, trlinediff(-1)
pval_graphs

** Use all untreated units
single_treatment_graphs, trlinediff(-1) effects_ylabels(-30(10)30) effects_ymax(35) effects_ymin(-35)

** Use the untreated units whose RMSPE is lower than 5 times of the treated unit's RMSPE
keep if pre_rmspe<=1.943233*5
single_treatment_graphs, trlinediff(-1) effects_ylabels(-30(10)30) effects_ymax(35) effects_ymin(-35)

** Displays SC estimated treatment effects for treated unit
effect_graphs, trlinediff(-1)




** Step 6: Display Effect Graphs (use real file)
synth_runner cigsale beer(1984(1)1988) lnincome retprice age15to24 cigsale(1988) cigsale(1980) cigsale(1975), trunit(3) trperiod(1989)  pvals1s pre_limit_mult(5) keep("$rawdata\results") replace
merge 1:1 state year using "$rawdata\results", nogenerate
gen cigsale_synth = cigsale-effect
pval_graphs

** Use all untreated units
single_treatment_graphs, trlinediff(-1) effects_ylabels(-30(10)30) effects_ymax(35) effects_ymin(-35)

** Use the untreated units whose RMSPE is lower than 5 times of the treated unit's RMSPE
keep if pre_rmspe<=1.943233*5
single_treatment_graphs, trlinediff(-1) effects_ylabels(-30(10)30) effects_ymax(35) effects_ymin(-35)

** Displays SC estimated treatment effects for treated unit
effect_graphs, trlinediff(-1)


** multiple treated case
clear
use $rawdata\smoking_ca.dta,replace
tsset state year

gen byte D = (state==3 & year>=1989) | (state==7 & year>=1988)

synth_runner cigsale beer(1984(1)1987) lnincome(1972(1)1987) retprice age15to24, d(D) //pre_limit_mult(5) //trends training_propr(`=13/18')

effect_graphs //, multi depvar(cigsale)

pval_graphs
