
clear
capture log close
cls

**  GENERAL DO-FILE COMMENTS
**  Program:		COVID_physician_001.do
**  Project:      	Physican Online Learning
**	Sub-Project:	Manuscript Analysis
**  Analyst:        Kern Rocke 
**	Date Created:	03/09/2021
**	Date Modified: 	03/09/2022
**  Algorithm Task: Re-running manuscript analysis in STATA


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150

*Set working directories (Set you working directory to match your OS)

*MAC OS 
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/OneDrive - The UWI - Cave Hill Campus/Consultancy/Physician Online Learning/Data"


*Load in data
import spss "`datapath'/2022_08_19.sav", clear

*List all variables in the dataset
ds

*Minor data cleaning

gen telehealth_doc = _v2
recode telehealth_doc (0=1) (1=0)
label var telehealth_doc "Physicians reporting use of telehealth"
label define telehealth_doc 0 "Yes" 1"No"
label value telehealth_doc telehealth_doc


*-------------------------------------------------------------------------------

* Re-create table 1
foreach x of varlist age_newbins Sex location practiceset Job Patients_seen~s {
	
	tab `x' telehealth_doc, col chi2
}
*-------------------------------------------------------------------------------

* Re-create table 2
foreach x of varlist effectiverealtime effectivenessstored effectivenessremote {
	
	tabstat `x', by(Job_rec) stat(n p50 iqr) format(%9.2f) col(stat) long
	mean `x', over(Job_rec) cformat(%9.2f)
	kwallis `x', by(Job)
	kwallis `x', by(Job_rec)
	
}

*-------------------------------------------------------------------------------

* Re-create table 3
foreach x of varlist barrierprivatecostandpurchase barrierprivatelackofinfoquality _v1 barrierprivatepoorinfrastructure barrierprivatetroubleshooting barrierprivatetraining barrierprivatepatientreluctance barrierprivateconfidence barrierprivatebillling barrierprivatepayment barrierprivateliability barrierprivateinsurance barrierprivatepreparation {
	
	tabstat `x', by(location) stat (p50 iqr) format(%9.2f) col(stat) long
	kwallis `x', by(location)
}
*-------------------------------------------------------------------------------

*Re-create table 4

foreach x of varlist effectiverealtime effectivenessstored effectivenessremote {

	tabstat `x', by(practiceset) stat(n p50 iqr) format(%9.2f) col(stat) long
	ranksum `x', by(practiceset)
	
}

*-------------------------------------------------------------------------------

*Re-create table 5

foreach x of varlist effectiverealtime effectivenessstored effectivenessremote {

	tabstat `x', by(location) stat(n p50 iqr) format(%9.2f) col(stat) long
	kwallis `x', by(location)
	
}
*-------------------------------------------------------------------------------


*------------------------------END----------------------------------------------
