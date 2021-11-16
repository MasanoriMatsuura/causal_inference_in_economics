clear

** please change your path
global do = "C:\Users\mm_wi\Documents\ntu_agecon\Labor_empirical\Class_Data\do"
global log = "C:\Users\mm_wi\Documents\ntu_agecon\Labor_empirical\Class_Data\log"
global rawdata = "C:\Users\mm_wi\Documents\ntu_agecon\Labor_empirical\Class_Data\rawdata"
global workdata = "C:\Users\mm_wi\Documents\ntu_agecon\Labor_empirical\Class_Data\workdata"
global pic = "C:\Users\mm_wi\Documents\ntu_agecon\Labor_empirical\Class_Data\pic"
*/

capture log close
log using "C:\Users\mm_wi\Documents\ntu_agecon\Labor_empirical\Class_Datalog\ttest", replace text
set more off

use "C:\Users\mm_wi\Documents\ntu_agecon\Labor_empirical\Class_Data\rawdata\cps_2014_16.dta"

ttest incwage, by(sex)

ttest age = 30 if sex==1 

log close
