** Use do-files and log-files to keeping track of things that you did
** The results of each command can be recorded in a log-file for review when the do-file is finished running.
** "clear": cleam up any previous data, otherwise you can not load new dataset 
clear


** You should use a tree-style directory with different folders to organise your work in order to make it easier to find things at a later date

** please change your path
global do = "C:\Users\mm_wi\Documents\ntu_agecon\Labor_empirical\Class_Data\do"
global log = "C:\Users\mm_wi\Documents\ntu_agecon\Labor_empirical\Class_Data\log"
global rawdata = "C:\Users\mm_wi\Documents\ntu_agecon\Labor_empirical\Class_Data\rawdata"
global workdata = "C:\Users\mm_wi\Documents\ntu_agecon\Labor_empirical\Class_Data\workdata"
global pic = "C:\Users\mm_wi\Documents\ntu_agecon\Labor_empirical\Class_Data\pic"
*/


** "capture": this command tells Stata to ignore any error messages and keep going
** "log close": closes any log-files that you might have accidentally left open
capture log close

/*
Start a log-file of all the results
The replace option overwrites any log file of the same name, so if you re-run an updated do-file again the old log-file will be replaced with the updated results
If, instead, you want to add the new log-file to the end of previous versions, then use the append option 
By default Stata uses its own SMCL format to create log files
The "text option overrides the default and makes the log file readable in any editor
*/

log using "C:\Users\mm_wi\Documents\ntu_agecon\Labor_empirical\Class_Data\log\C2_read_data.log", replace text

** When there are a lot of results in the results window, Stata pauses the do-file to give you a chance to review each page on-screen and you have to press a key to get more.
** This command tells Stata to run the entire do-file without pausing. You can then review the results in the log file.
set more off

** Stata's default memory may not be big enough to handle large datafiles. Trying to open a file that is too large returns a long error message beginning
//set memory 6000m

** It is good practice to keep extensive notes within your do-file so that when you look back over it you know what you were trying to achieve with each command or set of commands. 
** You can insert comments in several different ways

//

** Stata will ignore a line if it starts with two consecutive slashes (or with an asterisk *), 
** so you can type whatever you like on that line. But while two consecutive slashes work anywhere in a line, 
** i.e. you can start a comment after a command, an asterisk can only be used at the beginning. 
** Note, comments are also useful for getting Stata to temporarily ignore commands – 
** if you decide later to re-insert the command into your do-file, just delete the slashes or the asterisk

/* */

** You can place notes after a command by inserting it inside these pseudo-parentheses, for example:
// use "$rawdata\acs_2015.dta" /* opens 2015 acs data */
** These pseudo-parentheses are also useful for temporarily blocking a whole set of commands – place /* at the beginning of the first command, */ at the end of the last, and Stata will just skip over all of them.

** Lastly you can use three consecutive slashes which will result in the rest of the line being ignored and the next line added at the end of the current line. 
** This comment is useful for splitting a very long line of code over several lines

**graph twoway (scatter age inctot if year == 2015) /// This combines two scatter plots
**(scatter age incwage if year == 2015)






** If your data is in Stata format, then simply read it in as follows:
** The clear option will clear the revised dataset currently in memory before opening the other one
//use "D:\nest\Dropbox\causal_data_course\Class_Data\acs_2015.dta", clear
use "C:\Users\mm_wi\Documents\ntu_agecon\Labor_empirical\Class_Data\rawdata\acs_2015.dta", replace 
use "$rawdata\acs_2015.dta", replace   


** If you changed the directory already, the command can exclude the directory mapping: 
** cd: Sets the default directory where Stata will look for any files you try to open and save any files you try to save
cd $rawdata
cd "C:\Users\mm_wi\Documents\ntu_agecon\Labor_empirical\Class_Data\rawdata"
use "acs_2015.dta", replace 

use year datanum serial hhwt region using "acs_2015.dta",replace


** If you do not need all the variables from a data set, you can also load only some of the variables (here: pernum sex age year) from a file
 

** export delimited using acs_2015.csv, which can be read in excel
** replace option: replace previous version of acs_2015.csv
export delimited using acs_2015new.csv,replace
export delimited using acs_2015new.txt,replace


** import a txt (csv) file from outside
import delimited using acs_2015new.csv,clear
import delimited using acs_2015new.txt,clear

import delimited year1 datanum1 using acs_2015new.csv,clear

import delimited using acs_2015new.csv, colrange(1:3) rowrange(3:8) clear

import delimited using acs_2015new.txt,clear


** import/export Excel files

export excel using acs_2015new.xlsx, sheet("Data") replace

import excel year datanum serial hhwt using acs_2015new.xlsx, sheet("Data") clear 

** "infix": read fixed ASCII format data

** The data cannot be read directly but a codebook is necessary that explains how the data is stored
** To read this type of data into Stata we need to use the infix command and provide Stata with the information from the codebook.

** Since there are a lot of files it my be more convenient to save the codebook information in a separate file, a so called “dictionary file”.
** After setting up this file we would save it as acs_2015.dct
** Since setting up dictionary files is a lot of work, we are lucky that many datasets might already have dictionary files that can be read with STATA 

clear
  infix                ///
  int     year        1-4    ///
  byte    datanum     5-6    ///
  double  serial      7-14   ///
  float   hhwt        15-24  ///
  byte    region      25-26  ///
  long    incwage     66-71  ///
  using `"acs_2015.dat"'

clear
infix using read_acs_2015.dct  

** Save data: "save"
** replace option: overwrites any previous version of the file in the directory you try saving to 
** If you want to keep an old version as back-up, you should save under a different name
save "$rawdata\acs_2015_test.dta", replace
  

** wrong
clear
quietly infix                ///
  int     year        1-5    ///
  byte    datanum     6-7    ///
  double  serial      8-14   ///
  using `"acs_2015.dat"'  
  
  

** "compress": to preserve space, only store a variable with the minimum string length necessary
compress


** delete acs_2015_test.dta
erase "$rawdata\acs_2015_test.dta"

/*
** If you are going to make some revisions but are unsure of whether or not you will keep them, then you have two options
** "preserve": this command will take a snapshot of the current dataset
** If you want to revert back to that copy later on, just type "restore"
*/

use "$rawdata\acs_2015.dta", clear  

preserve

gen p=1

restore


log close



