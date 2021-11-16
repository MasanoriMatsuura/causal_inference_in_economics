** Use do-files and log-files to keeping track of things that you did
** The results of each command can be recorded in a log-file for review when the do-file is finished running.
** "clear": cleam up any previous data, otherwise you can not load new dataset 
clear


** You should use a tree-style directory with different folders to organise your work in order to make it easier to find things at a later date

** please change your path
global do = "D:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\do"
global log = "D:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\log"
global rawdata = "D:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\rawdata"
global workdata = "D:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\workdata"
global pic = "D:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\pic"
*/


/** please change your path
global do = "C:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\do"
global log = "C:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\log"
global rawdata = "C:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\rawdata"
global workdata = "C:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\workdata"
global pic = "C:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\pic"
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

log using $log\C2_read_data.log, replace text

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
use "C:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\rawdata\acs_2015.dta", replace 
use "$rawdata\acs_2015.dta", replace 
