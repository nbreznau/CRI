/*

THE CROWDSOURCED REPLICATION INITIATIVE (CRI)

Expansion Phase Replication Files
All Stata Teams

https://osf.io/bs46f/wiki/home/

Compiled by 
Nate Breznau, breznau.nate@gmail.com
Hung Nguyen, vhnh1607@gmail.com 

Note: All teams have been anonymized except "Team 0" which is Brady and 
Finnigan's original analytical code. All code has been left in its original
form, except the working directories have been modified, non-essential code
removed and estimation of average marginal effects included when not present.

Everything is run assuming that you have all files in the working directory,
Here we use "C:/data/

// Files needed:

*Publicly available

ZA1490.dta
ZA1950.dta
ZA2900.dta
ZA4900.dta
ZA6900_v2-0-0.dta
ZA4748.dta                        // Team 37 uses it for income recode
ZA2880.dta                        // Team 47 uses it for a migration Q
ZA3910_v2-1-0.dta                 // Team 47 uses it for a migration Q
bradyfinnigan2014countrydata.dta
bradyfinnigan2014countrydata.xls


*Provided by the PIs

cri_macro.csv
cri_macro.dta                  // cri_macro.csv imported into Stata without changes
L2data.dta                     // from the Replication Phase


*Provided by the Teams

netmig_un2.dta                 // Team 17
Mcountrydata.dta               // Team 21
L2_data.dta                    // Team 22
ESS_prepared                   // Team 22
L2data_exp2.dta                // Team 28
fract_30.dta				   // Team 30 fractionalization data
cri_marco2.xlsx                // Team 31 (this is cri_macro1.xlsx with missings recoded)
Immigration_Specific.xlsx      // Team 32
Macro data3 wide.dta           // Team 37 (this is cri_macro.csv in wide format)
DP_LIVE_20112018180339319.csv  // Team 39
countrydata_importV2.dta       // Team 42 (reshaped version of cri_macro.csv)
rawmig.dta                     // Team 43 (OECD inflows of foreign population)
macro_new_team43.dta           // Team 43 (cri_macro cleaned)
cri_marco_jmtb.dta             // Team 45 (cri_macro cleaned)
cri_macro_DE_1989_90.xlsx      // Team 46 (cri_macro.xlsx with a few values imputed as nearest year neighbors, e.g., stock in 1989 for 1990 in DE)
UN_Data-country of origin.dta  // Team 46 
cri_macro1.xlsx                // Team 47 missing fixed version of cri_macro
countrydata_52.dta             // Team 52 (combined B&F, cri_macro and OECD)
welfare_regime_subset23.dta    // Team 58 4-category regime variable
alldata2_60.dta                // Team 60 worked up data for models
Macrodata_64.xlsx              // Team 64 cri_macro reshaped plus inflow
Macros_Sample_68.xlsx          // Team 68
Ref_Inflow_OECD.xlsx           // Team 68
Mig_Inflow_OECD.xlsx           // Team 68
MIPEX.xlsx                     // Team 68
OECD inflation.dta             // Team 73 OECD inflation data
socx_oecd_83.xlsx              // Team 83 OECD socx data
full_data2_86.dta              // Team 86 Pre-cleaned/merged version. Original not available
netmigpct_96.dta               // Team 95 updated cri_macro to include netmig 2016
dat_expansion.dta              // Team 97 Produced from their R code


*Imported from Mplus or SPSS   // We have not yet replicated these analyses

xyz.dta                        // Team 21




// Packages needed:
ssc install zscore
ssc install mfx2
ssc install coefplot
ssc install reghdfe
ssc install egenmore
ssc install renames
ssc install distinct
ssc install labutil2
ssc install kountry
ssc install gologit2

*/	

*Hung
*cd "E:/July-August Project/Main Data"
*Nate
clear

*Set working directory
cd "C:/data/"

set more off





// TEAM 0 - Brady & Finnigan original
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team0.dta"
  if _rc==0   {
    display "team0.dta already exists, skipping to next code chunk"
  }
  else {
version 15
********************************
********** ISSP 1996 ***********
********************************

use ZA2900.dta, clear

// The numerical codes for countries in the 1996 and 2006 waves are different. 
// This command changes the 1996 codes to match the 2006 codes. 
// This command does not recode all the 1996 countries though.
recode v3 (1=36) (2/3=276) (4=826) (6=840) (8=348) (9=.) (10=372) (12=578) (13=752) (14=203) (15=705) (16=616) (17=.) (18=643) (19=554) (20=124) (21=608) (22/23=376) (24=392) (25=724) (26=428) (27=250) (28=.) (30=756), gen(v3a)
label define cntrylbl 36 "Australia" 124 "Canada" 152 "Chile" 158 "Taiwan" 191 "Croatia" 203 "Czech" 208 "Denmark" 246 "Finland" 250 "France" 276 "Germany" 348 "Hungary" 372 "Ireland" 376 "Isreal" 392 "Japan" 410 "S Korea" 428 "Latvia" 528 "Netherlands" 554 "New Zealand" 578 "Norway" 608 "Philippines" 616 "Poland" 620 "Portugal" 643 "Russia" 705 "Slovenia" 724 "Spain" 752 "Sweden" 756 "Switzerland" 826 "Great Britain" 840 "United States" 
label values v3a cntrylbl


****************************************
***** ROLE OF GOVERNMENT VARIABLES *****
****************************************

**** GOV RESPONSIBILITY ****
// All variables originally coded 1 to 4, "should be" to "should not be"
// Now dichotomized

// Provide jobs for everyone
recode v36 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
recode govjobs (1/2=0) (3/4=1), gen(dgovjobs)

// Provide healthcare for the sick
recode v38 (1=4) (2=3) (3=2) (4=1), gen(govhcare)
recode govhcare (1/2=0) (3/4=1), gen(dhcare)

// Provide living standard for the old
recode v39 (1=4) (2=3) (3=2) (4=1), gen(govretire)
recode govretire (1/2=0) (3/4=1), gen(dgovretire)

// Provide living standard for the unemployed
recode v41 (1=4) (2=3) (3=2) (4=1), gen(govunemp)
recode govunemp (1/2=0) (3/4=1), gen(dgovunemp)

// Reduce income diff bw rich and poor
recode v42 (1=4) (2=3) (3=2) (4=1), gen(govincdiff)
recode govincdiff (1/2=0) (3/4=1), gen(dgovincdiff)

// Provide decent housing to those who can't afford it
recode v44 (1=4) (2=3) (3=2) (4=1), gen(govhousing)
recode govhousing (1/2=0) (3/4=1), gen(dgovhous)


*****************************
***** CONTROL VARIABLES *****
*****************************

// AGE
rename v201 age
gen agesq=age*age

// SEX
recode v200 (1=0) (2=1), gen(female)

// MARITAL STATUS
** missing for Spain
rename v202 marst
recode marst (5=1) (nonmiss=0), gen(nevermar)
recode marst (2/5=0), gen(married)
recode marst (3/4=1) (nonmiss=0), gen(divorced)
recode marst (2=1) (nonmiss=0), gen(widow)

// STEADY LIFE PARTNER
recode v203 (2=0), gen(partner)

// HOUSEHOLD SIZE
// top-coded at 8 for Great Britain, 9 for Slovenia
rename v273 hhsize

// CHILDREN IN HH
recode v274 (2/4=1) (6/8=1) (nonmiss=0), gen(kidshh)
local i = 10
while `i' < 27 {
	replace kidshh=1 if v274==`i'
	local i = `i' + 2
}

// RURAL
recode v275 (3=1) (nonmiss=0), gen(rural)
recode v275 (2=1) (nonmiss=0), gen(suburb)

// COUNTRY/PLACE OF BIRTH
rename v324 ETHNIC

// EDUCATION
rename v204 edyears
rename v205 edcat
recode edcat (1/3=1) (4=2) (5=3) (6=4) (7=5), gen(degree)
label define edlabels 1 "Primary/less" 2 "Some Secondary" 3 "Secondary" 4 "Some Higher Ed" 5 "University or higher"
label values degree edlabels

recode degree (1/2=1) (nonmiss=0), gen(lesshs)
recode degree (3/4=1) (nonmiss=0), gen(hs)
recode degree (5=1) (nonmiss=0), gen(univ)

// OCCUPATION
// see page 127 (210 of pdf) in codebook
rename v208 isco
rename v209 occ2
rename v215 hourswrk

recode v206 (2/10=0), gen(ftemp)
recode v206 (2/4=1) (nonmiss=0), gen(ptemp)
recode v206 (5=1) (nonmiss=0), gen(unemp)
recode v206 (6/10=1) (nonmiss=0), gen(nolabor)

gen selfemp=v213==1
replace selfemp=. if v206==.
gen pubemp=(v212==1 | v212==2)
replace pubemp=. if v206==.
gen pvtemp=(selfemp==0 & pubemp==0)
replace pvtemp=. if v206==.

// INCOME
// constructing country-specific z-scores, then a standardized cross-country income variable
rename v218 faminc

gen inczscore=.
levelsof v3a, local(cntries)
foreach cntryval of local cntries {
	zscore faminc if v3a==`cntryval', listwise
	replace inczscore=z_faminc if v3a==`cntryval'
	drop z_faminc
}

// UNION MEMBER
recode v222 (2=0), gen(union)

// POLITICAL PARTY 
rename v223 party

// RELIGIOUS ATTENDANCE
recode v220 (1/2=1) (nonmiss=0), gen(highrel)
recode v220 (3/5=1) (nonmiss=0), gen(lowrel)
recode v220 (6=1) (nonmiss=0), gen(norel)
rename v220 religion

*** TECHNICAL VARIABLES ***

// year
gen year=1996
gen yr2006=0

// country identifier
rename v3a cntry

// weights
rename v325 wghts


save "ISSP96recode.dta", replace


********************************
********** ISSP 2006 ***********
********************************

use "ZA4700.dta", clear


*******************************
***** DEPENDENT VARIABLES *****
*******************************

**** GOV RESPONSIBILITY ****
// All variables originally coded 1 to 4, "should be" to "should not be"
// reverse coded, then dichotomous version collapses to "should be"/'maybe should be" and "maybe should not be"/"should not be"

// Provide jobs for everyone
recode V25 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
recode govjobs (1/2=0) (3/4=1), gen(dgovjobs)

// Provide healthcare for the sick
recode V27 (1=4) (2=3) (3=2) (4=1), gen(govhcare)
recode govhcare (1/2=0) (3/4=1), gen(dhcare)

// Provide living standard for the old
recode V28 (1=4) (2=3) (3=2) (4=1), gen(govretire)
recode govretire (1/2=0) (3/4=1), gen(dgovretire)

// Provide living standard for the unemployed
recode V30 (1=4) (2=3) (3=2) (4=1), gen(govunemp)
recode govunemp (1/2=0) (3/4=1), gen(dgovunemp)

// Reduce income diff bw rich and poor
recode V31 (1=4) (2=3) (3=2) (4=1), gen(govincdiff)
recode govincdiff (1/2=0) (3/4=1), gen(dgovincdiff)

// Provide decent housing to those who can't afford it
recode V33 (1=4) (2=3) (3=2) (4=1), gen(govhousing)
recode govhousing (1/2=0) (3/4=1), gen(dgovhous)


*****************************
***** CONTROL VARIABLES *****
*****************************

// AGE
gen agesq=age*age

// SEX
recode sex (1=0) (2=1), gen(female)

// MARITAL STATUS
rename marital marst
recode marst (5=1) (nonmiss=0), gen(nevermar)
recode marst (2/5=0), gen(married)
recode marst (3/4=1) (nonmiss=0), gen(divorced)
recode marst (2=1) (nonmiss=0), gen(widow)

// STEADY LIFE PARTNER
recode cohab (2=0), gen(partner)

// HOUSEHOLD SIZE
// top-coded at 8 for Sweden, 9 for Denmark
rename hompop hhsize

// CHILDREN IN HH
recode hhcycle (2/4=1) (6/8=1) (nonmiss=0), gen(kidshh)
local i = 10
while `i' < 29 {
	replace kidshh=1 if hhcycle==`i'
	local i = `i' + 2
}

// RURAL
recode urbrural (1/3=0) (4/5=1), gen(rural)
recode urbrural (2/3=1) (nonmiss=0), gen(suburb)

// EDUCATION
// see pg 97 in codebook
rename educyrs edyears
rename degree edcat
recode edcat (0=1), gen(degree)
label define edlabels 1 "Primary/less" 2 "Some Secondary" 3 "Secondary" 4 "Some Higher Ed" 5 "University or higher"
label values degree edlabels

recode degree (1/2=1) (nonmiss=0), gen(lesshs)
recode degree (3/4=1) (nonmiss=0), gen(hs)
recode degree (5=1) (nonmiss=0), gen(univ)

// OCCUPATION
rename wrkst empstat
rename ISCO88 isco // see pg 137 in codebook
rename wrkhrs hourswrk

recode empstat (2/10=0), gen(ftemp)
recode empstat (2/4=1) (nonmiss=0), gen(ptemp)
recode empstat (5=1) (nonmiss=0), gen(unemp)
recode empstat (6/10=1) (nonmiss=0), gen(nolabor)

gen selfemp=wrktype==4
replace selfemp=. if empstat==.
gen pubemp=(wrktype==1 | wrktype==2)
replace pubemp=. if empstat==.
gen pvtemp=(selfemp==0 & pubemp==0)
replace pvtemp=. if empstat==.

// INCOME
// earnings and family income are country specific
// dividing family income by the squareroot of hh size and transforming to country-specific z-scores
// generating a cross-country income variable using within-country z-scores

gen inczscore=.
local incvars = "AU_INC CA_INC CH_INC CL_INC CZ_INC DE_INC DK_INC DO_INC ES_INC FI_INC FR_INC GB_INC HR_INC HU_INC IE_INC IL_INC JP_INC KR_INC LV_INC NL_INC NO_INC NZ_INC PH_INC PL_INC PT_INC RU_INC SE_INC SI_INC TW_INC US_INC UY_INC VE_INC ZA_INC" 
foreach incvar of local incvars {
	zscore `incvar', listwise
	replace inczscore=z_`incvar' if z_`incvar'!=.
	drop z_`incvar'
}

// UNION MEMBER
recode union (2/3=0)

// POLITICAL PARTY
rename PARTY_LR party

// RELIGIOUS ATTENDANCE
recode attend (1/3=1) (nonmiss=0), gen(highrel)
recode attend (4/7=1) (nonmiss=0), gen(lowrel)
recode attend (8=1) (nonmiss=0), gen(norel)
rename attend religion

*** TECHNICAL VARIABLES ***

// Country Identifier
rename V3a cntry

// weights
rename weight wghts

// year
gen year=2006
gen yr2006=1

gen mail=mode==34

save "ISSP06recode.dta", replace


************************
***** MERGING DATA *****
************************

append using "ISSP96recode.dta"
sort cntry year
merge m:1 cntry year using "bradyfinnigan2014countrydata.dta"
recode cntry (36=1) (124=1) (208=1) (246=1) (250=1) (276=1) (372=1) (392=1) (528=1) (554=1) (578=1) (620=1) (724=1) (752=1) (756=1) (826=1) (840=1) (else=0), gen(orig17)
recode cntry (36=1) (124=1) (250=1) (276=1) (372=1) (392=1) (554=1) (578=1) (724=1) (752=1) (756=1) (826=1) (840=1) (else=0), gen(orig13)

*PI adjustment, original data are in 5-year estimates, we want 1-year
replace netmigpct=netmigpct/5
//

save "ISSP9606.dta", replace


********************* ANALYSES *****************************

global data "ISSP9606.dta"


*************************
***** 2006 ANALYSES *****
*************************

use $data, clear
keep if year==2006
keep if orig17

global depvars "dgovjobs dgovunemp dgovincdiff dgovretire dgovhous dhcare"
global controls "age agesq female nevermar divorced widow hhsize kidshh rural suburb lesshs univ ptemp unemp nolabor selfemp pubemp inczscore highrel lowrel"
global cntryvars "foreignpct netmigpct cforborn socx socdem liberal emprate assim diffex multi"

egen allcontrols = rowmiss($controls)
recode allcontrols (0=1) (nonmiss=0)
keep if allcontrols


******************************
***** 1996-2006 ANALYSES *****
******************************

use $data, clear
keep if orig13

global depvars "dgovjobs dgovunemp dgovincdiff dgovretire dgovhous dhcare"
global controls "age agesq female lesshs univ ptemp unemp nolabor selfemp inczscore yr2006"
global cntryvars "foreignpct netmigpct socx emprate"

egen allcontrols = rowmiss($controls)
recode allcontrols (0=1) (nonmiss=0)

quietly tab cntry, gen(cntryfe)



*** TABLE 4: FE % FOREIGN BORN ***
local m = 1
foreach depvar in $depvars {
	logit `depvar' foreignpct $controls cntryfe*
	margins, dydx(foreignpct) saving("t0m`m'", replace)
	local m = `m' + 1
}

foreach depvar in $depvars {
	logit `depvar' foreignpct socx $controls cntryfe*
	margins, dydx(foreignpct) saving("t0m`m'", replace)
	local m = `m' + 1
	}

foreach depvar in $depvars {
	logit `depvar' foreignpct emprate $controls cntryfe*
	margins, dydx(foreignpct) saving("t0m`m'", replace)
	local m = `m' + 1
	}
	
foreach depvar in $depvars {
	logit `depvar' netmigpct foreignpct $controls cntryfe*
	margins, dydx(foreignpct) saving("t0m`m'", replace)
	local m = `m' + 1
	}

*** TABLE 5: FE NET MIGRATION ***

foreach depvar in $depvars {
	logit `depvar' netmigpct $controls cntryfe*
	margins, dydx(netmigpct) saving("t0m`m'", replace)
	local m = `m' + 1
	}

foreach depvar in $depvars {
	logit `depvar' netmigpct socx $controls cntryfe*
	margins, dydx(netmigpct) saving("t0m`m'", replace)
	local m = `m' + 1
	}

foreach depvar in $depvars {
	logit `depvar' netmigpct emprate $controls cntryfe*
	margins, dydx(netmigpct) saving("t0m`m'", replace)
	local m = `m' + 1
	}

foreach depvar in $depvars {
	logit `depvar' netmigpct foreignpct $controls cntryfe*
	margins, dydx(netmigpct) saving("t0m`m'", replace)
	local m = `m' + 1
	}



use t0m1, clear
foreach i of numlist 2/48 {
append using t0m`i'
}

gen f = [_n]
gen factor = "Immigrant Stock" if f<25
replace factor = "Immigrant Flow, 1-year" if f>24
clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
gen id = "t0m1"
foreach i of numlist 2/48 {
replace id = "t0m`i'" if f==`i'
}

order factor AME lower upper id
keep factor AME lower upper id
save team0, replace

foreach i of numlist 1/48 {
erase "t0m`i'.dta" 
}
erase "ISSP96recode.dta"
erase "ISSP06recode.dta"
erase "ISSP9606.dta"
}

*==============================================================================*
*==============================================================================*
*==============================================================================*

































*
// TEAM 1
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*
*Note: only coding the data here, analysis done in R
*version 15
/*
{
clear
clear mata
clear matrix

* ISSP 1996
use "ZA2900.dta"

* ID
rename v2 id
lab var id "id"
* year
gen year = 1996
lab var year "year"
* old age care
gen oldagecare = .
replace oldagecare = 0 if v39 >= 3 & v39 <= 4
replace oldagecare = 1 if v39 >= 1 & v39 <= 2
lab var oldagecare "old age care"
* unemployment
gen unemployment = .
replace unemployment = 0 if v41 >= 3 & v41 <= 4
replace unemployment = 1 if v41 >= 1 & v41 <= 2
lab var unemployment "unemployment"
* income differences
gen incomedifferences = .
replace incomedifferences = 0 if v42 >= 3 & v42 <= 4
replace incomedifferences = 1 if v42 >= 1 & v42 <= 2
lab var incomedifferences "income differences"
* job
gen job = .
replace job = 0 if v36 >= 3 & v36 <= 4
replace job = 1 if v36 >= 1 & v36 <= 2
lab var job "job"
* cntry
gen cntry = .
replace cntry = 36 if v3 == 1
replace cntry = 276 if v3 == 2 | v3 == 3
replace cntry = 826 if v3 == 4
replace cntry = 840 if v3 == 6
replace cntry = 348 if v3 == 8
replace cntry = . if v3 == 9
replace cntry = 372 if v3 == 10
replace cntry = 578 if v3 == 12
replace cntry = 752 if v3 == 13
replace cntry = 203 if v3 == 14
replace cntry = 705 if v3 == 15
replace cntry = 616 if v3 == 16
replace cntry = . if v3 == 17
replace cntry = 643 if v3 == 18
replace cntry = 554 if v3 == 19
replace cntry = 124 if v3 == 20
replace cntry = . if v3 == 21
replace cntry = 376 if v3 == 22 | v3 == 23
replace cntry = 392 if v3 == 24
replace cntry = 724 if v3 == 25
replace cntry = 428 if v3 == 26
replace cntry = 250 if v3 == 27
replace cntry = . if v3 == 28
replace cntry = 756 if v3 == 30
lab var cntry "cntry"
* female
gen female = v200==2 if v200 != .
lab var female "female"
lab def female 0 "male" 1 "female"
lab val female female
* age
gen age = v201
gen age2 = age * age
lab var age "age"
lab var age2 "age squared"
* education
gen educ = .
replace educ = 0 if v205 >= 1 & v205 <= 4
replace educ = 1 if v205 == 5 | v205 == 6
replace educ = 2 if v205 == 7
lab var educ "education"
lab def educ 0 "primary" 1 "secondary" 2 "tertiary"
lab val educ educ
* employment
gen employment = .
replace employment = 0 if v206 == 2 | v206 == 3
replace employment = 1 if v206 == 4 | (v206 >= 6 & v206 <=10)
replace employment = 2 if v206 == 5
replace employment = 3 if v206 == 1
lab var employment "employment"
lab def employment 0 "part-time" 1 "not active" 2 "active unemployed" 3 "full-time"
lab val employment employment
* weight
rename v325 weight
lab var weight "weight"
* store data
keep id year cntry oldagecare unemployment incomedifferences job female age age2 educ employment weight
drop if cntry == . 
save "temp_1996.dta", replace

* ISSP 2006
use "ZA4700.dta", clear
* ID
rename V2 id
lab var id "id"
* year
gen year = 2006
lab var year "year"
* old age care
gen oldagecare = .
replace oldagecare = 0 if V28 >= 3 & V28 <= 4
replace oldagecare = 1 if V28 >= 1 & V28 <= 2
lab var oldagecare "old age care"
* unemployment
gen unemployment = .
replace unemployment = 0 if V30 >= 3 & V30 <= 4
replace unemployment = 1 if V30 >= 1 & V30 <= 2
lab var unemployment "unemployment"
* income differences
gen incomedifferences = .
replace incomedifferences = 0 if V31 >= 3 & V31 <= 4
replace incomedifferences = 1 if V31 >= 1 & V31 <= 2
lab var incomedifferences "income differences"
* job
gen job = .
replace job = 0 if V25 >= 3 & V25 <= 4
replace job = 1 if V25 >= 1 & V25 <= 2
lab var job "job"
* cntry
gen cntry = V3a
lab var cntry "cntry"
* female
gen female = sex==2 if sex != .
lab var female "female"
lab def female 0 "male" 1 "female"
lab val female female
* age
gen age2 = age * age
lab var age "age"
lab var age2 "age squared"
* education
gen educ = .
replace educ = 0 if degree >= 0 & degree <= 2
replace educ = 1 if degree == 3 | degree == 4
replace educ = 2 if degree == 5
lab var educ "education"
lab def educ 0 "primary" 1 "secondary" 2 "tertiary"
lab val educ educ
* employment
gen employment = .
replace employment = 0 if wrkst == 2 | wrkst == 3
replace employment = 1 if wrkst == 4 | (wrkst >= 6 & wrkst <=10)
replace employment = 2 if wrkst == 5
replace employment = 3 if wrkst == 1
lab var employment "employment"
lab def employment 0 "part-time" 1 "not active" 2 "active unemployed" 3 "full-time"
lab val employment employment
* weight
lab var weight "weight"
* store data
keep id year cntry oldagecare unemployment incomedifferences job female age age2 educ employment weight
drop if cntry == .
save "temp_2006.dta", replace

* combine data sets
use "temp_1996.dta", clear
append using "temp_2006.dta"
sort cntry year

* merge country level data
merge m:1 cntry year using "L2data.dta"
keep if _merge == 3
drop _merge

drop if emprate == . | foreignpct == . | socx == . | netmigpct == .
drop if cntry == 208 | cntry == 246 | cntry == 528 | cntry == 620

* export data set
save "cri1pooled.dta", replace

erase "temp_1996.dta"
erase "temp_2006.dta"
}
*/
*==============================================================================*
*==============================================================================*
*==============================================================================*

































// TEAM 2
*==============================================================================*
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team2.dta"
  if _rc==0   {
    display "team2.dta already exists, skipping to next code chunk"
  }
  else {
version 15  
*** ISSP 1985
use "ZA1490.dta", clear

*** GOV RESPONSIBILITY

// Provide jobs for everyone
recode V101 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
recode govjobs (1/2=0) (3/4=1), gen(dgovjobs)
// Provide healthcare for the sick
recode V103 (1=4) (2=3) (3=2) (4=1), gen(govhcare)
recode govhcare (1/2=0) (3/4=1), gen(dhcare)
// Provide living standard for the old
recode V104 (1=4) (2=3) (3=2) (4=1), gen(govretire)
recode govretire (1/2=0) (3/4=1), gen(dgovretire)
// Provide living standard for the unemployed
recode V106 (1=4) (2=3) (3=2) (4=1), gen(govunemp)
recode govunemp (1/2=0) (3/4=1), gen(dgovunemp)
// Reduce income diff bw rich and poor
recode V107 (1=4) (2=3) (3=2) (4=1), gen(govincdiff)
recode govincdiff (1/2=0) (3/4=1), gen(dgovincdiff)

*** CONTROL VARIABLES

// AGE
gen age = V117

replace age = 21 if V117 == 1 // Italy: 1 = 18-24 years
replace age = 30 if V117 == 2 // Italy: 1 = 25-34 years
replace age = 40 if V117 == 3 // Italy: 1 = 35-44 years
replace age = 50 if V117 == 4 // Italy: 1 = 45-54 years
replace age = 60 if V117 == 5 // Italy: 1 = 55-64 years
replace age = 70 if V117 == 6 // Italy: 1 = 65-74 years

gen agesq=age*age

// SEX

recode V118 (1=0) (2=1), gen(female)

// EDUCATION

// see codebook, p. 144 ff.

recode V123 (1 2 3 = 1) (else = 0), gen(lesshs_aus) // ?
replace lesshs_aus = 0 if V3 != 1
recode V123 (7 8 = 1) (else = 0), gen(univ_aus) 
replace univ_aus = 0 if V3 != 1

recode V123 (1 3 = 1) (else = 0), gen(lesshs_d) //  ?
replace lesshs_d = 0 if V3 != 2
recode V123 (7 = 1) (else = 0), gen(univ_d) 
replace univ_d = 0 if V3 != 2

recode V123 (3 4 = 1) (else = 0), gen(lesshs_gb) // ?
replace lesshs_gb = 0 if V3 != 3
recode V123 (8 = 1) (else = 0), gen(univ_gb) 
replace univ_gb = 0 if V3 != 3

recode V123 (1 2 = 1) (else = 0), gen(lesshs_usa) 
replace lesshs_usa = 0 if V3 != 4
recode V123 (5 6 = 1) (else = 0), gen(univ_usa) 
replace univ_usa = 0 if V3 != 4

recode V123 (3 4 = 1) (else = 0), gen(lesshs_a) // ?
replace lesshs_a = 0 if V3 != 5
recode V123 (8 = 1) (else = 0), gen(univ_a) 
replace univ_a = 0 if V3 != 5

recode V123 (1 2 3 = 1) (else = 0), gen(lesshs_i) // ?
replace lesshs_i = 0 if V3 != 8
recode V123 (9 = 1) (else = 0), gen(univ_i) 
replace univ_i = 0 if V3 != 8

gen lesshs = lesshs_aus + lesshs_d + lesshs_gb + lesshs_usa + lesshs_a + lesshs_i
gen univ = univ_aus + univ_d + univ_gb + univ_usa + univ_a

// OCCUPATION
*** Full-/Part-time Employment as in B/F

	*** Not asked ***

*** Full-/Part-time based on hours worked	
gen ftemp2 = 0
replace ftemp2 = 1 if V108 >= 35 & V108 <= 100  
gen ptemp2 = 0
replace ptemp2 = 1 if V108 < 35 & V108 > 0 
*** Unemployed
recode V109 (1=1) (else=0), gen(unemp) // !

***Not in labor force

	*** not asked ***
	gen nolabor=.
// SELFEMPLOYED
fre V112
recode V112 (1/2=1) (else=0) , gen(selfemp) // !
// INCOME


recode V128 (97 98 99 = .)

recode V128 (1/10 = 5250 "under 10,500") (11/20 = 15500 "10,500-20,499") (21/30 = 25500 "20,500-30,499") (31/40 = 35500 "30,500-40,499") (41/50 = 45500 "40,500-50,499") (51/60 = 55500 "50,500-60,499") (61/70 = 65500 "60,500-70,499") (71/80 = 75500 "70,500-80,499") (81/90 = 85500 "80.500-90.499"), gen(inc_aus)
replace inc_aus = 0 if V3 != 1

	**Income not measured in Germany

recode V128 (1 = 1000 "under 2000") (2 = 2500 "2000-2999") (3 = 3500 "3000-3999") (4 = 4500 "4000-4999") (5 = 5500 "5000-5999") (6 = 6500 "6000-6999") (7 = 7500 "7000-7999") (8 = 9000 "8000-9999") (9 = 11000 "10000-11999") (10 = 13500 "12000-14999") (11 = 18000 "15000+"), gen(inc_gb)
replace inc_gb = 0 if V3 != 3


recode V128 (1 = 500 "under 1000") (2 = 2000 "1000-2999") (3 = 3500 "3000-3999") (4 = 4500 "4000-4999") (5 = 5500 "5000-5999") (6 = 6500 "6000-6999") (7 = 7500 "7000-7999") ///
			(8 = 9000 "8000-9999") (9 = 11250 "10000-12499") (10 = 13750 "12500-14999") (11 = 16250 "15000-17499")  (12 = 18750 "17500-19999")  (13 = 21250 "20000-22499") ///
			(14 = 23750 "22500-24999") (15 = 30000 "25000-34999") (16 = 42500 "35000-49999") (17 = 65000 "50000") , gen(inc_usa)
replace inc_usa = 0 if V3 != 4

recode V128 (1 2 = 3000 "0 - 5999") (3 4 = 8000 "6000-9999") (5 6 = 12000 "10000-13999") (7 8 = 16000 "14000-17999") (9 10 = 20000 "18000-21999") ///
			(11 12 = 24000 "22000-25999") (13 14 = 28000 "26000-29999") (15 16 = 32000 "30000-33999") (17 18 = 36000 "34000-37999") (19 20 = 46000 "38000+"), gen(inc_a)
replace inc_a = 0 if V3 != 5

recode V128 (1 2 = 300 "0 - 600k") (3 4 = 900 "600k-1200k") (5 6 = 1600 "1200k-1800k") (7 8 = 2100 "1800k-2400k") (9 10 = 2700 "2400k-3000k") ///
			(11 12 = 3300 "3000k-3600k") (13 14 = 3900 "3600k-4200k") (15 16 = 4500 "4200k-4800k") (17 18 = 6000 "4800k+") , gen(inc_i)
replace inc_i = 0 if V3 != 8

gen faminc = inc_aus + inc_gb + inc_usa + inc_a + inc_i
replace faminc = . if V128 == .

gen inczscore=.
levelsof V3, local(cntries)
foreach cntryval of local cntries {
	center faminc if V3==`cntryval', prefix(z_) standardize // zscore faminc if v3a==`cntryval', listwise   // MM: "ZSCORE" findet man nicht mehr mit findit?!
	replace inczscore=z_faminc if V3==`cntryval'
	drop z_faminc
}

*** TECHNICAL VARIABLES ***

// ID
gen id_original = V2
// year
gen year = 1985
// country
fre V3
recode V3 (1 = 36) (2 = 276) (3 = 826) (4 = 840) (5 = 40) (8 = 380), gen(iso_country)
// weights
sum V141
gen weight = V141
	
*** reduce data set
keep govjobs dgovjobs govhcare dhcare govretire dgovretire govunemp dgovunemp govincdiff dgovincdiff /// main dependent variables
	 age agesq female lesshs univ ftemp2 ptemp2 unemp nolabor selfemp inczscore /// controls
	 id_original year iso_country weight /// technical variables 

	 save DATA_issp1985.dta, replace

*** ISSP 1990
	use "ZA1950.dta", clear
**** GOV RESPONSIBILITY ****
// All variables originally coded 1 to 4, "should be" to "should not be"

// Provide jobs for everyone
recode v49 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
recode govjobs (1/2=0) (3/4=1), gen(dgovjobs)
// Provide healthcare for the sick
recode v51 (1=4) (2=3) (3=2) (4=1), gen(govhcare)
recode govhcare (1/2=0) (3/4=1), gen(dhcare)
// Provide living standard for the old
recode v52 (1=4) (2=3) (3=2) (4=1), gen(govretire)
recode govretire (1/2=0) (3/4=1), gen(dgovretire)
// Provide living standard for the unemployed
recode v54 (1=4) (2=3) (3=2) (4=1), gen(govunemp)
recode govunemp (1/2=0) (3/4=1), gen(dgovunemp)
// Reduce income diff bw rich and poor
recode v55 (1=4) (2=3) (3=2) (4=1), gen(govincdiff)
recode govincdiff (1/2=0) (3/4=1), gen(dgovincdiff)
// Provide decent housing to those who can't afford it
recode v57 (1=4) (2=3) (3=2) (4=1), gen(govhousing)
recode govhousing (1/2=0) (3/4=1), gen(dgovhous)


*** CONTROL VARIABLES

// AGE
rename v60 age
gen agesq=age*age
// SEX

recode v59 (1=0) (2=1), gen(female)

// EDUCATION

recode v81 (1 2 3 4 = 1) (else = 0), gen(lesshs_aus) 
replace lesshs_aus = 0 if v3 != 1
recode v81 (6 = 1) (else = 0), gen(univ_aus) 
replace univ_aus = 0 if v3 != 1
recode v81 (1 2 3 = 1) (else = 0), gen(lesshs_wd) // ?
replace lesshs_wd = 0 if v3 != 2
recode v81 (8 = 1) (else = 0), gen(univ_wd) 
replace univ_wd = 0 if v3 != 2
recode v81 (1 2 3 = 1) (else = 0), gen(lesshs_od) // ?
replace lesshs_od = 0 if v3 != 3
recode v81 (7 = 1) (else = 0), gen(univ_od) 
replace univ_od = 0 if v3 != 3
recode v81 (3 4 = 1) (else = 0), gen(lesshs_gb) // ?
replace lesshs_gb = 0 if v3 != 4
recode v81 (8 = 1) (else = 0), gen(univ_gb) 
replace univ_gb = 0 if v3 != 4
recode v81 (3 4 5 = 1) (else = 0), gen(lesshs_nirl)  // ?
replace lesshs_nirl = 0 if v3 != 5
recode v81 (8 = 1) (else = 0), gen(univ_nirl) 
replace univ_nirl = 0 if v3 != 5
recode v81 (1 3 = 1) (else = 0), gen(lesshs_usa) 
replace lesshs_usa = 0 if v3 != 6
recode v81 (6 7 = 1) (else = 0), gen(univ_usa) 
replace univ_usa = 0 if v3 != 6
recode v81 (1 2 3 4 = 1) (else = 0), gen(lesshs_h) // ?
replace lesshs_h = 0 if v3 != 7
recode v81 (7 = 1) (else = 0), gen(univ_h) 
replace univ_h = 0 if v3 != 7
recode v81 (1 3 = 1) (else = 0), gen(lesshs_i) 
replace lesshs_i = 0 if v3 != 8
recode v81 (6 = 1) (else = 0), gen(univ_i) 
replace univ_i = 0 if v3 != 8
recode v81 (1 2 3 4 = 1) (else = 0), gen(lesshs_irl) 
replace lesshs_irl = 0 if v3 != 9
recode v81 (7 = 1) (else = 0), gen(univ_irl) 
replace univ_irl = 0 if v3 != 9
recode v81 (3 = 1) (else = 0), gen(lesshs_n) 
replace lesshs_n = 0 if v3 != 10
recode v81 (7 8 = 1) (else = 0), gen(univ_n) // ?
replace univ_n = 0 if v3 != 10
recode v81 (1 2 3 = 1) (else = 0), gen(lesshs_il) 
replace lesshs_il = 0 if v3 != 11
recode v81 (6 7 = 1) (else = 0), gen(univ_il) 
replace univ_il = 0 if v3 != 11

gen lesshs = lesshs_aus + lesshs_wd + lesshs_od + lesshs_gb + lesshs_nirl + lesshs_usa + lesshs_h + lesshs_i + lesshs_irl + lesshs_n + lesshs_il
gen univ = univ_aus + univ_wd + univ_od + univ_gb + univ_nirl + univ_usa + univ_h + univ_i + univ_irl + univ_n + univ_il


*** Full-/Part-time Employment as in B/F
recode v63 (1=1) (else=0) , gen(ftemp1) // !
recode v63 (2/4=1) (else=0), gen(ptemp1) // !
*** Unemployed
recode v63 (5=1) (else=0), gen(unemp) // !
***Not in labor force
	*** not asked ***
	gen nolabor=.

*** Full-/Part-time based on hours worked
gen ftemp2 = 0
replace ftemp2 = 1 if v63 >= 1 & v64 <= 100  
gen ptemp2 = 0
replace ptemp2 = 1 if v64 < 35 & v64 > 0 
// SELFEMPLOYED
fre v72
recode v72 (1=1) (else=0) , gen(selfemp) // !
// INCOME

recode v100 (1 = 1500 "under 3000") (2 = 3500 "3000-3999") (3 = 4500 "4000-4999") (4 = 5500 "5000-5999") (5 = 6500 "6000-6999") ///
			(6 = 7500 "7000-7999") (7 = 9000 "8000-9999") (8 = 11000 "10000-11999") (9 = 13500 "12000-14999") (10 = 16500 "15000-17999") (11 = 19000 "18000-19999") ///
			(12 = 21500 "20000-22999") (13 = 24500 "23000-25999") (14 = 27500 "26000-28999") (15 = 30500 "29000-31999") (16 = 40000 "32000+") , gen(inc_gb)
replace inc_gb = 0 if v3 != 4 

recode v100 (1 = 1500 "under 3000") (2 = 3500 "3000-3999") (3 = 4500 "4000-4999") (4 = 5500 "5000-5999") (5 = 6500 "6000-6999") ///
			(6 = 7500 "7000-7999") (7 = 9000 "8000-9999") (8 = 11000 "10000-11999") (9 = 13500 "12000-14999") (10 = 16500 "15000-17999") (11 = 19000 "18000-19999") ///
			(12 = 21500 "20000-22999") (13 = 24500 "23000-25999") (14 = 27500 "26000-28999") (15 = 30500 "29000-31999") (16 = 40000 "32000+"), gen(inc_nirl)
replace inc_nirl = 0 if v3 != 5

recode v100 (1 2 = 1500 "under 3000") (3 4 = 4000 "3000-4999") (5 6 = 6000 "5000-6999") (7 8 = 8500 "7000-9999") (9 10 = 12500 "10000-14999") ///
			(11 12 = 17500 "15000-19999") (13 14 = 22500 "20000-24999") (15 16 = 30000 "25000-34999") (17 18 = 42500 "35000-49999") (17 18 = 65000 "50000+"), gen(inc_usa)
replace inc_usa = 0 if v3 != 6

recode v100 (1 2 = 300 "0 - 600k") (3 4 = 900 "600k-1200k") (5 6 = 1600 "1200k-1800k") (7 8 = 2100 "1800k-2400k") (9 10 = 2700 "2400k-3000k") ///
			(11 12 = 3300 "3000k-3600k") (13 14 = 3900 "3600k-4200k") (15 16 = 4500 "4200k-4800k") (17 18 = 6000 "4800k+") , gen(inc_i)
replace inc_i = 0 if v3 != 8

recode v100 (1 = 1375 "under 2750") (2 = 3625 "2750-4499") (3 = 5000 "4500-5499") (4 = 6500 "5500-7499") (5 = 8250 "7500-9499") ///
			(6 = 10250 "9500-11999") (7 = 13500 "12000-14999") (8 = 16500 "15000-18999") (9 = 22000 "19000-25999") (10 = 34000 "26000+"), gen(inc_irl)
replace inc_irl = 0 if v3 != 9

recode v100 (1 = 2500 "under 5000") (2 =  7500 "5000-9999") (3 = 12500 "10000-14999") (4 = 17500 "15000-19999") (5 = 22500 "20000-24999") ///
			(6 = 27500 "25000-29999") (7 = 35000 "30000-39999") (8 = 45000 "40000-49999") (9 = 65000 "50000+"), gen(inc_n)
replace inc_n = 0 if v3 != 10

	*** not possible for Israel
recode v99 (. = 0)
gen faminc = v99 + inc_gb + inc_nirl + inc_usa + inc_i + inc_irl + inc_n 

replace faminc = . if v100 == .
replace faminc = . if v3 == 11 // Israel

gen inczscore=.
levelsof v3, local(cntries)
foreach cntryval of local cntries {
	center faminc if v3==`cntryval', prefix(z_) standardize // zscore faminc if v3a==`cntryval', listwise   // MM: "ZSCORE" findet man nicht mehr mit findit?!
	replace inczscore=z_faminc if v3==`cntryval'
	drop z_faminc
}

*** TECHNICAL VARIABLES ***
// ID
gen id_original = v2
// year
gen year = 1990
// country
recode v3 (1 = 36) (2 3 = 276) (4 = 826) (5 = 5) (6 = 840) (7 = 348) (8 = 380) (9 = 372) (10 = 578) (11 = 376), gen(iso_country) // What to do with Northern Ireland?
 
// weights
sum v141
gen weight = v141
	
*** reduce data set
keep govjobs dgovjobs govhcare dhcare govretire dgovretire govunemp dgovunemp govincdiff dgovincdiff /// main dependent variables
	 age agesq female lesshs univ ftemp1 ptemp1 ftemp2 ptemp2 unemp nolabor selfemp inczscore /// controls
	 id_original year iso_country weight /// technical variables 

save DATA_issp1990.dta, replace

*** ISSP 1996 ***
use "ZA2900.dta", clear

recode v3 (1=36) (2/3=276) (4=826) (6=840) (8=348) (9=380) (10=372) (12=578) (13=752) (14=203) (15=705) (16=616) (17=100) (18=643) (19=554) (20=124) (21=608) (22/23=376) (24=392) (25=724) (26=428) (27=250) (28=196) (30=756), gen(v3a)
label define cntrylbl 36 "Australia" 100 "Bulgaria" 124 "Canada" 152 "Chile" 158 "Taiwan" 191 "Croatia" 196 "Cyprus" 203 "Czech" 208 "Denmark" 246 "Finland" 250 "France" 276 "Germany" 348 "Hungary" 372 "Ireland" 376 "Isreal" 380 "Italy" 392 "Japan" 410 "S Korea" 428 "Latvia" 528 "Netherlands" 554 "New Zealand" 578 "Norway" 608 "Philippines" 616 "Poland" 620 "Portugal" 643 "Russia" 705 "Slovenia" 724 "Spain" 752 "Sweden" 756 "Switzerland" 826 "Great Britain" 840 "United States" 
label values v3a cntrylbl

*** GOV RESPONSIBILITY

// Provide jobs for everyone
recode v36 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
recode govjobs (1/2=0) (3/4=1), gen(dgovjobs)
// Provide healthcare for the sick
recode v38 (1=4) (2=3) (3=2) (4=1), gen(govhcare)
recode govhcare (1/2=0) (3/4=1), gen(dhcare)
// Provide living standard for the old
recode v39 (1=4) (2=3) (3=2) (4=1), gen(govretire)
recode govretire (1/2=0) (3/4=1), gen(dgovretire)
// Provide living standard for the unemployed
recode v41 (1=4) (2=3) (3=2) (4=1), gen(govunemp)
recode govunemp (1/2=0) (3/4=1), gen(dgovunemp)
// Reduce income diff bw rich and poor
recode v42 (1=4) (2=3) (3=2) (4=1), gen(govincdiff)
recode govincdiff (1/2=0) (3/4=1), gen(dgovincdiff)
// Provide decent housing to those who can't afford it
recode v44 (1=4) (2=3) (3=2) (4=1), gen(govhousing)
recode govhousing (1/2=0) (3/4=1), gen(dgovhous)


*** CONTROL VARIABLES

// AGE
rename v201 age
gen agesq=age*age
// SEX
recode v200 (1=0) (2=1), gen(female)
// EDUCATION
rename v204 edyears
rename v205 edcat
recode edcat (1/3=1) (4=2) (5=3) (6=4) (7=5), gen(degree)
label define edlabels 1 "Primary/less" 2 "Some Secondary" 3 "Secondary" 4 "Some Higher Ed" 5 "University or higher"
label values degree edlabels
recode degree (1/2=1) (else=0), gen(lesshs) // !
recode degree (3/4=1) (else=0), gen(hs) // !
recode degree (5=1) (else=0), gen(univ) // !
// OCCUPATION
// see page 127 (210 of pdf) in codebook
rename v208 isco
rename v209 occ2
rename v215 hourswrk

*** Full-/Part-time Employment as in B/F
recode v206 (1 = 0) (else = 0), gen(ftemp1) // !
recode v206 (2/4=1) (else=0), gen(ptemp1) // !

*** Full-/Part-time based on hours worked
gen ftemp2 = 0
replace ftemp2 = 1 if hourswrk >= 1 & hourswrk <= 100  
gen ptemp2 = 0
replace ptemp2 = 1 if hourswrk < 35 & hourswrk > 0 
*** Unemployed
recode v206 (5=1) (else=0), gen(unemp) // !
*Not in labor force
recode v206 (6/10=1) (else=0), gen(nolabor) // !
*** Selfemployed
fre v213
recode v213 (1 = 1) (else = 0), gen(selfemp) // !
// INCOME
// constructing country-specific z-scores, then a standardized cross-country income variable
rename v218 faminc

gen inczscore=.
levelsof v3a, local(cntries)
foreach cntryval of local cntries {
	center faminc if v3a==`cntryval', prefix(z_) standardize // zscore faminc if v3a==`cntryval', listwise   // MM: "ZSCORE" findet man nicht mehr mit findit?!
	replace inczscore=z_faminc if v3a==`cntryval'
	drop z_faminc
}

*** TECHNICAL VARIABLES

// ID
gen id_original = v2
// year
gen year=1996
// country identifier
rename v3a iso_country
// weights
rename v325 weight

*** reduce and save data set
keep govjobs dgovjobs govhcare dhcare govretire dgovretire govunemp dgovunemp govincdiff dgovincdiff govhousing dgovhous /// main dependent variables
	 age agesq female lesshs univ ftemp1 ptemp1 ftemp2 ptemp2 unemp nolabor selfemp inczscore /// controls
	 id_original year iso_country weight	/// technical variables 
	
save DATA_issp1996.dta, replace

*** ISSP 2006 ***

	use "ZA4700.dta", clear

*** GOV RESPONSIBILITY

// Provide jobs for everyone
recode V25 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
recode govjobs (1/2=0) (3/4=1), gen(dgovjobs)
// Provide healthcare for the sick
recode V27 (1=4) (2=3) (3=2) (4=1), gen(govhcare)
recode govhcare (1/2=0) (3/4=1), gen(dhcare)
// Provide living standard for the old
recode V28 (1=4) (2=3) (3=2) (4=1), gen(govretire)
recode govretire (1/2=0) (3/4=1), gen(dgovretire)
// Provide living standard for the unemployed
recode V30 (1=4) (2=3) (3=2) (4=1), gen(govunemp)
recode govunemp (1/2=0) (3/4=1), gen(dgovunemp)
// Reduce income diff bw rich and poor
recode V31 (1=4) (2=3) (3=2) (4=1), gen(govincdiff)
recode govincdiff (1/2=0) (3/4=1), gen(dgovincdiff)
// Provide financial help to students
recode V32 (1=4) (2=3) (3=2) (4=1), gen(govstudents)
recode govstudents (1/2=0) (3/4=1), gen(dgovstud)
// Provide decent housing to those who can't afford it
recode V33 (1=4) (2=3) (3=2) (4=1), gen(govhousing)
recode govhousing (1/2=0) (3/4=1), gen(dgovhous)


*** CONTROL VARIABLES

// AGE
// rename AGE age // die variable heißt bereits age, nicht AGE
gen agesq=age*age
// SEX
recode sex (1=0) (2=1), gen(female) // recode SEX (1=0) (2=1), gen(female)
// EDUCATION
// see pg 97 in codebook
rename educyrs edyears // rename EDUCYRS edyears
rename degree edcat // rename DEGREE edcat
recode edcat (0=1), gen(degree)
label define edlabels 1 "Primary/less" 2 "Some Secondary" 3 "Secondary" 4 "Some Higher Ed" 5 "University or higher"
label values degree edlabels
recode degree (1/2=1) (else=0), gen(lesshs) // !
recode degree (5=1) (else=0), gen(univ) // !
// OCCUPATION
rename wrkst empstat 
rename ISCO88 isco  
rename wrkhrs hourswrk 
*** Full-/Part-time Employment as in B/F
recode empstat (1 = 1) (else = 0), gen(ftemp1)
recode empstat (2/4=1) (else = 0), gen(ptemp1)
*** Full-/Part-time based on hours worked
gen ftemp2 = 0
replace ftemp2 = 1 if hourswrk >= 1 & hourswrk <= 100  
gen ptemp2 = 0
replace ptemp2 = 1 if hourswrk < 35 & hourswrk > 0 


*** Unemployed
recode empstat (5=1) (else = 0), gen(unemp)
*** Not in labor force
recode empstat (6/10=1) (else = 0), gen(nolabor)
*** Selfemployed
recode empstat (1 = 1) (else = 0), gen(selfemp)

// INCOME
// earnings and family income are country specific
// dividing family income by the squareroot of hh size and transforming to country-specific z-scores
// generating a cross-country income variable using within-country z-scores

gen inczscore=.
local incvars = "AU_INC CA_INC CH_INC CL_INC CZ_INC DE_INC DK_INC DO_INC ES_INC FI_INC FR_INC GB_INC HR_INC HU_INC IE_INC IL_INC JP_INC KR_INC LV_INC NL_INC NO_INC NZ_INC PH_INC PL_INC PT_INC RU_INC SE_INC SI_INC TW_INC US_INC UY_INC VE_INC ZA_INC" 

foreach incvar of local incvars {
	center `incvar', prefix(z_) standardize // zscore `incvar', listwise  // MM: "ZSCORE" findet man nicht mehr mit findit?!
	replace inczscore=z_`incvar' if z_`incvar'!=.
	drop z_`incvar' 
}


*** TECHNICAL VARIABLES

// ID
gen id_original = V2
// Country Identifier
rename V3a iso_country
// year
gen year=2006

*** reduce and save data set
keep govjobs dgovjobs govhcare dhcare govretire dgovretire govunemp dgovunemp govincdiff dgovincdiff govhousing dgovhous /// main dependent variables
	 age agesq female lesshs univ ftemp1 ptemp1 ftemp2 ptemp2 unemp nolabor selfemp inczscore /// controls
	 id_original year iso_country weight	/// technical variables 

save "DATA_issp2006.dta", replace

*** ISSP 2016 ***

use "ZA6900_v2-0-0.dta", clear

**** GOV RESPONSIBILITY

// Provide jobs for everyone
recode v21 (1=4) (2=3) (3=2) (4=1) (8 9 = .), gen(govjobs)
recode govjobs (1/2=0) (3/4=1), gen(dgovjobs)
// Provide healthcare for the sick
recode v23 (1=4) (2=3) (3=2) (4=1) (8 9 = .), gen(govhcare)
recode govhcare (1/2=0) (3/4=1), gen(dhcare)
// Provide living standard for the old
recode v24 (1=4) (2=3) (3=2) (4=1) (8 9 = .), gen(govretire)
recode govretire (1/2=0) (3/4=1), gen(dgovretire)
// Provide living standard for the unemployed
recode v26 (1=4) (2=3) (3=2) (4=1) (8 9 = .), gen(govunemp)
recode govunemp (1/2=0) (3/4=1), gen(dgovunemp)
// Reduce income diff bw rich and poor
recode v27 (1=4) (2=3) (3=2) (4=1) (8 9 = .), gen(govincdiff)
recode govincdiff (1/2=0) (3/4=1), gen(dgovincdiff)
// Provide decent housing to those who can't afford it
recode v29 (1=4) (2=3) (3=2) (4=1) (8 9 = .), gen(govhousing)
recode govhousing (1/2=0) (3/4=1), gen(dgovhous)

*** CONTROL VARIABLES

// AGE
rename AGE age
recode age (999 = .)
recode DK_AGE (0 = .)
replace age = DK_AGE if country == 208 & DK_AGE != . // Denmark: age categorized 

gen agesq=age*age

// SEX

recode SEX (1=0) (2=1) (9 = .), gen(female)
// EDUCATION
recode DEGREE (0/2=1) (else=0), gen(lesshs) // !
recode DEGREE (5 6 = 1) (else=0), gen(univ) // !

*** Full-/Part-time based on hours worked
recode WRKHRS (98 99 = .)
gen ftemp2 = 0
replace ftemp2 = 1 if WRKHRS >= 1 & WRKHRS <= 100  
gen ptemp2 = 0
replace ptemp2 = 1 if WRKHRS < 35 & WRKHRS > 0 
*** Unemployed
recode MAINSTAT (5=1) (else=0), gen(unemp) // !
*** Not on labor force
recode MAINSTAT (3 4 5 6 7 = 1) (else = 0), gen(nolabor)

// SELFEMPLOYED
fre EMPREL
recode EMPREL (2 3 =1) (else=0) , gen(selfemp) // !
tab EMPREL selfemp, mis

// INCOME
// constructing country-specific z-scores, then a standardized cross-country income variable
lookfor income
mvdecode AU_INC BE_INC CH_INC CL_INC CZ_INC DE_INC DK_INC ES_INC FI_INC FR_INC GB_INC GE_INC HR_INC HU_INC IL_INC IN_INC IS_INC JP_INC KR_INC LT_INC LV_INC NO_INC NZ_INC PH_INC RU_INC SE_INC SI_INC SK_INC SR_INC TH_INC TR_INC TW_INC US_INC VE_INC ZA_INC ///
		 , mv(999990 999999 999997 999998 9999999 9999990 9999998 9999999 9999997 99999990 99999999 99999998 999999990 999999998 = .)
		 
gen inczscore=.
local incvars = "AU_INC BE_INC CH_INC CL_INC CZ_INC DE_INC DK_INC ES_INC FI_INC FR_INC GB_INC GE_INC HR_INC HU_INC IL_INC IN_INC IS_INC JP_INC KR_INC LT_INC LV_INC NO_INC NZ_INC PH_INC RU_INC SE_INC SI_INC SK_INC SR_INC TH_INC TR_INC TW_INC US_INC VE_INC ZA_INC" 
foreach incvar of local incvars {
	center `incvar', prefix(z_) standardize // zscore `incvar', listwise  // MM: "ZSCORE" findet man nicht mehr mit findit?!
	replace inczscore=z_`incvar' if z_`incvar'!=.
	drop z_`incvar'
}

*** TECHNICAL VARIABLES
// ID
gen id_original = CASEID
// year
gen year=2016
// country identifier
rename country iso_country
// weights
lookfor weight
rename WEIGHT weight

	
*** reduce and save data set
keep govjobs dgovjobs  govhcare dhcare govretire dgovretire govunemp dgovunemp govincdiff dgovincdiff govhousing dgovhous /// main dependent variables
	 age agesq female lesshs univ ftemp2 ptemp2 unemp selfemp inczscore /// controls
	 year iso_country weight	/// technical variables 
	
save DATA_issp2016.dta, replace

*** Append and merge 
	use "DATA_issp2016" , clear
	append using "DATA_issp1985"
	append using "DATA_issp1990"
	append using "DATA_issp1996"
	append using "DATA_issp2006"

label define COUNTRY 5 "Northern Ireland" 40 "Austria" 100 "Bulgaria" 124 "Canada" 196 "Cyprus" 214 "The Dominican Republic" 372 "Ireland" 380 "Italy" 528 "Netherlands" 616 "Poland" 620 "Portugal" 858 "Uruguay", add	// 
		
save "DATA_final.dta", replace

*** change order of variables
order iso_country year

*** CRI Macro Data ***

*** import CRI macro data
import delimited "cri_macro.csv", clear 

*** set as panel
xtset iso_country year, yearly

*** create one year lag of each variable
foreach var of varlist gdp_oecd-socx_oecd {
gen `var'_lag1=L1.`var'
}

*** create one year lagged one year-change in each variable
foreach var of varlist gdp_oecd-socx_oecd {
gen `var'_d1_lag1=L1.`var'-L2.`var'
}

*** create more deltas for foreign born variable from World Bank
foreach n of numlist 3/11 {
local d=`n'-1
gen migstock_wb_d`d'_lag1=L1.migstock_wb-L`n'.migstock_wb
}

save "cri_macro_2.dta", replace

use "DATA_final.dta", replace

*** merge pooled ISSP with macro data 
merge m:1 iso_country year using "cri_macro_2.dta"

drop if _merge==2

*** create country-year variable
gen cntryyear=iso_country*10000+year

*** define established democracies with advanced welfare state
gen advweldem=0
replace advweldem=1 if iso_country==36 | iso_country==40 | iso_country==56 | iso_country==124 | iso_country==208 | iso_country==246 | iso_country==250 | iso_country==276 | iso_country==352 | ///
 		   iso_country==372 | iso_country==380 | iso_country==392 | iso_country==528 | iso_country==554 | iso_country==578 | iso_country==620 | iso_country==620 | iso_country==620 | ///
					   iso_country==724 |iso_country==752 | iso_country==756 | iso_country==826 | iso_country==840 // excludes Northern Ireland, Israel, South Korea



keep if advweldem==1				 
gen BFsample=0
replace BFsample=1 if advweldem==1 & (year==1996 | year==2006)
replace BFsample=0 if iso_country==380
tab iso_country year if BFsample==1
gen BF_FEsample=BFsample
replace BF_FEsample=0 if iso_country==208 | iso_country==246 | iso_country==528 | iso_country==620 

*PI added this line to reduce size
keep govjobs govunemp govincdiff govretire govhous govhcare ///
age agesq female lesshs univ ptemp2 unemp inczscore selfemp year ///
migstock_wb_lag1 mignet_un_lag1 migstock_wb_d5_lag1 migstock_wb_d1_lag1 ///
gdp_wb_lag1 ginid_solt_lag1 cntryyear country iso_country

*PI added this to delete files

erase "DATA_issp1985.dta"
erase "DATA_issp1990.dta"
erase "DATA_issp1996.dta"
erase "DATA_issp2006.dta"
erase "DATA_issp2016.dta"

*Table 1
		factor govjobs govunemp govincdiff govretire govhcare, pcf
		predict welsupp_all
		
// PI rescale the DV to 0.48 to fit with observed variable scales
replace welsupp_all = welsupp_all*0.48
/*
		pwcorr welsupp_all welsupp_later
		alpha govjobs govunemp govincdiff govretire govhous 
		
	*** cfa, mgcfa
		set matsize 5000
		sem (Welsupp_all -> govjobs govunemp govincdiff govretire govhcare), latent(Welsupp_all) ///
		mean(Welsupp_all@0) group(cntryyear) ginvariant(none) stand
		estat ginvariant, showpclass(mcoef) class
	*** test for invariance across countries (but not time)
		en country, gen(nations)
		sem (Welsupp_all -> govjobs govunemp govincdiff govretire govhcare), latent(Welsupp_all) ///
		mean(Welsupp_all@0) group(nations) ginvariant(none) stand
		estat ginvariant, showpclass(mcoef) class
	*** test for invariance across time (but not countries)
		sem (Welsupp_all -> govjobs govunemp govincdiff govretire govhcare), latent(Welsupp_all) ///
		mean(Welsupp_all@0) group(year) ginvariant(none) stand
		estat ginvariant, showpclass(mcoef) class
*Table 2		
		sem (Welsupp_all -> govjobs govunemp govincdiff govretire govhcare), latent(Welsupp_all) stand
		estat gof, stat(all)
*/	
	***Marginal effects (preferred models from Figs 1 to 4 in Team report)
		global controls "age agesq female lesshs univ ptemp2 unemp selfemp inczscore i.year" 
		*migration stock
		qui: mixed welsupp_all migstock_wb_lag1 $controls i.iso_country || cntryyear:
		margins, dydx(migstock_wb_lag1) saving("t2m1", replace)

		* net migration measure 
		qui: mixed welsupp_all mignet_un_lag1 $controls i.iso_country || cntryyear: 
		margins, dydx(mignet_un_lag1) saving("t2m2", replace)

		*1-year change in migration stock
		qui: mixed welsupp_all migstock_wb_d1_lag1 $controls i.iso_country || cntryyear:
		margins, dydx(migstock_wb_d1_lag1) saving("t2m3", replace)

		*5-year change in migration stock
		qui: mixed welsupp_all migstock_wb_d5_lag1 $controls i.iso_country || cntryyear:
		margins, dydx(migstock_wb_d5_lag1) saving("t2m4", replace)


		
use t2m1, clear
append using t2m2
append using t2m3
append using t2m4
gen f = [_n]
gen factor = "Immigrant Stock" if f==1
replace factor = "Immigrant Flow, 1-year" if f==2
replace factor = "Immigrant Flow, 1-year" if f==3
replace factor = "Immigrant Flow, 5-year" if f==4
clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
gen id = "t2m1"
replace id = "t2m2" if f==2
replace id = "t2m3" if f==3
replace id = "t2m4" if f==4
// PI make net migration on a % equivalent scale
replace AME = AME*10 if f==2
replace lower = lower*10 if f==2
replace upper = upper*10 if f==2
// PI make a 1-point change over 5-years on a 1-year scale
replace AME = AME*5 if f==4
replace lower = lower*5 if f==4
replace upper = upper*5 if f==4
order factor AME lower upper id
keep factor AME lower upper id
save team2, replace

erase "t2m1.dta" 
erase "t2m2.dta"
erase "t2m3.dta"
erase "t2m4.dta"
erase "DATA_final.dta"
erase "cri_macro_2.dta"
}
*==============================================================================*
*==============================================================================*
*==============================================================================*


























 
 
 
 

// TEAM 5
*==============================================================================*
*==============================================================================*
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team5.dta"
  if _rc==0   {
	    display "Team 5 already exists, skipping to next code chunk"
	}
  else {
version 15
  // 2006 // 
use "ZA4700.dta" , clear
set more off
*Dependent variables
foreach var of varlist V25 V28 V30 V31 {
replace `var'=1 if `var'==1|`var'==2
replace `var'=0 if `var'==3|`var'==4
}
rename V25 jobs
rename V28 oldagecare
rename V30 unemployed
rename V31 reduceincomedifferences

foreach var of varlist V18 V22 V23 {
replace `var'=1 if `var'==1|`var'==2
replace `var'=0 if `var'==3|`var'==4|`var'==5
}
rename V18 should_health
rename V22 should_pensions
rename V23 should_unemployment


*Independent variables
replace sex=0 if sex==1
replace sex=1 if sex==2
label values sex .

gen age2=age*age

gen education=1 if degree==0|degree==1|degree==2	//is 'above lowest' primary?
replace education=2 if degree==3
replace education=3 if degree==4|degree==5	//is 'above higher secondary' university?

gen employment=1 if wrkst==1
replace employment=2 if wrkst==2|wrkst==3	//is 'less than part-time' part-time?
replace employment=3 if wrkst==4|wrkst==6|wrkst==8
replace employment=4 if wrkst==5|wrkst==7|wrkst==9|wrkst==10
lab val employment employment

*Unique code for country-year (for merging)
gen year=2006
gen country=V3a
gen ID_merge=country+year

save "ISSP_2006_coded.dta" , replace

*** Prepare aggregate-level data ***
import excel "cri_macro.xlsx", sheet("cri_macro") firstrow clear

keep iso_country year wdi_unempilo socx_oecd migstock_oecd migstock_un mignet_un gdp_oecd
replace socx_oecd="." if socx_oecd==".."
destring wdi_unempilo socx_oecd migstock_oecd migstock_un mignet_un gdp_oecd , replace

keep if year==2006
rename iso_country country
gen ID_merge=country+year

*Save
save "Aggregate_coded_2006", replace

*** Create final data set ***
*Append coded data sets
use "ISSP_2006_coded.dta" , clear
*Merge aggregate-level data
merge m:m ID_merge using "Aggregate_coded_2006.dta"


****Refugees
gen refugee=22164/20827600 if country==36	//Australia
gen refugee_3=63476/20127400 if country==36

replace refugee=1376/16319792 if country==152	//Chile
replace refugee_3=569/15799542 if country==152

replace refugee=2443/4440000 if country==191	//Croatia
replace refugee_3=4387/4440000 if country==191

replace refugee=1887/10238905 if country==203	//Czech Republic
replace refugee_3=1516/10193998 if country==203

replace refugee=23401/5493621 if country==208	//Denmark
replace refugee_3=44374/5419432 if country==208

replace refugee=11827/5266268 if country==246	//Finland
replace refugee_3=10843/5213014 if country==246

replace refugee=605406/82376451 if country==276	//Germany
replace refugee_3=960395/82534176 if country==276

replace refugee=8075/10071370 if country==348	//Hungary
replace refugee_3=7023/10129552 if country==348

replace refugee=1156/7180100 if country==376	//Israel
replace refugee_3=574/6809000 if country==376

replace refugee=1844/128000000 if country==392	//Japan
replace refugee_3=2266/128000000 if country==392

replace refugee=69/48184561 if country==410	//South Korea
replace refugee_3=17/47644736 if country==410

replace refugee=29/2200325 if country==428	//Latvia
replace refugee_3=11/2263122 if country==428

replace refugee=4906/4184600 if country==554	//New Zealand
replace refugee_3=5807/4027200 if country==554

replace refugee=43336/4660677 if country==578	//Norway
replace refugee_3=46109/4564855 if country==578

replace refugee=254/2006868 if country==705	//Slovenia
replace refugee_3=2069/1995733 if country==705

replace refugee=35086/49364582 if country==710	//South Africa
replace refugee_3=26558/47648727 if country==710

replace refugee=5147/45226803 if country==724	//Spain
replace refugee_3=5686/42921895 if country==724

replace refugee=79913/9080505 if country==752	//Sweden
replace refugee_3=112167/8958229 if country==752

replace refugee=45653/7551117 if country==756	//Switzerland
replace refugee_3=67678/7389625 if country==756

replace refugee=301556/60846820 if country==826	//Great-Britain
replace refugee_3=276522/59647577 if country==826

replace refugee=843498/298000000 if country==840	//US
replace refugee_3=452548/290000000 if country==840

replace refugee=151827/32570505 if country==124	//Canada
replace refugee_3=133094/31676000 if country==124

replace refugee=145996/63621381 if country==250	//Frankrijk
replace refugee_3=130838/62244886 if country==250

replace refugee=12774/38125760 if country==616	//Poland 
replace refugee_3=4604/38165440 if country==616

replace refugee=7917/4273591 if country==620	//Portugal
replace refugee_3=5971/3996521 if country==620

replace refugee=7917/4273591 if country==372	//Ireland
replace refugee_3=5971/3996521 if country==372

replace refugee=100574/16346101 if country==528	//Netherlands
replace refugee_3=140886/16225302 if country==528

replace refugee=125/3331043 if country==858	//Uruguay
replace refugee_3=91/3325637 if country==858

replace refugee=refugee*100
replace refugee_3=refugee_3*100

*percent change net change/divided by net amount = % change
gen refugee_change=((refugee-refugee_3)/refugee_3)*100


****Migration
*OECD migration data: https://data.oecd.org/migration/stocks-of-foreign-born-population-in-oecd-countries.htm

gen migration=.
gen migration_3=.

replace migration= 4877090/20827600 if country==36	//Australia 2006
replace migration_3= 4534510/20127400 if country==36

replace migration=247365/16319792 if country==152	//Chile 2006
replace migration_3=184464/15799542 if country==152 //2002

replace migration_3=448477/10193998 if country==203 //2002

replace migration=378665/5493621 if country==208	//Denmark 2008
replace migration_3=343367/5419432 if country==208

replace migration=176612/5266268 if country==246	//Finland 2006
replace migration_3=152057/5213014 if country==246

replace migration=10371000/82376451 if country==276	//Germany 2006

replace migration=331493/10071370 if country==348	//Hungary 2006
replace migration_3=302750/10129552 if country==348

replace migration=1930000/7180100 if country==376	//Israel 2007
replace migration_3=1975000/6809000 if country==376

replace migration=879537/4184600 if country==554	//New Zealand 2006
replace migration_3=698625/4027200 if country==554

replace migration=380367/4660677 if country==578	//Norway 2006
replace migration_3=333855/4564855 if country==578

replace migration=5249993/45226803 if country==724	//Spain 2007
replace migration_3=3693806/42921895 if country==724

replace migration=1125790/9080505 if country==752	//Sweden 2006
replace migration_3=1053463/8958229 if country==752

replace migration=5757000/60846820 if country==826	//Great-Britain 2006


replace migration=35769603/298000000 if country==840	//US 2006
replace migration_3=33096150/290000000 if country==840

replace migration=6186950/32570505 if country==124	//Canada 2006
replace migration_3=5448480/31676000 if country==124 //2001

replace migration=6910060/63621381 if country==250	//Frankrijk 2006
replace migration_3=4306100/62244886 if country==250 //2000

replace migration_3=776185/38165440 if country==616 //2003

replace migration_3=651472/3996521 if country==620

replace migration=601732/4273591 if country==372	//Ireland 2006
replace migration_3=390034/3996521 if country==372

replace migration=1734722/16346101 if country==528	//Netherlands 2006
replace migration_3=1714155/16225302 if country==528

replace migration=migration*100
replace migration_3=migration_3*100

gen migration_change=((migration-migration_3)/migration_3)*100

************
**Analyses**
************


// PREFERRED MODELS - STOCK
qui melogit jobs i.sex age age2 i.education i.employment refugee socx_oecd wdi_unempilo migstock_un || country:
margins, dydx(migstock_un) saving("t5m1",replace)
margins, dydx(refugee) saving("t5m17",replace)
tab country if e(sample)==1
qui melogit unemployed i.sex age age2 i.education i.employment refugee socx_oecd wdi_unempilo migstock_un || country: 
margins, dydx(migstock_un) saving("t5m2",replace)
margins, dydx(refugee) saving("t5m18",replace)
tab country if e(sample)==1

qui melogit reduceincomedifferences i.sex age age2 i.education i.employment refugee socx_oecd wdi_unempilo migstock_un || country: 
margins, dydx(migstock_un) saving("t5m3",replace)
margins, dydx(refugee) saving("t5m19",replace)
tab country if e(sample)==1

qui melogit oldagecare i.sex age age2 i.education i.employment refugee socx_oecd wdi_unempilo migstock_un || country: 
margins, dydx(migstock_un) saving("t5m4",replace)
margins, dydx(refugee) saving("t5m20",replace)
tab country if e(sample)==1

// PREFERRED MODELS - CHANGE IN STOCK

qui melogit jobs i.sex age age2 i.education i.employment refugee_change socx_oecd wdi_unempilo migration_change || country: 
margins, dydx(migration_change) saving("t5m5",replace)
margins, dydx(refugee_change) saving("t5m21",replace)
tab country if e(sample)==1

qui melogit unemployed i.sex age age2 i.education i.employment refugee_change socx_oecd wdi_unempilo migration_change || country:
margins, dydx(migration_change) saving("t5m6",replace)
margins, dydx(refugee_change) saving("t5m22",replace)
tab country if e(sample)==1

qui melogit reduceincomedifferences i.sex age age2 i.education i.employment refugee_change socx_oecd wdi_unempilo migration_change || country: 
margins, dydx(migration_change) saving("t5m7",replace)
margins, dydx(refugee_change) saving("t5m23",replace)
tab country if e(sample)==1

qui melogit oldagecare i.sex age age2 i.education i.employment refugee_change socx_oecd wdi_unempilo migration_change || country:
margins, dydx(migration_change) saving("t5m8",replace)
margins, dydx(refugee_change) saving("t5m24",replace)
tab country if e(sample)==1

// 2016 //

use "ZA6900_v2-0-0.dta" , clear
set more off
*Dependent variables
foreach var of varlist v21 v24 v26 v27 {
replace `var'=1 if `var'==1|`var'==2
replace `var'=0 if `var'==3|`var'==4
replace `var'=. if `var'==8|`var'==9
}
rename v21 jobs
rename v24 oldagecare
rename v26 unemployed
rename v27 reduceincomedifferences

foreach var of varlist v14 v18 v19 {
replace `var'=. if `var'==0
replace `var'=1 if `var'==1|`var'==2
replace `var'=0 if `var'==3|`var'==4|`var'==5
replace `var'=. if `var'==8|`var'==9
}
rename v14 should_health
rename v18 should_pensions
rename v19 should_unemployment

*Independent variables
gen sex=0 if SEX==1
replace sex=1 if SEX==2

gen age=AGE
replace age=. if age==0|age==999

gen age2=age*age

gen education=1 if DEGREE==0|DEGREE==1|DEGREE==2
replace education=2 if DEGREE==3|DEGREE==4
replace education=3 if DEGREE==5|DEGREE==6

gen employment=1 if WORK==1
replace employment=2 if WORK==2
replace employment=3 if WORK==3
lab def employment 1 "Paid work" 2 "Currently no paid work" 3 "Never had paid work"
lab val employment employment

*Year variable (for merging)
gen year=2016


*Unique code for country-year (for merging)
gen ID_merge=country+year

save "ISSP_2016_coded.dta" , replace

*** Prepare aggregate-level data ***
import excel "cri_macro.xlsx", sheet("cri_macro") firstrow clear

keep iso_country year wdi_unempilo socx_oecd migstock_oecd migstock_un mignet_un gdp_oecd
replace socx_oecd="." if socx_oecd==".."
destring wdi_unempilo socx_oecd migstock_oecd migstock_un mignet_un gdp_oecd , replace

keep if year==2016
rename iso_country country
gen ID_merge=country+year

*Save
save "Aggregate_coded_2016", replace

*** Create final data set ***
*Append coded data sets
use "ISSP_2016_coded.dta" , clear
*Merge aggregate-level data
merge m:m ID_merge using "Aggregate_coded_2016.dta"


***Select countries for use
keep if country==36|country==56|country==152|country==191|country==203	///
|country==208|country==246|country==276|country==826|country==348|country==352	///
|country==376|country==392|country==410|country==428|country==440|country==554	///
|country==578|country==703|country==705|country==724|country==752|country==756	///
|country==840|country==710

gen refugee=42188/24210809 if country==36	//Australia
gen refugee_3=34503/23145901 if country==36

replace refugee=42128/11372068 if country==56	//Belgium
replace refugee_3=29179/11209057 if country==56

replace refugee=1841/17909754 if country==152	//Chile
replace refugee_3=1773/17462982 if country==152

replace refugee=448/4125700 if country==191	//Croatia
replace refugee_3=726/4238389 if country==191

replace refugee=3644/10566332 if country==203	//Czech Republic
replace refugee_3=2979/10514272 if country==203

replace refugee=35593/5728010 if country==208	//Denmark
replace refugee_3=17185/5614932 if country==208

replace refugee=20714/5495303 if country==246	//Finland
replace refugee_3=11798/5495303 if country==246

replace refugee=669482/82348669 if country==276	//Germany
replace refugee_3=187576/80645605 if country==276

replace refugee=4748/9814023 if country==348	//Hungary
replace refugee_3=2440/9893082 if country==348

replace refugee=321/341284 if country==352	//Iceland
replace refugee_3=99/327386 if country==352

replace refugee=32946/8380100 if country==376	//Israel
replace refugee_3=48505/7910500 if country==376

replace refugee=2189/127000000 if country==392	//Japan
replace refugee_3=2560/127000000 if country==392

replace refugee=1463/51014947 if country==410	//South Korea
replace refugee_3=487/50199853 if country==410

replace refugee=349/1959537 if country==428	//Latvia
replace refugee_3=160/2012647 if country==428

replace refugee=1093/2868231 if country==440	//Lithuania
replace refugee_3=916/2957689 if country==440

replace refugee=1421/4693200 if country==554	//New Zealand
replace refugee_3=1403/4442100 if country==554

replace refugee=59522/5234519 if country==578	//Norway
replace refugee_3=46106/5079623 if country==578

replace refugee=990/5430798 if country==703	//Slovakia
replace refugee_3=703/5413393 if country==703

replace refugee=292/2063531 if country==705	//Slovenia
replace refugee_3=176/2057159 if country==705

replace refugee=88694/56717156 if country==710	//South Africa
replace refugee_3=112192/54539571 if country==710

replace refugee=12989/46484062 if country==724	//Spain
replace refugee_3=4637/46620045 if country==724

replace refugee=230164/9923085 if country==752	//Sweden
replace refugee_3=114175/9600379 if country==752

replace refugee=92995/8373338 if country==756	//Switzerland
replace refugee_3=62620/8089346 if country==756

replace refugee=118995/65595565 if country==826	//Great-Britain
replace refugee_3=126055/64128226 if country==826

replace refugee=272959/323000000 if country==840	//US
replace refugee_3=263662/323000000 if country==840

replace refugee=refugee*100
replace refugee_3=refugee_3*100

gen refugee_change = ((refugee-refugee_3)/refugee_3)*100

*Migration

gen migration=.
gen migration_3=.


replace migration=6710540/24210809 if country==36	//Australia 2016
replace migration_3=6209500/23145901 if country==36

replace migration=1849287/11372068 if country==56	//Belgium 2017 /2016
replace migration_3=1775561/11209057 if country==56 

replace migration=465319/17909754 if country==152	//Chile 2016 / 2015
replace migration_3=415540/17462982 if country==152

replace migration=540503/5728010 if country==208	//Denmark 2016
replace migration_3=456386/5614932 if country==208

replace migration=337162/5495303 if country==246	//Finland 2016
replace migration_3=285461/5495303 if country==246

replace migration=11453000/82348669 if country==276	//Germany 2016
replace migration_3=10102000/80645605 if country==276

replace migration=504302/9814023 if country==348	//Hungary 2016
replace migration_3=424192/9893082 if country==348

replace migration=42020/341284 if country==352	//Iceland 2017 / 2016
replace migration_3=37230/327386 if country==352

replace migration=1817000/8380100 if country==376	//Israel 2015
replace migration_3=1850000/7910500 if country==376

replace migration=258889/1959537 if country==428	//Latvia 2016
replace migration_3=279227/2012647 if country==428

replace migration_3=1001772/4442100 if country==554

replace migration=772477/5234519 if country==578	//Norway 2016
replace migration_3=663870/5079623 if country==578

replace migration=181642/5430798 if country==703	//Slovakia 2016
replace migration_3=158164/5413393 if country==703

replace migration=341230/2063531 if country==705	//Slovenia 2015
replace migration_3=271816/2057159 if country==705

replace migration=5918341/46484062 if country==724	//Spain 2016
replace migration_3=6174740/46620045 if country==724

replace migration=1676264/9923085 if country==752	//Sweden 2016
replace migration_3=1473256/9600379 if country==752

replace migration=8988000/65595565 if country==826	//Great-Britain2016
replace migration_3=7860000/64128226 if country==826

replace migration=43289646/323000000 if country==840	//US 2016
replace migration_3=40738224/323000000 if country==840

replace migration=migration*100
replace migration_3=migration_3*100


gen migration_change = ((migration-migration_3)/migration_3)*100

sum migration_change

************
**Analyses**
************

*** Proportion refugees ***


*PREFERRED MODELS - STOCK
melogit jobs i.sex age age2 i.education i.employment refugee socx_oecd wdi_unempilo migstock_un || country:
margins, dydx(migstock_un) saving("t5m9",replace)
margins, dydx(refugee) saving("t5m25",replace)
tab country if e(sample)==1

melogit unemployed i.sex age age2 i.education i.employment refugee socx_oecd wdi_unempilo migstock_un || country: 
margins, dydx(migstock_un) saving("t5m10",replace)
margins, dydx(refugee) saving("t5m26",replace)
tab country if e(sample)==1

melogit reduceincomedifferences i.sex age age2 i.education i.employment refugee socx_oecd wdi_unempilo migstock_un || country: 
margins, dydx(migstock_un) saving("t5m11",replace)
margins, dydx(refugee) saving("t5m27",replace)
tab country if e(sample)==1

melogit oldagecare i.sex age age2 i.education i.employment refugee socx_oecd wdi_unempilo migstock_un || country: 
margins, dydx(migstock_un) saving("t5m12",replace)
margins, dydx(refugee) saving("t5m28",replace)
tab country if e(sample)==1

*PREFERRED MODELS - STOCK CHANGE
melogit jobs i.sex age age2 i.education i.employment refugee_change socx_oecd wdi_unempilo migration_change || country: 
margins, dydx(migration_change) saving("t5m13",replace)
margins, dydx(refugee_change) saving("t5m29",replace)
tab country if e(sample)==1

melogit unemployed i.sex age age2 i.education i.employment refugee_change socx_oecd wdi_unempilo migration_change || country:
margins, dydx(migration_change) saving("t5m14",replace)
margins, dydx(refugee_change) saving("t5m30",replace)
tab country if e(sample)==1

melogit reduceincomedifferences i.sex age age2 i.education i.employment refugee_change socx_oecd wdi_unempilo migration_change || country: 
margins, dydx(migration_change) saving("t5m15",replace)
margins, dydx(refugee_change) saving("t5m31",replace)
tab country if e(sample)==1

melogit oldagecare i.sex age age2 i.education i.employment refugee_change socx_oecd wdi_unempilo migration_change || country:
margins, dydx(migration_change) saving("t5m16",replace)
margins, dydx(refugee_change) saving("t5m32",replace)
tab country if e(sample)==1

use t5m1, clear
foreach i of numlist 2/32{
append using t5m`i'
}
gen f = [_n]
gen factor = .

clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
gen id = "t5m1"
foreach i of numlist 2/32{
replace id = "t5m`i'" if f==`i'
}

*they measured 3 year change in flow
*we multiply by 3 to make it equivalent to a 1-point change per year
replace AME = AME*3 if f>4 & f<9
replace lower=lower*3 if f>4 & f<9
replace upper=upper*3 if f>4 & f<9
replace AME = AME*3 if f>12 & f<17
replace lower=lower*3 if f>12 & f<17
replace upper=upper*3 if f>12 & f<17
replace AME = AME*3 if f>20 & f<25
replace lower=lower*3 if f>20 & f<25
replace upper=upper*3 if f>20 & f<25
replace AME = AME*3 if f>28
replace lower=lower*3 if f>28
replace upper=upper*3 if f>28

order factor AME lower upper id
keep factor AME lower upper id

foreach i of numlist 1/32{
erase "t5m`i'.dta"
}
erase "Aggregate_coded_2016.dta"
erase "ISSP_2016_coded.dta"
erase "Aggregate_coded_2006.dta"
erase "ISSP_2006_coded.dta"

save team5, replace
}
*==============================================================================*
*==============================================================================*
*==============================================================================*




































// TEAM 6
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*
capture confirm file "team6.dta"
  if _rc==0  {
	    display "Team 6 already exists, skipping to next code chunk"
}
else {
version 15
*************************************************************
			* Wave 2006  data preparation*
*************************************************************

use "ZA4700.dta",clear
rename (V28 V30 V31 V25) (oldagecare unemployed reduce jobs)


foreach var of varlist  oldagecare unemployed reduce jobs {
clonevar `var'_bi=`var'
recode  `var'_bi 1 2=1 3 4=0 8 9=.
recode `var' 8 9=. 1=4 2=3 3=2 4=1
}
label define ordcode 4"affimative answer" 1"no affirmative answer"
label value oldagecare  ordcode
label value unemployed ordcode
label value reduce ordcode
label value jobs ordcode 

recode sex 2=1 1=0
label define fem 1"Female" 0"Male" 
label value  sex fem


recode degree 0 1=0 2 3 =1   4 5=2
label define degree2 0"lower" 1"secondary" 2"higher"
label value degree degree2

rename wrkst employment
recode employment ///	
		1=1 ///
		2 3=2 /// 
		5=3 ///
		4 6 7 8 9 10 =4  
label define employment 1"full time"  2"part time" 3"active unemployed" 4"not active"
label values employment employment

gen year =2006
rename V2 id
rename V3a country 

keep oldagecare unemployed reduce jobs oldagecare_bi unemployed_bi reduce_bi jobs_bi  sex degree age employment  id year country
order country year id
sort country id

save "ZA4700.dta_clean" , replace


*************************************************************
		* wave 1996 preparation *
*************************************************************
clear

use "ZA2900.dta"

rename (v39 v41 v42 v36) (oldagecare unemployed reduce jobs)

foreach var of varlist  oldagecare unemployed reduce jobs {
clonevar `var'_bi=`var'
recode  `var'_bi 1 2=1 3 4=0 8 9=.
recode `var' 8 9=. 1=4 2=3 3=2 4=1
}
label define ordcode 4"affimative answer" 1"no affirmative answer"
label value oldagecare  ordcode
label value unemployed ordcode
label value reduce ordcode
label value jobs ordcode 


rename v200 sex
recode sex 2=1 1=0
label define fem 1"Female" 0"Male" 
label value  sex fem

rename v201 age

rename v205 degree
recode degree 1 2 3=0 4 5 =1   6 7=2
label define degree2 0"lower" 1"secondary" 2"higher"
label value degree degree2

rename v206 wrkst
rename wrkst employment
recode employment ///	
		1=1 ///
		2 3=2 /// 
		5=3 ///
		4 6 7 8 9 10 =4  
label define employment 1"full time"  2"part time" 3"active unemployed" 4"not active"
label value employment employment


gen year =1996
rename v2 id
rename v3 country

*country coding differes between the waves. 
recode country 1 = 36  2 3=276 4=826 6=840 8=348 9=. 10=372 11=578 ///
12=578 13=752 14=203 15=705 16=616 17=. 18=643 19=554 20=124 21=608 ///
22 23=376 24=392 25=724 26=428  27=250 28=. 30=756 

label define country2 ///
32 "Argentina" ///
36 "AU-Australia"    /// 
40 "Austria"     ///
56 "Belgium" ///
76 "Brazil" ///
100 "Bulgaria" ///
124 "CA-Canada " ///
152 "CL-Chile" ///
158 "TW-Taiwan" ///
170 "Colombia" ///
191 "HR-Croatia" ///
196 "Cyprus" ///
203 "CZ-Czech Republic" ///
208 "DK-Denmark" ///
214 "DO-Dominican Republic" ///
233 "Estonia" ///
246 "FI-Finland" ///
250 "FR-France" ///
268 "Georgia" ///
276 "DE-Germany" ///
300 "Greece" ///
348 "HU-Hungary" ///
352 "Iceland" ///
356 "India" ///
372 "IE-Ireland" ///
376 "IL-Israel" ///
380 "Italy" ///
392 "JP-Japan" ///
410 "KR-South Korea" ///
428 "LV-Latvia" ///
440 "Lithuania" ///
484 "Mexico" ///
528 "NL-Netherlands" ///
554 "NZ-New Zealand" ///
578 "NO-Norway" ///
608 "PH-Philippines" ///
616 "PL-Poland" ///
620 "PT-Portugal" ///
643 "RU-Russia" ///
703 "Slovakia" ///
705 "SI-Slovenia" ///
710 "ZA-South Africa" ///
724 "ES-Spain" ///
740 "Suriname" ///
752 "SE-Sweden" ///
756 "CH-Switzerland" ///
764  "Thailand" ///
792 "Turkey " ///
826 "GB-Great Britain" ///
840 "US-United States" ///
858 "UY-Uruguay" ///
862 "VE-Venezuela"
label value country country2

keep oldagecare unemployed reduce jobs oldagecare_bi unemployed_bi reduce_bi jobs_bi  sex degree age employment  id year country
sort id year 

save "ZA2900.dta_clean" , replace

***********************************
		* 2016 *
***********************************

clear 

use "ZA6900_v2-0-0.dta"

rename (v24 v26 v27 v21) (oldagecare unemployed reduce jobs)

foreach var of varlist  oldagecare unemployed reduce jobs {
clonevar `var'_bi=`var'
recode  `var'_bi 1 2=1 3 4=0 8 9=.
recode `var' 8 9=. 1=4 2=3 3=2 4=1
}
label define ordcode 4"affimative answer" 1"no affirmative answer"
label value oldagecare  ordcode
label value unemployed ordcode
label value reduce ordcode
label value jobs ordcode 

rename SEX sex
recode sex 2=1 1=0 9=.
label define fem 1"Female" 0"Male" 
label value  sex fem

rename AGE age

rename DEGREE degree                             // Kontrolle
recode degree 0 1 =0 2 3 =1   4 5 6=2 9=.
label define degree2 0"lower" 1"secondary" 2"higher"
label value degree degree2

recode WRKHRS 99 98=.
recode MAINSTAT 99 9=.
gen employment =.
replace employment =1 if MAINSTAT == 1 & WRKHRS >=38 & WRKHRS <.	
replace employment =2 if MAINSTAT == 1 & WRKHRS <=38 & WRKHRS >=1
replace employment =3 if MAINSTAT == 2 
replace employment =4 if MAINSTAT != 1 &  MAINSTAT != 2 &  MAINSTAT != .

label define employment 1"full time"  2"part time" 3"active unemployed" 4"not active", modify
label value employment employment

gen year =2016
rename v2 id
label define country2 ///
32 "Argentina" ///
36 "AU-Australia"    /// 
40 "Austria"     ///
56 "Belgium" ///
76 "Brazil" ///
100 "Bulgaria" ///
124 "CA-Canada " ///
152 "CL-Chile" ///
158 "TW-Taiwan" ///
170 "Colombia" ///
191 "HR-Croatia" ///
196 "Cyprus" ///
203 "CZ-Czech Republic" ///
208 "DK-Denmark" ///
214 "DO-Dominican Republic" ///
233 "Estonia" ///
246 "FI-Finland" ///
250 "FR-France" ///
268 "Georgia" ///
276 "DE-Germany" ///
300 "Greece" ///
348 "HU-Hungary" ///
352 "Iceland" ///
356 "India" ///
372 "IE-Ireland" ///
376 "IL-Israel" ///
380 "Italy" ///
392 "JP-Japan" ///
410 "KR-South Korea" ///
428 "LV-Latvia" ///
440 "Lithuania" ///
484 "Mexico" ///
528 "NL-Netherlands" ///
554 "NZ-New Zealand" ///
578 "NO-Norway" ///
608 "PH-Philippines" ///
616 "PL-Poland" ///
620 "PT-Portugal" ///
643 "RU-Russia" ///
703 "Slovakia" ///
705 "SI-Slovenia" ///
710 "ZA-South Africa" ///
724 "ES-Spain" ///
740 "Suriname" ///
752 "SE-Sweden" ///
756 "CH-Switzerland" ///
764  "Thailand" ///
792 "Turkey " ///
826 "GB-Great Britain" ///
840 "US-United States" ///
858 "UY-Uruguay" ///
862 "VE-Venezuela"
label value country country2

keep oldagecare unemployed reduce jobs oldagecare_bi unemployed_bi reduce_bi jobs_bi  sex degree age  id year country employment
sort id year 

save "ZA6900_v2-0-0.dta_clean" , replace


***********************************
		* macro data*
***********************************

clear 
use "cri_macro.dta"

gen country2=iso_country

label define country2 ///
32 "Argentina" ///
36 "AU-Australia"    /// 
40 "Austria"     ///
56 "Belgium" ///
76 "Brazil" ///
100 "Bulgaria" ///
124 "CA-Canada " ///
152 "CL-Chile" ///
158 "TW-Taiwan" ///
170 "Colombia" ///
191 "HR-Croatia" ///
196 "Cyprus" ///
203 "CZ-Czech Republic" ///
208 "DK-Denmark" ///
214 "DO-Dominican Republic" ///
233 "Estonia" ///
246 "FI-Finland" ///
250 "FR-France" ///
268 "Georgia" ///
276 "DE-Germany" ///
300 "Greece" ///
348 "HU-Hungary" ///
352 "Iceland" ///
356 "India" ///
372 "IE-Ireland" ///
376 "IL-Israel" ///
380 "Italy" ///
392 "JP-Japan" ///
410 "KR-South Korea" ///
428 "LV-Latvia" ///
440 "Lithuania" ///
484 "Mexico" ///
528 "NL-Netherlands" ///
554 "NZ-New Zealand" ///
578 "NO-Norway" ///
608 "PH-Philippines" ///
616 "PL-Poland" ///
620 "PT-Portugal" ///
643 "RU-Russia" ///
703 "Slovakia" ///
705 "SI-Slovenia" ///
710 "ZA-South Africa" ///
724 "ES-Spain" ///
740 "Suriname" ///
752 "SE-Sweden" ///
756 "CH-Switzerland" ///
764  "Thailand" ///
792 "Turkey " ///
826 "GB-Great Britain" ///
840 "US-United States" ///
858 "UY-Uruguay" ///
862 "VE-Venezuela"
label value country2 country2

drop country
rename country2 country

sort country year 

clonevar  socx =socx_oecd 
clonevar netmigpct= mignet_un // relative measure - change in mig stock
clonevar foreignpct= migstock_oecd // absolute measure immigration stock
clonevar unemprate=wdi_unempilo
clonevar gdp=gdp_oecd 

destring socx netmigpct migstock_wb migstock_un wdi_empprilo foreignpct unemprate gdp , force replace 


* linear interpolation of stock from other stock variable
ipolate foreignpct migstock_un, gen(foreignpct_i) epolate
by country: ipolate socx year, gen(socx_i) epolate

* replace net migration rate of 2016 with value from 2015
gen netmigpct_i = netmigpct
levelsof country, local(c)
foreach num of numlist `c' {
qui sum netmigpct_i if country == `num' & year == 2015
replace netmigpct_i = r(mean) if country == `num' & year == 2016
}

keep if year == 2016 | year==2006 | year == 1996

save "cri_macro_clean.dta", replace

***********************************
		* Merge/append *
***********************************

clear 
use "ZA4700.dta_clean"

append using "ZA2900.dta_clean"
append using "ZA6900_v2-0-0.dta_clean"

sort country year
save "ZA2900+4700+6900.dta" , replace

use "ZA2900+4700+6900.dta"

merge m:1 country year using "cri_macro_clean.dta"

keep if _merge ==3

tab country year


keep if country ==    36 | country == 124 | country == 208 | country == 246 | country == 250 ///
					| country == 276 | country == 826 | country == 372  | country == 392 | country == 554 ///
					| country == 578 | country == 724 | country == 752 | country == 756 | country == 840

drop _merge

save "replication_extension_workfile.dta",replace

erase "ZA4700.dta_clean"
erase "ZA2900.dta_clean"
erase "cri_macro_clean.dta"
erase "ZA6900_v2-0-0.dta_clean"
erase "ZA2900+4700+6900.dta"

**************************
* Analysis * 
**************************
clear 
use "replication_extension_workfile.dta"
mark 	nmiss
markout nmiss  oldagecare unemployed reduce jobs unemprate foreignpct_i netmigpct_i employment gdp socx_i sex degree  age id year country			
drop if nmiss==0

foreach var of varlist gdp unemprate socx_i netmigpct_i foreignpct_i {
	bys country: egen `var'_m = mean(`var')
	gen `var'_dm = `var'-`var'_m
}
local i=1
foreach ivar of varlist foreignpct_i netmigpct_i  {
	foreach dvar of varlist jobs unemployed reduce oldagecare {
			qui ologit `dvar' i.sex ib1.degree i.employment c.age##c.age ///
				gdp unemprate socx_i ///
				`ivar' ///
				i.country i.year, vce(cluster country)
				margins , dydx(`ivar') predict(xb) saving ("t6m`i'",replace)
				loc i=`i'+1
	}
} 	
use t6m1,clear
foreach x of numlist 2/8{
	append using t6m`x'
}
gen f = [_n]
gen factor = "Immigrant Stock"
replace factor = "Immigrant Flow, 1-year" if f>4

clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub

*PI fix
replace AME=AME*10 if f>4
replace lower= lower*10 if f>4
replace upper= upper*10 if f>4


gen id = "t6m1"
foreach i of numlist 2/8{
replace id = "t6m`i'" if f==`i'
}
order factor AME lower upper id
keep factor AME lower upper id
save team6, replace
foreach i of numlist 1/8{
	erase "t6m`i'.dta"
}
erase "replication_extension_workfile.dta"
}
*==============================================================================*
*==============================================================================*
*==============================================================================*




























// TEAM 7
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team7.dta"
	if _rc==0 {
		display "Team 7 already exists, skipping to next code chunk"
	}
else {
version 15
*ISSP 1985
use ZA1490.dta, clear

gen iso=.
replace iso=36 if V3==1
replace iso=276.1 if V3==2
replace iso=826.1 if V3==3
replace iso=840 if V3==4
replace iso=40 if V3==5
replace iso=380 if V3==8

label define iso 36 "Australia" 276 "Germany West & East" 826 "Great Britain" ///
	840 "USA" 348 "Hungary" 380 "Italy" 372 "Ireland" 578 "Norway" 752 "Sweden" 	///
	203 "Czech Republic" 705 "Slovenia" 616 "Poland"	///
	100 "Bulgaria" 643 "Russia" 554 "New Zealand" 124 "Canada" 608 "Philippines" ///
	376 "Israel Jews & Arabs" 392 "Japan" 724 "Spain" ///
	428 "Latvia" 250 "France" 196 "Cyprus" 756 "Switzerland" 40 "Austria", replace
	
label values iso iso

gen year=.
replace year=1985 if V1==1490

*keep variables of interest
keep V1 V2 V3 V141 iso year ///
	V101 V102 V103 V104 V105 V106 V107  ///cntrys respon social policy
	V132 V133 ///religion
	V108 V109 V110 V111 V112 V113 V114 ///occupation
	V115 V116 V117 V118 V119 V120 V121 V122 V123	///
	V126 V127 V128 V129 V130 V131 V134	///
	V139	///
	V82 V83 V84 V85 V86 V87 V88 V89	//govt spend
	
ds iso year, not
foreach var of varlist `r(varlist)'{
	rename `var' issp1985`var'
}

sort iso year
save ISSP1985.dta, replace


*ISSP 1990
use ZA1950.dta, clear

gen iso=.
replace iso=36 if v3==1
replace iso=276.1 if v3==2
replace iso=276.2 if v3==3
replace iso=826.1 if v3==4
replace iso=826.2 if v3==5
replace iso=840 if v3==6
replace iso=348 if v3==7
replace iso=380 if v3==8
replace iso=372 if v3==9
replace iso=578 if v3==10
replace iso=376 if v3==11

label define iso 36 "Australia" 276 "Germany West & East" 826 "Great Britain" ///
	840 "USA" 348 "Hungary" 380 "Italy" 372 "Ireland" 578 "Norway" 752 "Sweden" 	///
	203 "Czech Republic" 705 "Slovenia" 616 "Poland"	///
	100 "Bulgaria" 643 "Russia" 554 "New Zealand" 124 "Canada" 608 "Philippines" ///
	376 "Israel Jews & Arabs" 392 "Japan" 724 "Spain" ///
	428 "Latvia" 250 "France" 196 "Cyprus" 756 "Switzerland" 40 "Austria"	///
	, replace
	
label values iso iso

gen year=.
replace year=1990 if v1==1950


*keep variables of interest
keep  v1 v2 v3 iso year v114	///
	 v33 v34 v35 v36 v37	/// govt spend
	 v49 v50 v51 v52 v53 v54 v55 v56 v57 /// gov resp
	 v59 v60 v61	///
	  v63 v64 v65 v66 v67 v68 v69 v70 v71 v72 ///
	  v73 v74 v75 v76 v78 v79 v80 v81 v87 v88 v89 ///
	  v90 v98 v101 v102 v103 v104 v113 v135 v142	///
	   v77 v82 v85 v86 v105
	   
ds iso year, not
foreach var of varlist `r(varlist)'{
	rename `var' issp1990`var'
}

sort iso year
save ISSP1990.dta, replace

*ISSP 1996
use ZA2900.dta, clear

gen iso=.
replace iso=36 if v3==1
replace iso=276.1 if v3==2
replace iso=276.2 if v3==3
replace iso=826.1 if v3==4
replace iso=840 if v3==6
replace iso=348 if v3==8
replace iso=380 if v3==9
replace iso=372 if v3==10
replace iso=578 if v3==12
replace iso=752 if v3==13
replace iso=203 if v3==14
replace iso=705 if v3==15
replace iso=616 if v3==16
replace iso=100 if v3==17
replace iso=643 if v3==18
replace iso=554 if v3==19
replace iso=124 if v3==20
replace iso=608 if v3==21
replace iso=376.1 if v3==22
replace iso=376.2 if v3==23
replace iso=392 if v3==24
replace iso=724 if v3==25
replace iso=428 if v3==26
replace iso=250 if v3==27
replace iso=196 if v3==28
replace iso=756 if v3==30


label define iso 36 "Australia" 276 "Germany West & East" 826 "Great Britain" ///
	840 "USA" 348 "Hungary" 380 "Italy" 372 "Ireland" 578 "Norway" 752 "Sweden" 	///
	203 "Czech Republic" 705 "Slovenia" 616 "Poland"	///
	100 "Bulgaria" 643 "Russia" 554 "New Zealand" 124 "Canada" 608 "Philippines" ///
	376 "Israel Jews & Arabs" 392 "Japan" 724 "Spain" ///
	428 "Latvia" 250 "France" 196 "Cyprus" 756 "Switzerland" 40 "Austria"	///
	203 "Czech Republic" 100 "Bulgaria" 643 "Russian Federation" 608 "Philippines", replace
	
label values iso iso

gen year=.
replace year=1996 if v1==2900


keep  v1 v2 v3  v325 iso year ///
	 v36 v37 v38 v39 v40 v41 v42 v43 v44 v45	///
	 v200 v201 v202 v203 v204 v205 v206	///
	 v208 v209	///
	 v212 v213 v214 v215 v216 v217 v218	///
	 v219 v220 v221 v222 v223 v273 v274 v275	///
	 v25 v26 v27 v28 v29 v30 v31 v32 v248 v324
	 
	 
ds iso year, not
foreach var of varlist `r(varlist)'{
	rename `var' issp1996`var'
}

sort iso year
save ISSP1996.dta, replace

*ISSP 2006

use ZA4700.dta, clear

gen iso=.
replace iso=V3

label define iso 36 "Australia" 276 "Germany West & East" 826 "Great Britain" ///
	840 "USA" 348 "Hungary" 380 "Italy" 372 "Ireland" 578 "Norway" 752 "Sweden" 	///
	203 "Czech Republic" 705 "Slovenia" 616 "Poland"	///
	100 "Bulgaria" 643 "Russia" 554 "New Zealand" 124 "Canada" 608 "Philippines" ///
	376 "Israel Jews & Arabs" 392 "Japan" 724 "Spain" ///
	428 "Latvia" 250 "France" 196 "Cyprus" 756 "Switzerland" 40 "Austria"	///
	203 "Czech Republic" 100 "Bulgaria" 643 "Russian Federation" 608 "Philippines"	///
	152 "Chile" 158 "Taiwan" 191 "Croatia" 208 "Denmark" 214 "Dominican Republic" ///
	246 "Finland" 410 "South Korea" 528 "Netherlands" 620 "Portugal" 710 "South Africa" ///
	858 "Urguguay" 862 "Venezuela" , replace
	
label values iso iso

gen year=.
replace year=2006 if V1==4700

keep  V1 version V2 V3 V3a iso year  weight ///
	V25 V26 V27 V28 V29 V30 V31 V32 V33 V34	///
	V17 V18 V19 V20 V21 V22 V23 V24	/// govt spending
	sex age marital  educyrs degree ///
	wrkst wrkhrs ISCO88 wrksup wrktype nemploy union hompop hhcycle PARTY_LR	///
	VOTE_LE  relig religgrp attend topbot urbrural ethnic
	
ds iso year, not
foreach var of varlist `r(varlist)'{
	rename `var' issp2006`var'
}

sort iso year
save ISSP2006.dta, replace


*ISSP 2016
use ZA6900_v2-0-0.dta, clear

gen iso=.
replace iso=c_sample
replace iso=56.1 if c_sample==5601
replace iso=56.2 if c_sample==5602
replace iso=56.3 if c_sample==5603
replace iso=276.1 if c_sample==27601
replace iso=276.2 if c_sample==27602
replace iso=376.1 if c_sample==37601
replace iso=376.2 if c_sample==37602
replace iso=826.1 if c_sample==82601

label define iso 36 "Australia" 276 "Germany West & East" 826 "Great Britain" ///
	840 "USA" 348 "Hungary" 380 "Italy" 372 "Ireland" 578 "Norway" 752 "Sweden" 	///
	203 "Czech Republic" 705 "Slovenia" 616 "Poland"	///
	100 "Bulgaria" 643 "Russia" 554 "New Zealand" 124 "Canada" 608 "Philippines" ///
	376 "Israel Jews & Arabs" 392 "Japan" 724 "Spain" ///
	428 "Latvia" 250 "France" 196 "Cyprus" 756 "Switzerland" 40 "Austria"	///
	203 "Czech Republic" 100 "Bulgaria" 643 "Russian Federation" 608 "Philippines"	///
	152 "Chile" 158 "Taiwan" 191 "Croatia" 208 "Denmark" 214 "Dominican Republic" ///
	246 "Finland" 410 "South Korea" 528 "Netherlands" 620 "Portugal" 710 "South Africa" ///
	858 "Urguguay" 862 "Venezuela" ///
	268 "Georgia" 352 "Iceland" 356 "India" 440 "Lithuania" 703 "Slovakia"	///
	740 "Surianme" 764 "Thailand" 792 "Turkey" 56 "Belgium" , replace
	
label values iso iso

gen year=.
replace year=2016 if studyno==6900

keep  studyno version doi CASEID country c_sample c_alphan iso year  WEIGHT ///
	v13 v14 v15 v16 v17 v18 v19 v20	/// gov spending
	v21 v22 v23 v24 v25 v26 v27 v28 v29 v30 v31 /// gov resp 
	v46 NZ_v46 v47 v48	///
	SEX BIRTH AGE DK_AGE EDUCYRS DEGREE ///
	WORK WRKHRS EMPREL NEMPLOY WRKSUP NSUP TYPORG1 TYPORG2 ISCO08 MAINSTAT	///
	UNION RELIGGRP ATTEND TOPBOT VOTE_LE PARTY_LR HOMPOP HHCHILDR HHTODD	///
	MARITAL F_BORN M_BORN URBRURAL
	
ds iso year, not
foreach var of varlist `r(varlist)'{
	rename `var' issp2016`var'
}

sort iso year
save ISSP2016.dta, replace

*****************************************************************************
*merge
use ISSP2016.dta, clear
merge m:m iso year using ISSP2006.dta	// ISSP 2016: 48720 cases, ISSP 2006: 48641 cases

drop _merge

merge m:m iso year using ISSP1996.dta	// ISSP 2016: 48720 cases, ISSP 2006: 48641 cases, ISSP 1996: 35313 cases
drop _merge

merge m:m iso year using ISSP1990.dta	// ISSP 2016: 48720 cases, ISSP 2006: 48641 cases, ISSP 1996: 35313 cases, ISSP 1990: 14897 cases
drop _merge

merge m:m iso year using ISSP1985.dta	// ISSP 2016: 48720 cases, ISSP 2006: 48641 cases, ISSP 1996: 35313 cases, ISSP 1990: 14897 cases, ISSp 1985: 7350 cases
drop _merge

gen double iso2=round(iso,0.1)
label values iso2 iso

drop iso
rename iso2 iso

save ISSP_merged.dta, replace
erase ISSP2016.dta
erase ISSP2006.dta
erase ISSP1996.dta
erase ISSP1990.dta
erase ISSP1985.dta
use ISSP_merged.dta, clear

*keep if country at least 2 times in issp

drop if iso==40  // Austria
drop if	issp2016country==56 // Belgium
drop if	iso==100  	//Bulgaria
drop if	iso==196  	//Cyprus
drop if	iso==214  	//Dominican Rep
drop if	iso==268  	//Georgia
drop if	iso==352  	//Iceland
drop if	iso==356  	//India
drop if	iso==440  	//Lithuania
drop if	iso==528  	//Netherlands
drop if	iso==620  	//Portugal
drop if	iso==703  	//Slovakia
drop if	iso==740  	//Suriname
drop if	iso==764  	//Thailand
drop if	iso==792 	//Turkey
drop if	iso==858 		//Uruguay

label var iso "Country ISO Code"

*Sex
gen sex=.
replace sex=issp2016SEX if year==2016
mvdecode sex, mv(9)
replace sex=issp2006sex if year==2006
replace sex=issp1996v200 if year==1996
replace sex=issp1990v59 if year==1990
replace sex=issp1985V118 if year==1985

replace sex=sex-1
label define sex 0 "Male" 1 "Female"
label values sex sex

label var sex "Female"

* age
gen age=.
replace age=issp2016AGE if year==2016
mvdecode age, mv(999)
replace age=issp2006age if year==2006
replace age=issp1996v201 if year==1996
replace age=issp1990v60 if year==1990
replace age=issp1985V117 if year==1985
replace age=0 if issp1985V117<=6 & year==1985
mvdecode age, mv(0=.a)

label var age "Age"

gen age_dk=.
replace age_dk=issp2016DK_AGE
label values age_dk DK_AGE

label var age_dk "Age DK"

gen age_it=.
replace age_it=issp1985V117 if issp1985V117<=6 & year==1985

label define ag_it 1 "18-24 years" 2 "25-34 years" 3 "35-44 years" 4 "45-54 years"	///
	5 "55-64 years" 6 "65-74 years"
label values age_it agit

label var age_it "Age IT"

*education
rename issp2016DEGREE degree2016
rename issp2006degree degree2006
rename issp1996v205 degree1996
rename issp1990v81 degree1990
rename issp1985V123 degree1985
tab1 degree*

gen educat=.
replace educat=0 if ((degree2016==0 | degree2016==1) & year==2016)	//2016
replace educat=0 if ((degree2006==0 | degree2006==1) & year==2006)	//2006
replace educat=0 if ((degree1996==1 | degree1996==2 | degree1996==3) & year==1996) //1996
replace educat=0 if year==1990 & (((degree1990==1 | degree1990==2 | degree1990==3) & iso==36) | /// australia 1990
		((degree1990==1 | degree1990==2) & (iso==276.1 | iso==276.2)) | /// Germany 1990
		((degree1990==1 | degree1990==2 | degree1990==3) & iso==348) | ///Hungary 1990
		((degree1990==1 | degree1990==2 | degree1990==3) & iso==372) | ///Ireland 1990
		((degree1990==3) & iso==578) |	///Norway 1990
		((degree1990==1 | degree1990==2) & iso==376) |	///Israel 1990
		((degree1990==1 | degree1990==3) & iso==380) |	///Italy 1990
		((degree1990==3) & iso==826.1) | ///GB 1990
		((degree1990==3) & iso==826.2) | ///GB Northern Ireland 1990
		((degree1990==1 | degree1990==2 | degree1990==3) & iso==840))  //USA 1990
replace educat=0 if year==1985 & (((degree1985==1 | degree1985==2) & iso==36) | ///Australia 1985
		((degree1985==1) & (iso==276.1 | iso==276.2)) | ///Germany 1985
		((degree1985==3) & iso==826.1) | ///GB 1985
		((degree1985==1 | degree1985==2)  & iso==840) | ///USA 1985
		((degree1985==1 | degree1985==2 | degree1985==3) & iso==380))  //Italy 1985

replace educat=1 if ((degree2016==2 | degree2016==3 | degree2016==4) & year==2016)	//2016
replace educat=1 if ((degree2006==2 | degree2006==3 | degree2006==4) & year==2006) //2006
replace educat=1 if ((degree1996==4 | degree1996==5 | degree1996==6) & year==1996)	//1996
replace educat=1 if year==1990 & ((iso==36 & (degree1990==4 | degree1990==5)) | ///Australia 1990
		((iso==276.1 | iso==276.2) & (degree1990>=3 & degree1990<=7)) |	///Germany 1990
		(iso==348 & (degree1990>=4 & degree1990<=6)) |	///Hungary 1990
		(iso==372 & (degree1990>=4 & degree1990<=6)) |	///Ireland 1990
		(iso==376 & (degree1990>=3 & degree1990<=5)) |	///Israel 1990
		(iso==380 & (degree1990==4 | degree1990==5)) |	///Italy 1990
		(iso==578 & (degree1990>=4 & degree1990<=7)) | 	///Norway 1990
		((iso==826.1 | iso==826.2) & (degree1990>=4 & degree1990<=7)) |	///GB & Northern Ireland 1990
		(iso==840 & (degree1990==4 | degree1990==5)))	//USA 1990
replace educat=1 if year==1985 & ((iso==36 & (degree1985>=3 & degree1985<=6)) | ///Australia 1985
		(iso==276.1 & (degree1985>=3 & degree1985<=6)) | ///Germany 1985
		(iso==380 & (degree1985>=4 & degree1985<=8)) |	///Italy 1985
		(iso==840 & (degree1985>=3 & degree1985<=4)) |	///USA 1985
		(iso==826.1 & (degree1985>=4 & degree1985<=7)))	//GB & Northern Ireland 1985
		
replace educat=2 if year==2016 & (degree2016==5 | degree2016==6)	//2016
replace educat=2 if year==2006 & (degree2006==5)		//2006
replace educat=2 if year==1996 & (degree1996==7)	//1996
replace educat=2 if year==1990 & ((iso==36 & degree1990==6) |	///Australia 1990
		((iso==276.1 | iso==276.2) & degree1990==8) |	///Germany1990
		(iso==348 & degree1990==7) |	///Hungary 1990
		(iso==372 & degree1990==7) | 	///ireland 1990
		(iso==376 & (degree1990==6 | degree1990==7)) | ///Israel 1990
		(iso==380 & degree1990==6) | ///Italy 1990
		(iso==578 & degree1990==8) | ///Norway 1990
		((iso==826.1 | iso==826.2) & degree1990==8) | ///GB & Northern Ireland 1990
		(iso==840 & (degree1990==6 | degree1990==7)))	//USA 1990
replace educat=2 if year==1985 & ((iso==36 & (degree1985==7 | degree1985==8)) | 	///Australia 1985
		(iso==276.1 & degree1985==7) |	///Germany 1985
		(iso==380 & degree1985==9) |	///Italy 1985
		(iso==840 & (degree1985==5 | degree1985==6)) | 	///USA1985
		(iso==826.1 & degree1985==8))	//GB NIR 1985
		

label define edu 0 "Primary or less" 1 "Secondary; more than primary, less than completed university degree"	///
		2 "University degree or more" 
label values  educat edu

label var educat "Education cat."

*marital
gen marital=.
replace marital=1 if (issp2016MARITAL==1 | issp2016MARITAL==2) & year==2016
replace marital=2 if issp2016MARITAL==3 & year==2016
replace marital=3 if issp2016MARITAL==4 & year==2016
replace marital=4 if issp2016MARITAL==5 & year==2016
replace marital=5 if issp2016MARITAL==6 & year==2016

replace marital=1 if issp2006marital==1 & year==2006
replace marital=2 if issp2006marital==4 & year==2006	
replace marital=3 if issp2006marital==3 & year==2006
replace marital=4 if issp2006marital==2 & year==2006	//apparently incorrect value labels 2=="widowed" --> no civil partnership in issp2006
replace marital=5 if issp2006marital==5 & year==2006

replace marital=1 if issp1996v202==1 & year==1996
replace marital=2 if issp1996v202==4 & year==1996
replace marital=3 if issp1996v202==3 & year==1996
replace marital=4 if issp1996v202==2 & year==1996
replace marital=5 if issp1996v202==5 & year==1996

replace marital=1 if issp1990v61==1 & year==1990
replace marital=2 if issp1990v61==4 & year==1990
replace marital=3 if issp1990v61==3 & year==1990
replace marital=4 if issp1990v61==2 & year==1990
replace marital=5 if issp1990v61==5 & year==1990

replace marital=1 if issp1985V120==1 & year==1985
replace marital=2 if issp1985V120==4 & year==1985
replace marital=3 if issp1985V120==3 & year==1985
replace marital=4 if issp1985V120==2 & year==1985
replace marital=5 if issp1985V120==5 & year==1985

label define marital 1 "Married/Civil partnership" 2 "Separated" 3 "Divorced" 4 "Widowed" 5 "Never married/in civil partnership"
label values marital marital

label var marital "Marital status"

*working status

gen wrkst=.

replace wrkst=2 if issp2016MAINSTAT==2 & year==2016
replace wrkst=1 if (issp2016MAINSTAT>=3 & issp2016MAINSTAT<=7) & year==2016
replace wrkst=3 if issp2016MAINSTAT==1 &  issp2016WRKHRS >=37 & issp2016WRKHRS<=96 & year==2016
replace wrkst=0 if issp2016WRKHRS<=37 & issp2016WRKHRS>=1 & issp2016MAINSTAT==1 & year==2016

replace wrkst=3 if issp2006wrkst==1 & year==2006
replace wrkst=1 if (issp2006wrkst==4 | (issp2006wrkst>=6 & issp2006wrkst<=10)) & year==2006
replace wrkst=2 if issp2006wrkst==5 & year==2006
replace wrkst=0 if (issp2006wrkst==2 | issp2006wrkst==3) & year==2006

replace wrkst=0 if (issp1996v206==2 | issp1996v206==3) & year==1996
replace wrkst=1 if (issp1996v206==4 | (issp1996v206>=6 & issp1996v206<=10)) & year==1996
replace wrkst=2 if issp1996v206==5 & year==1996
replace wrkst=3 if issp1996v206==1 & year==1996

replace wrkst=0 if (issp1990v63==2 | issp1990v63==3) & year==1990
replace wrkst=1 if (issp1990v63==4 | (issp1990v63>=6 & issp1990v63<=10)) & year==1990
replace wrkst=2 if issp1990v63==5 & year==1990
replace wrkst=3 if issp1990v63==1 & year==1990

replace wrkst=2 if issp1985V109==1 & year==1985
replace wrkst=0 if issp1985V109==2 & year==1985
replace wrkst=3 if issp1985V109==2 & issp1985V108>=37 & year==1985
replace wrkst=1 if issp1985V109==. & year==1985	//AUS: 55 cases "no answer" GER:40 cases "no answer"


label define wrkst 0 "Part time" 1 "Not active" 2 "Active unemployed" 3 "Full-time"
label values wrkst wrkst

label var wrkst "Labor force status"

*religion

gen attend=.
replace attend=0 if issp1985V133==5 & year==1985
replace attend=1 if issp1985V133==1 & year==1985
replace attend=2 if issp1985V133==2 & year==1985
replace attend=3 if issp1985V133==3 & year==1985
replace attend=4 if issp1985V133==4 & year==1985

replace attend=0 if issp1990v89==6 & year==1990
replace attend=1 if issp1990v89==1 & year==1990
replace attend=2 if (issp1990v89==2 | issp1990v89==3) & year==1990
replace attend=3 if issp1990v89==4 & year==1990
replace attend=4 if issp1990v89==5

replace attend=0 if issp1996v220==6 & year==1996
replace attend=1 if issp1996v220==1 & year==1996
replace attend=2 if (issp1996v220==2 | issp1996v220==3) & year==1996
replace attend=3 if issp1996v220==4 & year==1996
replace attend=4 if issp1996v220==5 & year==1996

replace attend=0 if issp2006attend==8 & year==2006
replace attend=1 if (issp2006attend==1 | issp2006attend==2) & year==2006
replace attend=2 if (issp2006attend==3 | issp2006attend==4) & year==2006
replace attend=3 if issp2006attend==5 & year==2006
replace attend=4 if (issp2006attend==6 | issp2006attend==7) & year==2006

replace attend=0 if issp2016ATTEND==8 & year==2016
replace attend=1 if (issp2016ATTEND==1 | issp2016ATTEND==2) & year==2016
replace attend=2 if (issp2016ATTEND==3 | issp2016ATTEND==4) & year==2016
replace attend=3 if issp2016ATTEND==5 & year==2016
replace attend=4 if (issp2016ATTEND==6 | issp2016ATTEND==7) & year==2016

label define attend 0 "Never" 1 "Once or more times a week" 2 "Once to 3 times a month" 3 "Several times a year"	///
	4 "Less frequently"
label values attend attend

label var attend "Attendance at religious services"

*size of household

gen size=.
replace size=1 if issp2016HOMPOP==1 & year==2016
replace size=2 if issp2016HOMPOP==2 & year==2016
replace size=3 if issp2016HOMPOP==3 & year==2016
replace size=4 if issp2016HOMPOP==4 & year==2016
replace size=5 if issp2016HOMPOP==5 & year==2016
replace size=6 if issp2016HOMPOP==6 & year==2016
replace size=7 if issp2016HOMPOP==7 & year==2016
replace size=8 if (issp2016HOMPOP>=8 & issp2016HOMPOP<=27) & year==2016

replace size=issp2006hompop if issp2006hompop<=8 & year==2006
replace size=8 if (issp2006hompop>=8 & issp2006hompop<=36) & year==2006

replace size=issp1996v273 if issp1996v273<=8 & year==1996
replace size=8 if (issp1996v273>=8 & issp1996v273<=18) & year==1996

replace size=issp1990v98 if issp1990v98<=8 & year==1990
replace size=8 if (issp1990v98>=8 & issp1990v98<=13) & year==1990

replace size=1 if issp1985V121==1 & year==1985 & iso==36
replace size=2 if (issp1985V121==2 | issp1985V121==7) & year==1985 & iso==36
replace size=3 if (issp1985V121==3 | issp1985V121==8 | issp1985V121==15) & year==1985 & iso==36
replace size=4 if (issp1985V121==4 | issp1985V121==9 | issp1985V121==16 | issp1985V121==23) & year==1985 & iso==36
replace size=5 if (issp1985V121==5 | issp1985V121==10 | issp1985V121==17 | issp1985V121==24 | issp1985V121==28) & year==1985 & iso==36
replace size=6 if (issp1985V121==6 | issp1985V121==11 | issp1985V121==18 | issp1985V121==25 | issp1985V121==29 | issp1985V121==31) & year==1985 & iso==36
replace size=7 if (issp1985V121==12 | issp1985V121==19 | issp1985V121==26 | issp1985V121==30) & year==1985 & iso==36
replace size=8 if (issp1985V121==13 | issp1985V121==14 | issp1985V121==20 | issp1985V121==21 | issp1985V121==22 | issp1985V121==27 | issp1985V121==32) & year==1985 & iso==36

replace size=issp1985V121 if issp1985V121<=8 & year==1985 & (iso==276.1 | iso==840)
replace size=8 if issp1985V121>=8 & issp1985V121<=10 & year==1985 & (iso==276.1 | iso==840)

label define size 1 "Single person household" 8 "8 or more persons"
label values size size
label var size "Size of household"

gen size_gb85=issp1985V121 if year==1985 & iso==826.1
label define size_gb85 1 "Single adult 60 and more years" 2 "Two adults both 60 and more years" 3 "Single adult 18-59 years" ///
	4 "Two adults 18-59 years" 5 "Youngest person 0-4 years" 6 "Youngest person 5-17 years" 7 "Three adults"
label values size_gb85 size_gb85	
label var size_gb85 "Size of household; GB 1985"

gen size_it85=issp1985V121 if year==1985 & iso==380
label define size_it85 1 "Single adult (living alone)" 2 "Living with parents" 3 "Young couple without children" ///
	4 "Couple with little children (<15y)" 5 "Couple with grown-up children (>15y)" 6 "Couple living seperately without children" ///
	7 "Living with familiy of son/daughter" 8 "Living with other persons (friends, relatives)"
label values size_it85 size_it85
label var size_it85 "Size of household; IT 1985"

*trade union membership

**************************************
*Resp: jobs

gen jobs=.
replace jobs=issp2016v21 if year==2016
replace jobs=issp2006V25 if year==2006
replace jobs=issp1996v36 if year==1996
replace jobs=issp1990v49 if year==1990
replace jobs=issp1985V101 if year==1985
label values jobs V21
mvdecode jobs, mv(8 9)
label var jobs "Government responsibility: Provide jobs for everyone"

*Resp: old

gen oldage=.
replace oldage=issp2016v24 if year==2016 
replace oldage=issp2006V28 if year==2006 
replace oldage=issp1996v39 if year==1996 
replace oldage=issp1990v52 if year==1990 
replace oldage=issp1985V104 if year==1985 
label values oldage V24 
mvdecode oldage, mv(8 9)
label var oldage "Government responsibility: Provide living for the old"

*Resp: unemployed

gen unemp=.
replace unemp=issp2016v26 if year==2016
replace unemp=issp2006V30 if year==2006 
replace unemp=issp1996v41 if year==1996 
replace unemp=issp1990v54 if year==1990 
replace unemp=issp1985V106 if year==1985 
label values unemp V26
mvdecode unemp, mv(8 9)
label var unemp "Government responsibility: Provide living standard for unemployed"


*Resp: Reduce income differences

gen redincd=.
replace redincd=issp2016v27 if year==2016
replace redincd=issp2006V31 if year==2006
replace redincd=issp1996v42 if year==1996
replace redincd=issp1990v55 if year==1990
replace redincd=issp1985V107 if year==1985
label values redincd V27
mvdecode redincd, mv(8 9)
label var redincd "Government responsibility: Reduce income differences rich/poor"

replace iso=276 if iso==276.1 | iso==276.2
replace iso=826 if iso==826.1 | iso==826.2

keep if iso==36 | iso==124 | iso==246 | iso==250 | iso==276 | iso==372 | iso==380  ///
	| iso==392 | iso==554 | iso==578 | iso==724 | iso==752 | iso==756 | iso==826 | iso==840

keep iso year age educat sex jobs oldage unemp redincd marital wrkst attend size age_dk age_it size_gb85 size_it85

order iso year age educat sex age_dk age_it jobs oldage unemp redincd ///
	marital wrkst attend size size_gb85 size_it85	


sort iso year
save issp_ansample.dta, replace

************************************************************************
*Macrovariables
gen migstock_un=.

replace migstock_un=	.	 if iso==	36	 & year==	1985
replace migstock_un=	23.2093948	 if iso==	36	 & year==	1990
replace migstock_un=	22.98203933	 if iso==	36	 & year==	1996
replace migstock_un=	24.60093075	 if iso==	36	 & year==	2006
replace migstock_un=	28.48535426	 if iso==	36	 & year==	2016
replace migstock_un=	.	 if iso==	124	 & year==	1985
replace migstock_un=	15.6478824	 if iso==	124	 & year==	1990
replace migstock_un=	16.85569532	 if iso==	124	 & year==	1996
replace migstock_un=	19.01947369	 if iso==	124	 & year==	2006
replace migstock_un=	21.24867775	 if iso==	124	 & year==	2016
replace migstock_un=	.	 if iso==	246	 & year==	1985
replace migstock_un=	1.266056632	 if iso==	246	 & year==	1990
replace migstock_un=	2.083642557	 if iso==	246	 & year==	1996
replace migstock_un=	3.848197938	 if iso==	246	 & year==	2006
replace migstock_un=	5.982078695	 if iso==	246	 & year==	2016
replace migstock_un=	.	 if iso==	250	 & year==	1985
replace migstock_un=	10.35319619	 if iso==	250	 & year==	1990
replace migstock_un=	10.46903306	 if iso==	250	 & year==	1996
replace migstock_un=	11.08607227	 if iso==	250	 & year==	2006
replace migstock_un=	12.22333359	 if iso==	250	 & year==	2016
replace migstock_un=	.	 if iso==	276	 & year==	1985
replace migstock_un=	7.502915317	 if iso==	276	 & year==	1990
replace migstock_un=	9.557531177	 if iso==	276	 & year==	1996
replace migstock_un=	11.63597739	 if iso==	276	 & year==	2006
replace migstock_un=	13.66166471	 if iso==	276	 & year==	2016
replace migstock_un=	.	 if iso==	372	 & year==	1985
replace migstock_un=	6.386791425	 if iso==	372	 & year==	1990
replace migstock_un=	6.792499721	 if iso==	372	 & year==	1996
replace migstock_un=	14.34314787	 if iso==	372	 & year==	2006
replace migstock_un=	16.44714055	 if iso==	372	 & year==	2016
replace migstock_un=	.	 if iso==	380	 & year==	1985
replace migstock_un=	2.500075271	 if iso==	380	 & year==	1990
replace migstock_un=	3.220694842	 if iso==	380	 & year==	1996
replace migstock_un=	7.317910402	 if iso==	380	 & year==	2006
replace migstock_un=	9.854048519	 if iso==	380	 & year==	2016
replace migstock_un=	.	 if iso==	392	 & year==	1985
replace migstock_un=	0.863848656	 if iso==	392	 & year==	1990
replace migstock_un=	1.138770858	 if iso==	392	 & year==	1996
replace migstock_un=	1.58681053	 if iso==	392	 & year==	2006
replace migstock_un=	1.78261324	 if iso==	392	 & year==	2016
replace migstock_un=	.	 if iso==	554	 & year==	1985
replace migstock_un=	15.24487283	 if iso==	554	 & year==	1990
replace migstock_un=	16.33173258	 if iso==	554	 & year==	1996
replace migstock_un=	20.58524985	 if iso==	554	 & year==	2006
replace migstock_un=	22.60741232	 if iso==	554	 & year==	2016
replace migstock_un=	.	 if iso==	578	 & year==	1985
replace migstock_un=	4.534355476	 if iso==	578	 & year==	1990
replace migstock_un=	5.573829944	 if iso==	578	 & year==	1996
replace migstock_un=	8.393299542	 if iso==	578	 & year==	2006
replace migstock_un=	14.70646911	 if iso==	578	 & year==	2016
replace migstock_un=	.	 if iso==	724	 & year==	1985
replace migstock_un=	2.090273414	 if iso==	724	 & year==	1990
replace migstock_un=	2.856069088	 if iso==	724	 & year==	1996
replace migstock_un=	10.14489578	 if iso==	724	 & year==	2006
replace migstock_un=	12.76343865	 if iso==	724	 & year==	2016
replace migstock_un=	.	 if iso==	752	 & year==	1985
replace migstock_un=	9.206625967	 if iso==	752	 & year==	1990
replace migstock_un=	10.73460804	 if iso==	752	 & year==	1996
replace migstock_un=	12.81237633	 if iso==	752	 & year==	2006
replace migstock_un=	17.02393128	 if iso==	752	 & year==	2016
replace migstock_un=	.	 if iso==	756	 & year==	1985
replace migstock_un=	20.85850104	 if iso==	756	 & year==	1990
replace migstock_un=	21.23944223	 if iso==	756	 & year==	1996
replace migstock_un=	24.79034592	 if iso==	756	 & year==	2006
replace migstock_un=	29.30723371	 if iso==	756	 & year==	2016
replace migstock_un=	.	 if iso==	826	 & year==	1985
replace migstock_un=	6.38347913	 if iso==	826	 & year==	1990
replace migstock_un=	7.338364378	 if iso==	826	 & year==	1996
replace migstock_un=	10.26640978	 if iso==	826	 & year==	2006
replace migstock_un=	13.11062346	 if iso==	826	 & year==	2016
replace migstock_un=	.	 if iso==	840	 & year==	1985
replace migstock_un=	9.207235023	 if iso==	840	 & year==	1990
replace migstock_un=	11.0369285	 if iso==	840	 & year==	1996
replace migstock_un=	13.50475069	 if iso==	840	 & year==	2006
replace migstock_un=	15.20036966	 if iso==	840	 & year==	2016


gen migstock_wb=.
replace migstock_wb=	19.948	if iso==	36	& year==	1985
replace migstock_wb=	23.177	if iso==	36	& year==	1990
replace migstock_wb=	22.937	if iso==	36	& year==	1996
replace migstock_wb=	24.539	if iso==	36	& year==	2006
replace migstock_wb=	.	if iso==	36	& year==	2016
replace migstock_wb=	15.036	if iso==	124	& year==	1985
replace migstock_wb=	15.593	if iso==	124	& year==	1990
replace migstock_wb=	16.831	if iso==	124	& year==	1996
replace migstock_wb=	19.237	if iso==	124	& year==	2006
replace migstock_wb=	.	if iso==	124	& year==	2016
replace migstock_wb=	0.996	if iso==	246	& year==	1985
replace migstock_wb=	1.269	if iso==	246	& year==	1990
replace migstock_wb=	2.088	if iso==	246	& year==	1996
replace migstock_wb=	3.862	if iso==	246	& year==	2006
replace migstock_wb=	.	if iso==	246	& year==	2016
replace migstock_wb=	10.481	if iso==	250	& year==	1985
replace migstock_wb=	10.079	if iso==	250	& year==	1990
replace migstock_wb=	10.252	if iso==	250	& year==	1996
replace migstock_wb=	10.734	if iso==	250	& year==	2006
replace migstock_wb=	.	if iso==	250	& year==	2016
replace migstock_wb=	.	if iso==	276	& year==	1985
replace migstock_wb=	7.473	if iso==	276	& year==	1990
replace migstock_wb=	9.486	if iso==	276	& year==	1996
replace migstock_wb=	12.82	if iso==	276	& year==	2006
replace migstock_wb=	.	if iso==	276	& year==	2016
replace migstock_wb=	6.367	if iso==	372	& year==	1985
replace migstock_wb=	6.487	if iso==	372	& year==	1990
replace migstock_wb=	6.917	if iso==	372	& year==	1996
replace migstock_wb=	14.446	if iso==	372	& year==	2006
replace migstock_wb=	.	if iso==	372	& year==	2016
replace migstock_wb=	2.214	if iso==	380	& year==	1985
replace migstock_wb=	2.518	if iso==	380	& year==	1990
replace migstock_wb=	3.244	if iso==	380	& year==	1996
replace migstock_wb=	7.432	if iso==	380	& year==	2006
replace migstock_wb=	.	if iso==	380	& year==	2016
replace migstock_wb=	0.705	if iso==	392	& year==	1985
replace migstock_wb=	0.871	if iso==	392	& year==	1990
replace migstock_wb=	1.147	if iso==	392	& year==	1996
replace migstock_wb=	1.593	if iso==	392	& year==	2006
replace migstock_wb=	.	if iso==	392	& year==	2016
replace migstock_wb=	14.784	if iso==	554	& year==	1985
replace migstock_wb=	15.558	if iso==	554	& year==	1990
replace migstock_wb=	16.256	if iso==	554	& year==	1996
replace migstock_wb=	20.586	if iso==	554	& year==	2006
replace migstock_wb=	.	if iso==	554	& year==	2016
replace migstock_wb=	3.556	if iso==	578	& year==	1985
replace migstock_wb=	4.541	if iso==	578	& year==	1990
replace migstock_wb=	5.595	if iso==	578	& year==	1996
replace migstock_wb=	8.46	if iso==	578	& year==	2006
replace migstock_wb=	.	if iso==	578	& year==	2016
replace migstock_wb=	1.864	if iso==	724	& year==	1985
replace migstock_wb=	2.114	if iso==	724	& year==	1990
replace migstock_wb=	2.877	if iso==	724	& year==	1996
replace migstock_wb=	10.23	if iso==	724	& year==	2006
replace migstock_wb=	.	if iso==	724	& year==	2016
replace migstock_wb=	7.834	if iso==	752	& year==	1985
replace migstock_wb=	9.216	if iso==	752	& year==	1990
replace migstock_wb=	10.741	if iso==	752	& year==	1996
replace migstock_wb=	12.969	if iso==	752	& year==	2006
replace migstock_wb=	.	if iso==	752	& year==	2016
replace migstock_wb=	18.596	if iso==	756	& year==	1985
replace migstock_wb=	20.732	if iso==	756	& year==	1990
replace migstock_wb=	21.171	if iso==	756	& year==	1996
replace migstock_wb=	24.845	if iso==	756	& year==	2006
replace migstock_wb=	.	if iso==	756	& year==	2016
replace migstock_wb=	6.253	if iso==	826	& year==	1985
replace migstock_wb=	6.376	if iso==	826	& year==	1990
replace migstock_wb=	7.341	if iso==	826	& year==	1996
replace migstock_wb=	10.291	if iso==	826	& year==	2006
replace migstock_wb=	.	if iso==	826	& year==	2016
replace migstock_wb=	8.192	if iso==	840	& year==	1985
replace migstock_wb=	9.314	if iso==	840	& year==	1990
replace migstock_wb=	11.034	if iso==	840	& year==	1996
replace migstock_wb=	13.487	if iso==	840	& year==	2006
replace migstock_wb=	.	if iso==	840	& year==	2016



gen migstock=.
replace migstock=migstock_un
replace migstock= migstock_wb if year==1985

gen net_mig_un_5y=.
replace net_mig_un_5y=	4.3894	if iso==	36	& year==	1985
replace net_mig_un_5y=	6.857	if iso==	36	& year==	1990
replace net_mig_un_5y=	5.6522	if iso==	36	& year==	1996
replace net_mig_un_5y=	5.1382	if iso==	36	& year==	2006
replace net_mig_un_5y=	9.0132	if iso==	36	& year==	2016
replace net_mig_un_5y=	3.398	if iso==	124	& year==	1985
replace net_mig_un_5y=	4.404	if iso==	124	& year==	1990
replace net_mig_un_5y=	5.5548	if iso==	124	& year==	1996
replace net_mig_un_5y=	5.9384	if iso==	124	& year==	2006
replace net_mig_un_5y=	6.8828	if iso==	124	& year==	2016
replace net_mig_un_5y=	-0.3096	if iso==	246	& year==	1985
replace net_mig_un_5y=	0.9432	if iso==	246	& year==	1990
replace net_mig_un_5y=	1.4154	if iso==	246	& year==	1996
replace net_mig_un_5y=	1.0778	if iso==	246	& year==	2006
replace net_mig_un_5y=	2.668	if iso==	246	& year==	2016
replace net_mig_un_5y=	0.7214	if iso==	250	& year==	1985
replace net_mig_un_5y=	1.274	if iso==	250	& year==	1990
replace net_mig_un_5y=	1.3184	if iso==	250	& year==	1996
replace net_mig_un_5y=	1.4984	if iso==	250	& year==	2006
replace net_mig_un_5y=	1.3718	if iso==	250	& year==	2016
replace net_mig_un_5y=	.	if iso==	276	& year==	1985
replace net_mig_un_5y=	.	if iso==	276	& year==	1990
replace net_mig_un_5y=	5.7296	if iso==	276	& year==	1996
replace net_mig_un_5y=	1.8682	if iso==	276	& year==	2006
replace net_mig_un_5y=	2.6656	if iso==	276	& year==	2016
replace net_mig_un_5y=	0.7636	if iso==	372	& year==	1985
replace net_mig_un_5y=	-4.3236	if iso==	372	& year==	1990
replace net_mig_un_5y=	-2.9376	if iso==	372	& year==	1996
replace net_mig_un_5y=	7.7318	if iso==	372	& year==	2006
replace net_mig_un_5y=	-0.016	if iso==	372	& year==	2016
replace net_mig_un_5y=	0.7296	if iso==	380	& year==	1985
replace net_mig_un_5y=	0.5494	if iso==	380	& year==	1990
replace net_mig_un_5y=	0.3064	if iso==	380	& year==	1996
replace net_mig_un_5y=	3.6704	if iso==	380	& year==	2006
replace net_mig_un_5y=	1.89	if iso==	380	& year==	2016
replace net_mig_un_5y=	0.2468	if iso==	392	& year==	1985
replace net_mig_un_5y=	-0.1438	if iso==	392	& year==	1990
replace net_mig_un_5y=	-0.1492	if iso==	392	& year==	1996
replace net_mig_un_5y=	0.091	if iso==	392	& year==	2006
replace net_mig_un_5y=	0.5076	if iso==	392	& year==	2016
replace net_mig_un_5y=	-2.9542	if iso==	554	& year==	1985
replace net_mig_un_5y=	-0.3346	if iso==	554	& year==	1990
replace net_mig_un_5y=	3.7784	if iso==	554	& year==	1996
replace net_mig_un_5y=	4.946	if iso==	554	& year==	2006
replace net_mig_un_5y=	3.6022	if iso==	554	& year==	2016
replace net_mig_un_5y=	1.096	if iso==	578	& year==	1985
replace net_mig_un_5y=	1.4596	if iso==	578	& year==	1990
replace net_mig_un_5y=	2.044	if iso==	578	& year==	1996
replace net_mig_un_5y=	2.832	if iso==	578	& year==	2006
replace net_mig_un_5y=	8.0254	if iso==	578	& year==	2016
replace net_mig_un_5y=	0.1598	if iso==	724	& year==	1985
replace net_mig_un_5y=	-0.274	if iso==	724	& year==	1990
replace net_mig_un_5y=	0.8294	if iso==	724	& year==	1996
replace net_mig_un_5y=	9.8114	if iso==	724	& year==	2006
replace net_mig_un_5y=	2.511	if iso==	724	& year==	2016
replace net_mig_un_5y=	1.573	if iso==	752	& year==	1985
replace net_mig_un_5y=	1.701	if iso==	752	& year==	1990
replace net_mig_un_5y=	3.4296	if iso==	752	& year==	1996
replace net_mig_un_5y=	2.4258	if iso==	752	& year==	2006
replace net_mig_un_5y=	5.4612	if iso==	752	& year==	2016
replace net_mig_un_5y=	-1.5502	if iso==	756	& year==	1985
replace net_mig_un_5y=	3.1184	if iso==	756	& year==	1990
replace net_mig_un_5y=	5.9306	if iso==	756	& year==	1996
replace net_mig_un_5y=	3.7998	if iso==	756	& year==	2006
replace net_mig_un_5y=	9.5228	if iso==	756	& year==	2016
replace net_mig_un_5y=	-0.055	if iso==	826	& year==	1985
replace net_mig_un_5y=	-0.0684	if iso==	826	& year==	1990
replace net_mig_un_5y=	0.5676	if iso==	826	& year==	1996
replace net_mig_un_5y=	2.6316	if iso==	826	& year==	2006
replace net_mig_un_5y=	4.4742	if iso==	826	& year==	2016
replace net_mig_un_5y=	3.2562	if iso==	840	& year==	1985
replace net_mig_un_5y=	2.8472	if iso==	840	& year==	1990
replace net_mig_un_5y=	3.2042	if iso==	840	& year==	1996
replace net_mig_un_5y=	4.6814	if iso==	840	& year==	2006
replace net_mig_un_5y=	3.0524	if iso==	840	& year==	2016



gen pc5_gdp_oecd=.
replace pc5_gdp_oecd=	0.068317108	if iso==	36	& year==	1985
replace pc5_gdp_oecd=	0.042166442	if iso==	36	& year==	1990
replace pc5_gdp_oecd=	0.050830028	if iso==	36	& year==	1996
replace pc5_gdp_oecd=	0.051221179	if iso==	36	& year==	2006
replace pc5_gdp_oecd=	0.020130204	if iso==	36	& year==	2016
replace pc5_gdp_oecd=	0.069444657	if iso==	124	& year==	1985
replace pc5_gdp_oecd=	0.043913324	if iso==	124	& year==	1990
replace pc5_gdp_oecd=	0.03520525	if iso==	124	& year==	1996
replace pc5_gdp_oecd=	0.047645014	if iso==	124	& year==	2006
replace pc5_gdp_oecd=	0.015444002	if iso==	124	& year==	2016
replace pc5_gdp_oecd=	0.076836172	if iso==	246	& year==	1985
replace pc5_gdp_oecd=	0.063310173	if iso==	246	& year==	1990
replace pc5_gdp_oecd=	0.027340914	if iso==	246	& year==	1996
replace pc5_gdp_oecd=	0.043678836	if iso==	246	& year==	2006
replace pc5_gdp_oecd=	0.013296215	if iso==	246	& year==	2016
replace pc5_gdp_oecd=	0.063411177	if iso==	250	& year==	1985
replace pc5_gdp_oecd=	0.060153792	if iso==	250	& year==	1990
replace pc5_gdp_oecd=	0.030879333	if iso==	250	& year==	1996
replace pc5_gdp_oecd=	0.033745813	if iso==	250	& year==	2006
replace pc5_gdp_oecd=	0.02017069	if iso==	250	& year==	2016
replace pc5_gdp_oecd=	0.068427637	if iso==	276	& year==	1985
replace pc5_gdp_oecd=	0.060869048	if iso==	276	& year==	1990
replace pc5_gdp_oecd=	0.029524295	if iso==	276	& year==	1996
replace pc5_gdp_oecd=	0.038552408	if iso==	276	& year==	2006
replace pc5_gdp_oecd=	0.028782481	if iso==	276	& year==	2016
replace pc5_gdp_oecd=	0.070736368	if iso==	372	& year==	1985
replace pc5_gdp_oecd=	0.082637963	if iso==	372	& year==	1990
replace pc5_gdp_oecd=	0.073484951	if iso==	372	& year==	1996
replace pc5_gdp_oecd=	0.0633193	if iso==	372	& year==	2006
replace pc5_gdp_oecd=	0.101393413	if iso==	372	& year==	2016
replace pc5_gdp_oecd=	0.069474509	if iso==	380	& year==	1985
replace pc5_gdp_oecd=	0.063062264	if iso==	380	& year==	1990
replace pc5_gdp_oecd=	0.033833976	if iso==	380	& year==	1996
replace pc5_gdp_oecd=	0.028816229	if iso==	380	& year==	2006
replace pc5_gdp_oecd=	0.01451194	if iso==	380	& year==	2016
replace pc5_gdp_oecd=	0.088686819	if iso==	392	& year==	1985
replace pc5_gdp_oecd=	0.078240985	if iso==	392	& year==	1990
replace pc5_gdp_oecd=	0.034079461	if iso==	392	& year==	1996
replace pc5_gdp_oecd=	0.037837651	if iso==	392	& year==	2006
replace pc5_gdp_oecd=	0.034151658	if iso==	392	& year==	2016
replace pc5_gdp_oecd=	0.084294593	if iso==	554	& year==	1985
replace pc5_gdp_oecd=	0.03049547	if iso==	554	& year==	1990
replace pc5_gdp_oecd=	0.048565366	if iso==	554	& year==	1996
replace pc5_gdp_oecd=	0.043438455	if iso==	554	& year==	2006
replace pc5_gdp_oecd=	0.037816917	if iso==	554	& year==	2016
replace pc5_gdp_oecd=	0.085188895	if iso==	578	& year==	1985
replace pc5_gdp_oecd=	0.044413396	if iso==	578	& year==	1990
replace pc5_gdp_oecd=	0.065196773	if iso==	578	& year==	1996
replace pc5_gdp_oecd=	0.075601864	if iso==	578	& year==	2006
replace pc5_gdp_oecd=	-0.009927704	if iso==	578	& year==	2016
replace pc5_gdp_oecd=	0.061883042	if iso==	724	& year==	1985
replace pc5_gdp_oecd=	0.075348978	if iso==	724	& year==	1990
replace pc5_gdp_oecd=	0.035009305	if iso==	724	& year==	1996
replace pc5_gdp_oecd=	0.061037291	if iso==	724	& year==	2006
replace pc5_gdp_oecd=	0.025411553	if iso==	724	& year==	2016
replace pc5_gdp_oecd=	0.072258483	if iso==	752	& year==	1985
replace pc5_gdp_oecd=	0.050855975	if iso==	752	& year==	1990
replace pc5_gdp_oecd=	0.02988787	if iso==	752	& year==	1996
replace pc5_gdp_oecd=	0.048021744	if iso==	752	& year==	2006
replace pc5_gdp_oecd=	0.021362903	if iso==	752	& year==	2016
replace pc5_gdp_oecd=	0.063423354	if iso==	756	& year==	1985
replace pc5_gdp_oecd=	0.053398406	if iso==	756	& year==	1990
replace pc5_gdp_oecd=	0.018814912	if iso==	756	& year==	1996
replace pc5_gdp_oecd=	0.0424969	if iso==	756	& year==	2006
replace pc5_gdp_oecd=	0.026104436	if iso==	756	& year==	2016
replace pc5_gdp_oecd=	0.076360697	if iso==	826	& year==	1985
replace pc5_gdp_oecd=	0.064768186	if iso==	826	& year==	1990
replace pc5_gdp_oecd=	0.04760404	if iso==	826	& year==	1996
replace pc5_gdp_oecd=	0.046635523	if iso==	826	& year==	2006
replace pc5_gdp_oecd=	0.030460686	if iso==	826	& year==	2016
replace pc5_gdp_oecd=	0.07749314	if iso==	840	& year==	1985
replace pc5_gdp_oecd=	0.055570699	if iso==	840	& year==	1990
replace pc5_gdp_oecd=	0.042673966	if iso==	840	& year==	1996
replace pc5_gdp_oecd=	0.04506696	if iso==	840	& year==	2006
replace pc5_gdp_oecd=	0.030250016	if iso==	840	& year==	2016


gen unemprr =.
replace	unemprr	=	0.4245	if iso ==	36	& year==	1985
replace	unemprr	=	0.481	if iso ==	36	& year==	1990
replace	unemprr	=	0.5015	if iso ==	36	& year==	1996
replace	unemprr	=	0.4255	if iso ==	36	& year==	2006
replace	unemprr	=	0.3785	if iso ==	36	& year==	2016
replace	unemprr	=	0.6585	if iso ==	124	& year==	1985
replace	unemprr	=	0.652	if iso ==	124	& year==	1990
replace	unemprr	=	0.6365	if iso ==	124	& year==	1996
replace	unemprr	=	0.583	if iso ==	124	& year==	2006
replace	unemprr	=	0.5795	if iso ==	124	& year==	2016
replace	unemprr	=	0.6115	if iso ==	246	& year==	1985
replace	unemprr	=	0.6445	if iso ==	246	& year==	1990
replace	unemprr	=	0.68	if iso ==	246	& year==	1996
replace	unemprr	=	0.6175	if iso ==	246	& year==	2006
replace	unemprr	=	0.606	if iso ==	246	& year==	2016
replace	unemprr	=	0.7225	if iso ==	250	& year==	1985
replace	unemprr	=	.	if iso ==	250	& year==	1990
replace	unemprr	=	0.7375	if iso ==	250	& year==	1996
replace	unemprr	=	0.7085	if iso ==	250	& year==	2006
replace	unemprr	=	0.701	if iso ==	250	& year==	2016
replace	unemprr	=	0.665	if iso ==	276	& year==	1985
replace	unemprr	=	0.664	if iso ==	276	& year==	1990
replace	unemprr	=	0.6525	if iso ==	276	& year==	1996
replace	unemprr	=	0.6565	if iso ==	276	& year==	2006
replace	unemprr	=	0.6575	if iso ==	276	& year==	2016
replace	unemprr	=	0.609	if iso ==	372	& year==	1985
replace	unemprr	=	0.469	if iso ==	372	& year==	1990
replace	unemprr	=	0.4455	if iso ==	372	& year==	1996
replace	unemprr	=	0.489	if iso ==	372	& year==	2006
replace	unemprr	=	0.5375	if iso ==	372	& year==	2016
replace	unemprr	=	0.0845	if iso ==	380	& year==	1985
replace	unemprr	=	0.243	if iso ==	380	& year==	1990
replace	unemprr	=	0.4645	if iso ==	380	& year==	1996
replace	unemprr	=	0.6655	if iso ==	380	& year==	2006
replace	unemprr	=	0.613	if iso ==	380	& year==	2016
replace	unemprr	=	0.5635	if iso ==	392	& year==	1985
replace	unemprr	=	0.5545	if iso ==	392	& year==	1990
replace	unemprr	=	0.561	if iso ==	392	& year==	1996
replace	unemprr	=	0.568	if iso ==	392	& year==	2006
replace	unemprr	=	0.58	if iso ==	392	& year==	2016
replace	unemprr	=	0.526	if iso ==	554	& year==	1985
replace	unemprr	=	0.5295	if iso ==	554	& year==	1990
replace	unemprr	=	0.451	if iso ==	554	& year==	1996
replace	unemprr	=	0.39	if iso ==	554	& year==	2006
replace	unemprr	=	0.372	if iso ==	554	& year==	2016
replace	unemprr	=	0.701	if iso ==	578	& year==	1985
replace	unemprr	=	0.7035	if iso ==	578	& year==	1990
replace	unemprr	=	0.6955	if iso ==	578	& year==	1996
replace	unemprr	=	0.695	if iso ==	578	& year==	2006
replace	unemprr	=	0.691	if iso ==	578	& year==	2016
replace	unemprr	=	0.9625	if iso ==	724	& year==	1985
replace	unemprr	=	0.9015	if iso ==	724	& year==	1990
replace	unemprr	=	0.7535	if iso ==	724	& year==	1996
replace	unemprr	=	0.754	if iso ==	724	& year==	2006
replace	unemprr	=	0.7865	if iso ==	724	& year==	2016
replace	unemprr	=	0.8185	if iso ==	752	& year==	1985
replace	unemprr	=	0.861	if iso ==	752	& year==	1990
replace	unemprr	=	0.7485	if iso ==	752	& year==	1996
replace	unemprr	=	0.7525	if iso ==	752	& year==	2006
replace	unemprr	=	0.6235	if iso ==	752	& year==	2016
replace	unemprr	=	0.7575	if iso ==	756	& year==	1985
replace	unemprr	=	0.7575	if iso ==	756	& year==	1990
replace	unemprr	=	0.7905	if iso ==	756	& year==	1996
replace	unemprr	=	0.778	if iso ==	756	& year==	2006
replace	unemprr	=	.	if iso ==	756	& year==	2016
replace	unemprr	=	0.3495	if iso ==	826	& year==	1985
replace	unemprr	=	0.279	if iso ==	826	& year==	1990
replace	unemprr	=	0.2895	if iso ==	826	& year==	1996
replace	unemprr	=	0.296	if iso ==	826	& year==	2006
replace	unemprr	=	0.3125	if iso ==	826	& year==	2016
replace	unemprr	=	0.671	if iso ==	840	& year==	1985
replace	unemprr	=	0.588	if iso ==	840	& year==	1990
replace	unemprr	=	0.5845	if iso ==	840	& year==	1996
replace	unemprr	=	0.5905	if iso ==	840	& year==	2006
replace	unemprr	=	0.5755	if iso ==	840	& year==	2016

gen sickrr=.
replace	sickrr	=	0.4245	if iso ==	36	& year==	1985
replace	sickrr	=	0.481	if iso ==	36	& year==	1990
replace	sickrr	=	0.5015	if iso ==	36	& year==	1996
replace	sickrr	=	0.4255	if iso ==	36	& year==	2006
replace	sickrr	=	0.3785	if iso ==	36	& year==	2016
replace	sickrr	=	0.4075	if iso ==	124	& year==	1985
replace	sickrr	=	0.403	if iso ==	124	& year==	1990
replace	sickrr	=	0.419	if iso ==	124	& year==	1996
replace	sickrr	=	0.3845	if iso ==	124	& year==	2006
replace	sickrr	=	0.3755	if iso ==	124	& year==	2016
replace	sickrr	=	0.8025	if iso ==	246	& year==	1985
replace	sickrr	=	0.849	if iso ==	246	& year==	1990
replace	sickrr	=	0.7875	if iso ==	246	& year==	1996
replace	sickrr	=	0.7325	if iso ==	246	& year==	2006
replace	sickrr	=	0.7275	if iso ==	246	& year==	2016
replace	sickrr	=	0.6245	if iso ==	250	& year==	1985
replace	sickrr	=	0.6405	if iso ==	250	& year==	1990
replace	sickrr	=	0.651	if iso ==	250	& year==	1996
replace	sickrr	=	0.636	if iso ==	250	& year==	2006
replace	sickrr	=	0.6305	if iso ==	250	& year==	2016
replace	sickrr	=	0.9625	if iso ==	276	& year==	1985
replace	sickrr	=	0.9325	if iso ==	276	& year==	1990
replace	sickrr	=	0.963	if iso ==	276	& year==	1996
replace	sickrr	=	0.897	if iso ==	276	& year==	2006
replace	sickrr	=	0.8875	if iso ==	276	& year==	2016
replace	sickrr	=	0.609	if iso ==	372	& year==	1985
replace	sickrr	=	0.4925	if iso ==	372	& year==	1990
replace	sickrr	=	0.455	if iso ==	372	& year==	1996
replace	sickrr	=	0.4775	if iso ==	372	& year==	2006
replace	sickrr	=	0.4925	if iso ==	372	& year==	2016
replace	sickrr	=	0.791	if iso ==	380	& year==	1985
replace	sickrr	=	0.7685	if iso ==	380	& year==	1990
replace	sickrr	=	0.809	if iso ==	380	& year==	1996
replace	sickrr	=	0.8065	if iso ==	380	& year==	2006
replace	sickrr	=	0.794	if iso ==	380	& year==	2016
replace	sickrr	=	0.521	if iso ==	392	& year==	1985
replace	sickrr	=	0.547	if iso ==	392	& year==	1990
replace	sickrr	=	0.542	if iso ==	392	& year==	1996
replace	sickrr	=	0.5975	if iso ==	392	& year==	2006
replace	sickrr	=	0.645	if iso ==	392	& year==	2016
replace	sickrr	=	0.5495	if iso ==	554	& year==	1985
replace	sickrr	=	0.552	if iso ==	554	& year==	1990
replace	sickrr	=	0.474	if iso ==	554	& year==	1996
replace	sickrr	=	0.39	if iso ==	554	& year==	2006
replace	sickrr	=	0.372	if iso ==	554	& year==	2016
replace	sickrr	=	1	if iso ==	578	& year==	1985
replace	sickrr	=	1	if iso ==	578	& year==	1990
replace	sickrr	=	1	if iso ==	578	& year==	1996
replace	sickrr	=	1	if iso ==	578	& year==	2006
replace	sickrr	=	1	if iso ==	578	& year==	2016
replace	sickrr	=	0.761	if iso ==	724	& year==	1985
replace	sickrr	=	0.7815	if iso ==	724	& year==	1990
replace	sickrr	=	0.772	if iso ==	724	& year==	1996
replace	sickrr	=	0.7685	if iso ==	724	& year==	2006
replace	sickrr	=	0.7785	if iso ==	724	& year==	2016
replace	sickrr	=	0.9275	if iso ==	752	& year==	1985
replace	sickrr	=	0.9185	if iso ==	752	& year==	1990
replace	sickrr	=	0.7865	if iso ==	752	& year==	1996
replace	sickrr	=	0.828	if iso ==	752	& year==	2006
replace	sickrr	=	0.8045	if iso ==	752	& year==	2016
replace	sickrr	=	1	if iso ==	756	& year==	1985
replace	sickrr	=	1	if iso ==	756	& year==	1990
replace	sickrr	=	1	if iso ==	756	& year==	1996
replace	sickrr	=	1	if iso ==	756	& year==	2006
replace	sickrr	=	1	if iso ==	756	& year==	2016
replace	sickrr	=	0.3605	if iso ==	826	& year==	1985
replace	sickrr	=	0.3035	if iso ==	826	& year==	1990
replace	sickrr	=	0.2575	if iso ==	826	& year==	1996
replace	sickrr	=	0.2295	if iso ==	826	& year==	2006
replace	sickrr	=	0.235	if iso ==	826	& year==	2016
replace	sickrr	=	0	if iso ==	840	& year==	1985
replace	sickrr	=	0	if iso ==	840	& year==	1990
replace	sickrr	=	0	if iso ==	840	& year==	1996
replace	sickrr	=	0	if iso ==	840	& year==	2006
replace	sickrr	=	0	if iso ==	840	& year==	2016

gen pensionrr=.
replace	pensionrr	=	0.383	if iso ==	36	& year==	1985
replace	pensionrr	=	0.404	if iso ==	36	& year==	1990
replace	pensionrr	=	0.4185	if iso ==	36	& year==	1996
replace	pensionrr	=	0.388	if iso ==	36	& year==	2006
replace	pensionrr	=	0.409	if iso ==	36	& year==	2016
replace	pensionrr	=	0.5465	if iso ==	124	& year==	1985
replace	pensionrr	=	0.581	if iso ==	124	& year==	1990
replace	pensionrr	=	0.638	if iso ==	124	& year==	1996
replace	pensionrr	=	0.6515	if iso ==	124	& year==	2006
replace	pensionrr	=	.	if iso ==	124	& year==	2016
replace	pensionrr	=	0.63	if iso ==	246	& year==	1985
replace	pensionrr	=	0.6325	if iso ==	246	& year==	1990
replace	pensionrr	=	0.718	if iso ==	246	& year==	1996
replace	pensionrr	=	0.738	if iso ==	246	& year==	2006
replace	pensionrr	=	0.7745	if iso ==	246	& year==	2016
replace	pensionrr	=	0.6595	if iso ==	250	& year==	1985
replace	pensionrr	=	0.661	if iso ==	250	& year==	1990
replace	pensionrr	=	0.6585	if iso ==	250	& year==	1996
replace	pensionrr	=	0.587	if iso ==	250	& year==	2006
replace	pensionrr	=	.	if iso ==	250	& year==	2016
replace	pensionrr	=	0.7315	if iso ==	276	& year==	1985
replace	pensionrr	=	0.694	if iso ==	276	& year==	1990
replace	pensionrr	=	0.672	if iso ==	276	& year==	1996
replace	pensionrr	=	0.5915	if iso ==	276	& year==	2006
replace	pensionrr	=	0.538	if iso ==	276	& year==	2016
replace	pensionrr	=	0.537	if iso ==	372	& year==	1985
replace	pensionrr	=	0.5005	if iso ==	372	& year==	1990
replace	pensionrr	=	0.4755	if iso ==	372	& year==	1996
replace	pensionrr	=	0.4825	if iso ==	372	& year==	2006
replace	pensionrr	=	0.6025	if iso ==	372	& year==	2016
replace	pensionrr	=	0.712	if iso ==	380	& year==	1985
replace	pensionrr	=	0.743	if iso ==	380	& year==	1990
replace	pensionrr	=	0.871	if iso ==	380	& year==	1996
replace	pensionrr	=	0.878	if iso ==	380	& year==	2006
replace	pensionrr	=	0.8175	if iso ==	380	& year==	2016
replace	pensionrr	=	0.663	if iso ==	392	& year==	1985
replace	pensionrr	=	0.645	if iso ==	392	& year==	1990
replace	pensionrr	=	0.6185	if iso ==	392	& year==	1996
replace	pensionrr	=	0.637	if iso ==	392	& year==	2006
replace	pensionrr	=	0.6435	if iso ==	392	& year==	2016
replace	pensionrr	=	0.5225	if iso ==	554	& year==	1985
replace	pensionrr	=	0.539	if iso ==	554	& year==	1990
replace	pensionrr	=	0.5025	if iso ==	554	& year==	1996
replace	pensionrr	=	0.4455	if iso ==	554	& year==	2006
replace	pensionrr	=	0.473	if iso ==	554	& year==	2016
replace	pensionrr	=	0.599	if iso ==	578	& year==	1985
replace	pensionrr	=	0.622	if iso ==	578	& year==	1990
replace	pensionrr	=	0.5985	if iso ==	578	& year==	1996
replace	pensionrr	=	0.6645	if iso ==	578	& year==	2006
replace	pensionrr	=	0.7235	if iso ==	578	& year==	2016
replace	pensionrr	=	0.9205	if iso ==	724	& year==	1985
replace	pensionrr	=	1.0785	if iso ==	724	& year==	1990
replace	pensionrr	=	1.0595	if iso ==	724	& year==	1996
replace	pensionrr	=	0.9495	if iso ==	724	& year==	2006
replace	pensionrr	=	0.936	if iso ==	724	& year==	2016
replace	pensionrr	=	0.8965	if iso ==	752	& year==	1985
replace	pensionrr	=	0.7895	if iso ==	752	& year==	1990
replace	pensionrr	=	0.7875	if iso ==	752	& year==	1996
replace	pensionrr	=	0.6615	if iso ==	752	& year==	2006
replace	pensionrr	=	0.6225	if iso ==	752	& year==	2016
replace	pensionrr	=	0.476	if iso ==	756	& year==	1985
replace	pensionrr	=	0.449	if iso ==	756	& year==	1990
replace	pensionrr	=	0.472	if iso ==	756	& year==	1996
replace	pensionrr	=	0.4975	if iso ==	756	& year==	2006
replace	pensionrr	=	.	if iso ==	756	& year==	2016
replace	pensionrr	=	0.498	if iso ==	826	& year==	1985
replace	pensionrr	=	0.5005	if iso ==	826	& year==	1990
replace	pensionrr	=	0.548	if iso ==	826	& year==	1996
replace	pensionrr	=	0.569	if iso ==	826	& year==	2006
replace	pensionrr	=	0.5775	if iso ==	826	& year==	2016
replace	pensionrr	=	0.629	if iso ==	840	& year==	1985
replace	pensionrr	=	0.6565	if iso ==	840	& year==	1990
replace	pensionrr	=	0.6725	if iso ==	840	& year==	1996
replace	pensionrr	=	0.6985	if iso ==	840	& year==	2006
replace	pensionrr	=	0.6585	if iso ==	840	& year==	2016

gen gov_party=.
replace	gov_party	=	5	if iso ==	36	& year==	1985
replace	gov_party	=	5	if iso ==	36	& year==	1990
replace	gov_party	=	2	if iso ==	36	& year==	1996
replace	gov_party	=	1	if iso ==	36	& year==	2006
replace	gov_party	=	1	if iso ==	36	& year==	2016
replace	gov_party	=	1	if iso ==	124	& year==	1985
replace	gov_party	=	1	if iso ==	124	& year==	1990
replace	gov_party	=	1	if iso ==	124	& year==	1996
replace	gov_party	=	1	if iso ==	124	& year==	2006
replace	gov_party	=	1	if iso ==	124	& year==	2016
replace	gov_party	=	3	if iso ==	246	& year==	1985
replace	gov_party	=	3	if iso ==	246	& year==	1990
replace	gov_party	=	3	if iso ==	246	& year==	1996
replace	gov_party	=	3	if iso ==	246	& year==	2006
replace	gov_party	=	1	if iso ==	246	& year==	2016
replace	gov_party	=	5	if iso ==	250	& year==	1985
replace	gov_party	=	5	if iso ==	250	& year==	1990
replace	gov_party	=	1	if iso ==	250	& year==	1996
replace	gov_party	=	1	if iso ==	250	& year==	2006
replace	gov_party	=	5	if iso ==	250	& year==	2016
replace	gov_party	=	1	if iso ==	276	& year==	1985
replace	gov_party	=	1	if iso ==	276	& year==	1990
replace	gov_party	=	1	if iso ==	276	& year==	1996
replace	gov_party	=	3	if iso ==	276	& year==	2006
replace	gov_party	=	3	if iso ==	276	& year==	2016
replace	gov_party	=	2	if iso ==	372	& year==	1985
replace	gov_party	=	1	if iso ==	372	& year==	1990
replace	gov_party	=	3	if iso ==	372	& year==	1996
replace	gov_party	=	1	if iso ==	372	& year==	2006
replace	gov_party	=	2	if iso ==	372	& year==	2016
replace	gov_party	=	2	if iso ==	380	& year==	1985
replace	gov_party	=	3	if iso ==	380	& year==	1990
replace	gov_party	=	3	if iso ==	380	& year==	1996
replace	gov_party	=	3	if iso ==	380	& year==	2006
replace	gov_party	=	4	if iso ==	380	& year==	2016
replace	gov_party	=	1	if iso ==	392	& year==	1985
replace	gov_party	=	1	if iso ==	392	& year==	1990
replace	gov_party	=	2	if iso ==	392	& year==	1996
replace	gov_party	=	1	if iso ==	392	& year==	2006
replace	gov_party	=	1	if iso ==	392	& year==	2016
replace	gov_party	=	5	if iso ==	554	& year==	1985
replace	gov_party	=	4	if iso ==	554	& year==	1990
replace	gov_party	=	1	if iso ==	554	& year==	1996
replace	gov_party	=	5	if iso ==	554	& year==	2006
replace	gov_party	=	1	if iso ==	554	& year==	2016
replace	gov_party	=	1	if iso ==	578	& year==	1985
replace	gov_party	=	2	if iso ==	578	& year==	1990
replace	gov_party	=	5	if iso ==	578	& year==	1996
replace	gov_party	=	4	if iso ==	578	& year==	2006
replace	gov_party	=	1	if iso ==	578	& year==	2016
replace	gov_party	=	5	if iso ==	724	& year==	1985
replace	gov_party	=	5	if iso ==	724	& year==	1990
replace	gov_party	=	3	if iso ==	724	& year==	1996
replace	gov_party	=	5	if iso ==	724	& year==	2006
replace	gov_party	=	1	if iso ==	724	& year==	2016
replace	gov_party	=	5	if iso ==	752	& year==	1985
replace	gov_party	=	5	if iso ==	752	& year==	1990
replace	gov_party	=	5	if iso ==	752	& year==	1996
replace	gov_party	=	4	if iso ==	752	& year==	2006
replace	gov_party	=	5	if iso ==	752	& year==	2016
replace	gov_party	=	2	if iso ==	756	& year==	1985
replace	gov_party	=	2	if iso ==	756	& year==	1990
replace	gov_party	=	2	if iso ==	756	& year==	1996
replace	gov_party	=	2	if iso ==	756	& year==	2006
replace	gov_party	=	2	if iso ==	756	& year==	2016
replace	gov_party	=	1	if iso ==	826	& year==	1985
replace	gov_party	=	1	if iso ==	826	& year==	1990
replace	gov_party	=	1	if iso ==	826	& year==	1996
replace	gov_party	=	5	if iso ==	826	& year==	2006
replace	gov_party	=	1	if iso ==	826	& year==	2016
replace	gov_party	=	1	if iso ==	840	& year==	1985
replace	gov_party	=	1	if iso ==	840	& year==	1990
replace	gov_party	=	1	if iso ==	840	& year==	1996
replace	gov_party	=	1	if iso ==	840	& year==	2006
replace	gov_party	=	1	if iso ==	840	& year==	2016

gen AvgS_ImmPol=.
replace	AvgS_ImmPol	=	0.603736103	if iso ==	36	& year==	1985
replace	AvgS_ImmPol	=	0.305849224	if iso ==	36	& year==	1990
replace	AvgS_ImmPol	=	0.290432543	if iso ==	36	& year==	1996
replace	AvgS_ImmPol	=	0.309986115	if iso ==	36	& year==	2006
replace	AvgS_ImmPol	=	0.342545629	if iso ==	36	& year==	2016
replace	AvgS_ImmPol	=	0.321928322	if iso ==	124	& year==	1985
replace	AvgS_ImmPol	=	0.327935278	if iso ==	124	& year==	1990
replace	AvgS_ImmPol	=	0.353803337	if iso ==	124	& year==	1996
replace	AvgS_ImmPol	=	0.404208839	if iso ==	124	& year==	2006
replace	AvgS_ImmPol	=	0.409417182	if iso ==	124	& year==	2016
replace	AvgS_ImmPol	=	0.359047621	if iso ==	246	& year==	1985
replace	AvgS_ImmPol	=	0.376964301	if iso ==	246	& year==	1990
replace	AvgS_ImmPol	=	0.369694442	if iso ==	246	& year==	1996
replace	AvgS_ImmPol	=	0.41747421	if iso ==	246	& year==	2006
replace	AvgS_ImmPol	=	0.422474205	if iso ==	246	& year==	2016
replace	AvgS_ImmPol	=	0.32249999	if iso ==	250	& year==	1985
replace	AvgS_ImmPol	=	0.331250012	if iso ==	250	& year==	1990
replace	AvgS_ImmPol	=	0.326626986	if iso ==	250	& year==	1996
replace	AvgS_ImmPol	=	0.325625002	if iso ==	250	& year==	2006
replace	AvgS_ImmPol	=	0.327261895	if iso ==	250	& year==	2016
replace	AvgS_ImmPol	=	0.452839285	if iso ==	276	& year==	1985
replace	AvgS_ImmPol	=	0.435165673	if iso ==	276	& year==	1990
replace	AvgS_ImmPol	=	0.365389884	if iso ==	276	& year==	1996
replace	AvgS_ImmPol	=	0.386729151	if iso ==	276	& year==	2006
replace	AvgS_ImmPol	=	0.377330363	if iso ==	276	& year==	2016
replace	AvgS_ImmPol	=	0.683442473	if iso ==	372	& year==	1985
replace	AvgS_ImmPol	=	0.683442473	if iso ==	372	& year==	1990
replace	AvgS_ImmPol	=	0.683442473	if iso ==	372	& year==	1996
replace	AvgS_ImmPol	=	0.703382969	if iso ==	372	& year==	2006
replace	AvgS_ImmPol	=	0.555287719	if iso ==	372	& year==	2016
replace	AvgS_ImmPol	=	0.607728183	if iso ==	380	& year==	1985
replace	AvgS_ImmPol	=	0.491954356	if iso ==	380	& year==	1990
replace	AvgS_ImmPol	=	0.382996023	if iso ==	380	& year==	1996
replace	AvgS_ImmPol	=	0.371579349	if iso ==	380	& year==	2006
replace	AvgS_ImmPol	=	0.377509922	if iso ==	380	& year==	2016
replace	AvgS_ImmPol	=	0.459156752	if iso ==	392	& year==	1985
replace	AvgS_ImmPol	=	0.395158738	if iso ==	392	& year==	1990
replace	AvgS_ImmPol	=	0.358253956	if iso ==	392	& year==	1996
replace	AvgS_ImmPol	=	0.36944446	if iso ==	392	& year==	2006
replace	AvgS_ImmPol	=	0.384325385	if iso ==	392	& year==	2016
replace	AvgS_ImmPol	=	0.614722252	if iso ==	554	& year==	1985
replace	AvgS_ImmPol	=	0.444424599	if iso ==	554	& year==	1990
replace	AvgS_ImmPol	=	0.433442473	if iso ==	554	& year==	1996
replace	AvgS_ImmPol	=	0.457269847	if iso ==	554	& year==	2006
replace	AvgS_ImmPol	=	0.460412711	if iso ==	554	& year==	2016
replace	AvgS_ImmPol	=	0.365141392	if iso ==	578	& year==	1985
replace	AvgS_ImmPol	=	0.334747016	if iso ==	578	& year==	1990
replace	AvgS_ImmPol	=	0.313950896	if iso ==	578	& year==	1996
replace	AvgS_ImmPol	=	0.339211315	if iso ==	578	& year==	2006
replace	AvgS_ImmPol	=	0.35887897	if iso ==	578	& year==	2016
replace	AvgS_ImmPol	=	0.46423611	if iso ==	724	& year==	1985
replace	AvgS_ImmPol	=	0.446656764	if iso ==	724	& year==	1990
replace	AvgS_ImmPol	=	0.342926592	if iso ==	724	& year==	1996
replace	AvgS_ImmPol	=	0.34785217	if iso ==	724	& year==	2006
replace	AvgS_ImmPol	=	0.365051597	if iso ==	724	& year==	2016
replace	AvgS_ImmPol	=	0.348418891	if iso ==	752	& year==	1985
replace	AvgS_ImmPol	=	0.431380212	if iso ==	752	& year==	1990
replace	AvgS_ImmPol	=	0.372178823	if iso ==	752	& year==	1996
replace	AvgS_ImmPol	=	0.34739086	if iso ==	752	& year==	2006
replace	AvgS_ImmPol	=	0.364663929	if iso ==	752	& year==	2016
replace	AvgS_ImmPol	=	0.359598219	if iso ==	756	& year==	1985
replace	AvgS_ImmPol	=	0.351481885	if iso ==	756	& year==	1990
replace	AvgS_ImmPol	=	0.347092003	if iso ==	756	& year==	1996
replace	AvgS_ImmPol	=	0.354290664	if iso ==	756	& year==	2006
replace	AvgS_ImmPol	=	0.354513884	if iso ==	756	& year==	2016
replace	AvgS_ImmPol	=	0.34221229	if iso ==	826	& year==	1985
replace	AvgS_ImmPol	=	0.360406756	if iso ==	826	& year==	1990
replace	AvgS_ImmPol	=	0.390585303	if iso ==	826	& year==	1996
replace	AvgS_ImmPol	=	0.429308534	if iso ==	826	& year==	2006
replace	AvgS_ImmPol	=	0.498275816	if iso ==	826	& year==	2016
replace	AvgS_ImmPol	=	0.418454856	if iso ==	840	& year==	1985
replace	AvgS_ImmPol	=	0.355682045	if iso ==	840	& year==	1990
replace	AvgS_ImmPol	=	0.373673111	if iso ==	840	& year==	1996
replace	AvgS_ImmPol	=	0.411396325	if iso ==	840	& year==	2006
replace	AvgS_ImmPol	=	0.413033247	if iso ==	840	& year==	2016

gen	wdi_unempilo	=	.
replace	wdi_unempilo	=	.	if iso ==	36	& year==	1985
replace	wdi_unempilo	=	.	if iso ==	36	& year==	1990
replace	wdi_unempilo	=	8.5059996	if iso ==	36	& year==	1996
replace	wdi_unempilo	=	4.7820001	if iso ==	36	& year==	2006
replace	wdi_unempilo	=	5.7379999	if iso ==	36	& year==	2016
replace	wdi_unempilo	=	.	if iso ==	124	& year==	1985
replace	wdi_unempilo	=	.	if iso ==	124	& year==	1990
replace	wdi_unempilo	=	9.6000004	if iso ==	124	& year==	1996
replace	wdi_unempilo	=	6.3000002	if iso ==	124	& year==	2006
replace	wdi_unempilo	=	7.073	if iso ==	124	& year==	2016
replace	wdi_unempilo	=	.	if iso ==	246	& year==	1985
replace	wdi_unempilo	=	.	if iso ==	246	& year==	1990
replace	wdi_unempilo	=	15.572	if iso ==	246	& year==	1996
replace	wdi_unempilo	=	7.7189999	if iso ==	246	& year==	2006
replace	wdi_unempilo	=	8.9969997	if iso ==	246	& year==	2016
replace	wdi_unempilo	=	.	if iso ==	250	& year==	1985
replace	wdi_unempilo	=	.	if iso ==	250	& year==	1990
replace	wdi_unempilo	=	12.845	if iso ==	250	& year==	1996
replace	wdi_unempilo	=	8.9359999	if iso ==	250	& year==	2006
replace	wdi_unempilo	=	9.9650002	if iso ==	250	& year==	2016
replace	wdi_unempilo	=	.	if iso ==	276	& year==	1985
replace	wdi_unempilo	=	.	if iso ==	276	& year==	1990
replace	wdi_unempilo	=	8.8249998	if iso ==	276	& year==	1996
replace	wdi_unempilo	=	10.25	if iso ==	276	& year==	2006
replace	wdi_unempilo	=	4.3109999	if iso ==	276	& year==	2016
replace	wdi_unempilo	=	.	if iso ==	372	& year==	1985
replace	wdi_unempilo	=	.	if iso ==	372	& year==	1990
replace	wdi_unempilo	=	11.717	if iso ==	372	& year==	1996
replace	wdi_unempilo	=	4.415	if iso ==	372	& year==	2006
replace	wdi_unempilo	=	8.0889997	if iso ==	372	& year==	2016
replace	wdi_unempilo	=	.	if iso ==	380	& year==	1985
replace	wdi_unempilo	=	.	if iso ==	380	& year==	1990
replace	wdi_unempilo	=	11.874	if iso ==	380	& year==	1996
replace	wdi_unempilo	=	6.777	if iso ==	380	& year==	2006
replace	wdi_unempilo	=	11.541	if iso ==	380	& year==	2016
replace	wdi_unempilo	=	.	if iso ==	392	& year==	1985
replace	wdi_unempilo	=	.	if iso ==	392	& year==	1990
replace	wdi_unempilo	=	3.4000001	if iso ==	392	& year==	1996
replace	wdi_unempilo	=	4.0999999	if iso ==	392	& year==	2006
replace	wdi_unempilo	=	3.1359999	if iso ==	392	& year==	2016
replace	wdi_unempilo	=	.	if iso ==	554	& year==	1985
replace	wdi_unempilo	=	.	if iso ==	554	& year==	1990
replace	wdi_unempilo	=	6.2979999	if iso ==	554	& year==	1996
replace	wdi_unempilo	=	3.8499999	if iso ==	554	& year==	2006
replace	wdi_unempilo	=	5.2459998	if iso ==	554	& year==	2016
replace	wdi_unempilo	=	.	if iso ==	578	& year==	1985
replace	wdi_unempilo	=	.	if iso ==	578	& year==	1990
replace	wdi_unempilo	=	5.0359998	if iso ==	578	& year==	1996
replace	wdi_unempilo	=	3.3989999	if iso ==	578	& year==	2006
replace	wdi_unempilo	=	4.8060002	if iso ==	578	& year==	2016
replace	wdi_unempilo	=	.	if iso ==	724	& year==	1985
replace	wdi_unempilo	=	.	if iso ==	724	& year==	1990
replace	wdi_unempilo	=	22.142	if iso ==	724	& year==	1996
replace	wdi_unempilo	=	8.4519997	if iso ==	724	& year==	2006
replace	wdi_unempilo	=	19.447001	if iso ==	724	& year==	2016
replace	wdi_unempilo	=	.	if iso ==	752	& year==	1985
replace	wdi_unempilo	=	.	if iso ==	752	& year==	1990
replace	wdi_unempilo	=	9.5469999	if iso ==	752	& year==	1996
replace	wdi_unempilo	=	7.066	if iso ==	752	& year==	2006
replace	wdi_unempilo	=	7.0929999	if iso ==	752	& year==	2016
replace	wdi_unempilo	=	.	if iso ==	756	& year==	1985
replace	wdi_unempilo	=	.	if iso ==	756	& year==	1990
replace	wdi_unempilo	=	3.7049999	if iso ==	756	& year==	1996
replace	wdi_unempilo	=	4	if iso ==	756	& year==	2006
replace	wdi_unempilo	=	4.5830002	if iso ==	756	& year==	2016
replace	wdi_unempilo	=	.	if iso ==	826	& year==	1985
replace	wdi_unempilo	=	.	if iso ==	826	& year==	1990
replace	wdi_unempilo	=	8.1920004	if iso ==	826	& year==	1996
replace	wdi_unempilo	=	5.3499999	if iso ==	826	& year==	2006
replace	wdi_unempilo	=	4.849	if iso ==	826	& year==	2016
replace	wdi_unempilo	=	.	if iso ==	840	& year==	1985
replace	wdi_unempilo	=	.	if iso ==	840	& year==	1990
replace	wdi_unempilo	=	5.4000001	if iso ==	840	& year==	1996
replace	wdi_unempilo	=	4.5999999	if iso ==	840	& year==	2006
replace	wdi_unempilo	=	4.9060001	if iso ==	840	& year==	2016

gen	unemp_CPDS	=	.
replace	unemp_CPDS	=	8.258135796	if iso ==	36	& year==	1985
replace	unemp_CPDS	=	6.925963879	if iso ==	36	& year==	1990
replace	unemp_CPDS	=	8.506212234	if iso ==	36	& year==	1996
replace	unemp_CPDS	=	4.782290936	if iso ==	36	& year==	2006
replace	unemp_CPDS	=	5.723928452	if iso ==	36	& year==	2016
replace	unemp_CPDS	=	10.64446259	if iso ==	124	& year==	1985
replace	unemp_CPDS	=	8.131444931	if iso ==	124	& year==	1990
replace	unemp_CPDS	=	9.619827271	if iso ==	124	& year==	1996
replace	unemp_CPDS	=	6.320348263	if iso ==	124	& year==	2006
replace	unemp_CPDS	=	6.99407959	if iso ==	124	& year==	2016
replace	unemp_CPDS	=	4.900000095	if iso ==	246	& year==	1985
replace	unemp_CPDS	=	3.200000048	if iso ==	246	& year==	1990
replace	unemp_CPDS	=	14.60000038	if iso ==	246	& year==	1996
replace	unemp_CPDS	=	7.699999809	if iso ==	246	& year==	2006
replace	unemp_CPDS	=	8.800000191	if iso ==	246	& year==	2016
replace	unemp_CPDS	=	8.699999809	if iso ==	250	& year==	1985
replace	unemp_CPDS	=	7.900000095	if iso ==	250	& year==	1990
replace	unemp_CPDS	=	10.5	if iso ==	250	& year==	1996
replace	unemp_CPDS	=	8.800000191	if iso ==	250	& year==	2006
replace	unemp_CPDS	=	10.10000038	if iso ==	250	& year==	2016
replace	unemp_CPDS	=	7.2	if iso ==	276	& year==	1985
replace	unemp_CPDS	=	4.8	if iso ==	276	& year==	1990
replace	unemp_CPDS	=	8.899999619	if iso ==	276	& year==	1996
replace	unemp_CPDS	=	10.10000038	if iso ==	276	& year==	2006
replace	unemp_CPDS	=	4.099999905	if iso ==	276	& year==	2016
replace	unemp_CPDS	=	16.79999924	if iso ==	372	& year==	1985
replace	unemp_CPDS	=	13.39999962	if iso ==	372	& year==	1990
replace	unemp_CPDS	=	11.69999981	if iso ==	372	& year==	1996
replace	unemp_CPDS	=	4.800000191	if iso ==	372	& year==	2006
replace	unemp_CPDS	=	8.399999619	if iso ==	372	& year==	2016
replace	unemp_CPDS	=	8.199999809	if iso ==	380	& year==	1985
replace	unemp_CPDS	=	8.899999619	if iso ==	380	& year==	1990
replace	unemp_CPDS	=	11.19999981	if iso ==	380	& year==	1996
replace	unemp_CPDS	=	6.800000191	if iso ==	380	& year==	2006
replace	unemp_CPDS	=	11.69999981	if iso ==	380	& year==	2016
replace	unemp_CPDS	=	2.599999905	if iso ==	392	& year==	1985
replace	unemp_CPDS	=	2.099999905	if iso ==	392	& year==	1990
replace	unemp_CPDS	=	3.400000095	if iso ==	392	& year==	1996
replace	unemp_CPDS	=	4.099999905	if iso ==	392	& year==	2006
replace	unemp_CPDS	=	3.099999905	if iso ==	392	& year==	2016
replace	unemp_CPDS	=	3.614461899	if iso ==	554	& year==	1985
replace	unemp_CPDS	=	8.282064438	if iso ==	554	& year==	1990
replace	unemp_CPDS	=	6.101715088	if iso ==	554	& year==	1996
replace	unemp_CPDS	=	3.640634537	if iso ==	554	& year==	2006
replace	unemp_CPDS	=	5.117845058	if iso ==	554	& year==	2016
replace	unemp_CPDS	=	2.599999905	if iso ==	578	& year==	1985
replace	unemp_CPDS	=	5.199999809	if iso ==	578	& year==	1990
replace	unemp_CPDS	=	4.699999809	if iso ==	578	& year==	1996
replace	unemp_CPDS	=	3.400000095	if iso ==	578	& year==	2006
replace	unemp_CPDS	=	4.699999809	if iso ==	578	& year==	2016
replace	unemp_CPDS	=	17.79999924	if iso ==	724	& year==	1985
replace	unemp_CPDS	=	15.5	if iso ==	724	& year==	1990
replace	unemp_CPDS	=	19.89999962	if iso ==	724	& year==	1996
replace	unemp_CPDS	=	8.5	if iso ==	724	& year==	2006
replace	unemp_CPDS	=	19.60000038	if iso ==	724	& year==	2016
replace	unemp_CPDS	=	3.599999905	if iso ==	752	& year==	1985
replace	unemp_CPDS	=	2.400000095	if iso ==	752	& year==	1990
replace	unemp_CPDS	=	10.69999981	if iso ==	752	& year==	1996
replace	unemp_CPDS	=	7.099999905	if iso ==	752	& year==	2006
replace	unemp_CPDS	=	6.900000095	if iso ==	752	& year==	2016
replace	unemp_CPDS	=	0.886441827	if iso ==	756	& year==	1985
replace	unemp_CPDS	=	0.468913496	if iso ==	756	& year==	1990
replace	unemp_CPDS	=	3.483596325	if iso ==	756	& year==	1996
replace	unemp_CPDS	=	3.803736448	if iso ==	756	& year==	2006
replace	unemp_CPDS	=	4.311520576	if iso ==	756	& year==	2016
replace	unemp_CPDS	=	11.19999981	if iso ==	826	& year==	1985
replace	unemp_CPDS	=	6.900000095	if iso ==	826	& year==	1990
replace	unemp_CPDS	=	7.900000095	if iso ==	826	& year==	1996
replace	unemp_CPDS	=	5.400000095	if iso ==	826	& year==	2006
replace	unemp_CPDS	=	4.800000191	if iso ==	826	& year==	2016
replace	unemp_CPDS	=	7.199999809	if iso ==	840	& year==	1985
replace	unemp_CPDS	=	5.599999905	if iso ==	840	& year==	1990
replace	unemp_CPDS	=	5.400000095	if iso ==	840	& year==	1996
replace	unemp_CPDS	=	4.599999905	if iso ==	840	& year==	2006
replace	unemp_CPDS	=	4.900000095	if iso ==	840	& year==	2016

gen unempl=.
replace unempl= wdi_unempilo
replace unempl= unemp_CPDS if year==1985
replace unempl= unemp_CPDS if year==1990


************************************************************************

gen msample=.
reg jobs oldage unemp redincd  marital wrkst  size age educat sex /// attend
	unemprr sickrr pensionrr gov_party AvgS_ImmPol migstock  unempl
replace msample=1 if e(sample)

cap drop socpol
factor jobs oldage unemp redincd, pcf, if msample==1
rotate
predict socpol, regress

gen cy= iso*10000+year
label variable cy "Country years"


sum socpol
gen socpol2=socpol-r(min) 
sum socpol2
replace socpol2=socpol2/r(max) 
replace socpol2=socpol2*5
pwcorr socpol2 socpol 

gen socpol3=.
replace socpol3= (jobs+oldage+unemp+redincd)
replace socpol3=socpol3-4

reg socpol2 socpol3 jobs oldage unemp redincd marital wrkst  size age educat sex unemprr sickrr pensionrr  migstock gov_party AvgS_ImmPol pc5_gdp_oecd net_mig_un_5y unempl iso year
gen sample=.
replace sample=1 if e(sample)

*PI additions
replace socpol3 = (socpol3/2.601746)*0.48
replace net_mig_un_5y = net_mig_un_5y/10
* recode DVs so that support = higher values
recode jobs oldage unemp redincd (1=4)(2=3)(3=2)(4=1)
replace socpol3 = socpol3*-1

//

local i=1
local x=6
foreach var in jobs unemp redincd oldage socpol3 {
	qui mixed `var' i.marital i.wrkst size age i.educat i.sex /// 
	unemprr sickrr pensionrr gov_party AvgS_ImmPol  migstock pc5_gdp_oecd  net_mig_un_5y  unempl i.iso ib1990.year /// 
	|| cy:, var , if sample==1
	margins, dydx (migstock) saving ("t7m`i'",replace)
	margins, dydx (net_mig_un_5y) saving("t7m`x'",replace)
	tab iso year if e(sample)==1
loc i=`i'+1
loc x=`x'+1
}

use t7m1,clear
foreach x of numlist 2/10{
	append using t7m`x'
}
gen f = [_n]
gen factor = "Immigrant Stock" 
replace factor = "Immigrant Flow, 1-year" if f>5

clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
	
gen id = "t7m1"
foreach i of numlist 2/10{
replace id = "t7m`i'" if f==`i'
}
order factor AME lower upper id
keep factor AME lower upper id
save team7, replace
foreach i of numlist 1/10{
	erase "t7m`i'.dta"
}
erase "ISSP_merged.dta"
erase "issp_ansample.dta"


}
*==============================================================================*
*==============================================================================*
*==============================================================================*

































// TEAM 8
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*
capture confirm file "team8.dta"
	if _rc==0 {
		display "Team 8 already exists, skipping to next code chunk"
	}
else {
version 15
* Open the 2006 ISSP
use "ZA4700.dta", clear

* Keep only necessary vars
keep V3a V25 V27 V28 V30 V31 V33 sex age degree wrkst wrkhrs *_DEGR

* Rename similar vars
rename V25 govresp_jobs
rename V27 govresp_health
rename V28 govresp_oldage
rename V30 govresp_unempl
rename V31 govresp_inequal
rename V33 govresp_housing
gen year = 2006

* Store for later use
compress
tempfile tempo06
save "`tempo06'"

* Open the 1996 ISSP
use "ZA2900.dta", clear

* Keep only necessary vars
keep v3 v36 v38 v39 v41 v42 v44 v200 v201 v205 v206 v215

* Rename similar vars
rename v36 govresp_jobs
rename v38 govresp_health
rename v39 govresp_oldage
rename v41 govresp_unempl
rename v42 govresp_inequal
rename v44 govresp_housing
rename v200 sex
rename v201 age
rename v206 wrkst
rename v215 wrkhrs
gen year = 1996

* Rename labels to avoid conflicts when appending
* really got me confused at one point
foreach var of varlist _all {
	if "`:value label `var''" != "" {
		label copy `:value label `var'' `:value label `var''_06, replace
		lab val `var' `:value label `var''_06
	}
}


* Store for later use
compress
tempfile tempo96
save "`tempo96'"


* Open 2016 ISSP
use "ZA6900_v2-0-0.dta", clear

keep country v21 v23 v24 v26 v27 v29 SEX AGE DK_AGE WRKHRS MAINSTAT *DEGR*
rename _all, low

rename v21 govresp_jobs
rename v23 govresp_health
rename v24 govresp_oldage
rename v26 govresp_unempl // N/A for Georgia, but we drop it anyway
rename v27 govresp_inequal
rename v29 govresp_housing

// In 2016, numeric values are used for missings, recode to missing
//fre govresp*
mvdecode govresp*, mv(0 8 9 = .)

//fre sex
mvdecode sex, mv(9 = .)

//fre age
mvdecode age, mv(999 = .)

//fre dk_age // Replace age with midpoints of categories for DK
		   // Numeric value already is the midpoint (and 70 for > 65)
replace age = dk_age if inrange(dk_age, 20, 80)
drop dk_age

//fre wrkhrs
mvdecode wrkhrs, mv(98 99 = .)

//fre mainstat
mvdecode mainstat, mv(99 = .)

* Degree variables
rename *degr* =16

// Country-specific degree vars
foreach var of varlist *_degr16 {
	sum `var', meanonly
	//if r(max) < 90 fre `var'
}
// -> The ones w/ max < 90 have no missings (except code 0)
mvdecode *_degr16, mv(0 90/99 = .)

// Main degree variable
//fre  degree16
mvdecode degree16, mv(9 = .)

* Rename labels to avoid conflicts when appending
foreach var of varlist _all {
	if "`:value label `var''" != "" {
		label copy `:value label `var'' `:value label `var''_16, replace
		label drop `:value label `var''
		lab val `var' `:value label `var''_16
	}
}

gen year = 2016

* Append earlier waves
append using "`tempo06'"
append using "`tempo96'"

* cntry identifier
gen cntry = V3a if year == 2006
// Recode country identifier from 1996 to match that from 2006
// Countries that did not participate in 1996 will be dropped anyway
recode v3 (1 = 36) (2 3 = 276) (4 = 826) (6 = 840) (8 = 348) (9 = 9) (10 = 372) ///
(12 = 578) (13 = 752) (14 = 203) (15 = 705) (16 = 616) (17 = 17) (18 = 643) ///
(19 = 554) (20 = 124) (21 = 608) (22 23 = 376) (24 = 392) (25 = 724) (26 = 428) ///
(27 = 250) (28 = 28) (30 = 756)
replace cntry = v3 if year == 1996
lab val cntry V3A
// Country from 2006

// -> Consistent
replace cntry = country if year == 2016
drop v3 V3a country


* Restrict to rich welfare states (Israel added to Brady/Finigan sample)
* Australia, Canada, France, Germany, Ireland, Israel, Japan, New Zealand,
* Norway, Spain, Sweden, Switzerland, GB, US
* These also happen to be the cases with net immigration values for both waves

keep if cntry==36 | /// Australia
		cntry==124 | /// Canada
		cntry==250 | /// France
		cntry==276 | /// Germany
		cntry==372 | /// Ireland
		cntry==376 | /// Israel
		cntry==392 | /// Japan
		cntry==554 | /// New Zealand
		cntry==578 | /// Norway
		cntry==724 | /// Spain
		cntry==752 | /// Sweden
		cntry==756 | /// Switzerland
		cntry==826 | /// Great Britain
		cntry==840   // United States

// Generate a string version of country variable & ISO code
gen cntrystr = ""
numlabel V3A, remove
levelsof cntry, local(cntries)
foreach cntry of local cntries {
	replace cntrystr = "`: label V3A `cntry''" if cntry == `cntry'
}

gen iso3166 = substr(cntrystr, 1, 2)
replace cntrystr = regexr(cntrystr, "[a-zA-Z]+-", "")

//--------------------------
// Dependent variables (government responsibility for X)
//--------------------------

* We want cases to be complete wrt to all government responsibility variables
* (consistent sample for comparisons across DVs)
foreach var of varlist govresp* {
	drop if mi(`var')
}

// PCA of the depvars (overall support for government intervention)
pca govresp*, blanks(0.3)
predict govresp_overall
replace govresp_overall = `r(max)' - govresp_overall
lab var govresp_overall "Overall welfare state support"

*PI adjustment
replace govresp_overall = ((govresp_overall-6.779999)/1.748702)*0.48


* Dichotomize depvars
recode govresp* (1 2 = 1) (3 4 = 0)


* Generate the controls
* Age
mvdecode age, mv(999 = .)

* Sex/female dummy
gen female = sex
recode female (1 = 0) (2 = 1) (nonmissing = .)
lab var female "Female"

* Employment status for 96/06 - as in replication
// Target variable has categories
// 1 "Fulltime" 2 "Parttime" 3 "Unemployed" 4 "Inactive"
// Helping family members should also be treated as employed
// --> Assign them to FT vs. PT based on wrkhrs
gen emplstat = wrkst
recode emplstat (1 = 1) (2/3 = 2) (5 = 3) (6/10 = 4)
lab def emplstat 1 "Fulltime" 2 "Parttime" 3 "Unemployed" 4 "Inactive"
table emplstat if emplstat <= 2, c(mean wrkhrs p10 wrkhrs p50 wrkhrs p80 wrkhrs p90 wrkhrs)

// Now deal with helping family members
lab val emplstat emplstat
// Some part-timers work quite long hours, but conventionalk cut-off of 35 seems reasonable
replace emplstat = 1 if wrkst == 4 & inrange(wrkhrs, 35, .)
replace emplstat = 2 if wrkst == 4 & wrkhrs < 35

// Check

replace emplstat = . if emplstat == 4 & wrkst == 4
gen mi_whrs = mi(wrkhrs)
drop mi_whrs

replace emplstat = 1 if inlist(emplst, 1, 2) & inrange(wrkhrs, 35, .)
replace emplstat = 2 if inlist(emplst, 1, 2) & wrkhrs < 35

// Now add 2016

replace emplstat = 1 if mainstat == 1 & inrange(wrkhrs, 35, .)
replace emplstat = 2 if mainstat == 1 & wrkhrs > 0 & wrkhrs < 35
replace emplstat = 3 if mainstat == 2
replace emplstat = 4 if inrange(mainstat, 3, 9)



* Education
gen edu_bradfin = degree if year == 2006
recode edu_bradfin (0 = 1) (1/3 = 2) (4/5 = 3)
gen edu = degree if year == 2006
recode edu (0/1 = 1) (2/3 = 2) (4/5 = 3)
drop *_DEGR

recode v205 (1/3 = 1) (4/5 = 2) (6/7 = 3), gen(temp)
replace edu_bradfin = temp if year == 1996
drop temp

recode v205 (1/4 = 1) (5 = 2) (6/7 = 3)
replace edu = v205 if year == 1996
drop v205

recode degree16 (0/1 = 1) (2/4 = 2) (5/6 = 3), gen(temp)
replace edu_bradfin = temp if year == 2016
drop temp

recode degree16 (0/2 = 1) (3/4 = 2) (5/6 = 3)
replace edu = degree16 if year == 2016
drop degree16

lab def edu_bradfin 1 "Primary or less" 2 "Secondary" 3 "University or more"
lab val edu_bradfin edu_bradfin

lab def edu 1 "Less than upper sec." 2 "Upper sec." 3 "Tertiary"
lab val edu edu

* merge cntry data
preserve
insheet using "cri_macro.csv",delimiter(,) n clear

//Labeling
lab var gdp_oecd "GDP PPP 2016 $US"
lab var gdp_wb "GDP PPP 2017 $US"
lab var gdp_twn "gdp_twn	GDP PPP 2017 $US"
lab var gni_wb "GNI PPP 2017 $Intl"
lab var ginid_solt "Gini disposable income, average (post fisc)"
lab var ginim_dolt "Gini market inc., avg (pre fisc, before transfers incl. state pensions)"
lab var gini_wb "Gini (probably based on disposable inc)"
notes gini_wb: Unclear and varying methods, based on "income" or "consumption" data, this suggests that the standard is disposable income
lab var gini_wid "Gini, pre-tax, taxable inc. (includes government transfers considered inc.)"
lab var top10_wid "share of taxable inc. in top 10%, pre-tax (incl. gov inc. transfers)"
lab var mcp "Multiculturalism Policy Index, variable Total Policy"
lab var migstock_wb "% foreign-born or foreign of total pop, interpolated 5 years"
notes migstock_wb: not perfectly comparable by country
lab var migstock_un "% foreign-born or foreign of total pop"
notes migstock_un: not perfectly comparable by country
lab var migstock_oecd "Percent foreign-born (directly comprable)"
lab var mignet_un "Net migration (interpolated over 5-year estimates)"
notes mignet_un: number of immigrants minus emigrants, expressed at a per 1,000 inhabitants rate
lab var pop_wb "total population"
lab var al_ethnic "Alesina's ethnic fractionalization index"
lab var dpi_tf "Database of Political Institutions, ethnic fractionalization index"
lab var wdi_empprilo "World Development Indicators, employment to total population ratio, 15+"
lab var wdi_unempilo "World Development Indicators, unemployment percent of active population 15+"
lab var socx_oecd "Public social welfare expenditures as a percentage of GDP"
notes socx_oecd: 5-year interpolation prior to 2010

//change socx to numerical variable; there are Excel errors in the variable, but these pertain to Mexico (not in our sample)
destring socx_oecd,replace ignore(. .. #VALUE!)
replace socx_oecd = socx_oecd/10

//for Japan and New Zealand we don't have SOCX for 2016, so we use the last available year
xtset iso_country year
clonevar socx_oecd_avail = socx_oecd
notes socx_oecd_avail: last available years for J (2013) and NZ (2015)
replace socx_oecd_avail =  l1.socx_oecd if iso_country==554 & year == 2016
replace socx_oecd_avail =  l3.socx_oecd if iso_country==392 & year == 2016

//lag immigration stock one year
xtset iso_country year

foreach var in wb un oecd {
	gen migstock_`var'_lag = l1.migstock_`var'
	local l`var' : variable label migstock_`var'
	lab var migstock_`var'_lag "`l`var'' 1 year lag"
	}

//rename for matching
rename iso_country cntry

compress

save "L2data_ext.dta" , replace
restore

//for migration stock, values are lagged one year, for other level-2 variables no lag

keep govresp_* cntry year female age emplstat edu
compress
merge m:1 cntry year using "L2data_ext.dta",nogen keep(3) keepusing(wdi_empprilo socx_oecd socx_oecd_avail migstock_oecd_lag migstock_un_lag migstock_wb_lag)

drop migstock_oecd_lag migstock_wb_lag

//compare with old level 2 measures

merge m:1 cntry year using "L2data.dta",nogen keep(1 3)

lab var foreignpct "Foreign Born Stock (% of pop)"
lab var socx "Social Welfare Expenditures (% of GDP, last available)"
lab var emprate "Employment Rate (% in LF)"

* Generate country-year for clustering
egen cntryear = group(cntry year)

* Listwise deletion on predictors
foreach var in female age edu emplstat year foreignpct socx emprate {
	drop if `var' == .
}

*** PREFERED MODEL: RE, FOREIGNPCT, GOVRESP_OVERALL, s=1
qui mixed govresp_overall female age c.age##c.age b2.edu b1.emplstat i.year foreignpct socx emprate || cntry: || cntryear:   
margins,dydx(foreignpct) saving("team8",replace)

use team8,clear
gen factor = "Immigrant Stock" 
clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
gen id = "t8m1"
order factor AME lower upper id
keep factor AME lower upper id
save team8, replace

erase L2data_ext.dta
erase 04-dataprep_extension.dta

}
*==============================================================================*
*==============================================================================*
*==============================================================================*
































// TEAM 10
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team10.dta"
	if _rc==0 {
		display "Team 10 already exists, skipping to next code chunk"
	}
else {
version 15

//ISSP 1996
use "ZA2900.dta", clear

gen year=1996
gen country=""
replace country="Australia" if v3==1
replace country="Germany" if v3==2 | v3==3
replace country="United Kingdom" if v3==4
replace country="United States" if v3==6	
replace country="Ireland" if v3==10
replace country="Norway" if v3==12
replace country="Sweden" if v3==13
replace country="New Zealand" if v3==19
replace country="Canada" if v3==20
replace country="Japan" if v3==24
replace country="Spain" if v3==25
replace country="France" if v3==27
replace country="Switzerland" if v3==30

//DV

recode v39 1/2=1 3/4=0, gen(gr_old)
recode v41 1/2=1 3/4=0, gen(gr_unemp)
recode v42 1/2=1 3/4=0, gen(gr_inc)
recode v36 1/2=1 3/4=0, gen(gr_jobs)
recode v44 1/2=1 3/4=0, gen(gr_house)
recode v38 1/2=1 3/4=0, gen(gr_health)

//Ind. controls

gen age=v201
gen age_sq=age*age
recode v200 2=1 1=0, gen(female)
recode v205 1=. 2/3=1 4/7=0,gen(edu_primary)
recode v206 (1=0) (2/3=1) (4 6 7 8 9 10=2) (5=3) , gen(occ_notact) //1=part 2= not act 3= unemp

recode v223 6/7=., gen(lrscale)

keep  year-lrscale 

saveold ISSP96.dta, replace

//ISSP 2006
use "ZA4700.dta", clear

gen year=2006
gen country=""
replace country="Australia" if V3==36
replace country="Germany" if V3==276.1 | V3==276.2
replace country="United Kingdom" if V3==826.1
replace country="United States" if V3==840	
replace country="Ireland" if V3==372
replace country="Norway" if V3==578
replace country="Sweden" if V3==752
replace country="New Zealand" if V3==554
replace country="Canada" if V3==124
replace country="Japan" if V3==392
replace country="Spain" if V3==724
replace country="France" if V3==250
replace country="Switzerland" if V3==756

//DV

recode V28 1/2=1 3/4=0, gen(gr_old)
recode V30 1/2=1 3/4=0, gen(gr_unemp)
recode V31 1/2=1 3/4=0, gen(gr_inc)
recode V25 1/2=1 3/4=0, gen(gr_jobs)
recode V33 1/2=1 3/4=0, gen(gr_house)
recode V27 1/2=1 3/4=0, gen(gr_health)

//Ind. controls

rename age age2
gen age=age2
gen age_sq=age*age
recode sex 2=1 1=0, gen(female)
recode degree 0/1=1 2/5=0,gen(edu_primary)
recode wrkst (1=0) (2/3=1) (4 6 7 8 9 10=2) (5=3), gen(occ_notact) //1=part 2= not act 3= unemp
recode PARTY_LR 6/7=., gen(lrscale)

keep  year-lrscale 

saveold ISSP06.dta, replace

//ISSP 2016
use "ZA6900_v2-0-0.dta", clear

gen year=2016
rename country V3
gen country=""
replace country="Australia" if V3==36
replace country="Germany" if V3==276
replace country="United Kingdom" if V3==826
replace country="United States" if V3==840	
replace country="Ireland" if V3==372 // no Ireland
replace country="Norway" if V3==578
replace country="Sweden" if V3==752
replace country="New Zealand" if V3==554
replace country="Canada" if V3==124 //no Canada
replace country="Japan" if V3==392
replace country="Spain" if V3==724
replace country="France" if V3==250
replace country="Switzerland" if V3==756

//DV

recode v18 1/2=1 3/4=0 5/10=., gen(gr_old)
recode v19 1/2=1 3/4=0 5/10=., gen(gr_unemp)
recode v27 1/2=1 3/4=0 5/10=., gen(gr_inc)
recode v21 1/2=1 3/4=0 5/10=., gen(gr_jobs)
recode v29 1/2=1 3/4=0, gen(gr_house)
recode v23 1/2=1 3/4=0, gen(gr_health)

//Ind. controls

recode AGE 999=., gen(age)
gen age_sq=age*age
recode SEX 2=1 1=0 9=., gen(female)
recode DEGREE 0/1=1 2/6=0 9=.,gen(edu_primary)

gen occ_notact=.
replace occ_notact=1 if (EMPREL>0 & EMPREL<=4) //part-time
replace occ_notact=0 if (EMPREL>0 & EMPREL<=4) & (WRKHRS>=35 & WRKHRS<=96)
replace occ_notact=2 if WORK==2 | WORK==3
replace occ_notact=3 if MAINS==2 
replace occ_notact=. if WORK ==9

recode PARTY_LR 6/7=., gen(lrscale)


keep  year-lrscale 

saveold ISSP16.dta, replace


*MACRO DATA
import excel "cri_macro.xlsx", sheet("cri_macro") clear firstrow 

keep if year==1996 | year==2006 | year==2016 | year==2015 | year==1986

destring gdp_wb, replace
destring wdi_empprilo, replace 
replace socx_oecd="" if socx_oecd==".."
destring socx_oecd, replace
destring mignet_un, replace
destring migstock_un, replace 
destring migstock_wb, replace

keep year country gdp_wb wdi_empprilo socx_oecd migstock_un 
saveold macro_1.dta, replace

import excel "cri_macro.xlsx", sheet("cri_macro") clear firstrow 

keep if year==1996 | year==2006  | year==2015 | year==1986

destring mignet_un, replace
destring migstock_wb, replace

keep country year mignet_un migstock_wb 
reshape wide mignet_un migstock_wb, i(country) j(year)

rename mignet_un2015 mignet_un2016
rename migstock_wb2015 migstock_wb2016

gen diffmig1996=mignet_un1996-mignet_un1986
gen diffmig2006=mignet_un2006-mignet_un1996
gen diffmig2016=mignet_un2016-mignet_un2006

drop mignet_un1986 migstock_wb1986

reshape long  diffmig  mignet_un migstock_wb, i(country) j(year)

saveold macro_2.dta, replace


*MERGE AND ANALYSIS

use ISSP96.dta, clear
append using ISSP06.dta
append using ISSP16.dta

sort year country

merge m:1 year country using "macro_1.dta"

keep if _merge==3
drop _merge

merge m:1 year country using "macro_2.dta"

keep if _merge==3
drop _merge

//Recoding EU-status and country-year identifier 
gen eu=0
replace eu=1 if country=="Germany" | country=="United Kingdom" | country=="Ireland" | ///
country=="Sweden" | country=="Spain" | country=="France" 
gen euefta=0
replace euefta=1 if country=="Germany" | country=="United Kingdom" | country=="Ireland" | ///
country=="Sweden" | country=="Spain" | country=="France" | country=="Switzerland"  | country=="Norway" 

egen cid=group(country)

 tostring cid, gen(cids)
 tostring year, gen(years)
 gen cidyear= years+cids
 destring cidyear, replace
 codebook cidyear

//Analysis


*****
keep if eu==1
*****

*PI adjustment
recode gr_health gr_house (8 9=.)
//

//Mig stock
qui mixed gr_jobs  age age_sq i.female i.edu_primary i.occ_notact lrscale migstock_wb   gdp_wb wdi_empprilo socx_oecd i.cid i.year ||cidyear: , vce(r)
margins, dydx (migstock_wb) saving ("t10m1",replace)
qui mixed gr_unemp  age age_sq i.female i.edu_primary i.occ_notact lrscale migstock_wb   gdp_wb wdi_empprilo socx_oecd i.cid i.year ||cidyear: , vce(r)
margins, dydx (migstock_wb) saving ("t10m2",replace)
qui mixed gr_inc  age age_sq i.female i.edu_primary i.occ_notact lrscale migstock_wb   gdp_wb wdi_empprilo socx_oecd i.cid i.year ||cidyear: , vce(r)
margins, dydx (migstock_wb) saving ("t10m3",replace)
qui mixed gr_old age age_sq i.female i.edu_primary i.occ_notact lrscale migstock_wb   gdp_wb wdi_empprilo socx_oecd i.cid i.year ||cidyear: , vce(r)
margins, dydx (migstock_wb) saving ("t10m4",replace)
qui mixed gr_house  age age_sq i.female i.edu_primary i.occ_notact lrscale migstock_wb   gdp_wb wdi_empprilo socx_oecd i.cid i.year ||cidyear: , vce(r)
margins, dydx (migstock_wb) saving ("t10m5",replace)
qui mixed gr_health age age_sq i.female i.edu_primary i.occ_notact lrscale migstock_wb   gdp_wb wdi_empprilo socx_oecd i.cid i.year ||cidyear: , vce(r)
margins, dydx (migstock_wb) saving ("t10m6",replace)



//Mig net change
qui mixed gr_jobs age age_sq i.female i.edu_primary i.occ_notact lrscale mignet_un   gdp_wb wdi_empprilo socx_oecd i.cid i.year ||cidyear: , vce(r)
margins, dydx (mignet_un) saving ("t10m7",replace)
qui mixed gr_unemp  age age_sq i.female i.edu_primary i.occ_notact lrscale mignet_un   gdp_wb wdi_empprilo socx_oecd i.cid i.year ||cidyear: , vce(r)
margins, dydx (mignet_un) saving ("t10m8",replace)
qui mixed gr_inc  age age_sq i.female i.edu_primary i.occ_notact lrscale mignet_un   gdp_wb wdi_empprilo socx_oecd i.cid i.year ||cidyear: , vce(r)
margins, dydx (mignet_un) saving ("t10m9",replace)
qui mixed gr_old age age_sq i.female i.edu_primary i.occ_notact lrscale mignet_un   gdp_wb wdi_empprilo socx_oecd i.cid i.year ||cidyear: , vce(r)
margins, dydx (mignet_un) saving ("t10m10",replace)
qui mixed gr_house  age age_sq i.female i.edu_primary i.occ_notact lrscale mignet_un   gdp_wb wdi_empprilo socx_oecd i.cid i.year ||cidyear: , vce(r)
margins, dydx (mignet_un) saving ("t10m11",replace)
qui mixed gr_health age age_sq i.female i.edu_primary i.occ_notact lrscale mignet_un   gdp_wb wdi_empprilo socx_oecd i.cid i.year ||cidyear: , vce(r)
margins, dydx (mignet_un) saving ("t10m12",replace)

use t10m1,clear
foreach i of numlist 2/12{
	append using "t10m`i'"
}

gen f = [_n]
gen factor = "Immigrant Stock" if f==1|f==2|f==3|f==4|f==5|f==6
replace factor ="Immigration Flow, 1-year" if f==7|f==8|f==9|f==10|f==11|f==12
clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
gen id = "t10m1"

*PI adjustment
replace AME = AME*10 if f>6
replace lower = lower*10 if f>6
replace upper = upper*10 if f>6
//

foreach i of numlist 2/12{
	replace id = "t10m`i'" if f==`i'
}
order factor AME lower upper id
keep factor AME lower upper id
save team10, replace

erase ISSP16.dta
erase ISSP06.dta
erase ISSP96.dta
erase macro_1.dta
erase macro_2.dta
foreach i of numlist 1/12{
	erase "t10m`i'.dta"
}

}
*==============================================================================*
*==============================================================================*
*==============================================================================*
























// TEAM 13
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*
*MLwiN used for analysis. This works up the data and imports their results.
capture confirm file "team13.dta"
	if _rc==0 {
		display "Team 13 already exists, skipping to next code chunk"
	}
else {

// ISSP 1996
use "ZA2900.dta", clear
gen year = 1996
gen id = _n // id values from 1 to 35,313 (= number of respondents)
replace id = 100000 + id // 100001 to 135313
sort id
save "t13.issp1996.dta", replace

// ISSP 2006
use "ZA4700.dta", clear
gen year = 2006
gen id = _n
replace id = 200000 + id
sort id
save "t13.issp2006.dta", replace

// MERGE FILES
use "t13.issp1996.dta", clear
merge 1:1 id using "t13.issp2006.dta"

* Create country ID variable
gen country =.
replace country =	1	if v3 ==	1   | V3a ==	36	                //	AU-Australia
replace country =	2	if v3 ==	20	| V3a ==	124	                //	CA-Canada
replace country =	3	if v3 ==	30	| V3a ==	756	                //	CH-Switzerland
replace country =	4	if v3 ==	2	| V3a ==	276	| v3 ==	2       //	DE-Germany
replace country =	5	if v3 ==	25	| V3a ==	724	                //	ES-Spain
replace country =	6	if v3 ==	27	| V3a ==	250	                //	FR-France
replace country =	7	if v3 ==	4	| V3a ==	826	                //	GB-Great Britain
replace country =	8	if v3 ==	10	| V3a ==	372	                //	IE-Ireland
replace country =	9	if v3 ==	24	| V3a ==	392	                //	JP-Japan
replace country =	10	if v3 ==	12	| V3a ==	578	                //	NO-Norway
replace country =	11	if v3 ==	19	| V3a ==	554	                //	NZ-New Zealand
replace country =	12	if v3 ==	13	| V3a ==	752              	//	SE-Sweden
replace country =	13	if v3 ==	6	| V3a ==	840	                //	US-United States

* Keep only the 13 countries in the dataset
drop if country ==.

//*******************************************************************************************
//** DEPENDENT VARIABLES
//*******************************************************************************************
// 1. Old age care
gen old_age = v39
replace old_age = V28 if old_age ==.
recode old_age (2=1) (3 4=0)

// 2. Unemployed
gen unemployed = v41
replace unemployed = V30 if unemployed ==.
recode unemployed (2=1) (3 4=0)

// 3. Reduce income differences
gen incdiff = v42
replace incdiff = V31 if incdiff ==.
recode incdiff (2=1) (3 4=0)

// 4. Jobs
gen jobs = v36
replace jobs = V25 if jobs ==.
recode jobs (2=1) (3 4=0)

//5. Housing
gen housing = V33
replace housing = v44 if housing ==.
recode housing (2=1) (3 4=0)

//6. Healthcare
gen health = v38
replace health = V27 if health ==.
recode health(2=1) (3 4=0)

//*******************************************************************************************
//** INDIVIDUAL CONTROL VARIABLES
//*******************************************************************************************
// Gender
gen female =.
replace female = 0 if v200 == 1 | sex == 1
replace female = 1 if v200 == 2 | sex == 2
*******************************************************************************************
// Age
gen ager=age
replace ager = v201 if year == 1996
drop age
*******************************************************************************************
// Age-squared
gen age2=age^2/100

*******************************************************************************************
// Education
gen edu1996 = v205 // Education 1996 wave: 1 - Primary or less, 2 - Secondary, 3 - University or more
recode edu1996 ( 1 2 3 = 1) (4 5 = 2) (6 7 =3)

gen edu2006 = degree // Education 2006 wave: 1- Primary or less, 2 - Secondary, 3 - University or more
recode edu2006 ( 0 1 = 1) (2 3 = 2) (4 5 =3)

// Dummy vars.
gen edu_prim = edu1996 // Primary education
replace edu_prim = 1 if edu2006 == 1
replace edu_prim = 0 if edu2006 == 2 | edu2006 == 3 | edu1996 == 2 | edu1996 == 3

gen edu_sec = edu1996 // Secondary education
replace edu_sec = 0 if edu2006 == 1 | edu2006 == 3 | edu1996 == 1 | edu1996 == 3
replace edu_sec = 1 if edu2006 == 2 | edu1996 == 2

gen edu_uni = edu1996 // University or more
replace edu_uni = 0 if edu2006 == 1 | edu2006 == 2 | edu1996 == 1 | edu1996 == 2
replace edu_uni = 1 if edu2006 == 3 | edu1996 == 3

*******************************************************************************************
// Employment status
gen empl= v206
replace empl = wrkst if empl ==.
recode empl(1=1) ( 2 3 = 2) (4 6 8 =3) (5 7 9 10 = 4)  

// Dummy variables
gen full_time = empl // Full-time employed
recode full_time (2  3 4 = 0)

gen part_time = empl // Part-time employed
recode part_time (1 3 4 = 0) (2 =1)

gen act_unempl = empl // Active unemployed
recode act_unempl (1 2 4 = 0) (3 =1)

gen not_active= empl // Not active
recode not_active (1 2 3 = 0) (4 =1)
*******************************************************************************************
// Relative income
gen income1 = v217
bysort v3: egen meaninc1=mean(income1)
bysort v3: egen sdinc1=sd(income1)
gen zinc1 = (income1-meaninc1)/sdinc1

gen income2 =.
replace income2 =AU_RINC if income2 ==.
replace income2 =CA_RINC if income2 ==.
replace income2 =CH_RINC if income2 ==.
replace income2 =DE_RINC if income2 ==.
replace income2 =ES_RINC if income2 ==.
replace income2 =FR_RINC if income2 ==.
replace income2 =GB_RINC if income2 ==.
replace income2 =IE_RINC if income2 ==.
replace income2 =JP_RINC if income2 ==.
replace income2 =NO_RINC if income2 ==.
replace income2 =NZ_RINC if income2 ==.
replace income2 =SE_RINC if income2 ==.
replace income2 =US_RINC if income2 ==.

bysort V3a: egen meaninc2=mean(income2)
bysort V3a: egen sdinc2=sd(income2)
gen zinc2 = (income2-meaninc2)/sdinc2

gen income= zinc1
replace income = zinc2 if income==.  // around 10.000 missing values (!!!)

*******************************************************************************************
// Dummy time variable
gen time=year
recode time (2006=1) (1996=0)
*******************************************************************************************
** DROP RESPONDENTS WITH MISSING VALUES ON THE INDIVIDUAL CONTROL VARIABLES
*******************************************************************************************
drop if ager==.
drop if female ==.
drop if edu_prim ==.
drop if empl==.
drop if income ==.
//*******************************************************************************************
//** INDEPENDENT COUNTRY-LEVEL VARIABLES
//*******************************************************************************************
// Immigrant stock
gen istock96 =.
replace istock96 =	21.29999924	if country ==	1	& year ==	1996
replace istock96 =	17.20000076	if country ==	2	& year ==	1996
replace istock96 =	20.89999962	if country ==	3	& year ==	1996
replace istock96 =	11.00000000	if country ==	4	& year ==	1996
replace istock96 =	2.59999990	if country ==	5	& year ==	1996
replace istock96 =	10.50000000	if country ==	6	& year ==	1996
replace istock96 =	7.19999981	if country ==	7	& year ==	1996
replace istock96 =	7.30000019	if country ==	8	& year ==	1996
replace istock96 =	1.08599997	if country ==	9	& year ==	1996
replace istock96 =	5.40000010	if country ==	10	& year ==	1996
replace istock96 =	16.20000076	if country ==	11	& year ==	1996
replace istock96 =	10.30000019	if country ==	12	& year ==	1996
replace istock96 =	10.69999981	if country ==	13	& year ==	1996

gen istock06=.					
replace istock06 =	21.29999924	if country ==	1	& year ==	2006
replace istock06 =	19.50000000	if country ==	2	& year ==	2006
replace istock06 =	22.29999924	if country ==	3	& year ==	2006
replace istock06 =	12.89999962	if country ==	4	& year ==	2006
replace istock06 =	10.60000038	if country ==	5	& year ==	2006
replace istock06 =	10.60000038	if country ==	6	& year ==	2006
replace istock06 =	9.69999981	if country ==	7	& year ==	2006
replace istock06 =	14.80000019	if country ==	8	& year ==	2006
replace istock06 =	1.56400001	if country ==	9	& year ==	2006
replace istock06 =	8.00000000	if country ==	10	& year ==	2006
replace istock06 =	20.70000076	if country ==	11	& year ==	2006
replace istock06 =	12.30000019	if country ==	12	& year ==	2006
replace istock06 =	13.30000019	if country ==	13	& year ==	2006


// Immigrant stock
gen istock96b =.
replace istock96b =	21.29999924	if country ==	1
replace istock96b =	17.20000076	if country ==	2
replace istock96b =	20.89999962	if country ==	3	
replace istock96b =	11.00000000	if country ==	4	
replace istock96b =	2.59999990	if country ==	5	
replace istock96b =	10.50000000	if country ==	6	
replace istock96b =	7.19999981	if country ==	7	
replace istock96b =	7.30000019	if country ==	8	
replace istock96b =	1.08599997	if country ==	9	
replace istock96b =	5.40000010	if country ==	10	
replace istock96b =	16.20000076	if country ==	11	
replace istock96b =	10.30000019	if country ==	12	
replace istock96b =	10.69999981	if country ==	13	

gen istock06b=.					
replace istock06b =	21.29999924	if country ==	1	
replace istock06b =	19.50000000	if country ==	2	
replace istock06b =	22.29999924	if country ==	3	
replace istock06b =	12.89999962	if country ==	4	
replace istock06b =	10.60000038	if country ==	5	
replace istock06b =	10.60000038	if country ==	6	
replace istock06b =	9.69999981	if country ==	7	
replace istock06b =	14.80000019	if country ==	8	
replace istock06b =	1.56400001	if country ==	9
replace istock06b =	8.00000000	if country ==	10	
replace istock06b =	20.70000076	if country ==	11
replace istock06b =	12.30000019	if country ==	12
replace istock06b =	13.30000019	if country ==	13

gen istock = istock96
replace istock=istock06 if istock ==.

// Between country effect
gen imst_be = ((istock96b + istock06b)/2)

// Within country effect
gen imst_we = istock-imst_be


*******************************************************************************************
// Change in immigrant stock
gen ch_immstock96=.
replace ch_immstock96 =	1.29490924	if country ==	1	& year ==	1996
replace ch_immstock96 =	2.18959260	if country ==	2	& year ==	1996
replace ch_immstock96 =	3.22248268	if country ==	3	& year ==	1996
replace ch_immstock96 =	3.24450660	if country ==	4	& year ==	1996
replace ch_immstock96 =	0.82168734	if country ==	5	& year ==	1996
replace ch_immstock96 =	0.41396859	if country ==	6	& year ==	1996
replace ch_immstock96 =	0.28843811	if country ==	7	& year ==	1996
replace ch_immstock96 =	-0.03458165	if country ==	8	& year ==	1996
replace ch_immstock96 =	0.37720755	if country ==	9	& year ==	1996
replace ch_immstock96 =	0.97341746	if country ==	10	& year ==	1996
replace ch_immstock96 =	3.88337779	if country ==	11	& year ==	1996
replace ch_immstock96 =	1.70722461	if country ==	12	& year ==	1996
replace ch_immstock96 =	2.46555519	if country ==	13	& year ==	1996

gen ch_immstock06=.					
replace ch_immstock06 =	3.14409065	if country ==	1	& year ==	2006
replace ch_immstock06 =	3.33456159	if country ==	2	& year ==	2006
replace ch_immstock06 =	2.69005394	if country ==	3	& year ==	2006
replace ch_immstock06 =	1.12776864	if country ==	4	& year ==	2006
replace ch_immstock06 =	5.76934290	if country ==	5	& year ==	2006
replace ch_immstock06 =	1.24947679	if country ==	6	& year ==	2006
replace ch_immstock06 =	1.57342863	if country ==	7	& year ==	2006
replace ch_immstock06 =	5.52292585	if country ==	8	& year ==	2006
replace ch_immstock06 =	0.06418485	if country ==	9	& year ==	2006
replace ch_immstock06 =	1.82521141	if country ==	10	& year ==	2006
replace ch_immstock06 =	2.48007941	if country ==	11	& year ==	2006
replace ch_immstock06 =	2.06375408	if country ==	12	& year ==	2006
replace ch_immstock06 =	1.91910112	if country ==	13	& year ==	2006

gen ch_immstock96b=.
replace ch_immstock96b =	1.29490924	if country ==	1	
replace ch_immstock96b =	2.18959260	if country ==	2	
replace ch_immstock96b =	3.22248268	if country ==	3	
replace ch_immstock96b =	3.24450660	if country ==	4	
replace ch_immstock96b =	0.82168734	if country ==	5	
replace ch_immstock96b =	0.41396859	if country ==	6	
replace ch_immstock96b =	0.28843811	if country ==	7	
replace ch_immstock96b =	-0.03458165	if country ==	8	
replace ch_immstock96b =	0.37720755	if country ==	9	
replace ch_immstock96b =	0.97341746	if country ==	10	
replace ch_immstock96b =	3.88337779	if country ==	11	
replace ch_immstock96b =	1.70722461	if country ==	12	
replace ch_immstock96b =	2.46555519	if country ==	13	

gen ch_immstock06b=.					
replace ch_immstock06b =	3.14409065	if country ==	1
replace ch_immstock06b =	3.33456159	if country ==	2	
replace ch_immstock06b =	2.69005394	if country ==	3
replace ch_immstock06b =	1.12776864	if country ==	4	
replace ch_immstock06b =	5.76934290	if country ==	5	
replace ch_immstock06b =	1.24947679	if country ==	6	
replace ch_immstock06b =	1.57342863	if country ==	7	
replace ch_immstock06b =	5.52292585	if country ==	8	
replace ch_immstock06b =	0.06418485	if country ==	9	
replace ch_immstock06b =	1.82521141	if country ==	10	
replace ch_immstock06b =	2.48007941	if country ==	11	
replace ch_immstock06b =	2.06375408	if country ==	12	
replace ch_immstock06b =	1.91910112	if country ==	13	

gen ist_ch = ch_immstock96
replace ist_ch=ch_immstock06 if ist_ch ==.

// Between country effect
gen istch_be = (ch_immstock96b + ch_immstock06b)/2

// Within country effect
gen istch_we= ist_ch-istch_be


//*******************************************************************************************
//** COUNTRY-LEVEL CONTROL VARIABLES
//*******************************************************************************************

// Employment rate
gen empl_rate06 =.				
replace empl_rate06 =	72.97335815	if country ==	1	& year ==	2006
replace empl_rate06 =	72.69680023	if country ==	2	& year ==	2006
replace empl_rate06 =	84.54134369	if country ==	3	& year ==	2006
replace empl_rate06 =	67.40676117	if country ==	4	& year ==	2006
replace empl_rate06 =	64.84596252	if country ==	5	& year ==	2006
replace empl_rate06 =	61.84713745	if country ==	6	& year ==	2006
replace empl_rate06 =	70.22309875	if country ==	7	& year ==	2006
replace empl_rate06 =	69.33929443	if country ==	8	& year ==	2006
replace empl_rate06 =	76.22027588	if country ==	9	& year ==	2006
replace empl_rate06 =	76.38436127	if country ==	10	& year ==	2006
replace empl_rate06 =	76.01436615	if country ==	11	& year ==	2006
replace empl_rate06 =	72.93346405	if country ==	12	& year ==	2006
replace empl_rate06 =	71.92974091	if country ==	13	& year ==	2006

gen empl_rate96 =.					
replace empl_rate96 =	68.38307953	if country ==	1	& year ==	1996
replace empl_rate96 =	66.95101166	if country ==	2	& year ==	1996
replace empl_rate96 =	82.60142517	if country ==	3	& year ==	1996
replace empl_rate96 =	64.15186310	if country ==	4	& year ==	1996
replace empl_rate96 =	47.57519531	if country ==	5	& year ==	1996
replace empl_rate96 =	58.16967773	if country ==	6	& year ==	1996
replace empl_rate96 =	68.31567383	if country ==	7	& year ==	1996
replace empl_rate96 =	56.05609894	if country ==	8	& year ==	1996
replace empl_rate96 =	74.41401672	if country ==	9	& year ==	1996
replace empl_rate96 =	74.37256622	if country ==	10	& year ==	1996
replace empl_rate96 =	71.75603485	if country ==	11	& year ==	1996
replace empl_rate96 =	70.34078979	if country ==	12	& year ==	1996
replace empl_rate96 =	71.77012634	if country ==	13	& year ==	1996

gen empl_rate06b =.				
replace empl_rate06b =	72.97335815	if country ==	1	
replace empl_rate06b =	72.69680023	if country ==	2	
replace empl_rate06b =	84.54134369	if country ==	3	
replace empl_rate06b =	67.40676117	if country ==	4	
replace empl_rate06b =	64.84596252	if country ==	5	
replace empl_rate06b =	61.84713745	if country ==	6	
replace empl_rate06b =	70.22309875	if country ==	7	
replace empl_rate06b =	69.33929443	if country ==	8	
replace empl_rate06b =	76.22027588	if country ==	9	
replace empl_rate06b =	76.38436127	if country ==	10	
replace empl_rate06b =	76.01436615	if country ==	11	
replace empl_rate06b =	72.93346405	if country ==	12	
replace empl_rate06b =	71.92974091	if country ==	13	

gen empl_rate96b =.					
replace empl_rate96b =	68.38307953	if country ==	1	
replace empl_rate96b =	66.95101166	if country ==	2	
replace empl_rate96b =	82.60142517	if country ==	3	
replace empl_rate96b =	64.15186310	if country ==	4	
replace empl_rate96b =	47.57519531	if country ==	5	
replace empl_rate96b =	58.16967773	if country ==	6	
replace empl_rate96b =	68.31567383	if country ==	7	
replace empl_rate96b =	56.05609894	if country ==	8	
replace empl_rate96b =	74.41401672	if country ==	9	
replace empl_rate96b =	74.37256622	if country ==	10	
replace empl_rate96b =	71.75603485	if country ==	11	
replace empl_rate96b =	70.34078979	if country ==	12	
replace empl_rate96b =	71.77012634	if country ==	13	

gen empl_r = empl_rate96
replace empl_r=empl_rate06 if empl_r ==.

// Between country effect
gen emplr_be = (empl_rate96b + empl_rate06b)/2

// Within country effect
gen emplr_we= empl_r-emplr_be

// Social Welfare expenditure
gen soc_wel06=.
replace soc_wel06 =	17.10000038	if country ==	1	& year ==	2006
replace soc_wel06 =	16.39999962	if country ==	2	& year ==	2006
replace soc_wel06 =	20.20000076	if country ==	3	& year ==	2006
replace soc_wel06 =	26.70000076	if country ==	4	& year ==	2006
replace soc_wel06 =	21.20000076	if country ==	5	& year ==	2006
replace soc_wel06 =	29.10000038	if country ==	6	& year ==	2006
replace soc_wel06 =	21.20000076	if country ==	7	& year ==	2006
replace soc_wel06 =	16.70000076	if country ==	8	& year ==	2006
replace soc_wel06 =	18.50000000	if country ==	9	& year ==	2006
replace soc_wel06 =	21.60000038	if country ==	10	& year ==	2006
replace soc_wel06 =	18.50000000	if country ==	11	& year ==	2006
replace soc_wel06 =	29.39999962	if country ==	12	& year ==	2006
replace soc_wel06 =	15.89999962	if country ==	13	& year ==	2006

gen soc_wel96=.				
replace soc_wel96 =	16.60000038	if country ==	1	& year ==	1996
replace soc_wel96 =	18.00000000	if country ==	2	& year ==	1996
replace soc_wel96 =	18.00000000	if country ==	3	& year ==	1996
replace soc_wel96 =	27.00000000	if country ==	4	& year ==	1996
replace soc_wel96 =	21.29999924	if country ==	5	& year ==	1996
replace soc_wel96 =	28.79999924	if country ==	6	& year ==	1996
replace soc_wel96 =	19.89999962	if country ==	7	& year ==	1996
replace soc_wel96 =	14.69999981	if country ==	8	& year ==	1996
replace soc_wel96 =	14.50000000	if country ==	9	& year ==	1996
replace soc_wel96 =	22.50000000	if country ==	10	& year ==	1996
replace soc_wel96 =	18.89999962	if country ==	11	& year ==	1996
replace soc_wel96 =	31.60000038	if country ==	12	& year ==	1996
replace soc_wel96 =	15.10000038	if country ==	13	& year ==	1996

gen soc_wel06b=.
replace soc_wel06b =	17.10000038	if country ==	1	
replace soc_wel06b =	16.39999962	if country ==	2	
replace soc_wel06b =	20.20000076	if country ==	3	
replace soc_wel06b =	26.70000076	if country ==	4	
replace soc_wel06b =	21.20000076	if country ==	5	
replace soc_wel06b =	29.10000038	if country ==	6	
replace soc_wel06b =	21.20000076	if country ==	7	
replace soc_wel06b =	16.70000076	if country ==	8	
replace soc_wel06b =	18.50000000	if country ==	9	
replace soc_wel06b =	21.60000038	if country ==	10	
replace soc_wel06b =	18.50000000	if country ==	11	
replace soc_wel06b =	29.39999962	if country ==	12	
replace soc_wel06b =	15.89999962	if country ==	13	

gen soc_wel96b=.				
replace soc_wel96b =	16.60000038	if country ==	1	
replace soc_wel96b =	18.00000000	if country ==	2	
replace soc_wel96b =	18.00000000	if country ==	3	
replace soc_wel96b =	27.00000000	if country ==	4	
replace soc_wel96b =	21.29999924	if country ==	5	
replace soc_wel96b =	28.79999924	if country ==	6	
replace soc_wel96b =	19.89999962	if country ==	7	
replace soc_wel96b =	14.69999981	if country ==	8	
replace soc_wel96b =	14.50000000	if country ==	9	
replace soc_wel96b =	22.50000000	if country ==	10	
replace soc_wel96b =	18.89999962	if country ==	11	
replace soc_wel96b =	31.60000038	if country ==	12	
replace soc_wel96b =	15.10000038	if country ==	13	

gen soc_w = soc_wel96
replace soc_w=soc_wel06 if soc_w ==.

// Between country
gen socw_be = (soc_wel96b + soc_wel06b)/2

// Within country
gen socw_we= soc_w-socw_be

**************************************************************************************
// Country by year variable
**************************************************************************************
gen cxy=.
replace cxy = 1 if country ==1 & year == 1996
replace cxy = 2 if country ==1 & year == 2006

replace cxy = 3 if country ==2 & year == 1996
replace cxy = 4 if country ==2 & year == 2006

replace cxy = 5 if country ==3 & year == 1996
replace cxy = 6 if country ==3 & year == 2006

replace cxy = 7 if country ==4 & year == 1996
replace cxy = 8 if country ==4 & year == 2006

replace cxy = 9 if country  ==5 & year == 1996
replace cxy = 10 if country ==5 & year == 2006

replace cxy = 11 if country ==6 & year == 1996
replace cxy = 12 if country ==6 & year == 2006

replace cxy = 13 if country ==7 & year == 1996
replace cxy = 14 if country ==7 & year == 2006

replace cxy = 15 if country ==8 & year == 1996
replace cxy = 16 if country ==8 & year == 2006

replace cxy = 17 if country ==9 & year == 1996
replace cxy = 18 if country ==9 & year == 2006

replace cxy = 19 if country ==10 & year == 1996
replace cxy = 20 if country ==10 & year == 2006

replace cxy = 21 if country ==11 & year == 1996
replace cxy = 22 if country ==11 & year == 2006

replace cxy = 23 if country ==12 & year == 1996
replace cxy = 24 if country ==12 & year == 2006

replace cxy = 25 if country ==13 & year == 1996
replace cxy = 26 if country ==13 & year == 2006


*/
// additional vars needed for Mlwin
gen con1 =1
gen con2 =1
**************************************************************************************
// Save final data
**************************************************************************************
sort country cxy id
keep country cxy id old_age unemployed incdiff jobs housing health ager age2 female edu_prim edu_sec edu_uni full_time part_time act_unempl not_active income imst_be imst_we istch_be istch_we emplr_be emplr_we socw_be socw_we time weight con1 con2
order country cxy id old_age unemployed incdiff jobs housing health ager age2 female edu_prim edu_sec edu_uni full_time part_time act_unempl not_active income imst_be imst_we istch_be istch_we emplr_be emplr_we socw_be socw_we time weight con1 con2

saveold "t13.isspreplication.dta"

erase "t13.issp1996.dta"
erase "t13.issp2006.dta"

*This is a file in case anyone wants to check their work in MLwiN
*The team provided screenshots of the MLwiN results
*We import them here

gen n = _n
drop if n>24
drop id
gen AME = -0.052 if n ==1
gen se = 0.021 if n==1
replace AME = -0.042 if n==2
replace se = 0.036 if n==2
replace AME = -0.024 if n==3
replace se = 0.018 if n==3
replace AME = -0.042 if n==4
replace se = 0.045 if n==4
replace AME = 0.021 if n==5
replace se = 0.023 if n==5
replace AME = -0.009 if n==6
replace se = 0.046 if n==6

replace AME = -0.063 if n==7
replace se = 0.051 if n==7
replace AME = 0.006 if n==8
replace se = 0.061 if n==8
replace AME = -0.061 if n==9
replace se = 0.042 if n==9
replace AME = 0.010 if n==10
replace se = 0.075 if n==10
replace AME = 0.029 if n==11
replace se = 0.083 if n==11
replace AME = -0.111 if n==12
replace se = 0.112 if n==12

replace AME = -0.047 if n==13
replace se = 0.162 if n==13
replace AME = 0.209 if n==14
replace se = 0.230 if n==14
replace AME = -0.024 if n==15
replace se = 0.117 if n==15
replace AME = 0.221 if n==16
replace se = 0.285 if n==16
replace AME = 0.247 if n==17
replace se = 0.133 if n==17
replace AME = 0.147 if n==18
replace se = 0.286 if n==18

replace AME = 0.066 if n==19
replace se = 0.064 if n==19
replace AME = -0.032 if n==20
replace se = 0.076 if n==20
replace AME = -0.057 if n==21
replace se = 0.056 if n==21
replace AME = 0.044 if n==22
replace se = 0.091 if n==22
replace AME = 0.130 if n==23
replace se = 0.095 if n==23
replace AME = 0.121 if n==24
replace se = 0.143 if n==24
gen id = "t13m1"
foreach n of numlist 2/24 {
replace id = "t13m`n'" if n == `n'
}

*calculate 95% CI with 1.96*SE
gen lower = .
gen upper = .
replace lower = AME - (1.96*se)
replace upper = AME + (1.96*se)

*adjust margins for netmig effect and wave avg. length
replace AME = AME*10 if n>12
replace AME = AME*7.75 if n>6 & n<13
replace lower = lower*10 if n>12
replace lower = lower*7.75 if n>6 & n<13
replace upper = upper*10 if n>12
replace upper = upper*7.75 if n>6 & n<13
keep AME lower upper id
save "team13.dta", replace
}
**************************************************************************************
*==============================================================================*
*==============================================================================*
*==============================================================================*


















// TEAM 17
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team17.dta"
	if _rc==0 {
		display "Team 17 already exists, skipping to next code chunk"
	}
else {
version 15
*******************
*** ISSP1985  ***
*******************

use "ZA1490.dta", clear

* Renames
gen  Jobs = V101
gen  JobsC = V101
gen HealthC = V103
gen OldAgeCare = V104
gen OldAgeCareC = V104
gen  Unemployed = V106
gen  UnemployedC = V106
gen  RedIncDiff = V107
gen  RedIncDiffC = V107

rename V118 sex
gen  age = V117
recode age 1=21 2=29.5 3= 39.5 4= 49.5 5=59.5 6=69.5 if V3== 8 /* only categories in Italy */
gen  educ1 = V123

gen employment= . 
*rename XXX ethnic
gen cntry= .
rename  V2 id
gen year=1985

* Recodes

recode OldAgeCare (1 2=1) (3 4 =0)
recode Unemployed (1 2=1) (3 4 =0)
recode RedIncDiff (1 2=1) (3 4 =0)
recode Jobs (1 2=1) (3 4 =0)

recode educ1 (1/3=1) (4/5=2) (6/8=3) if V3 == 1  /* australia */
recode educ1 (1/3=1) (4/6=2) (7=3) if V3 == 2  /*Germany */
recode educ1 (3=1) (4/6=2) (7/8=3) (9=.) if V3 == 3 /* GB */
recode educ1 (1/2=1) (3/4=2) (5/6=3) if V3 == 4  /* USA */
recode educ1 (3=1) (4/7=2) (8=3) if V3 == 5  /* Austria */
recode educ1 (1/4=1) (5/7=2) (8/9=3) if V3 == 8  /* Italy */


lab def educ 1 "Primary" 2 "Secondary" 3 "University"
lab val educ1 educ

sort V3
by V3: tab V123 educ1, miss


* employment status
replace employment = 3 if V109== 1
replace employment= 4 if V109 ==. /* "No answer" and "not in labor force"  coded as missing; 55/40 miscodings in Australia/ Germany */
replace employment = 1 if V109==2 & V108 >= 35 & V108 != . & V3 != 8
replace employment = 2 if V109==2 & V108 < 35  & V3 != 8
replace employment = 1 if V109==2 & V3 == 8 /* No information about working hours in Italy */
replace employment = 5 if (V112==1 | V112==2 ) & (V109 == 2 | V109==.)


lab def employment 1 "Full time" 2 "Part time" 3 "Unemployed" 4 "not active" 5 "self employed"
lab val employment employment


* employment dummies
gen parttime = 0
replace parttime = 1 if employment==2
replace parttime = . if employment==.
gen unemployed = 0
replace unemployed = 1 if employment==3
replace unemployed = . if employment==.
gen notactive = 0 
replace notactive = 1 if employment==4
replace notactive = . if employment==.
gen self = 0 
replace self = 1 if employment==5
replace self = . if employment==.

gen public = 0
replace public = 1 if V114==1 
replace public = . if employment==.

* income
sort V3
by V3: egen inc_m= mean(V129)
by V3: egen inc_s= sd(V129)
gen inc=(V129-inc_m)/inc_s

by V3: egen incfam_m= mean(V128)
by V3: egen incfam_s= sd(V128)
gen incfam=(V128-incfam_m)/incfam_s

/* marital status */
gen  marital=V120
gen nevermarried = 0
replace nevermarried = 1 if V120 == 5
replace nevermarried = . if V120 == .
gen divorced = 0
replace divorced = 1 if V120 == 3 | V120 == 4
replace divorced = . if V120 == .
gen widowed = 0
replace widowed = 1 if V120 == 2
replace widowed = . if V120 == .

/* household */
gen household = V121


replace household = 1 if V121 == 1  & V3==1
replace household = 2 if (V121 == 2 | V121==7) & V3==1
replace household = 3 if (V121 == 3 | V121==8  | V121==15) & V3==1
replace household = 4 if (V121 == 4 | V121==9  | V121==16 | V121== 23) & V3==1
replace household = 5 if (V121 == 5 | V121==10  | V121==17 | V121== 24 | V121==28) & V3==1
replace household = 6 if (V121 == 6 | V121==11  | V121==18 | V121== 25 | V121==29 | V121==31) & V3==1
replace household = 7 if 			 (V121==12  | V121==19 | V121== 26 | V121==30) & V3==1
replace household = 8 if 			 (V121==13  | V121==20 | V121== 27) & V3==1
replace household = 10 if			 (V121==14  | 						V121==32) & V3==1
replace household = 11 if 			 			 (V121==21)  & V3==1
replace household = 12 if (V121==22) & V3==1
 
replace household = 1 if (V121 == 1 | V121== 3) & V3 == 3
replace household = 2 if (V121 == 2 | V121== 4) & V3 == 3
replace household = 3 if (V121 == 5 | V121== 6 | V121 ==7) & V3 == 3 

replace household = 1 if (V121 == 1 | V121== 6) & V3 == 8
replace household = 2 if (V121 == 3 ) & V3 == 8
replace household = 3 if (V121 == 2 | V121== 4) & V3 == 8
replace household = 4 if (V121 == 5 | V121== 7 | V121 ==8) & V3 == 8

by V3: tab V121 household, miss

* Children in HH
gen child = 0
replace child=. if V121 == .
replace child = 1 if (V121==2 | V121==3 | V121==4 | V121==5 | V121==6 | V121==8 | V121==9 | V121==10 | V121==11 | V121==12 | V121==13 ///
	 | V121==14 | V121==16 | V121==17 | V121==18 | V121==19 | V121==20 | V121==21 | V121==22  | V121==24 | V121==25 | V121==26 ///
	 | V121==27 | V121==29 | V121==30 | V121==32) & V3 == 1
replace child =1 if (V121 >= 3 & V121 < =10) & (V3 == 2 | V3 == 4  | V3 ==5)
replace child =1 if (V121 == 5 | V121 ==6) & (V3 == 3)
replace child =1 if (V121 == 4 | V121 ==5) & (V3 == 8)
by V3: tab V121 child, miss
	 

/*Religious attendance */
recode V133 (1 2 3 5= 0) (4 = 1), gen(at_low)
recode V133 (4 5 = 0) (1 2 3 = 1), gen(at_high)	 

* urban/rural
gen suburb=0
replace suburb=. if V119 ==.
replace suburb=1 if (V119 == 3 | V119==4) & V3 ==1 /*australia*/
replace suburb=1 if (V119 == 2 | V119==3) & V3 ==3 /* GB*/
replace suburb=1 if (V119 >= 3 & V119<=8) & V3 ==4 /* USA*/
replace suburb=1 if (V119 >= 3 & V119<=4) & V3 ==5 /* Austria*/
replace suburb=1 if (V119 >= 2 & V119<=4) & V3 ==8 /*Italy*/
replace suburb=. if V3==2 /* Germany*/

gen rural=0
replace rural=. if V119==.
replace rural=1 if (V119 == 5 | V119==6) & V3 ==1 /*australia*/
replace rural=1 if (V119 == 4 | V119==5) & V3 ==3 /* GB*/
replace rural=1 if (V119 >= 9 & V119<=10) & V3 ==4 /* USA*/
replace rural=1 if (V119 >= 5 & V119<=8) & V3 ==5 /* Austria*/
replace rural=1 if (V119 >= 5 & V119<=6) & V3 ==8 /*Italy*/
replace rural=. if V3==2 /* Germany*/
by V3: tab V119 suburb, miss
by V3: tab V119 rural, miss

*ethnic group
gen ethnic=.

replace cntry = 36 if V3 ==1
replace cntry = 276 if V3 ==2
replace cntry = 826 if V3 ==3
replace cntry = 840 if V3 ==4
replace cntry = 40 if V3 ==5
replace cntry = 380 if V3 ==8

keep cntry id year OldAgeCare OldAgeCareC  Unemployed UnemployedC RedIncDiff RedIncDiffC Jobs JobsC HealthC  sex age educ1  employment parttime unemployed notactive self public   inc incfam ///
   marital nevermarried divorced widowed household child at_low at_high suburb rural ethnic
order cntry id year OldAgeCare OldAgeCareC  Unemployed UnemployedC RedIncDiff RedIncDiffC Jobs JobsC HealthC  sex age educ1  employment parttime unemployed notactive self public   inc incfam ///
   marital nevermarried divorced widowed household child at_low at_high suburb rural ethnic
sort cntry id

keep if cntry==36 | cntry== 276 | cntry==826 | cntry==380 | cntry==840 

save "ISSP1985r_3", replace

*******************
*** ISSP1990  ***
*******************

use "ZA1950.dta", clear

* Renames
gen  Jobs = v49
gen  JobsC = v49
gen HealthC = v51
gen OldAgeCare = v52
gen OldAgeCareC = v52
gen  Unemployed = v54
gen  UnemployedC = v54
gen  RedIncDiff = v55
gen  RedIncDiffC = v55
gen StudentsC = v56
gen HousingC = v57


rename v59 sex
rename v60 age
gen  educ1 = v81
gen employment= v63 
gen cntry= .
rename  v2 id
gen year=1990

* Recodes

recode OldAgeCare (1 2=1) (3 4 =0)
recode Unemployed (1 2=1) (3 4 =0)
recode RedIncDiff (1 2=1) (3 4 =0)
recode Jobs (1 2=1) (3 4 =0)

recode educ1 (1/4=1) (5=2) (6=3) if v3 == 1 /* Australia; different codes as 1985 */
recode educ1 (1/3=1) (4/6=2) (7/8=3) (9=.) if v3 == 2 | v3==3 /* D-West, East */
recode educ1 (3=1) (4/6=2) (7/8=3) (9=.) if v3 == 4 | v3==5 /* GB, nothern Ireland*/
recode educ1 (1/3=1) (4/5=2) (6/7=3) if v3 == 6 /* USA*/
recode educ1 (1/3=1) (4/5=2) (6/7=3) if v3 == 7 /* Hungary */
recode educ1 (1/3=1) (4/5=2) (6=3) if v3 == 8 /* Italy */
recode educ1 (1/4=1) (5=2) (6/7=3) if v3 == 9 /* Ireland */
recode educ1 (3=1) (4/6=2) (7/8=3) (9=.) if v3 == 10 /* Norway */
recode educ1 (1/3=1) (4/5=2) (6/7=3) (8=.) if v3 == 11 /* Israel */


lab def educ 1 "Primary" 2 "Secondary" 3 "University"
lab val educ1 educ

sort v3
by v3: tab v81 educ1, miss

* employment status: Methods description unclear. What about "Less part time" and "Help family member"? Assumption: Part time
recode employment (2/4=2) (5=3) (6/10=4)
replace employment=5 if v72==1 & v63 >=1 & v63 <= 4
lab def employment 1 "Full time" 2 "Part time" 3 "Unemployed" 4 "not active" 5 "self employed"
lab val employment employment

* employment dummies
gen parttime = 0 
replace parttime = 1 if employment==2
replace parttime = . if employment==.
gen unemployed = 0
replace unemployed = 1 if employment==3
replace unemployed = . if employment==.
gen notactive = 0
replace notactive = 1 if employment==4
replace notactive = . if employment==.
gen self = 0 
replace self = 1 if employment==5
replace self = . if employment==.
gen public = 0
replace public = 1 if v71==1 | v71==2 
replace public = . if employment==.
/* 1: with nationalized industy */

* income
sort v3
by v3: egen inc_m= mean(v102)
by v3: egen inc_s= sd(v102)
gen inc=(v102-inc_m)/inc_s

by v3: egen incfam_m= mean(v100)
by v3: egen incfam_s= sd(v100)
gen incfam=(v100-incfam_m)/incfam_s

by v3: su v102 inc v100 incfam 

/* marital status */

gen marital=v61
gen nevermarried = 0
replace nevermarried = 1 if v61 == 5
replace nevermarried = . if v61 == .
gen divorced = 0
replace divorced = 1 if v61 == 3 | v61 == 4
replace divorced = . if v61 == .
gen widowed = 0
replace widowed = 1 if v61 == 2
replace widowed = . if v61 == .

* HHsize
gen household = v98

* children
gen child = .
replace child = 1 if v135 < .
replace child = 0 if missing(v135) 

/*Religious attendance */

recode v89 (1 2 3 4 6= 0) (5 = 1), gen(at_low)
recode v89 (5 6 = 0) (1 2 3 4 = 1), gen(at_high)	 

* urban/rural
gen suburb=0
replace suburb=. if v104 ==.
replace suburb=1 if (v104 == 3 | v104==4) & v3 ==1 /*australia*/
replace suburb=1 if (v104 >= 5 & v104<=8) & v3 ==2 /* G-West */
replace suburb=1 if (v104 >= 2 & v104<=3) & v3 ==5 /* Nirl */
replace suburb=1 if (v104 >= 3 & v104<=8) & v3 ==6 /* USA*/
replace suburb=1 if (v104 ==2) & v3 ==7 /* Hun */
replace suburb=1 if (v104 >= 2 & v104<=5) & v3 ==9 /* Ireland*/
replace suburb=1 if (v104 ==2) & v3 ==10 /* Norway */
replace suburb=1 if (v104 >= 2 & v104<=5) & v3 ==11 /* Israel*/
/*Italy, GB , G-East: NA*/
/* Israel: no clear definition; only Big City vs. other */


gen rural=0
replace rural=. if v104==.
replace rural=1 if (v104 == 5 | v104==6) & v3 ==1 /*australia*/
replace rural=1 if (v104 >= 9 & v104<=10) & v3 ==2 /* G-West */
replace rural=1 if (v104 >= 4 & v104<=5) & v3 ==5 /* Nirl */
replace rural=1 if (v104 >= 9 & v104<=10) & v3 ==6 /* USA*/
replace rural=1 if (v104 ==3) & v3 ==7 /* Hun */
replace rural=1 if (v104 >= 6 & v104<=7) & v3 ==9 /* Ireland*/
replace rural=1 if (v104 ==3) & v3 ==10 /* Norway */
/* for Israel: rural stays 0 */

sort v3
by v3: tab v104 suburb, miss
by v3: tab v104 rural, miss


/* ethnicity */

gen ethnic = . 
replace ethnic = 0 if v3==1 & (v113 == 1 | v113==2) /* Australia */
replace ethnic = 1 if v3==1 & v113 > 2 & v113 <. 
replace ethnic = 0 if v3==4 & v113 == 7  /* UK */
replace ethnic = 1 if v3==4 & v113!=7 & v113 < . 
replace ethnic = 1 if v3==5 & v113==7   /* Nirl */
replace ethnic = 0 if v3==5 & v113!=7  & v113 < . 
replace ethnic = 0 if v3==6 & (v113==97 | v113== 2 | v113==3  |v113==4  |v113== 7 |v113==8  |v113==9  |v113==10  |v113==11  |v113==12  |v113== 14 |v113==15  |v113==18  |v113== 19 |v113== 24 |v113==25  |v113== 26 | ///
   v113==27  |v113==32  |v113==36 | v113==97)/* USA */
replace ethnic = 1 if v3==6 & (v113==1  | v113==5 | v113==6  |v113==13  |v113==16  |v113==17  |v113==20  |v113==21  |v113==22  |v113== 23 |v113==29  |v113==30  |v113==31  |v113==33  |v113==34 |v113==35  |v113== 37 | ///
   v113==38 |v113==39 )   
replace ethnic = 0 if v3==11 & (v113==2 | v113==3  |v113==5) /* Israel */
replace ethnic = 1 if v3==11 & (v113==1 |v113==4) & v113 < . 
*replace ethnic=. if v3==2 | v3==3 | v3 == 7 | v3 == 8 | v3 == 9 | v3 == 10
sort v3
by v3: tab v113 ethnic, miss

replace cntry = 36 if v3 ==1
replace cntry = 276 if v3 ==2 | v3==3
replace cntry = 826 if v3 ==4 | v3==5
replace cntry = 840 if v3 ==6
replace cntry = 348 if v3 ==7
replace cntry = 380 if v3 ==8
replace cntry = 372 if v3 ==9
replace cntry = 578 if v3 ==10
replace cntry = 376 if v3 ==11 


keep cntry id year OldAgeCare OldAgeCareC  Unemployed UnemployedC RedIncDiff RedIncDiffC Jobs JobsC HealthC  sex age educ1  employment parttime unemployed notactive self public   inc incfam ///
   marital nevermarried divorced widowed household child at_low at_high suburb rural ethnic
order cntry id year OldAgeCare OldAgeCareC  Unemployed UnemployedC RedIncDiff RedIncDiffC Jobs JobsC HealthC  sex age educ1  employment parttime unemployed notactive self public   inc incfam ///
   marital nevermarried divorced widowed household child at_low at_high suburb rural ethnic
sort cntry id

keep if cntry==36 | cntry== 276 | cntry==826 | cntry==380 | cntry==840 | cntry==348 | cntry==372 | cntry==578 

save "ISSP1990r_3", replace


*******************
*** ISSP1996  ***
*******************

use "ZA2900.dta", clear

* Renames
gen  Jobs = v36
gen  JobsC = v36
gen HealthC = v38
gen OldAgeCare = v39
gen OldAgeCareC = v39
gen  Unemployed = v41
gen  UnemployedC = v41
gen  RedIncDiff = v42
gen  RedIncDiffC = v42
gen StudentsC = v43
gen HousingC = v44

rename v200 sex
rename v201 age
gen  educ1 = v205
gen employment= v206 
*rename v324 ethnic
gen cntry= .
rename  v2 id
gen year=1996

* Recodes

recode OldAgeCare (1 2=1) (3 4 =0)
recode Unemployed (1 2=1) (3 4 =0)
recode RedIncDiff (1 2=1) (3 4 =0)
recode Jobs (1 2=1) (3 4 =0)

recode educ1 (1/4=1) (5=2) (6/7=3)

lab def educ 1 "Primary" 2 "Secondary" 3 "University"
lab val educ1 educ

* employment status: Methods description unclear. What about "Less part time" and "Help family member"? Assumption: Part time
recode employment (2/4=2) (5=3) (6/10=4)
replace employment=5 if v213==1 & v206 >=1 & v206 <= 4
lab def employment 1 "Full time" 2 "Part time" 3 "Unemployed" 4 "not active" 5 "self employed"

*employment dummies
gen parttime = 0
replace parttime = 1 if employment==2
replace parttime = . if employment==.
gen unemployed = 0
replace unemployed = 1 if employment==3
replace unemployed = . if employment==.
gen notactive = 0
replace notactive = 1 if employment==4
replace notactive = . if employment==.
gen self = 0
replace self = 1 if employment==5
replace self = . if employment==.
gen public = 0
replace public = 1 if v212==1 | v212==2  | v212 == 6
replace public = . if employment==.
/* 1: with public owned firms , "others" "non-profit organisations" */

lab val employment employment

* income
sort v3
by v3: egen inc_m= mean(v217)
by v3: egen inc_s= sd(v217)
gen inc=(v217-inc_m)/inc_s

by v3: egen incfam_m= mean(v218)
by v3: egen incfam_s= sd(v218)
gen incfam=(v218-incfam_m)/incfam_s

by v3: su v217 inc v218 incfam 

* Marital status

gen marital = v202
gen nevermarried = 0
replace nevermarried = 1 if v202 == 5
replace nevermarried = . if v202 == .
gen divorced = 0
replace divorced = 1 if v202 == 3 | v202 == 4
replace divorced = . if v202 == .
gen widowed = 0
replace widowed = 1 if v202 == 2
replace widowed = . if v202 == .

/*household*/
gen household = v273

/* child */
gen child = . 
replace child = 1 if v274 == 2 | v274 == 3 | v274 == 4 | v274 == 6 | v274 == 7 | v274 == 8 | v274 == 10 | v274 == 12 | v274 == 14 ///
	 | v274 == 16 | v274 == 18 | v274 == 20 | v274 == 22 | v274 == 24 | v274 == 26 | v274 == 28
replace child = 0 if v274 == 1 | v274 == 5 | v274 == 9 | v274 == 11 | v274 == 13 | v274 == 15 | v274 == 17 | v274 == 19 | v274 == 21 ///
	 | v274 == 23 | v274 == 25 | v274 == 27


/* rel. attendance */ 
recode v220 (1 2 3 4 6= 0) (5 = 1), gen(at_low)
recode v220 (5 6 = 0) (1 2 3 4 = 1), gen(at_high)	 

/* urban/rural */
gen suburb=0
replace suburb=. if v275==.
replace suburb=1 if v275==2

gen rural=0
replace rural=. if v275==.
replace rural=1 if v275==3

/*ethnicity*/
gen ethnic = .
replace ethnic = 0 if v3==1 & v324==9  
replace ethnic= 1 if v3==1 & v324!=9 & v324 < . /* Australia */  
replace ethnic= 0 if v3==2 & v324==38  
replace ethnic= 1 if v3==2 & v324!=38 & v324 < .  /* G - West */
replace ethnic= 0 if v3==3 & v324==38  
replace ethnic= 1 if v3==3 & v324!=38 & v324 < .  /* G-East */
replace ethnic= 0 if v3==4 & v324==32  
replace ethnic= 1 if v3==4 & v324!=32 & v324 < .  /* UK */ 
/* for GB; ethnic is european white */
replace ethnic= 0 if v3==6 & (v324==4 | v324==10 | v324==21 | v324==30 | v324==31 | v324==32 | v324==34 | v324==35 | v324==36 | v324==38| v324==39 | v324==48 ///
    | v324==49| v324==58 | v324==61| v324==69 | v324==76 | v324==81 | v324==82 | v324==83 )  
replace ethnic= 1 if v3==6 & !(v324==4 | v324==10 | v324==21 | v324==30 | v324==31 | v324==32 | v324==34 | v324==35 | v324==36 | v324==38| v324==39 | v324==48 ///
    | v324==49| v324==58 | v324==61| v324==69 |  v324==76 | v324==81 | v324==82 | v324==83 )  & v324 < .  /* USA   */
replace ethnic= 0 if v3==13 & v324==82  
replace ethnic= 1 if v3==13 & v324!=82 & v324 < .  /* Sweden */
replace ethnic= 0 if v3==15 & v324==79  
replace ethnic= 1 if v3==15 & v324!=79 & v324 < .  /* Slovenia */
replace ethnic= 0 if v3==16 & v324==68  
replace ethnic= 1 if v3==16 & v324!=68 & v324 < .  /* Poland */
replace ethnic= 0 if v3==18 & v324==72  
replace ethnic= 1 if v3==18 & v324!=72 & v324 < .  /* Russia */
replace ethnic= 0 if v3==20 & (v324==21 | v324==31 | v324==35 | v324==76 )
replace ethnic= 1 if v3==20 & v324!=21 &!(v324==21 | v324==31 | v324==35 | v324==76 ) & v324 < .  /* Canada */
/* canada; nobody choose canada for origin country */ 
replace ethnic= 0 if v3==21 & (v324==65 | v324==66)  
replace ethnic= 1 if v3==21 & (v324!=65 | v324!=66) & v324 < .  /* Phillipines not in final sample, so no final recodes for this var */
replace ethnic= 0 if v3==22 & v324==40  
replace ethnic= 1 if v3==22 & v324!=40 & v324 < .  /* Israel Jews */
replace ethnic= 0 if v3==23 & v324==40  
replace ethnic= 1 if v3==23 & v324!=40 & v324 < .  /*Israel arabs */
replace ethnic= 0 if v3==26 & (v324==11  | v324 ==72) /* incl. russians */
replace ethnic= 1 if v3==26 & v324!=11 &v324 != 72 & v324 < .  /* Latvia */
replace ethnic= 0 if v3==28 & v324==39  
replace ethnic= 1 if v3==28 & v324!=39 & v324 < .  /* Cyprus */ 
/* cyprus = greek cypriote */
replace ethnic= 0 if v3==30 & (v324==83 | v324==36 | v324==49 )
replace ethnic= 1 if v3==30 & v324!=83 & v324!=36 & v324!=49 & v324 < .  /* Switzerland */
sort v3
by v3: tab v324 ethnic, miss
		 

replace cntry = 36 if v3 ==1
replace cntry = 276 if v3 ==2 | v3==3
replace cntry = 826 if v3 ==4
replace cntry = 840 if v3 ==6
replace cntry = 348 if v3 ==8
replace cntry = 380 if v3 ==9
replace cntry = 372 if v3 ==10
replace cntry = 528 if v3 ==11
replace cntry = 578 if v3 ==12
replace cntry = 752 if v3 ==13
replace cntry = 203 if v3 ==14
replace cntry = 705 if v3 ==15
replace cntry = 616 if v3 ==16
replace cntry = 100 if v3 ==17
replace cntry = 643 if v3 ==18
replace cntry = 554 if v3 ==19
replace cntry = 124 if v3 ==20
replace cntry = 608 if v3 ==21
replace cntry = 376 if v3 ==22 | v3==23
replace cntry = 392 if v3 ==24
replace cntry = 724 if v3 ==25
replace cntry = 428 if v3 ==26
replace cntry = 250 if v3 ==27
replace cntry = 196 if v3 ==28
replace cntry = 756 if v3 ==30


keep cntry id year OldAgeCare OldAgeCareC  Unemployed UnemployedC RedIncDiff RedIncDiffC Jobs JobsC HealthC  sex age educ1  employment parttime unemployed notactive self public   inc incfam ///
   marital nevermarried divorced widowed household child at_low at_high suburb rural ethnic
order cntry id year OldAgeCare OldAgeCareC  Unemployed UnemployedC RedIncDiff RedIncDiffC Jobs JobsC HealthC  sex age educ1  employment parttime unemployed notactive self public   inc incfam ///
   marital nevermarried divorced widowed household child at_low at_high suburb rural ethnic
sort cntry id

sort cntry id

keep if cntry==36 | cntry== 276 | cntry==826 | cntry==380 | cntry==840 | cntry==348 | cntry==372 | cntry==578 | cntry==752 |cntry==203 ///
  | cntry==705 |  cntry==616 | cntry==643 | cntry==554 | cntry==124 | cntry== 608 | cntry==392 | cntry==724 | cntry==428 | cntry==250 | cntry== 756

save "ISSP1996r_3", replace


*****************************
*** ISSP2006 ****************
*****************************

use "ZA4700.dta", clear

gen  Jobs = V25
gen  JobsC = V25
gen HealthC = V27
gen OldAgeCare = V28
gen OldAgeCareC = V28
gen  Unemployed = V30
gen  UnemployedC = V30
gen  RedIncDiff = V31
gen  RedIncDiffC = V31
gen StudentsC = V32
gen HousingC = V33

gen  educ1 = degree
gen employment= wrkst
gen cntry = V3a
*rename V2 id Whatever V2 is: It is not a respondent id
rename ethnic ethnic_or
gen year = 2006

sort cntry
gen id = _n /* id not really needed ... should be sufficient */

* Recodes

recode OldAgeCare (1 2=1) (3 4 =0)
recode Unemployed (1 2=1) (3 4 =0)
recode RedIncDiff (1 2=1) (3 4 =0)
recode Jobs (1 2=1) (3 4 =0)

* same logic as above
recode educ1 (0/2=1) (3=2) (4/5=3)

lab def educ 1 "Primary" 2 "Secondary" 3 "University"
lab val educ1 educ

* employment status: same logic as abovee
recode employment (2/4=2) (5=3) (6/10=4)
replace employment=5 if wrktype==4  & wrkst >=1 & wrkst <= 4
lab def employment 1 "Full time" 2 "Part time" 3 "Unemployed" 4 "not active" 5 "self employed"
lab val employment employment
tab wrkst employment, miss

* employment dummies
gen parttime = 0 
replace parttime = 1 if employment==2
replace parttime = . if employment==.
gen unemployed = 0 
replace unemployed = 1 if employment==3
replace unemployed = . if employment==.
gen notactive = 0
replace notactive = 1 if employment==4
replace notactive = . if employment==.
gen self = 0
replace self = 1 if employment==5
replace self = . if employment==.
gen public = 0
replace public = 1 if wrktype==1 | wrktype==2 | wrktype==6
replace public = . if employment==.
/* 1: with public owned firms (wrktype==2) & "other" (wrktype==6) */

* income
gen long rincome=.
format rincome %12.2f
replace rincome = AU_RINC if V3a == 36
replace rincome = CA_RINC if V3a == 124
replace rincome = CH_RINC if V3a == 756
replace rincome = CL_RINC if V3a == 152
replace rincome = CZ_RINC if V3a == 203
replace rincome = DE_RINC if V3a == 276
replace rincome = DK_RINC if V3a == 208
replace rincome = DO_RINC if V3a == 214
replace rincome = ES_RINC if V3a == 724
replace rincome = FI_RINC if V3a == 246
replace rincome = FR_RINC if V3a == 250
replace rincome = GB_RINC if V3a == 826
replace rincome = HR_RINC if V3a == 191
replace rincome = HU_RINC if V3a == 348
replace rincome = IE_RINC if V3a == 372
replace rincome = IL_RINC if V3a == 376
replace rincome = JP_RINC if V3a == 392
replace rincome = KR_RINC if V3a == 410
replace rincome = LV_RINC if V3a == 428
replace rincome = NL_RINC if V3a == 528
replace rincome = NO_RINC if V3a == 578
replace rincome = NZ_RINC if V3a == 554
replace rincome = PH_RINC if V3a == 608
replace rincome = PL_RINC if V3a == 616
replace rincome = PT_RINC if V3a == 620
replace rincome = RU_RINC if V3a == 643
replace rincome = SE_RINC if V3a == 752
replace rincome = SI_RINC if V3a == 705
replace rincome = TW_RINC if V3a == 158
replace rincome = US_RINC if V3a == 840
replace rincome = UY_RINC if V3a == 858
replace rincome = VE_RINC if V3a == 862
replace rincome = ZA_RINC if V3a == 710


gen long fincome=.
format fincome %12.2f
replace fincome = AU_INC if V3a == 36
replace fincome = CA_INC if V3a == 124
replace fincome = CH_INC if V3a == 756
replace fincome = CL_INC if V3a == 152
replace fincome = CZ_INC if V3a == 203
replace fincome = DE_INC if V3a == 276
replace fincome = DK_INC if V3a == 208
replace fincome = DO_INC if V3a == 214
replace fincome = ES_INC if V3a == 724
replace fincome = FI_INC if V3a == 246
replace fincome = FR_INC if V3a == 250
replace fincome = GB_INC if V3a == 826
replace fincome = HR_INC if V3a == 191
replace fincome = HU_INC if V3a == 348
replace fincome = IE_INC if V3a == 372
replace fincome = IL_INC if V3a == 376
replace fincome = JP_INC if V3a == 392
replace fincome = KR_INC if V3a == 410
replace fincome = LV_INC if V3a == 428
replace fincome = NL_INC if V3a == 528
replace fincome = NO_INC if V3a == 578
replace fincome = NZ_INC if V3a == 554
replace fincome = PH_INC if V3a == 608
replace fincome = PL_INC if V3a == 616
replace fincome = PT_INC if V3a == 620
replace fincome = RU_INC if V3a == 643
replace fincome = SE_INC if V3a == 752
replace fincome = SI_INC if V3a == 705
replace fincome = TW_INC if V3a == 158
replace fincome = US_INC if V3a == 840
replace fincome = UY_INC if V3a == 858
replace fincome = VE_INC if V3a == 862
replace fincome = ZA_INC if V3a == 710

* Marital status

gen nevermarried = 0
replace nevermarried = 1 if marital == 5
replace nevermarried = . if marital == .
gen divorced = 0
replace divorced = 1 if marital == 3 | marital == 4
replace divorced = . if marital == .
gen widowed = 0
replace widowed = 1 if marital == 2
replace widowed = . if marital == .

sort V3a
by V3a: egen inc_m= mean(rincome)
by V3a: egen inc_s= sd(rincome)
gen inc=(rincome-inc_m)/inc_s

by V3a: egen incfam_m= mean(fincome)
by V3a: egen incfam_s= sd(fincome)
gen incfam=(fincome-incfam_m)/incfam_s

by V3a: su rincome inc fincome incfam 

/*household*/
gen household = hompop

/* child */
gen child = .
replace child = 0 if hhcycle==1 | hhcycle ==5 | hhcycle ==9 | hhcycle ==11 | hhcycle ==13 | hhcycle ==15 | hhcycle ==17 | hhcycle ==19 ///
	 | hhcycle ==21 | hhcycle ==23 | hhcycle ==25
replace child = 1 if hhcycle==2 | hhcycle ==3 | hhcycle ==4 | hhcycle ==6 | hhcycle ==7 | hhcycle ==8 | hhcycle ==10 | hhcycle ==12 ///
		 | hhcycle ==14 | hhcycle ==16 | hhcycle ==18 | hhcycle ==20 | hhcycle ==22 | hhcycle ==24 | hhcycle ==26 | hhcycle ==28
table hhcycle child, miss


* rel. att.
recode attend (1 2 3 4 5 8 = 0) (6 7 = 1), gen(at_low)
recode attend (6 7 8 = 0) (1 2 3 4 5 = 1), gen(at_high)	 

/* urban/rural */
gen suburb=0
replace suburb=. if urbrural==.
replace suburb=1 if urbrural >=2 & urbrural <= 3

gen rural=0
replace rural=. if urbrural==.
replace rural=1 if urbrural >=4 & urbrural <= 5

/*ethnicity*/
gen ethnic = .
replace ethnic = 0 if V3a==36 & ethnic_or==9  
replace ethnic= 1 if V3a==36 & ethnic_or!=9 & ethnic_or < . /* Australia */  /* NO INFO??*/
replace ethnic= 0 if V3a==276 & ethnic_or==38  
replace ethnic= 1 if V3a==276 & ethnic_or!=38 & ethnic_or < .  /* G - West */
replace ethnic= 0 if V3a==826 & ethnic_or==32  
replace ethnic= 1 if V3a==826 & ethnic_or!=32 & ethnic_or < .  /* UK */ 
/* for GB; ethnic is european white */

replace ethnic= 0 if V3a==840 & (ethnic_or==4 | ethnic_or==10 | ethnic_or==21 | ethnic_or==30 | ethnic_or==31 | ethnic_or==32 | ethnic_or==34 | ethnic_or==35 | ethnic_or==36 | ethnic_or==38| ethnic_or==39 | ethnic_or==48 ///
    | ethnic_or==49| ethnic_or==58 | ethnic_or==61| ethnic_or==69 | ethnic_or==76 | ethnic_or==81 | ethnic_or==82 | ethnic_or==83 |ethnic_or==90)  
replace ethnic= 1 if V3a==840 & !(ethnic_or==4 | ethnic_or==10 | ethnic_or==21 | ethnic_or==30 | ethnic_or==31 | ethnic_or==32 | ethnic_or==34 | ethnic_or==35 | ethnic_or==36 | ethnic_or==38| ethnic_or==39 | ethnic_or==48 ///
    | ethnic_or==49| ethnic_or==58 | ethnic_or==61| ethnic_or==69 |  ethnic_or==76 | ethnic_or==81 | ethnic_or==82 | ethnic_or==83 |ethnic_or==90)  & ethnic_or < .  /* USA   */
	
replace ethnic= 0 if V3a==752 & ethnic_or==82  
replace ethnic= 1 if V3a==752 & ethnic_or!=82 & ethnic_or < .  /* Sweden */
replace ethnic= 0 if V3a==705 & ethnic_or==79  
replace ethnic= 1 if V3a==705 & ethnic_or!=79 & ethnic_or < .  /* Slovenia */
replace ethnic= 0 if V3a==616 & ethnic_or==68  
replace ethnic= 1 if V3a==616 & ethnic_or!=68 & ethnic_or < .  /* Poland */
replace ethnic= 0 if V3a==643 & ethnic_or==72  
replace ethnic= 1 if V3a==643 & ethnic_or!=72 & ethnic_or < .  /* Russia */
replace ethnic= 0 if V3a==124 & (ethnic_or==21 | ethnic_or==31 | ethnic_or==35 | ethnic_or==76 )
replace ethnic= 1 if V3a==124 & ethnic_or!=21 &!(ethnic_or==21 | ethnic_or==31 | ethnic_or==35 | ethnic_or==76 ) & ethnic_or < .  /* Canada */
/* canada; nobody choose canada for origin country */ 
replace ethnic= 0 if V3a==376 & ethnic_or==40  
replace ethnic= 1 if V3a==376 & ethnic_or!=40 & ethnic_or < .  /* Israel  */
replace ethnic= 0 if V3a==428 & (ethnic_or==11  | ethnic_or ==72) /* incl. russians */
replace ethnic= 1 if V3a==428 & ethnic_or!=11 &ethnic_or != 72 & ethnic_or < .  /* Latvia */
replace ethnic= 0 if V3a==756 & (ethnic_or==83 | ethnic_or==36 | ethnic_or==49 )
replace ethnic= 1 if V3a==756 & ethnic_or!=83 & ethnic_or!=36 & ethnic_or!=49 & ethnic_or < .  /* Switzerland */

replace ethnic= 0 if V3a==246 & (ethnic_or==34)
replace ethnic= 1 if V3a==246 & !(ethnic_or==34) & ethnic_or < .  /* Finland */
replace ethnic= 0 if V3a==348 & (ethnic_or==41)
replace ethnic= 1 if V3a==348 & !(ethnic_or==41) & ethnic_or < .  /* Hungary */
replace ethnic= 0 if V3a==554 & (ethnic_or==32)
replace ethnic= 1 if V3a==554 & !(ethnic_or==32) & ethnic_or < .  /* NZ */

sort V3a
by V3a: tab ethnic_or ethnic, miss

keep cntry id year OldAgeCare OldAgeCareC  Unemployed UnemployedC RedIncDiff RedIncDiffC Jobs JobsC HealthC  sex age educ1  employment parttime unemployed notactive self public   inc incfam ///
   marital nevermarried divorced widowed household child at_low at_high suburb rural ethnic
order cntry id year OldAgeCare OldAgeCareC  Unemployed UnemployedC RedIncDiff RedIncDiffC Jobs JobsC HealthC  sex age educ1  employment parttime unemployed notactive self public   inc incfam ///
   marital nevermarried divorced widowed household child at_low at_high suburb rural ethnic
sort cntry id

keep if cntry==36 | cntry== 276 | cntry==826 | cntry==840 | cntry==348 | cntry==372 | cntry==578 | cntry==752 |cntry==203 ///
  | cntry==705 |  cntry==616 | cntry==643 | cntry==554 | cntry==124 | cntry== 608 | cntry==392 | cntry==724 | cntry==428 | cntry==250 | cntry== 756 ///
  | cntry==191 | cntry==208 | cntry==246 | cntry==428 | cntry== 710

save "ISSP2006r_3", replace

*****************************
*** ISSP2016 ****************
*****************************

use "ZA6900_v2-0-0.dta", clear

* set missings
recode v21 v23 v24 v26 v27 v28 v29 (0 8 9 =.)
recode SEX (9=.)
recode WRKHRS (98 99=.)
recode DEGREE (9=.)
recode MAINSTAT (99=.)
recode AGE (999=.)
recode MARITAL (7 9 =.)
mvdecode HOMPOP, mv(0 99 = .)

* Var generation

gen  Jobs = v21
gen  JobsC = v21
gen HealthC = v23
gen OldAgeCare = v24
gen OldAgeCareC = v24
gen  Unemployed = v26
gen  UnemployedC = v26
gen  RedIncDiff = v27
gen  RedIncDiffC = v27
gen StudentsC = v28
gen HousingC = v29

rename SEX sex
rename AGE age
replace age=DK_AGE if country== 208 & DK_AGE >0

gen  educ1 = DEGREE
gen employment= MAINSTAT
ren  country cntry
gen year = 2016

sort cntry
gen id = _n /* id not really needed ... should be sufficient */

* Recodes

recode OldAgeCare (1 2=1) (3 4 =0)
recode Unemployed (1 2=1) (3 4 =0)
recode RedIncDiff (1 2=1) (3 4 =0)
recode Jobs (1 2=1) (3 4 =0)

* same logic as above
recode educ1 (0/1=1) (2/4=2) (5/6=3) (9=.)

lab def educ 1 "Primary" 2 "Secondary" 3 "University"
lab val educ1 educ

* employment status: same logic as abovee
recode employment (2=3) (2/9=4)
replace employment=2 if MAINSTAT==1 & WRKHRS < 35
replace employment=5 if (EMPREL==2 | EMPREL==3) & MAINSTAT==1
lab def employment 1 "Full time" 2 "Part time" 3 "Unemployed" 4 "not active" 5 "self employed"
lab val employment employment

*employment dummies
gen parttime = 0 
replace parttime = 1 if employment==2
replace parttime = . if employment==.
gen unemployed = 0
replace unemployed = 1 if employment==3
replace unemployed = . if employment==.
gen notactive = 0
replace notactive = 1 if employment==4
replace notactive = . if employment==.
gen self = 0
replace self = 1 if employment==5
replace self = . if employment==.
/* 1: without "working for own family's business */
gen public = 0
replace public = 1 if TYPORG2==1 
replace public = . if employment==.

* income

foreach x in AU_RINC BE_RINC CH_RINC  CZ_RINC DE_RINC DK_RINC ES_RINC FI_RINC FR_RINC GB_RINC GE_RINC HR_RINC HU_RINC ///
   IL_RINC IN_RINC LT_RINC LV_RINC  NZ_RINC PH_RINC  RU_RINC  SE_RINC SI_RINC SK_RINC SR_RINC TH_RINC  ///
   TR_RINC TW_RINC US_RINC VE_RINC ZA_RINC    {
recode `x' 999990/max =.
}

foreach x in   CL_RINC IS_RINC  NO_RINC {
recode `x' 9999990/max =.
}

foreach x in   JP_RINC KR_RINC  {
recode `x' 99999990/max =.
}

foreach x in  BE_INC CH_INC  CZ_INC DE_INC  ES_INC FI_INC FR_INC GB_INC GE_INC HR_INC HU_INC ///
   IL_INC IN_INC LT_INC LV_INC  NZ_INC PH_INC  RU_INC  SE_INC SI_INC SK_INC SR_INC TH_INC  ///
   TR_INC TW_INC US_INC  ZA_INC    {
recode `x' 999990/max =.
}

foreach x in AU_INC  CL_INC IS_INC  NO_INC DK_INC VE_INC {
recode `x' 9999990/max =.
}

foreach x in   JP_INC   {
recode `x' 99999990/max =.
}

foreach x in    KR_INC  {
recode `x' 999999990/max =.
}


gen long rincome=.
format rincome %12.2f
replace rincome = AU_RINC if cntry == 36
replace rincome = BE_RINC if cntry == 56
*replace rincome = CA_RINC if cntry == 124
replace rincome = CH_RINC if cntry == 756
replace rincome = CL_RINC if cntry == 152
replace rincome = CZ_RINC if cntry == 203
replace rincome = DE_RINC if cntry == 276
replace rincome = DK_RINC if cntry == 208
*replace rincome = DO_RINC if cntry == 214
replace rincome = ES_RINC if cntry == 724
replace rincome = FI_RINC if cntry == 246
replace rincome = FR_RINC if cntry == 250
replace rincome = GB_RINC if cntry == 826
replace rincome = GE_RINC if cntry == 268
replace rincome = HR_RINC if cntry == 191
replace rincome = HU_RINC if cntry == 348
*replace rincome = IE_RINC if cntry == 372
replace rincome = IL_RINC if cntry == 376
replace rincome = IN_RINC if cntry == 356
replace rincome = IS_RINC if cntry == 352
replace rincome = JP_RINC if cntry == 392
replace rincome = KR_RINC if cntry == 410
replace rincome = LT_RINC if cntry == 440
replace rincome = LV_RINC if cntry == 428
*replace rincome = NL_RINC if cntry == 528
replace rincome = NO_RINC if cntry == 578
replace rincome = NZ_RINC if cntry == 554
replace rincome = PH_RINC if cntry == 608
*replace rincome = PL_RINC if cntry == 616
*replace rincome = PT_RINC if cntry == 620
replace rincome = RU_RINC if cntry == 643
replace rincome = SE_RINC if cntry == 752
replace rincome = SI_RINC if cntry == 705
replace rincome = SK_RINC if cntry == 703
replace rincome = SR_RINC if cntry ==  740
replace rincome = TH_RINC if cntry == 764
replace rincome = TR_RINC if cntry == 792
replace rincome = TW_RINC if cntry == 158
replace rincome = US_RINC if cntry == 840
*replace rincome = UY_RINC if cntry == 858
replace rincome = VE_RINC if cntry == 862
replace rincome = ZA_RINC if cntry == 710


gen long fincome=.
format fincome %12.2f
replace fincome = AU_INC if cntry == 36
replace fincome = BE_INC if cntry == 56
*replace fincome = CA_INC if cntry == 124
replace fincome = CH_INC if cntry == 756
replace fincome = CL_INC if cntry == 152
replace fincome = CZ_INC if cntry == 203
replace fincome = DE_INC if cntry == 276
replace fincome = DK_INC if cntry == 208
*replace fincome = DO_INC if cntry == 214
replace fincome = ES_INC if cntry == 724
replace fincome = FI_INC if cntry == 246
replace fincome = FR_INC if cntry == 250
replace fincome = GB_INC if cntry == 826
replace fincome = GE_INC if cntry == 268
replace fincome = HR_INC if cntry == 191
replace fincome = HU_INC if cntry == 348
*replace fincome = IE_INC if cntry == 372
replace fincome = IL_INC if cntry == 376
replace fincome = IN_INC if cntry == 356
replace fincome = IS_INC if cntry == 352
replace fincome = JP_INC if cntry == 392
replace fincome = KR_INC if cntry == 410
replace fincome = LT_INC if cntry == 440
replace fincome = LV_INC if cntry == 428
*replace fincome = NL_INC if cntry == 528
replace fincome = NO_INC if cntry == 578
replace fincome = NZ_INC if cntry == 554
replace fincome = PH_INC if cntry == 608
*replace fincome = PL_INC if cntry == 616
*replace fincome = PT_INC if cntry == 620
replace fincome = RU_INC if cntry == 643
replace fincome = SE_INC if cntry == 752
replace fincome = SI_INC if cntry == 705
replace fincome = SK_INC if cntry == 703
replace fincome = SR_INC if cntry ==  740
replace fincome = TH_INC if cntry == 764
replace fincome = TR_INC if cntry == 792
replace fincome = TW_INC if cntry == 158
replace fincome = US_INC if cntry == 840
*replace fincome = UY_INC if cntry == 858
replace fincome = VE_INC if cntry == 862
replace fincome = ZA_INC if cntry == 710

sort cntry
by cntry: egen inc_m= mean(rincome)
by cntry: egen inc_s= sd(rincome)
gen inc=(rincome-inc_m)/inc_s

by cntry: egen incfam_m= mean(fincome)
by cntry: egen incfam_s= sd(fincome)
gen incfam=(fincome-incfam_m)/incfam_s

by cntry: su rincome inc fincome incfam 

* Marital status
gen marital= MARITAL
gen nevermarried = 0
replace nevermarried = 1 if MARITAL == 6
replace nevermarried = . if MARITAL == .
gen divorced = 0
replace divorced = 1 if MARITAL == 3 | MARITAL == 4
replace divorced = . if MARITAL == .
gen widowed = 0
replace widowed = 1 if MARITAL == 5
replace widowed = . if MARITAL == .

/*household*/
gen household = HOMPOP

/* child */
gen child = .
replace child = 0 if HHCHILDR==0 & HHTODD==0
replace child = 1 if (HHCHILDR>0 & HHCHILDR<96) | (HHTODD>0 & HHTODD<96)

* rel. att.
recode ATTEND (0 97 98 99 =.)
recode ATTEND (1 2 3 4 5 8 = 0) (6 7 = 1), gen(at_low)
recode ATTEND (6 7 8 = 0) (1 2 3 4 5 = 1), gen(at_high)	 

/* urban/rural */
gen suburb=0
replace suburb=. if URBRURAL==0 | URBRURAL == 7 | URBRURAL== 8 | URBRURAL==9
replace suburb=1 if URBRURAL >=2 & URBRURAL <= 3

gen rural=0
replace rural=. if URBRURAL==0 | URBRURAL == 7 | URBRURAL== 8 | URBRURAL==9
replace rural=1 if URBRURAL >=4 & URBRURAL <= 5

* Ethnic

gen ethnic=.
replace ethnic = 0 if cntry==36 & (AU_ETHN1 == 1 |  AU_ETHN1 == 2)
replace ethnic = 1 if cntry==36 & !(AU_ETHN1 == 1 |  AU_ETHN1 == 2) & (AU_ETHN1 !=0 & AU_ETHN1 < 99)
replace ethnic = 0 if cntry==276 & (DE_ETHN1 == 276)
replace ethnic = 1 if cntry==276 & !(DE_ETHN1 == 276) & (DE_ETHN1 !=0 & DE_ETHN1 < 999)
replace ethnic = 0 if cntry==826 & (GB_ETHN1 == 9)
replace ethnic = 1 if cntry==826 & !(GB_ETHN1 == 9) & (GB_ETHN1 !=0 & GB_ETHN1 < 999)

replace ethnic = 0 if cntry==840 & ( US_ETHN1==3 | US_ETHN1==4 | US_ETHN1==7 | US_ETHN1== 8|  US_ETHN1==9 |US_ETHN1==10 | US_ETHN1== 11| US_ETHN1==12 | US_ETHN1==14 |  US_ETHN1== 15| ///
     US_ETHN1== 18|  US_ETHN1== 19 |US_ETHN1==21 |  US_ETHN1== 24 | US_ETHN1==25| US_ETHN1==26 |  US_ETHN1==27 |  US_ETHN1==32 |  US_ETHN1==36  ///
    | US_ETHN1==49| US_ETHN1==58 | US_ETHN1==61| US_ETHN1==69 | US_ETHN1==76 | US_ETHN1==81 | US_ETHN1==82 | US_ETHN1==83 |US_ETHN1==90 |US_ETHN1==96) 
replace ethnic = 1 if cntry==840 & !(  US_ETHN1==3 | US_ETHN1==4 | US_ETHN1==7 | US_ETHN1== 8|  US_ETHN1==9 |US_ETHN1==10 | US_ETHN1== 11| US_ETHN1==12 | US_ETHN1==14 |  US_ETHN1== 15| ///
     US_ETHN1== 18|  US_ETHN1== 19 |US_ETHN1==21 |  US_ETHN1== 24 | US_ETHN1==25| US_ETHN1==26 |  US_ETHN1==27 |  US_ETHN1==32 |  US_ETHN1==36  ///
    | US_ETHN1==49| US_ETHN1==58 | US_ETHN1==61| US_ETHN1==69 | US_ETHN1==76 | US_ETHN1==81 | US_ETHN1==82 | US_ETHN1==83 |US_ETHN1==90 |US_ETHN1==96)   & (US_ETHN1 !=0 & US_ETHN1 < 98)
	
replace ethnic = 0 if cntry==348 & (HU_ETHN1 == 1)
replace ethnic = 1 if cntry==348 & !(HU_ETHN1 == 1) & (HU_ETHN1 !=0 & HU_ETHN1 < 98)
replace ethnic = 0 if cntry==578 & (NO_ETHN1 == 1)
replace ethnic = 1 if cntry==578 & !(NO_ETHN1 == 1) & (NO_ETHN1 !=0 & NO_ETHN1 < 97)
replace ethnic = 0 if cntry==752 & (SE_ETHN1 == 752)
replace ethnic = 1 if cntry==752 & !(SE_ETHN1 == 752) & (SE_ETHN1 !=0 & SE_ETHN1 < 9999)
replace ethnic = 0 if cntry==203 & (CZ_ETHN1 == 1)
replace ethnic = 1 if cntry==203 & !(CZ_ETHN1 == 1) & (CZ_ETHN1 !=0 & CZ_ETHN1 < 99)
replace ethnic = 0 if cntry==705 & (SI_ETHN1 == 1)
replace ethnic = 1 if cntry==705 & !(SI_ETHN1 == 1) & (SI_ETHN1 !=0 & SI_ETHN1 < 99)
replace ethnic = 0 if cntry==643 & (RU_ETHN1 == 1)
replace ethnic = 1 if cntry==643 & !(RU_ETHN1 == 1) & (RU_ETHN1 !=0 & RU_ETHN1 < 97)
replace ethnic = 0 if cntry==554 & (NZ_ETHN1 == 2)
replace ethnic = 1 if cntry==554 & !(NZ_ETHN1 == 2) & (NZ_ETHN1 !=0 & NZ_ETHN1 < 99)
replace ethnic = 0 if cntry==392 & (JP_ETHN1 == 1)
replace ethnic = 1 if cntry==392 & !(JP_ETHN1 == 1) & (JP_ETHN1 !=0 & JP_ETHN1 < 99)
replace ethnic = 0 if cntry==724 & (ES_ETHN1 >= 1 & ES_ETHN1 <= 24) /* really strange ... */
replace ethnic = 1 if cntry==724 & !(ES_ETHN1 >= 1 & ES_ETHN1 <= 24) & (ES_ETHN1 !=0 & ES_ETHN1 < 99)
replace ethnic = 0 if cntry==428 & (LV_ETHN1 == 1 |  LV_ETHN1 == 2)
replace ethnic = 1 if cntry==428 & !(LV_ETHN1 == 1 |  LV_ETHN1 == 2) & (LV_ETHN1 !=0 & AU_ETHN1 < 97)
replace ethnic = 0 if cntry==250 & (FR_ETHN1 ==5)
replace ethnic = 1 if cntry==250 & !(FR_ETHN1 ==5) & (FR_ETHN1 !=0 & FR_ETHN1 < 99)
replace ethnic = 0 if cntry==191 & (HR_ETHN1 ==1)
replace ethnic = 1 if cntry==191 & !(HR_ETHN1 ==1) & (HR_ETHN1 !=0 & HR_ETHN1 < 99)
replace ethnic = 0 if cntry==208 & (DK_ETHN1 ==1)
replace ethnic = 1 if cntry==208 & !(DK_ETHN1 ==1) & (DK_ETHN1 !=0 & DK_ETHN1 < 98)
replace ethnic = 0 if cntry==246 & (FI_ETHN1 ==1 | FI_ETHN1 ==2)
replace ethnic = 1 if cntry==246 & !(FI_ETHN1 ==1 | FI_ETHN1 ==2) & (FI_ETHN1 !=0 & FI_ETHN1 < 99)
replace ethnic = 0 if cntry==710 & (ZA_ETHN1 ==1)
replace ethnic = 1 if cntry==710 & !(ZA_ETHN1 ==1) & (ZA_ETHN1 !=0 & ZA_ETHN1 < 99)

keep cntry id year OldAgeCare OldAgeCareC  Unemployed UnemployedC RedIncDiff RedIncDiffC Jobs JobsC HealthC  sex age educ1  employment parttime unemployed notactive self public   inc incfam ///
   marital nevermarried divorced widowed household child at_low at_high suburb rural ethnic
order cntry id year OldAgeCare OldAgeCareC  Unemployed UnemployedC RedIncDiff RedIncDiffC Jobs JobsC HealthC  sex age educ1  employment parttime unemployed notactive self public   inc incfam ///
   marital nevermarried divorced widowed household child at_low at_high suburb rural ethnic

sort cntry id

keep if cntry==36 | cntry== 276 | cntry==826 | cntry==840 | cntry==348 | cntry==578 | cntry==752 |cntry==203 ///
  | cntry==705 | cntry==643 | cntry==554 |  cntry== 608 | cntry==392 | cntry==724 | cntry==428 | cntry==250 | cntry== 756 ///
  | cntry==191 | cntry==208 | cntry==246 | cntry== 710

save "ISSP2016r_3", replace

* Merge
use "cri_macro.dta", clear 
rename iso_country cntry

gen mig_stock = migstock_un
replace mig_stock = migstock_wb if cntry==36 & year ==1985 /*  Australia 1985 */
replace mig_stock = migstock_wb if cntry==380 & year ==1985 /* italy 1995 */
replace mig_stock = migstock_wb if cntry==826 & year ==1985  /* UK 1985 */
replace mig_stock = migstock_wb if cntry==840 & year ==1985   /* USA 1995 */

* GDP
gen GDP=gdp_wb
replace GDP= gdp_twn if cntry==158
* Gini
sort cntry year
list gini* gni_wb in 1/100
gen GINI_dis= ginid_solt /* Gini disposable income */
replace GINI_dis= ginid_solt[_n-1] if GINI_dis ==. & year==2016 
replace GINI_dis= ginid_solt[_n-2] if GINI_dis ==. & year==2016  /* take most recent value */
gen GINI_mar= ginim_dolt /* Gini market income */
replace GINI_mar= ginim_dolt[_n-1] if GINI_mar ==. & year==2016
replace GINI_mar= ginim_dolt[_n-2] if GINI_mar ==. & year==2016
list cntry country year ginid_solt GINI_dis ginim_dolt GINI_mar if year > 2012 & year < 2017


**
*list cntry country year top mcp in 1/l
gen TOP = top10_wid
replace TOP= top10_wid[_n-1] if TOP ==. & year==2016
replace TOP= top10_wid[_n-2] if TOP ==. & year==2016
*list cntry country year top TOP if year > 2011 & year < 2017

gen MCP = mcp
replace MCP= mcp[_n-1] if MCP ==. & year==2016
replace MCP= mcp[_n-2] if MCP ==. & year==2016
list cntry country year mcp MCP if year > 2011 & year < 2017

list cntry country year pop_wb al_ethnic dpi_tf wdi_empprilo  wdi_unempilo socx_oecd  in 1/1000

gen POP = pop_wb
replace POP= pop_wb[_n-1] if POP ==. & year==2016
replace POP= pop_wb[_n-2] if POP ==. & year==2016
list cntry country year pop_wb POP if year > 2011 & year < 2017

gen FRAC = al_ethnic
replace FRAC= al_ethnic[_n-1] if FRAC ==. & year==2016
replace FRAC= al_ethnic[_n-2] if FRAC ==. & year==2016
list cntry country year al_ethnic FRAC if year > 2011 & year < 2017

gen POLI = dpi_tf
replace POLI= dpi_tf[_n-1] if POLI ==. & year==2016
replace POLI= dpi_tf[_n-2] if POLI ==. & year==2016
list cntry country year dpi_tf POLI if year > 2014 & year < 2017

gen EMP = wdi_empprilo
replace EMP= wdi_empprilo[_n-1] if EMP ==. & year==2016
replace EMP= wdi_empprilo[_n-2] if EMP ==. & year==2016
list cntry country year wdi_empprilo EMP if year > 2011 & year < 2017

gen UNEMP = wdi_unempilo
replace UNEMP= wdi_unempilo[_n-1] if UNEMP ==. & year==2016
replace UNEMP= wdi_unempilo[_n-2] if UNEMP ==. & year==2016
list cntry country year wdi_unempilo UNEMP if year > 2011 & year < 2017

gen SOCX = socx_oecd
destring SOCX socx_oecd, replace force
replace SOCX= socx_oecd[_n-1] if SOCX ==. & year==2016
replace SOCX= socx_oecd[_n-2] if SOCX ==. & year==2016
list cntry country year socx_oecd SOCX if year > 2011 & year < 2017

global L2 mig_stock mig_net2 GINI_dis GINI_mar TOP MCP POP FRAC POLI EMP UNEMP SOCX

* mignet
list cntry  year mignet_un
gen mig_net2=mignet_un
replace mig_net2=mignet_un[_n-1] if year[_n-1]==2015 /* transfer the values of 2015 to 2016 */
list cntry  year mignet_un mig_net2

save "L2data_17.dta", replace


use "ISSP1985r_3" , clear 
append using "ISSP1990r_3"
append using "ISSP1996r_3"
append using "ISSP2006r_3"
append using "ISSP2016r_3"

merge m:1 cntry year using "L2data_17.dta"
drop if _merge==2
drop _merge
merge m:1 cntry year using "netmig_un2.dta", keepusing(mig_net1)
drop if _merge==2

save "ISSPgr_3_f", replace

***

use "ISSPgr_3_f.dta", clear

drop if cntry==608
drop if cntry == 392
drop if cntry == 710
drop if (cntry==276  & year==1985) 

gen age2= age*age

egen cy = group(cntry year)
egen sl = tag(cntry year)


**********
* DV 
**********

sort cntry year
egen pick_survey = tag(cntry year)
egen survey= group(cntry year)

recode  JobsC (4=1) (3=2) (2=3) (1=4)
recode  HealthC (4=1) (3=2) (2=3) (1=4)
recode  OldAgeCareC (4=1) (3=2) (2=3) (1=4)
recode  UnemployedC (4=1) (3=2) (2=3) (1=4)
recode  RedIncDiffC (4=1) (3=2) (2=3) (1=4)

* factor analysis to create DV

*************

fac  OldAgeCareC   UnemployedC  RedIncDiffC  HealthC  , ipf fac(1) 
predict wsupport
replace wsupport = (wsupport/.8662188)*0.48

**********
* Take missing as an dummy 
**********
* educ1  employment parttime unemployed notactive self public   inc incfam  marital nevermarried divorced widowed household child at_low at_high suburb rural ethnic

gen secondary_m=0
replace secondary_m=1 if educ1==2
gen university_m=0
replace university_m=1 if educ1==3
gen educ1_miss=0
replace educ1_miss = 1 if educ1==.


gen parttime_m=parttime
gen unemployed_m=unemployed
gen notactive_m = notactive
gen self_m = self
gen employment_miss=0
replace employment_miss=1 if employment==.

gen public_m = public
gen public_miss=0
replace public_miss=1 if public==.

gen nevermarried_m = nevermarried
gen divorced_m=divorced
gen widowed_m=widowed
gen marital_miss=0
replace marital_miss=1 if marital==.

gen child_m=child
gen child_miss=0
replace child_miss=1 if child==.

gen at_low_m=at_low
gen at_high_m=at_high
gen at_miss=0
replace at_miss=1 if at_low==.

gen suburb_m=suburb
gen rural_m=rural
gen urb_miss=0
replace urb_miss=1 if suburb==.

gen inc_m = inc
replace inc_m =incfam if (cntry==380 & (year==1985 | year==1996)) | (cntry==724 & year==1996)


foreach x in parttime unemployed notactive self public   nevermarried divorced widowed child at_low at_high suburb rural {
recode `x'_m (.=0)
}


**************
* select country/years where variables are missing completly
***********

gen sel_inc =0
replace sel_inc  = 1 if (cntry==380 & (year==1995 | year==1996)) | (cntry==724 & year==1996)
gen sel_incfam =0
replace sel_incfam=1 if cntry==276 & year== 1985
gen sel_marital =0 
replace sel_marital=1 if (cntry==724 & year==1996)
gen sel_hh = 0
replace sel_hh = 1 if (cntry==724 & year==1996) | (cntry==36 & year==1996)
gen sel_child=0
replace sel_child=1 if (cntry==724 & year==1996) | (cntry==36 & year==1996) | (cntry==250 & year==1996) | (cntry==380 & year==1996) | (cntry==826 & year==1996)
gen sel_at =0
replace sel_at=1 if (cntry==380 & year==1985) | (cntry==724 & year==1996)
gen sel_urban=0
replace sel_urban=1 if  (cntry==36 & year==1996) |(cntry==276 & (year==1985 | year==1996)) | (cntry==380 & year==1996)|  (cntry==392 & year==1996)   |(cntry==724 & year==1996)  | (cntry==826 & year==1996) 


****************************
* Vars L2
****************************

sort cntry
by cntry: egen mig_stock_mn = mean(mig_stock)
by cntry: gen mig_stock_dev = mig_stock - mig_stock_mn

by cntry: egen mig_net1_mn = mean(mig_net1)
by cntry: gen mig_net1_dev = mig_net1 - mig_net1_mn

by cntry: egen mig_net2_mn = mean(mig_net2)
by cntry: gen mig_net2_dev = mig_net2 - mig_net2_mn

gen libwf =0
replace libwf=1 if cntry== 36 | cntry== 124 | cntry== 554 | cntry== 826 | cntry== 840 
gen eastwf =0
replace eastwf =1 if cntry== 191 |  cntry== 203 | cntry== 348 | cntry==428  | cntry== 616 | cntry== 643 |  cntry== 705

gen wstate=1
replace wstate=. if libwf==. | eastwf==.
replace wstate = 2 if libwf==1
replace wstate=3 if eastwf ==1
lab def wstate 1 "strong" 2 "lib" 3 "east"
lab val wstate wstate

gen migmn_libwf = mig_stock_mn * libwf
gen migdev_libwf = mig_stock_dev * libwf
gen migmn_eastwf = mig_stock_mn * eastwf
gen migdev_eastwf = mig_stock_dev * eastwf

tab country eastwf, miss

** CL interactions
gen migmn_ethnic = ethnic*mig_stock_mn
gen migdev_ethnic = ethnic*mig_stock_dev
gen gdp_ethnic = ethnic*GDP
gen gini_ethnic = ethnic*GINI_mar
gen unemp_ethnic = ethnic*UNEMP


save "ISSPgr_3b_f.dta", replace

*** ANALYSES ***

use "ISSPgr_3b_f.dta", clear

global indepvar1 i.sex age age2 ib2.educ1 i.employment public

*** PREFERRED MODEL

*PI adjustment
replace mig_net2=mig_net2/10
//

qui mixed wsupport $indepvar1 mig_stock_mn mig_stock_dev mig_net2 GDP GINI_mar POP SOCX EMP UNEMP year || cy:  
margins, dydx(mig_stock_mn) saving ("t17m1",replace)
margins, dydx(mig_stock_dev) saving ("t17m2",replace)
margins, dydx(mig_net2) saving ("t17m3",replace)

use t17m1,clear
append using t17m2
append using t17m3

gen f = [_n]
gen factor = "Immigrant Stock" if f==1
replace factor = "Immigrant Flow, per wave" if f==2
replace factor = "Immigrant Flow, 1-year" if f==3
clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
*PI adjustment for the average of 7.75 years between waves
replace AME = AME*7.75 if f==2
replace lower = lower*7.75 if f==2
replace upper = upper*7.75 if f==2
gen id = "t17m1"
replace id = "t17m2" if f==2
replace id = "t17m3" if f==3
order factor AME lower upper id
keep factor AME lower upper id
save team17,replace

erase L2data_17.dta
foreach x in 1985 1990 1996 2006 2016{
erase "ISSP`x'r_3.dta"
}
erase ISSPgr_3_f.dta
erase ISSPgr_3b_f.dta


foreach x of numlist 1/3{
erase "t17m`x'.dta"
}

}
*==============================================================================*
*==============================================================================*
*==============================================================================*

































// TEAM 19
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team19.dta"
	if _rc==0 {
		display "Team 19 already exists, skipping to next code chunk"
	}
else {

version 15
//PART 1: RECODES ISSP 1996

clear 
set more off


//------------------------------------------------------\\
//-------------------ISSP1996---------------------------\\
//open data
use "ZA2900.dta",clear 
//Country selection

recode v3 (1=36) (8=348) (14=203) (15=705) (20=124) (27=250) (2/3=276) (10=372) (24=392) ///
(19=554) (12=578) (25=724) (13=752) (30=756) (4=826) (6=840) (26=428) (16=616) (else=.), gen(cntry)
label define cntry 36 "Australia" 124 "Canada" 203 "Czech Republic" 250 "France" ///
276 "Germany" 348 "Hungary" 372 "Ireland" 392 "Japan" 428 "Latvia" 554 "New Zealand" ///
578 "Norway" 616 "Poland" 705 "Slovenia" 724 "Spain" 752 "Sweden" 756 "Switzerland" ///
826 "UK" 840 "USA"

label values cntry cntry


//------Dependent variable in tables 4 and 5: government responsibility-----\\

// Provide jobs for everyone
rename v36 jobs 

// Provide healthcare for the sick
rename v38 health

// Provide living standard for the old
rename v39 retirement

// Provide living standard for the unemployed
rename v41 unemp

// Reduce income differences
rename v42 income

// Provide decent housing to those who can't afford it
rename v44 housing


//Latent attitude variable
factor jobs health retirement unemp income housing, pcf
alpha jobs-housing
//alpha .84, 1 factor in pca --> to assume underlying latent dimension seems reasonable

//recode
recode jobs-housing (4=1) (3=2) (2=3) (1=4) 

label define gov_in 1 "should not be" 4 "definitely should"
label values jobs-housing gov_in

//delete all cases with missing on one of the dependent variables

egen miss_dv = rowmiss(jobs health retirement unemp income housing)
tab miss_dv 

keep if miss_dv == 0

egen gov_resp=rmean(jobs health retirement unemp income housing)


//-----Individual level controls (p.25-26)-----\\

//---------------------------------------
// (1) age & age-squared
//---------------------------------------
rename v201 age
gen agesq=age^2

//---------------------------------------
// (2) sex
//---------------------------------------
//p.25/26: "Female is coded 1"
recode v200 (1=0) (2=1), gen(female)

//---------------------------------------
// (3) Education, 3 dummies
//---------------------------------------
// p.26: "Education uses sec. degree as the reference, with dummies for less than sec. and uni or higher"
rename v205 education

gen lesssec=.
replace lesssec=1 if education>=1 & education<=4
replace lesssec= 0 if education >=5 & education<=7
label variable lesssec "Less than secondary education"

gen uni_above=.
replace uni_above=1 if education==7
replace uni_above= 0 if education >=1 & education<=6
label variable uni_above "university education or above"

gen highsec=.
replace highsec=1 if education==5 | education==6
replace highsec=0 if education>=1 & education<=4 | education==7
label variable highsec "secondary education"

//---------------------------------------
//(4) Labour market status
//---------------------------------------
// p.26: dummies for (1) part-time employment, (2) unemployment, (3) not in the labor force (ref=full-time) AND (1) self-employment(ref= work for someone else) --> public employment omitted (p. 26, left column)
// we encountreed some difficulty because the coding of some categories was uncleas (esp. those belonging to part-time). --> we coded according to the do-file
recode v206 (2/4=1) (nonmis=0), gen(pttime)
recode v206 (5=1)  (nonmis=0), gen(unempl)
recode v206 (6/10=1) (nonmis=0), gen(nolab)
recode v206 (1=1) (nonmis=0), gen(fltime)

label variable pttime "part-time employed"
label variable unempl "unemployed"
label variable nolab "not in labour force"
label variable fltime "full-time employed"

// self-employment
// following the authors' do-file, we only declared people missing, who did not reply in v206
//--> thus, self-employed is now contrast to every other category in v206, incl. unemployment and being out of the labour force
//crossing the two variables reveals 

generate slfemp=0
replace slfemp=1 if v213==1
replace slfemp=. if v206==.

//---------------------------------------
// (5) relative income
//---------------------------------------

sort cntry
by cntry: sum v218

rename v218 hhinc

gen hhinc_z=.
levelsof cntry, local(countries)
foreach value of local countries {
	zscore hhinc if cntry==`value', listwise
	replace hhinc_z=z_hhinc if cntry==`value'
	drop z_hhinc
}

sum hhinc_z
by cntry: sum hhinc_z


//---------------------------------------
// variables for merging: year and country 
//---------------------------------------
gen year=1996
keep if cntry==36 | cntry==124 | cntry==250 | cntry==276 | cntry==372 | cntry==392 | cntry==554 | cntry==578 | cntry==724 | cntry==752 ///
 | cntry==756 | cntry==826 | cntry==840 | cntry==203 |  cntry==705 | cntry==428 | cntry==616


//---------------------------------------
// Reduce data to relevant countries
//---------------------------------------
drop if cntry==.

//---------------------------------------
// save data
//---------------------------------------
save "ISSP1996_recoded_v2.dta", replace

//------------------------------------------------------\\
//-------------------ISSP2006---------------------------\\
//open ISSP 2006 
clear
use "ZA4700.dta"

//Country selection
//Selection of the 13 countries needed in the analyses in tables 4&5 (cp. p. 24, left column)
recode V3 (36=36) (124=124) (203=203) (250=250) (250=250) (276.1/276.2=276) (348=348) ///
(372=372) (392=392) (428=428) (554=554) (578=578) (616=616) (705=705) (724=724) (752=752) ///
(756=756) (826.1=826) (840=840) (else=.), gen(cntry)

label define cntry 36 "Australia" 124 "Canada" 203 "Czech Republic" 250 "France" ///
276 "Germany" 348 "Hungary" 372 "Ireland" 392 "Japan" 428 "Latvia" 554 "New Zealand" ///
578 "Norway" 616 "Poland" 705 "Slovenia" 724 "Spain" 752 "Sweden" 756 "Switzerland" ///
826 "UK" 840 "USA"

label values cntry cntry

//------Dependent variable in tables 4 and 5: GOV RESPONSIBILITY-----\\
// 6 variables measuring policy preferences in the field of jobs, unemployment, income, retirement, housing & healthcare (p.24, right column)
// Original coding: 1 "should be" to 4 "should not be", recode like 1996

// Provide jobs for everyone
rename V25 jobs 

// Provide healthcare for the sick
rename V27 health

// Provide living standard for the old
rename V28 retirement

// Provide living standard for the unemployed
rename V30 unemp

// Reduce income differences
rename V31 income

// Provide decent housing to those who can't afford it
rename V33 housing

sort cntry

//Latent attitude variable
factor jobs health retirement unemp income housing, pcf
alpha jobs-housing
//alpha .84, 1 factor in pca --> to assume underlying latent dimension seems reasonable

//recode
recode jobs-housing (4=1) (3=2) (2=3) (1=4) 

tab1 jobs health retirement unemp income housing, m
label define gov_in 1 "should not be" 4 "definitely should"
label values jobs-housing gov_in

//delete all cases with missing on one of the dependent variables

egen miss_dv = rowmiss(jobs health retirement unemp income housing)

keep if miss_dv == 0

egen gov_resp=rmean(jobs health retirement unemp income housing)


//-----Individual level controls (p.25-26)-----\\
//---------------------------------------
// (1) age & age-squared
//---------------------------------------
//age already named
gen agesq=age^2

//---------------------------------------
// (2) sex
//---------------------------------------
//sex already named
recode sex (1=0) (2=1), gen(female)

//---------------------------------------
// (3) Education, 3 dummies
//---------------------------------------
rename degree education

gen lesssec=.
replace lesssec=1 if education>=0 & education<=2
replace lesssec= 0 if education>=3 & education<=5
label variable lesssec "Less than higher secondary education"

gen uni_above=.
replace uni_above=1 if education==5
replace uni_above=0 if education >=0 & education<=4
label variable uni_above "university education or above"

gen highsec=.
replace highsec=1 if education==3 | education==4
replace highsec=0 if education>=0 & education<=2 | education==5
label variable highsec "higher secondary education"

//---------------------------------------
//(4) Labour market status
//---------------------------------------
// p.26: dummies for (1) part-time employment, (2) unemployment, (3) not in the labor force (ref=full-time) AND (1) self-employment(ref= work for someone else) --> public employment omitted (p. 26, left column)
// wrktype : private/public
// wrkst: employment status

recode wrkst (2/4=1) (nonmis=0), gen(pttime)
recode wrkst (5=1)  (nonmis=0), gen(unempl)
recode wrkst (6/10=1) (nonmis=0), gen(nolab)
recode wrkst (1=1) (nonmis=0), gen(fltime)
  
label variable pttime "part-time employed"
label variable unempl "unemployed"
label variable nolab "not in labour force"
label variable fltime "full-time employed"

generate slfemp=0
replace slfemp=1 if wrktype==4
replace slfemp=. if wrkst==.

//---------------------------------------
// (5) relative income
//---------------------------------------
gen hhinc_z=.
zscore *_INC

local hhinc="z_AU_INC z_CA_INC z_CH_INC z_CL_INC z_CZ_INC z_DE_INC z_DK_INC z_DO_INC z_ES_INC z_FI_INC z_FR_INC z_GB_INC z_HR_INC z_HU_INC z_IE_INC z_IL_INC z_JP_INC z_KR_INC z_LV_INC z_NL_INC z_NO_INC z_NZ_INC z_PH_INC z_PL_INC z_PT_INC z_RU_INC z_SE_INC z_SI_INC z_TW_INC z_US_INC z_UY_INC z_VE_INC z_ZA_INC" 
foreach value of local hhinc {
	replace hhinc_z=`value' if `value'!=.
	}
	drop z_AU_INC - z_ZA_INC	

sum hhinc_z
sort cntry
by cntry: sum hhinc_z


//---------------------------------------
// Merge variables: year and country
//---------------------------------------
keep if cntry==36 | cntry==124 | cntry==250 | cntry==276 | cntry==372 | cntry==392 | cntry==554 | cntry==578 | cntry==724 | cntry==752 ///
 | cntry==756 | cntry==826 | cntry==840 | cntry==203 |  cntry==705 | cntry==428 | cntry==616
gen year=2006


//---------------------------------------
// Reduce data to relevant countries
//---------------------------------------
drop if cntry==.


//---------------------------------------
// save data
//---------------------------------------
save "ISSP2006_recoded_v2.dta", replace

//PART 3: Merge & Analyses

clear

//------------------------------------------------------\\
//Macro data
use "cri_macro.dta"

rename iso_country cntry

keep if cntry==36 | cntry==124 | cntry==250 | cntry==276 | cntry==372 | cntry==392 | cntry==554 | cntry==578 | cntry==724 | cntry==752 ///
 | cntry==756 | cntry==826 | cntry==840 | cntry==203 |  cntry==705 | cntry==428 | cntry==616

keep if year==1996 | year==2006 

//GDP: New control variable --> oecd and wb highly correlated --> choose oecd
destring gdp_oecd gdp_wb, replace
rename gdp_oecd gdp

//percentage foreign born - only UN version covers all countries and years --> foreignpct
destring migstock_un, replace 
rename migstock_un foreignpct

//net migration (not available for 2016)
destring mignet_un, replace
rename mignet_un mignet

//social expenditure --> not available for 2016 in some countries //not availably for Hungary in 1996
destring socx_oecd, replace
rename socx_oecd socx

//unemployment rate (percent of active population 15+) --> different from employment rate used by BF
destring wdi_unempilo, replace
rename wdi_unempilo unemprate

save "cri_macro_recoded.dta", replace

clear

// open ISSP 2006 
use "ISSP2006_recoded_v2.dta"
		

//------------------------------------------------------\\
//---------------Merge 1996 & 2006----------------------\\

append using "ISSP1996_recoded_v2.dta"
sort year cntry


merge m:1 cntry year using "cri_macro_recoded.dta"

//determine if merger worked
sort year
by year: tab cntry

//Fixed effects variables: year and country
//year variable
gen yr2006=0
replace yr2006=1 if year==2006

//country dummies
quietly tab cntry, gen(cntryfe)

//------------------------------------------------------\\
//-------------------- Analyses--------------------------\\

//dependent gov_resp
global controls "age agesq female lesssec uni_above pttime unempl nolab slfemp hhinc_z yr2006"
global cntryfe "cntryfe1-cntryfe16"
global cntryvar "gdp foreignpct mignet socx unemprate" 

egen missing = rowmiss($controls)

keep if missing == 0

//------------------------------------------------------\\
//------------ Table 4: %foreign born (revised version)--------------------\\
//install outreg2

qui regress gov_resp foreignpct $controls $cntryfe
margins,dydx(foreignpct) saving ("t19m1",replace)
tab cntry year if e(sample)==1
qui regress gov_resp foreignpct socx $controls $cntryfe
margins,dydx(foreignpct) saving ("t19m2",replace)
tab cntry year if e(sample)==1
qui regress gov_resp foreignpct unemprate $controls $cntryfe
margins,dydx(foreignpct) saving ("t19m3",replace)
tab cntry year if e(sample)==1
qui regress gov_resp foreignpct gdp $controls $cntryfe
margins,dydx(foreignpct) saving ("t19m4",replace)
tab cntry year if e(sample)==1

//------------------------------------------------------\\
//------------ Table 5: net migration (revised version)--------------------\\
*PI adjustment
replace mignet = mignet/10
//

qui regress gov_resp mignet $controls $cntryfe
margins,dydx(mignet) saving ("t19m5",replace)
tab cntry year if e(sample)==1
qui regress gov_resp mignet socx $controls $cntryfe
margins,dydx(mignet) saving ("t19m6",replace)
tab cntry year if e(sample)==1
qui regress gov_resp mignet unemprate $controls $cntryfe
margins,dydx(mignet) saving ("t19m7",replace)
tab cntry year if e(sample)==1
qui regress gov_resp mignet gdp $controls $cntryfe
margins,dydx(mignet) saving ("t19m8",replace)
tab cntry year if e(sample)==1
qui regress gov_resp mignet foreignpct $controls $cntryfe
margins,dydx(foreignpct) saving ("t19m9",replace)
margins,dydx(mignet) saving ("t19m10",replace)
tab cntry year if e(sample)==1

use t19m1,clear
foreach x of numlist 2/10{
	append using t19m`x'
}
gen f = [_n]
gen factor = "Immigrant Stock" if f==1|f==2|f==3|f==4|f==9
replace factor = "Immigrant Flow, 1-year" if f==5|f==6|f==7|f==8|f==10

clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
gen id = "t19m1"
foreach x of numlist 2/10{
	replace id = "t19m`x'" if f==`x'
}

order factor AME lower upper id
keep factor AME lower upper id
save team19, replace

erase ISSP1996_recoded_v2.dta
erase ISSP2006_recoded_v2.dta
erase cri_macro_recoded.dta

foreach x of numlist 1/10{
erase "t19m`x'.dta"
}
}
*==============================================================================*
*==============================================================================*
*==============================================================================*





































// TEAM 21
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team21.dta"
	if _rc==0 {
		display "Team 21 already exists, skipping to next code chunk"
	}
else {
version 15
********************************
****COUNTRY-LEVEL CONTROLS******
*******************************

use "Mcountrydata.dta", clear

********************************
********** ISSP 1996 ***********
********************************

use "ZA2900.dta", clear

*****************************
******CONTEXT****************
*****************************

*** recode country codes so that those used in 1996 (1-30) match those used in 2006 (iSO: 36-862) - 2006 reference since 2006-only analysis

	recode v3 (1=36) (2/3=276) (4=826) (6=840) (8=348) (9=.) (10=372) (12=578) (13=752) (14=203) (15=705) (16=616) (17=.) (18=643) (19=554) (20=124) (21=608) (22/23=376) (24=392) (25=724) (26=428) (27=250) (28=.) (30=756), gen(country)
	label define country 36 "AU-Australia" 124 "CA-Canada" 152 "CL-Chile" 158 "TW-Taiwan" 191 "HR-Croatia" 203 "CZ-Czech" 208 "DK-Denmark" 214"DO-Dominican Republic" 246 "FI-Finland" 250 "FR-France" 276 "DE-Germany" 348 "-HU-Hungary" 372 "IE-Ireland" 376 "IL-Isreal" 392 "JP-Japan" 410 "SK-South Korea" 428 "LV-Latvia" 528 "NL-Netherlands" 554 "NZ-New Zealand" 578 "NO-Norway" 608 "PH-Philippines" 616 "PL-Poland" 620 "PT-Portugal" 643 "RU-Russia" 705 "SI-Slovenia" 710"ZA-South Africa" 724 "ES-Spain" 752 "SE-Sweden" 756 "CH-Switzerland" 826 "GB-Great Britain" 840 "US-United States" 858"UY-Uruguay" 862"VE-Venezuela" 
	label values country country
	
	keep if country==36| country==250| country==276| country==392| country==554| country==578| country==724| country==752| country==756| country==826| country==840

***************************
*** TECHNICAL VARIABLES ***
***************************

*YEAR

	gen year=1996
	
*COUNTRY IDENTIFIER

	label variable country "Country ID"
	
* INDIVIDUAL IDENTIFIER  - some of the codes overlap with codes present in 2006 data 

	rename v2 caseid
	
	gen str4 refyear_string=string(year, "%04.0f")
	gen str3 refcountry_string=string(country,"%03.0f" )
	gen str7 caseid_string=string(caseid, "%07.0f")
	gen case=refyear_string+"00"+ refcountry_string+ caseid_string 
	destring case, generate(CASEID)

	
*****************************
******DEPENDENT VARIABLE(S)**
***************************** 

*labelling  and reverse coding

	*JOBS Provide jobs for everyone
	recode v36 (1=4) (2=3) (3=2) (4=1), gen(jobs)
	label variable jobs "jobs"
	label define dep 1" Definitely not" 2"Probably not" 3"Probably should" 4"Definetely should"
	label values jobs dep 
	tabulate jobs, missing
	
	*UNEMPLOYMENT Provide living standard for the unemployed
	recode v41 (1=4) (2=3) (3=2) (4=1), gen(unemp)
	label variable unemp "unemployment"
	label values unemp dep
	tabulate unemp, missing 
	
	*INCOME Reduce income diff bw rich and poor
	recode v42 (1=4) (2=3) (3=2) (4=1), gen(incdiff)
	label variable incdiff "income difference"
	label values incdiff dep
	tabulate incdiff, missing
	
	*RETIREMENT Provide living standard for the old
	recode v39 (1=4) (2=3) (3=2) (4=1), gen(retire)
	label variable retire "retirement"
	label values retire dep
	tabulate retire, missing
	
	*HOUSING Provide decent housing to those who can't afford it
	recode v44 (1=4) (2=3) (3=2) (4=1), gen(housing)
	label variable housing "housing"
	label values housing dep
	tabulate housing, missing 
	
	*HEALTHCARE Provide healthcare for the sick
	recode v38 (1=4) (2=3) (3=2) (4=1), gen(hcare)
	label variable hcare "healthcare"
	label values hcare dep
	tabulate hcare, missing

****************************
*INDIVIDUAL-LEVEL CONTROLS**
****************************

*AGE

	rename v201 age

* FEMALE

	rename v200 sex
	recode sex (1=0) (2=1), gen(female)
	label variable female "sex"
	label define female 1"female" 0"male"
	label values female female


* EDUCATION (less than secondary, university or above, ref: secondary degree)

	rename v205 educat
	recode educat (1/4=1) (5/6=0)(7=2), gen(degree3)
	label define degree3 1 "less than secondary degree" 0 "Secondary"  2 "University or higher"
	label values degree3 degree3

* MAIN LABOUR MARKET STATUS (in paid work, in paid work.self-employed, unemployed, ref:not in the labor force)
	
	recode v206 (1/4=0)(5=2)(6/10=3), generate (lmstatus)
	replace lmstatus=1 if v213==1 & (v206!=. & v206!=4 & lmstatus!=2 & lmstatus!=3)
	replace lmstatus=. if lmstatus==0 & v206==.
	label variable lmstatus " current LM status"	
	label define lmstatus 0 "in paid work" 1"in paid work.self-employed" 2"unemployed" 3"not in the labour force"
	label values lmstatus lmstatus
 	

* RELATIVE INCOME - country-year-specific z-scores

	rename v218 faminc
	generate faminczscore=.
	levelsof country, local(cntries)
	foreach country of local cntries {
		zscore faminc if country==`country', listwise
		replace faminczscore=z_faminc if country==`country'
		drop z_faminc
	}

*POLITICAL TRUST - understood as INCUMBENT-BASED TRUST - see https://www.gesis.org/fileadmin/upload/forschung/publikationen/gesis_reihen/gesis_arbeitsberichte/GESIS_AB_7.pdf 


	egen inctrust= rowmean (v53 v54) 
	label variable inctrust "incumbent-based trust"

save "ISSP96replication_new.dta", replace


********************************
********** ISSP 2006 ***********
********************************

use "ZA4700.dta", clear
drop version

*********** ****************
*** TECHNICAL VARIABLES ***
***************************

*YEAR

	generate year=2006
	
*COUNTRY IDENTIFIER

	rename V3a country
	label define country 36 "AU-Australia" 124 "CA-Canada" 152 "CL-Chile" 158 "TW-Taiwan" 191 "HR-Croatia" 203 "CZ-Czech" 208 "DK-Denmark" 214"DO-Dominican Republic" 246 "FI-Finland" 250 "FR-France" 276 "DE-Germany" 348 "-HU-Hungary" 372 "IE-Ireland" 376 "IL-Isreal" 392 "JP-Japan" 410 "SK-South Korea" 428 "LV-Latvia" 528 "NL-Netherlands" 554 "NZ-New Zealand" 578 "NO-Norway" 608 "PH-Philippines" 616 "PL-Poland" 620 "PT-Portugal" 643 "RU-Russia" 705 "SI-Slovenia" 710"ZA-South Africa" 724 "ES-Spain" 752 "SE-Sweden" 756 "CH-Switzerland" 826 "GB-Great Britain" 840 "US-United States" 858"UY-Uruguay" 862"VE-Venezuela" 
	label values country country
	label variable country "Country ID"
	
	keep if country==36| country==250| country==276| country==392| country==554| country==578| country==724| country==752| country==756| country==826| country==840

* INDIVIDUAL IDENTIFIER - some identifier are used for individuals in different countries 

	rename V2 caseid
	
	gen str4 refyear_string=string(year, "%04.0f")
	gen str3 refcountry_string=string(country,"%03.0f" )
	gen str7 caseid_string=string(caseid, "%07.0f")
	gen case=refyear_string+"00"+ refcountry_string+ caseid_string
	destring case, generate(CASEID)
	
****************************
******DEPENDENT VARIABLE(S)*
**************************** 

* labelling

	*JOBS Provide jobs for everyone
	
	recode V25 (1=4) (2=3) (3=2) (4=1), gen(jobs)
	label variable jobs "jobs"
	label define dep 1" Definitely not" 2"Probably not" 3"Probably should" 4"Definetely should"
	label values jobs dep
	
	*UNEMPLOYMENT Provide living standard for the unemployed
	
	recode V30 (1=4) (2=3) (3=2) (4=1), gen(unemp)
	label variable unemp "unemployment"
	label values unemp dep
	
	*INCOME Reduce income diff bw rich and poor
	
	recode V31 (1=4) (2=3) (3=2) (4=1), gen(incdiff)
	label variable incdiff "income difference"
	label values incdiff dep
	
	*RETIREMENT Provide living standard for the old
	
	recode V28 (1=4) (2=3) (3=2) (4=1), gen(retire)
	label variable retire "retirement"
	label values retire dep
	
	*HOUSING Provide decent housing to those who can't afford it
	
	recode V33 (1=4) (2=3) (3=2) (4=1), gen(housing)
	label variable housing "housing"
	label values housing dep
	
	*HEALTHCARE Provide healthcare for the sick
	
	recode V27 (1=4) (2=3) (3=2) (4=1), gen(hcare)
	label variable hcare "healthcare"
	label values hcare dep
	
****************************
*INDIVIDUAL-LEVEL CONTROLS**
****************************

*AGE

* FEMALE

	recode sex (1=0) (2=1), gen(female)
	label variable female "sex"
	label define female 1"female" 0"male"
	label values female female


* EDUCATION (less than secondary, university or above, ref: secondary degree)

	recode degree (0/2=1) (3/4=0)(5=2), gen(degree3)
	label define degree3 1 "less than secondary degree" 0 "Secondary"  2 "University or higher"
	label values degree3 degree3


* MAIN LABOUR MARKET STATUS (in paid work, in paid work.self-employed, unemployed, ref:not in the labor force)
	
	recode wrkst (1/4=0)(5=2)(6/10=3), generate (lmstatus)
	replace lmstatus=1 if wrktype==4 & (wrkst!=. & wrkst!=4 & lmstatus!=2 & lmstatus!=3)
	replace lmstatus=. if lmstatus==0 & wrktype==.
	label variable lmstatus " current LM status"	
	label define lmstatus 0 "in paid work" 1"in paid work.self-employed" 2"unemployed" 3"not in the labour force"
	label values lmstatus lmstatus

* RELATIVE INCOME - country-year-specific z-scores

	gen faminczscore=.
	local famincvars = "AU_INC FR_INC DE_INC JP_INC GB_INC ES_INC NO_INC CH_INC US_INC NZ_INC SE_INC" 
	foreach famincvar of local famincvars {
	zscore `famincvar', listwise
	replace faminczscore=z_`famincvar' if z_`famincvar'!=.
	drop z_`famincvar'
	}


*POLITICAL TRUST - understood as INCUMBENT-BASED TRUST - see https://www.gesis.org/fileadmin/upload/forschung/publikationen/gesis_reihen/gesis_arbeitsberichte/GESIS_AB_7.pdf 

	rename V49 v49
	rename V50 v50
	
	egen inctrust= rowmean (v49 v50) 
	label variable inctrust "incumbent-based trust"

save "ISSP06replication_new.dta", replace


********************************
********** ISSP 2016 ***********
********************************

use "ZA6900_v2-0-0.dta", clear
drop version

***************************
*** TECHNICAL VARIABLES ***
***************************

*YEAR

	generate year=2016
	
*COUNTRY IDENTIFIER
	
	keep if country==36| country==250| country==276| country==392| country==554| country==578| country==724| country==752| country==756| country==826| country==840
	label variable country "Country ID"
	
*****************************
******DEPENDENT VARIABLE(S)**
***************************** 

*labelling 

	*JOBS Provide jobs for everyone
	
	recode v21 (1=4) (2=3) (3=2) (4=1), gen(jobs)
	label variable jobs "jobs"
	label define dep 1" Definitely not" 2"Probably not" 3"Probably should" 4"Definetely should"
	label values jobs dep
	replace jobs=. if jobs>4 
	
	*UNEMPLOYMENT Provide living standard for the unemployed
	
	recode v26 (1=4) (2=3) (3=2) (4=1), gen(unemp)
	label variable unemp "unemployment"
	label values unemp dep
	replace unemp=. if unemp>4
	
	*INCOME Reduce income diff bw rich and poor
	
	recode v27 (1=4) (2=3) (3=2) (4=1), gen(incdiff)
	label variable incdiff "income difference"
	label values incdiff dep
	replace incdiff=. if incdiff>4
	
	*RETIREMENT Provide living standard for the old
	
	recode v24 (1=4) (2=3) (3=2) (4=1), gen(retire)
	label variable retire "retirement"
	label values retire dep
	replace retire=. if retire>4
	
	*HOUSING Provide decent housing to those who can't afford it
	
	recode v29 (1=4) (2=3) (3=2) (4=1), gen(housing)
	label variable housing "housing"
	label values housing dep
	replace housing=. if housing>4
	
	*HEALTHCARE Provide healthcare for the sick
	
	recode v23 (1=4) (2=3) (3=2) (4=1), gen(hcare)
	label variable hcare "healthcare"
	label values hcare dep
	replace hcare=. if hcare>4
	
****************************
*INDIVIDUAL-LEVEL CONTROLS**
****************************

*AGE
	rename AGE age
	drop if age==-999
	
* FEMALE

	rename SEX sex
	recode sex (1=0) (2=1), gen(female)
	label variable female "sex"
	label define female 1"female" 0"male"
	label values female female
	drop if sex==9

* EDUCATION (less than secondary, university or above, ref: secondary degree)

	rename DEGREE degree
	drop if degree==9
	recode degree (0/1=1) (2/4=0)(5/6=2), gen(degree3)
	label define degree3 1 "less than secondary degree" 0 "Secondary"  2 "University or higher"
	label values degree3 degree3


* MAIN LABOUR MARKET STATUS (in paid work, in paid work.self-employed, unemployed, ref:not in the labor force)

	rename MAINSTAT main
	rename EMPREL emprel 
	recode main (1=0) (2=2)(3/9=3)(99=.), generate (lmstatus)
	replace lmstatus=1 if (emprel==2 | emprel==3) & main==1
	replace lmstatus=. if main==1 & emprel==9
	label variable lmstatus " current LM status"	
	label define lmstatus 0 "in paid work" 1"in paid work.self-employed" 2"unemployed" 3"not in the labour force"
	label values lmstatus lmstatus 	


* RELATIVE INCOME - country-year-specific z-scores

	gen faminczscore=.
	local famincvars = "AU_INC FR_INC DE_INC JP_INC GB_INC ES_INC NO_INC CH_INC US_INC NZ_INC SE_INC" 
	foreach famincvar of local famincvars {
	zscore `famincvar', listwise
	replace faminczscore=z_`famincvar' if z_`famincvar'!=.
	drop z_`famincvar'
	}

*POLITICAL TRUST - understood as INCUMBENT-BASED TRUST - see https://www.gesis.org/fileadmin/upload/forschung/publikationen/gesis_reihen/gesis_arbeitsberichte/GESIS_AB_7.pdf 
	
	replace v49=. if v49>5
	replace v50=. if v50>5
	
	egen inctrust= rowmean (v49 v50) 
	label variable inctrust "incumbent-based trust"

save "ISSP16replication_new.dta", replace


*************************************************************************************************************************************************
************************************************************MERGING DATA ************************************************************************
*************************************************************************************************************************************************

* APPEND THEN MERGE 

	append using "ISSP96replication_new.dta"
	append using "ISSP06replication_new.dta"
	sort country year
	merge m:1 country year using "Mcountrydata.dta"
	
* DUPLICATES IN TERMS OF CASE ID

		duplicates report CASEID
	
save "ISSP9616replication_new.dta", replace

* SELECT ONLY RELEVANT VARIABLES

keep CASEID country year jobs unemp incdif hcare retire housing age female degree3 lmstatus faminczscore inctrust laggedgini laggedgdpoecd laggedmigstock_un laggedmignet_un laggedsocx_oecd
format CASEID %16.0f
rename CASEID caseid

save "ISSP9616rep_n_red.dta", replace

* DATA FOR MPLUS 

*NOT YET RUN IN MPLUS BY THE PIs, xyz.dta provided by the researcher(s)
// stata2mplus caseid jobs unemp incdiff hcare retire housing  using "ISSP9616rep_n_red.dta", replace

* MERGING MPLUS DATA RESULTS 

use "ISSP9616rep_n_red.dta", clear
sort caseid
merge 1:1 caseid using "xyz.dta"


*************************************************************************************************************************************************
*************************************************************** ANALYSES ************************************************************************
*************************************************************************************************************************************************

*  prep for hybrid model 

tab degree3, gen(dgr)
tab lmstatus, gen(lmsts)  

gen mysample = !missing(Fscore, age, inctrust, faminczscore, female, dgr2-dgr3, lmsts1-lmsts3, caseid) 

foreach var of varlist age inctrust faminczscore female dgr2-dgr3 lmsts1-lmsts3{  
egen m`var' = mean(`var')if mysample, by (country year) 
} 

foreach var of varlist age inctrust faminczscore female dgr2-dgr3 lmsts1-lmsts3{  
gen d`var' = `var' - m`var' if mysample
}

gen magesq=mage*mage
gen dagesq=dage*dage

* hybrid model
 
*PI adjustment
replace Fscore = (Fscore/0.8793447)*0.48
//

*** TABLE 4: hybrid %FB ***


local ilcontrols " mage magesq dage dagesq mfaminczscore dfaminczscore minctrust dinctrust mfemale dfemale mdgr2-mdgr3 ddgr2-ddgr3 mlmsts1-mlmsts3 dlmsts1-dlmsts3 i.year i.country"

	qui regress Fscore c.laggedmigstock_un laggedgini laggedgdpoecd  `ilcontrols' 
	margins, dydx(c.laggedmigstock_un) saving ("t21m1",replace)
    tab country year if e(sample)==1

*** TABLE 5: hybrid NETMIG***

local ilcontrols " mage magesq dage dagesq mfaminczscore dfaminczscore minctrust dinctrust mfemale dfemale mdgr2-mdgr3 ddgr2-ddgr3 mlmsts1-mlmsts3 dlmsts1-dlmsts3 i.year i.country"

*PI adjustment
replace laggedmignet_un=laggedmignet_un/10
//

	qui regress Fscore c.laggedmignet_un laggedgini laggedgdpoecd  `ilcontrols' 
	margins, dydx(c.laggedmignet_un) saving ("t21m2",replace)
	tab country year if e(sample)==1
	
use t21m1,clear
append using t21m2
gen f= [_n]
gen factor = "Immigrant Stock" if f==1
replace factor = "Immigrant Flow, 1-year" if f==2
clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
gen id = "t21m1"
replace id = "t21m2" if f==2
order factor AME lower upper id
keep factor AME lower upper id
save team21, replace

foreach x in 9616 06 16 96 {
erase "ISSP`x'replication_new.dta"
}
erase ISSP9616rep_n_red.dta
erase t21m1.dta
erase t21m2.dta
}
*==============================================================================*
*==============================================================================*
*==============================================================================*































// TEAM 22
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team22.dta"
	if _rc==0 {
		display "Team 22 already exists, skipping to next code chunk"
	}
else {
set more off
version 15

*-----------------------------------------------------------------------------


******************************************************************************
*** Predictor of interest (ESS 2014 data)
******************************************************************************

// PIs do not replicate the ESS analysis. We use the file "ESS_prepared.dta"
// directly from the authors

/*
use "ESS7e02_1.dta", clear

keep if cntry=="BE" | cntry=="DK" | cntry=="FI" | cntry=="FR" | cntry=="DE" ///
	| cntry=="NO" | cntry=="ES" | cntry=="SE" | cntry=="CH" | cntry=="GB" 

* Recode country codes to ISO codes
encode cntry, gen(cntry2)
recode cntry2 ///
	(1 = 56 "Belgium") 			///
	(2 = 756 "Switzerland")		///
	(3 = 276 "Germany")			///
	(4 = 208 "Denmark")			///
	(5 = 724 "Spain")			///
	(6 = 246 "Finland")			///
	(7 = 250 "France")			///
	(8 = 826 "Great Britain")	///
	(9 = 578 "Norway")			///
	(10 = 752 "Sweden")			///
	, gen(country)	

* remove missings from variable on perceived immigrant share
recode noimbro (101/max =.), gen(immshare)
lab var immshare "Perceived Share Foreign Born" 

* collapse data by country, taking weighted mean of perceived immigrant share
collapse (mean) immshare [pweight = dweight], by(country)

* save prepared data 
save "ESS_prepared.dta", replace
*/

******************************************************************************
*** Other Macro level predictors (Compiled data)
******************************************************************************

use "L2_data.dta", clear

keep if country=="Belgium" | country=="Denmark" | country=="Finland" | ///
	country=="France" | country=="Germany" | country=="Norway" | ///
	country=="Spain" | country=="Sweden" | country=="Switzerland" | ///
	country=="United Kingdom"

encode country, gen(country2)

drop country

recode country2 ///
	(1 = 56 "Belgium") 			///
	(2 = 208 "Denmark")			///
	(3 = 246 "Finland")			///
	(4 = 250 "France")			///
	(5 = 276 "Germany")			///
	(6 = 578 "Norway")			///
	(7 = 724 "Spain")			///
	(8 = 752 "Sweden")			///
	(9 = 756 "Switzerland")		///
	(10 = 826 "United Kingdom")	///
	, gen(country)


keep if year==2010 | year==2014
destring socx_oecd, gen(socx)

/* we use socx and emp for 2014 and mcp for 2010, the latest year available*/

gen socx2014 = socx if year==2014

gen mcp2010 = mcp if year==2010

gen emp2014 = wdi_empprilo if year==2014

gen migstock_un2014 = migstock_un if year==2014
gen migstock_wb2014 = migstock_wb if year==2014

collapse (max) socx2014 mcp2010 emp2014 migstock_wb2014 migstock_un2014, by(country)

lab var socx2014 "Soc. Welfare Expenditure (2014)"
lab var emp2014 "Employment Rate (2014)"
lab var mcp2010 "Multiculturalism Policy Index (2010)"
lab var migstock_wb2014 "Immigrant Stock (WB, 2014)"
lab var migstock_un2014 "Immigrant Stock (UN, 2014)"

/* Generate a variable for the welfare regime (two dummies, reference is)
Christian Democrat */

gen liberal = 0
replace liberal = 1 if country==756 | country==826

lab var liberal "Liberal Welfare State"

gen socdem =0
replace socdem = 1 if country==208 | country==246 | country==578 | ///
	country==752

lab var socdem "Social Democratic Welfare State"

save "L2_prepared.dta", replace

******************************************************************************
*** Dependent variables (ISSP 2016 data)
******************************************************************************

use "ZA6900_v2-0-0.dta", clear

* Keep only countries for which we have our macro-indicator of interest

keep if country==56  | /// Belgium
		country==208 | /// Denmark
		country==246 | /// Finland
		country==250 | /// France
		country==276 | /// Germany
		country==578 | /// Norway
		country==724 | /// Spain
		country==752 | /// Sweden
		country==756 | /// Switzerland
		country==826   // GB


*** Jobs

	recode v21				///
		(1 2 = 1 "Yes")		///
		(3 4 = 0 "No")		///
		(8 9 =. )			///
		, gen(jobs)	
	lab var jobs "Jobs"
	
*** Unemployment

	recode v26				///
		(1 2 = 1 "Yes")		///
		(3 4 = 0 "No")		///
		(0 8 9 =.)			///
		, gen(unempl)
lab var unempl "Unemployment"

*** Income 

	recode v27 				///
		(1 2 = 1 "Yes")		///
		(3 4 = 0 "No")		///
		(8 9 = .)			///
		, gen(incdiff)	

	lab var incdiff "Income"
	
*** Retirement 

	recode v24				///
		(1 2 = 1 "yes")		///
		(3 4 = 0 "no")		///
		(8 9 = . )			///
		, gen(old)
	lab var old "Retirement"

*** Housing

	recode v29				///
		(1 2 = 1 "yes")		///
		(3 4 = 0 "no")		///
		(8 9 = . )			///
		, gen(housing)
	lab var housing "Housing"

*** Healthcare

	recode v23				///
		(1 2 = 1 "yes")		///
		(3 4 = 0 "no")		///
		(8 9 = . )			///
		, gen(health)
	lab var health "Healthcare"
	
******************************************************************************
*** Individual-Level Controls (ISSP 2016 data)
******************************************************************************

*** Age

	replace AGE=DK_AGE if country==208 //filling in values for Denmark
	recode AGE 				///
		(999 =.)			///
		, gen(age) 			// 167 missings
	lab var age "Age"

*** Age-squared

	gen age_sq = age*age // 167 missings
	lab var age_sq "Age-squared"	

*** Female

	recode SEX 				///
		(2 = 1 "Female")	///
		(1 = 0 "Male")		///
		(9 = .)				///
		, gen(female) // 129 missings
	lab var female "Female"
	
*** Married

	recode MARITAL ///
		(1 2 3 	= 1 "Married") ///
		(6 		= 2 "Never married") ///
		(4 		= 3 "Divorced") ///
		(5 		= 4 "Widowed") ///
		(7 9 	= .) ///
		, gen(married) // 1131 missings		
	lab var married "Civil Status"
	
*** Household size

	recode HOMPOP ///
		(0 99 = .) ///
		, gen(housesize) // 1378 missings		
	lab var housesize "Household size" 

*** Children

	recode HHCHILDR ///
		(1/13  	  = 1 "yes") ///
		(0 		  = 0 "no") ///	
		(96 97 99 = .) ///
		, gen(children) // 2704 missings		
	lab var children "Children" 

*** Urbanity

	recode URBRURAL ///
		(1 		 = 1 "urban") ///
		(2 3 	 = 2 "suburb/town") ///
		(4 5 	 = 3 "rural") ///
		(0 7 8 9 = .) ///
		, gen(urbanity) // 1820 missings
	lab var urbanity "Urbanity"

*** Education 

	recode DEGREE							///
		(0 1 	= 1 "Less than secondary")	///
		(2 3 4 	= 2 "Secondary")			///
		(5 6	= 3 "University or above")	///
		(9 		= .)						///
		, gen(edu) 							// 687 missings
	lab var edu "Education"
		
*** Labor market status

	recode MAINSTAT ///
		(1 4 		= 1 "employed") ///
		(2 			= 2 "unemployed") ///
		(3 5 6 7 8 	= 3 "not in the labor force") ///
		(9 99 		= .) ///
		, gen(empl) // 2464 missings
	
	lab var empl "Labor Market Status" 
	
*** Relative income

	recode BE_RINC (5001/max =.)
	egen incBE = std(BE_RINC)
	recode CH_RINC (11000/max =.)
	egen incCH = std(CH_RINC)
	recode DE_RINC (8001/max =.)
	egen incDE = std(DE_RINC)
	recode DK_RINC (900000/max =.)
	egen incDK = std(DK_RINC)
	recode ES_RINC (8000/max =.)
	egen incES = std(ES_RINC)
	recode FI_RINC (70000/max=.)
	egen incFI = std(FI_RINC)
	recode FR_RINC (100000/max=.)
	egen incFR = std(FR_RINC)
	recode GB_RINC (5000/max =.)
	egen incGB = std(GB_RINC)
	recode NO_RINC (2000000/max =.)
	egen incNO = std(NO_RINC)
	recode SE_RINC (900000/max =.)
	egen incSE = std(SE_RINC)
	gen income = incBE if country==56
	replace income = incCH if country==756
	replace income = incDE if country==276
	replace income = incDK if country==208
	replace income = incES if country==724
	replace income = incFI if country==246
	replace income = incFR if country==250
	replace income = incGB if country==826
	replace income = incNO if country==578
	replace income = incSE if country==752

lab var income "Relative Income"

*** Religious attendance 

	recode ATTEND ///
		(8 			= 1 "no") ///
		(1/5 		= 2 "low") ///
		(6 7 		= 3 "high") ///
		(0 97 98 99 = .) ///
		, gen(rel) // 1834 missings
	lab var rel "Religious attendance"

keep CASEID country jobs unempl incdiff old housing health age age_sq ///
	female married housesize children urbanity edu empl income rel

save "ISSP2016_prepared.dta", replace

*** MERGE ***
clear 

use "ISSP2016_prepared.dta", clear

merge m:1 country using "ESS_prepared.dta", nogen
merge m:1 country using "L2_prepared.dta", nogen

drop if missing(age, female, married, housesize, children, urbanity, edu, empl, income, rel)

*** ANALYSIS ***

******************************************************************************
*  Set control variables
******************************************************************************

global controls age age_sq i.female ib1.married housesize i.children ib1.urbanity ///
ib2.edu ib1.empl income ib1.rel immshare socx2014 i.liberal i.socdem emp2014 mcp2010

	
******************************************************************************
*  Actual Share Foreign Born - REPORTED MODELS
******************************************************************************

qui xtmixed jobs migstock_wb2014 $controls, vce(cluster country)
margins,dydx (migstock_wb2014) saving ("t22m1",replace)
qui xtmixed unempl migstock_wb2014 $controls, vce(cluster country)
margins,dydx (migstock_wb2014) saving ("t22m2",replace)
qui xtmixed incdiff migstock_wb2014 $controls, vce(cluster country)
margins,dydx (migstock_wb2014) saving ("t22m3",replace)
qui xtmixed old migstock_wb2014 $controls, vce(cluster country)
margins,dydx (migstock_wb2014) saving ("t22m4",replace)
qui xtmixed housing migstock_wb2014 $controls, vce(cluster country)
margins,dydx (migstock_wb2014) saving ("t22m5",replace)
qui xtmixed health migstock_wb2014 $controls, vce(cluster country)
margins,dydx (migstock_wb2014) saving ("t22m6",replace)

use t22m1, clear
foreach x of numlist 2/6{
append using t22m`x'
}
gen f = [_n]
gen factor = "Immigrant Stock"
clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
gen id = "t22m1"
foreach x of numlist 2/6{
replace id = "t22m`x'"  if f==`x'
}
order factor AME lower upper id
keep factor AME lower upper id
save team22, replace

foreach x of numlist 1/6{
erase "t22m`x'.dta"
}
erase "L2_prepared.dta" 
erase "ISSP2016_prepared.dta"

}		
*==============================================================================*
*==============================================================================*
*==============================================================================*

































// TEAM 23
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*
				
capture confirm file "team23.dta"
  if _rc==0  {
    display "Team 23 already exists, skipping to next code chunk"
  }
  else {
  version 15

*========================================================
*========================================================
*1) DEFINE VARIABLES in 1996 
*========================================================
*ISSP 1996 data 
use "ZA2900.dta", clear


*country 
recode v3 (1=36) (2/3=276) (4=826) (6=840) (8=348) (9=.) (10=372) (12=578) (13=752) (14=203) (15=705) (16=616) (17=.) (18=643) (19=554) (20=124) (21=608) (22/23=376) (24=392) (25=724) (26=428) (27=250) (28=.) (30=756), gen(v3a)
label define cntrylbl 36 "Australia" 124 "Canada" 152 "Chile" 158 "Taiwan" 191 "Croatia" 203 "Czech" 208 "Denmark" 246 "Finland" 250 "France" 276 "Germany" 348 "Hungary" 372 "Ireland" 376 "Isreal" 392 "Japan" 410 "S Korea" 428 "Latvia" 528 "Netherlands" 554 "New Zealand" 578 "Norway" 608 "Philippines" 616 "Poland" 620 "Portugal" 643 "Russia" 705 "Slovenia" 724 "Spain" 752 "Sweden" 756 "Switzerland" 826 "Great Britain" 840 "United States" 
label values v3a cntrylbl

*-------------------------------------------------------
*-------------------------------------------------------
*1.1) OUTCOME VARIABLES: 
*-------------------------------------------------------

*------------------------------------------
* GOV RESPONSIBILITY
*------------------------------------------

foreach var of varlist v36 v37 v38 v39 v40 v41 v42 v43 v44 v45{
 recode `var' (1=4) (2=3) (3=2) (4=1), gen(`var'b)
 recode `var'b (1/2=0) (3/4=1), gen(`var'c)
}
rename (v36b v37b v38b v39b v40b v41b v42b v43b v44b v45b) (govjobs govprices govhcare govretire indgrow govunemp govincdiff govstudents govhousing lawsenv) 
rename (v36c v37c v38c v39c v40c v41c v42c v43c v44c v45c) (dgovjobs dgovprices dhcare dgovretire dindgrow dgovunemp dgovincdiff dgovstud dgovhous dlawsenv) 

*----------------------------------------------------
*----------------------------------------------------
*1.2) CONTROL VARIABLES 
*----------------------------------------------------

*AGE
rename v201 age
gen agesq=age*age

*SEX
recode v200 (1=0) (2=1), gen(female)


*MARITAL STATUS
**missing for Spain
rename v202 marst
recode marst (5=1) (nonmiss=0), gen(nevermar)
recode marst (2/5=0), gen(married)
recode marst (3/4=1) (nonmiss=0), gen(divorced)
recode marst (2=1) (nonmiss=0), gen(widow)

*STEADY LIFE PARTNER
recode v203 (2=0), gen(partner)

*HOUSEHOLD SIZE
//top-coded at 8 for Great Britain, 9 for Slovenia
rename v273 hhsize

*CHILDREN IN HH
recode v274 (2/4=1) (6/8=1) (nonmiss=0), gen(kidshh)
local i = 10
while `i' < 27 {
	replace kidshh=1 if v274==`i'
	local i = `i' + 2
}
ta v274 kidshh
*RURAL
recode v275 (3=1) (nonmiss=0), gen(rural)
recode v275 (2=1) (nonmiss=0), gen(suburb)

*COUNTRY/PLACE OF BIRTH
rename v324 ETHNIC

*EDUCATION
rename v204 edyears
rename v205 edcat
recode edcat (1/3=1) (4=2) (5=3) (6=4) (7=5), gen(degree)
label define edlabels 1 "Primary/less" 2 "Some Secondary" 3 "Secondary" 4 "Some Higher Ed" 5 "University or higher"
label values degree edlabels


recode degree (1/2=1) (nonmiss=0), gen(lesshs)
recode degree (3/4=1) (nonmiss=0), gen(hs)
recode degree (5=1) (nonmiss=0), gen(univ)


*OCCUPATION
//see page 127 (210 of pdf) in codebook
rename v208 isco
rename v209 occ2
rename v215 hourswrk

recode v206 (2/10=0), gen(ftemp)
recode v206 (2/4=1) (nonmiss=0), gen(ptemp)
recode v206 (5=1) (nonmiss=0), gen(unemp)
recode v206 (6/10=1) (nonmiss=0), gen(nolabor)

gen selfemp=v213==1
replace selfemp=. if v206==.
gen pubemp=(v212==1 | v212==2)
replace pubemp=. if v206==.
gen pvtemp=(selfemp==0 & pubemp==0)
replace pvtemp=. if v206==.

*INCOME
// constructing country-specific z-scores, then a standardized cross-country income variable
rename v218 faminc

*findit zscore
gen inczscore=.
levelsof v3a, local(cntries)
foreach cntryval of local cntries {
	zscore faminc if v3a==`cntryval', listwise
	replace inczscore=z_faminc if v3a==`cntryval'
	drop z_faminc
}
*UNION MEMBER
recode v222 (2=0), gen(union)

*POLITICAL PARTY 
rename v223 party

*RELIGIOUS ATTENDANCE
recode v220 (1/2=1) (nonmiss=0), gen(highrel)
recode v220 (3/5=1) (nonmiss=0), gen(lowrel)
recode v220 (6=1) (nonmiss=0), gen(norel)
rename v220 religion

*---------------------------------------------------
*---------------------------------------------------
*1.3) TECHNICAL VARIABLES 
*----------------------------------------------------
*year
gen year=1996
gen yr2006=0

*country identifier
rename v3a cntry

*weights
rename v325 wghts

*---------------------------------------------------
*---------------------------------------------------
*1.4)SAVE FINAL 1996 dataset
*---------------------------------------------------
save "ISSP96recode.dta", replace


*========================================================
*========================================================
*2) DEFINE VARIABLES in 2006
*========================================================
*ISSP 20-6 data 
use "ZA4700.dta", clear

*-------------------------------------------------------
*-------------------------------------------------------
*2.1) OUTCOMES VARIABLES 
*-------------------------------------------------------

*--------------------------
*GOV RESPONSIBILITY
*--------------------------
// All variables originally coded 1 to 4, "should be" to "should not be"
// reverse coded, then dichotomous version collapses to "should be"/'maybe should be" and "maybe should not be"/"should not be"

foreach var of varlist V25 V26 V27 V28 V29 V30 V31 V32 V33 V34{
 recode `var' (1=4) (2=3) (3=2) (4=1), gen(`var'b)
 recode `var' (1/2=1) (3/4=0), gen(`var'c) //I have inverted the order probably data has changed 
}
rename (V25b V26b V27b V28b V29b V30b V31b V32b V33b V34b) (govjobs govprices govhcare govretire indgrow govunemp govincdiff govstudents govhousing lawsenv) 
rename (V25c V26c V27c V28c V29c V30c V31c V32c V33c V34c) (dgovjobs dgovprices dhcare dgovretire dindgrow dgovunemp dgovincdiff dgovstud dgovhous dlawsenv) 

*--------------------------------------------------------
*--------------------------------------------------------
*2.2) CONTROL VARIABLES 
*--------------------------------------------------------

*AGE
gen agesq=age*age

*SEX
recode sex(1=0) (2=1), gen(female)

*MARITAL STATUS
rename marital marst
recode marst (5=1) (nonmiss=0), gen(nevermar)
recode marst (2/5=0), gen(married)
recode marst (3/4=1) (nonmiss=0), gen(divorced)
recode marst (2=1) (nonmiss=0), gen(widow)

*STEADY LIFE PARTNER
recode cohab (2=0), gen(partner)
ta cohab partner,m

*HOUSEHOLD SIZE
// top-coded at 8 for Sweden, 9 for Denmark
rename hompop hhsize

*CHILDREN IN HH
recode hhcycle (2/4=1) (6/8=1) (nonmiss=0), gen(kidshh)
local i = 10
while `i' < 29 {
	replace kidshh=1 if hhcycle==`i'
	local i = `i' + 2
}

*RURAL
recode urbrural (1/3=0) (4/5=1), gen(rural)
recode urbrural (2/3=1) (nonmiss=0), gen(suburb)

*EDUCATION
rename educyrs edyears
rename degree edcat
recode edcat (0=1), gen(degree)
label define edlabels 1 "Primary/less" 2 "Some Secondary" 3 "Secondary" 4 "Some Higher Ed" 5 "University or higher"
label values degree edlabels

recode degree (1/2=1) (nonmiss=0), gen(lesshs)
recode degree (3/4=1) (nonmiss=0), gen(hs)
recode degree (5=1) (nonmiss=0), gen(univ)

*OCCUPATION
rename wrkst empstat
rename ISCO88 isco // see pg 137 in codebook
rename wrkhrs hourswrk

recode empstat (2/10=0), gen(ftemp)
recode empstat (2/4=1) (nonmiss=0), gen(ptemp)
recode empstat (5=1) (nonmiss=0), gen(unemp)
recode empstat (6/10=1) (nonmiss=0), gen(nolabor)

gen selfemp=wrktype==4
replace selfemp=. if empstat==.
gen pubemp=(wrktype==1 | wrktype==2)
replace pubemp=. if empstat==.
gen pvtemp=(selfemp==0 & pubemp==0)
replace pvtemp=. if empstat==.

*INCOME
gen inczscore=.
local incvars = "AU_INC CA_INC CH_INC CL_INC CZ_INC DE_INC DK_INC DO_INC ES_INC FI_INC FR_INC GB_INC HR_INC HU_INC IE_INC IL_INC JP_INC KR_INC LV_INC NL_INC NO_INC NZ_INC PH_INC PL_INC PT_INC RU_INC SE_INC SI_INC TW_INC US_INC UY_INC VE_INC ZA_INC" 
foreach incvar of local incvars {
	zscore `incvar', listwise
	replace inczscore=z_`incvar' if z_`incvar'!=.
	drop z_`incvar'
}

*UNION MEMBER
rename union unionb
recode unionb (2/3=0), gen(union)

*POLITICAL PARTY
rename PARTY_LR party

*RELIGIOUS ATTENDANCE
recode attend (1/3=1) (nonmiss=0), gen(highrel)
recode attend (4/7=1) (nonmiss=0), gen(lowrel)
recode attend (8=1) (nonmiss=0), gen(norel)
rename attend religion

*-------------------------------------------------------
*-------------------------------------------------------
*2.3) TECHNICAL VARIABLES
*-------------------------------------------------------

*Country Identifier
rename V3a cntry

*weights
rename weight wghts

*year
gen year=2006
gen yr2006=1

gen mail=mode==34

*------------------------------------------------------
*------------------------------------------------------
*3.1) append waves 1996 and 2006
*------------------------------------------------------
append using "ISSP96recode.dta"

*------------------------------------------------------
*------------------------------------------------------
*3.2) merge data with author's file 
*------------------------------------------------------
sort cntry year
merge m:1 cntry year using "BradyFinnigan2014CountryData.dta"
recode cntry (36=1) (124=1) (250=1) (276=1) (372=1) (392=1) (554=1) (578=1) (724=1) (752=1) (756=1) (826=1) (840=1) (else=0), gen(orig13)

*-----------------------------------------------------
*-----------------------------------------------------
*3.3) SAVE FINAL DATASET FOR ANALYSIS
*-----------------------------------------------------

*==================================================
*==================================================
*1996-2006 EXTENSION ANALYSES 
*==================================================

*select sample 
keep if orig13

*generate ISEI 
egen isco88=rowmax(isco SPISCO88 v210)
iscoisei ISEI, isco(isco88)
table cntry, c(mean ISEI min ISEI max ISEI sd ISEI)

global depvars "dgovjobs dgovunemp dgovincdiff dgovretire dgovhous dhcare"
global controls "age agesq female lesshs univ ptemp unemp nolabor selfemp inczscore yr2006"
global cntryvars "foreignpct netmigpct socx emprate"

egen allcontrols = rowmiss($controls)
recode allcontrols (0=1) (nonmiss=0)

quietly tab cntry, gen(cntryfe)

*PI to ensure comprability we run the margins command instead of mfx2 which is
*what the original authors used. The results are nearly identical
*-------------------------------------------
*2) MODELS WITH CONTROLS 
*-------------------------------------------


*** TABLE 4: FE % FOREIGN BORN ***
local i = 1
foreach depvar in $depvars {
	logit `depvar' foreignpct $controls cntryfe*, vce(cluster cntry)
	  margins, dydx(foreignpct) saving("t23m`i'", replace)
	  local i = `i'+1
	  tab cntry year if e(sample)==1
}

local i = 7
foreach depvar in $depvars {
	logit `depvar' foreignpct socx $controls cntryfe*, vce(cluster cntry)
	  margins, dydx(foreignpct) saving("t23m`i'", replace)
	  local i = `i'+1
	  	  tab cntry year if e(sample)==1

}

local i = 13
foreach depvar in $depvars {
	logit `depvar' foreignpct emprate $controls cntryfe*, vce(cluster cntry)
	  margins, dydx(foreignpct) saving("t23m`i'", replace)
	  local i = `i'+1
	  	  tab cntry year if e(sample)==1

}

*** TABLE 5: FE NET MIGRATION ***

*PI adjustment, B&F data (like Team 0)
replace netmigpct=netmigpct/5
//


local i = 25
foreach depvar in $depvars {
	logit `depvar' netmigpct $controls cntryfe*, vce(cluster cntry)
	  margins, dydx(netmigpct) saving("t23m`i'", replace)
	  local i = `i'+1
	  	  tab cntry year if e(sample)==1

}

local i = 31
foreach depvar in $depvars {
	logit `depvar' netmigpct socx $controls cntryfe*, vce(cluster cntry)
	  margins, dydx(netmigpct) saving("t23m`i'", replace)
	  local i = `i'+1
	  	  tab cntry year if e(sample)==1

}

local i = 37
foreach depvar in $depvars {
	logit `depvar' netmigpct emprate $controls cntryfe*, vce(cluster cntry)
	  margins, dydx(netmigpct) saving("t23m`i'", replace)
	  local i = `i'+1
	  	  tab cntry year if e(sample)==1

}

local i = 43
local j = 19
foreach depvar in $depvars {
	logit `depvar' netmigpct foreignpct $controls cntryfe*, vce(cluster cntry)
	  margins, dydx(netmigpct) saving("t23m`i'", replace)
	  margins, dydx(foreignpct) saving("t23m`j'", replace)
	  local i = `i'+1 
	  local j = `j'+1
	  	  tab cntry year if e(sample)==1

}

use t23m1, clear
foreach i of numlist 2/48 {
append using t23m`i'
}
gen f = [_n]
gen factor = "Immigrant Stock"
replace factor = "Immigrant Flow, 1-year" if f>24

clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
gen id = "t23m1"
foreach i of numlist 2/48 {
replace id = "t23m`i'" if f==`i'
}


foreach i of numlist 1/48 {
erase "t23m`i'.dta"
}
order factor AME lower upper id
keep factor AME lower upper id
save team23.dta, replace
erase "ISSP96recode.dta"
}
*==============================================================================*
*==============================================================================*
*==============================================================================*

































// TEAM 26
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team26.dta"
  if _rc==0  {
    display "Team 26 already exists, skipping to next code chunk"
  }
  else {
  version 15

		* prepare 1996
		use "ZA2900.dta", clear
		**General labels
		label define yesno 0 "no" 1 "yes"
		label define dvrev 1 "Definitely not" 2 "Probably not" 3 "Probably should" 4 "Definitely should"
		label define cntry_lab 36 "Australia" 100 "Bulgaria" 124 "Canada" 191 "Croatia" 196 "Cyprus" 203 "Czech Republic" 208 "Denmark" 246 "Finland" 250 "France" 276 "Germany" 826 "Great Britain" 348 "Hungary" ///
					  372 "Ireland" 376 "Israel" 380 "Italy" 392 "Japan" 428 "Latvia" 554 "New Zealand" 578  "Norway" 608 "Phillipines" 616 "Poland" 643 "Russia" 705 "Slovenia" 724 "Spain" 752 "Sweden" ///
					  756  "Switzerland" 840 "USA"

		* system variables
		gen newid=_n
		gen double id=199600000+newid

		**country
		gen cntry=.
		replace cntry=36 if v3==1
		replace cntry=100 if v3==17
		replace cntry=124 if v3==20
		replace cntry=196 if v3==28
		replace cntry=203 if v3==14
		replace cntry=250 if v3==27
		replace cntry=276 if v3==2
		replace cntry=276 if v3==3
		replace cntry=348 if v3==8
		replace cntry=372 if v3==10
		replace cntry=376 if v3==22
		replace cntry=376 if v3==23
		replace cntry=380 if v3==9
		replace cntry=392 if v3==24
		replace cntry=428 if v3==26
		replace cntry=554 if v3==19
		replace cntry=578 if v3==12
		replace cntry=608 if v3==21
		replace cntry=616 if v3==16
		replace cntry=643 if v3==18
		replace cntry=705 if v3==15
		replace cntry=724 if v3==25
		replace cntry=752 if v3==13
		replace cntry=756 if v3==30
		replace cntry=826 if v3==4
		replace cntry=840 if v3==6

		keep if cntry==36 | cntry==124 | cntry==191 | cntry==203 | cntry==208 | cntry==246 | cntry==250 | cntry==276 | cntry==826 | cntry==348 | ///
					  cntry==372 | cntry==392  | cntry==428  | cntry==554  | cntry==578  | cntry==616  | cntry==705 | cntry==724  | cntry==752 | ///
					  cntry==756  | cntry==840

		label variable cntry "Country"
		label values cntry cntry_lab
		table cntry v3

		**year
		gen study=v1
		label variable study "Study Number GESIS"
		gen yearm=.
		replace yearm=1995 if cntry==705
		replace yearm=1996 if cntry==36 | cntry==124 | cntry==196 | cntry==203 | cntry==276 | cntry==826 | cntry==348 | cntry==372 | cntry==376 | cntry==380 | cntry==392 | cntry==428 | cntry==578 | cntry==608 | cntry==724 | cntry==752 | cntry==840 
		replace yearm=1997 if cntry==100 | cntry==250 | cntry==554 | cntry==616 | cntry==643
		replace yearm=1998 if cntry==756
		label variable year "Year of Fieldwork in Country"
		gen year = yearm - 1

		**outcomes
		gen oldage=v39*-1+5
		label variable oldage "Gov: Should provide for the elderly"
		label values oldage dvrev

		gen unemployed=v41*-1+5
		label variable unemployed "Gov: Should provide for the unemployed"
		label values unemployed dvrev

		gen reducinc=v42*-1+5
		label variable reducinc "Gov: Should reduce inequality"
		label values reducinc dvrev

		gen jobs=v36*-1+5
		label variable jobs "Gov: Should provide jobs for all"
		label values jobs dvrev

		**female
		gen female=.
		replace female=1 if v200==2
		replace female=0 if v200==1
		tab female
		label variable female "Gender: Female"
		label values female yesno

		**age
		gen age=v201

		**educ
		gen educ=.
		replace educ=1 if v205==1 & v206!=6
		replace educ=1 if v205==2 | v205==3
		replace educ=2 if v205==4 | v205==5
		replace educ=3 if v205==6 | v205==7
		label variable educ "R: Highest Education Level"
		label define educ_lb 1 "Primary or less" 2 "Secondary" 3 "Tertiary"
		label values educ educ_lb

		**empl - revised employment status (adjusted for 2006 categories)
		gen empl=.
		replace empl=1 if v206==1 | v206==2 | v206==3
		replace empl=2 if v206==5 
		replace empl=3 if v206==4 | v206==6 | v206==7 | v206==8 | v206==9 | v206==10
		tab empl
		label variable empl "R: Labor Market Status"
		label define empl_lb 1 "Employed (Full-time)" 2 "Unemployed" 3 "Inactive"
		label values empl empl_lb

		** LR
		gen LR = .
		replace LR = 1 if v223 == 3 | v223 >=6
		replace LR = 2 if v223 >= 1 & v223 <=2
		replace LR = 3 if v223 >= 4 & v223 <=5
		label variable LR "R: Left Right Party Pref."
		label define lrlb 1 "Center or None" 2 "Left" 3 "Right"
		label values LR lrlb

		* income
		gen incomeh = v218
		replace incomeh = . if income == 999996 | income == 1500 | income == 53 // remove dubious categories

		egen income = xtile(incomeh), by(v3) p(10(10)90)

		keep id oldage unemployed reducinc jobs year study female age educ empl cntry LR income
		save "r2_issp1996.dta", replace

		*** prepare 2006
		use "ZA4700.dta" , clear
		label define cntry_lab 36 "Australia" 100 "Bulgaria" 124 "Canada" 191 "Croatia" 196 "Cyprus" 203 "Czech Republic" 208 "Denmark" 246 "Finland" 250 "France" 276 "Germany" 826 "Great Britain" 348 "Hungary" ///
					  372 "Ireland" 376 "Israel" 380 "Italy" 392 "Japan" 428 "Latvia" 554 "New Zealand" 578  "Norway" 608 "Phillipines" 616 "Poland" 643 "Russia" 705 "Slovenia" 724 "Spain" 752 "Sweden" ///
					  756  "Switzerland" 840 "USA"


		* system variables
		gen newid=_n
		gen double id=200600000+newid

		*cntry
		gen cntry = V3
		recode cntry (276.1 = 276) (276.2 = 276) (376.1 = 376) (376.2 = 376) (826.1 = 826)

		keep if cntry==36 | cntry==124 | cntry==191 | cntry==203 | cntry==208 | cntry==246 | cntry==250 | cntry==276 | cntry==826 | cntry==348 | ///
					  cntry==372 | cntry==392  | cntry==428  | cntry==554  | cntry==578  | cntry==616  | cntry==705 | cntry==724  | cntry==752 | ///
					  cntry==756  | cntry==840

		label variable cntry "Country"
		label values cntry cntry_lab
		table cntry V3
		label variable cntry "Country"
		label values cntry cntry_lab

		*year
		gen study=4700
		label variable study "Study Number GESIS"
		gen yearm=.
		replace yearm=2007 if cntry==36 | cntry==124  | cntry==428 | cntry==724 | cntry==756
		replace yearm=2008 if cntry==208 |cntry==616 
		replace yearm=2006 if yearm!=2007 & yearm!=2008
		label variable yearm "Year of Fieldwork Ended"
		table yearm cntry, mis
		gen year = yearm - 1

		**General labels
		label define yesno 0 "no" 1 "yes"
		label define dvrev 1 "Definitely not" 2 "Probably not" 3 "Probably should" 4 "Definitely should"

		* outcomes
		gen oldage = V28*-1+5
		label variable oldage "Gov: Should provide for the elderly"
		label values oldage dvrev

		gen unemployed = V30*-1+5
		label variable unemployed  "Gov: Should provide for the unemployed"
		label values unemployed  dvrev

		gen reducinc = V31*-1+5
		label variable reducinc "Gov: Should reduce inequality"
		label values reducinc dvrev

		gen jobs = V25*-1+5
		label variable jobs "Gov: Should provide jobs for all"
		label values jobs dvrev

		***individual level predictors
		gen female = sex
		recode female (1=0) (2=1)
		label variable female "Gender: Female"
		label values female yesno


		gen educ = .
		replace educ = 1 if degree <= 1
		replace educ = 2 if degree == 2 | degree == 3
		replace educ = 3 if degree >= 4
		label variable educ "R: Highest Education Level"
		label define educ_lb 1 "Primary or less" 2 "Secondary" 3 "Tertiary"
		label values educ educ_lb
		
		gen empl = .
		replace empl = 1 if wrkst == 1
		replace empl = 3 if wrkst == 2 | wrkst == 3 | wrkst ==4 | wrkst >= 6
		replace empl = 2 if wrkst == 5 
		label variable empl "R: Labor Market Status"
		label define empl_lb 1 "Employed (Full-time)" 2 "Unemployed" 3 "Inactive"
		label values empl empl_lb


		** Left-right
		gen LR = .
		replace LR = 1 if PARTY_LR == 3 | PARTY_LR >=6
		replace LR = 2 if PARTY_LR >= 1 & PARTY_LR <=2
		replace LR = 3 if PARTY_LR >= 4 & PARTY_LR <=5
		label variable LR "R: Left Right Party Pref."
		label define lrlb 1 "Center or None" 2 "Left" 3 "Right"
		label values LR lrlb

		* income
		gen incomeh = .
		replace incomeh = AU_DEGR if V3 == 36
		replace incomeh = CA_DEGR if V3 == 124
		replace incomeh = HR_DEGR if V3 == 191
		replace incomeh = CZ_DEGR if V3 == 203
		replace incomeh = DK_DEGR if V3 == 208
		replace incomeh = FI_DEGR if V3 == 246
		replace incomeh = FR_DEGR if V3 == 250
		replace incomeh = HU_DEGR if V3 == 348
		replace incomeh = IE_DEGR if V3 == 372
		replace incomeh = JP_DEGR if V3 == 392
		replace incomeh = LV_DEGR if V3 == 428
		replace incomeh = NZ_DEGR if V3 == 554
		replace incomeh = NO_DEGR if V3 == 578
		replace incomeh = PL_DEGR if V3 == 616
		replace incomeh = SI_DEGR if V3 == 705
		replace incomeh = ES_DEGR if V3 == 724
		replace incomeh = SE_DEGR if V3 == 752
		replace incomeh = CH_DEGR if V3 == 756
		replace incomeh = US_DEGR if V3 == 840

		egen income = xtile(incomeh), by(V3) p(10(10)90)

		keep id oldage unemployed reducinc jobs year study female age educ empl cntry LR income
		save "r2_issp2006.dta", replace

		* prepare 2016
		*** recode variables
		use "ZA6900_v2-0-0.dta", clear

		**General labels
		label define yesno 0 "no" 1 "yes"
		label define dvrev 1 "Definitely not" 2 "Probably not" 3 "Probably should" 4 "Definitely should"

		***New ID codes
		gen newid=_n
		gen double id=201600000+newid
		tab country, nolab
		gen cntry=country
		keep if cntry==36 | cntry==124 | cntry==191 | cntry==203 | cntry==208 | cntry==246 | cntry==250 | cntry==276 | cntry==826 | cntry==348 | ///
					  cntry==372 | cntry==392  | cntry==428  | cntry==554  | cntry==578  | cntry==616  | cntry==705 | cntry==724  | cntry==752 | ///
					  cntry==756  | cntry==840

		label define cntry_lab 36 "Australia" 100 "Bulgaria" 124 "Canada" 191 "Croatia" 196 "Cyprus" 203 "Czech Republic" 208 "Denmark" 246 "Finland" 250 "France" 276 "Germany" 826 "Great Britain" 348 "Hungary" ///
					  372 "Ireland" 376 "Israel" 380 "Italy" 392 "Japan" 428 "Latvia" 554 "New Zealand" 578  "Norway" 608 "Phillipines" 616 "Poland" 643 "Russia" 705 "Slovenia" 724 "Spain" 752 "Sweden" ///
					  756  "Switzerland" 840 "USA"
					  
		label variable cntry "Country"
		label values cntry cntry_lab
		tab cntry

		*year
		gen study=6900
		label variable study "Study Number GESIS"
		gen yearm=.
		replace yearm=2016 if cntry==203 | cntry==208 | cntry==246 | cntry==250 | cntry==276 | cntry==826 | cntry==348 | cntry==392 | cntry==428 | cntry==554 | cntry==705 | cntry==724 | cntry==752 | cntry==840
		replace yearm=2017 if cntry==36 | cntry==191 | cntry==578 | cntry==756
		replace yearm=2016 if cntry==616 /*Could not find when Poland had its fieldsurvey, sent an email to Nate*/
		label variable yearm "Year of Fieldwork Ended"
		gen year = yearm - 1


		* outcomes
		mvdecode v24, mv(8/9)
		gen oldage = v24*-1+5
		label variable oldage "Gov: Should provide for the elderly"
		label values oldage dvrev

		mvdecode v26, mv(0 8/9)
		gen unemployed = v26*-1+5
		label variable unemployed  "Gov: Should provide for the unemployed"
		label values unemployed  dvrev

		mvdecode v27, mv(8/9)
		gen reducinc = v27*-1+5
		label variable reducinc "Gov: Should reduce inequality"
		label values reducinc dvrev

		mvdecode v21, mv(8/9)
		gen jobs = v21*-1+5
		label variable jobs "Gov: Should provide jobs for all"
		label values jobs dvrev


		**female
		gen female=.
		replace female=1 if SEX==2
		replace female=0 if SEX==1
		tab female
		label variable female "Gender: Female"
		label values female yesno

		**age --- Issue with DK
		gen age=AGE
		replace age = DK_AGE if country==208

		**educ
		mvdecode DEGREE, mv(9=.)
		gen educ=.
		replace educ = 1 if DEGREE <= 1
		replace educ = 2 if DEGREE  == 2 | DEGREE == 3
		replace educ = 3 if DEGREE  >= 4 & DEGREE<9
		label variable educ "R: Highest Education Level"
		label define educ_lb 1 "Primary or less" 2 "Secondary" 3 "Tertiary"
		label values educ educ_lb

		***
		*empl
		gen empl=.
		replace empl=1 if MAINSTAT==1
		replace empl=2 if MAINSTAT==2 
		replace empl=3 if MAINSTAT==3 | MAINSTAT==4 | MAINSTAT==5 | MAINSTAT==6 | MAINSTAT==7 | MAINSTAT==8
		label variable empl "R: Labor Market Status"
		label define empl_lb 1 "Employed (Full-time)" 2 "Unemployed" 3 "Inactive"
		label values empl empl_lb

		** LR
		gen LR = .
		replace LR = 1 if PARTY_LR == 3 | PARTY_LR >=6
		replace LR = 2 if PARTY_LR >= 1 & PARTY_LR <=2
		replace LR = 3 if PARTY_LR >= 4 & PARTY_LR <=5
		label variable LR "R: Left Right Party Pref."
		label define lrlb 1 "Center or None" 2 "Left" 3 "Right"
		label values LR lrlb

		* income
		gen incomeh = .
		replace incomeh = AU_DEGR if country == 36
		replace incomeh = HR_DEGR if country == 191
		replace incomeh = CZ_DEGR if country == 203
		replace incomeh = DK_DEGR if country == 208
		replace incomeh = FI_DEGR if country == 246
		replace incomeh = FR_DEGR if country == 250
		replace incomeh = DE_RINC if country == 276
		replace incomeh = HU_DEGR if country == 348
		replace incomeh = JP_DEGR if country == 392
		replace incomeh = LV_DEGR if country == 428
		replace incomeh = NZ_DEGR if country == 554
		replace incomeh = NO_DEGR if country == 578
		replace incomeh = SI_DEGR if country == 705
		replace incomeh = ES_DEGR if country == 724
		replace incomeh = SE_DEGR if country == 752
		replace incomeh = CH_DEGR if country == 756
		replace incomeh = GB_RINC if country == 826
		replace incomeh = US_DEGR if country == 840

		egen income = xtile(incomeh), by(country) p(10(10)90)

		keep id oldage unemployed reducinc jobs year study female age educ empl cntry LR income
		save "r2_issp2016.dta", replace

		* combine data
		merge 1:1 id cntry using "r2_issp1996.dta"
		drop _merge
		merge 1:1 id cntry using "r2_issp2006.dta"
		
		* additional labelling
		tab study year
		label define study_lb 2900 "ISSP 1996" 4700 "ISSP 2006" 6900 "ISSP 2016"
		label value study study_lb
		
		label variable age "Age"
		label variable income "Income"
		label define year_lb 1994 "1994" 1995 "1995" 1996 "1996" 1997 "1997" 2005 "2005" 2006 "2006" 2007 "2007" 2015 "2015" 2016 "2016"
		label values year year_lb
		
		**Country selection
		keep if cntry==36 | cntry==124 | cntry==191 | cntry==203 | cntry==208 | cntry==246 | cntry==250 | cntry==276 | cntry==826 | cntry==348 | ///
					  cntry==372 | cntry==392  | cntry==428  | cntry==554  | cntry==578  | cntry==616  | cntry==705 | cntry==724  | cntry==752 | ///
					  cntry==756  | cntry==840

		**Confirmatory Factor Analysis
/*		sem (WFS-> oldage unemployed reducinc jobs ) if year==1995 //structural equation modelling of trstprl&trstun
		estat gof, stats (all) //goodness-of-fit-test
		sem (WFS-> oldage unemployed reducinc jobs ) if year==2005 //structural equation modelling of trstprl&trstun
		estat gof, stats (rmsea) //goodness-of-fit-test
		sem (WFS-> oldage unemployed reducinc jobs ) if year==2015 //structural equation modelling of trstprl&trstun
		estat gof, stats (rmsea) //goodness-of-fit-test
		sem (WFS-> oldage unemployed reducinc jobs ) */
		sem (WFS-> oldage unemployed reducinc jobs ), stand
		estat gof, stats (all) //goodness-of-fit-test
		predict wfs_cfa, latent (WFS) //confirmatory factor analysis prediction

		gen wfs_index=(oldage+unemployed+reducinc+jobs)/4

		* save
		drop _merge
		save "r2_issp_combined.dta", replace


		* add country variables ??Shouldn't there be a lag introduced when matching the values...? So the value of the gdp to given year is actually the gdp from previous year, right?
		import excel "cri_macro.xlsx", firstrow clear
		gen cntry=iso_country
		gen gininet=ginid_solt
		gen ginigross=ginim_dolt
		* gen yearM=year-1
		* keep cntry year gdp_wb gininet ginigross migstock_oecd socx_oecd
		save "r2_L2data.dta", replace

		use "r2_issp_combined.dta", replace
		merge m:1 cntry year using "r2_L2data.dta", force
		destring migstock_oecd socx_oecd wdi_unempilo mignet_un gdp_oecd gininet, replace force 
		drop if id == .
		
		label variable socx_oecd "Social expenditure rate"
		label variable wdi_unempilo "Unemployment rate"
		label variable migstock_oecd "Foreignborn rate"
		label variable mignet_un "Netmigration"
		label variable gininet "Gini (Disposable)"

			* save
		save "r2_issp_combined.dta", replace


		* analysis
		use "r2_issp_combined.dta", clear

		global indlev female age b2.educ b1.empl LR income

		global M1 $indlev migstock_oecd 
		global M2 $indlev migstock_oecd socx_oecd 
		global M3 $indlev migstock_oecd wdi_unempilo 
		global M4 $indlev mignet_un
		global M5 $indlev mignet_un socx_oecd
		global M6 $indlev mignet_un wdi_unempilo


		*** listwise deletion
		*quietly reg id $indlev $dvars $M2 $M3 $M4  // Getting the number of cases for the full model
		*gen netsamp_A = e(sample)

		estimates clear
*PI adjustment
replace mignet_un = mignet_un/10
//
		* demean macro-variables
		foreach var of varlist migstock_oecd socx_oecd wdi_unempilo mignet_un gdp_oecd gininet {
		bys cntry: egen `var'_m = mean(`var')
		gen `var'_dm = `var'-`var'_m
		}

		label variable socx_oecd_m "Social expenditure rate (BE)"
		label variable socx_oecd_dm "Social expenditure rate (WE)"
		label variable wdi_unempilo_m "Unemployment rate (BE)"
		label variable wdi_unempilo_dm "Unemployment rate(WE)"
		label variable migstock_oecd_m "Foreignborn rate (BE)"
		label variable migstock_oecd_dm "Foreignborn rate(WE)"
		label variable mignet_un_m "Netmigration(BE)"
		label variable mignet_un_dm "Netmigration(WE)"
		label variable gininet_m "Gini (Disposable) (BE)"
		label variable gininet_dm "Gini (Disposable) (WE)"

	
* preferred model
		global M5_means  migstock_oecd_m gininet_m socx_oecd_m wdi_unempilo_m
		global M5_demeans  migstock_oecd_dm gininet_dm socx_oecd_dm wdi_unempilo_dm 

		
* preferred model
		global M10_means  mignet_un_m gininet_m socx_oecd_m wdi_unempilo_m
		global M10_demeans  mignet_un_dm gininet_dm socx_oecd_dm wdi_unempilo_dm 

*PI adjustment
replace wfs_cfa = wfs_cfa*1.707
//
	qui mixed wfs_cfa $indlev i.study ${M5_means} ${M5_demeans} || cntry:  || study:
	margins, dydx(migstock_oecd_m) saving("t26m1",replace)
	margins, dydx(migstock_oecd_dm) saving("t26m2",replace)
	tab cntry year if e(sample)==1
	qui mixed wfs_cfa $indlev i.study ${M10_means} ${M10_demeans} || cntry:  || study:
	margins, dydx(mignet_un_m) saving("t26m3",replace)
	margins, dydx(mignet_un_dm) saving("t26m4",replace)
	tab cntry year if e(sample)==1
use t26m1,clear
foreach x of numlist 2/4{
append using t26m`x'
}
gen f = [_n]
gen factor = "Immigrant Stock" if f==1
replace factor = "Immigrant Flow, per wave" if f==2
replace factor = "Immigrant Flow, 1-year" if f==3
replace factor = "Change in Immigrant Flow, per wave" if f==4  
clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
gen id = "t26m1"
replace id = "t26m2" if f==2
replace id = "t26m3" if f==3
replace id = "t26m4" if f==4

order factor AME lower upper id
keep factor AME lower upper id
save team26, replace

erase r2_issp_combined.dta
foreach x in 2016 2006 1996{
erase "r2_issp`x'.dta"
}
erase r2_L2data.dta
foreach x of numlist 1/4{
erase "t26m`x'.dta"
}

}
*==============================================================================*
*==============================================================================*
*==============================================================================*



































// TEAM 27
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team27.dta"
  if _rc==0  {
    display "Team 27 already exists, skipping to next code chunk"
  }
  else {
version 15
**********************
* Cleaning 2016 Data *
**********************

use ZA6900_v2-0-0.dta, clear

// Provide jobs for everyone
recode v21 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
recode govjobs (1/2=0) (3/4=1), gen(dgovjobs)


// Provide healthcare for the sick
recode v23 (1=4) (2=3) (3=2) (4=1), gen(govhcare)
recode govhcare (1/2=0) (3/4=1), gen(dhcare)

// Provide living standard for the old
recode v24 (1=4) (2=3) (3=2) (4=1), gen(govretire)
recode govretire (1/2=0) (3/4=1), gen(dgovretire)

// Provide living standard for the unemployed
recode v26 (1=4) (2=3) (3=2) (4=1), gen(govunemp)
recode govunemp (1/2=0) (3/4=1), gen(dgovunemp)

// Reduce income diff bw rich and poor
recode v27 (1=4) (2=3) (3=2) (4=1), gen(govincdiff)
recode govincdiff (1/2=0) (3/4=1), gen(dgovincdiff)

// Provide decent housing to those who can't afford it
recode v29 (1=4) (2=3) (3=2) (4=1), gen(govhousing)
recode govhousing (1/2=0) (3/4=1), gen(dgovhous)

* Controls *

// AGE

gen agesq=AGE*AGE

// SEX
recode SEX (1=0) (2=1), gen(female)

// EDUCATION

rename EDUCYRS edyears
rename DEGREE edcat
recode edcat (0=1), gen(degree)
label define edlabels 1 "Primary/less" 2 "Some Secondary" 3 "Secondary" 4 "Some Higher Ed" 5 "University or higher"
label values degree edlabels
recode degree (1/2=1) (nonmiss=0), gen(lesshs)
recode degree (3/4=1) (nonmiss=0), gen(hs)
recode degree (5=1) (nonmiss=0), gen(univ)

// OCCUPATION

rename ISCO08 isco 
rename WRKHRS hourswrk
gen hourstemp = hourswrk

gen ftemp = 0
replace ftemp = 1 if hourstemp >= 35
replace ftemp = . if hourstemp >= 98

gen ptemp = 0
replace ptemp = 1 if hourstemp < 35
replace ptemp = 0 if hourstemp == 0
replace ptemp = . if hourstemp >= 98

gen unemp = 1
replace unemp = 0 if hourstemp > 0
replace unemp = . if hourstemp >= 98

drop hourstemp

gen selfemp = 0
replace selfemp = 1 if EMPREL == 2 | EMPREL == 3 
replace selfemp = . if EMPREL == 9



// INCOME
gen inczscore=.
local incvars = "AU_INC CH_INC CL_INC CZ_INC DE_INC DK_INC ES_INC FI_INC FR_INC GB_INC HR_INC HU_INC IL_INC JP_INC KR_INC LV_INC NO_INC NZ_INC PH_INC RU_INC SE_INC SI_INC TW_INC US_INC VE_INC ZA_INC" 
foreach incvar of local incvars {
	zscore `incvar', listwise
	replace inczscore=z_`incvar' if z_`incvar'!=.
	drop z_`incvar'
}

// Country Identifier
rename country cntry

// weights
rename WEIGHT wghts

// year
gen year=2016
gen yr2016=1

drop version

save "ZA6900_cleaned.dta", replace

clear

**********************
* Cleaning 1996 Data *
**********************

use ZA2900.dta

recode v3 (1=36) (2/3=276) (4=826) (6=840) (8=348) (9=.) (10=372) (12=578) (13=752) (14=203) (15=705) (16=616) (17=.) (18=643) (19=554) (20=124) (21=608) (22/23=376) (24=392) (25=724) (26=428) (27=250) (28=.) (30=756), gen(v3a)
label define cntrylbl 36 "Australia" 124 "Canada" 152 "Chile" 158 "Taiwan" 191 "Croatia" 203 "Czech" 208 "Denmark" 246 "Finland" 250 "France" 276 "Germany" 348 "Hungary" 372 "Ireland" 376 "Isreal" 392 "Japan" 410 "S Korea" 428 "Latvia" 528 "Netherlands" 554 "New Zealand" 578 "Norway" 608 "Philippines" 616 "Poland" 620 "Portugal" 643 "Russia" 705 "Slovenia" 724 "Spain" 752 "Sweden" 756 "Switzerland" 826 "Great Britain" 840 "United States" 
label values v3a cntrylbl

* DVs *

// Provide jobs for everyone
recode v36 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
recode govjobs (1/2=0) (3/4=1), gen(dgovjobs)

// Provide healthcare for the sick
recode v38 (1=4) (2=3) (3=2) (4=1), gen(govhcare)
recode govhcare (1/2=0) (3/4=1), gen(dhcare)

// Provide living standard for the old
recode v39 (1=4) (2=3) (3=2) (4=1), gen(govretire)
recode govretire (1/2=0) (3/4=1), gen(dgovretire)

// Provide living standard for the unemployed
recode v41 (1=4) (2=3) (3=2) (4=1), gen(govunemp)
recode govunemp (1/2=0) (3/4=1), gen(dgovunemp)

// Reduce income diff bw rich and poor
recode v42 (1=4) (2=3) (3=2) (4=1), gen(govincdiff)
recode govincdiff (1/2=0) (3/4=1), gen(dgovincdiff)

// Provide decent housing to those who can't afford it
recode v44 (1=4) (2=3) (3=2) (4=1), gen(govhousing)
recode govhousing (1/2=0) (3/4=1), gen(dgovhous)

* Controls *

// Age and Age Squared
rename v201 age
gen agesq=age*age

// Sex
recode v200 (1=0) (2=1), gen(female)

// Education
rename v205 edcat
recode edcat (1/3=1) (4=2) (5=3) (6=4) (7=5), gen(degree)
label define edlabels 1 "Primary/less" 2 "Some Secondary" 3 "Secondary" 4 "Some Higher Ed" 5 "University or higher"
label values degree edlabels
recode degree (1/2=1) (nonmiss=0), gen(lesshs)
recode degree (3/4=1) (nonmiss=0), gen(hs)
recode degree (5=1) (nonmiss=0), gen(univ)

// Occupation
recode v206 (2/10=0), gen(ftemp)
recode v206 (2/4=1) (nonmiss=0), gen(ptemp)
recode v206 (5=1) (nonmiss=0), gen(unemp)
recode v206 (6/10=1) (nonmiss=0), gen(nolabor)

gen selfemp=v213==1
replace selfemp=. if v206==.

// Income

rename v218 faminc

gen inczscore=.
levelsof v3a, local(cntries)
foreach cntryval of local cntries {
	zscore faminc if v3a==`cntryval', listwise
	replace inczscore=z_faminc if v3a==`cntryval'
	drop z_faminc
}

// year
gen year=1996
gen yr2006=0

// country identifier
rename v3a cntry

// weights
rename v325 wghts

*****************
* New Variables *
*****************

save "ZA2900_cleaned.dta", replace

clear

**********************
* Cleaning 2006 Data *
**********************

use ZA4700.dta

*DVs*

// Provide jobs for everyone
recode V25 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
recode govjobs (1/2=0) (3/4=1), gen(dgovjobs)

// Provide healthcare for the sick
recode V27 (1=4) (2=3) (3=2) (4=1), gen(govhcare)
recode govhcare (1/2=0) (3/4=1), gen(dhcare)

// Provide living standard for the old
recode V28 (1=4) (2=3) (3=2) (4=1), gen(govretire)
recode govretire (1/2=0) (3/4=1), gen(dgovretire)

// Provide living standard for the unemployed
recode V30 (1=4) (2=3) (3=2) (4=1), gen(govunemp)
recode govunemp (1/2=0) (3/4=1), gen(dgovunemp)

// Reduce income diff bw rich and poor
recode V31 (1=4) (2=3) (3=2) (4=1), gen(govincdiff)
recode govincdiff (1/2=0) (3/4=1), gen(dgovincdiff)

// Provide decent housing to those who can't afford it
recode V33 (1=4) (2=3) (3=2) (4=1), gen(govhousing)
recode govhousing (1/2=0) (3/4=1), gen(dgovhous)


* Controls *

// AGE

gen agesq=age*age

// SEX
recode sex (1=0) (2=1), gen(female)

// EDUCATION

rename educyrs edyears
rename degree edcat
recode edcat (0=1), gen(degree)
label define edlabels 1 "Primary/less" 2 "Some Secondary" 3 "Secondary" 4 "Some Higher Ed" 5 "University or higher"
label values degree edlabels

recode degree (1/2=1) (nonmiss=0), gen(lesshs)
recode degree (3/4=1) (nonmiss=0), gen(hs)
recode degree (5=1) (nonmiss=0), gen(univ)

// OCCUPATION
rename wrkst empstat
rename ISCO88 isco // see pg 137 in codebook
rename wrkhrs hourswrk

recode empstat (2/10=0), gen(ftemp)
recode empstat (2/4=1) (nonmiss=0), gen(ptemp)
recode empstat (5=1) (nonmiss=0), gen(unemp)
recode empstat (6/10=1) (nonmiss=0), gen(nolabor)

gen selfemp=wrktype==4
replace selfemp=. if empstat==.

// INCOME
gen inczscore=.
local incvars = "AU_INC CA_INC CH_INC CL_INC CZ_INC DE_INC DK_INC DO_INC ES_INC FI_INC FR_INC GB_INC HR_INC HU_INC IE_INC IL_INC JP_INC KR_INC LV_INC NL_INC NO_INC NZ_INC PH_INC PL_INC PT_INC RU_INC SE_INC SI_INC TW_INC US_INC UY_INC VE_INC ZA_INC" 
foreach incvar of local incvars {
	zscore `incvar', listwise
	replace inczscore=z_`incvar' if z_`incvar'!=.
	drop z_`incvar'
}

// Country Identifier
rename V3a cntry

// weights
rename weight wghts

// year
gen year=2006
gen yr2006=1

save "ZA4700_cleaned.dta", replace

****************
* Merging Data *
****************

append using "ZA2900_cleaned.dta"
append using "ZA6900_cleaned.dta"
sort cntry year
merge m:1 cntry year using "bradyfinnigan2014countrydata.dta"
recode cntry (36=1) (124=1) (208=1) (246=1) (250=1) (276=1) (372=1) (392=1) (528=1) (554=1) (578=1) (620=1) (724=1) (752=1) (756=1) (826=1) (840=1) (else=0), gen(orig17)
recode cntry (36=1) (124=1) (250=1) (276=1) (372=1) (392=1) (554=1) (578=1) (724=1) (752=1) (756=1) (826=1) (840=1) (else=0), gen(orig13)
save "RepData2.dta", replace

*****************************
* The actual expansion work *
*****************************

* Background organization stuff *

quietly tab cntry, gen(cntryfe)

* First set *

qui logit dgovjobs foreignpct age female lesshs unemp inczscore yr2006 cntryfe*, or
margins, dydx(foreignpct) saving ("t27m1",replace)
qui logit dgovunemp foreignpct age female lesshs unemp inczscore yr2006 cntryfe*, or
margins, dydx(foreignpct) saving ("t27m2",replace)
qui logit dgovincdiff foreignpct age female lesshs unemp inczscore yr2006 cntryfe*, or
margins, dydx(foreignpct) saving ("t27m3",replace)
qui logit dgovretire foreignpct age female lesshs unemp inczscore yr2006 cntryfe*, or
margins, dydx(foreignpct) saving ("t27m4",replace)
qui logit dgovhous foreignpct age female lesshs unemp inczscore yr2006 cntryfe*, or
margins, dydx(foreignpct) saving ("t27m5",replace)
qui logit dhcare foreignpct age female lesshs unemp inczscore yr2006 cntryfe*, or
margins, dydx(foreignpct) saving ("t27m6",replace)
tab cntry year if e(sample)==1


* Second Set *
*PI adjustment
replace netmigpct=netmigpct/5
//

qui logit dgovjobs netmigpct age female lesshs unemp inczscore yr2006 cntryfe*, or
margins,dydx(netmigpct) saving ("t27m7",replace)
qui logit dgovunemp netmigpct age female lesshs unemp inczscore yr2006 cntryfe*, or
margins,dydx(netmigpct) saving ("t27m8",replace)
qui logit dgovincdiff netmigpct age female lesshs unemp inczscore yr2006 cntryfe*, or
margins,dydx(netmigpct) saving ("t27m9",replace)
qui logit dgovretire netmigpct age female lesshs unemp inczscore yr2006 cntryfe*, or
margins,dydx(netmigpct) saving ("t27m10",replace)
qui logit dgovhous netmigpct age female lesshs unemp inczscore yr2006 cntryfe*, or
margins,dydx(netmigpct) saving ("t27m11",replace)
qui logit dhcare netmigpct age female lesshs unemp inczscore yr2006 cntryfe*, or
margins,dydx(netmigpct) saving ("t27m12",replace)
tab cntry year if e(sample)==1

use t27m1,clear
foreach x of numlist 2/12 {
append using t27m`x'
}
gen f = [_n]
gen factor = "Immigrant Stock"
replace factor = "Immigrant Flow, 1-year" if f>6
clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
gen id = "t27m1"
foreach x of numlist 2/12 {
replace id = "t27m`x'" if f==`x'
}
order factor AME lower upper id
keep factor AME lower upper id
save team27, replace

erase ZA4700_cleaned.dta
erase ZA2900_cleaned.dta
erase ZA6900_cleaned.dta
erase RepData2.dta
foreach x of numlist 1/12 {
erase "t27m`x'.dta"
}
 } 
*==============================================================================*
*==============================================================================*
*==============================================================================*
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 // TEAM 28
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "issp1985_2016_28.csv"
  if _rc==0  {
    display "Team 28 analysis data already exists, skipping to next code chunk"
  }
  else {
* They recoded in Stata and then ran their models in R
* This code only works up the file issp1996_2006_13cL2.csv

use ZA1490.dta
gen year=1985

gen country="Australia" if V3==1
replace country="United Kingdom" if V3==3
replace country="United States" if V3==4
replace country="Italy" if V3==8

*Dependent variables
gen d_oldagecare=1 if V104==1 | V104==2
replace d_oldagecare=0 if V104==3 | V104==4
gen d_unemployed=1 if V106==1 | V106==2
replace d_unemployed=0 if V106==3 | V106==4
gen d_incomediff=1 if V107==1 | V107==2
replace d_incomediff=0 if V107==3 | V107==4
gen d_jobs=1 if V101==1 | V101==2
replace d_jobs=0 if V101==3 | V101==4
gen d_health=1 if V103==1 | V103==2
replace d_health=0 if V103==3 | V103==4

gen c_oldagecare=V104 if V104<=4
gen c_unemployed=V106 if V106<=4
gen c_incomediff=V107 if V107<=4
gen c_jobs=V101 if V101<=4
gen c_health=V103 if V103<=4

*L1 variables
gen female=.
replace female=1 if V118==2
replace female=0 if V118==1
gen age = V117 if V117<=97
gen age2=age*age

*education version including incomplete sec as lowest
gen edu=2 if V123==1 | V123==2 | V123==3 
replace edu=1 if V123==4 | V123==5
replace edu=3 if V123==6 | V123==7 | V123==8

gen yrsedu=V122 if V122<=25

*employment status two versions, depending on what to do with categories 3 and 4 (less than part-time and helping family members)
gen empl=1 if V109==2 //employed
replace empl=2 if V109==1 //unemployed
replace empl=3 if V109==. //OLF

gen weight=V141
gen edu_orig1985=V123
gen empl_orig1985=V109

keep year-empl_orig1985

save issp1985.dta, replace

***
*ISSP 1990 - ZA1950
use ZA1950.dta
gen year=1990

gen country="Australia" if v3==1
replace country="Germany" if v3==2
replace country="Germany" if v3==3
replace country="United Kingdom" if v3==4
replace country="United States" if v3==6
replace country="Italy" if v3==8
replace country="Hungary" if v3==7
replace country="Ireland" if v3==9
replace country="Norway" if v3==10
replace country="Israel" if v3==11

*Dependent variables
gen d_oldagecare=1 if v52==1 | v52==2
replace d_oldagecare=0 if v52==3 | v52==4
gen d_unemployed=1 if v54==1 | v54==2
replace d_unemployed=0 if v54==3 | v54==4
gen d_incomediff=1 if v55==1 | v55==2
replace d_incomediff=0 if v55==3 | v55==4
gen d_jobs=1 if v49==1 | v49==2
replace d_jobs=0 if v49==3 | v49==4
gen d_house=1 if v57==1 | v57==2
replace d_house=0 if v57==3 | v57==4
gen d_health=1 if v51==1 | v51==2
replace d_health=0 if v51==3 | v51==4

gen c_oldagecare=v52 if v52<=4
gen c_unemployed=v54 if v54<=4
gen c_incomediff=v55 if v55<=4
gen c_jobs=v49 if v49<=4
gen c_health=v51 if v51<=4
gen c_house=v57 if v57<=4

*L1 variables
gen female=.
replace female=1 if v59==2
replace female=0 if v59==1
gen age = v60 if v60<=97
gen age2=age*age

*education version including incomplete sec as lowest
gen edu=2 if v81==1 | v81==2 | v81==3 | v81==4
replace edu=1 if v81==5 | v81==6
replace edu=3 if v81==7 | v81==8

gen yrsedu=v80 if v80<=25

*employment status two versions, depending on what to do with categories 3 and 4 (less than part-time and helping family members)
gen empl=1 if v63==1 | v63==1  //employed
replace empl=2 if v63==5 //unemployed
replace empl=3 if v63==6 | v63==7 |v63==8 |v63==9 |v63==10  //OLF

gen weight=v114
gen edu_orig1990=v81
gen empl_orig1990=v63

keep year-empl_orig1990

save issp1990.dta, replace

***
*ISSP 1996 - ZA2900
use ZA2900.dta
gen year=1996
*countries
gen country="Australia" if v3==1
replace country="Germany" if v3==2
replace country="Germany" if v3==3
replace country="United Kingdom" if v3==4
replace country="United States" if v3==6
replace country="Hungary" if v3==8
replace country="Italy" if v3==9
replace country="Ireland" if v3==10
replace country="Norway" if v3==12
replace country="Sweden" if v3==13
replace country="Czech Republic" if v3==14
replace country="Slovenia" if v3==15
replace country="Poland" if v3==16
replace country="Russia" if v3==18
replace country="New Zealand" if v3==19
replace country="Canada" if v3==20
replace country="Israel" if v3==22
replace country="Israel" if v3==23
replace country="Japan" if v3==24
replace country="Spain" if v3==25
replace country="Latvia" if v3==26
replace country="France" if v3==27
replace country="Switzerland" if v3==30

*Dependent variables
gen d_oldagecare=1 if v39==1 | v39==2
replace d_oldagecare=0 if v39==3 | v39==4
gen d_unemployed=1 if v41==1 | v41==2
replace d_unemployed=0 if v41==3 | v41==4
gen d_incomediff=1 if v42==1 | v42==2
replace d_incomediff=0 if v42==3 | v42==4
gen d_jobs=1 if v36==1 | v36==2
replace d_jobs=0 if v36==3 | v36==4
gen d_house=1 if v44==1 | v44==2
replace d_house=0 if v44==3 | v44==4
gen d_health=1 if v38==1 | v38==2
replace d_health=0 if v38==3 | v38==4

gen c_oldagecare=v39 if v39<=4
gen c_unemployed=v41 if v41<=4
gen c_incomediff=v42 if v42<=4
gen c_jobs=v36 if v36<=4
gen c_health=v38 if v38<=4
gen c_house=v44 if v44<=4

*L1 variables
gen female=.
replace female=1 if v200==2
replace female=0 if v200==1
tab v201, miss
gen age = v201 if v201<=97
gen age2=age*age

*education version including incomplete sec as lowest
gen edu=2 if v205==1 | v205==2 | v205==3 | v205==4
replace edu=1 if v205==5 | v205==6
replace edu=3 if v205==7 

gen yrsedu=v204 if v204<=25

*employment status two versions, depending on what to do with categories 3 and 4 (less than part-time and helping family members)
gen empl=1 if v206==1 | v206==2 //employed
replace empl=2 if v206==5 //unemployed
replace empl=3 if v206==6 | v206==7 | v206==8 |v206==9 |v206==10 
//not active - student, retired, houswife, perm disab, other OLF
*?? less than part-timne and helping family member? 

gen weight=v325
gen edu_orig1996=v205
gen empl_orig1996=v206

keep year-empl_orig1996

save issp1996.dta, replace

*ISSP 2006 - ZA
use ZA4700.dta, clear
gen year=2006
*countries
gen country="Australia" if V3a==36
replace country="Germany" if V3a==276
replace country="United Kingdom" if V3a==826
replace country="United States" if V3a==840
replace country="Hungary" if V3a==348 //n
replace country="Ireland" if V3a==372
replace country="Norway" if V3a==578
replace country="Sweden" if V3a==752
replace country="Czech Republic" if V3a==203 //n
replace country="Slovenia" if V3a==705 //n
replace country="Poland" if V3a==616 //n
replace country="Russia" if V3a==643 //n
replace country="New Zealand" if V3a==554
replace country="Canada" if V3a==124
replace country="Israel" if V3a==376 //n
replace country="Japan" if V3a==392
replace country="Spain" if V3a==724
replace country="Latvia" if V3a==428 //n
replace country="France" if V3a==250
replace country="Switzerland" if V3a==756
replace country="Denmark" if V3a==208
replace country="Croatia" if V3a==191
replace country="Finland" if V3a==246
replace country="Korea" if V3a==410
replace country="Taiwan" if V3a==158

*Dependent variables
gen d_oldagecare=1 if V28==1 | V28==2
replace d_oldagecare=0 if V28==3 | V28==4
gen d_unemployed=1 if V30==1 | V30==2
replace d_unemployed=0 if V30==3 | V30==4
gen d_incomediff=1 if V31==1 | V31==2
replace d_incomediff=0 if V31==3 | V31==4
gen d_jobs=1 if V25==1 | V25==2
replace d_jobs=0 if V25==3 | V25==4
gen d_house=1 if V27==1 | V27==2
replace d_house=0 if V27==3 | V27==4
gen d_health=1 if V33==1 | V33==2
replace d_health=0 if V33==3 | V33==4

gen c_oldagecare=V28 if V28<=4
gen c_unemployed=V30 if V30<=4
gen c_incomediff=V31 if V31<=4
gen c_jobs=V25 if V25<=4
gen c_health=V33 if V33<=4
gen c_house=V27 if V27<=4

*L1 variables
gen female=.
replace female=1 if sex==2
replace female=0 if sex==1
gen age2=age*age

*education version including or excluding incomplete sec as lowest
gen edu=2 if degree==0 | degree==1 
replace edu=1 if degree==2 | degree==3 | degree==4
replace edu=3 if degree==5

gen yrsedu=educyrs if educyrs<=25

*employment status two versions, depending on what to do with categories 3 and 4 (less than part-time and helping family members)
gen empl=1 if wrkst==1 | wrkst==2 //employed
replace empl=2 if wrkst==5 //unemployed
replace empl=3 if wrkst==6 | wrkst==7 | wrkst==8 |wrkst==9 |wrkst==10 

gen edu_orig2006=degree
gen empl_orig2006=wrkst

keep age weight year-empl_orig2006

save issp2006.dta, replace

*++++++
*ISSP 2016 - ZA
use ZA6900_v2-0-0.dta, clear
gen year=2016
*countries
rename country countryo
gen country="Australia" if countryo==36
replace country="Korea" if countryo==410
replace country="Germany" if countryo==276
replace country="Czech Republic" if countryo==203 
replace country="Croatia" if countryo==191
replace country="Taiwan" if countryo==158
replace country="Denmark" if countryo==208
replace country="Finland" if countryo==246
replace country="France" if countryo==250
replace country="Hungary" if countryo==348
replace country="Israel" if countryo==376 
replace country="Japan" if countryo==392
replace country="Latvia" if countryo==428 
replace country="New Zealand" if countryo==554
replace country="Norway" if countryo==578
replace country="Russia" if countryo==643 
replace country="Slovenia" if countryo==705 
replace country="Spain" if countryo==724
replace country="Sweden" if countryo==752
replace country="Switzerland" if countryo==756
replace country="United Kingdom" if countryo==826
replace country="United States" if countryo==840
replace country="Taiwan" if countryo==158

*Dependent variables
gen d_oldagecare=1 if v24==1 | v24==2
replace d_oldagecare=0 if v24==3 | v24==4
gen d_unemployed=1 if v26==1 | v26==2
replace d_unemployed=0 if v26==3 | v26==4
gen d_incomediff=1 if v27==1 | v27==2
replace d_incomediff=0 if v27==3 | v27==4
gen d_jobs=1 if v21==1 | v21==2
replace d_jobs=0 if v21==3 | v21==4
gen d_house=1 if v29==1 | v29==2
replace d_house=0 if v29==3 | v29==4
gen d_health=1 if v23==1 | v23==2
replace d_health=0 if v23==3 | v23==4

gen c_oldagecare=v24 if v24<=4
gen c_unemployed=v26 if v26<=4
gen c_incomediff=v27 if v27<=4
gen c_jobs=v21 if v21<=4
gen c_health=v23 if v23<=4
gen c_house=v29 if v29<=4

*L1 variables
gen female=.
replace female=1 if SEX==2
replace female=0 if SEX==1
gen age=AGE if AGE<=97
gen age2=age*age
replace age=22 if DK_AGE==22
replace age=31 if DK_AGE==31
replace age=41 if DK_AGE==41
replace age=51 if DK_AGE==51
replace age=61 if DK_AGE==61
replace age=70 if DK_AGE==70

*education version including or excluding incomplete sec as lowest
gen edu=2 if DEGREE==0 | DEGREE==1 
replace edu=1 if DEGREE==2 | DEGREE==3 | DEGREE==4
replace edu=3 if DEGREE==5 | DEGREE==6

gen yrsedu=EDUCYRS if EDUCYRS<=25

*employment status two versions, depending on what to do with categories 3 and 4 (less than part-time and helping family members)
gen empl=1 if MAINSTAT==1 | MAINSTAT==4 //employed
replace empl=2 if MAINSTAT==2 //unemployed
replace empl=3 if MAINSTAT==3 | MAINSTAT==5 | MAINSTAT==6 |MAINSTAT==7 |MAINSTAT==9 


gen weight=WEIGHT
gen edu_orig2016=DEGREE
gen empl_orig2016=MAINSTAT

keep age weight year-empl_orig2016

save issp2016.dta, replace
append using issp1985.dta 
append using issp1990.dta 
append using issp1996.dta 
append using issp2006.dta 
encode country, generate(country_num)
drop if country==""
merge m:1 country year using L2data_exp2.dta, generate(match)


* PI removes unused variables
drop iso_country-match
* PIs had to change names, otherwise the wrong file gets saved here
save "issp1985_2016_28.dta", replace

erase issp1985.dta
erase issp1990.dta
erase issp1996.dta
erase issp2006.dta
erase issp2016.dta 
}

*==============================================================================*
*==============================================================================*
*==============================================================================*

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 // TEAM 29
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*
capture confirm file "team29.dta"
  if _rc==0  {
    display "Team 29 already exists, skipping to next code chunk"
  }
  else {
version 15
  global vars country year oldcare unempl incdiff jobs stock delta_stock socexp emplrate female ///
			age age2 edu lowedu secedu hiedu lfstatus ptime noactive activeue fulltime 

use ZA2900.dta, clear

g country = "" // countries with fully available country-info and responses in both waves 
replace country = "Australia" if v3 == 1
replace country = "Canada" if v3 == 20
replace country = "France" if v3 == 27
replace country = "Germany" if v3 == 2 | v3 == 3
replace country = "Ireland" if v3 == 10
replace country = "Japan" if v3 == 24
replace country = "New Zealand" if v3 == 19
replace country = "Norway" if v3 == 12
replace country = "Spain" if v3 == 25
replace country = "Sweden" if v3 == 13
replace country = "Switzerland" if v3 == 30 
replace country = "United Kingdom" if v3 == 4 
replace country = "United States" if v3 == 6

drop if country == ""

g year = 1996

g oldcare = .
	replace oldcare = 0 if v39 == 3 | v39 == 4
	replace oldcare = 1 if v39 == 1 | v39 == 2

g unempl = .
	replace unempl = 0 if v41 == 3 | v41 == 4
	replace unempl = 1 if v41 == 1 | v41 == 2
	
g incdiff = .
	replace incdiff = 0 if v42 == 3 | v42 == 4
	replace incdiff = 1 if v42 == 1 | v42 == 2

g jobs = .
	replace jobs = 0 if v36 == 3 | v36 == 4
	replace jobs = 1 if v36 == 1 | v36 == 2

g female = .
	replace female = 0 if v200 == 1
	replace female = 1 if v200 == 2
g age = v201
g age2 = age^2
g lowedu = .
	replace lowedu = 0 if v205 != .
	replace lowedu = 1 if v205 <= 3
g secedu = .
	replace secedu = 0 if v205 != .
	replace secedu = 1 if v205 == 4 | v205 == 5
g hiedu = .
	replace hiedu = 0 if v205 != .
	replace hiedu = 1 if v205 >= 6 & v205 != .
g edu = .
	replace edu = 0 if lowedu == 1
	replace edu = 1 if secedu == 1
	replace edu = 2 if hiedu == 1
la def edu 0 "primary" 1 "secondary" 2 "tertiary"	
la val edu edu

g ptime = .
	replace ptime = 0 if v206 != .
	replace ptime = 1 if v206 == 2
g activeue = .
	replace activeue = 0 if v206 != .
	replace activeue = 1 if v206 == 5
g fulltime = .
	replace fulltime = 0 if v206 != .
	replace fulltime = 1 if v206 == 1
g noactive = .
	replace noactive = 0 if v206 != .
	replace noactive = 1 if v206 != 2 & v206 != 5 & v206 != 1 & v206 != .
	
g lfstatus = .
	replace lfstatus = 0 if fulltime == 1
	replace lfstatus = 1 if ptime == 1
	replace lfstatus = 2 if activeue == 1
	replace lfstatus = 3 if noactive == 1
la def lfstatus 0 "full-time" 1 "part-time" 2 "unemployed" 3 "not active"
la val lfstatus lfstatus	

	
save temp_ZA2900.dta, replace

********************************************************************************
use ZA4700.dta, clear

g country = ""
replace country = "Australia" if V3 == 36
replace country = "Canada" if V3 == 124
replace country = "France" if V3 == 250
replace country = "Germany" if V3a == 276
replace country = "Ireland" if V3 == 372
replace country = "Japan" if V3 == 392
replace country = "New Zealand" if V3 == 554
replace country = "Norway" if V3 == 578
replace country = "Spain" if V3 == 724
replace country = "Sweden" if V3 == 752
replace country = "Switzerland" if V3 == 756 
replace country = "United Kingdom" if V3a == 826 
replace country = "United States" if V3 == 840

drop if country == ""

g year = 2006

g oldcare = .
	replace oldcare = 0 if V28 == 3 | V28 == 4
	replace oldcare = 1 if V28 == 1 | V28 == 2

g unempl = .
	replace unempl = 0 if V30 == 3 | V30 == 4
	replace unempl = 1 if V30 == 1 | V30 == 2

g incdiff = .
	replace incdiff = 0 if V31 == 3 | V31 == 4
	replace incdiff = 1 if V31 == 1 | V31 == 2

g jobs = .
	replace jobs = 0 if V25 == 3 | V25 == 4
	replace jobs = 1 if V25 == 1 | V25 == 2

g female = .
	replace female = 0 if sex == 1
	replace female = 1 if sex == 2

g age2 = age^2 

g lowedu = .
	replace lowedu = 0 if degree != .
	replace lowedu = 1 if degree <= 1
g secedu = .
	replace secedu = 0 if degree != .
	replace secedu = 1 if degree == 2 | degree == 3
g hiedu = .
	replace hiedu = 0 if degree != .
	replace hiedu = 1 if degree == 4 | degree == 5
g edu = .
	replace edu = 0 if lowedu == 1
	replace edu = 1 if secedu == 1
	replace edu = 2 if hiedu == 1


g ptime = .
	replace ptime = 0 if wrkst != .
	replace ptime = 1 if wrkst == 2
g activeue = .
	replace activeue = 0 if wrkst != .
	replace activeue = 1 if wrkst == 5
g fulltime = .
	replace fulltime = 0 if wrkst != .
	replace fulltime = 1 if wrkst == 1
g noactive = .
	replace noactive = 0 if wrkst != .
	replace noactive = 1 if wrkst != 2 & wrkst != 5 & wrkst != 1 & wrkst != .
	
g lfstatus = .
	replace lfstatus = 0 if fulltime == 1
	replace lfstatus = 1 if ptime == 1
	replace lfstatus = 2 if activeue == 1
	replace lfstatus = 3 if noactive == 1
la def lfstatus 0 "full-time" 1 "part-time" 2 "unemployed" 3 "not active"
la val lfstatus lfstatus	

append using temp_ZA2900.dta
********************************************************************************
save temp_workfile.dta, replace 



clear
import excel cri_macro.xlsx, sheet("cri_macro") firstrow

replace socx_oecd = "." if socx_oecd == ".."

foreach var in gdp_oecd gdp_wb gdp_twn gni_wb ginid_solt ginim_dolt gini_wb gini_wid top10_wid mcp migstock_wb migstock_un migstock_oecd mignet_un pop_wb al_ethnic dpi_tf wdi_empprilo wdi_unempilo socx_oecd {
destring `var', replace
} 

merge 1:m country year using temp_workfile.dta, nogen keep(3)


erase temp_ZA2900.dta
erase temp_workfile.dta

g stock = migstock_un
	la var stock "% foreign born (UN)"
g delta_stock = mignet_un
	la var delta_stock "net migration rate (UN)"
g socexp = socx_oecd
	la var socexp "Social expenditure (OECD)"
g emplrate = wdi_empprilo
	la var emplrate "Employment rate (WDI)"

bys country year: egen aux = median(v218)
g hiwage = .
	replace hiwage = 0 if v218 < aux & aux!= . & v218 != .
	replace hiwage = 1 if v218 > aux & aux!= . & v218 != .
	
g urban = .
	replace urban = 1 if v275  == 1 | v275 == 2
	replace urban = 0 if v275 == 3

g employed = .
		replace employed = 1 if lfstatus == 0 | lfstatus == 1
		replace employed = 2 if lfstatus == 2 | lfstatus == 3
	
g ethnicfrac = dpi_tf
	
keep $vars hiwage urban employed ethnicfrac

encode country, g(ctry)

compress


global covars female age age2 ib(2).edu ib(1).lfstatus

global policy oldcare unempl incdiff jobs  

global indiv employed hiedu urban

su ethnicfrac
g frac = .
	replace frac = 0 if ethnicfrac <= r(mean) 
	replace frac = 1 if ethnicfrac > r(mean)
	
********************************************************************************
*MODEL 1
********************************************************************************

*PI adjudtment - "delta_stock" is net migration
replace delta_stock = delta_stock/10
g stock_sq = stock * stock
g delta_stock_sq = delta_stock * delta_stock


foreach i in $policy {
	
	logit `i' stock $covars i.year i.ctry, or robust
		est sto `i'_1
	logit `i' stock stock_sq $covars i.year i.ctry, or robust
		est sto `i'_2
	logit `i' stock socexp $covars i.year i.ctry, or robust
		est sto `i'_3
	logit `i' stock stock_sq socexp $covars i.year i.ctry, or robust
		est sto `i'_4
	logit `i' stock emplrate $covars i.year i.ctry, or robust
		est sto `i'_5
	logit `i' stock stock_sq emplrate $covars i.year i.ctry, or robust
		est sto `i'_6
	
su delta_stock
	local lo = round(r(min),1)
	local hi = round(r(max),1)
	
	logit `i' delta_stock $covars i.year i.ctry, or robust
		est sto `i'_7
	logit `i' delta_stock delta_stock_sq $covars i.year i.ctry, or robust
		est sto `i'_8		
	logit `i' delta_stock socexp $covars i.year i.ctry, or robust
		est sto `i'_9
	logit `i' delta_stock delta_stock_sq socexp $covars i.year i.ctry, or robust
		est sto `i'_10	
	logit `i' delta_stock emplrate $covars i.year i.ctry, or robust
		est sto `i'_11
	logit `i' delta_stock delta_stock_sq emplrate $covars i.year i.ctry, or robust
		est sto `i'_12

}



// ADDED BY THE PIs //
*Added to achieve margins
local i =  1
foreach l in jobs unempl incdiff oldcare {
est restore `l'_1
margins, dydx(stock) saving("t29m`i'", replace)
local j = `i'+4
est restore `l'_2
*Non-linear, add together to get at means effects
margins, dydx(stock) saving("t29m`j'", replace)
margins, dydx(stock_sq) saving("t29m`j'a", replace)
local j = `i'+8
est restore `l'_3
margins, dydx(stock) saving("t29m`j'", replace)
local j = `i'+12
est restore `l'_4
margins, dydx(stock) saving("t29m`j'", replace)
margins, dydx(stock_sq) saving("t29m`j'a", replace)
local j = `i'+16
est restore `l'_5
margins, dydx(stock) saving("t29m`j'", replace)
local j = `i'+20
est restore `l'_6
margins, dydx(stock ) saving("t29m`j'", replace) 
margins, dydx(stock_sq) saving("t29m`j'a", replace)
local j = `i'+24
est restore `l'_7
margins, dydx(delta_stock) saving("t29m`j'", replace)
local j = `i'+28
est restore `l'_8
margins, dydx(delta_stock) saving("t29m`j'", replace)
margins, dydx(delta_stock_sq) saving("t29m`j'a", replace)
local j = `i'+32
est restore `l'_9
margins, dydx(delta_stock) saving("t29m`j'", replace)
local j = `i'+36
est restore `l'_10
margins, dydx(delta_stock) saving("t29m`j'", replace)
margins, dydx(delta_stock_sq) saving("t29m`j'a", replace)
local j = `i'+40
est restore `l'_11
margins, dydx(delta_stock) saving("t29m`j'", replace)
local j = `i'+44
est restore `l'_12
margins, dydx(delta_stock) saving("t29m`j'", replace)
margins, dydx(delta_stock_sq) saving("t29m`j'a", replace)
local i = `i'+1
}

use t29m1,clear
foreach x of numlist 2/48 {
append using t29m`x'
}

preserve
use t29m5a, clear
append using t29m6a
append using t29m7a
append using t29m8a
append using t29m13a
append using t29m14a
append using t29m15a
append using t29m16a
append using t29m21a
append using t29m22a
append using t29m23a
append using t29m24a
append using t29m29a
append using t29m30a
append using t29m31a
append using t29m32a
append using t29m37a
append using t29m38a
append using t29m39a
append using t29m40a
append using t29m45a
append using t29m46a
append using t29m47a
append using t29m48a
gen f = [_n]
recode f (1=5)(2=6)(3=7)(4=8) ///
(5=13)(6=14)(7=15)(8=16) ///
(9=21)(10=22)(11=23)(12=24) ///
(13=29)(14=30)(15=31)(16=32) ///
(17=37)(18=38)(19=39)(20=40) ///
(21=45)(22=46)(23=47)(24=48)
save t29a, replace
restore

gen f = [_n]
gen factor = "Immigrant Stock"
replace factor = "Immigrant Flow, 1-year" if f>24
clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
gen id = "t29m1"
foreach x of numlist 2/48 {
replace id = "t29m`x'" if f==`x'
}

//need to combine the "a" squared effects somehow
order factor AME lower upper id
keep factor AME lower upper id

save team29, replace

gen f = [_n]
merge 1:1 f using "t29a.dta"
replace AME = AME+_margin if _margin!=.
replace lower = lower+_ci_lb if _margin!=.
replace upper = upper+_ci_ub if _margin!=.
foreach x of numlist 1/48 {
erase "t29m`x'.dta"
capture erase "t29m`x'a.dta"
}
erase t29a.dta
keep factor AME lower upper id
save team29, replace
}
*==============================================================================*
*==============================================================================*
*==============================================================================*





























// TEAM 30
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*
capture confirm file "team30.dta"
  if _rc==0  {
    display "Team 30 already exists, skipping to next code chunk"
  }
  else {
version 14.2
* wave 1 (ISSP 1996)
use "ZA2900.dta", clear
keep v1 v2 v3 v36 v39 v41 v42 v200 v201 v205 v206 v325 v218

* country
gen country=""	// 2 digit (ISO 3166-2)
	replace country	=	"AU"	if	v3==1
	replace country	=	"DE"	if	v3==2 | v3==3
	replace country =	"GB"	if	v3==4
	replace country =	"NIRL"	if	v3==5	// has no 2 digit ISO code
	replace country =	"US"	if	v3==6
	replace country =	"AT"	if	v3==7
	replace country =	"HU"	if	v3==8
	replace country =	"IT"	if	v3==9
	replace country =	"IE"	if	v3==10
	replace country =	"NL"	if	v3==11
	replace country =	"NO"	if	v3==12
	replace country =	"SE"	if	v3==13
	replace country =	"CZ"	if	v3==14
	replace country =	"SI"	if	v3==15
	replace country =	"PL"	if	v3==16
	replace country =	"BG"	if	v3==17
	replace country =	"RU"	if	v3==18
	replace country =	"NZ"	if	v3==19
	replace country =	"CA"	if	v3==20
	replace country =	"PH"	if	v3==21
	replace country =	"IL"	if	v3==22
	replace country =	"PS"	if	v3==23
	replace country =	"JP"	if	v3==24
	replace country =	"ES"	if	v3==25
	replace country =	"LV"	if	v3==26
	replace country =	"FR"	if	v3==27
	replace country =	"CY"	if	v3==28
	replace country =	"CH"	if	v3==30	

kountry country, from(iso2c) to(iso3n)
rename _ISO3N_ iso3n
replace iso3n=643 if iso3n==810		// replace USSR with Russia
	
* DVs // the government should ...

	* jobs
	recode v36 (1 2=1 "1. Yes") (3 4=0 "0. No"), gen(jobs)
	
	* old age support
	recode v39 (1 2=1 "1. Yes") (3 4=0 "0. No"), gen(old_age)
	
	* unemployment
	recode v41 (1 2=1 "1. Yes") (3 4=0 "0. No"), gen(unemp)
	
	* income redistribution
	recode v42 (1 2=1 "1. Yes") (3 4=0 "0. No"), gen(redist)

* IVs

	* gender
	recode v200 (1=0 "0. Male") (2=1 "1. Female"), gen(gender)
	
	* age
	rename v201 age
	gen age2=age^2
	
	* education		// unlcear how 4 and 6 are coded -> lower categories
	recode v205 (1 2 3 4=1 "1. Primary or less") (5 6=2 "2. Secondary") ///
		(7=3 "3. University or more"), gen(edu)
	
	* employment 	// unclear how 3 (less than part time) is coded -> part-time
	recode v206 (1=1 "1. Full-time emp.") (2 3=2 "2. Part-time emp. (or less)") ///
		(5=3 "3. Unemployed") (4 6 7 8 9 10=4 "4. Not active"), gen(emp)
	
	* country-year specific z-score of income
	clonevar income=v218
	bysort country: center income, prefix(z_) standardize


* weight
rename v325 weight
recast float weight, force	// too precise for mlwin

* year
gen year=1996

keep v1 v2 v3 v3 iso3n age weight jobs old_age unemp redist gender age2 edu emp z_income country year
save "t30.issp.1996.dta", replace

//	ISSP 2006

* wave 2 (ISSP 2006)
use "ZA4700.dta", clear

keep V1 version V2 V3 V3a V25 V28 V30 V31 sex age degree wrkst weight *_INC
rename V1 V2 V3 V3a V25 V28 V30 V31, lower

* country
kountry v3a, from(iso3n) to(iso2c)
replace _ISO2C_		=	"RU"	if (v3==643) & _ISO2C_==""
rename _ISO2C_ country
rename v3a iso3n

* DVs // the government should ...

	* jobs
	recode v25 (1 2=1 "1. Yes") (3 4=0 "0. No"), gen(jobs)
	
	* old age support
	recode v28 (1 2=1 "1. Yes") (3 4=0 "0. No"), gen(old_age)
	
	* unemployment
	recode v30 (1 2=1 "1. Yes") (3 4=0 "0. No"), gen(unemp)
	
	* income redistribution
	recode v31 (1 2=1 "1. Yes") (3 4=0 "0. No"), gen(redist)

* IVs

	* gender
	recode sex (1=0 "0. Male") (2=1 "1. Female"), gen(gender)
	
	* age
	gen age2=age^2
	
	* education		// unlcear how 2 is coded -> lower categories 
	recode degree (0 1 2=1 "1. Primary or less") (3 4=2 "2. Secondary") ///
		(5=3 "3. University or more"), gen(edu)
	
	* employment 	// unclear how 3 (less than part time) is coded -> part-time
	recode wrkst (1=1 "1. Full-time emp.") (2 3=2 "2. Part-time emp. (or less)") ///
		(5=3 "3. Unemployed") (4 6 7 8 9 10=4 "4. Not active"), gen(emp)

	* country-year specific z-score of income
	gen income=.
	levelsof country, local(levels)
	foreach l of local levels {
		di "`l'"
		replace income=`l'_INC if country=="`l'"
		}
	bysort country: center income, prefix(z_) standardize
	
* weight
sum weight
recast float weight, force		// too precise for mlwin
	
* year
gen year=2006
	
//	#2.2
//	save 2006 data

keep v1 v2 v3 iso3n age weight jobs old_age unemp redist gender age2 edu emp z_income country year
save "t30.issp.2006.dta", replace

//	ISSP 2016

* wave 3 (ISSP 2016)
use "ZA6900_v2-0-0.dta", clear

keep studyno country CASEID v21 v24 v26 v27 SEX AGE DK_AGE DEGREE WORK MAINSTAT WRKHRS WEIGHT *_INC

clonevar v1=studyno
clonevar v2=CASEID

* country
rename country v3

kountry v3, from(iso3n) to(iso2c)
replace _ISO2C_		=	"RU"	if (v3==643) & _ISO2C_==""	// kountry does not identify 643 as Russia -> by hand
rename _ISO2C_ country
rename v3 iso3n

* DVs // the government should ...

	* jobs
	recode v21 (1 2=1 "1. Yes") (3 4=0 "0. No") (else=.), gen(jobs)
	
	* old age support
	recode v24 (1 2=1 "1. Yes") (3 4=0 "0. No") (else=.), gen(old_age)
	
	* unemployment
	recode v26 (1 2=1 "1. Yes") (3 4=0 "0. No") (else=.), gen(unemp)	// 0 = not available (Georgia)
	
	* income redistribution
	recode v27 (1 2=1 "1. Yes") (3 4=0 "0. No") (else=.), gen(redist)

* IVs

	* gender
	recode SEX (1=0 "0. Male") (2=1 "1. Female") (else=.), gen(gender)
	
	* age
	recode AGE (999=.), gen(age)										// top-coded in GB (97 years and older), do nothing (9 cases)
	replace age=DK_AGE if age==0
	gen age2=age^2
	
	* education		// unlcear how 2 is coded -> higher (secondary) categories 
	recode DEGREE (0 1=1 "1. Primary or less") (2 3 4=2 "2. Secondary") ///
		(5 6=3 "3. University or more") (else=.), gen(edu)
	
	* employment 	// variable wrkst unavailable
	gen emp=.
	replace emp=1 if WRKHRS>=35 & WRKHRS<=96	// full-time defined as 35+
	replace emp=2 if WRKHRS>=1  & WRKHRS<=34	// part-time defined as 1-34 
	replace emp=3 if MAINSTAT==2 & emp==.
	replace emp=4 if ((WORK==2 | WORK==3) & emp==.) | (inlist(MAINSTAT,3,4,5,6,7,8,9) & emp==.)
	lab def emp 1 "1. Full-time emp." 2 "2. Part-time emp." 3 "3. Unemployed" 4 "4. Not active"
	lab val emp emp

	* country-year specific z-score of income
	gen income=.
	levelsof country, local(levels)
	foreach l of local levels {
		di "`l'"
		replace income=`l'_INC if country=="`l'"
		}
	bysort country: center income, prefix(z_) standardize
	
* weight
rename WEIGHT, lower
recast float weight, force		// too precise for mlwin
	
* year
gen year=2016

keep v1 v2 iso3n age weight jobs old_age unemp redist gender age2 edu emp z_income country year
save "t30.issp.2016.dta", replace

//	#4
//	append data

* value lables for iso3n
labvalcombine V3A COUNTRY, lblname(country)
lab def country 275 "275. PS-Palestine" 380 "380. IT-Italy", modify
lab val iso3n country

* unique ids
sort year country 
gen id=_n
lab var id "Unique (artifical) respondent ID"

* generate country year level indicator
gen double iso3n_year=iso3n*1000000
format iso3n_year %20.0f
replace iso3n_year=iso3n_year+year

save "t30.issp.1996-2016.dta", replace



import excel "${data}/cri_macro.xlsx", firstrow clear 					// deleted "." in xlsx-file to pr

* country
rename country country_b

kountry iso_country, from(iso3n) to(iso2c)
replace _ISO2C_		=	"RU"	if (iso_country==643) & _ISO2C_==""		// kountry does not identify 643 as Russia -> by hand
rename _ISO2C_ country

rename iso_country iso3n

* destring to numeric values

ds iso3n year country country_b, not 					// create list of variables that should not (!) be encoded to numeric
local i=1
foreach x of var `r(varlist)' { 
	di as text " "
	di as text "`i'. Variable: " "`x'"
	di as text " "
	
	replace `x'="." if `x'==".."						// replace ".." in string variables with "."
	
	rename `x' `x'_str									// attach suffix (_str) to string variable names
	destring `x'_str, gen(`x')							// destring string variables, use original varnames
	
	di as text " "
	di as text "Compare to variables (string and numeric): " "`x'"	// display name of variable
	compare `x' `x'_str									// compare variable values -> should be jointly defined/missing 
	local i=`i'+1
}

aorder
order iso3n country country_b year
drop *_str												// drop original string variables

* select variables 
keep country iso3n year ///
	migstock_wb migstock_un migstock_oecd ///
	socx_oecd ///
	wdi_empprilo wdi_unempilo ///
	mignet_un 
	
* migstock	
pwcorr migstock_wb migstock_un migstock_oecd			// high correlation b/w immigrant stock variables

clonevar c_foreignpct=migstock_wb						// imperfect comparability b/w countries of migstock_wb (cf.  cri_macro_codebook.xlsx); but within-country (FE) estimates
replace c_foreignpct=migstock_un if c_foreignpct==.		// use migstock_un if migstock_wb is missing
replace c_foreignpct=migstock_oecd if c_foreignpct==.	// use migstock_oecd if migstock_wb is still missing
lab var c_foreignpct "Combined info from migstock_wb (94%) and migstock_un (6%)"

gen c_L1foreignpct=.
lab var c_L1foreignpct "Lagged migstock (pervious year); combined info from migstock_wb (94%) and migstock_un (6%)"
xtset iso3n year
bysort iso3n: replace c_L1foreignpct=l1.c_foreignpct

* net migration (immigrants minus emigrants)
*PI recode
replace mignet_un = mignet_un/10
rename mignet_un c_mignet

gen c_L1mignet=.
lab var c_L1mignet "Lagged net migration (pervious year)"
xtset iso3n year
bysort iso3n: replace c_L1mignet=l1.c_mignet

* social expenditure
rename socx_oecd c_socx

* employmet rate
rename wdi_empprilo c_emprate

* unemployment rate
rename wdi_unempilo c_unemprate

keep country iso3n year c_foreignpct c_L1foreignpct c_mignet c_L1mignet c_socx c_emprate c_unemprate 

save "t30.cri_macro.dta", replace

* individual level data
use "t30.issp.1996-2016.dta", clear
des, s
table country year, c(n id)

* merge with country level data
merge m:1 country year using "t30.cri_macro.dta"

drop if _merge==2
drop _merge

* merge with fractionalization data, collected by team
merge m:1 country year using "fract_30.dta"

drop if _merge==2
drop _merge

save "t30.issp.analysis.1996-2016.dta", replace

//	analysis

global dv1	old_age
global dv2	unemp
global dv3	redist
global dv4	jobs

global c1 c.c_L1foreignpct
global c2 c.c_L1mignet
global c3 c.c_herf
global c4 c.c_L1foreignpct##c.c_herf
global c5 c.c_L1mignet##c.c_herf

global ind	age age2 i.gender i.edu i.emp
global wave	b1996.year
global cnt	b36.iso3n
global cnty c.c_socx c.c_emprate  

* define analysis-sample
capture drop sample
mark sample
markout sample $dv1 $dv2 $dv3 $dv4 $ind $year c_emprate c_L1foreignpct c_L1mignet c_socx c_herf c_fract
*replace sample=0 if !inlist(cntry,1,3,4,8,11,13,14,17,20,24,25,31,34)  
fre sample
table country year if sample, c(count sample)

tab country year  
tab country year if sample

sum $dv1 $dv2 $dv3 $dv4 age age2 bn.gender bn.edu bn.emp c_emprate c_L1foreignpct c_L1mignet c_socx c_herf c_fract if sample, separator(0) 
pwcorr $dv1 $dv2 $dv3 $dv4 age age2 gender edu emp c_emprate c_L1foreignpct c_L1mignet c_socx c_herf c_fract if sample
pwcorr $dv1 $dv2 $dv3 $dv4 if sample
pwcorr c_emprate c_L1foreignpct c_L1mignet c_socx c_herf c_fract if sample

capture gen cons=1


sort iso3n iso3n_year id


foreach var of varlist $dv1 $dv2 $dv3 $dv4 {
	* Model 1:
							xi: runmlwin `var' $c1 $wave $cnt $cnty $ind cons if sample, level3(iso3n: cons) level2(iso3n_year: cons) level1(id:) ///			// first: models with mql1
						             nopause forcerecast discrete(distribution(binomial) link(logit) denominator(cons)) fpsandwich
						  
	eststo logit3l_m1`var': xi: runmlwin `var' $c1 $wave $cnt $cnty $ind cons if sample, level3(iso3n: cons) level2(iso3n_year: cons) level1(id:) ///			// second: models with pql2 and initial values from first model (to be reported) 
						             nopause forcerecast discrete(distribution(binomial) link(logit) denominator(cons) pql2) initsprevious fpsandwich
	
	* Model 2:
						    xi: runmlwin `var' $c2 $wave $cnt $cnty $ind cons if sample, level3(iso3n: cons) level2(iso3n_year: cons) level1(id:) ///
						             nopause forcerecast discrete(distribution(binomial) link(logit) denominator(cons)) fpsandwich
						  
	eststo logit3l_m2`var': xi: runmlwin `var' $c2 $wave $cnt $cnty $ind cons if sample, level3(iso3n: cons) level2(iso3n_year: cons) level1(id:) ///
						             nopause forcerecast discrete(distribution(binomial) link(logit) denominator(cons) pql2) initsprevious fpsandwich
	
	* Model 3:
							xi: runmlwin `var' $c3 $wave $cnt $cnty $ind cons if sample, level3(iso3n: cons) level2(iso3n_year: cons) level1(id:) ///
						             nopause forcerecast discrete(distribution(binomial) link(logit) denominator(cons)) fpsandwich
						  
	eststo logit3l_m3`var': xi: runmlwin `var' $c3 $wave $cnt $cnty $ind cons if sample, level3(iso3n: cons) level2(iso3n_year: cons) level1(id:) ///
						             nopause forcerecast discrete(distribution(binomial) link(logit) denominator(cons) pql2) initsprevious fpsandwich
	
	* Model 4:
							xi: runmlwin `var' $c4 $wave $cnt $cnty $ind cons if sample, level3(iso3n: cons) level2(iso3n_year: cons) level1(id:) ///
						             nopause forcerecast discrete(distribution(binomial) link(logit) denominator(cons)) fpsandwich
						  
	eststo logit3l_m4`var': xi: runmlwin `var' $c4 $wave $cnt $cnty $ind cons if sample, level3(iso3n: cons) level2(iso3n_year: cons) level1(id:) ///
						             nopause forcerecast discrete(distribution(binomial) link(logit) denominator(cons) pql2) initsprevious fpsandwich
	
	* Model 5:
							xi: runmlwin `var' $c5 $wave $cnt $cnty $ind cons if sample, level3(iso3n: cons) level2(iso3n_year: cons) level1(id:) ///
						             nopause forcerecast discrete(distribution(binomial) link(logit) denominator(cons)) fpsandwich
						  
	eststo logit3l_m5`var': xi: runmlwin `var' $c5 $wave $cnt $cnty $ind cons if sample, level3(iso3n: cons) level2(iso3n_year: cons) level1(id:) ///
						             nopause forcerecast discrete(distribution(binomial) link(logit) denominator(cons) pql2) initsprevious fpsandwich
	}
	
* Tables
* N 
	est restore logit3l_m2$dv1
	matrix def N_g=e(N_g)
	foreach model in $dv1 $dv2 $dv3 $dv4 { 
		forvalues i=1/5 {
			est restore logit3l_m`i'`model'
				estadd scalar N3 = N_g[1,1]
				estadd scalar N2 = N_g[1,2]
		}
		}

* one table for each DV
local counter = 1
foreach model in $dv1 $dv2 $dv3 $dv4 {
	if `counter' == 1 {
	 esttab logit3l_m1`model' ///
			logit3l_m2`model' ///
			logit3l_m3`model' ///
			logit3l_m4`model' ///
			logit3l_m5`model' ///
			using "logit.table_$S_DATE.rtf", eform 											///
				stats(N3 N2 N, fmt(%18.0g) label("N countries" "N country-years" "N persons" ))			/// 
				c(b(fmt(3) star label(OR)) z(fmt(3))) stardetach											///
				order(c_L1foreignpct c_L1mignet c_herf c_c_L1foreignpct_c_c_herf c_c_L1mignet_c_c_herf c_socx c_emprate )	///
				coeflabels(c_L1foreignpct "Immigrant stock pervious year (%)" 								///
						c_socx "Social welfare expenditures (% of GDP)"									///
						c_emprate "Employment Rate (% in LF)"											///
						c_L1mignet "Net migration previous year (per 1,000)"							///
						c_herf "Herfindahl index (origin countries) previous year"						///
						c_c_L1foreignpct_c_c_herf "Herfindahl index X immigrant stock"					///
						c_c_L1mignet_c_c_herf "Herfindahl index X net migration"						///
						age "Age" age2 "Age squared" _Igender_1 "Gender (1=female)"						///
						_Iedu_2 "Secondary" _Iedu_3 "University or more" 								///
						_Iemp_2 "Part-time emp." _Iemp_3 "Unemployed" _Iemp_4 "Not active"				///
						cons "Constant")																///
				drop(*iso3n *year OD: RP2: RP3:)														///
				refcat(c_foreignpct "COUNTRY-LEVEL VARIABLES" age "INDIVIDUAL-LEVEL VARIABLES"				///
					_Iedu_2 "Primary or less (Ref.)" _Iemp_2 "Full-time emp. (Ref.)", label(" "))					///
				eqlabels(" " "Level 3 (countries)" "Level 2 (country-years)")								///
				mtitles("`model'" "`model'" "`model'" "`model'" "`model'")									///
				varwidth(30) modelwidth(10)																	///
				addnote("Source: ISSP 1996, 2006, 2016. Country and year fixed effects included. Unweighted"	///
						"Cluster robust standard errors. Z-statistics below the odds ratios. * p<0.05, ** p<0.01, *** p<0.001."	///
						"Model fit through using second order penalized quasi-likelihood linearization (MLwiN).")	///
				tit(Table `counter'. Three level logit models predicting support for governmental policies) 	///
			rtf replace
			}
	else {
	 esttab logit3l_m1`model' ///
			logit3l_m2`model' ///
			logit3l_m3`model' ///
			logit3l_m4`model' ///
			logit3l_m5`model' ///
			using "logit.table_$S_DATE.rtf", eform 											///
				stats(N3 N2 N, fmt(%18.0g) label("N countries" "N country-years" "N persons" ))			/// 
				c(b(fmt(3) star label(OR)) z(fmt(3))) stardetach											///
				order(c_L1foreignpct c_L1mignet c_herf c_c_L1foreignpct_c_c_herf c_c_L1mignet_c_c_herf c_socx c_emprate )	///
				coeflabels(c_L1foreignpct "Immigrant stock pervious year (%)" 								///
						c_socx "Social welfare expenditures (% of GDP)"									///
						c_emprate "Employment Rate (% in LF)"											///
						c_L1mignet "Net migration previous year (per 1,000)"							///
						c_herf "Herfindahl index (origin countries) previous year"						///
						c_c_L1foreignpct_c_c_herf "Herfindahl index X immigrant stock"					///
						c_c_L1mignet_c_c_herf "Herfindahl index X net migration"						///
						age "Age" age2 "Age squared" _Igender_1 "Gender (1=female)"						///
						_Iedu_2 "Secondary" _Iedu_3 "University or more" 								///
						_Iemp_2 "Part-time emp." _Iemp_3 "Unemployed" _Iemp_4 "Not active"				///
						cons "Constant")																///
				drop(*iso3n *year OD: RP2: RP3:)														///
				refcat(c_foreignpct "COUNTRY-LEVEL VARIABLES" age "INDIVIDUAL-LEVEL VARIABLES"				///
					_Iedu_2 "Primary or less (Ref.)" _Iemp_2 "Full-time emp. (Ref.)", label(" "))					///
				eqlabels(" " "Level 3 (countries)" "Level 2 (country-years)")								///
				mtitles("`model'" "`model'" "`model'" "`model'" "`model'")									///
				varwidth(30) modelwidth(10)																	///
				addnote("Source: ISSP 1996, 2006, 2016. Country and year fixed effects included. Unweighted"	///
						"Cluster robust standard errors. Z-statistics below the odds ratios. * p<0.05, ** p<0.01, *** p<0.001."	///
						"Model fit through using second order penalized quasi-likelihood linearization (MLwiN).")	///
				tit(Table `counter'. Three level logit models predicting support for governmental policies) 	///
			rtf append
		}
	local counter=`counter'+1
}
	


erase "t30.issp.analysis.1996-2016.dta"
erase "t30.issp.1996.dta"
erase "t30.issp.2006.dta"
erase "t30.issp.2016.dta"
erase "t30.issp.1996-2016.dta" 

/* PIs do not have MLwin therefore we simply derive their results here. They are
in odds-ratios and accoring to the team, MLwin cannot output average marginal effects. 
Therefore we apply the following 'work around'. 

This team argued for effects being different by response. Therefore,
we allow their margins to be categorical as well. We consider the 
cutpoints in recreating a single linear effect
Treat four ordered logits as 1, 2, 3 and 4 and then estimate the 
difference between the population mean with this coding scheme and 
the predicted population mean based on the likelihood of being in each
category given a 1 point higher value of the indep. variable. This gives 
an approximation of what the overall population mean would be given 
unequal effect intervals.

The alternative to this would be to predict(xb) and have a linear effect,
but our coding here allows the sampled values in the data to change
differently for each parameter given a 1 point change in the 
independent variable */



gen id = [_n]
gen id2 = id-72
replace id = id2 if id>72

recode id (1/4 25/28 49/52 =1)(5/8 29/32 53/56 =2) ///
(9/12 33/36 57/60 =3)(13/16 37/40 61/64 =4) ///
(17/20 41/44 65/68 =5)(21/24 45/48 69/72 =6), gen(dv)

*This finds the number of respondents in each category of
*the ologit for each model (4 per model)
recode id ///
( 1 25 49 73  97 121 = 6714)  /// 
( 2 26 50 74  98 122 = 13513) ///
( 3 27 51 75  99 123 = 19720) ///
( 4 28 52 76 100 124 = 17065) /// /* jobs */
( 5 29 53 77 101 125 = 424)   ///
( 6 30 54 78 102 126 = 2397)  ///
( 7 31 55 79 103 127 = 19804) ///
( 8 32 56 80 104 128 = 35703) /// /* old */
( 9 33 57 81 105 129 = 4036)  ///
(10 34 58 82 106 130 = 11847) ///
(11 35 59 83 107 131 = 26381) ///
(12 36 60 84 108 132 = 14121) /// /* unemp */
(13 37 61 85 109 133 = 4595)  /// 
(14 38 62 86 110 134 = 9839)  ///
(15 39 63 87 111 135 = 18850) ///
(16 40 64 88 112 136 = 23452) /// /* incdif */
(17 41 65 89 113 137 = 2497)  ///
(18 42 66 90 114 138 = 8912)  ///
(19 43 67 91 115 139 = 27272) ///
(20 44 68 92 116 140 = 18050) /// /* house */
(21 45 69 93 117 141 = 494)   /// 
(22 46 70 94 118 142 = 2073)  ///
(23 47 71 95 119 143 = 16940) ///
(24 48 72 96 120 144 = 38820) /// /* health */
, gen(pop)

*This takes the total number of respondents listwise
recode id ///
( 1 25 49 73  97 121 = 57012)  /// 
( 5 29 53 77 101 125 = 58328)  ///
( 9 33 57 81 105 129 = 56385)  ///
(13 37 61 85 109 133 = 56736)  /// 
(17 41 65 89 113 137 = 56731)  ///
(21 45 69 93 117 141 = 58327)  /// 
(*=.), gen(tpop)

*This assigns 1,2,3&4 as values to each category
recode id ///
( 1 25 49 73  97 121 = 1) /// 
( 2 26 50 74  98 122 = 2) ///
( 3 27 51 75  99 123 = 3) ///
( 4 28 52 76 100 124 = 4) /// /* jobs */
( 5 29 53 77 101 125 = 1) ///
( 6 30 54 78 102 126 = 2) ///
( 7 31 55 79 103 127 = 3) ///
( 8 32 56 80 104 128 = 4) /// /* old */
( 9 33 57 81 105 129 = 1) ///
(10 34 58 82 106 130 = 2) ///
(11 35 59 83 107 131 = 3) ///
(12 36 60 84 108 132 = 4) /// /* unemp */
(13 37 61 85 109 133 = 1) /// 
(14 38 62 86 110 134 = 2) ///
(15 39 63 87 111 135 = 3) ///
(16 40 64 88 112 136 = 4) /// /* incdif */
(17 41 65 89 113 137 = 1) ///
(18 42 66 90 114 138 = 2) ///
(19 43 67 91 115 139 = 3) ///
(20 44 68 92 116 140 = 4) /// /* house */
(21 45 69 93 117 141 = 1) /// 
(22 46 70 94 118 142 = 2) ///
(23 47 71 95 119 143 = 3) ///
(24 48 72 96 120 144 = 4) /// /* health */
, gen(score)


gen mean = ((score*pop)+(score[_n+1]*pop[_n+1]) ///
+(score[_n+2]*pop[_n+2])+(score[_n+3]*pop[_n+3]))/tpop

gen margmean = ( ///
score*(pop+(pop*_margin)) + ///
score[_n+1]*(pop[_n+1]+(pop[_n+1]*_margin[_n+1])) + ///
score[_n+2]*(pop[_n+2]+(pop[_n+2]*_margin[_n+2])) + ///
score[_n+3]*(pop[_n+3]+(pop[_n+3]*_margin[_n+3])) ///
)/tpop

gen margmean_lb = ( ///
score*(pop+(pop*(_ci_lb))) + ///
score[_n+1]*(pop[_n+1]+(pop[_n+1]*(_ci_lb[_n+1]))) + ///
score[_n+2]*(pop[_n+2]+(pop[_n+2]*(_ci_lb[_n+2]))) + ///
score[_n+3]*(pop[_n+3]+(pop[_n+3]*(_ci_lb[_n+3]))) ///
)/tpop

gen margmean_ub = ( ///
score*(pop+(pop*(_ci_ub))) + ///
score[_n+1]*(pop[_n+1]+(pop[_n+1]*(_ci_ub[_n+1]))) + ///
score[_n+2]*(pop[_n+2]+(pop[_n+2]*(_ci_ub[_n+2]))) + ///
score[_n+3]*(pop[_n+3]+(pop[_n+3]*(_ci_ub[_n+3]))) ///
)/tpop

gen AME = margmean - mean
gen lower = margmean_lb - mean
gen upper = margmean_ub - mean
drop if AME == .
gen factor = .
gen n = [_n]
drop id
gen id = "t58m1"
foreach n of numlist 2/36 {
replace id = "t58m`n'" if `n'==n
}
order factor AME lower upper id
keep factor AME lower upper id
save "team58.dta", replace

foreach n of numlist 1/36 {
erase "t58m`n'.dta"
}



}
*==============================================================================*
*==============================================================================*
*==============================================================================*















// TEAM 31
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team31.dta"
  if _rc==0  {
    display "Team 31 already exists, skipping to next code chunk"
  }
  else {
  version 15
  use ZA2900.dta, clear

	** unified country labels
	recode v3 (1=36) (2/3=276) (4=826) (6=840) (8=348) (9=.) (10=372) (12=578) (13=752) (14=203) (15=705) (16=616) (17=.) (18=643) (19=554) (20=124) (21=608) (22/23=376) (24=392) (25=724) (26=428) (27=250) (28=.) (30=756), gen(v3a)
	label define cntrylbl 36 "Australia" 124 "Canada" 152 "Chile" 158 "Taiwan" 191 "Croatia" 203 "Czech" 208 "Denmark" 246 "Finland" 250 "France" 276 "Germany" 348 "Hungary" 372 "Ireland" 376 "Isreal" 392 "Japan" 410 "S Korea" 428 "Latvia" 528 "Netherlands" 554 "New Zealand" 578 "Norway" 608 "Philippines" 616 "Poland" 620 "Portugal" 643 "Russia" 705 "Slovenia" 724 "Spain" 752 "Sweden" 756 "Switzerland" 826 "Great Britain" 840 "United States" 
	label values v3a cntrylbl

	** prepare variables
	recode v36 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
	recode govjobs (1/2=0) (3/4=1), gen(dgovjobs)
	lab var govj "provide jobs for everyone"
	lab var dgovj "provide jobs for everyone"

	recode v38 v39  v40  v41 v42-v45  (1=4) (2=3) (3=2) (4=1), ///
			gen(govhcare govretire indgrow govunemp govincdiff govstudents govhousing lawsenv)
	recode govhcare govretire indgrow govunemp govincdiff govstudents govhousing lawsenv (1/2=0) (3/4=1), /// 
			gen(dhcare dgovretire dindgrow dgovunemp dgovincdiff dgovstud dgovhous dlawsenv)

	recode v19 v20 (1=5) (2=4) (4=2) (5=1), gen(cutspend projjobs)
	recode cutspend projjobs (1/3=0) (4/5=1), gen(dcutspend dprojjobs)

	lab var govretire "living standard for the old"
	lab var indgrow "Help industry grow"
	lab var govhcare "healthcare for the sick"
	lab var govunemp "living standard for the unemployed"
	lab var govincdiff "Reduce income diff"
	lab var govstudents "financial help to stud"
	lab var govhousing "decent housing"
	lab var lawsenv "environment laws"
	lab var projjobs "Projects for new jobs"

	lab var dgovretire "living standard for the old"
	lab var dindgrow "Help industry grow"
	lab var dhcare "healthcare for the sick"
	lab var dgovunemp "living standard for the unemployed"
	lab var dgovincdiff "Reduce income diff"
	lab var dgovstud "financial help to stud"
	lab var dgovhous "decent housing"
	lab var dlawsenv "environment laws"
	lab var dprojjobs "Projects for new jobs"


	// AGE
	rename v201 age
	gen agesq=age*age

	// SEX
	recode v200 (1=0) (2=1), gen(female)

	// MARITAL STATUS
	rename v202 marst
	recode marst (5=1) (nonmiss=0), gen(nevermar)
	recode marst (2/5=0), gen(married)
	recode marst (3/4=1) (nonmiss=0), gen(divorced)
	recode marst (2=1) (nonmiss=0), gen(widow)

	// STEADY LIFE PARTNER
	recode v203 (2=0), gen(partner)

	// HOUSEHOLD SIZE
	rename v273 hhsize

	// CHILDREN IN HH
	recode v274 (2/4 10 12 14 16 18 20 22 24 26=1) (6/8=1) (nonmiss=0), gen(kidshh)

	// RURAL
	recode v275 (3=1) (nonmiss=0), gen(rural)
	recode v275 (2=1) (nonmiss=0), gen(suburb)

	// COUNTRY/PLACE OF BIRTH
	rename v324 ETHNIC

	// EDUCATION
	rename v204 edyears
	rename v205 edcat
	recode edcat (1/3=1) (4=2) (5=3) (6=4) (7=5), gen(degree)
	label define edlabels 1 "Primary/less" 2 "Some Secondary" 3 "Secondary" 4 "Some Higher Ed" 5 "University or higher"
	label values degree edlabels

	recode degree (1/2=1) (nonmiss=0), gen(lesshs)
	recode degree (3/4=1) (nonmiss=0), gen(hs)
	recode degree (5=1) (nonmiss=0), gen(univ)

	// OCCUPATION
	rename v208 isco
	rename v209 occ2
	rename v215 hourswrk

	recode v206 (2/10=0), gen(ftemp)
	recode v206 (2/4=1) (nonmiss=0), gen(ptemp)
	recode v206 (5=1) (nonmiss=0), gen(unemp)
	recode v206 (6/10=1) (nonmiss=0), gen(nolabor)

	gen selfemp=v213==1
	replace selfemp=. if v206==.
	gen pubemp=(v212==1 | v212==2)
	replace pubemp=. if v206==.
	gen pvtemp=(selfemp==0 & pubemp==0)
	replace pvtemp=. if v206==.

	// INCOME
	rename v218 faminc
	set more off
	gen inczscore=.
	levelsof v3, local(cntries)
	foreach cntryval of local cntries {
		zscore faminc if v3==`cntryval', listwise
		replace inczscore=z_faminc if v3==`cntryval'
		drop z_faminc
	}

	// UNION MEMBER
	recode v222 (2=0), gen(union)

	// POLITICAL PARTY 
	rename v223 party

	// RELIGIOUS ATTENDANCE
	recode v220 (1/2=1) (nonmiss=0), gen(highrel)
	recode v220 (3/5=1) (nonmiss=0), gen(lowrel)
	recode v220 (6=1) (nonmiss=0), gen(norel)
	rename v220 religion

	*** TECHNICAL VARIABLES ***

	// year
	gen year=1996
	gen yr2006=0

	// country identifier
	rename v3a cntry

	// weights
	rename v325 wghts

	save "ISSP96recode.dta", replace

	********************************
	********** ISSP 2006 ***********
	********************************

	use "ZA4700.dta", clear

	// Provide jobs for everyone
	recode V25 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
	recode govjobs (1/2=0) (3/4=1), gen(dgovjobs)

	// Provide healthcare for the sick
	recode V27 (1=4) (2=3) (3=2) (4=1), gen(govhcare)
	recode govhcare (1/2=0) (3/4=1), gen(dhcare)

	// Provide living standard for the old
	recode V28 (1=4) (2=3) (3=2) (4=1), gen(govretire)
	recode govretire (1/2=0) (3/4=1), gen(dgovretire)

	// Provide living standard for the unemployed
	recode V30 (1=4) (2=3) (3=2) (4=1), gen(govunemp)
	recode govunemp (1/2=0) (3/4=1), gen(dgovunemp)

	// Reduce income diff bw rich and poor
	recode V31 (1=4) (2=3) (3=2) (4=1), gen(govincdiff)
	recode govincdiff (1/2=0) (3/4=1), gen(dgovincdiff)

	// Provide decent housing to those who can't afford it
	recode V33 (1=4) (2=3) (3=2) (4=1), gen(govhousing)
	recode govhousing (1/2=0) (3/4=1), gen(dgovhous)

	**** TRUST ****

	// Only a few people to trust
	rename V54 trustfew
	recode trustfew (1/2 = 0) (3/5 = 1), gen(dtrust)

	// People will take advantage
	rename V55 takeadv
	recode takeadv (1/2 = 0) (3/5 = 1), gen(dtakeadv)


	// AGE
	gen agesq=age*age

	// SEX
	recode sex (1=0) (2=1), gen(female)

	// MARITAL STATUS
	rename marital marst
	recode marst (5=1) (nonmiss=0), gen(nevermar)
	recode marst (2/5=0), gen(married)
	recode marst (3/4=1) (nonmiss=0), gen(divorced)
	recode marst (2=1) (nonmiss=0), gen(widow)

	// STEADY LIFE PARTNER
	recode cohab (2=0), gen(partner)

	// HOUSEHOLD SIZE
	// top-coded at 8 for Sweden, 9 for Denmark
	rename hompop hhsize

	// CHILDREN IN HH
	recode hhcycle (2/4=1) (6/8=1) (nonmiss=0), gen(kidshh)
	local i = 10
	while `i' < 29 {
		replace kidshh=1 if hhcycle==`i'
		local i = `i' + 2
	}

	// RURAL
	recode urbrural (1/3=0) (4/5=1), gen(rural)
	recode urbrural (2/3=1) (nonmiss=0), gen(suburb)

	// EDUCATION
	// see pg 97 in codebook
	rename educyrs edyears
	rename degree edcat
	recode edcat (0=1), gen(degree)
	label define edlabels 1 "Primary/less" 2 "Some Secondary" 3 "Secondary" 4 "Some Higher Ed" 5 "University or higher"
	label values degree edlabels

	recode degree (1/2=1) (nonmiss=0), gen(lesshs)
	recode degree (3/4=1) (nonmiss=0), gen(hs)
	recode degree (5=1) (nonmiss=0), gen(univ)

	// OCCUPATION
	rename wrkst empstat
	rename ISCO88 isco // see pg 137 in codebook
	rename wrkhrs hourswrk

	recode empstat (2/10=0), gen(ftemp)
	recode empstat (2/4=1) (nonmiss=0), gen(ptemp)
	recode empstat (5=1) (nonmiss=0), gen(unemp)
	recode empstat (6/10=1) (nonmiss=0), gen(nolabor)

	gen selfemp=wrktype==4
	replace selfemp=. if empstat==.
	gen pubemp=(wrktype==1 | wrktype==2)
	replace pubemp=. if empstat==.
	gen pvtemp=(selfemp==0 & pubemp==0)
	replace pvtemp=. if empstat==.

	// INCOME
	set more off
	gen inczscore=.
	local incvars = "AU_INC CA_INC CH_INC CL_INC CZ_INC DE_INC DK_INC DO_INC ES_INC FI_INC FR_INC GB_INC HR_INC HU_INC IE_INC IL_INC JP_INC KR_INC LV_INC NL_INC NO_INC NZ_INC PH_INC PL_INC PT_INC RU_INC SE_INC SI_INC TW_INC US_INC UY_INC VE_INC ZA_INC" 
	foreach incvar of local incvars {
		zscore `incvar', listwise
		replace inczscore=z_`incvar' if z_`incvar'!=.
		drop z_`incvar'
	}

	// UNION MEMBER
	rename union UNION
	recode UNION (2/3=0), gen(union)

	// POLITICAL PARTY
	rename PARTY_LR party

	// RELIGIOUS ATTENDANCE
	recode attend (1/3=1) (nonmiss=0), gen(highrel)
	recode attend (4/7=1) (nonmiss=0), gen(lowrel)
	recode attend (8=1) (nonmiss=0), gen(norel)
	rename attend religion

	*** TECHNICAL VARIABLES ***

	// Country Identifier
	rename V3a cntry

	// weights
	rename weight wghts

	// year
	gen year=2006
	gen yr2006=1

	gen mail=mode==34

	save "ISSP06recode.dta", replace


	************************************************************************************************************************************************************
	//////////////////////                             MERGING FILES                ////////////////////////////////////////////////////////////////////////////
	************************************************************************************************************************************************************

	append using "ISSP96recode.dta"
	sort cntry year
preserve 
import excel "cri_macro2.xlsx", first clear
ren  iso cntry
save cri_macro_31.dta, replace
restore
	*some values were nonnumeric in the original cri_macro1.xlsx, so this is just a fixed version
	merge m:1 cntry year using "cri_macro_31.dta"
	recode cntry (36=1) (124=1) (208=1) (246=1) (250=1) (276=1) (372=1) (392=1) (528=1) (554=1) (578=1) (620=1) (724=1) (752=1) (756=1) (826=1) (840=1) (else=0), gen(orig17)
	recode cntry (36=1) (124=1) (250=1) (276=1) (372=1) (392=1) (554=1) (578=1) (724=1) (752=1) (756=1) (826=1) (840=1) (else=0), gen(orig13)

	save "ISSP9606.dta", replace


**************** Table 4 **********
use ISSP9606.dta, clear

ren (govjobs govunemp govincdiff govretire govhous govhcare) (Jobs	Unemp	IncomeDif	Old	House	Health)

*PI added, will not run without destring command
destring migstock*, replace
//

egen foreignpct=rowmean(migstock*)
gen emprate=wdi_empprilo
*PI added
destring emprate, replace
//
gen socx=socx_oecd
destring socx,replace

global depvars "Jobs	Unemp	IncomeDif	Old	House	Health" 
global controls "age agesq female nevermar divorced widow hhsize kidshh rural suburb lesshs univ ptemp unemp nolabor selfemp pubemp inczscore highrel lowrel year"
global cntryvars "foreignpct netmigpct cforborn socx socdem liberal emprate assim diffex multi"
	
egen allcontrols = rowmiss($controls)
recode allcontrols (0=1) (nonmiss=0)
keep if allcontrols

quietly tab cntry, gen(cntryfe)

qui mixed Jobs foreignpct $controls  || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m1",replace)
qui mixed Unemp foreignpct $controls   || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m2",replace)
qui mixed IncomeDif foreignpct $controls   || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m3",replace)
qui mixed Old foreignpct $controls   || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m4",replace)
qui mixed House foreignpct $controls   || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m5",replace)
qui mixed Health foreignpct $controls  || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m6",replace)


qui mixed Jobs foreignpct socx $controls   || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m7",replace)
qui mixed Unemp foreignpct socx $controls   || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m8",replace)
qui mixed IncomeDif foreignpct socx $controls   || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m9",replace)
qui mixed Old foreignpct socx $controls   || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m10",replace)
qui mixed House foreignpct socx $controls   || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m11",replace)
qui mixed Health foreignpct socx $controls  || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m12",replace)

qui mixed Jobs foreignpct emprate $controls   || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m13",replace)
tab country year if e(sample)==1
qui mixed Unemp foreignpct emprate $controls   || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m14",replace)
qui mixed IncomeDif foreignpct emprate $controls   || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m15",replace)
qui mixed Old foreignpct emprate $controls   || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m16",replace)
qui mixed House foreignpct emprate $controls   || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m17",replace)
qui mixed Health foreignpct emprate $controls  || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m18",replace)
	
**************************** TABLE 5 *************************************.			

gen netmigpct=mignet_un
*PI 
destring netmigpct, replace
replace netmigpct=netmigpct/10

set more off
qui mixed Jobs netmigpct $controls   || country: || year:, vce(robust)
margins, dydx(netmigpct) saving("t31m25",replace)
qui mixed Unemp netmigpct $controls   || country: || year:, vce(robust)
margins, dydx(netmigpct) saving("t31m26",replace)
qui mixed IncomeDif netmigpct $controls   || country: || year:, vce(robust)
margins, dydx(netmigpct) saving("t31m27",replace)
qui mixed Old netmigpct $controls   || country: || year:, vce(robust)
margins, dydx(netmigpct) saving("t31m28",replace)
qui mixed House netmigpct $controls   || country: || year:, vce(robust)
margins, dydx(netmigpct) saving("t31m29",replace)
qui mixed Health netmigpct $controls  || country: || year:, vce(robust)
margins, dydx(netmigpct) saving("t31m30",replace)

qui mixed Jobs netmigpct socx $controls   || country: || year:, vce(robust)
margins, dydx(netmigpct) saving("t31m31",replace)
qui mixed Unemp netmigpct socx $controls   || country: || year:, vce(robust)
margins, dydx(netmigpct) saving("t31m32",replace)
qui mixed IncomeDif netmigpct socx $controls   || country: || year:, vce(robust)
margins, dydx(netmigpct) saving("t31m33",replace)
qui mixed Old netmigpct socx $controls   || country: || year:, vce(robust)
margins, dydx(netmigpct) saving("t31m34",replace)
qui mixed House netmigpct socx $controls   || country: || year:, vce(robust)
margins, dydx(netmigpct) saving("t31m35",replace)
qui mixed Health netmigpct socx $controls  || country: || year:, vce(robust)
margins, dydx(netmigpct) saving("t31m36",replace)

qui mixed Jobs netmigpct emprate $controls   || country: || year:, vce(robust)
margins, dydx(netmigpct) saving("t31m37",replace)
qui mixed Unemp netmigpct emprate $controls   || country: || year:, vce(robust)
margins, dydx(netmigpct) saving("t31m38",replace)
qui mixed IncomeDif netmigpct emprate $controls   || country: || year:, vce(robust)
margins, dydx(netmigpct) saving("t31m39",replace)
qui mixed Old netmigpct emprate $controls   || country: || year:, vce(robust)
margins, dydx(netmigpct) saving("t31m40",replace)
qui mixed House netmigpct emprate $controls   || country: || year:, vce(robust)
margins, dydx(netmigpct) saving("t31m41",replace)
qui mixed Health netmigpct emprate $controls  || country: || year:, vce(robust)
margins, dydx(netmigpct) saving("t31m42",replace)

qui mixed Jobs netmigpct foreignpct  $controls   || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m19",replace)
margins, dydx(netmigpct) saving("t31m43",replace)
qui mixed Unemp netmigpct foreignpct  $controls   || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m20",replace)
margins, dydx(netmigpct) saving("t31m44",replace)
qui mixed IncomeDif netmigpct foreignpct  $controls   || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m21",replace)
margins, dydx(netmigpct) saving("t31m45",replace)
qui mixed Old netmigpct foreignpct  $controls   || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m22",replace)
margins, dydx(netmigpct) saving("t31m46",replace)
qui mixed House netmigpct foreignpct  $controls   || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m23",replace)
margins, dydx(netmigpct) saving("t31m47",replace)
qui mixed Health netmigpct foreignpct  $controls  || country: || year:, vce(robust)
margins, dydx(foreignpct) saving("t31m24",replace)
margins, dydx(netmigpct) saving("t31m48",replace)

use t31m1,clear
foreach x of numlist 2/48 {
append using t31m`x'
}
gen f = [_n]
gen factor = "Immigrant Stock" 
replace factor = "Immigrant Flow-1 year" if f>24

clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
gen id = "t31m1"
foreach x of numlist 2/48 {
replace id = "t31m`x'" if f==`x'
}
order factor AME lower upper id
keep factor AME lower upper id
save team31, replace

foreach x of numlist 1/48 {
erase t31m`x'.dta
}
erase cri_macro_31.dta
erase ISSP9606.dta
erase ISSP06recode.dta
erase ISSP96recode.dta
 } 
*==============================================================================*
*==============================================================================*
*==============================================================================*
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 // TEAM 32
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*
capture confirm file "team32.dta"
  if _rc==0  {
    display "Team 32 already exists, skipping to next code chunk"
  }
  else {
 version 15 
  
use "ZA2900.dta", clear 

* countries
decode v3, gen(temp)

gen V3a = .
replace V3a = 36    if temp == "aus"
replace V3a = 2761 if temp == "D-W"
replace V3a = 2762 if temp == "D-E"
replace V3a = 826 if temp == "gb"
replace V3a = 840   if temp == "usa"
replace V3a = 348   if temp == "h"
replace V3a = 380   if temp == "i"
replace V3a = 372   if temp == "irl"
replace V3a = 578   if temp == "n"
replace V3a = 752   if temp == "s"
replace V3a = 203   if temp == "cz"
replace V3a = 705   if temp == "slo"
replace V3a = 616   if temp == "pl"
replace V3a = 100   if temp == "bg"
replace V3a = 643   if temp == "rus"
replace V3a = 554   if temp == "nz"
replace V3a = 124   if temp == "cdn"
replace V3a = 608   if temp == "rp"
replace V3a = 3761 if temp == "IL-J"
replace V3a = 3762 if temp == "IL-A"
replace V3a = 392   if temp == "j"
replace V3a = 724   if temp == "e"
replace V3a = 428   if temp == "lv"
replace V3a = 250   if temp == "f"
replace V3a = 196   if temp == "cy"
replace V3a = 756   if temp == "ch"

rename V3a v3a
keep if v3a == 392 | v3a == 578 | v3a == 752 | v3a == 826 ///
	| v3a == 724 | v3a == 250 | v3a == 2761 | v3a == 2762  | v3a == 756 ///
	| v3a == 840 | v3a == 36 | v3a == 554

gen country = "Australia" if v3a == 36
replace country = "Germany" if v3a == 2761 | v3a == 2762
replace country = "UK" if v3a == 826
replace country = "USA" if v3a == 840
replace country = "Japan" if v3a == 392
replace country = "Norway" if v3a == 578
replace country = "Sweden" if v3a == 752
replace country = "Spain" if v3a == 724
replace country = "France" if v3a == 250
replace country = "Switzerland" if v3a == 756
replace country = "New Zealand" if v3a == 554
	

* DVs
gen retirement = v39
gen unemployment = v41
gen income = v42
gen jobs = v36
gen healthcare = v38
gen housing = v44

*Demographics

//gender and age
gen female = v200-1
gen age = v201
gen age2 = age*age


//marital status: married as baseline category
gen widow=0
replace widow = 1 if v202 == 2
replace widow = . if v202 == .

gen divorced = 0
replace divorced = 1 if v202 == 3 | v202 == 4
replace divorced = . if v202 == .

gen single = 0
replace single = 1 if v202 == 5
replace single = . if v202 == .

//household size 
gen hhsize = v273

gen hhchildren = 1
replace hhchildren = 0 if v274 == 1 | v274 == 5 | v274 == 9 | v274 == 11 | v274 == 13 | v274 == 15 | v274 == 17 | v274 == 19 ///
	| v274 == 21 | v274 == 23 | v274 == 27
replace hhchildren = . if v274 == . | v274 == 95


//urban: baseline category
gen rural = 0
replace rural = 1 if v275 == 3
replace rural = . if v275 == .

gen suburb = 0
replace suburb = 1 if v275 == 2
replace suburb = . if v275 == .


//education: secondary is baseline
gen educ_low = 0
replace educ_low = 1 if v205 >= 1 & v205 <= 4
replace educ_low = . if v205 == .

gen educ_high = 0
replace educ_high = 1 if v205 == 6 | v205 == 7
replace educ_high = . if v205 == .


//employment status: employed as baseline

gen unemployed = 0
replace unemployed = 1 if v206 == 5
replace unemployed = . if v206 == .

gen notinLF = 0
replace notinLF = 1 if v206 == 4 | v206 == 6 | v206 == 7 | v206 == 8 | v206 == 9 | v206 == 10
replace notinLF = . if v206 == .

* NOTE: we use simpler categories to harmonize with 2016 data


//country-specific income
gen csincome = .

levelsof country , local(levels)
foreach l of local levels {
	cap drop temp
	egen temp = std(v218) if country == "`l'"
	replace csincome = temp if csincome == .
}


//religious attendance: none is reference category
gen relig_low = 0
replace relig_low = 1 if v220 == 5
replace relig_low = . if v220 == .

gen relig_high = 0
replace relig_high = 1 if v220 >= 1 & v220 <= 4
replace relig_high = . if v220 == .

bysort v3a: egen sample_size = count(v3a)
gen weight = v325 / sample_size


* Saving TEMP
keep v3a country weight sample_size ///
	retirement unemployment income jobs healthcare housing ///
	female age age2 widow divorced single hhsize hhchildren rural suburb ///
	educ_low educ_high unemployed notinLF csincome relig_low relig_high

gen year= 1996

save "ZA2900_clean.dta", replace  


* ----------------------- *
* Cleaning 2006 ISSP data *
* ----------------------- *

use "ZA4700.dta", clear 

rename *, lower

keep if v3a == 392 | v3a == 578 | v3a == 752 | v3a == 826 ///
	| v3a == 724 | v3a == 250 | v3a == 276 | v3a == 756 ///
	| v3a == 840 | v3a == 36 | v3a == 554

gen country = "Australia" if v3a == 36
replace country = "Germany" if v3a == 276
replace country = "UK" if v3a == 826
replace country = "USA" if v3a == 840
replace country = "Japan" if v3a == 392
replace country = "Norway" if v3a == 578
replace country = "Sweden" if v3a == 752
replace country = "Spain" if v3a == 724
replace country = "France" if v3a == 250
replace country = "Switzerland" if v3a == 756
replace country = "New Zealand" if v3a == 554	
	
	
* DVs
gen retirement = v28
gen unemployment = v30
gen income = v31
gen jobs = v25
gen healthcare = v27
gen housing = v33


* Demographis

//age and sex
gen female = sex-1
gen age2 = age * age


//marital status: married as baseline category
gen widow=0
replace widow = 1 if marital == 2
replace widow = . if marital == .

gen divorced = 0
replace divorced = 1 if marital == 3 | marital == 4
replace divorced = . if marital == .

gen single = 0
replace single = 1 if marital == 5
replace single = . if marital == .


//household size 
gen hhsize = hompop

gen hhchildren = 1
replace hhchildren = 0 if hhcycle == 1 | hhcycle == 5 | hhcycle == 9 | hhcycle == 11 | hhcycle == 13 | hhcycle == 15 | hhcycle == 17 | hhcycle == 19 ///
	| hhcycle == 21 
replace hhchildren = . if hhcycle == . | hhcycle == 95


//urban: baseline category
gen rural = 0
replace rural = 1 if urbrural == 4 | urbrural == 5
replace rural = . if urbrural == .

gen suburb = 0
replace suburb = 1 if urbrural == 2 | urbrural == 3
replace suburb = . if urbrural == .


//education: secondary is baseline
gen educ_low = 0
replace educ_low = 1 if degree >= 0 & degree <= 2
replace educ_low = . if degree == .

gen educ_high = 0
replace educ_high = 1 if degree == 4 | degree == 5
replace educ_high = . if degree == .

//employment status: employed as baseline

gen unemployed = 0
replace unemployed = 1 if wrkst == 5
replace unemployed = . if wrkst == .

gen notinLF = 0
replace notinLF = 1 if wrkst == 4 | wrkst == 6 | wrkst == 7 | wrkst == 8 | wrkst == 9 | wrkst == 10
replace notinLF = . if wrkst == .

//country-specific income
gen csincome = .

foreach var of varlist au_inc ch_inc de_inc es_inc fr_inc gb_inc jp_inc no_inc se_inc us_inc nz_inc {
	cap drop temp
	egen temp = std(`var')
	replace csincome = temp if csincome == .
}

//religious attendance: none is reference category
gen relig_low = 0
replace relig_low = 1 if attend == 6 | attend == 7
replace relig_low = . if attend == .

gen relig_high = 0
replace relig_high = 1 if attend >= 1 & attend <= 5
replace relig_high = . if attend == .

*weights
bysort v3a: egen sample_size = count(v3a)

replace weight = weight / sample_size

* Saving TEMP
keep v3a country weight sample_size ///
	retirement unemployment income jobs healthcare housing ///
	female age age2 widow divorced single hhsize hhchildren rural suburb ///
	educ_low educ_high unemployed notinLF csincome relig_low relig_high

gen year = 2006

save "ZA4700_clean.dta", replace 


* ----------------------- *
* Cleaning 2016 ISSP data *
* ----------------------- *

use "ZA6900_v2-0-0.dta", clear 

rename *, lower

rename country v3a
keep if v3a == 392 | v3a == 578 | v3a == 752 | v3a == 826 ///
	| v3a == 724 | v3a == 250 | v3a == 276 | v3a == 756 ///
	| v3a == 840 | v3a == 36 | v3a == 554

gen country = "Australia" if v3a == 36
replace country = "Germany" if v3a == 276
replace country = "UK" if v3a == 826
replace country = "USA" if v3a == 840
replace country = "Japan" if v3a == 392
replace country = "Norway" if v3a == 578
replace country = "Sweden" if v3a == 752
replace country = "Spain" if v3a == 724
replace country = "France" if v3a == 250
replace country = "Switzerland" if v3a == 756
replace country = "New Zealand" if v3a == 554	
	
	
* DVs
gen retirement = v24
gen unemployment = v26
gen income = v27
gen jobs = v21
gen healthcare = v23
gen housing = v29

foreach var of varlist retirement unemployment income jobs healthcare housing {
	recode `var' (8 = .) (9 = .)
}

* Demographis

//age and sex
gen female = sex-1
replace female = . if sex == 9

replace age = . if age > 100
gen age2 = age * age

//marital status: married as baseline category
gen widow=0
replace widow = 1 if marital == 5
replace widow = . if marital == 9

gen divorced = 0
replace divorced = 1 if marital == 3 | marital == 4
replace divorced = . if marital == 9

gen single = 0
replace single = 1 if marital == 6
replace single = . if marital == 9

//household size 
gen hhsize = hompop
recode hhsize (0=.) (99 = .)

gen hhchildren = .
replace hhchildren = 0 if hhchildr == 0
replace hhchildren = 0 if hhchildr == 99 & v3a == 36
replace hhchildren = 1 if hhchildr >= 1 & hhchildr <= 6

//urban: baseline category
gen rural = 0
replace rural = 1 if urbrural == 4 | urbrural == 5
replace rural = . if urbrural == 7 | urbrural == 9

gen suburb = 0
replace suburb = 1 if urbrural == 2 | urbrural == 3
replace suburb = . if urbrural == 7 | urbrural == 9

//education: secondary is baseline
gen educ_low = 0
replace educ_low = 1 if degree >= 0 & degree <= 2
replace educ_low = . if degree == 9

gen educ_high = 0
replace educ_high = 1 if degree == 4 | degree == 5 | degree == 6
replace educ_high = . if degree == 9

//employment status: full-time as baseline
gen unemployed = 0
replace unemployed = 1 if mainstat == 2
replace unemployed = . if mainstat == 9 | mainstat == 99

gen notinLF = 0
replace notinLF = 1 if mainstat >= 3 & mainstat <= 8
replace notinLF = . if mainstat == 9 | mainstat == 99

//country-specific income
replace au_inc = . if au_inc >= 9999990
replace ch_inc = . if ch_inc >= 999990
replace de_inc = . if de_inc >= 999990
replace es_inc = . if es_inc >= 999990
replace fr_inc = . if fr_inc >= 999990
replace gb_inc = . if gb_inc >= 999990
replace jp_inc = . if jp_inc >= 99999990
replace no_inc = . if no_inc >= 9999990
replace se_inc = . if se_inc >= 999990
replace us_inc = . if us_inc >= 999990
replace nz_inc = . if nz_inc >= 999990

gen csincome = .

foreach var of varlist au_inc ch_inc de_inc es_inc fr_inc gb_inc jp_inc no_inc se_inc us_inc nz_inc {
	cap drop temp
	egen temp = std(`var')
	replace csincome = temp if csincome == .
}

//religious attendance: none is reference category
gen relig_low = 0
replace relig_low = 1 if attend == 6 | attend == 7
replace relig_low = . if attend == 98 | attend == 99

gen relig_high = 0
replace relig_high = 1 if attend >= 1 & attend <= 5
replace relig_high = . if attend == 98 | attend == 99


*weights
bysort v3a: egen sample_size = count(v3a)

replace weight = weight / sample_size

* Saving TEMP
keep v3a country weight sample_size ///
	retirement unemployment income jobs healthcare housing ///
	female age age2 widow divorced single hhsize hhchildren rural suburb ///
	educ_low educ_high unemployed notinLF csincome relig_low relig_high

gen year = 2016

save "ZA6900_clean.dta", replace 


* --------- *
* Appending *
* --------- *

use "ZA2900_clean.dta", clear 
append using "ZA4700_clean.dta"
append using "ZA6900_clean.dta"


foreach var of varlist retirement unemployment income jobs housing healthcare {
	recode `var' (1 = 3) (3 = 1) (4 = 0)
}


//labels and cleaning up
rename v3a code
order sample_size, after(code)
order year, after(country)
order weight, after(country)
gen _DVs_ = .
order _DVs_, after(year)
gen _DEMOGRAPHICS_ = .
order _DEMOGRAPHICS_ , after(housing)

label var hhsize "Household size"
label var hhchildren "Dummy: children in household?"
label var educ_low "Less than Secondary completed"
label var educ_h "More than Secondary"
label var notinLF "Not in Labor Force"
label var csincome "Respondent's country specific income"
label var relig_l "Low Religious Attendence"
label var relig_h "High Religious Attendence"
label var code "Numeric Country Code"

save "ISSP_clean.dta", replace


* ---------------- *
* Prepping L2 data *
* ---------------- *
import excel "Immigration_Specific.xlsx", sheet("clean") firstrow clear
*use L2data.dta
rename * , lower

rename destination country

gen stock_immigrants = total / population

//eastern europe
egen eeur = rowtotal(albania  belarus  bosnia  bulgaria  croatia  czechia  estonia  ///
	hungary  latvia  lithuania  montenegro  poland  republicofmoldova  romania ///
	 russia  serbia  slovakia  slovenia  tfyrmacedonia  ukraine)

//southern europe
egen seur = rowtotal(andorra  cyprus  greece  holysee  israel  italy  malta  portugal  spain  sanmarino)

//"western"
egen western =  rowtotal(australia  austria  belgium  canada  channelislands  chinahongkong  denmark  faeroeislands ///
	 finland  france   germany  gibralt  greenland  iceland  ireland  isleofman ///
	 japan  liechtenstein  luxembourg  monaco  netherlands  newzealand  norway  republicofkorea  saintpierreandmiquelon  singapore ///
	 sweden  switzerland  unitedkingdom  unitedstatesofamerica  othernorth)

//latin America  carribbean
egen lac = rowtotal(anguilla  antiguaandbarbuda  argentina  aruba  bahamas  barbados  belize ///
	 bermuda  bolivia  brazil  britishvirginislands  caribbeannetherlands  caymanislands ///
	 chile  colombia  costarica  cuba  curaçao  dominica  dominicanrepublic  ecuador ///
	 elsalvador  falklandislandsmalvinas  frenchguiana  grenada  guadeloupe  guatemala ///
	 guyana  haiti  honduras  jamaica  martinique  mexico  montserrat  nicaragua ///
	 panama  paraguay  peru  puertorico  saintkittsandnevis  saintlucia  saintvincentandthegrenadines ///
	 sintmaartendutchpart  surinam  trinidad  turksandcaicosislands  unitedstatesvirginislands ///
	 uruguay  venezuela)

//subsaharan africa
egen ssa = rowtotal(angola  benin  botswana  burkinafaso  burundi  caboverde  cameroon  ///
	centralafricanrepublic  chad  comoros  congo  côtedivoire  democraticrepublicofthecongo ///
	 equatorialguinea  eritrea  ethiopia  gabon  gambia  ghana  guinea  guineabissau  kenya ///
	 lesotho  liberia  madagascar  malawi  mali  mauritania  mauritius  mayotte ///
	 mozambique  namibia  niger  nigeria  réunion  rwanda  sainthelena  saotomeandprincipe ///
	 senegal  seychelles  sierraleone  somalia  southafrica  southsudan  sudan  swaziland ///
	 togo  uganda  unitedrepublicoftanzania  westernsahara  zambia  zimbabwe)

//middle east, north africa
egen mena = rowtotal(algeria  bahrain  djibouti  egypt  iraq  jordan  kuwait  lebanon ///
	 libya  morocco  oman  qatar  saudi   stateofpalestine  syria  tunisia ///
	 turkey  unitedarabemirates  yemen)

//asia
egen asia = rowtotal(afghanistan  americansamoa  armenia  azerbaijan  bangladesh  bhutan  bruneidarussalam ///
	 cambodia  china  chinamacao  cookislands  dempeoplesrepublicofkorea   fiji  frenchpolynesia ///
	 georgia  guam  india  indonesia  iranislamicrepublicof   kazakhstan  kiribati ///
	 kyrgyzstan  laopeoplesdemocraticrepublic  malaysia  maldives  marshallislands ///
	 micronesiafedstatesof  mongolia  myanmar  nauru  nepal  newcaledonia  niue  northernmarianaislands ///
	 pakistan  palau  papuanew  philippines   samoa   solomonislands  srilanka  tajikistan ///
	 thailand  timor  tokelau  tonga  turkmen  tuvalu  uzbekistan  vanuatu  vietnam   wallisandfutunaislands)
	
** creating western and non-western immigration:
gen advanced_immigrants = (western + seur) / population
gen nonwestern_immigrants = (total - western - seur) / population
	

//labels
label var stock_immigrants "Percentage Total Immigrant Stock"
label var advanced_immigrants "Immigration from advanced countries"
label var nonwestern_immigrants "Immigration from less developed countries"

replace year = year + 1

keep code year unemploy socx population ///
	stock advanced nonwestern 

replace socx = 23.1 if socx == . & year == 2016 & code == 392 // note: socx variable is missing for japan in 2015, use number from 2013
	
save "L2data_clean.dta", replace

* ------- *
* Merging *
* ------- *

use "ISSP_clean.dta", clear

gen code2 = code
recode code(2761 = 276) (2762 = 276)

merge m:1 code year using "L2data_clean.dta"

/*
Note: in 1995, the population of western germany was 67509627
and of eastern Germany was 14274318
*/
gen tag = 1 if code == 276 & year == 1996 // tagging Germany in 1996
replace weight = weight * population if tag != 1
replace weight = weight * 67509627 if code2 == 2761 & year == 1996
replace weight = weight * 14274318 if code2 == 2762 & year == 1996
drop code2 tag


save "CleanData.dta", replace



*****************
* PRELIMINARIES *
*****************
clear 
use "CleanData.dta"
lab var socx "Welfare State Expenditure"
lab var advanced_immigrants "\#Immigrants from Advanced Economies"
lab var nonwestern_immigrants "\#Immigrants from Non-Western Economies"
lab var stock_immigrants "Percentage of Immigrants"
lab var unemploy "Unemployment Rate"

foreach var of varlist stock advanced nonwestern {
	replace `var' = `var' * 100
}

global controls = "female age age2 single divorced widow educ_low educ_high unemployed notinLF"

egen se = concat(year code)

****************************
* LATENT WELFARE ATTITUDES *
****************************

factor jobs unemployment income retirement housing healthcare, pcf
rotate, blanks(0.4)
predict welfarestate
lab var welfarestate "Welfare State, gen."

*PI adjustment
replace welfarestate=welfarestate*0.48
//

*** PREFERED MODEL HERE ***
qui eststo: reg welfarestate stock_immigrants socx unemploy ${controls} i.code i.year [pweight = weight], cluster(se)
margins,dydx(stock_immigrants) saving("team32",replace)
tab code year if e(sample)==1
use team32,clear
gen factor = "Immigrant Stock"
clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
g id = "t32m1"
order factor AME lower upper id
keep factor AME lower upper id
save team32, replace

foreach x of numlist 2900 4700 6900{
erase "ZA`x'_clean.dta"
}
erase ISSP_clean.dta
erase L2data_clean.dta
erase CleanData.dta
 }
*==============================================================================*
*==============================================================================*
*==============================================================================*
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
// TEAM 34
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team34.dta"
  if _rc==0  {
    display "Team 34 already exists, skipping to next code chunk"
  }
  else {
version 15
  use "ZA1490.dta", clear

drop if V3==5
generate country="AU" if V3==1
replace country="DE" if V3==2
replace country="GB" if V3==3
replace country="US" if V3==4
replace country="IT" if V3==8

generate sample=country
generate year=1985
rename V2 id
rename V141 weight
rename V101 jobs
rename V103 hcare
rename V104 old
rename V106 unempl
rename V107 incdif

rename V118 sex
rename V117 age

recode age (1=21)(2=29)(3=39)(4=49)(5=59)(6=69) 

rename V122 eduyrs
recode eduyrs (95 96 97=.)(26/94=26)

rename V123 educ
recode educ (1=1)(2/3=2)(4/5=3)(6/8=5)(0 9=.)

rename V109 empstat
recode empstat (1=2)(2=1)(.=4)
replace empstat=3 if empstat==4 & V110!=. & age>65

rename V120 marital

generate AU_urbrur=V119 if country=="AU"
generate GB_urbrur=V119 if country=="GB"
generate US_urbrur=V119 if country=="US"
generate IT_urbrur=V119 if country=="IT"

recode AU_urbrur (1 2=1)(3=2)(4/6=3)
recode GB_urbrur (1 2=1)(3=2)(4 5=3)
recode US_urbrur (1/5=1)(6 7=2)(8/10=3)
recode IT_urbrur (1 2=1)(3 4=2)(5 6=3)

generate urbrur=AU_urbrur if country=="AU"
replace urbrur=GB_urbrur if country=="GB"
replace urbrur=US_urbrur if country=="US"
replace urbrur=IT_urbrur if country=="IT"

rename V132 relgr
rename V133 attend
* rename xxx topbot top-bottom not available 1985
rename V134 sclass
recode sclass (1 2=1)(3 4=2)(5 6=3)(else=.)

rename V116 union
recode union (1=1)(2=0)

rename V121 hhsize

generate AU_INC=V128 if country=="AU"
generate DE_INC=V129 if country=="DE" // no household income for Germany available, instead earnings
generate GB_INC=V128 if country=="GB"
generate US_INC=V128 if country=="US"
generate IT_INC=V128 if country=="IT"

foreach var of varlist AU_INC DE_INC GB_INC US_INC IT_INC {
xtile `var'_per=`var', nq(100)
egen  `var'_z  =std(`var')
}

generate inc_per=AU_INC_per if country=="AU"
replace inc_per=DE_INC_per if country=="DE"
replace inc_per=GB_INC_per if country=="GB"
replace inc_per=US_INC_per if country=="US"
replace inc_per=IT_INC_per if country=="IT"


sum AU_INC_z DE_INC_z GB_INC_z US_INC_z IT_INC_z
generate inc_z=AU_INC_z if country=="AU"
replace inc_z=DE_INC_z if country=="DE"
replace inc_z=GB_INC_z if country=="GB"
replace inc_z=US_INC_z if country=="US"
replace inc_z=IT_INC_z if country=="IT"
sum inc_z

* rename xx ethnic Ethnicity not availble 1985

keep year country sample id weight ///
   jobs hcare old unempl incdif ///
   sex age eduyrs educ empstat marital urbrur relgr attend sclass union hhsize inc_per inc_z
   
save "ISSP-select-1985.dta", replace

*** Use ISSP 1990

use "ZA1950.dta", clear

drop if v3==5

generate country="AU" if v3==1
replace country="DE" if v3==2 | v3==3
replace country="GB" if v3==4
replace country="US" if v3==6
replace country="HU" if v3==7
replace country="IT" if v3==8
replace country="IE" if v3==9
replace country="NO" if v3==10
replace country="IL" if v3==11

generate sample="AU" if v3==1
replace sample="DE-W" if v3==2
replace sample="DE-E" if v3==3
replace sample="GB" if v3==4
replace sample="US" if v3==6
replace sample="HU" if v3==7
replace sample="IT" if v3==8
replace sample="IE" if v3==9
replace sample="NO" if v3==10
replace sample="IL" if v3==11

generate year=1990
rename v2 id
rename v114 weight
rename v49 jobs
rename v51 hcare
rename v52 old
rename v54 unempl
rename v55 incdif
rename v57 housing 

rename v59 sex
rename v60 age
rename v80 eduyrs
recode eduyrs (95 96=.)(26/94=26)

rename v81 educ
recode educ (2=1)(3=2)(4/6=3)(7=4)(8=5)(0 1 9=.)

rename v63 empstat
recode empstat (1/4=1)(5=2)(7=3)(6 8/10=4)	

rename v61 marital

generate AU_urbrur=v105 if country=="AU"
generate DEW_urbrur=v105 if sample=="DE-W"
generate DEE_urbrur=v105 if sample=="DE-W"
generate HU_urbrur=v105 if country=="HU"
generate IE_urbrur=v105 if country=="IE"
generate IL_urbrur=v105 if country=="IL"
generate IT_urbrur=v105 if country=="IT"
generate NO_urbrur=v105 if country=="NO"
generate US_urbrur=v105 if country=="US"

recode AU_urbrur (1 2=1)(3=2)(4/6=3)
recode DEW_urbrur (1 2=1)(3/5=2)(6 7=3)
recode DEE_urbrur (1=1)(2/4=2)(5 6=3)
recode US_urbrur (1/3=1)(4 5=2)(6/7=3)
recode HU_urbrur (1 2=1)(3 4=2)(5 6=3)
recode IT_urbrur (1 2=1)(3 4=2)(5 6=3)
recode IE_urbrur (1=1)(2=2)(3/7=3)
recode NO_urbrur (1=1)(2/4=2)(5 6=3)
recode IL_urbrur (1 3 4 5=1)(2=2)

generate urbrur=AU_urbrur if country=="AU"
replace urbrur=DEW_urbrur if sample=="DE-W"
replace urbrur=DEE_urbrur if sample=="DE-E"
replace urbrur=US_urbrur if country=="US"
replace urbrur=HU_urbrur if country=="HU"
replace urbrur=IT_urbrur if country=="IT"
replace urbrur=IE_urbrur if country=="IE"
replace urbrur=NO_urbrur if country=="NO"
replace urbrur=IL_urbrur if country=="IL"

rename v88 relgr
rename v89 attend

rename v90 sclass
recode sclass (1 2=1)(3 4=2)(5 6=3)(else=.)


rename v77 union
recode union (1=1)(2=0)

* Household size


recode v135 v141 (.=0)
generate hhsize_a=1+v135+v141 if country=="AU" | country=="IL" | country=="IT"
generate hhsize_US=v135+v141 if country=="US"


recode v115 v117 v119 v121 v123 v125 v127 v129 v131 v133 (1 2=1)(else=0), gen(rv115 rv117 rv119 rv121 rv123 rv125 rv127 rv129 rv131 rv133) 
generate hhsize_b=1+rv115+rv117+rv119+rv121+rv123+rv125+rv127+rv129+rv131+rv133 if country=="DE" | country=="GB" | country=="IE" | country=="IT"

bysort country: tab hhsize_a hhsize_b,m // hhsize_b seems more realistic for IT

recode v136 v137 v138 v139 v140 (.=0)
generate hhsize_NO=1+v136+v137+v138+v139+v140+v141 if country=="NO"

generate hhsize=hhsize_a if country=="AU" | country=="IL" | country=="US"
replace hhsize=hhsize_b if country=="DE" | country=="GB" | country=="IE" | country=="IT"
replace hhsize=hhsize_US if country=="US"
replace hhsize=hhsize_NO if country=="NO"

replace hhsize=2 if hhsize==1 & marital==1


generate AU_INC=v100 if country=="AU"
generate DE_INC=v100 if country=="DE"
generate GB_INC=v100 if country=="GB"
generate HU_INC=v100 if country=="HU"
generate IE_INC=v100 if country=="IE"
generate IL_INC=v100 if country=="IL"
generate IT_INC=v100 if country=="IT"
generate NO_INC=v100 if country=="NO"
generate US_INC=v100 if country=="US"

foreach var of varlist AU_INC DE_INC GB_INC HU_INC IE_INC IL_INC IT_INC NO_INC US_INC {
xtile `var'_per=`var', nq(100)
egen  `var'_z  =std(`var')
}

generate inc_per=AU_INC_per if country=="AU"
replace inc_per=DE_INC_per if country=="DE"
replace inc_per=GB_INC_per if country=="GB"
replace inc_per=HU_INC_per if country=="HU"
replace inc_per=IE_INC_per if country=="IE"
replace inc_per=IL_INC_per if country=="IL"
replace inc_per=IT_INC_per if country=="IT"
replace inc_per=NO_INC_per if country=="NO"
replace inc_per=US_INC_per if country=="US"

generate inc_z=AU_INC_z if country=="AU"
replace inc_z=DE_INC_z if country=="DE"
replace inc_z=GB_INC_z if country=="GB"
replace inc_z=HU_INC_z if country=="HU"
replace inc_z=IE_INC_z if country=="IE"
replace inc_z=IL_INC_z if country=="IL"
replace inc_z=IT_INC_z if country=="IT"
replace inc_z=NO_INC_z if country=="NO"
replace inc_z=US_INC_z if country=="US"
sum inc_z

keep year country sample id weight ///
   jobs hcare old unempl incdif housing ///
   sex age eduyrs educ empstat marital urbrur relgr attend sclass union hhsize inc_per inc_z
   
save "ISSP-select-1990.dta", replace

*** Use ISSP 1996

use "ZA2900.dta", clear

drop if v3==17 | v3==28

generate country="AU" if v3==1
replace country="DE" if v3==2 | v3==3
replace country="GB" if v3==4
replace country="US" if v3==6
replace country="HU" if v3==8
replace country="IT" if v3==9
replace country="IE" if v3==10
replace country="NO" if v3==12
replace country="SE" if v3==13
replace country="CZ" if v3==14
replace country="SI" if v3==15
replace country="PL" if v3==16
replace country="RU" if v3==18
replace country="NZ" if v3==19
replace country="CA" if v3==20
replace country="PH" if v3==21
replace country="IL" if v3==22 | v3==23
replace country="JP" if v3==24
replace country="ES" if v3==25
replace country="LV" if v3==26
replace country="FR" if v3==27
replace country="CH" if v3==30

generate sample="AU" if v3==1
replace sample="DE-W" if v3==2
replace sample="DE-E" if v3==3
replace sample="GB" if v3==4
replace sample="US" if v3==6
replace sample="HU" if v3==8
replace sample="IT" if v3==9
replace sample="IE" if v3==10
replace sample="NO" if v3==12
replace sample="SE" if v3==13
replace sample="CZ" if v3==14
replace sample="SL" if v3==15
replace sample="PL" if v3==16
replace sample="RU" if v3==18
replace sample="NZ" if v3==19
replace sample="CA" if v3==20
replace sample="PH" if v3==21
replace sample="IL-J" if v3==22
replace sample="IL-A" if v3==23
replace sample="JP" if v3==24
replace sample="ES" if v3==25
replace sample="LV" if v3==26
replace sample="FR" if v3==27
replace sample="CY" if v3==28
replace sample="CH" if v3==30

generate year=1996
rename v2 id
rename v325 weight
rename v36 jobs
rename v38 hcare
rename v39 old
rename v41 unempl
rename v42 incdif
rename v44 housing 

rename v200 sex
rename v201 age
rename v204 eduyrs
bysort country: sum eduyrs // missing for Spain
recode eduyrs (97=0)(94 95 96=.)(26/94=26)

rename v205 educ
recode educ (2=1)(3/4=2)(5=3)(6=4)(7=5)(1 99=.)

rename v206 empstat
recode empstat (1/4=1)(5=2)(7=3)(6 8/10=4)	
tab empstat, m

rename v202 marital

recode v282 (1 2=1)(3/5=2)(6 7=3), gen(DE_urbrur)
recode v283 (1/3=1)(4 5=2)(6 7=3), gen(ES_urbrur)
recode v290 (1/3=1)(4=2)(5=3), gen(JP_urbrur)

rename v275 urbrur
replace urbrur=DE_urbrur if country=="DE"
replace urbrur=ES_urbrur if country=="ES"
replace urbrur=JP_urbrur if country=="JP"

rename v219 relgr
rename v220 attend
rename v221 sclass
recode sclass (1 2=1)(3 4=2)(5 6=3)(else=.)

rename v222 union
recode union (1=1)(2=0)

rename v273 hhsize


generate AU_INC=v218 if country=="AU"
generate CA_INC=v218 if country=="CA"
generate CH_INC=v218 if country=="CH"
generate CZ_INC=v218 if country=="CZ"
generate DE_INC=v218 if country=="DE"
generate ES_INC=v218 if country=="ES"
generate FR_INC=v218 if country=="FR"
generate GB_INC=v218 if country=="GB"
generate HU_INC=v218 if country=="HU"
generate IE_INC=v218 if country=="IE"
generate IT_INC=v218 if country=="IT"
generate JP_INC=v218 if country=="JP"
generate LV_INC=v218 if country=="LV"
generate NO_INC=v218 if country=="NO"
generate NZ_INC=v218 if country=="NZ"
generate PH_INC=v218 if country=="PH"
generate PL_INC=v218 if country=="PL"
generate RU_INC=v218 if country=="RU"
generate SE_INC=v218 if country=="SE"
generate SI_INC=v218 if country=="SI"
generate US_INC=v218 if country=="US"

foreach var of varlist AU_INC CA_INC CH_INC CZ_INC DE_INC ES_INC FR_INC GB_INC HU_INC IE_INC IT_INC JP_INC LV_INC NO_INC NZ_INC PH_INC PL_INC RU_INC SE_INC SI_INC US_INC {
xtile `var'_per=`var', nq(100)
egen  `var'_z  =std(`var')
}

generate inc_per=AU_INC_per if country=="AU"
replace inc_per=CA_INC_per if country=="CA"
replace inc_per=CH_INC_per if country=="CH"
replace inc_per=CZ_INC_per if country=="CZ"
replace inc_per=DE_INC_per if country=="DE"
replace inc_per=ES_INC_per if country=="ES"
replace inc_per=FR_INC_per if country=="FR"
replace inc_per=GB_INC_per if country=="GB"
replace inc_per=HU_INC_per if country=="HU"
replace inc_per=IE_INC_per if country=="IE"
replace inc_per=IT_INC_per if country=="IT"
replace inc_per=JP_INC_per if country=="JP"
replace inc_per=LV_INC_per if country=="LV"
replace inc_per=NO_INC_per if country=="NO"
replace inc_per=NZ_INC_per if country=="NZ"
replace inc_per=PH_INC_per if country=="PH"
replace inc_per=PL_INC_per if country=="PL"
replace inc_per=RU_INC_per if country=="RU"
replace inc_per=SE_INC_per if country=="SE"
replace inc_per=SI_INC_per if country=="SI"
replace inc_per=US_INC_per if country=="US"

generate inc_z=AU_INC_z if country=="AU"
replace inc_z=CA_INC_z if country=="CA"
replace inc_z=CH_INC_z if country=="CH"
replace inc_z=CZ_INC_z if country=="CZ"
replace inc_z=DE_INC_z if country=="DE"
replace inc_z=ES_INC_z if country=="ES"
replace inc_z=FR_INC_z if country=="FR"
replace inc_z=GB_INC_z if country=="GB"
replace inc_z=HU_INC_z if country=="HU"
replace inc_z=IE_INC_z if country=="IE"
replace inc_z=IT_INC_z if country=="IT"
replace inc_z=JP_INC_z if country=="JP"
replace inc_z=LV_INC_z if country=="LV"
replace inc_z=NO_INC_z if country=="NO"
replace inc_z=NZ_INC_z if country=="NZ"
replace inc_z=PH_INC_z if country=="PH"
replace inc_z=PL_INC_z if country=="PL"
replace inc_z=RU_INC_z if country=="RU"
replace inc_z=SE_INC_z if country=="SE"
replace inc_z=SI_INC_z if country=="SI"
replace inc_z=US_INC_z if country=="US"


rename v324 ethnic

keep year country sample id weight ///
   jobs hcare old unempl incdif housing ///
   sex age eduyrs educ empstat marital urbrur relgr attend sclass union hhsize inc_per inc_z
   
save "ISSP-select-1996.dta", replace

*** Use ISSP 2006

use "ZA4700.dta", clear

drop if V3a==214 | V3a==528 | V3a==620 | V3a==858

generate country="AU" if V3a==36
replace country="CA" if V3a==124
replace country="CL" if V3a==152
replace country="TW" if V3a==158
replace country="HR" if V3a==191
replace country="CZ" if V3a==203
replace country="DK" if V3a==208
replace country="FI" if V3a==246
replace country="FR" if V3a==250
replace country="DE" if V3a==276
replace country="HU" if V3a==348
replace country="IE" if V3a==372
replace country="IL" if V3a==376
replace country="JP" if V3a==392
replace country="KR" if V3a==410
replace country="LV" if V3a==428
replace country="NZ" if V3a==554
replace country="NO" if V3a==578
replace country="PH" if V3a==608
replace country="PL" if V3a==616
replace country="RU" if V3a==643
replace country="SI" if V3a==705
replace country="ZA" if V3a==710
replace country="ES" if V3a==724
replace country="SE" if V3a==752
replace country="CH" if V3a==756
replace country="GB" if V3a==826
replace country="US" if V3a==840
replace country="VE" if V3a==862

generate sample="AU" if V3a==36
replace sample="CA" if V3a==124
replace sample="CL" if V3a==152
replace sample="TW" if V3a==158
replace sample="HR" if V3a==191
replace sample="CZ" if V3a==203
replace sample="DK" if V3a==208
replace sample="FI" if V3a==246
replace sample="FR" if V3a==250
replace sample="DE-W" if V3a==276.1
replace sample="DE-E" if V3a==276.1
replace sample="HU" if V3a==348
replace sample="IE" if V3a==372
replace sample="IL-J" if V3a==376.1
replace sample="IL-A" if V3a==376.2
replace sample="JP" if V3a==392
replace sample="KR" if V3a==410
replace sample="LV" if V3a==428
replace sample="NZ" if V3a==554
replace sample="NO" if V3a==578
replace sample="PH" if V3a==608
replace sample="PL" if V3a==616
replace sample="RU" if V3a==643
replace sample="SI" if V3a==705
replace sample="ZA" if V3a==710
replace sample="ES" if V3a==724
replace sample="SE" if V3a==752
replace sample="CH" if V3a==756
replace sample="GB" if V3a==826
replace sample="US" if V3a==840
replace sample="VE" if V3a==862

generate year=2006
rename V2 id
rename V25 jobs
rename V27 hcare
rename V28 old
rename V30 unempl
rename V31 incdif
rename V33 housing 


rename educyrs eduyrs
recode eduyrs (95 96=.)(26/94=26)

rename degree educ
recode educ (0=1)(1=2)(2/3=3)(4=4)(5=5)

rename wrkst empstat
recode empstat (1/4=1)(5=2)(7=3)(6 8/10=4)	


rename urbrural urbrur
recode urbrur (1 2=1)(3=2)(4 5=3)

rename religgrp relgr

rename topbot sclass
recode sclass (1/4=1)(5/7=2)(8/10=3)(else=.)

recode union (1=1)(2 3=0)

rename hompop hhsize

foreach var of varlist AU_INC CA_INC CH_INC CL_INC CZ_INC DE_INC DK_INC ES_INC FI_INC FR_INC GB_INC HR_INC HU_INC ///
  IE_INC IL_INC JP_INC KR_INC LV_INC NO_INC NZ_INC PH_INC PL_INC RU_INC SE_INC SI_INC TW_INC US_INC VE_INC ZA_INC{
xtile `var'_per=`var', nq(100)
egen  `var'_z  =std(`var')
}

generate inc_per=AU_INC_per if country=="AU"
replace inc_per=CA_INC_per if country=="CA"
replace inc_per=CH_INC_per if country=="CH"
replace inc_per=CL_INC_per if country=="CL"
replace inc_per=CZ_INC_per if country=="CZ"
replace inc_per=DE_INC_per if country=="DE"
replace inc_per=DK_INC_per if country=="DK"
replace inc_per=ES_INC_per if country=="ES"
replace inc_per=FI_INC_per if country=="FI"
replace inc_per=FR_INC_per if country=="FR"
replace inc_per=GB_INC_per if country=="GB"
replace inc_per=HR_INC_per if country=="HR"
replace inc_per=HU_INC_per if country=="HU"
replace inc_per=IE_INC_per if country=="IE"
replace inc_per=IL_INC_per if country=="IL"
replace inc_per=JP_INC_per if country=="JP"
replace inc_per=KR_INC_per if country=="KR"
replace inc_per=LV_INC_per if country=="LV"
replace inc_per=NO_INC_per if country=="NO"
replace inc_per=NZ_INC_per if country=="NZ"
replace inc_per=PH_INC_per if country=="PH"
replace inc_per=PL_INC_per if country=="PL"
replace inc_per=RU_INC_per if country=="RU"
replace inc_per=SE_INC_per if country=="SE"
replace inc_per=SI_INC_per if country=="SI"
replace inc_per=TW_INC_per if country=="TW"
replace inc_per=US_INC_per if country=="US"
replace inc_per=VE_INC_per if country=="VE"
replace inc_per=ZA_INC_per if country=="ZA"

generate inc_z=AU_INC_z if country=="AU"
replace inc_z=CA_INC_z if country=="CA"
replace inc_z=CH_INC_z if country=="CH"
replace inc_z=CL_INC_z if country=="CL"
replace inc_z=CZ_INC_z if country=="CZ"
replace inc_z=DE_INC_z if country=="DE"
replace inc_z=DK_INC_z if country=="DK"
replace inc_z=ES_INC_z if country=="ES"
replace inc_z=FI_INC_z if country=="FI"
replace inc_z=FR_INC_z if country=="FR"
replace inc_z=GB_INC_z if country=="GB"
replace inc_z=HR_INC_z if country=="HR"
replace inc_z=HU_INC_z if country=="HU"
replace inc_z=IE_INC_z if country=="IE"
replace inc_z=IL_INC_z if country=="IL"
replace inc_z=JP_INC_z if country=="JP"
replace inc_z=KR_INC_z if country=="KR"
replace inc_z=LV_INC_z if country=="LV"
replace inc_z=NO_INC_z if country=="NO"
replace inc_z=NZ_INC_z if country=="NZ"
replace inc_z=PH_INC_z if country=="PH"
replace inc_z=PL_INC_z if country=="PL"
replace inc_z=RU_INC_z if country=="RU"
replace inc_z=SE_INC_z if country=="SE"
replace inc_z=SI_INC_z if country=="SI"
replace inc_z=TW_INC_z if country=="TW"
replace inc_z=US_INC_z if country=="US"
replace inc_z=VE_INC_z if country=="VE"
replace inc_z=ZA_INC_z if country=="ZA"

keep year country sample id weight ///
   jobs hcare old unempl incdif housing ///
   sex age eduyrs educ empstat marital urbrur relgr attend sclass union hhsize inc_per inc_z
   
save "ISSP-select-2006.dta", replace


*** Use ISSP 2016

use "ZA6900_v2-0-0.dta", clear
rename country V3a

drop if V3a==56 | V3a==268 | V3a==352 | V3a==356 | V3a==440 | V3a==703 | V3a==740 | V3a==764 | V3a==792

generate country="AU" if V3a==36
replace country="CL" if V3a==152
replace country="TW" if V3a==158
replace country="HR" if V3a==191
replace country="CZ" if V3a==203
replace country="DK" if V3a==208
replace country="FI" if V3a==246
replace country="FR" if V3a==250
replace country="DE" if V3a==276
replace country="HU" if V3a==348
replace country="IE" if V3a==372
replace country="IL" if V3a==376
replace country="JP" if V3a==392
replace country="KR" if V3a==410
replace country="LV" if V3a==428
replace country="NZ" if V3a==554
replace country="NO" if V3a==578
replace country="PH" if V3a==608
replace country="RU" if V3a==643
replace country="SI" if V3a==705
replace country="ZA" if V3a==710
replace country="ES" if V3a==724
replace country="SE" if V3a==752
replace country="CH" if V3a==756
replace country="GB" if V3a==826
replace country="US" if V3a==840
replace country="VE" if V3a==862

generate sample="AU" if c_sample==36
replace sample="CL" if c_sample==152
replace sample="TW" if c_sample==158
replace sample="HR" if c_sample==191
replace sample="CZ" if c_sample==203
replace sample="DK" if c_sample==208
replace sample="FI" if c_sample==246
replace sample="FR" if c_sample==250
replace sample="DE-W" if c_sample==27601
replace sample="DE-E" if c_sample==27602
replace sample="HU" if c_sample==348
replace sample="IE" if c_sample==372
replace sample="IL-J" if c_sample==37601
replace sample="IL-A" if c_sample==37602
replace sample="JP" if c_sample==392
replace sample="KR" if c_sample==410
replace sample="LV" if c_sample==428
replace sample="NZ" if c_sample==554
replace sample="NO" if c_sample==578
replace sample="PH" if c_sample==608
replace sample="RU" if c_sample==643
replace sample="SI" if c_sample==705
replace sample="ZA" if c_sample==710
replace sample="ES" if c_sample==724
replace sample="SE" if c_sample==752
replace sample="CH" if c_sample==756
replace sample="GB" if c_sample==826
replace sample="US" if c_sample==840
replace sample="VE" if c_sample==862

generate year=2016
rename CASEID id
rename WEIGHT weight
rename v21 jobs
rename v23 hcare
rename v24 old
rename v26 unempl
rename v27 incdif
rename v29 housing 

rename SEX sex
rename AGE age

replace age=DK_AGE if country=="DK"

rename EDUCYRS eduyrs
recode eduyrs (95 96 98 99=.)(26/94=26)

rename DEGREE educ
recode educ (0=1)(1=2)(2/3=3)(4=4)(5/6=5)(9=.)

rename MAINSTAT empstat
recode empstat (1 4=1)(2=2)(6=3)(3 5 7/9=4)(99=.)
rename MARITAL marital
recode marital (1 2=1)(5=2)(4=3)(3=4)(6=5)(7 9=.)

rename URBRURAL urbrur
recode urbrur (1 2=1)(3=2)(4 5=3)(else=.)

rename RELIGGRP relgr
rename ATTEND attend
rename TOPBOT sclass
recode sclass (1/4=1)(5/7=2)(8/10=3)(else=.)


rename UNION union
recode union (1=1)(0 2 3=0)(7/9=.)

rename HOMPOP hhsize
recode hhsize (0 99=.)

recode AU_INC (9999990 9999999=.)
recode CH_INC (999990 999997/max=.)
recode CL_INC (9999990 9999998 9999999=.)
recode CZ_INC (999990 999997/max=.)
recode DE_INC (999990 999999=.)
recode DK_INC (9999990 9999999=.)
recode ES_INC (999990 999998 999999=.)
recode FI_INC (999990 999999=.)
recode FR_INC (999990 999999=.)
recode GB_INC (999990 999997 999999=.)
recode HR_INC (999990 999997/max=.)
recode HU_INC (999990 999997/max=.)
recode IL_INC (999990 999997/max=.)
recode JP_INC (99999990 99999999=.)
recode KR_INC (999999990 999999998=.)
recode LT_INC (999990 999997 999998=.)
recode LV_INC (999990 999997 999998=.)
recode NO_INC (9999990 9999998 9999999=.)
recode NZ_INC (999990 999999=.)
recode PH_INC (999990 999997/max=.)
recode RU_INC (999990 999997 999998=.)
recode SE_INC (999990 999999=.)
recode SI_INC (999990 999997/max=.)
recode TW_INC (9999990 9999997 9999998=.)
recode US_INC (999990 999997 999998=.)
recode VE_INC (9999990 9999999=.)
recode ZA_INC (999990 999997/max=.)

 
foreach var of varlist AU_INC CH_INC CL_INC CZ_INC DE_INC DK_INC ES_INC FI_INC FR_INC GB_INC HR_INC HU_INC ///
  IL_INC JP_INC KR_INC LV_INC NO_INC NZ_INC PH_INC RU_INC SE_INC SI_INC TW_INC US_INC VE_INC ZA_INC{
xtile `var'_per=`var', nq(100)
egen  `var'_z  =std(`var')
}

generate inc_per=AU_INC_per if country=="AU"
replace inc_per=CH_INC_per if country=="CH"
replace inc_per=CL_INC_per if country=="CL"
replace inc_per=CZ_INC_per if country=="CZ"
replace inc_per=DE_INC_per if country=="DE"
replace inc_per=DK_INC_per if country=="DK"
replace inc_per=ES_INC_per if country=="ES"
replace inc_per=FI_INC_per if country=="FI"
replace inc_per=FR_INC_per if country=="FR"
replace inc_per=GB_INC_per if country=="GB"
replace inc_per=HR_INC_per if country=="HR"
replace inc_per=HU_INC_per if country=="HU"
replace inc_per=IL_INC_per if country=="IL"
replace inc_per=JP_INC_per if country=="JP"
replace inc_per=KR_INC_per if country=="KR"
replace inc_per=LV_INC_per if country=="LV"
replace inc_per=NO_INC_per if country=="NO"
replace inc_per=NZ_INC_per if country=="NZ"
replace inc_per=PH_INC_per if country=="PH"
replace inc_per=RU_INC_per if country=="RU"
replace inc_per=SE_INC_per if country=="SE"
replace inc_per=SI_INC_per if country=="SI"
replace inc_per=TW_INC_per if country=="TW"
replace inc_per=US_INC_per if country=="US"
replace inc_per=VE_INC_per if country=="VE"
replace inc_per=ZA_INC_per if country=="ZA"

generate inc_z=AU_INC_z if country=="AU"
replace inc_z=CH_INC_z if country=="CH"
replace inc_z=CL_INC_z if country=="CL"
replace inc_z=CZ_INC_z if country=="CZ"
replace inc_z=DE_INC_z if country=="DE"
replace inc_z=DK_INC_z if country=="DK"
replace inc_z=ES_INC_z if country=="ES"
replace inc_z=FI_INC_z if country=="FI"
replace inc_z=FR_INC_z if country=="FR"
replace inc_z=GB_INC_z if country=="GB"
replace inc_z=HR_INC_z if country=="HR"
replace inc_z=HU_INC_z if country=="HU"
replace inc_z=IL_INC_z if country=="IL"
replace inc_z=JP_INC_z if country=="JP"
replace inc_z=KR_INC_z if country=="KR"
replace inc_z=LV_INC_z if country=="LV"
replace inc_z=NO_INC_z if country=="NO"
replace inc_z=NZ_INC_z if country=="NZ"
replace inc_z=PH_INC_z if country=="PH"
replace inc_z=RU_INC_z if country=="RU"
replace inc_z=SE_INC_z if country=="SE"
replace inc_z=SI_INC_z if country=="SI"
replace inc_z=TW_INC_z if country=="TW"
replace inc_z=US_INC_z if country=="US"
replace inc_z=VE_INC_z if country=="VE"
replace inc_z=ZA_INC_z if country=="ZA"

keep year country sample id weight ///
   jobs hcare old unempl incdif housing ///
   sex age eduyrs educ empstat marital urbrur relgr attend sclass union hhsize inc_per inc_z
   
save "ISSP-select-2016.dta", replace

clear
use "ISSP-select-1985.dta"
append using "ISSP-select-1990.dta"
append using "ISSP-select-1996.dta"
append using "ISSP-select-2006.dta"
append using "ISSP-select-2016.dta"

bysort year: table country, content(mean id mean weight) format(%9.4f)

recode jobs hcare old unempl incdif housing (8/9 = .)

bysort year: table country, content(mean jobs mean hcare mean old) format(%9.4f)
bysort year: table country, content(mean unempl mean incdif mean housing) format(%9.4f)
bysort year: alpha jobs hcare old unempl incdif housing

egen stateresp85=rowmean(jobs hcare old unempl incdif) if year==1985
egen stateresp=rowmean(jobs hcare old unempl incdif housing) if year > 1985
replace stateresp=stateresp85 if year==1985

egen rmis=rowmiss(jobs hcare old unempl incdif housing)

replace stateresp=. if rmis>=3 & year==1985
replace stateresp=. if rmis>=4 & year > 1985

replace stateresp=(-1)*stateresp+5

recode sex (9=.)

gen female=sex
recode female 1=0 2=1
recode female 9=.

recode age (0 99 999=.)

bysort year country: egen m_age=mean(age)
generate c_age=age-m_age
generate age2=c_age*c_age


label var eduyrs "years of education"
bysort year country: egen m_eduyrs=mean(eduyrs)
generate c_eduyrs=eduyrs-m_eduyrs


label define educat 1 "no formal" 2 "lowest" 3 "secondary" 4 "post-secondary" 5 "teriary"	
label values educ educat
label var educ "educational level"

label define empcat 1 "employed" 2 "unemployed" 3 "retired" 4 "other"
label values empstat empcat
label var empstat "employment status"

label var marital "marital status"

label var urbrur "urbanicity"
label define urbcat 1 "large city" 2 "small city/town" 3 "village"
label values urbrur urbcat

label var sclass "social class"
label define classcat 1 "low" 2 "middle" 3 "high"
label values sclass classcat

label define unicat 0 "not member" 1 "member"
label values union unicat
label var union "union membership"

lab var hhsize "household size"

recode hhsize (10/max=10)

bysort year country: egen m_hhsize=mean(hhsize)
generate c_hhsize=hhsize-m_hhsize

label var inc_per "Income in percentiles per country x year"

bysort year country: egen m_inc_per=mean(inc_per)
generate c_inc_per=inc_per-m_inc_per

label var inc_z "Income z-scores per country x year"


* recode religion
gen relden=relgr if year==2016
gen nrelgr2006=relgr if year==2006
recode nrelgr2006 1=0 2=1 3=2 4=3 9=4 10=9 11=10 if year==2006
replace relden= nrelgr2006 if year==2006
gen nrelgr1985=relgr if year==1985
recode nrelgr1985 10=1 20=5 30=6 40=2 41=2 42=2 43=4 44=2 45=4 46=4 47=4 49=2 50=99 51=8 52=7 53=9 54=3 90=10 96=0 if year==1985
replace relden=nrelgr1985 if year==1985
gen nrelgr1990=relgr if year==1990
recode nrelgr1990 10=1 20=5 30=6 40=2 41=2 42=2 43=4 44=2 45=4 46=4 47=4 48=2 49=2 51=8 52=7 53=9 54=3 90=0 91=99 92=10 93=10 if year==1990
replace relden=nrelgr1990 if year==1990
gen relgr1996=relgr if year==1996
recode relgr1996 10=1 11=1 20=5 30=6 31=10 40=2 41=2 42=2 43=4 44=2 45=4 46=4 47=4 48=2 49=2 50=9 51=8 52=7 53=9 54=3 55=4 60=4 61=4 62=4 63=4 64=4 65=4 66=10 ///
90=0 91=99 92=4 93=10 94=10 if year==1996
replace relden=relgr1996 if year==1996

* recode religion short: Christian, Jewish, Mulsim, Budhist, Hindu , and other?
gen denomination=relden
recode denomination 0=0 1=1 2=1 3=1 4=1 5=2 6=3 7=4 8=5 9=6 10=6 97=. 98=. 99=.
lab def denomination 0 "Not religious" 1 "Christian" 2 "Jewish" 3 "Muslim" 4 "Buddhist" 5 "Hindu" 6 "Other"
lab val denomination denomination

* recode attend	
gen nattend1985=attend if year==1985
recode nattend1985 1=6 2=5 3=3 4=2 5=1
gen nattend1990=attend if year==1990
recode nattend1990 1=6 2=5 3=4 4=3 5=2 6=1
gen nattend1996=attend if year==1996
recode nattend1996 1=6 2=5 3=4 4=3 5=2 6=1
gen nattend2006=attend if year==2006
recode nattend2006 1=6 2=6 3=5 4=4 5=3 6=2 7=2 8=1
gen nattend2016=attend if year==2016
recode nattend2016 1=6 2=6 3=5 4=4 5=3 6=2 7=2 8=1 97=. 98=. 99=.
gen nattend=attend if year==1990
replace nattend=nattend1985 if year==1985
replace nattend=nattend1990 if year==1990
replace nattend=nattend1996 if year==1996
replace nattend=nattend2006 if year==2006
replace nattend=nattend2016 if year==2016
lab def nattendl 6 "once a week" 5 "2-3 times a month" 4 "once a month" 3 "several times a year" 2 "once a year" 1 "never"
lab val nattend nattendl

* recode attend short
gen nattend_short=.
replace nattend_short=1 if nattend==1|nattend==2
replace nattend_short=2 if nattend==3|nattend==4
replace nattend_short=3 if nattend==5|nattend==6
tab nattend nattend_short,m

save "ISSP-integrated-select.dta", replace
import delim "cri_macro.csv", rowrange(1:1749) varn (1) numericc(1 3/20) clear
sum _all

* generate country variable to match with micro data file
ren country cntry
tab cntry,m

gen country="AR" if cntry=="Argentina"
replace country="AU" if cntry=="Australia"
replace country="AT" if cntry=="Austria"
replace country="BE" if cntry=="Belgium"
replace country="BR" if cntry=="Brazil"
replace country="BG" if cntry=="Bulgaria"
replace country="CA" if cntry=="Canada"
replace country="CL" if cntry=="Chile"
replace country="CN" if cntry=="China"
replace country="CO" if cntry=="Colombia"
replace country="HR" if cntry=="Croatia"
replace country="CY" if cntry=="Cyprus"
replace country="CZ" if cntry=="Czechia"
replace country="DK" if cntry=="Denmark"
replace country="EE" if cntry=="Estonia"
replace country="FI" if cntry=="Finland"
replace country="FR" if cntry=="France"
replace country="DE" if cntry=="Germany"
replace country="GR" if cntry=="Greece"
replace country="HU" if cntry=="Hungary"
replace country="IS" if cntry=="Iceland"
replace country="IN" if cntry=="India"
replace country="IE" if cntry=="Ireland"
replace country="IL" if cntry=="Israel"
replace country="IT" if cntry=="Italy"
replace country="JP" if cntry=="Japan"
replace country="KR" if cntry=="Korea, South"
replace country="LV" if cntry=="Latvia"
replace country="LT" if cntry=="Lithuania"
replace country="MX" if cntry=="Mexico"
replace country="NZ" if cntry=="New Zealand"
replace country="NO" if cntry=="Norway"
replace country="PL" if cntry=="Poland"
replace country="PT" if cntry=="Portugal"
replace country="RU" if cntry=="Russia"
replace country="SK" if cntry=="Slovakia"
replace country="SI" if cntry=="Slovenia"
replace country="ZA" if cntry=="South Africa"
replace country="ES" if cntry=="Spain"
replace country="SE" if cntry=="Sweden"
replace country="CH" if cntry=="Switzerland"
replace country="TW" if cntry=="Taiwan"
replace country="NL" if cntry=="The Netherlands"
replace country="TW" if cntry=="Taiwan"
replace country="TR" if cntry=="Turkey"
replace country="GB" if cntry=="United Kingdom"
replace country="US" if cntry=="United States"

gen L_year=year+1

replace year=year+1
list year L_year
drop L_year

save "Macrodata extention NEW.dta", replace

use "ISSP-integrated-select.dta" , clear
sort country year
save "ISSP-integrated-select.dta" , replace

use "Macrodata extention NEW.dta" , clear
sort country year
save "Macrodata extention NEW.dta", replace

use "ISSP-integrated-select.dta" , clear
merge m:1 country year using "Macrodata extention NEW.dta"
*bysort _merge: tab country year, m

keep if _merge==3
drop _merge

egen ncy = group(country year)

save "workingdataII NEW.dta", replace

sort country year
by country year: generate n1 = _n

keep if n1==1
keep country year gdp_oecd - ncy

* create country means and country-years differences from country means

by country: egen c_mean_stock=mean(migstock_un)
replace c_mean_stock=. if migstock_un==.
gen cy_diff_stock=migstock_un-c_mean_stock
list country migstock_un c_mean_stock cy_diff_stock

*PI adjustment
replace mignet_un=mignet_un/10
//

by country: egen c_mean_net=mean(mignet_un)
replace c_mean_net=. if mignet_un==.
gen cy_diff_net=mignet_un-c_mean_net
list country mignet_un c_mean_net cy_diff_net

by country: egen c_mean_emp=mean(wdi_empprilo)
replace c_mean_emp=. if wdi_empprilo==.
gen cy_diff_emp=wdi_empprilo-c_mean_emp
list country wdi_empprilo c_mean_emp cy_diff_emp

by country: egen c_mean_unemp=mean(wdi_unempilo)
replace c_mean_unemp=. if wdi_unempilo==.
gen cy_diff_unemp=wdi_unempilo-c_mean_unemp
list country wdi_unempilo c_mean_unemp cy_diff_unemp

by country: egen c_mean_gdp=mean(gdp_wb)
replace c_mean_gdp=. if gdp_wb==.
gen cy_diff_gdp=gdp_wb-c_mean_gdp
list country gdp_wb c_mean_gdp cy_diff_gdp

keep country year c_mean_stock cy_diff_stock c_mean_net cy_diff_net c_mean_emp cy_diff_emp c_mean_unemp cy_diff_unemp c_mean_gdp cy_diff_gdp

save "Macrodata additions.dta", replace

use "workingdataII NEW.dta" , clear
merge m:1 country year using "Macrodata additions.dta"
bysort _merge: tab country year, m


egen miss1=rowmiss(stateresp female c_age age2 empstat union marital c_hhsize educ c_eduyrs c_inc_per urbrur denomination nattend sclass mignet_un migstock_un wdi_unempilo)
mark sample_miss1 if miss1==0

* Descriptives level 2
sort country year
by country year: generate n1 = _n

*PI adjust within-effect by average wave length
replace cy_diff_stock = cy_diff_stock/7.75

qui xtmixed stateresp i.female c_age age2 i.empstat i.union i.marital c_hhsize ib5.educ c_eduyrs c_inc_per ib1.urbrur ib1.denomination nattend i.sclass c_mean_stock cy_diff_stock  || _all: R.year || country:|| ncy:, var
margins,dydx(c_mean_stock) saving ("t34m1",replace)
margins,dydx(cy_diff_stock) saving ("t34m2",replace)
* migstock_un and Employment rate
qui xtmixed stateresp i.female c_age age2 i.empstat i.union i.marital c_hhsize ib5.educ c_eduyrs c_inc_per ib1.urbrur ib1.denomination nattend i.sclass c_mean_stock cy_diff_stock c_mean_emp cy_diff_emp || _all: R.year || country:|| ncy:, var
margins,dydx(c_mean_stock) saving ("t34m3",replace)
margins,dydx(cy_diff_stock) saving ("t34m4",replace)
* only mignet_un
qui xtmixed stateresp i.female c_age age2 i.empstat i.union i.marital c_hhsize ib5.educ c_eduyrs c_inc_per ib1.urbrur ib1.denomination nattend i.sclass c_mean_net cy_diff_net  || _all: R.year || country:|| ncy:, var
margins,dydx(c_mean_net) saving ("t34m5",replace)
margins,dydx(cy_diff_net) saving ("t34m6",replace)
* mignet:un and Employment rate
qui xtmixed stateresp i.female c_age age2 i.empstat i.union i.marital c_hhsize ib5.educ c_eduyrs c_inc_per ib1.urbrur ib1.denomination nattend i.sclass c_mean_net cy_diff_net c_mean_emp cy_diff_emp || _all: R.year || country:|| ncy:, var
margins,dydx(c_mean_net) saving ("t34m7",replace)
margins,dydx(cy_diff_net) saving ("t34m8",replace)
* migstock_un and  mignet_un
qui xtmixed stateresp i.female c_age age2 i.empstat i.union i.marital c_hhsize ib5.educ c_eduyrs c_inc_per ib1.urbrur ib1.denomination nattend i.sclass c_mean_stock cy_diff_stock c_mean_net cy_diff_net || _all: R.year || country:|| ncy:, var
tab cntry year if e(sample)==1
margins,dydx(c_mean_stock) saving ("t34m9",replace)
margins,dydx(c_mean_net) saving ("t34m10",replace)
margins,dydx(cy_diff_stock) saving ("t34m11",replace)
margins,dydx(cy_diff_net) saving ("t34m12",replace)


* migstock_un and mignet_un with Employment rate
qui xtmixed stateresp i.female c_age age2 i.empstat i.union i.marital c_hhsize ib5.educ c_eduyrs c_inc_per ib1.urbrur ib1.denomination nattend i.sclass c_mean_stock cy_diff_stock c_mean_net cy_diff_net c_mean_emp cy_diff_emp || _all: R.year || country:|| ncy:, var
tab country year if e(sample)==1
margins,dydx(c_mean_stock) saving ("t34m13",replace)
margins,dydx(c_mean_net) saving ("t34m14",replace)
margins,dydx(cy_diff_stock) saving ("t34m15",replace)
margins,dydx(cy_diff_net) saving ("t34m16",replace)

use t34m1,clear
foreach x of numlist 2/16 {
append using t34m`x'
}
gen f = [_n]
gen factor = "Immigrant Stock, between" 
replace factor = "Immigrant Stock, within" if f==2|f==4|f==11|f==15
replace factor = "Immigrant Flow, between" if f==5|f==7|f==10|f==14
replace factor = "Immigrant Flow, within" if f==6|f==8|f==12|f==16

clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
gen id = "t34m1"
foreach x of numlist 2/16 {
replace id = "t34m`x'" if f==`x'
}
order factor AME lower upper id
keep factor AME lower upper id
save team34, replace

foreach x of numlist 1985 1990 1996 2006 2016 {
erase ISSP-select-`x'.dta
}

erase ISSP-integrated-select.dta
erase "Macrodata extention NEW.dta"
erase "workingdataII NEW.dta"
erase "Macrodata additions.dta"
erase ISSP-select-1985.dta
erase ISSP-select-1990.dta
erase ISSP-select-1996.dta
erase ISSP-select-2006.dta
erase ISSP-select-2016.dta

foreach x of numlist 1/16{
erase t34m`x'.dta
}

}
*==============================================================================*
*==============================================================================*
*==============================================================================*



































// TEAM 36
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team36.dta"
  if _rc==0  {
    display "Team 36 already exists, skipping to next code chunk"
  }
  else {
version 14.0
set more off
 
use ZA2900.dta , clear
gen year = 1996

*** Outcome variables
* Jobs / jobs for all
recode v36 (8 9=.)(1 2=1)(3 4 =0), gen(outc_jobs)

* Unemployment / unemployed
recode v41 (8 9=.)(1 2=1)(3 4 =0), gen(outc_unemp)

* Reduce Income Differences / income differences
recode v42 (8 9=.)(1 2=1)(3 4 =0), gen(outc_income)

* Old Age Care / elderly
recode v39 (8 9=.)(1 2=1)(3 4 =0), gen(outc_retire)

* Housing
recode v44 (8 9=.)(1 2=1)(3 4 =0), gen(outc_housing)

* Healthcare
recode v38 (8 9=.)(1 2=1)(3 4 =0), gen(outc_health)


*** Individual-level control variables
recode v200 (2=1)(1=0), gen(female)
rename v201 age
gen age_sq = age * age

recode v205 (1/4=0)(5 6=1)(7=2), gen(education)
lab def education 0 "Primary or less" 1 "Secondary" 2 "University"
lab values education education

recode v206 (1/4=1)(5/10=0), gen(employ)

*** Harmonize country code
gen cntry =.
	replace cntry = 36  if v3 == 1	/* Australia 36 */	
	replace cntry = 276 if v3 == 2 	/* West Germany */	
	replace cntry = 276 if v3 == 3 	/* East Germany */	
	replace cntry = 124 if v3 == 20	/* Canada 124 */
	replace cntry = 250	if v3 == 27	/* France */
	replace cntry = 372	if v3 == 10	/* Ireland */
	replace cntry = 392	if v3 == 24	/* Japan */
	replace cntry = 554	if v3 == 19	/* New Zealand */
	replace cntry = 578	if v3 == 12	/* Norway */
	replace cntry = 724	if v3 == 25	/* Spain */
	replace cntry = 752	if v3 == 13	/* Sweden */
	replace cntry = 756	if v3 == 30	/* Switzerland */
	replace cntry = 826	if v3 == 4	/* UK */
	replace cntry = 840	if v3 == 6	/* US */
drop if cntry==.					/* keep the relevant 13 countries */

keep year cntry female age age_sq education employ outc_jobs outc_unemp outc_income outc_retire outc_health outc_housing	
save ISSP_1996.dta , replace
	

**********************************	
* 2. Prepare ISSP-2006 for merging
use ZA4700.dta , clear
gen year = 2006

*** Outcome variables

* Jobs / jobs for all
recode V25 (8 9=.)(1 2=1)(3 4 =0), gen(outc_jobs)

* Unemployment / unemployed
recode V30 (8 9=.)(1 2=1)(3 4 =0), gen(outc_unemp)

* Reduce Income Differences / income differences
recode V31 (8 9=.)(1 2=1)(3 4 =0), gen(outc_income)

* Old Age Care / elderly
recode V28 (8 9=.)(1 2=1)(3 4 =0), gen(outc_retire)

* Housing
recode V33 (8 9=.)(1 2=1)(3 4 =0), gen(outc_housing)

* Healthcare
recode V27 (8 9=.)(1 2=1)(3 4 =0), gen(outc_health)



*** Individual-level control variables
recode sex (2=1)(1=0), gen(female)
gen age_sq = age * age

recode degree (0 1 2=0)(3 4=1)(5=2), gen(education)
lab def education 0 "Primary or less" 1 "Secondary" 2 "University"
lab values education education

recode wrkst (1/4=1)(5/10=0), gen(employ)

*** Harmonize country code
rename V3 cntry
replace cntry=276 if cntry==276.1
replace cntry=276 if cntry==276.2
replace cntry=376 if cntry==376.1
replace cntry=376 if cntry==376.2
replace cntry=826 if cntry==826.1

keep if ///
	cntry == 36  | ///
	cntry == 276 | ///
	cntry == 124 | ///
	cntry == 250 | ///
	cntry == 372 | ///
	cntry == 392 | ///
	cntry == 554 | ///
	cntry == 578 | ///
	cntry == 724 | ///
	cntry == 752 | ///
	cntry == 756 | ///
	cntry == 826 | ///
	cntry == 840

keep year cntry female age age_sq education employ outc_jobs outc_unemp outc_income outc_retire outc_health outc_housing	
save ISSP_2006.dta , replace



**********************************	
* 3. Prepare ISSP-2016 for merging
use ZA6900_v2-0-0.dta , clear
gen year = 2016


*** Outcome variables

* Jobs / jobs for all
recode v21 (8 9=.)(1 2=1)(3 4 =0), gen(outc_jobs)

* Unemployment / unemployed
recode v26 (8 9=.)(1 2=1)(3 4 =0), gen(outc_unemp)

* Reduce Income Differences / income differences
recode v27 (8 9=.)(1 2=1)(3 4 =0), gen(outc_income)

* Old Age Care / elderly
recode v24 (8 9=.)(1 2=1)(3 4 =0), gen(outc_retire)

* Housing
recode v29 (8 9=.)(1 2=1)(3 4 =0), gen(outc_housing)

* Healthcare
recode v23 (8 9=.)(1 2=1)(3 4 =0), gen(outc_health)


*** Individual-level control variables
recode SEX (9=.)(2=1)(1=0), gen(female)
recode AGE (0 999=.)(97/99=97), gen(age)
gen age_sq = age * age

recode DEGREE (9=.)(0 1=0)(2 3 4=1)(5 6=2), gen(education)
lab def education 0 "Primary or less" 1 "Secondary" 2 "University"
lab values education education

recode WORK (9=.)(1=1)(2 3=0), gen(employ)


*** Harmonize country code
rename country cntry
keep if ///
	cntry == 36  | ///
	cntry == 276 | ///
	cntry == 124 | ///
	cntry == 250 | ///
	cntry == 372 | ///
	cntry == 392 | ///
	cntry == 554 | ///
	cntry == 578 | ///
	cntry == 724 | ///
	cntry == 752 | ///
	cntry == 756 | ///
	cntry == 826 | ///
	cntry == 840

keep year cntry female age age_sq education employ outc_jobs outc_unemp outc_income outc_retire outc_health outc_housing	
append using ISSP_1996.dta
append using ISSP_2006.dta, nolab
save ISSP.dta , replace


***************************************
* 4. Merge country-level data with ISSP
/*
COUNTRY LEVEL VARIABLES
Immigrant Stock 			: migstock_oecd
Unemployment Rate			: wdi_unempilo
GDP							: gdp_oecd
*/

import excel "cri_macro.xlsx", sheet("cri_macro") firstrow clear

rename iso_country cntry
keep if ///
	cntry == 36  | ///
	cntry == 276 | ///
	cntry == 124 | ///
	cntry == 250 | ///
	cntry == 372 | ///
	cntry == 392 | ///
	cntry == 554 | ///
	cntry == 578 | ///
	cntry == 724 | ///
	cntry == 752 | ///
	cntry == 756 | ///
	cntry == 826 | ///
	cntry == 840

keep if year==1996 | year==2006 | year==2016
destring gdp_oecd migstock_un wdi_unempilo, replace	
keep cntry year gdp_oecd migstock_un wdi_unempilo
* Indvar: migstock_oecd (percent)


* Keep only country-years with complete data
egen miss = rowmiss(gdp_oecd migstock_un wdi_unempilo)
keep if miss==0
drop miss
rename gdp_oecd gdp
rename migstock_un foreignpct
rename wdi_unempilo unemplpct

merge 1:m cntry year using ISSP.dta
lab def cntry ///
	36 "Australia" ///
	276 "Germany" ///	
	124 "Canada" ///
	250	"France" ///
	372	"Ireland" ///
	392	"Japan" ///
	554	"New Zealand" ///
	578	"Norway" ///
	724	"Spain" ///
	752	"Sweden" ///
	756	"Switzerland" ///
	826	"UK" ///
	840	"US"
lab val cntry cntry

	assert _merge!=2	/* all ISSP obs should have received country-level data */
	drop if _merge==1	/* countries not in ISSP */
	sort cntry year
	
bysort year: summarize year cntry female age age_sq education employ outc_jobs outc_unemp outc_income outc_retire outc_health outc_housing unemplpct gdp foreignpct 

* Identifier for year-cntry cells
gen year_str = string(year)
	format year_str %4s
gen cntry_str = string(cntry)
	format cntry_str %3s
egen str cntry_year = concat(year_str cntry_str)
destring cntry_year, replace

/*____________________________________________________________________________*/
** ESTIMATION

*** Define Sample
* I assume original study used listwise deletion
egen miss = rowmiss (year cntry female age age_sq education employ outc_jobs outc_unemp outc_income outc_retire outc_health outc_housing unemplpct gdp foreignpct)	
keep if miss==0

global indctrls = "i.female i.female#i.cntry c.age c.age#i.cntry c.age_sq c.age_sq#i.cntry i.education i.education#i.cntry i.employ i.employ#i.cntry"
global twowayfe = "i.year i.cntry"



*** Marginal effect of one percentage point increase in migrant stock ***



qui logit outc_jobs c.foreignpct $indctrls $twowayfe , or vce(cluster cntry_year)
margins, dydx(c.foreignpct) saving("t36m1",replace)

qui logit outc_unemp c.foreignpct $indctrls $twowayfe , or vce(cluster cntry_year)
margins, dydx(c.foreignpct) saving("t36m2",replace)
		
qui logit outc_income c.foreignpct $indctrls $twowayfe , or vce(cluster cntry_year)
margins, dydx(c.foreignpct) saving("t36m3",replace)
		
qui logit outc_retire c.foreignpct $indctrls $twowayfe , or vce(cluster cntry_year)
margins, dydx(c.foreignpct) saving("t36m4",replace)
	
qui logit outc_housing c.foreignpct $indctrls $twowayfe , or vce(cluster cntry_year)
margins, dydx(c.foreignpct) saving("t36m5",replace)
		
qui logit outc_health c.foreignpct $indctrls $twowayfe , or vce(cluster cntry_year)
margins, dydx(c.foreignpct) saving("t36m6",replace)

use t36m1,clear
foreach x of numlist 2/6{
append using t36m`x'
}

gen factor = "Immigrant Stock"
clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
gen f = [_n]
gen id = "t36m1"
foreach i of numlist 2/6{
replace id = "t36m`i'" if `i' == f
}
order factor AME lower upper id
keep factor AME lower upper id
save team36, replace
		

/*____________________________________________________________________________*/
** CLEAN UP	
erase ISSP_1996.dta
erase ISSP_2006.dta
erase ISSP.dta	
foreach x of numlist 1/6{
erase t36m`x'.dta
}
clear

}
*==============================================================================*
*==============================================================================*
*==============================================================================*































// TEAM 37
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team37.dta"
  if _rc==0  {
    display "Team 37 already exists, skipping to next code chunk"
  }
  else {
version 15
  use "ZA4747.dta", clear

generate cntry = V5
generate year = V4

recode cntry (276.1/276.2 = 276)
recode cntry (826.1 = 826)

label define cntrylbl 36 "Australia" 124 "Canada" 203 "Czech Republic" 208 "Denmark" 246 "Finland" 250 "France" 276 "Germany" 348 "Hungary" 372 "Ireland" 380 "Italy" 392 "Japan" 528 "Netherlands" 554 "New Zealand" 578 "Norway" 620 "Portugal" 616 "Poland" 724 "Spain" 752 "Sweden" 756 "Switzerland" 826 "Great Britain" 840 "United States" 
label values cntry cntrylbl

drop if cntry == 376.1 | cntry == 376.2 | cntry == 428 | cntry == 608 | cntry == 643 | cntry == 705
drop if V6 == 376
drop if cntry==348 & year==1990

***Dependent variables 
recode V50 (1=4) (2=3) (3=2) (4=1), gen(jobs) 
recode V52 (1=4) (2=3) (3=2) (4=1), gen(hcare)
recode V53 (1=4) (2=3) (3=2) (4=1), gen(retire)
recode V55 (1=4) (2=3) (3=2) (4=1), gen(unemp)
recode V56 (1=4) (2=3) (3=2) (4=1), gen(incdiff) 
recode V58 (1=4) (2=3) (3=2) (4=1), gen(housing) 

egen welfare = rowmean(jobs hcare retire unemp incdiff housing)

*PI remvoed this to make it comprable
// generate welfare10 = welfare*2.5

***Independent variables
**Age, age squared
gen agesq = age*age
**Sex
recode sex (1=0) (2=1), generate(female)
**Education levels and dummies
recode degree (0/2=1) (3/4=2) (5=3), generate(edcat)
tab edcat, gen(edcat_)
**Labor market status
*Full-time employment, Part-time employment, Unemployed, or Not in the labor force
recode wrkst (1=1) (12=1) (2/3=2) (5=3) (11=3) (4=4) (6/10=4), generate(lmstatus)
**Worktype
recode wrktype (3=1) (1/2=2) (4=3) (6=4) (*=4), generate(worktype)

save "ZA4747_sample.dta", replace

***Getting income from supplemental file
use "ZA4748.dta"

*Define sample
generate cntry = V5

recode cntry (276.1/276.2 = 276)
recode cntry (826.1 = 826)

label define cntrylbl 36 "Australia" 124 "Canada" 203 "Czech Republic" 208 "Denmark" 246 "Finland" 250 "France" 276 "Germany" 348 "Hungary" 372 "Ireland" 380 "Italy" 392 "Japan" 528 "Netherlands" 554 "New Zealand" 578 "Norway" 620 "Portugal" 616 "Poland" 724 "Spain" 752 "Sweden" 756 "Switzerland" 826 "Great Britain" 840 "United States" 
label values cntry cntrylbl

drop if cntry == 376.1 | cntry == 376.2 | cntry == 428 | cntry == 608 | cntry == 643 | cntry == 705
drop if V6 == 376

*Create year variables 
generate year=V4

*West German 1985 is just repsondents' income. Family income not available
generate faminc = .

replace faminc = AU_INC85 if AU_INC85 !=.a 
replace faminc = AU_INC90 if AU_INC90 !=.a 
replace faminc = AU_INC96 if AU_INC96 !=.a 
replace faminc = AU_INC06 if AU_INC06 !=.a 
replace faminc = CA_INC96 if CA_INC96 !=.a
replace faminc = CA_INC06 if CA_INC06 !=.a
replace faminc = CH_INC96 if CH_INC96 !=.a
replace faminc = CH_INC06 if CH_INC06 !=.a
replace faminc = CZ_INC96 if CZ_INC96 !=.a
replace faminc = CZ_INC06 if CZ_INC06 !=.a
replace faminc = DE_RIN85 if DE_RIN85 !=.a
replace faminc = DE_INC90 if DE_INC90 !=.a
replace faminc = DE_INC96 if DE_INC96 !=.a
replace faminc = DE_INC06 if DE_INC06 !=.a
replace faminc = ES_INC96 if ES_INC96 !=.a 
replace faminc = ES_INC06 if ES_INC06 !=.a 
replace faminc = FR_INC96 if FR_INC96 !=.a 
replace faminc = FR_INC06 if FR_INC06 !=.a 
replace faminc = GB_INC85 if GB_INC85 !=.a 
replace faminc = GB_INC90 if GB_INC90 !=.a 
replace faminc = GB_INC96 if GB_INC96 !=.a 
replace faminc = GB_INC06 if GB_INC06 !=.a 
replace faminc = HU_INC96 if HU_INC96 !=.a 
replace faminc = HU_INC06 if HU_INC06 !=.a 
replace faminc = IE_INC90 if IE_INC90 !=.a 
replace faminc = IE_INC96 if IE_INC96 !=.a 
replace faminc = IE_INC06 if IE_INC06 !=.a  
replace faminc = IT_INC85 if IT_INC85 !=.a 
replace faminc = IT_INC90 if IT_INC90 !=.a 
replace faminc = IT_INC96 if IT_INC96 !=.a 
replace faminc = JP_INC96 if JP_INC96 !=.a 
replace faminc = JP_INC06 if JP_INC06 !=.a 
replace faminc = NO_INC90 if NO_INC90 !=.a 
replace faminc = NO_INC96 if NO_INC96 !=.a 
replace faminc = NO_INC06 if NO_INC06 !=.a 
replace faminc = NZ_INC96 if NZ_INC96 !=.a 
replace faminc = NZ_INC06 if NZ_INC06 !=.a 
replace faminc = PL_INC96 if PL_INC96 !=.a 
replace faminc = PL_INC06 if PL_INC06 !=.a  
replace faminc = SE_INC96 if SE_INC96 !=.a 
replace faminc = SE_INC06 if SE_INC06 !=.a  
replace faminc = US_INC85 if US_INC85 !=.a 
replace faminc = US_INC90 if US_INC90 !=.a 
replace faminc = US_INC96 if US_INC96 !=.a 
replace faminc = US_INC06 if US_INC06 !=.a 

**Standardized income
egen mean_income = mean(faminc), by(cntry year)
egen sd_income = sd(faminc), by(cntry year)
gen zinc = (faminc - mean_income)/sd_income

save "ZA4748_sample.dta", replace

***Merge
use "ZA4747_sample.dta"
merge m:1 V3 cntry year using "ZA4748_sample.dta"
drop _merge

save "ZA4747_sample.dta", replace

******************************************************************************************************

***** PREPARE ISSP 2006 DENMARK AND FINLAND  *****

******************************************************************************************************
clear

**ISSP 2006 file DENMARK
use "ZA4700.dta"
*Drop all countries but DK
keep if V3a==208
*Create year variables
gen year=2006
*Create country identifier
rename V3a cntry
save "ZA4700_DK.dta",replace
 
****Recoding
***Dependent variables
recode V25 (1=4) (2=3) (3=2) (4=1), gen(jobs)
recode V27 (1=4) (2=3) (3=2) (4=1), gen(hcare)
recode V28 (1=4) (2=3) (3=2) (4=1), gen(retire)
recode V30 (1=4) (2=3) (3=2) (4=1), gen(unemp)
recode V31 (1=4) (2=3) (3=2) (4=1), gen(incdiff)
recode V33 (1=4) (2=3) (3=2) (4=1), gen(housing)

egen welfare = rowmean(jobs hcare retire unemp incdiff housing)

*generate welfare10 = welfare*2.5
 
***Independent variables
**Age, age squared
gen agesq = age*age
**Sex
recode sex (1=0) (2=1), generate(female)
**Education levels and dummies. *Check! Is this in line with the cumulative file?
recode degree (0/2=1) (3/4=2) (5=3), generate(edcat)
tab edcat, gen(edcat_)
**Labor market status
*Full-time employment, Part-time employment, Unemployed, or Not in the labor force *Check! Is this in line with the cumulative file?
recode wrkst (1=1) (2/3=2) (5=3) (4=4) (6/10=4), generate(lmstatus)
*label define lmstatus_l 1 "Full-time" 2 "Part-time" 3 "Unemployed" 4 "Not in labor force"
*label lmstatus lmstatus_l
*Worktype
recode wrktype (1/2=1) (3=2) (4=3) (5=4) (*=4), generate(worktype)
**Standardized income
generate faminc = .
replace faminc = DK_INC if DK_INC!=.
egen mean_income = mean(faminc), by(cntry)
egen sd_income = sd(faminc), by(cntry)
gen zinc = (faminc - mean_income)/sd_income
 
**Save file
save "ZA4700_DK.dta", replace
 
**ISSP 2006 file FINLAND
use "ZA4700.dta",clear
*Drop all countries but Fi
keep if V3a==246
*Create year variables
gen year=2006
*Create country identifier
rename V3a cntry
save "ZA4700_FI.dta", replace
 
****Recoding
***Dependent variables
recode V25 (1=4) (2=3) (3=2) (4=1), gen(jobs)
recode V27 (1=4) (2=3) (3=2) (4=1), gen(hcare)
recode V28 (1=4) (2=3) (3=2) (4=1), gen(retire)
recode V30 (1=4) (2=3) (3=2) (4=1), gen(unemp)
recode V31 (1=4) (2=3) (3=2) (4=1), gen(incdiff)
recode V33 (1=4) (2=3) (3=2) (4=1), gen(housing)

egen welfare = rowmean(jobs hcare retire unemp incdiff housing)

*generate welfare10 = welfare*2.5 
 
***Independent variables
**Age, age squared
gen agesq = age*age
**Sex
recode sex (1=0) (2=1), generate(female)
**Education levels and dummies. *Check! Is this in line with the cumulative file?
recode degree (0/2=1) (3/4=2) (5=3), generate(edcat)
tab edcat, gen(edcat_)
**Labor market status
*Full-time employment, Part-time employment, Unemployed, or Not in the labor force *Check! Is this in line with the cumulative file?
recode wrkst (1=1) (2/3=2) (5=3) (4=4) (6/10=4), generate(lmstatus)
*label define lmstatus_l 1 "Full-time" 2 "Part-time" 3 "Unemployed" 4 "Not in labor force"
*label lmstatus lmstatus_l
*Worktype
recode wrktype (1/2=1) (3=2) (4=3) (5=4) (*=4), generate(worktype)
**Standardized income
generate faminc = .
replace faminc = FI_INC if FI_INC!=.
egen mean_income = mean(faminc), by(cntry)
egen sd_income = sd(faminc), by(cntry)
gen zinc = (faminc - mean_income)/sd_income
 
**Save file
save "ZA4700_FI.dta", replace

******************************************************************************************************

***** PREPARE ISSP 2016  *****

******************************************************************************************************


****Recoding 2016***

use "ZA6900_v2-0-0.dta"
*Create country identifier
rename country cntry
label define cntrylbl 36 "Australia" 203 "Czech Republic" 208 "Denmark" 246 "Finland" 250 "France" 276 "Germany" 348 "Hungary" 392 "Japan" 554 "New Zealand" 578 "Norway" 724 "Spain" 752 "Sweden" 756 "Switzerland" 826 "Great Britain" 840 "United States" 
label values cntry cntrylbl
*Drop cases from countries not in our analysis
keep if cntry==36 | cntry==203 | cntry==208 | cntry==246 | cntry==250 | cntry==276 | cntry==348| cntry==392 | cntry==554 | cntry==578 | cntry==724 | cntry==752 | cntry==756 | cntry==826 | cntry==840

*Create year variable 
generate year=2016

save "ZA6900_v2-0-0_sample.dta", replace

***Dependent variables 
recode v21 (1=4) (2=3) (3=2) (4=1) (8/9=.), gen(jobs) 
recode v23 (1=4) (2=3) (3=2) (4=1) (8/9=.), gen(hcare) 
recode v24 (1=4) (2=3) (3=2) (4=1) (8/9=.), gen(retire) 
recode v26 (1=4) (2=3) (3=2) (4=1) (8/9=.), gen(unemp)
recode v27 (1=4) (2=3) (3=2) (4=1) (8/9=.), gen(incdiff) 
recode v29 (1=4) (2=3) (3=2) (4=1) (8/9=.), gen(housing) 

egen welfare = rowmean(jobs hcare retire unemp incdiff housing)

*generate welfare10 = welfare*2.5


***Independent variables

**Age, age squared. 
generate age_r = .
replace age_r = AGE if DK_AGE==0
replace age_r = DK_AGE if DK_AGE!=0 
replace age_r = . if AGE==999

rename age_r age

gen agesq = age*age

**Sex
recode SEX (1=0)(2=1)(9=.), generate(female)
tab female

**Education levels and dummies.
recode DEGREE (0/2=1) (3/4=2) (5/6=3)(9=.), generate(edcat)
tab edcat, gen(edcat_)

**Labor market status
*Full-time employment, Part-time employment, Unemployed, or Not in the labor force
*Main status + WRKHRS >35 hours= fulltime. 
tab MAINSTAT
recode MAINSTAT (1=1)(2=3)(3=4)(4=4)(5=4)(6=4)(7=4)(8=4)(9=4)(99=.), generate(MAINSTAT_r)
generate wrkhrs_r = .
replace wrkhrs_r=1 if WRKHRS<35
replace wrkhrs_r=2 if WRKHRS>34 & WRKHRS<98
tab wrkhrs_r

generate lmstatus= MAINSTAT_r
replace lmstatus=2 if MAINSTAT==1 & wrkhrs_r ==1
*label define lmstatus_1 1 "Full-time" 2 "Part-time" 3 "Unemployed" 4 "Not in labor force"
*label lmstatus lmstatus_l

**Worktype * Must be discussed EMPREL TYPORG2 can separate between self-employed, welfare org, public and private. What is 4? not in the labour force? And did we just ignore 6?

tab EMPREL
recode EMPREL (0=4)(1=1)(2/3=3)(4=1)(9=4), generate(EMPREL_r)
tab EMPREL_r

tab TYPORG2
generate worktype = EMPREL_r
replace worktype = 2 if TYPORG2==1 & EMPREL_r==1
replace worktype = 4 if TYPORG2==8 & EMPREL_r==1
replace worktype = 4 if TYPORG2==9 & EMPREL_r==1
tab worktype
* implies worktype 4 includes those who do not work, those who work for non-profit organisations, those who do not know if employer is public or private, an those who did not answer the question about public/private. Reasonable? 

tab worktype TYPORG2

**Standardized income


generate faminc = .
replace faminc = AU_INC if AU_INC!=. & AU_INC!=9999990 & AU_INC!=9999999
replace faminc = CH_INC if CH_INC!=. & CH_INC!=999990 & CH_INC!=999997 & CH_INC!=999998 & CH_INC!=999999
replace faminc = CZ_INC if CZ_INC!=. & CZ_INC!=999990 & CZ_INC!=999997 & CZ_INC!=999998 & CZ_INC!=999999
replace faminc = DE_INC if DE_INC!=. & DE_INC!=999990 & DE_INC!=999999
replace faminc = DK_INC if DK_INC!=. & DK_INC!=9999990 & DK_INC!=9999999
replace faminc = ES_INC if ES_INC!=. & ES_INC!=999990 & ES_INC!=999998 & ES_INC!=999999
replace faminc = HU_INC if HU_INC!=. & HU_INC!=999990 & HU_INC!=999997 & HU_INC!=999998 & HU_INC!=999999
replace faminc = FI_INC if FI_INC!=. & FI_INC!=999990 & FI_INC!=999999
replace faminc = FR_INC if FR_INC!=. & FR_INC!=999990 & FR_INC!=999999
replace faminc = GB_INC if GB_INC!=. & GB_INC!=999990 & GB_INC!=999997 & GB_INC!=999999
replace faminc = JP_INC if JP_INC!=. & JP_INC!=99999990 & JP_INC!=99999999
replace faminc = NO_INC if NO_INC!=. & NO_INC!=9999990 & NO_INC!=9999998 & NO_INC!=9999999
replace faminc = NZ_INC if NZ_INC!=. & NZ_INC!=999990 & NZ_INC!=999999 
replace faminc = SE_INC if SE_INC!=. & SE_INC!=999990 & SE_INC!=999999  
replace faminc = US_INC if US_INC!=. & US_INC!=999990 & US_INC!=999997 & US_INC!=999998
egen mean_income = mean(faminc), by(cntry)
egen sd_income = sd(faminc), by(cntry)
gen zinc = (faminc - mean_income)/sd_income

**Save file
save "ZA6900_sample.dta", replace

******************************************************************************************************

***** APPEND ISSP FILES  *****

******************************************************************************************************

clear
use "ZA4747_sample.dta"
sort cntry year
append using  "ZA4700_FI.dta"
append using  "ZA4700_DK.dta"
save "ZA4747_sampleFIDK.dta", replace
append using  "ZA6900_sample.dta", force

tab cntry year
drop if cntry==348 & year==1990

save "ZA4747_FULL_sample.dta", replace


******************************************************************************************************

***** PREPARE COUNTRY DATA FILE *****

******************************************************************************************************
clear 
use "Macro data3 wide.dta"
rename v1 gdplevel1 	
rename v2 gdplevel2
rename v3 gdplevel3
rename v4 gdplevel4
rename v5 gdplevel5
rename v6 migstocklevel1
rename v7 migstocklevel2
rename v8 migstocklevel3
rename v9 migstocklevel4
rename v10 migstocklevel5
rename v11 socxlevel1
rename v12 socxlevel2
rename v13 socxlevel3
rename v14 socxlevel4
rename v15 socxlevel5
rename socx socx_mean
rename migstock migstock_mean 
rename gdp gdp_mean
rename iso_country cntry

reshape long gdpwith socx migstock gdplevel migstocklevel socxlevel , i(cntry) j(wave)
recode wave (1=1985) (2=1990) (3=1996) (4=2006) (5=2016), gen(year) 
save "CRI Macro data.dta", replace


******************************************************************************************************

***** MERGE COUNTRY DATA FILE *****

******************************************************************************************************
*PI notes
* "migstock" are within-mean-centered values
* "migstock_mean" is the within-country mean
* "migstock_level" is simply the level

clear
use "ZA4747_FULL_sample.dta"

merge m:1 cntry year using "CRI Macro data.dta"


******************************************************************************************************

***** 1985-2016 ANALYSES *****

******************************************************************************************************
*PI adjustment
replace migstock=migstock/7.75

qui xtmixed welfare migstocklevel age agesq female ib2.edcat i.lmstatus ib2.worktype wave || cntry: || year: if migstock!=. , var
margins,dydx(migstocklevel) saving("t37m1",replace)


qui xtmixed welfare migstock migstock_mean age agesq female ib2.edcat i.lmstatus ib2.worktype wave || cntry: || year: if migstock!=. , var
margins,dydx(migstock_mean) saving("t37m2",replace)
margins,dydx(migstock) saving("t37m3",replace)


use t37m1, clear
append using t37m2
append using t37m3
gen f = [_n]
gen factor = "Immigrant Stock"
replace factor = "Immigrant Flow, per wave" if f==3

gen id = "t37m1"
replace id = "t37m2" if f==2
replace id = "t37m3" if f==3


clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
order factor AME lower upper id
keep factor AME lower upper id
save team37, replace

erase t37m1.dta
erase t37m2.dta
erase t37m3.dta
erase "CRI Macro data.dta"
erase ZA4747_FULL_sample.dta
erase ZA4747_sampleFIDK.dta
erase ZA6900_sample.dta
erase ZA4700_FI.dta
erase ZA6900_v2-0-0_sample.dta
erase ZA4700_DK.dta
erase ZA4747_sample.dta
erase ZA4748_sample.dta

}
*==============================================================================*
*==============================================================================*
*==============================================================================*
























// TEAM 38
*==============================================================================*
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*
*==============================================================================*



capture confirm file "team38.dta"
  if _rc==0  {
    display "Team 38 already exists, skipping to next code chunk"
  }
  else {


*------------------------------------------------------------------------------*
* merge data
*------------------------------------------------------------------------------*


**************************************
* prepare 2016-dataset for appending *
**************************************

clear 
use "ZA6900_v2-0-0.dta" // ISSP 2016

* rename identifiers to append // PI had to change "c2016" to "c" for this to run
clonevar c = country
//

gen y = 2016
save "ZA6900_2016_append.dta", replace

**************************************
* prepare master - data for merging *
**************************************

use "cri_macro.dta", clear

	gen period = 0
	recode period 0=1 if year >=1981 & year <=1985
	recode period 0=2 if year >=1986 & year <=1990
	recode period 0=3 if year >=1992 & year <=1996
	recode period 0=4 if year >=2002 & year <=2006
	recode period 0=5 if year >=2012 & year <=2016
	
	drop if period == 0

	replace socx_oecd = "." if socx_oecd ==".."
	replace socx_oecd = "." if socx_oecd =="#VALUE!"
	destring, replace
	
	clonevar mignet = mignet_un

*PI addition - later country needs to be defined as "c"
gen c = iso_country
collapse gdp_oecd gdp_wb gdp_twn gni_wb ginid_solt ginim_dolt gini_wb ///
 gini_wid top10_wid mcp migstock_wb migstock_un migstock_oecd mignet_un ///
 pop_wb al_ethnic dpi_tf wdi_empprilo wdi_unempilo socx_oecd mignet (max) year ///
 , by(c period)
 
save "t38.macronew.dta", replace

**************************************************
* load cumulative dataset + append by 2016-wave  *
**************************************************

use "ZA4747.dta", clear

* year, country, countryyear-identifier
clonevar y = V4
clonevar cyear = V7
clonevar c = V6


* append using 2016-wave	
append using "ZA6900_2016_append.dta"
	
drop if c == 152 // chile
drop if c == 158 // taiwan
drop if c == 268 // georgia
drop if c == 356 // india
drop if c == 608 // philippines
drop if c == 643 // russia
drop if c == 740 // suriname
drop if c == 710 // south africa
drop if c == 764 // thailand
drop if c == 792 // turkey
drop if c ==  862 // venezuela

	
* gen dummy for post-communist:
gen postcom = 0
recode postcom 0 = 1 if c == 191 | c == 203 | c==440 | c==428 | c==703
	*Croatia 191
	*Czech Republic 203
	*Lithuania 440
	*Latvia 428
	*Slovakia 703
	
*********************
* merge macro data  *
*********************

/* PI - this is no longer necessary
gen ccum = c
replace ccum = c2016 if c==.
drop c
gen c = ccum
*/
gen year = y

* merge using country and year identifier
merge m:1 c year using "t38.macronew.dta", force
	drop if _merge==2
	drop if _merge==1 // countries for which we do not have macro data
	
 *********************************
 *** recode dependent variable ***
 *********************************

 * oldagecare
 gen oldagecare = V53
 replace oldagecare = v24 if oldagecare ==. // recode 8 9 
 
 * unemployed
 gen unemployed = V55 
 replace unemployed =  v26 if unemployed ==. // recode 8 9
 
 * redincdiff
gen redincdiff=  V56
 replace redincdiff = v27 if redincdiff==. // recode 8 9
 
 * providjobs 
 gen providjobs = V50
 replace providjobs = v21 if providjobs ==.  // recode 8 9
 
* recode missings
 foreach var of varlist oldagecare unemployed redincdiff providjobs {
recode `var' 8 / 9 =.
recode `var' 4=1 3=2 2=3 1=4
label define `var' 1 "strongly disagree" 2 "disagree" 3 "agree" 4 "strongly agree"
label values `var' `var'
}

* build index?
alpha oldagecare unemployed redincdiff providjobs
pwcorr oldagecare unemployed redincdiff providjobs, sig // .71, ok for index

* build index!
egen wssupport = rowmean(oldagecare unemployed redincdiff providjobs)

**********************	
*** micro controls ***
**********************	
	
	* female
	gen female = sex
	replace female = SEX if female == .
	recode female 1=0 2=1 9=.

	* age
	gen ageyear = age
	replace ageyear = AGE if age==.
	gen agesq = ageyear*ageyear
	drop if age < 15

	* political orientation
	clonevar pol=  PARTY_LR
		* 1 - left 5 - right 6-other, no party, no pref
		recode pol 0=6 6/99=6
	
	* education
	gen edu = degree
	replace edu = DEGREE if edu==.
	recode edu 0/1=1 2/3=2 4/5=3 6/9=. // NACHSCHAUEN!
	// add label
		label define edu  1 "<= Primary" 2 "<=Secondary" 3 ">secondary"
		label values edu edu 
		
	* employment
		// 1 paidwork, 2 unemployed, 3 education, 4 other not active
	gen employall = wrkst
	recode employall 1/3=1 5=2 4=4 6=3 7=4 8=4 9=4 10=4 11=2 12=1
	
	
	gen employ16 = MAINSTAT 
	recode employ16 1=1 2=2 3=3 4=3  5/9=4 99=.
	
	gen employ = employall
	replace employ = employ16 if employ==.
	
		// add label
		label define employl 1 "paid work" 2 "unemployed" 3 "in education" 4 "other non-active"
		label values employ employl
	
**********************	
*** macro controls ***
**********************	
	
	
* inequality reduction due to redistribution (market - disposable income gini)	
gen diffgini = ginim_dolt - ginid_solt
	
* specify weights
gen w = weight
replace w = WEIGHT if weight==.

* MODELS TO REPORT:
	reg wssupport female ageyear agesq i.edu i.employ i.pol i.c i.year migstock_oecd gdp_oecd  [pweight=w], cluster(c) robust
	margins, dydx(migstock_oecd) saving("t38m1", replace)
	
*PI adjustment
replace mignet=mignet/10
//
	reg wssupport female ageyear agesq i.edu i.employ i.pol i.c i.year mignet gdp_oecd [pweight=w], cluster(c) robust
	margins, dydx(mignet) saving("t38m2", replace)

use t38m1,clear
append using t38m2

gen f =[_n]
gen factor = "Immigrant Stock"
replace factor = "Immigrant Flow, 1-year" if f==2

gen id = "t38m1"
replace id = "t38m2" if f==2

clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
order factor AME lower upper id
keep factor AME lower upper id
save team38, replace 

erase macronew.dta
erase ZA6900_2016_append.dta
erase t38m1.dta
erase t38m2.dta

}
*==============================================================================*
*==============================================================================*
*==============================================================================*


































// TEAM 39
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team39.dta"
  if _rc==0   {
    display "Team 39 already exists, skipping to next code chunk"
  }
  else {
clear

* ==================================================== *
* Data preparation: 2006 data
* ==================================================== *

use "ZA4700.dta", clear

* Year
gen year = 2006
label var year "year of data collection"

gen country = V3a

label define country ///
	36  "Australia" ///
	208 "Denmark" ///
	246 "Finland" ///
	250 "France" ///
	276 "Germany" ///
	554 "New Zealand" ///
	578 "Norway" ///
	724 "Spain" ///
	752 "Sweden" ///
	756 "Switzerland" ///
	826 "United Kingdom" ///
	840 "United States" 
label values country country
numlabel country, add
label var country "country (ISO 3166)"

egen sample = anymatch(country), values(36 208 246 250 276 554 578 724 752 756 826 840)
keep if sample
drop sample

***********************
* Dependent variables *
***********************

* Old age care
gen old_age = 4 - V28
label variable old_age "Retirement"

* Unemployed
gen unemployed = 4 - V30
label variable unemployed "Unemployment"

* Reduce income differences
gen income = 4 - V31
label variable income "Income"

* Jobs
gen jobs = 4 - V25
label variable jobs "Jobs"

* Health
gen health = 4 - V27
label variable health "Healthcare"

* Housing
gen housing = 4 - V33
label variable housing "Housing"

*************************
* Independent variables *
*************************

* Female
recode sex (1 = 0) (2 = 1) (. = .), gen(female)
label var female "Female"

* Age
label var age "Age"

* Education
recode degree (0 1 = 1) (2 3 4 = 2) (5 = 3) (. = .), gen(education) 
label define education ///
	1 "Primary or less" ///
	2 "Secondary" ///
	3 "University or more" 
label values education education
label var education "education (3 categories)"

* Employment
recode wrkst (1 = 1) (2 3 = 2) (5 = 3) (4 6 7 8 9 10 = 4) (. = .), gen(employment) 
label define employment ///
	1 "Full time" ///
	2 "Part time" ///
	3 "Active unemployed" ///
	4 "Not active"
label values employment employment

* Keep and save prepared 2006 data
keep year country old_age* unemployed* income* jobs* health* housing* female age education employment
compress
save "prepared_2006.dta", replace

* ==================================================== *
* Data preparation: 2016 data
* ==================================================== *

use "ZA6900_v2-0-0.dta", clear

* Year
gen year = 2016
label var year "Year of data collection"


* Country (already in ISO 3166)
rename country V3a
gen country = V3a

label define country ///
	36  "Australia" ///
	208 "Denmark" ///
	246 "Finland" ///
	250 "France" ///
	276 "Germany" ///
	554 "New Zealand" ///
	578 "Norway" ///
	724 "Spain" ///
	752 "Sweden" ///
	756 "Switzerland" ///
	826 "United Kingdom" ///
	840 "United States" 
label values country country
label var country "country (ISO 3166)"

egen sample = anymatch(country), values(36 208 246 250 276 554 578 724 752 756 826 840)
keep if sample
drop sample


***********************
* Dependent variables *
***********************

* Old age care
recode v24 (4 = 0) (3 = 1) (2 = 2) (1 = 3) (8 9 = .), gen(old_age)
label variable old_age "Retirement"

* Unemployed
recode v26 (4 = 0) (3 = 1) (2 = 2) (1 = 3) (8 9 = .), gen(unemployed)
label variable unemployed "Unemployment"

* Reduce income differences
recode v27 (4 = 0) (3 = 1) (2 = 2) (1 = 3) (8 9 = .), gen(income)
label variable income "Income"

* Jobs
recode v21 (4 = 0) (3 = 1) (2 = 2) (1 = 3) (8 9 = .), gen(jobs)
label variable jobs "Jobs"

* Health
recode v23 (4 = 0) (3 = 1) (2 = 2) (1 = 3) (8 9 = .), gen(health)
label variable health "Healthcare"

* Housing
recode v29 (4 = 0) (3 = 1) (2 = 2) (1 = 3) (8 9 = .), gen(housing)
label variable housing "Housing"

*************************
* Independent variables *
*************************

* Female
recode SEX (1 = 0) (2 = 1) (9 = .), gen(female)
label var female "Female"

* Age
recode AGE (999 = .), gen(age)
replace age = DK_AGE if age == 0
label var age "Age"

* Education
recode DEGREE (0 1 = 1) (2 3 4 = 2) (5 6 = 3) (9 = .), gen(education) 
label define education ///
	1 "Primary or less" ///
	2 "Secondary" ///
	3 "University or more" 
label values education education
label var education "Education"

* Employment
recode MAINSTAT (2 = 3) (3 5 6 7 8 = 4) (99 = .) (1 4 8 9 = 100), gen(employment) 

recode WRKHRS (1/29 = 2) (30/96 = 1) (0 98 99 = .), gen(hours)
replace employment = 1 if hours == 1 & employment == 100	// full time
replace employment = 2 if hours == 2 & employment == 100	// part time
replace employment = 1 if MAINSTAT == 4 & employment == 100		// apprentices and trainees assumed to "work full time" (when info on hours is missing)
replace employment = 4 if WORK == 3 & employment == 100		// persons never worked treated as "not active"
replace employment = . if employment == 100

* Keep and save prepared 2006 data
keep year country old_age* unemployed* income* jobs* health* housing* female age education employment
compress
save "prepared_2016.dta", replace

* ==================================================== *
* Data preparation: Country-level data (Part I)
* ==================================================== *


clear all
import delimited "cri_macro.csv"

keep if year == 2004 | year == 2005 | year == 2014 | year == 2015
keep if country == "Australia" | country =="Denmark" | country == "Finland" | country == "France" | country == "Germany" | country == "Norway" | country == "New Zealand" | country == "Spain" | country == "Sweden" | country == "Switzerland"  | country == "United States" | country == "United Kingdom"
keep iso_country country year socx_oecd wdi_unempilo migstock_wb migstock_un migstock_un migstock_oecd

* Change in migration stock
bysort country (year): gen netmigpct = migstock_un - migstock_un[_n-1]

destring socx_oecd, replace

* Name variables
rename wdi_unempilo emprate
rename socx_oecd socx
rename migstock_un foreignpct

drop migstock_oecd migstock_wb

drop if year == 2004 | year == 2014
recode year (2005 = 2006) (2015 = 2016)

drop country
rename iso_country country

* Save country-level data
compress
save "prepared_level2.dta", replace

* ==================================================== *
* Data preparation: Country-level data (Part II)
* ==================================================== *

clear all
*These are foreign-born in the labor force, source team from OECD
import delimited DP_LIVE_20112018180339319.csv

* Keep relevant indicators (TOT = total population of foreign-born)
keep if subject == "TOT"
drop indicator flagcodes measure frequency subject

* Rename variables
rename ïlocation country
label var country "country"

* Keep relevant time points
keep if time == 2004 | time == 2005 | time == 2014 | time == 2015

* Keep countries
gen keep = 0
local in = "AUS DNK FIN FRA DEU NZL NOR ESP SWE CHE GBR USA"
foreach cntry of local in {
	replace keep = 1 if country == "`cntry'"
}
drop if keep == 0
drop keep

* Rename countries for merging
replace country = "36" if country == "AUS"
replace country = "208" if country == "DNK"
replace country = "246" if country == "FIN"
replace country = "250" if country == "FRA"
replace country = "276" if country == "DEU"
replace country = "554" if country == "NZL"
replace country = "578" if country == "NOR"
replace country = "724"  if country == "ESP"
replace country = "752"  if country == "SWE"
replace country = "756"  if country == "CHE"
replace country = "826"  if country == "GBR"
replace country = "840" if country == "USA"

destring country, replace

* Foreign-born unemployment rate 
rename value fbur

* Change in FBUR
bysort country (time): gen fbur_change = fbur - fbur[_n-1]

* Keep 2005 and 2015 + rename 
keep if time == 2005 | time == 2015
recode time (2005 = 2006) (2015 = 2016)
rename time year

* Save country-level data
compress
save "prepared_fbur.dta", replace

* ==================================================== *
* Data merging
* ==================================================== *


use "prepared_2006.dta", clear
append using "prepared_2016.dta"
// "long" data format

merge m:1 country year using "prepared_level2.dta"
drop _merge
merge m:1 country year using "prepared_fbur.dta"
drop _merge

misstable sum, all
egen miss = rowmiss(_all)
gen sample = (miss == 0)
misstable sum if sample == 1, all
// final sample = 29,055 observations
	
compress

	* ==================================================== *
	* Data analysis
	* ==================================================== *

	
	* labels 
	label var foreignpct "Immigrant Stock (%)"
	label var emprate "Employment Rate (% in LF)"
	label var socx "Social Welfare Expenditures (% of GDP)"
	label var fbur "Forein born unemployment rate (%)"
	label var netmigpct "Change in Immigrant Stock (1-year, in %)"
	label var fbur_change "Change in FBUR (1-year, in %)"
		
	* Define selection of vars	
	global depvar = "jobs unemployed income old_age housing health "
	global l1covar = "i.female c.age##c.age i.education i.employment"
	global fe = "i.country i.year"
		
	* Estimation linear (reported in their Table A, indicates preferred models)

	local i = 1
	drop if sample == 0
	foreach v of varlist $depvar {	
		reghdfe `v' c.foreignpct##c.fbur c.emprate c.socx $l1covar, absorb($fe) cluster(country)
		margin, dydx(foreignpct) saving("t39m`i'.dta", replace)
    local i = `i'+1
	}

	local i = 7
	drop if sample == 0
	foreach v of varlist $depvar {	
		reghdfe `v' c.netmigpct##c.fbur_change c.emprate c.socx $l1covar, absorb($fe) cluster(country)
		tab country year if e(sample)==1
		margin, dydx(netmigpct) saving("t39m`i'.dta", replace)
    local i = `i'+1		
	}
	
use t39m1, clear
foreach i of numlist 2/12 {
append using t39m`i'
}
gen f = [_n]
gen factor = "Immigrant Stock"
replace factor = "Immigrant Flow, 1-year" if f>6

clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
gen id = "t39m1"
foreach i of numlist 2/12 {
replace id = "t39m`i'" if f==`i'
}

order factor AME lower upper id
keep factor AME lower upper id
save "team39.dta", replace

foreach i of numlist 1/12 {
erase "t39m`i'.dta"
}
erase prepared_fbur.dta
erase prepared_level2.dta
erase prepared_2016.dta
erase prepared_2006.dta

}
*==============================================================================*
*==============================================================================*
*==============================================================================*























// TEAM 42
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team42.dta"
  if _rc==0   {
    display "Team 42 already exists, skipping to next code chunk"
  }
  else {
 set more off

********************************
********** ISSP 1996 ***********
********************************

use "ZA2900.dta", clear

*** # 1 Harmonize country codes across 1996 and 2006 data

recode v3 (1=36) (20=124)(27=250) (2/3=276) (10=372) (24=392) (19=554) (12=578) (25=724) (13=752) (30=756) (4=826) (6=840), gen(cntry)
label define countrylabel 36 "Australia" 124 "Canada" 152 "Chile" 158 "Taiwan" 191 "Croatia" 203 "Czech" 208 "Denmark" 246 "Finland" 250 "France" 276 "Germany" 348 "Hungary" 372 "Ireland" 376 "Isreal" 392 "Japan" 410 "S Korea" 428 "Latvia" 528 "Netherlands" 554 "New Zealand" 578 "Norway" 608 "Philippines" 616 "Poland" 620 "Portugal" 643 "Russia" 705 "Slovenia" 724 "Spain" 752 "Sweden" 756 "Switzerland" 826 "Great Britain" 840 "United States" 
label values cntry countrylabel

*** # 2 Dependent Variables / Six different welfare attitudes / 1996

* transfrom into binary variable should be (1) or should not be (0)
* "On the whole, do you think it should or should not be the government's responsibility to..."

// Provide jobs for everyone
recode v36 (1/2=1) (3/4=0), gen(b_jobs)
lab def b_jobs 0 "no support" 1 "support"
lab val b_jobs b_jobs

recode v36 (1=4) (2=3) (3=2) (4=1), gen(jobs)
lab def attitudes 1 "Definitely not" 2 "Probably not" 3 "Probably should" 4 "Definitely should"
lab val jobs attitudes

// Provide healthcare for the sick
recode v38 (1/2=1) (3/4=0), gen(b_hcare)
lab def b_hcare 0 "no support" 1 "support"
lab val b_hcare b_hcare

recode v38 (1=4) (2=3) (3=2) (4=1), gen(hcare)
lab val hcare attitudes

// Provide living standard for the old
recode v39 (1/2=1) (3/4=0), gen(b_retire)
lab def b_retire 0 "no support" 1 "support"
lab val b_retire b_retire

recode v39 (1=4) (2=3) (3=2) (4=1), gen(retire)
lab val retire attitudes

// Provide living standard for the unemployed
recode v41 (1/2=1) (3/4=0), gen(b_unemp)
lab def b_unemp 0 "no support" 1 "support"
lab val b_unemp b_unemp

recode v41 (1=4) (2=3) (3=2) (4=1), gen(unemp)
lab val unemp attitudes

// Reduce income diff bw rich and poor
recode v42 (1/2=1) (3/4=0), gen(b_incdiff)
lab def b_incdiff 0 "no support" 1 "support"
lab val b_incdiff b_incdiff

recode v42 (1=4) (2=3) (3=2) (4=1), gen(incdiff)
lab val incdiff attitudes

// Provide decent housing to those who can't afford it
recode v44 (1/2=1) (3/4=0), gen(b_house)
lab def b_house 0 "no support" 1 "support"
lab val b_house b_house

recode v44 (1=4) (2=3) (3=2) (4=1), gen(house)
lab val house attitudes

*** # 3 Individual Level Controls / 1996

// Age & age^2

rename v201 age
gen agesq=age^2

gen yrbrth = 1996-age

// Gender

recode v200 (1=0) (2=1), gen(gender)
lab def gender 0 "male" 1 "female"
lab val gender gender

// Education

recode v205 (1/4=1) (5/6=2) (7=3), gen(education)
lab def edlabels 1 "less than Secondary" 2 "Secondary" 3 "University or above"
lab val education edlabels

// Employment status

gen emplst = .
replace emplst = 1 if v206 == 1  // full-time employment
replace emplst = 2 if v206 >= 2 & v206 <= 4  // part-time employment
replace emplst = 3 if v206 == 5 // unemployed
replace emplst = 4 if v206 >= 6 & v206 <= 10 // not in labour force

lab def emplstlabel 1 "full-time" 2 "part-time" 3 "unemployed" 4 "not in labour force"
lab value emplst emplstlabel

gen selfempl = 0
replace selfempl = 1 if v213 == 1
rename v218 faminc

gen faminczscore=.
levelsof cntry, local(cntries)
foreach cntryval of local cntries {
	zscore faminc if cntry==`cntryval', listwise
	replace faminczscore=z_faminc if cntry==`cntryval'
	drop z_faminc
}

rename v217 owninc

gen owninczscore=.
levelsof cntry, local(cntries)
foreach cntryval of local cntries {
	zscore owninc if cntry==`cntryval', listwise
	replace owninczscore=z_owninc if cntry==`cntryval'
	drop z_owninc
}


// year
gen year=1996

save "CRI_96_recoded.dta", replace

********************************
********** ISSP 2006 ***********
********************************


use "ZA4700.dta", clear

rename V3a cntry

// #1 Dependent Variables / Six different welfare attitudes / 2006

// Provide jobs for everyone
recode V25 (1/2=1) (3/4=0), gen(b_jobs)
lab def b_jobs 0 "no support" 1 "support"
label val b_jobs b_jobs

recode V25 (1=4) (2=3) (3=2) (4=1), gen(jobs)
lab def attitudes 1 "Definitely not" 2 "Probably not" 3 "Probably should" 4 "Definitely should"
lab val jobs attitudes

// Provide healthcare for the sick
recode V27 (1/2=1) (3/4=0), gen(b_hcare)
lab def b_hcare 0 "no support" 1 "support"
label val b_hcare b_hcare

recode V27 (1=4) (2=3) (3=2) (4=1), gen(hcare)
lab val hcare attitudes

// Provide living standard for the old
recode V28 (1/2=1) (3/4=0), gen(b_retire)
lab def b_retire 0 "no support" 1 "support"
label val b_retire b_retire

recode V28 (1=4) (2=3) (3=2) (4=1), gen(retire)
lab val retire attitudes

// Provide living standard for the unemployed
recode V30 (1/2=1) (3/4=0), gen(b_unemp)
lab def b_unemp 0 "no support" 1 "support"
label val b_unemp b_unemp

recode V30 (1=4) (2=3) (3=2) (4=1), gen(unemp)
lab val unemp attitudes

// Reduce income diff bw rich and poor
recode V31 (1/2=1) (3/4=0), gen(b_incdiff)
lab def b_incdiff 0 "no support" 1 "support"
label val b_incdiff b_incdiff

recode V31 (1=4) (2=3) (3=2) (4=1), gen(incdiff)
lab val incdiff attitudes

// Provide decent housing to those who can't afford it
recode V33 (1/2=1) (3/4=0), gen(b_house)
lab def b_house 0 "no support" 1 "support"
label val b_house b_house

recode V33 (1=4) (2=3) (3=2) (4=1), gen(house)
lab val house attitudes

*** # 3 Individual Level Controls / 2006

// Age & age^2

gen agesq=age^2

gen yrbrth = 2006-age

// Gender

recode sex (1=0) (2=1), gen(gender)
lab def gender 0"male" 1"female"
lab val gender gender

// Education

recode degree (0 1 2=1) (3 4=2) (5=3), gen(education)
lab def edlabels 1 "less than Secondary" 2 "Secondary" 3 "University or above"
lab val education edlabels

// Employment status

gen emplst = .
replace emplst = 1 if wrkst == 1  // full-time employment
replace emplst = 2 if wrkst >= 2 & wrkst <= 4  // part-time employment
replace emplst = 3 if wrkst == 5 // unemployed
replace emplst = 4 if wrkst >= 6 & wrkst <= 10 // not in labour force

lab def emplstlabel 1 "full-time" 2 "part-time" ///
3 "unemployed" 4 "not in labour force"
lab value emplst emplstlabel

gen selfempl = 0
replace selfempl = 1 if wrktype == 4

// Income
* construct relative income (z-scores) [w/o currency conversion or inflation adjustment]
* run ado - findit zscore
* COMMENT: analysis of Brady Finnigan uses Family rather than individual earnings
* This is not apparent from the manuscript

gen faminczscore=.
local incvars = "AU_INC CA_INC CH_INC CL_INC CZ_INC DE_INC DK_INC DO_INC ES_INC FI_INC FR_INC GB_INC HR_INC HU_INC IE_INC IL_INC JP_INC KR_INC LV_INC NL_INC NO_INC NZ_INC PH_INC PL_INC PT_INC RU_INC SE_INC SI_INC TW_INC US_INC UY_INC VE_INC ZA_INC" 
foreach incvar of local incvars {
	zscore `incvar', listwise
	replace faminczscore=z_`incvar' if z_`incvar'!=.
	drop z_`incvar'
}

gen owninczscore=.
local incvars = "AU_RINC CA_RINC CH_RINC CL_RINC CZ_RINC DE_RINC DK_RINC DO_RINC ES_RINC FI_RINC FR_RINC GB_RINC HR_RINC HU_RINC IE_RINC IL_RINC JP_RINC KR_RINC LV_RINC NL_RINC NO_RINC NZ_RINC PH_RINC PL_RINC PT_RINC RU_RINC SE_RINC SI_RINC TW_RINC US_RINC UY_RINC VE_RINC ZA_RINC" 
foreach incvar of local incvars {
	zscore `incvar', listwise
	replace owninczscore=z_`incvar' if z_`incvar'!=.
	drop z_`incvar'
}

// year
gen year=2006


save "CRI_06_recoded.dta", replace

********************************
********** ISSP 2016 ***********
********************************


use "ZA6900_v2-0-0.dta", clear

rename country cntry

// #1 Dependent Variables / Six different welfare attitudes / 2016

recode v21 v23 v24 v26 v27 v29 (8/9=.) (0=.)

// Provide jobs for everyone
recode v21 (1/2=1) (3/4=0), gen(b_jobs)
lab def b_jobs 0 "no support" 1 "support"
label val b_jobs b_jobs

recode v21 (1=4) (2=3) (3=2) (4=1), gen(jobs)
lab def attitudes 1 "Definitely not" 2 "Probably not" 3 "Probably should" 4 "Definitely should"
lab val jobs attitudes

// Provide healthcare for the sick
recode v23 (1/2=1) (3/4=0), gen(b_hcare)
lab def b_hcare 0 "no support" 1 "support"
label val b_hcare b_hcare

recode v23 (1=4) (2=3) (3=2) (4=1), gen(hcare)
lab val hcare attitudes

// Provide living standard for the old
recode v24 (1/2=1) (3/4=0), gen(b_retire)
lab def b_retire 0 "no support" 1 "support"
label val b_retire b_retire

recode v24 (1=4) (2=3) (3=2) (4=1), gen(retire)
lab val retire attitudes

// Provide living standard for the unemployed
recode v26 (1/2=1) (3/4=0), gen(b_unemp)
lab def b_unemp 0 "no support" 1 "support"
label val b_unemp b_unemp

recode v26 (1=4) (2=3) (3=2) (4=1), gen(unemp)
lab val unemp attitudes

// Reduce income diff bw rich and poor
recode v27 (1/2=1) (3/4=0), gen(b_incdiff)
lab def b_incdiff 0 "no support" 1 "support"
label val b_incdiff b_incdiff

recode v27 (1=4) (2=3) (3=2) (4=1), gen(incdiff)
lab val incdiff attitudes

// Provide decent housing to those who can't afford it
recode v29 (1/2=1) (3/4=0), gen(b_house)
lab def b_house 0 "no support" 1 "support"
label val b_house b_house

recode v29 (1=4) (2=3) (3=2) (4=1), gen(house)
lab val house attitudes

*** # 3 Individual Level Controls / 2006

rename AGE age
recode age (0=.) (999=.)
gen agesq=age^2

gen yrbrth = 2016-age

// Gender

rename SEX sex
recode sex (1=0) (2=1) (9=.), gen(gender)
lab def gender 0"male" 1"female"
lab val gender gender

// Education

rename DEGREE degree
recode degree (0 1 2=1) (3 4=2) (5 6=3) (9=.), gen(education)
lab def edlabels 1 "less than Secondary" 2 "Secondary" 3 "University or above"
lab val education edlabels

// Employment status

recode WRKHRS (0=.) (98/99=.)

gen emplst = .
replace emplst = 1 if MAINSTAT == 1 & WRKHRS >=30 & WRKHRS!=. // full-time employment (more than 30 hours a week)
replace emplst = 2 if MAINSTAT == 1 & WRKHRS <30  // part-time employment (less than 30 hours a week)
replace emplst = 3 if MAINSTAT == 2 // unemployed
replace emplst = 4 if MAINSTAT >= 3 & MAINSTAT <= 9 // not in labour force (including in education/apprentice/tranining)

lab def emplstlabel 1 "full-time" 2 "part-time" ///
3 "unemployed" 4 "not in labour force"
lab value emplst emplstlabel

gen selfempl = 0
replace selfempl = 1 if EMPREL == 2 | EMPREL ==3

// Income
recode AU_INC AU_RINC NO_INC NO_RINC (9999990 9999999 = .)
recode CH_INC CH_RINC FR_INC FR_RINC DE_INC DE_RINC ES_INC ES_RINC NZ_INC NZ_RINC SE_INC SE_RINC US_INC US_RINC GB_INC GB_RINC (999990/999999 =.)
recode JP_INC JP_RINC (99999990/99999999 =.)

gen faminczscore=.
local incvars = "AU_INC CH_INC DE_INC ES_INC FR_INC GB_INC JP_INC NO_INC NZ_INC SE_INC US_INC" 
foreach incvar of local incvars {
	zscore `incvar', listwise
	replace faminczscore=z_`incvar' if z_`incvar'!=.
	drop z_`incvar'
}


gen owninczscore=.
local incvars = "AU_RINC CH_RINC DE_RINC ES_RINC FR_RINC GB_RINC JP_RINC NO_RINC NZ_RINC SE_RINC US_RINC"
foreach incvar of local incvars {
	zscore `incvar', listwise
	replace owninczscore=z_`incvar' if z_`incvar'!=.
	drop z_`incvar'
}

// year
gen year=2016

save "CRI_16_recoded.dta", replace

************************
***** MERGING DATA *****
************************

use "CRI_16_recoded.dta", clear

append using "CRI_96_recoded.dta"
append using "CRI_06_recoded.dta", force

// generate education and employment dummies

tab education, gen(education)
tab emplst, gen(emplst)

sort cntry year
merge m:1 cntry year using "countrydata_importV2.dta"

recode cntry (36=1) (250=1) (276=1) (392=1) (554=1) ///
(578=1) (724=1) (752=1) (756=1) (826=1) (840=1) (else=0), gen(keep11)
keep if keep11 == 1

************************
***** Pseudo Panel *****
************************

// generate cohort variable if education is used as grouping variable
*PI NOTE: education is not used as a cohort grouping variable
*PI NOTE: cohor defined only on birth year ('age') and gender
gen cohort = yrbrth
recode cohort (1899/1920=.) (1982/2000=.) /// 
(1921/1926 = 1) (1927/1933 = 2) (1934/1939 = 3) (1940/1945 = 4) ///
(1946/1951 = 5) (1952/1957 = 6) (1958/1963 = 7) (1964/1969 = 8) ///
(1970/1975 = 9) (1976/1981 = 10)

gen cohort2 = yrbrth
recode cohort2 (1899/1920=.) (1994/2000=.) /// 
(1921/1926 = 1) (1927/1933 = 2) (1934/1939 = 3) (1940/1945 = 4) ///
(1946/1951 = 5) (1952/1957 = 6) (1958/1963 = 7) (1964/1969 = 8) ///
(1970/1975 = 9) (1976/1981 = 10) (1982/1987= 11) (1988/1993 =12)

bysort gender: tab cntry cohort
// 2*11*10 = 220 

recode education (1/2=0) (3=1), gen(education_2kat)
lab def education2 0 "secondary or lower" 1 "university or higher"
lab val education_2kat education2

bysort gender education_2kat: tab cntry cohort

// GENERATE INDEX

alpha jobs hcare retire unemp incdiff house
factor jobs hcare retire unemp incdiff house, pcf

egen welfare = rmean(jobs hcare retire unemp incdiff house)

// keep only macro information from survey years

keep if year == 1996 | year == 2006 | year == 2016

gen n=1

destring gdp gdp_2lag gdp_5lag foreignpct foreignpct_2lag foreignpct_5lag netmig netmig_2lag netmig_5lag emprate emprate_2lag emprate_5lag socx socx_2lag socx_5lag, replace

*collapse

collapse (mean) welfare jobs hcare retire unemp incdiff house b_jobs b_hcare b_retire b_unemp b_incdiff b_house  /// dependendent variables
faminczscore owninczscore emplst* education* /// individual level information
gdp gdp_2lag gdp_5lag foreignpct foreignpct_2lag foreignpct_5lag netmig netmig_2lag netmig_5lag emprate emprate_2lag emprate_5lag socx socx_2lag socx_5lag (sum) n, /// country level information
by (cohort2 gender cntry year) // panel groups 

*group ids 
egen id=group(cohort2 cntry gender) //

tab id, mis

*checking size of cohorts

gen size30=1 if n>=30
replace size30=0 if n<30
tab size30

gen size50=1 if n>=50
replace size50=0 if n<50
tab size50

gen size80=1 if n>=80
replace size80=0 if n<80
tab size80

/// ANALYSIS

drop if id == .

global id id
global t year

*Modell 1
sort $id $t
xtset $id $t


// PREFERED MODELS


* foreignpct

*PI adjustment (to scale)
replace netmig=netmig/10
//
*PI adjustment (to estimate within wave differences)
replace foreignpct=foreignpct/7.75
replace netmig=netmig/7.75
//

xtreg welfare foreignpct faminczscore gdp socx if size30==1, fe robust
margins,dydx(foreignpct) saving("t42m1",replace)

* netmig

xtreg welfare netmig faminczscore gdp socx if size30==1, fe robust
margins,dydx(netmig) saving("t42m2",replace)


use t42m1,clear
append using t42m2

gen f =[_n]
gen factor = "Immigrant Stock"
replace factor = "Immigrant Flow, 1-year" if f==2

gen id = "t42m1"
replace id = "t42m2" if f==2
clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
order factor AME lower upper id
keep factor AME lower upper id
save team42, replace 

erase CRI_96_recoded.dta
erase CRI_06_recoded.dta
erase CRI_16_recoded.dta
erase t42m1.dta
erase t42m2.dta
 }
*==============================================================================*
*==============================================================================*
*==============================================================================*



























// TEAM 43
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team43.dta"
  if _rc==0   {
    display "Team 43 already exists, skipping to next code chunk"
  }
  else {
version 14

**********************
***Data preparation***
**********************

import excel using "bradyfinnigan2014countrydata.xls", clear firstrow
keep if year == 2006

merge 1:1 cntry year using "rawmig.dta", nogen keep(match)

recode cntry (36 = 1 "Australia")(276 = 2 "Germany") ///
(392 = 8 "Japan") (554 = 7 "New Zealand") ///
(578 = 5 "Norway") (724 = 9 "Spain") (752 = 6 "Sweden") (756 = 11 "Switzerland") ///
(826 = 3 "United Kingdom") (840 = 4 "United States") (250 = 10 "France") ///
(124 191 203 208 246 250 348 372 376  410 428 528 616 620 643 705 152 158 ///
214 608 710 858 862 = .), gen(cntry1)  
drop if cntry1 == .


***Indep Vars
keep foreignpct socx emprate netmig pop socdem liberal cntry1 bruttomig
gen netmigperc = 100*(netmig/pop)

save "countryprep1996.dta", replace

import excel using "bradyfinnigan2014countrydata.xls", clear firstrow
keep if year == 1996

merge 1:1 cntry year using "rawmig.dta", nogen keep(match)

recode cntry (36 = 1 "Australia")(276 = 2 "Germany") ///
(392 = 8 "Japan") (554 = 7 "New Zealand") ///
(578 = 5 "Norway") (724 = 9 "Spain") (752 = 6 "Sweden") (756 = 11 "Switzerland") ///
(826 = 3 "United Kingdom") (840 = 4 "United States") (250 = 10 "France") ///
(124 191 203 208 246 250 348 372 376  410 428 528 616 620 643 705 152 158 ///
214 608 710 858 862 = .), gen(cntry1)  
drop if cntry1 == .

***Indep Vars
keep foreignpct socx emprate netmig pop socdem liberal cntry1 bruttomig
gen netmigperc = 100*(netmig/pop)

save "countryprep2006.dta", replace

***Context 2016***
import excel using "macro_new_team43.xlsx", clear firstrow

gen lang = length(socx_oecd)
drop if lang == 2
keep if year == 2016

***Total migration merge
clonevar cntry=iso_country
merge 1:1 cntry year using "rawmig.dta", nogen

recode iso_country (36 = 1 "Australia")(276 = 2 "Germany") ///
(392 = 8 "Japan") (554 = 7 "New Zealand") ///
(578 = 5 "Norway") (724 = 9 "Spain") (752 = 6 "Sweden") (756 = 11 "Switzerland") ///
(826 = 3 "United Kingdom") (840 = 4 "United States") (250 = 10 "France") ///
(124 191 203 208 246 250 348 372 376  410 428 528 616 620 643 705 152 158 ///
214 608 710 858 862 = .), gen(cntry1)  
keep if inlist(iso_country, 36, 276, 392, 554, 578, 724, 752, 756, 826, 840, 250)

merge 1:1 cntry1 using "countryprep2006.dta", keep(1 3) keepus(socdem liberal)
 
renames migstock_un socx_oecd wdi_empprilo mignet_un pop_wb \ foreignpct socx emprate netmig pop

destring _all, replace
***Indep Vars
keep foreignpct socx emprate netmig pop socdem liberal cntry1 bruttomig

/*PI note: this line is a problem

gen netmigperc = 100*(netmig/pop)

*The team was not aware that netmig here was measured as persons per 1,000,
*But it does not matter because there are zero cases of netmig in 2016.
*No data 
*/

*PI adjustment to fix this, if there were data (but there are none)
gen netmigperc = netmig/10
//

save "countryprep20q6.dta", replace

***************
***ISSP 1996***
***************
use "ZA2900.dta", clear
recode v3 (1=1 "Australia") (2 3 = 2 "Germany") (4 5 = 3 "United Kingdom") ///
(6 = 4 "United States") (12 = 5 "Norway") (13 = 6 "Sweden") ///
(19 = 7 "New Zealand") (24 = 8 "Japan") (25 = 9 "Spain") ///
(27 = 10 "France") (30 = 11 "Switzerland") ///
(7 8 9 11 14 15 16 17 18 20 21 22 23 26 28 = .), gen(cntry1)
drop if cntry1 == .

***Coding of dep Vars
foreach var in v36 v41 v42 v39 v44 v38 {
recode `var' 1 2 = 1  3 4 = 0
label define dependent 1"should be" 0"should not be", replace
label value `var' dependent
}

renames v36 v41 v42 v39 v44 v38 \ jobs unemployment income retirement housing healthcare

***Coding of indep Vars
*Age
rename v201 age
*Age sqr
gen agesqr = age*age
*female
rename v200 female
recode female 2=1 1=0

*schooling
recode v205 (1 2 3 4 = 1 "less than secondary") (5 = 2 "Secondary") (6 7 = 3 "University or above"), ///
gen(edu)

*Employment
recode v206 (1 2 3 = 1 "employed") (5 = 2 "unemployed") (4 6/max = 3 "not in labor force"), gen(empl)

*relative income
foreach i of num 1/11 {
sum v218 if cntry1 == `i'
gen zincome`i' = (v218-r(mean))/r(sd) if cntry1 == `i'
xtile zincome_q`i' = zincome`i', n(3)
recode zincome_q`i' . = 0

} 

gen zincome_q = zincome_q1 +zincome_q2+zincome_q3 +zincome_q4+ zincome_q5 +zincome_q6+ zincome_q7+ ///
zincome_q8+zincome_q9+ zincome_q10+ zincome_q11

*Missing values 
drop if zincome_q == 0

gen year = 1996

recode v202 (1 4 = 1 "married") (5=2 "never married") (3=3 "Divorced") (2=4 "Widowed"), gen(famstat) 

*ID
rename v2 id

merge m:1 cntry1 using "countryprep1996.dta", keep(1 3)

******************************
***    PSEUDO PANEL PREP   ***
******************************

cap drop age_q
xtile age_q = age, n(3)

cap drop strata
egen strata = group(zincome_q age_q cntry1), label

cap drop count
bysort strata: gen count = _N
distinct strata
distinct strata if count < 50
distinct strata if count < 20
drop if count < 10
distinct strata

foreach var in edu empl {
tab `var', gen(dy_`var')
}

collapse jobs unemployment income retirement housing healthcare ///
age agesqr female dy_edu* dy_empl* foreignpct emprate socx netmigperc year bruttomig, by(strata) 

save "prep1996.dta", replace

***************
***ISSP 2006***
***************
use "ZA4700.dta", clear
recode V3a (36 = 1 "Australia")(276 = 2 "Germany") ///
(392 = 8 "Japan") (554 = 7 "New Zealand") ///
(578 = 5 "Norway") (724 = 9 "Spain") (752 = 6 "Sweden") (756 = 11 "Switzerland") ///
(826 = 3 "United Kingdom") (840 = 4 "United States") (250 = 10 "France") ///
(124 191 203 208 246 250 348 372 376  410 428 528 616 620 643 705 152 158 ///
214 608 710 858 862 = .), gen(cntry1) 
drop if cntry1 == .

***Coding of dep Vars
foreach var in V25 V30 V31 V28 V33 V27 {
recode `var' 1 2 = 1  3 4 = 0
label define dependent 1"should be" 0"should not be", replace
label value `var' dependent
} 

renames V25 V30 V31 V28 V33 V27 \ jobs unemployment income retirement housing healthcare

***Coding of indep Vars
*Age
fre age
*Age sqr
gen agesqr = age*age
*female
rename sex female
recode female 2=1 1=0

*schooling
recode degree (0 1 2 = 1 "less than secondary") (3 = 2 "Secondary") (4 5 = 3 "University or above"), ///
gen(edu)

*Employment
recode wrkst (1 2 3 = 1 "employed") (5 = 2 "unemployed") (4 6/max = 3 "not in labor force"), gen(empl)
 
*relative income
foreach var in VE_RINC UY_RINC US_RINC TW_RINC CH_RINC SE_RINC ES_RINC KR_RINC ///
ZA_RINC SI_RINC RU_RINC PT_RINC PL_RINC PH_RINC NO_RINC NZ_RINC NL_RINC LV_RINC ///
JP_RINC IL_RINC IE_RINC HU_RINC GB_RINC DE_RINC FI_RINC FR_RINC DO_RINC DK_RINC ///
CZ_RINC HR_RINC CL_RINC CA_RINC AU_RINC {
recode `var' . = 0
}

gen income_cn = VE_RINC +UY_RINC +US_RINC+ TW_RINC+ CH_RINC+ SE_RINC +ES_RINC +KR_RINC ///
+ZA_RINC +SI_RINC +RU_RINC +PT_RINC +PL_RINC +PH_RINC +NO_RINC +NZ_RINC +NL_RINC +LV_RINC ///
+JP_RINC +IL_RINC +IE_RINC +HU_RINC+GB_RINC +DE_RINC+ FI_RINC+ FR_RINC +DO_RINC +DK_RINC ///
+CZ_RINC +HR_RINC +CL_RINC +CA_RINC +AU_RINC

foreach i of num 1/11 {
sum income_cn if cntry1 == `i'
gen zincome`i' = (income_cn-r(mean))/r(sd) if cntry1 == `i'
xtile zincome_q`i' = zincome`i', n(3)
recode zincome_q`i' . = 0

} 



gen zincome_q = zincome_q1 +zincome_q2+zincome_q3 +zincome_q4+ zincome_q5 +zincome_q6+ zincome_q7+ ///
zincome_q8+zincome_q9+ zincome_q10+ zincome_q11
*Jahresdummy
gen year = 2006

*ID
rename V2 id

*famstat
recode marital (1 4 = 1 "married") (5=2 "never married") (3=3 "Divorced") (2=4 "Widowed"), gen(famstat) 

merge m:1 cntry1 using "countryprep2006.dta", keep(1 3)

******************************
***    PSEUDO PANEL PREP   ***
******************************

cap drop age_q
xtile age_q = age, n(3)

cap drop strata
egen strata = group(zincome_q age_q cntry1), label

cap drop count
bysort strata: gen count = _N
distinct strata
distinct strata if count < 50
distinct strata if count < 20
drop if count < 10
distinct strata


foreach var in edu empl {
tab `var', gen(dy_`var')
}

collapse jobs unemployment income retirement housing healthcare ///
age agesqr female dy_edu* dy_empl* foreignpct emprate socx netmigperc year bruttomig, by(strata) 

save "prep2006.dta", replace
***************
***ISSP 2016***
***************


use "ZA6900_v2-0-0.dta", clear
recode country (36=1 "Australia") (276= 2 "Germany") (826 = 3 "United Kingdom") ///
(840 = 4 "United States") (578 = 5 "Norway") (752 = 6 "Sweden") ///
(554 = 7 "New Zealand") (392 = 8 "Japan") (724 = 9 "Spain") ///
(250 = 10 "France") (756 = 11 "Switzerland") ///
(56 152 158 191 203 208 246 268 348 352 356 376 410 428 440 608 643 703 705 710 740 764 792 862  = .), gen(cntry1)
drop if cntry1 == .

***Coding of dep Vars
foreach var in v21 v26 v27 v24 v29 v23 {
recode `var' 1 2 = 1  3 4 = 0
label define dependent 1"should be" 0"should not be", replace
label value `var' dependent
}

renames v21 v26 v47 v24 v29 v23 \ jobs unemployment income retirement housing healthcare

***Coding of indep Vars
*Age
rename AGE age
*Age sqr
gen agesqr = age*age
*female
rename SEX female
recode female 2=1 1=0

recode DEGREE (0 1 = 1 "less than secondary") (2 3 4 = 2 "Secondary") (5 6 = 3 "University or above"), ///
gen(edu)
recode edu 9 = .

recode MAINSTAT (1 = 1 "employed") (2 = 2 "unemployed") (3/max = 3 "not in labor force"), gen(empl)

*relative income
foreach var in AU_RINC BE_RINC CH_RINC CL_RINC CZ_RINC DE_RINC DK_RINC ES_RINC ///
FI_RINC FR_RINC GB_RINC GE_RINC HR_RINC HU_RINC IL_RINC IN_RINC IS_RINC JP_RINC ///
KR_RINC LT_RINC LV_RINC NO_RINC NZ_RINC PH_RINC RU_RINC SE_RINC SI_RINC SK_RINC ///
SR_RINC TH_RINC TR_RINC TW_RINC US_RINC VE_RINC ZA_RINC {
recode `var' . = 0
}

gen income_cn = AU_RINC +BE_RINC +CH_RINC +CL_RINC +CZ_RINC +DE_RINC +DK_RINC +ES_RINC ///
+FI_RINC +FR_RINC +GB_RINC +GE_RINC +HR_RINC +HU_RINC +IL_RINC +IN_RINC +IS_RINC +JP_RINC ///
+KR_RINC +LT_RINC +LV_RINC +NO_RINC +NZ_RINC +PH_RINC +RU_RINC +SE_RINC +SI_RINC +SK_RINC ///
+SR_RINC +TH_RINC +TR_RINC +TW_RINC +US_RINC +VE_RINC +ZA_RINC

foreach i of num 1/11 {
sum income_cn if cntry1 == `i'
gen zincome`i' = (income_cn-r(mean))/r(sd) if cntry1 == `i'
xtile zincome_q`i' = zincome`i', n(3)
recode zincome_q`i' . = 0
} 


gen zincome_q = zincome_q1 +zincome_q2+zincome_q3 +zincome_q4+ zincome_q5 +zincome_q6+ zincome_q7+ ///
zincome_q8+zincome_q9+ zincome_q10+ zincome_q11

gen year = 2016

recode MARITAL (1 2 3= 1 "married") (6=2 "never married") (4=3 "Divorced") (5=4 "Widowed"), gen(famstat) 

rename CASEID id

merge m:1 cntry1 using "countryprep20q6.dta"


******************************
***    PSEUDO PANEL PREP   ***
******************************

cap drop age_q
xtile age_q = age, n(3)

cap drop strata
egen strata = group(zincome_q age_q cntry1), label

cap drop count
bysort strata: gen count = _N
distinct strata
distinct strata if count < 50
distinct strata if count < 20
drop if count < 10
distinct strata

foreach var in edu empl {
tab `var', gen(dy_`var')
}


collapse jobs unemployment income retirement housing healthcare ///
age agesqr female dy_edu* dy_empl* foreignpct emprate socx netmigperc year bruttomig, by(strata) 

save "prep2016.dta", replace

*************************
***      Append       ***
*************************

use "prep2006.dta", clear
append using "prep1996.dta" 
append using "prep2016.dta"

keep if year == 1996 | year == 2006 | year == 2016

**************
***Analyses***
**************

alpha jobs unemployment income retirement housing healthcare, item gen(opinion)
factor jobs unemployment income retirement housing healthcare

xtset strata year
xtreg opinion foreignpct female dy_edu* dy_empl* i.year, fe
margins, dydx(foreignpct) saving("t43m1",replace)

xtreg opinion foreignpct socx female dy_edu* dy_empl* i.year, fe
margins, dydx(foreignpct) saving("t43m2",replace)

xtreg opinion foreignpct emprate female dy_edu* dy_empl* i.year, fe
margins, dydx(foreignpct) saving("t43m3",replace)


****
cap drop opinion
alpha jobs unemployment income retirement housing healthcare, item gen(opinion)
drop if year == 2016

*PI adjustment
replace netmigperc=netmigperc/5
//

xtset strata year
xtreg opinion netmigperc female dy_edu* dy_empl* i.year, fe
margins, dydx(netmigperc) saving("t43m4",replace)

xtreg opinion netmigperc socx female dy_edu* dy_empl* i.year, fe
margins, dydx(netmigperc) saving("t43m5",replace)

xtreg opinion netmigperc emprate female dy_edu* dy_empl* i.year, fe
margins, dydx(netmigperc) saving("t43m6",replace)

use t43m1,clear
foreach x of numlist 2/6 {
append using t43m`x'
}

gen f=[_n]
gen factor = "Flow"
replace factor = "Change in Flow, per wave" if f>3

gen id = "t43m1"
foreach x of numlist 2/6 {
replace id = "t43m`x'" if f==`x'
}

clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
order factor AME lower upper id
keep factor AME lower upper id
save team43, replace 

foreach x of numlist 1/6 {
erase t43m`x'.dta
}
erase prep2016.dta
erase prep2006.dta
erase prep1996.dta
erase countryprep20q6.dta
erase countryprep1996.dta
erase countryprep2006.dta
}
*==============================================================================*
*==============================================================================*
*==============================================================================*




























// TEAM 45
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team45.dta"
  if _rc==0   {
    display "Team 45 already exists, skipping to next code chunk"
  }
  else {

version 15         // Stata version control 
macro drop _all    // delete all macros
set linesize 82    // result window has room for 82 chars in one line

********************************
********** ISSP 1996 ***********
********************************

use "ZA2900.dta", clear

// change country codes in 1996 to fit 2006 codes
recode v3 (1=36) (2/3=276) (4=826) (6=840) (8=348) (9=.) (10=372) (12=578) (13=752) (14=203) (15=705) (16=616) (17=.) (18=643) (19=554) (20=124) (21=608) (22/23=376) (24=392) (25=724) (26=428) (27=250) (28=.) (30=756), gen(v3a)
label define cntrylbl 36 "Australia" 124 "Canada" 152 "Chile" 158 "Taiwan" 191 "Croatia" 203 "Czech" 208 "Denmark" 246 "Finland" 250 "France" 276 "Germany" 348 "Hungary" 372 "Ireland" 376 "Isreal" 392 "Japan" 410 "S Korea" 428 "Latvia" 528 "Netherlands" 554 "New Zealand" 578 "Norway" 608 "Philippines" 616 "Poland" 620 "Portugal" 643 "Russia" 705 "Slovenia" 724 "Spain" 752 "Sweden" 756 "Switzerland" 826 "Great Britain" 840 "United States" 
label values v3a cntrylbl

// Provide jobs for everyone
recode v36 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
recode govjobs (1/2=0) (3/4=1), gen(dgovjobs)

// Provide healthcare for the sick
recode v38 (1=4) (2=3) (3=2) (4=1), gen(govhcare)
recode govhcare (1/2=0) (3/4=1), gen(dhcare)

// Provide living standard for the old
recode v39 (1=4) (2=3) (3=2) (4=1), gen(govretire)
recode govretire (1/2=0) (3/4=1), gen(dgovretire)

// Provide living standard for the unemployed
recode v41 (1=4) (2=3) (3=2) (4=1), gen(govunemp)
recode govunemp (1/2=0) (3/4=1), gen(dgovunemp)

// Reduce income diff bw rich and poor
recode v42 (1=4) (2=3) (3=2) (4=1), gen(govincdiff)
recode govincdiff (1/2=0) (3/4=1), gen(dgovincdiff)

// Provide decent housing to those who can't afford it
recode v44 (1=4) (2=3) (3=2) (4=1), gen(govhousing)
recode govhousing (1/2=0) (3/4=1), gen(dgovhous)

*****************************
***** micro-level covariates

// AGE
rename v201 age

// SEX
recode v200 (1=0) (2=1), gen(female)

// EDUCATION
recode v205 (1/4=1) (5/6=2) (7=3), gen(educ)
label define educlbl 1 "lesshs" 2 "hs" 3 "univ"
label value educ educlbl

//employment status
recode v206 (3/4=2) (5=3) (6/10=4), gen(empstat)
label define empstatlbl 1 "ftemp" 2 "ptemp" 3 "unemp" 4 "nolabor"
label value empstat empstatlbl

//self-employed
gen selfemp=v213==1 //recodes missings to 0
replace selfemp=. if v206==. //missings on empl. status

// INCOME
// constructing country-specific z-scores, then a standardized cross-country income variable
rename v218 faminc

gen inczscore=.
levelsof v3a, local(cntries)
foreach cntryval of local cntries {
	zscore faminc if v3a==`cntryval', listwise
	replace inczscore=z_faminc if v3a==`cntryval'
	drop z_faminc
}

// year
gen year=1996
gen yr2006=0
gen yr2016=0

// country identifier
rename v3a cntry

// weights
rename v325 wghts

save "ISSP96recode.dta", replace


********************************
********** ISSP 2006 ***********
********************************

use "ZA4700.dta", clear

*******************************
***** recode 6 DEPENDENT VARIABLES
*******************************


**** GOV RESPONSIBILITY ****

// Provide jobs for everyone
recode V25 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
recode govjobs (1/2=0) (3/4=1), gen(dgovjobs)

// Provide healthcare for the sick
recode V27 (1=4) (2=3) (3=2) (4=1), gen(govhcare)
recode govhcare (1/2=0) (3/4=1), gen(dhcare)

// Provide living standard for the old
recode V28 (1=4) (2=3) (3=2) (4=1), gen(govretire)
recode govretire (1/2=0) (3/4=1), gen(dgovretire)

// Provide living standard for the unemployed
recode V30 (1=4) (2=3) (3=2) (4=1), gen(govunemp)
recode govunemp (1/2=0) (3/4=1), gen(dgovunemp)

// Reduce income diff bw rich and poor
recode V31 (1=4) (2=3) (3=2) (4=1), gen(govincdiff)
recode govincdiff (1/2=0) (3/4=1), gen(dgovincdiff)

// Provide decent housing to those who can't afford it
recode V33 (1=4) (2=3) (3=2) (4=1), gen(govhousing)
recode govhousing (1/2=0) (3/4=1), gen(dgovhous)

*****************************
***** micro-level covariates *****
*****************************

// AGE

// SEX
recode sex (1=0) (2=1), gen(female)

// EDUCATION
// see pg 97 in codebook
recode degree (0/2=1) (3/4=2) (5=3), gen(educ)
label define educlbl 1 "lesshs" 2 "hs" 3 "univ"
label value educ educlbl

//employment status
recode wrkst (3/4=2) (5=3) (6/10=4), gen(empstat)
label define empstatlbl 1 "ftemp" 2 "ptemp" 3 "unemp" 4 "nolabor"
label value empstat empstatlbl

//self-employed
gen selfemp=wrktype==4
replace selfemp=. if wrkst==.


// INCOME
// earnings and family income are country specific
// dividing family income by the squareroot of hh size and transforming to country-specific z-scores
// generating a cross-country income variable using within-country z-scores

gen inczscore=.
local incvars = "AU_INC CA_INC CH_INC CL_INC CZ_INC DE_INC DK_INC DO_INC ES_INC FI_INC FR_INC GB_INC HR_INC HU_INC IE_INC IL_INC JP_INC KR_INC LV_INC NL_INC NO_INC NZ_INC PH_INC PL_INC PT_INC RU_INC SE_INC SI_INC TW_INC US_INC UY_INC VE_INC ZA_INC" 
foreach incvar of local incvars {
	zscore `incvar', listwise
	replace inczscore=z_`incvar' if z_`incvar'!=.
	drop z_`incvar'
}

*** TECHNICAL VARIABLES ***

// Country Identifier
rename V3a cntry

// weights
rename weight wghts

// year
gen year=2006
gen yr2006=1
gen yr2016=0

save "ISSP06recode.dta", replace

********************************
********** ISSP 2016 ***********
********************************

use "ZA6900_v2-0-0.dta", clear

*******************************
***** recode 6 DEPENDENT VARIABLES
******************************

**** GOV RESPONSIBILITY ****

// Provide jobs for everyone
recode v21 (1=4) (2=3) (3=2) (4=1) (8/9=.), gen(govjobs)
recode govjobs (1/2=0) (3/4=1), gen(dgovjobs)

// Provide healthcare for the sick
recode v23 (1=4) (2=3) (3=2) (4=1) (8/9=.), gen(govhcare)
recode govhcare (1/2=0) (3/4=1), gen(dhcare)

// Provide living standard for the old
recode v24 (1=4) (2=3) (3=2) (4=1) (8/9=.), gen(govretire)
recode govretire (1/2=0) (3/4=1), gen(dgovretire)

// Provide living standard for the unemployed
recode v26 (1=4) (2=3) (3=2) (4=1) (0 8/9=.), gen(govunemp)
recode govunemp (1/2=0) (3/4=1), gen(dgovunemp)

// Reduce income diff bw rich and poor
recode v27 (1=4) (2=3) (3=2) (4=1) (8/9=.), gen(govincdiff)
recode govincdiff (1/2=0) (3/4=1), gen(dgovincdiff)

// Provide decent housing to those who can't afford it
recode v29 (1=4) (2=3) (3=2) (4=1) (8/9=.), gen(govhousing)
recode govhousing (1/2=0) (3/4=1), gen(dgovhous)

summ dgovjobs dhcare dgovretire dgovunemp dgovincdiff dgovhous


*****************************
***** micro-level covariates *****
*****************************

// AGE
rename AGE age
recode age (999=.)

// SEX
rename SEX sex
recode sex (1=0) (2=1) (9=.), gen(female)

// EDUCATION
// see pg 97 in codebook
rename DEGREE degree
recode degree (0/2=1) (3/4=2) (5/6=3) (9=.), gen(educ)
label define educlbl 1 "lesshs" 2 "hs" 3 "univ"
label value educ educlbl

// The 2016 data do not include the same wrkst variable as in 2006, 
// so we had to deduce employment status from MAINSTAT, and
// part-time status from hours worked (WRKHRS)

//employment status
gen empstat=.
recode empstat (*=1) if WORK==1
recode empstat (*=4) if WORK==2
recode empstat (*=4) if WORK==3
recode empstat (*=3) if MAINSTAT==2
recode empstat (*=4) if MAINSTAT==3
recode empstat (*=4) if MAINSTAT==4
recode empstat (*=4) if MAINSTAT==8
recode empstat (*=4) if MAINSTAT==9
recode empstat (*=2) if WRKHRS!=0 & WRKHRS<=29
label define empstatlbl 1 "ftemp" 2 "ptemp" 3 "unemp" 4 "nolabor"
label value empstat empstatlbl

//self-employed
rename EMPREL wrktype

gen selfemp=.
recode selfemp (*=0) if wrktype==1
recode selfemp (*=1) if wrktype==2
recode selfemp (*=1) if wrktype==3
recode selfemp (*=1) if wrktype==4
recode selfemp (*=.) if wrktype==0
recode selfemp (*=.) if wrktype==9

gen inczscore=.
local incvars = "AU_INC CH_INC CL_INC CZ_INC DE_INC DK_INC  ES_INC FI_INC FR_INC GB_INC HR_INC HU_INC IL_INC JP_INC KR_INC LV_INC  NO_INC NZ_INC PH_INC  RU_INC SE_INC SI_INC TW_INC US_INC  VE_INC ZA_INC" 
foreach incvar of local incvars {
	recode `incvar' 999990/99999990=.
	zscore `incvar', listwise
	replace inczscore=z_`incvar' if z_`incvar'!=.
	drop z_`incvar'
}

*** TECHNICAL VARIABLES ***

// Country Identifier
rename country cntry

// weights
rename WEIGHT wghts

// year
gen year=2016
gen yr2006=0
gen yr2016=1


************************
***** Append the two micro-level datasets
************************

append using "ISSP96recode.dta"
append using "ISSP06recode.dta", force
sort cntry year

merge m:1 cntry year using "cri_macro_jmtb.dta"

*sample variables
recode cntry (36=1) (124=1) (208=1) (246=1) (250=1) (276=1) (372=1) (392=1) (528=1) (554=1) (578=1) (620=1) (724=1) (752=1) (756=1) (826=1) (840=1) (else=0), gen(orig17)
recode cntry (36=1) (124=1) (250=1) (276=1) (372=1) (392=1) (554=1) (578=1) (724=1) (752=1) (756=1) (826=1) (840=1) (else=0), gen(orig13)

*numerical country variable 
encode country, gen(cnt)

************************************************************
********************* ANALYSES *****************************
*************************************************************

keep if orig13

*set globals for variable groups
global depvars "dgovjobs dgovunemp dgovincdiff dgovretire dgovhous dhcare"
global controls "c.age##c.age i.female i.b2.educ i.b1.empstat i.selfemp c.inczscore i.yr2006 i.yr2016 i.b13.cnt"


summ dgovjobs dgovunemp dgovincdiff dgovretire dgovhous dhcare age female educ empstat selfemp inczscore yr2006 yr2016 cntry


*MAIN MODEL
local i=1
foreach depvar in $depvars {
	qui logit `depvar' foreignpct socx emprate gini $controls, cluster(country)  
	margins, dydx(foreignpct) saving("t45m`i'",replace)
	local i=`i'+1

}
use t45m1,clear
foreach x of numlist 2/6 {
append using t45m`x'
}

gen factor = "Immigrant Stock"
gen id = "t45m1"
foreach t of numlist 2/6 {
replace id = "t45m`t'" if `t'==[_n]
}
clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
order factor AME lower upper id
keep factor AME lower upper id
save team45, replace 

foreach x in 06 96 16 {
erase ISSP`x'recode.dta
}
erase ISSP960616.dta
foreach x of numlist 1/6{
erase t45m`x'.dta
} 
}
*==============================================================================*
*==============================================================================*
*==============================================================================*























// TEAM 46
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team46.dta"
  if _rc==0   {
    display "Team 46 already exists, skipping to next code chunk"
  }
  else {

******************************************************************************
************************* 1985
******************************************************************************

*************************
* Read data
*************************

use "ZA1490.dta", clear

gen year1=1985
gen int year = round(year1)
drop year1

recode V3 (1=36 "AUS") ///
	(2=276 "DE") (3=826 "GB")(4=840 "USA")(else=.), gen(country)

keep if country!=.

*************************
* Recoding variables
*************************

***** DVs: 
*** Government responsibility

* Jobs
recode V101 (1 2 = 1 "should be")(3 4 = 0 "should not be"), gen(jobs)

* Unemployment
recode V106 (1 2 = 1 "should be")(3 4 = 0 "should not be"), gen(unemp)

* Income
recode V107 (1 2 = 1 "should be")(3 4 = 0 "should not be"), gen(inc)

* Retirement
recode V104 (1 2 = 1 "should be")(3 4 = 0 "should not be"), gen(retire)

* Housing
//not available in 1985

* Healthcare
recode V103 (1 2 = 1 "should be")(3 4 = 0 "should not be"), gen(health)


*** IVs

* Age
clonevar age = V117

* Age squared
gen age2 = age*age

* Sex: Female
recode V118 (1=0 "male") (2=1 "female"), gen(sex)

* Marital status
recode V120 (1=1 "married")(2=2 "widowed")(3=3 "divorced")(5=5 "not married")(else=.), gen(marital)

recode V109 (.=1 "not lf")(else=0 "in lf"), gen(not_lf)

// part-time (but coding differs from 96/06)
gen parttime = 1 if (V108<30 & V108>1)
replace parttime = 0 if (V108>=30)

recode V109 (1=1 "unemployed")(2=0 "other")(else=.), gen(unemployed)
recode V112 (1 2=1 "self-employed")(3=0 "work for someone else")(else=.), gen (selfemp)
recode V114 (1=1 "public")(2=0 "private")(else=.), gen(public)
recode V114 (2=1 "private")(1=0 "public")(else=.), gen(private)

gen inczscore=.
levelsof country, local(cntry)
foreach cntryval of local cntry {
	zscore V128 if country==`cntryval', listwise
	replace inczscore=z_V128 if country==`cntryval'
	drop z_V128
}

keep jobs unemp inc retire health ///
	age age2 sex not_lf parttime unemployed selfemp public private inczscore year country

sort country year
save "issp85_rec.dta", replace


******************************************************************************
************************* 1990
******************************************************************************

use "ZA1950.dta", clear

gen year1=1990
gen int year = round(year1)
drop year1

recode v3 (1=36 "AUS") ///
	(2 3=276 "DE")(9=372 "IE") ///
	(10=578 "NO")(4=826 "GB")(6=840 "USA")(else=.), gen(country)

keep if country!=.

*************************
* Recoding variables
*************************

***** DVs: 

*** Government responsibility

* Jobs
recode v49 (1 2 = 1 "should be")(3 4 = 0 "should not be")(else=.), gen(jobs)

* Unemployment
recode v54 (1 2 = 1 "should be")(3 4 = 0 "should not be")(else=.), gen(unemp)

* Income
recode v55 (1 2 = 1 "should be")(3 4 = 0 "should not be")(else=.), gen(inc)

* Retirement
recode v52 (1 2 = 1 "should be")(3 4 = 0 "should not be")(else=.), gen(retire)

* Housing
recode v57 (1 2 = 1 "should be")(3 4 = 0 "should not be")(else=.), gen(house)

* Healthcare
recode v51 (1 2 = 1 "should be")(3 4 = 0 "should not be")(else=.), gen(health)

*** IVs

* Age
clonevar age = v60

* Age squared
gen age2 = age*age

* Sex: Female
recode v59 (1=0 "male") (2=1 "female"), gen(sex)

* Labour market status

// part-time (but coding differs from 96/06)
gen parttime = 1 if (v64<30 & v64>1)
replace parttime = 0 if (v64>=30)

recode v63 (5=1 "unemployed")(1/4 6/10=0 "other")(else=.), gen(unemployed)
recode v72 (1=1 "self-employed")(2=0 "work for someone else")(else=.), gen (selfemp)
recode v63 (6/10=1 "not in labour force")(1/3 5 =0 "other")(else=.), gen(not_lf)
recode v71 (1 2=1 "public")(3=0 "private")(else=.), gen(public)
recode v71 (3=1 "private")(1 2=0 "public")(else=.), gen(private)

* Income
gen inczscore=.
levelsof country, local(cntry)
foreach cntryval of local cntry {
	zscore v100 if country==`cntryval', listwise
	replace inczscore=z_v100 if country==`cntryval'
	drop z_v100
}

keep jobs unemp inc retire house health ///
	age age2 sex parttime unemployed selfemp not_lf public private inczscore year country

sort country year
save "issp90_rec.dta", replace

******************************************************************************
************************* 1996
******************************************************************************

use "ZA2900.dta", clear

gen year1=1996
gen int year = round(year1)
drop year1

recode v3 (1=36 "AUS")(20=124 "CDN")(27=250 "FR") ///
	(2 3=276 "DE")(10=372 "IE")(24=392 "JP")(19=554 "NZ") ///
	(12=578 "NO")(25=724 "ES")(13=752 "SE")(30=756 "CH") ///
	(4=826 "GB")(6=840 "USA")(else=.), gen(country)

keep if country!=.

*************************
* Recoding variables
*************************

****** DVs: 
*** Government responsibility

* Jobs
recode v36 (1 2 = 1 "should be")(3 4 = 0 "should not be"), gen(jobs)

* Unemployment
recode v41 (1 2 = 1 "should be")(3 4 = 0 "should not be"), gen(unemp)

* Income
recode v42 (1 2 = 1 "should be")(3 4 = 0 "should not be"), gen(inc)

* Retirement
recode v39 (1 2 = 1 "should be")(3 4 = 0 "should not be"), gen(retire)

* Housing
recode v44 (1 2 = 1 "should be")(3 4 = 0 "should not be"), gen(house)

* Healthcare
recode v38 (1 2 = 1 "should be")(3 4 = 0 "should not be"), gen(health)

*** IVs

* Age
clonevar age = v201

* Age squared
gen age2 = age*age

* Sex: Female
fre v200
recode v200 (1=0 "male") (2=1 "female"), gen(sex)

* Marital status
recode v202 (1=1 "married")(2=2 "widowed")(3=3 "divorced")(5=5 "not married")(else=.), gen(marital)

* Household size
clonevar hhsize = v273

* Children in Household
recode v274 (1 5 9 11 13 15 17 19 21 23 27=0 "no children") ///
	(2/4 6/8 10 12 14 16 18 20 22 24 26=1 "children in household")(else=.), gen(child)
	


* Urbanity
clonevar urban = v275

* Education
recode v205 (2/4 = 1 "less than secondary")(5=2 "secondary") ///
	(6 7 = 3 "higher than secondary")(else=.), gen(edu)

* Labour market status
recode v206 (2 3=1 "part-time")(1 5/10=0 "other")(else=.), gen(parttime)
recode v206 (5=1 "unemployed")(1/3 6/10=0 "other")(else=.), gen(unemployed)
recode v206 (6/10=1 "not in labour force")(1/3 5 =0 "other")(else=.), gen(not_lf)
recode v213 (1=1 "self-employed")(else=0 "work for someone else"), gen (selfemp)
gen public = 1 if v206==1 & (v212==1 | v212==2)	// public full-time
gen private = 1 if v206==1 & v212==3	// private full-time

* Income
fre v218
gen inczscore=.
levelsof country, local(cntry)
foreach cntryval of local cntry {
	zscore v218 if country==`cntryval', listwise
	replace inczscore=z_v218 if country==`cntryval'
	drop z_v218
}
fre inczscore

* Religious attendance
recode v220 (5 6=0 "low religious attendance")(1/4=1 "high religious attendance"), gen(religious)




*************************************************************
keep jobs unemp inc retire house health  ///
	age age2 sex parttime unemployed selfemp not_lf public private inczscore year country

sort country year
save "issp96_rec.dta", replace


*************************************************************
******** Recode 2006 ****************************************
*************************************************************

*************************
* Read data
*************************

use "ZA4700.dta", clear

gen year1=2006
gen int year = round(year1)
drop year1 version

fre V3a
recode V3a (36=36 "AUS")(124=124 "CDN")(208=208 "DK")(246=246 "FI")(250=250 "FR") ///
	(276=276 "DE")(372=372 "IE")(392=392 "JP")(528=528 "NL")(554 = 554 "NZ") ///
	(578=578 "NO")(620=620 "PT")(724=724 "ES")(752=752 "SE")(756=756 "CH") ///
	(826=826 "GB")(840=840 "USA")(else=.), gen(country)

keep if country != .	
	
	
*************************
* Recoding variables
*************************

******* DVs: 

*** Government responsibility

* Jobs
recode V25 (1 2 = 1 "should be")(3 4 = 0 "should not be"), gen(jobs)

* Unemployment
recode V30 (1 2 = 1 "should be")(3 4 = 0 "should not be"), gen(unemp)

* Income
recode V31 (1 2 = 1 "should be")(3 4 = 0 "should not be"), gen(inc)

* Retirement
recode V28 (1 2 = 1 "should be")(3 4 = 0 "should not be"), gen(retire)

* Housing
recode V33 (1 2 = 1 "should be")(3 4 = 0 "should not be"), gen(house)

* Healthcare
recode V27 (1 2 = 1 "should be")(3 4 = 0 "should not be"), gen(health)

*** IVs

* Age
fre age

* Age squared
gen age2 = age*age

* Sex: Female
rename sex gender
recode gender (1=0 "male") (2=1 "female"), gen(sex)

* Marital status
fre marital


replace marital = . if marital==4

* Household size
clonevar hhsize = hompop

* Children in household
fre hhcycle

recode hhcycle (1 5 9 11 13 15 17 19 21=0 "no children") ///
	(2/4 6/8 10 12 14 16 18 20=1 "children in household")(else=.), gen(child)
	
* Urbanity
recode urbrural (1=1 "urban")(2 3=2 "suburb/town")(4 5=3 "rural")(else=.), gen(urban)

* Education
recode degree (0/2 = 1 "less than secondary")(3=2 "secondary") ///
	(4 5 = 3 "higher than secondary")(else=.), gen(edu)

* Labour market status
recode wrkst (2 3=1 "part-time")(1 5/10=0 "other")(else=.), gen(parttime)
recode wrkst (5=1 "unemployed")(1/3 6/10=0 "other")(else=.), gen(unemployed)
recode wrkst (6/10=1 "not in labour force")(1/3 5 =0 "other")(else=.), gen(not_lf)
recode wrktype (4=1 "self-employed")(else=0 "work for someone else"), gen (selfemp)
gen public = 1 if wrkst==1 & (wrktype==1 | wrktype==2)	// public full-time
gen private = 1 if wrkst==1 & wrktype==3	// private full-time

* Income
gen inczscore=.
local incvars = "AU_INC CA_INC CH_INC DE_INC DK_INC ES_INC FI_INC FR_INC GB_INC IE_INC JP_INC NL_INC NO_INC NZ_INC PT_INC SE_INC US_INC" 
foreach incvar of local incvars {
	zscore `incvar', listwise
	replace inczscore=z_`incvar' if z_`incvar'!=.
	drop z_`incvar'
}


* Religious attendance
recode attend (6/8=0 "low religious attendance")(1/5=1 "high religious attendance"), gen(religious)


*************************************************************
keep jobs unemp inc retire house health  ///
	age age2 sex parttime unemployed selfemp not_lf public private inczscore year country

sort country year
save "issp06_rec.dta", replace


*************************************************************
******** Recode 2016 ****************************************
*************************************************************

*************************
* Read data
*************************

use "ZA6900_v2-0-0.dta", clear

gen year1=2016
gen int year = round(year1)
drop year1 version

fre country
rename country cntry
recode cntry (36=36 "AUS")(124=124 "CDN")(208=208 "DK")(246=246 "FI")(250=250 "FR") ///
	(276=276 "DE")(372=372 "IE")(392=392 "JP")(528=528 "NL")(554 = 554 "NZ") ///
	(578=578 "NO")(620=620 "PT")(724=724 "ES")(752=752 "SE")(756=756 "CH") ///
	(826=826 "GB")(840=840 "USA")(else=.), gen(country)

keep if country != .	
	
	
*************************
* Recoding variables
*************************

******** DVs: 

*** Government responsibility

* Jobs
recode v21 (1 2 = 1 "should be")(3 4 = 0 "should not be")(else=.), gen(jobs)

* Unemployment
recode v26 (1 2 = 1 "should be")(3 4 = 0 "should not be")(else=.), gen(unemp)

* Income
recode v27 (1 2 = 1 "should be")(3 4 = 0 "should not be")(else=.), gen(inc)

* Retirement
recode v24 (1 2 = 1 "should be")(3 4 = 0 "should not be")(else=.), gen(retire)

* Housing
recode v29 (1 2 = 1 "should be")(3 4 = 0 "should not be")(else=.), gen(house)

* Healthcare
recode v23 (1 2 = 1 "should be")(3 4 = 0 "should not be")(else=.), gen(health)


*** IVs

* Age: Problem. Classes for age in DK
mvdecode AGE DK_AGE, mv(0 999)
gen age=AGE
replace age = DK_AGE if country==208

* Age squared
gen age2 = age*age

* Sex: Female
recode SEX (1=0 "male") (2=1 "female")(else=.), gen(sex)

* Labour market status

// part-time (but coding differs from 96/06)
mvdecode WRKHRS, mv(0 98 99)
gen parttime = 1 if (WRKHRS<30 & WRKHRS>1)
replace parttime = 0 if (WRKHRS>=30)

recode MAINSTAT (5=1 "unemployed")(1/3 6/10=0 "other")(else=.), gen(unemployed)
recode MAINSTAT (6/10=1 "not in labour force")(1/3 5 =0 "other")(else=.), gen(not_lf)
recode EMPREL (2 3 4=1 "self-employed")(1=0 "work for someone else")(else=.), gen (selfemp)

recode TYPORG2 (1=1 "public")(2=0 "private")(else=.), gen(public)
recode TYPORG2 (2=1 "private")(1=0 "public")(else=.), gen(private)

* Income
gen inczscore=.
local incvars = "AU_INC CH_INC DE_INC DK_INC ES_INC FI_INC FR_INC GB_INC JP_INC NO_INC NZ_INC SE_INC US_INC" 
foreach incvar of local incvars {
	zscore `incvar', listwise
	replace inczscore=z_`incvar' if z_`incvar'!=.
	drop z_`incvar'
}


*************************************************************
keep jobs unemp inc retire house health ///
	age age2 sex parttime unemployed selfemp not_lf public private inczscore year country

sort country year
save "issp16_rec.dta", replace

*************************************************************
******** Merging Data ***************************************
*************************************************************

** macro data by Nate
import excel "cri_macro_DE_1989_90.xlsx", clear firstrow

// there is no German data for 1989, so I used the 1990 (=no lag)

rename country country_str
rename iso_country country

keep if country==36 | country==124 | country==208 | country==246 | country==250 ///
	 | country==276 | country==372 | country==392 | country==528 | country==554 ///
	  | country==578 | country==620 | country==724 | country==752 | country==756 ///
	   | country==826 | country==840

keep if year==1984 | year==1985 | year==1989 | year==1990 | year==1995 | year==1996 ///
		 | year==2005 | year==2006 | year==2015 | year==2016
	   
keep country country_str year migstock_wb migstock_un migstock_oecd mignet_un ///
	wdi_empprilo socx_oecd

gen netmigpct = mignet_un[_n-1]	 // lagged by 1 year

rename socx_oecd socx
rename wdi_empprilo emprate

gen foreignpct_nolag = .
replace foreignpct_nolag = migstock_un
replace foreignpct_nolag = migstock_wb if foreignpct==.

gen foreignpct = foreignpct_nolag[_n-1]	 // lagged by 1 year

fre foreignpct

sort country year

drop if year==1984 | year==1989 | year==1995 | year==2005 | year==2015

save "country_data.dta", replace

** UN net migration by country of origin:
use "UN_Data-country of origin.dta", clear
// create proportion of migrants from Afrika/West Asia (i.e. Middle East) as percent of total population

egen africa_east = rowtotal(o108 o174 o262 o232 o231 o404 o450 o454 o480 o175  ///
					o508 o638 o646 o690 o706 o728 o800 o834 o894 o716) 
egen africa_middle = rowtotal(o24 o120 o140 o148 o178 o180 o226 o266 o678) 
egen africa_north = rowtotal(o12 o818 o434 o504 o729 o788 o732) 
egen africa_south = rowtotal(o72 o426 o516 o710 o748) 
egen africa_west = rowtotal(o204 o854 o132 o384 o270 o288 o324 o624 o430 o466 ///
					o478 o562 o566 o654 o686 o694 o768) 
egen asia_west = rowtotal(o51 o31 o48 o196 o268 o368 o376 o400 o414 o422 ///
					o512 o634 o682 o275 o760 o792 o784 o887)	

gen mig_nonwest = (africa_east + africa_middle + africa_north + africa_south + africa_west + asia_west)/total*100

// create proportion of migrants from western countries (Europe west, north, south, North America & Oceania) as percent of total population
egen europe_north = rowtotal(o830 o208 o233 o234 o246 o352 o372 o833 o428 o440 o578 o752 o826)
egen europe_south = rowtotal(o8 o20 o70 o191 o292 o300 o336 o380 o470 o499 o620 o674 o688 o705 o724 o807)
egen europe_west = rowtotal(o40 o56 o250 o276 o438 o442 o492 o528 o756)
egen america_north = rowtotal(o60 o124 o304 o666 o840)
egen oceania = rowtotal(o36 o554)

gen mig_west = (europe_north + europe_south + europe_west + america_north + oceania)/total*100

// replace years to match ISSP years
replace year = 1996 if year==1995
replace year = 2006 if year==2005
replace year = 2016 if year==2015

// keep & save
keep year cntry_name country mig_nonwest mig_west
sort country year

save "mig_nonwest.dta", replace


*merging
use "issp16_rec.dta", clear
append using "issp85_rec.dta"
append using "issp90_rec.dta"
append using "issp96_rec.dta"
append using "issp06_rec.dta"

sort country year

merge m:1 country year using "country_data.dta", nogen
merge m:1 country year using "mig_nonwest.dta", nogen

save "issp8516.dta", replace


*************************************************************
*************************************************************
*************************************************************
******** Analyses *******************************************
*************************************************************
*************************************************************
*************************************************************

*PI note: their preferred models are indicated because they reported margins for them

********************************************		
** Using 1996, 2006 and 2016 combined		
********************************************		
use "issp8516.dta", clear

* need to drop CDN and IE, as they are not in the 2016 data
drop if country==124 | country==208 | country==246 | country==372 | country==528 | country==620

drop if year <1996

global depvars jobs unemp inc retire house health
global controls c.age c.age2 i.sex c.inczscore ///
		i.parttime i.unemployed i.not_lf i.selfemp  ///
		i.year ib840.country 

*PI adjustment
replace netmigpct=netmigpct/10
//

		
*** (foreignpct_m3)
loc i=1
foreach var of varlist $depvars {
	quiet logit `var' c.foreignpct c.emprate $controls , or
	margins,dydx(foreignpct) saving("t46m`i'",replace)
	loc i=`i'+1
}
	
*** (netmigpct_m4)
loc i=7
foreach var of varlist $depvars {
	quiet logit `var' c.foreignpct c.netmigpct $controls , or
	margins,dydx(netmigpct) saving("t46m`i'",replace)
	loc i = `i'+1
}

*** mig_nonwest_m3
loc i=13
foreach var of varlist $depvars {
	quiet logit `var' c.mig_nonwest c.emprate $controls , or
	margins,dydx(mig_nonwest) saving("t46m`i'",replace)
	loc i=`i'+1
}

*** mig_west_m3
loc i=19
foreach var of varlist $depvars {
	quiet logit `var' c.mig_west c.emprate $controls , or
	margins,dydx(mig_west) saving("t46m`i'",replace)
	loc i=`i'+1
}


use t46m1,clear
foreach x of numlist 2/24 {
append using t46m`x'
}

gen f=[_n]
gen factor = "Immigrant Stock"
replace factor = "Immigrant Flow, 1-year" if (f>6&f<13)
replace factor = "Non-Western Immigrant Stock" if (f>12&f<19)
replace factor = "Western Immigrant Stock" if (f>18&f<25)

gen id = "t46m1"
foreach x of numlist 2/24 {
replace id ="t46m`x'" if f==`x'
 }
clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
order factor AME lower upper id
keep factor AME lower upper id
save team46, replace 

foreach x of numlist 1/24 {
erase t46m`x'.dta
}
foreach x in 06 16 85 90 96  {
erase issp`x'_rec.dta
}
erase mig_nonwest.dta
erase country_data.dta
erase issp8516.dta
}
*==============================================================================*
*==============================================================================*
*==============================================================================*























// TEAM 47
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team47.dta"
  if _rc==0   {
    display "Team 47 already exists, skipping to next code chunk"
  }
  else {
	
****************************************************
****** (I) Set-up of country level variables *******
****************************************************	
	
** (1) Extracting national averages for attitudes **
*************  from ISSP 1995 **********************
		use "ZA2880.dta", clear
	// Adapt country codings to ISO norm.
		#delimit ;
		recode v3 (1=36)
			(2/3=276)
			(4=826)
			(5=.)
			(6=840) 
			(7/9=.)
			(10=372)
			(11=.)
			(12=578)
			(13=752)
			(14/18=.)
			(19=554)
			(20=124)
			(21/22=.) // Spain and Japan are differently coded than in 2003.
			(23=392)
			(24=724)
			(25/50=.)
			, gen(cntry);
		#delimit cr
	// Drop other countries.
		drop if cntry == .
	// Generalized perception of migration. V51 "Q.11 Do you think the number of immigrants to [COUNTRY] nowadays should be...; 1 Increased a lot - 5 Reduced a lot; 8-9 NA"
		recode v51 (8/9=.), gen(numb)
		bys cntry: sum numb, detail
		collapse (mean) numb_me = numb (sd) numb_sd = numb, by(cntry)
	// Save for merging	
		gen year=1996 // (Although the data set is from 1995, the variable will be used for the 1996 ISSP.)
		gen yr1996=1		
		save "ZA2880 - attitude for merge", replace
	
** (2) Extracting national averages for attitudes **
*************  from ISSP 2003 **********************
		clear all 
		use "ZA3910_v2-1-0"	// This is the name as provided by GESIS.
	// Adapt country codings to ISO code.	
		#delimit ;
		recode COUNTRY
			(1=36)
			(2/3=276)
			(4=826)
			(5=.)
			(6=840)
			(7/9=.)
			(10=372)
			(11=.)
			(12=578)
			(13=752)
			(14/18=.)
			(19=554)
			(20=124)
			(21/23=.)
			(24=392)
			(25=724)
			(26/50=.)
			, gen(cntry) 
			;
		#delimit cr
	// Drop other countries.
		drop if cntry == .
	// Generalized perceptions of migration. v55 "Q.11 Do you think the number of immigrants to [COUNTRY] nowadays should be...1 Increased a lot - 5 Reduced a lot; 8-9 NA" I.e. a higher score means more social distance towards migrants. 
		recode v55 (8/9=.), gen(numb)
		bys cntry: sum numb, detail
		collapse (mean) numb_me = numb (sd) numb_sd = numb, by(cntry)	
		gen year=2006 // (Although the data set is from 2003, the variable will be used for the 2006 ISSP.)
		gen yr2006=1		
		save "ZA3910 - attitude for merge", replace
		
********** (3) Gauging levels of migration *********
************** and other country variable **********
		clear all 
		import excel cri_macro1.xlsx, firstrow // (Data provided by Nate Breznau.)
	// Drop countries.
		rename iso_country cntry
		rename wdi_empprilo emprate
		rename socx_oecd socx
		rename mignet_un netmig
		rename migstock_un foreignpct
		drop if !inlist(year, 1996, 2006)
		keep cntry year emprate socx netmig foreignpct
		save "cri_macro1 - for merge.dta", replace
	
	
****************************************************
***** (II) Set-up of individual level variables ****
****************************************************
	
	// (All item wordings as described in Brady & Finnigan 2014.)

***************** (1) Re-coding ********************
********************* ISSP 1996 ********************
		clear all
		use "ZA2900.dta"
	// Adapt country codings to ISO code.
		# delimit; 
		recode v3 
			(1=36)
			(2/3=276)
			(4=826)
			(6=840)
			(7/9=.)
			(10=372)
			(12=578)
			(13=752)
			(14/18=.)
			(19=554)
			(20=124)
			(21/23=.)
			(24=392)
			(25=724)
			(26/50=.)
			, gen(cntry)
			;
		drop if cntry == .;
		label define cntrylbl 
			36 "Australia" 
			124 "Canada"  
			276 "Germany" 
			372 "Ireland" 
			392 "Japan" 
			554 "New Zealand" 
			578 "Norway" 
			724 "Spain" 
			752 "Sweden" 
			826 "Great Britain" 
			840 "United States"
			;
		# delimit cr
		label values cntry cntrylbl
	**** Outcome: Government responsibility
		// Provide jobs for everyone
			recode v36 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
			recode govjobs (1/2=0) (3/4=1), gen(dgovjobs)
		// Provide healthcare for the sick
			recode v38 (1=4) (2=3) (3=2) (4=1), gen(govhcare)
			recode govhcare (1/2=0) (3/4=1), gen(dhcare)
		// Provide living standard for the old
			recode v39 (1=4) (2=3) (3=2) (4=1), gen(govretire)
			recode govretire (1/2=0) (3/4=1), gen(dgovretire)
		// Provide living standard for the unemployed
			recode v41 (1=4) (2=3) (3=2) (4=1), gen(govunemp)
			recode govunemp (1/2=0) (3/4=1), gen(dgovunemp)
		// Reduce income diff bw rich and poor
			recode v42 (1=4) (2=3) (3=2) (4=1), gen(govincdiff)
			recode govincdiff (1/2=0) (3/4=1), gen(dgovincdiff)
		// Provide decent housing to those who can't afford it
			recode v44 (1=4) (2=3) (3=2) (4=1), gen(govhousing)
			recode govhousing (1/2=0) (3/4=1), gen(dgovhous)
	***** Controlls
		// Age
			rename v201 age
			gen agesq=age*age
		// Sex
			recode v200 (1=0) (2=1), gen(female)
		// Education
			rename v205 edcat
			recode edcat (1/3=1) (4=2) (5=3) (6=4) (7=5), gen(degree)
			label define edlabels 1 "Primary/less" 2 "Some Secondary" 3 "Secondary" 4 "Some Higher Ed" 5 "University or higher"
			label values degree edlabels
			recode degree (1/2=1) (nonmiss=0), gen(lesshs)
			recode degree (3/4=1) (nonmiss=0), gen(hs)
			recode degree (5=1) (nonmiss=0), gen(univ)
		// Occupation
			recode v206 (2/10=0), gen(ftemp)
			recode v206 (2/4=1) (nonmiss=0), gen(ptemp)
			recode v206 (5=1) (nonmiss=0), gen(unemp)
			recode v206 (6/10=1) (nonmiss=0), gen(nolabor)
			gen selfemp=v213==1
			replace selfemp=. if v206==.
		// Income
			rename v218 faminc
			gen inczscore=.
			levelsof cntry, local(cntries)
			foreach cntryval of local cntries {
				zscore faminc if cntry==`cntryval', listwise
				replace inczscore=z_faminc if cntry==`cntryval'
				drop z_faminc
			}
	** Technical vars
		// year
			gen year=1996
			gen yr2006=0
	** Save
		save "ZA2900 - for merge.dta", replace
		

***************** (2) Re-coding ********************
********************* ISSP 2006 ********************
		use "ZA4700.dta", clear
	// Drop countries and label them.
		rename V3a cntry
		#delimit ;
		label define cntrylbl
			36 "Australia" 
			124 "Canada" 
			276 "Germany" 
			372 "Ireland"  
			392 "Japan" 
			554 "New Zealand" 
			578 "Norway" 
			724 "Spain" 
			752 "Sweden" 
			826 "Great Britain" 
			840 "United States"
			;
		#delimit cr
		label values cntry cntrylbl
	***** Outcome: Government responsibility
		// Provide jobs for everyone
			recode V25 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
			recode govjobs (1/2=0) (3/4=1), gen(dgovjobs)
		// Provide healthcare for the sick
			recode V27 (1=4) (2=3) (3=2) (4=1), gen(govhcare)
			recode govhcare (1/2=0) (3/4=1), gen(dhcare)
		// Provide living standard for the old
			recode V28 (1=4) (2=3) (3=2) (4=1), gen(govretire)
			recode govretire (1/2=0) (3/4=1), gen(dgovretire)
		// Provide living standard for the unemployed
			recode V30 (1=4) (2=3) (3=2) (4=1), gen(govunemp)
			recode govunemp (1/2=0) (3/4=1), gen(dgovunemp)
		// Reduce income diff bw rich and poor
			recode V31 (1=4) (2=3) (3=2) (4=1), gen(govincdiff)
			recode govincdiff (1/2=0) (3/4=1), gen(dgovincdiff)
		// Provide decent housing to those who can't afford it
			recode V33 (1=4) (2=3) (3=2) (4=1), gen(govhousing)
			recode govhousing (1/2=0) (3/4=1), gen(dgovhous)
	***** Controlls 
		// Age
			gen agesq=age*age
		// Sex
			recode sex (1=0) (2=1), gen(female)
		// Education
			rename degree edcat
			recode edcat (0=1), gen(degree)
			label define edlabels 1 "Primary/less" 2 "Some Secondary" 3 "Secondary" 4 "Some Higher Ed" 5 "University or higher"
			label values degree edlabels
			recode degree (1/2=1) (nonmiss=0), gen(lesshs)
			recode degree (3/4=1) (nonmiss=0), gen(hs)
			recode degree (5=1) (nonmiss=0), gen(univ)
		// Occupation
			rename wrkst empstat
			recode empstat (2/10=0), gen(ftemp)
			recode empstat (2/4=1) (nonmiss=0), gen(ptemp)
			recode empstat (5=1) (nonmiss=0), gen(unemp)
			recode empstat (6/10=1) (nonmiss=0), gen(nolabor)
			gen selfemp=wrktype==4
			replace selfemp=. if empstat==.
		// Income
			gen inczscore=.
			local incvars = "AU_INC CA_INC CH_INC CL_INC CZ_INC DE_INC DK_INC DO_INC ES_INC FI_INC FR_INC GB_INC HR_INC HU_INC IE_INC IL_INC JP_INC KR_INC LV_INC NL_INC NO_INC NZ_INC PH_INC PL_INC PT_INC RU_INC SE_INC SI_INC TW_INC US_INC UY_INC VE_INC ZA_INC" 
			foreach incvar of local incvars {
				zscore `incvar', listwise
				replace inczscore=z_`incvar' if z_`incvar'!=.
				drop z_`incvar'
			}
	*** Technical variables
		// year
			gen year=2006
			gen yr2006=1
	** Save		
		save "ZA4700 - for merge.dta", replace
		clear all
	
********** (III) Merging data sets *****************
*********** and final preparation ******************
	// I merge data sets with country level vars
		clear all 
		use "ZA2880 - attitude for merge"	
		append using "ZA3910 - attitude for merge"
		order cntry year
		sort cntry year
		merge m:1 cntry year using "cri_macro1 - for merge.dta"
		drop _merge
		save "country vars - for merge", replace
	// I merge two ISSP data sets.
		clear all 
		use "ZA4700 - for merge.dta", replace
		append using "ZA2900 - for merge.dta"
	// I merge data sets for individual and country level vars						   
		sort cntry year
		merge m:1 cntry year using "country vars - for merge"
	// I change vars from string to numeric
		destring netmig foreignpct socx emprate, replace
	// I drop all cases from other countries. 
		keep if inlist(cntry, 36, 124, 276, 372, 392, 554, 578, 724, 752, 826, 840)
		save "ZA29004700country.dta", replace
	// Define macros.
		global desktop "Z:/Wissen-Arbeit/Post-Doc/2018_09 Replication/Analysis/Replication - Reproduction _ David Schieferdecker"
		global regtable "excel alpha(0.001, 0.01, 0.05) sym(***, **, *) ctitle(`depvar') eform bdec(3) sdec(2) stats(coef tstat) onecol append"
		global depvars "dgovjobs dgovunemp dgovincdiff dgovretire dgovhous dhcare"
		global controls "age agesq female lesshs univ ptemp unemp nolabor selfemp inczscore yr2006"
		global cntryvars "foreignpct netmig socx emprate numb_me numb_sd"
	// I drop other vars.
		keep $depvars $cntryvars $controls cntry
	// I prepare the list-wise deletion.
		egen allcontrols = rowmiss($controls)
		recode allcontrols (0=1) (nonmiss=0)
		tab cntry, gen(cntryfe)	
	// Save data set for analysis
		save "ZA29004700country.dta", replace
	
	
****************************************************
****************************************************
****************** Analysis  **********************
****************************************************
****************************************************
*PI adjust
replace netmig=netmig/10
//
// Expansion: Generalized perceptions as control
loc i=1
loc t=7
	foreach depvar in $depvars {
		qui logit `depvar' $cntryvars $controls cntryfe*
		margins, dydx(foreignpct) saving("t47m`i'",replace)
		margins, dydx(netmig) saving("t47m`t'",replace)
		loc i=`i'+1
		loc t=`t'+1	
	}

use t47m1,clear
foreach x of numlist 2/12 {
append using t47m`x'
}

gen f=[_n]
gen factor = "Immigrant Stock"
replace factor = "Immigrant Flow, 1-year" if f>6

gen id = "t47m1"
foreach x of numlist 2/12 {
	replace id = "t47m`x'" if f==`x'
}

clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
order factor AME lower upper id
keep factor AME lower upper id
save team47, replace  


erase "ZA3910 - attitude for merge.dta"
erase "ZA2880 - attitude for merge.dta"
erase "cri_macro1 - for merge.dta"
erase "ZA2900 - for merge.dta"
erase "ZA4700 - for merge.dta"
erase "country vars - for merge.dta"
erase "ZA29004700country.dta"
foreach x of numlist 1/12 {
erase t47m`x'.dta
}





}
*==============================================================================*
*==============================================================================*
*==============================================================================*

































// TEAM 49
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team49.dta"
  if _rc==0   {
    display "team249dta already exists, skipping to next code chunk"
  }
  else {
clear
#delimit ;

global countries9606 "36 124 250 276 372 392 554 578 724 752 756 826 840";
global dv    " Jobs Unemp Income Retirement Housing Healthcare ";
global idv   " age age_sq female lessthansecondary university 
               parttime unemp notinlabor selfemp inc_z"; 

#delimit cr;

/*******************************************************************************
	Prepare 1996 ISSP
*******************************************************************************/

use "ZA2900", clear

	gen year=1996
	rename v2 id1996
	rename v325 weight
	
*>> Data selection (country)
****************************

	gen 	cntry = .            // labels in V3A from 2006 dataset		In
	replace cntry = 36 if v3== 1 // AU-Australia 						*
	replace cntry =276 if v3== 2 // DE-Germany 							*
	replace cntry =276 if v3== 3 // DE-Germany
	replace cntry =826 if v3== 4 // GB-Great Britain					* *
	replace cntry =840 if v3== 6 // US-United States					*
	replace cntry =348 if v3== 8 // HU-Hungary
	replace cntry =380 if v3== 9 // IT-Italy  // looked up cntry code
	replace cntry =372 if v3==10 // IE-Ireland							*	
	replace cntry =578 if v3==12 // NO-Norway							*
	replace cntry =752 if v3==13 // SE-Sweden							*
	replace cntry =203 if v3==14 // CZ-Czech Republic
	replace cntry =705 if v3==15 // SI-Slovenia
	replace cntry =616 if v3==16 // PL-Poland
	replace cntry =100 if v3==17 // BG-Bulgaria
	replace cntry =643 if v3==18 // RU-Russia
	replace cntry =554 if v3==19 // NZ-New Zealand						*
	replace cntry =124 if v3==20 // CA-Canada							*
	replace cntry =608 if v3==21 // PH-Philippines
	replace cntry =376 if v3==22 // IL-Israel
	replace cntry =376 if v3==23 // IL-Israel
	replace cntry =392 if v3==24 // JP-Japan							*
	replace cntry =724 if v3==25 // ES-Spain							*
	replace cntry =428 if v3==26 // LV-Latvia
	replace cntry =250 if v3==27 // FR-France							*
	replace cntry =196 if v3==28 // CY-Cyprus
	replace cntry =756 if v3==30 // CH-Switzerland						*
	assert  cntry != .                                  

		gen		keep=0
	foreach country of global countries9606 {
		replace keep=1 if cntry==`country'
	}

	keep if keep==1
	drop    keep
	// labels for cntry come from 2006 data
	
*>> DVs
****************************

	// Jobs: "provide a job for everyone who wants one"
	gen Jobs = v36
		recode Jobs (1/2=1) (3/4=0)
		lab var Jobs "Jobs for all"

	// Unemployment: "provide a decent standard of living for the Unemployed"
	gen Unemp = v41
		recode Unemp (1/2=1) (3/4=0)
		lab var Unemp "Decent living for Unemployed"

	// Income: "reduce Income differences between rich and poor"
	gen Income = v42
		recode Income (1/2=1) (3/4=0)
		lab var Income "Reduce Income differences"

	// Retirementment: "provide a decent standard of living for the old"
	gen Retirement = v39
		recode Retirement (1/2=1) (3/4=0)
		lab var Retirement "Decent living for old"

	// Housing: "provide decent housing to those who can't afford it"
	gen Housing = v44
		recode Housing (1/2=1) (3/4=0)
		lab var Housing "Decent housing for poor"

	// Healthcare: "provide healthcare for the sick"
	gen Healthcare = v38
		recode Healthcare (1/2=1) (3/4=0)
		lab var Healthcare "Health care for sick"

*>> IDV	
****************************
		
	* Female
	recode v200 (1=0) (2=1), gen(female)

	* Age
	gen age = v201
	gen age_sq = age * age

	* Marital Status (ref: married) 
	recode v202 (3 4 = 3) (5=4), gen(marstat) 
	ta marstat, gen(marstat_bin) 							// In text they say "never married" not "not married"
	rename marstat_bin1 married
	rename marstat_bin2 widowed
	rename marstat_bin3 divorced
	rename marstat_bin4 notmarried

	* Householdsize
	rename v273 hhsize

	* Children in hh
	gen 	childreninhh = v274
	replace childreninhh = . if v274 == 95 					// "otherwise" set to sysmis
	recode 	childreninhh (1 5 9 11 13 15 17 19 21 = 0)
	recode 	childreninhh (2 3 4 6 7 8 10 12 14 16 18 20 = 1)


	* Region (ref: urban)
	ta v275, gen(urban_bin) 
	rename urban_bin1 urban
	rename urban_bin2 suburb
	rename urban_bin3 rural 

	* Educational level (ref: secondary)  
	recode v205 (1/4 = 1) (5/6=2) (7=3), gen(educ) 
	ta educ, gen(educ_bin)
	rename educ_bin1 lessthansecondary
	rename educ_bin2 secondary
	rename educ_bin3 university

	* Employment Status (ref: full-time)
	recode v206 (2/10=0), gen(fulltime)
	recode v206 (2/4=1)  (nonmiss=0), gen(parttime)
	recode v206 (5=1) 	 (nonmiss=0), gen(unemp)
	recode v206 (6/10=1) (nonmiss=0), gen(notinlabor)
	
	* (ref: private)
	recode v212 (1/2=1) (3/.=0), gen(public)
	recode v212 (3=1) (1 2/.=0), gen(private) 	// Deviation for reference category 
	recode v213 (2/.=0), gen(selfemp)			// Relevant deviation from B&F -> they set selfemp to missing if v206 is missing
	
	* Income (z-transformation)
	gen inc_z=.
	levelsof cntry, local(ct)
	foreach cntryval of local ct {
		zscore v218 if cntry==`cntryval', listwise
		replace inc_z=z_v218 if cntry==`cntryval'
		drop z_v218
	}

	* Religion (ref: not_rel)
	recode v220 (1/4=1) (5=2) (6=3) (nonmiss=0), gen(religion)
	ta religion, gen(religion_bin)
	rename religion_bin1 high_rel
	rename religion_bin2 low_rel
	rename religion_bin3 not_rel

	
	recode v46 (5 4 = 0) (1/3 = 1)
	
	rename  v46 pol_interest
	rename  v50 pol_understand
	


*>> Keep & Save	
****************************
order id cntry year weight $dv $idv pol_interest pol_understand
keep  id cntry year weight $idv $dv pol_interest pol_understand

save "issp1996.dta", replace

/*******************************************************************************
	Prepare 2006 ISSP
*******************************************************************************/

use "ZA4700", clear

	gen year=2006
	rename V2 id2006
	

*>> Data selection (country)
****************************

	rename V3a cntry

		gen		keep=0
	foreach country of global countries9606 {
		replace keep=1 if cntry==`country'
	}

	keep if keep==1
	drop    keep



*>> DVs
****************************

	// Jobs: "provide a job for everyone who wants one"
	gen Jobs = V25
		recode 	Jobs (1/2=1) (3/4=0)
		lab var Jobs "Jobs for all"

	// Unemployment: "provide a decent standard of living for the Unemployed"
	gen Unemp = V30
		recode 	Unemp (1/2=1) (3/4=0)
		lab var Unemp "Decent living for Unemployed"

	// Income: "reduce Income differences between rich and poor"
	gen Income = V31
		recode 	Income (1/2=1) (3/4=0)
		lab var Income "Reduce Income differences"

	// Retirementment: "provide a decent standard of living for the old"
	gen Retirement = V28
		recode 	Retirement (1/2=1) (3/4=0)
		lab var Retirement "Decent living for old"

	// Housing: "provide decent housing to those who can't afford it"
	gen Housing = V33
		recode 	Housing (1/2=1) (3/4=0)
		lab var Housing "Decent housing for poor"

	// Healthcare: "provide healthcare for the sick"
	gen Healthcare = V27
		recode 	Healthcare (1/2=1) (3/4=0)
		lab var Healthcare "Health care for sick"

*>> IDV	
****************************

		
	* Female
	recode sex (1=0) (2=1), gen(female)

	* Age
	gen age_sq = age * age

	* Marital Status (ref: married) 
	rename marital marstat 
	ta marstat, gen(marstat_bin) // In the text they write "never married" instead of "not married"
	rename marstat_bin1 married
	rename marstat_bin2 widowed
	rename marstat_bin3 divorced
	rename marstat_bin4 notmarried

	* Householdsize
	rename hompop hhsize

	* Children in hh
	gen childreninhh = hhcycle
	replace childreninhh = . if hhcycle == 95 // "other" set to sysmis
	recode childreninhh (1 5 9 11 13 15 17 19 21 23 25 = 0)
	recode childreninhh (2 3 4 6 7 8 10 12 14 16 18 20 22 24 26 28 = 1)

	* Region (ref: urban)
	recode urbrural (1=1) (2/3=2) (4/5=3), gen(region)
	ta region, gen(urban_bin) 
	rename urban_bin1 urban
	rename urban_bin2 suburb
	rename urban_bin3 rural 

	* Educational level (ref: secondary)  
	* Educational level (ref: secondary)  
	recode degree (0/2 = 1) (3/4=2) (5=3), gen(educ) 
	ta educ, gen(educ_bin)
	rename educ_bin1 lessthansecondary
	rename educ_bin2 secondary
	rename educ_bin3 university

	* Employment Status (ref: private full-time)
	recode wrkst (2/10=0), gen(fulltime)
	recode wrkst (2/4=1) (nonmiss=0), gen(parttime)
	recode wrkst (5=1) (nonmiss=0), gen(unemp)
	recode wrkst (6/10=1) (nonmiss=0), gen(notinlabor)
	recode wrktype (1/2=1) (3/.=0), gen(public)
	recode wrktype (3=1) (1 2/.=0), gen(private) // Deviation! 
	recode wrktype (2/.=0), gen(selfemp)


	* Income (z-transformation)
	gen inc_z=.
	local inc_cntrs = "AU_INC CA_INC FR_INC DE_INC IE_INC JP_INC NZ_INC NO_INC ES_INC SE_INC CH_INC GB_INC US_INC" 
	foreach inc_cntr of local inc_cntrs {
		zscore `inc_cntr', listwise
		replace inc_z=z_`inc_cntr' if z_`inc_cntr'!=.
		drop z_`inc_cntr'
	}


	* Religion (ref: not_rel)
	recode attend (1/6=1) (7=2) (8=3) (nonmiss=0), gen(religion)
	ta religion, gen(religion_bin)
	rename religion_bin1 high_rel
	rename religion_bin2 low_rel
	rename religion_bin3 not_rel

	recode V44 (5 4 = 0) (1/3 = 1)
	 
	rename  V44 pol_interest
	rename  V47 pol_understand
	


*>> Keep & Save	
****************************
order id cntry year weight $dv $idv pol_interest pol_understand
keep  id cntry year weight $idv $dv pol_interest pol_understand


save "issp2006.dta", replace

/*******************************************************************************
	Prepare 2016 ISSP -> Canada and Ireland missing (11 instead of 13 countries)
*******************************************************************************/			 

use "ZA6900_v2-0-0", clear

	gen year=2016
	rename CASEID id2016
	
	rename WEIGHT weight

*>> Data selection (country)
****************************

	rename country cntry                                 

	gen		keep=0
	foreach country of global countries9606 {
		replace keep=1 if cntry==`country'
	}

	keep if keep==1
	drop    keep

	

*>> DVs
****************************

	// Jobs: "provide a job for everyone who wants one"
	gen Jobs = v21
		recode Jobs (1/2=1) (3/4=0) (8/9=.)
		lab var Jobs "Jobs for all"

	// Unemployment: "provide a decent standard of living for the Unemployed"
	gen Unemp = v26
		recode Unemp (1/2=1) (3/4=0) (8/9=.)
		lab var Unemp "Decent living for Unemployed"

	// Income: "reduce Income differences between rich and poor"
	gen Income = v27
		recode Income (1/2=1) (3/4=0) (8/9=.)
		lab var Income "Reduce Income differences"

	// Retirementment: "provide a decent standard of living for the old"
	gen Retirement = v24
		recode Retirement (1/2=1) (3/4=0) (8/9=.)
		lab var Retirement "Decent living for old"

	// Housing: "provide decent housing to those who can't afford it"
	gen Housing = v29
		recode Housing (1/2=1) (3/4=0) (8/9=.)
		lab var Housing "Decent housing for poor"

	// Healthcare: "provide healthcare for the sick"
	gen Healthcare = v23
		recode Healthcare (1/2=1) (3/4=0) (8/9=.)
		lab var Healthcare "Health care for sick"


*>> IDV	
****************************

		
	* Female
	recode SEX (1=0) (2=1) (9=.), gen(female)

	* Age
	gen 	age    = AGE				
	replace age    = . if age==999		
	gen age_sq = age * age				

	* Marital Status (ref: married) 
	recode MARITAL (1/2=1) (5=2) (4=3) (3=4) (6=5) (9=.), gen(marstat)
	ta marstat, gen(marstat_bin) // In the text they write "never married" instead of "not married"
	rename marstat_bin1 married
	rename marstat_bin2 widowed
	rename marstat_bin3 divorced
	rename marstat_bin4 notmarried

	* Householdsize
	rename HOMPOP hhsize

	* Children in hh
	gen childreninhh = HHCHILDR
	replace childreninhh = . if HHCHILDR == 99 & cntry!= 36 // AU = no children; rest: no answer
	recode childreninhh (0 96 = 0)
	recode childreninhh (99   = 0) if cntry == 36
	recode childreninhh (1/6 = 1)

	* Region (ref: urban)
	recode URBRURAL (1=1) (2/3=2) (4/5=3) (7/9=.), gen(region)
	ta region, gen(urban_bin) 
	rename urban_bin1 urban
	rename urban_bin2 suburb
	rename urban_bin3 rural 

	* Educational level (ref: secondary)  
	* Educational level (ref: secondary)  
	recode DEGREE (0/2 = 1) (3/5=2) (6=3) (9=.), gen(educ) 
	ta educ, gen(educ_bin)
	rename educ_bin1 lessthansecondary
	rename educ_bin2 secondary
	rename educ_bin3 university

	* Employment Status (ref: private full-time)
	* Remark: In contrast to 1996 and 2006 the categories public and private cannot be generated
	recode WRKHRS (98/99=.) (0/36=0) (36/96=1), gen(fulltime) // fulltime defined as 36 hours+
	recode WRKHRS (98/99=.) (1/36=1) (36/96=0), gen(parttime) 
	recode MAINSTAT (99=.) (1 3/9=0) (2=1), gen(unemp) 
	recode MAINSTAT (99=.) (1/2=0) (7/9=0) (3/6=1), gen(notinlabor)
	recode EMPREL (9=.) (0 1 4=0) (2/3=1), gen(selfemp) 
		
	* Income (z-transformation)
	
	// first drop the missing values from the variables, then z-transform
	foreach income in 	/*AU_INC*/ FR_INC DE_INC /* JP_INC */ NZ_INC /*NO_INC*/ ES_INC SE_INC CH_INC GB_INC US_INC { 
		su  	`income'
		replace `income' = . if `income' ==	999990 // other countries missing code
		replace `income' = . if `income' ==	999997 // Refused
		replace `income' = . if `income' ==	999998 // Don't know
		replace `income' = . if `income' ==	999999 // No answer
	}
	
	replace AU_INC = . if AU_INC >= 9999990 // missing values only start at 9999990
	replace JP_INC = . if JP_INC >=99999990 // missing values only start there
	replace NO_INC = . if NO_INC >=9999990 // missing values only start there
	
	// now z-transform...
	gen inc_z=.
	local inc_cntrs = "AU_INC FR_INC DE_INC JP_INC NZ_INC NO_INC ES_INC SE_INC CH_INC GB_INC US_INC" 
	foreach inc_cntr of local inc_cntrs {
		zscore `inc_cntr', listwise
		replace inc_z=z_`inc_cntr' if z_`inc_cntr'!=.
		drop z_`inc_cntr'
	}


	* Religion (ref: not_rel)
	recode ATTEND (98/99=.) (1/6=1) (7=2) (8=3) (nonmiss=0), gen(religion)
	ta religion, gen(religion_bin)
	rename religion_bin1 high_rel
	rename religion_bin2 low_rel
	rename religion_bin3 not_rel
	
	gen pol_interest = .
	replace pol_interest = 0 if v46 == 4 | v46 == 5
	replace pol_interest = 0 if NZ_v46 == 3 | NZ_v46 == 4
	replace pol_interest = 1 if v46 == 1 | v46 == 2 | v46 == 3
	replace pol_interest = 1 if NZ_v46 == 1 | NZ_v46 == 2
	
	rename v48 pol_understand

	

*>> Keep & Save	
****************************
order id cntry year weight $dv $idv pol_interest pol_understand
keep  id cntry year weight $idv $dv pol_interest pol_understand

save "issp2016.dta", replace		
		

/*******************************************************************************
	Import & prepare NEW macro data
*******************************************************************************/

import excel "cri_macro.xlsx", firstrow clear

	destring, replace

	foreach var in migstock_wb migstock_un migstock_oecd mignet_un {
		replace `var' = `var'[_n-1] if year == 1996 | year == 2006 | year == 2016
	} 
	
	keep if year == 1996 | year == 2006 | year == 2016 
	drop country
	rename iso_country cntry
	
		gen		keep=0
	foreach country of global countries9606 {
		replace keep=1 if cntry==`country'
	}

	keep if keep==1
	drop    keep
	
	replace socx_oecd="." if socx_oecd==".."
    destring socx_oecd, replace
	
save "cri_macro_49.dta", replace


/*******************************************************************************
	Integrate OLD macro data // 
*******************************************************************************/
*PI NOTE: they don't use in preferred model, so this code deleted

/*******************************************************************************
	Dataset for analyes - pool 1996 & 2006 & 2016 & merge macro data
*******************************************************************************/

use 			"issp2006", clear // label for all cntry only in 2006
append using	"issp2016"
append using	"issp1996"

	order cntry year id1996 id2006 id2016

merge m:1 cntry year using "cri_macro_49.dta", gen(merge_new_m)
	drop if merge_new_m == 2 // CA & IE not available in 2016
	assert merge_new_m==3
	drop   merge_new_m

*>> Generate new weight (each country in each year has the same importance), 
*   integrates ISSP supplied weight: 

	assert weight <.
	
	// 13 countries * 3 times, minus 2 missing in 2016 = 37 country level obs
	// in total 56310 obs, i.e. target: 1521.9 per country/wave
	
	capture drop obscntry
	egen obscntry = count(weight), by(cntry year)
	
	count
		local obs = r(N)
		di `obs'
	
	capture drop groups
	egen groups = group(cntry year)
		sum group
		local groups = r(max)
		di `groups'
		
		di `obs'/`groups'
	
	capture drop 	wc
	gen 			wc = 1 / (obscntry / (`obs' / `groups'))
	lab var 		wc "weight equalizing # obs across countries & time"
	
/*******************************************************************************
	M2: Estimate our preferred model: netmigpctN, foreignpctN, socxN, emprateN
*******************************************************************************/

	rename mignet_un		netmigpctN   	
	rename migstock_wb      foreignpctN  	
	rename socx_oecd    	socxN // socx_oecd is missing for NZ + JP in 2016    		
	rename wdi_empprilo     emprateN     	
  
	// estimate models
	global twfe " ib1996.year ib36.cntry "
	global w 	"[iweight = wc]"
	global cse 	"vce(cluster cntry)"
	
	*PI adjustment
	replace netmigpctN=netmigpctN/10
	//
	local i = 1
	local j = 7
	foreach dv of global dv {
	 #delimit;

	  logit `dv' netmigpctN foreignpctN emprateN socxN	///
			$idv $twfe $w, $cse ; est store M2`dv'; loc M2`dv'=e(N); 
			margins, dydx(foreignpctN) saving("t49m`i'", replace);
			margins, dydx(netmigpctN) saving("t49m`j'", replace);
			local i = `i'+1;
			local j = `j'+1;
	 #delimit cr;
	}
	
use t49m1, clear
foreach i of numlist 2/12 {
append using t49m`i'
}
gen f = [_n]
gen factor = "Immigrant Stock"
replace factor = "Immigrant Flow, 1-year" if f>6

clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
gen id = "t49m1"
foreach i of numlist 2/12 {
replace id = "t49m`i'" if f==`i'
}

order factor AME lower upper id
keep factor AME lower upper id
save "team49.dta", replace

erase "issp1996.dta"
erase "issp2006.dta"		
erase "issp2016.dta"
erase "cri_macro_49.dta"
erase "analysis.dta"
foreach x of numlist 1/12 {
erase t49m`x'.dta
}
}
*==============================================================================*
*==============================================================================*
*==============================================================================*
































// TEAM 52
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team52.dta"
  if _rc==0   {
    display "Team 52 already exists, skipping to next code chunk"
  }
  else {
  
version 13.0

********************************* BEGIN ************************************
use ZA6900_v2-0-0.dta, clear	// 2016 data
ren v* za69_v*
labren, pref(za69_)	// change label names
gen year = 2016

append using ZA2900.dta	//	1996 data
recode year (. = 1996)

append using ZA4700.dta	// 2006 data
recode year (. = 2006)

//----------------------- INCLUDED COUNTRIES ----------------------------------
*	Australia, Canada (96;06), Denmark (06;16), Finland (06;16), France, 
*	Germany, Ireland (96;06), Japan, New Zealand, Norway, Spain, Sweden, 
*	Switzerland, UK, US
//-----------------------------------------------------------------------------
label define YN 1 "yes" 0 "no"

recode v3 (1/6 10/13 19 20 24 25 27 30 =1) (else=0), gen(incl96x)	// extended list; countries in study, 1996 
recode v3 (1/6 11/13 19 24 25 27 30 =1) (else=0), gen(incl96)	// short list; countries in study, 1996 
recode v3	///
	(208	=	208		"Denmark")		///
	(246	=	246		"Finland")		///
	(1		= 	36		"Australia")	///
	(2 3	=	276		"Germany")		///
	(4		=	826		"UK")			///
	(6		=	840		"USA")			///
	(10		=	372		"Ireland")		///
	(12		=	578		"Norway")		///
	(13		=	752		"Sweden")		///
	(19		=	554		"New Zealand")	///
	(20		=	124		"Canada")		///
	(24		=	392		"Japan")		///
	(25		=	724		"Spain")		///
	(27		=	250		"France")		///
	(30		=	756		"Switzerland")	///
	(else	=	.)						///
	, gen(cntry)
recode V3 (208 246 36 124 250 276.1 276.2 372 392 554 578 724 752 756 826.1 840 =1) (else=0), gen(incl06x) // extended list of countries in study, 2006 
recode V3 (36 250 276.1 276.2 392 554 578 724 752 756 826.1 840 =1) (else=0), gen(incl06) // countries in all waves, 2006 

replace cntry = V3a if cntry == . & incl06x == 1

recode country (208 246 36 276 826 840 372 578 752 554 124 392 724 250 756 =1) (else=0), gen(incl16x) // extended list of countries in study, 2016 
recode country (36 276 826 840 372 578 752 554 124 392 724 250 756 =1) (else=0), gen(incl16)	// countries in all waves, 2016

replace cntry = country if cntry == . & incl16x == 1

keep if incl96x == 1 | incl06x == 1 | incl16x == 1
egen allwave = rowmax (incl96 incl06 incl16)
label variable allwave "Country in all waves"
label values allwave YN


drop country

//---------------DEPENDENT VARIABLES--------------------------------------

recode v36 (1 2 = 1) (3 4 = 0) (.=.), gen(JOBS96)	// jobs
recode V25 (1 2 = 1) (3 4 = 0) (.=.), gen(JOBS06)
recode za69_v21 (1 2 = 1) (3 4 = 0) (else=.), gen(JOBS16)
egen JOBS = rowmax(JOBS96 JOBS06 JOBS16)
label values JOBS YN
label variable JOBS "Gvmnt should provide jobs"
drop v36 V25 za69_v21								// cleanup

recode v41 (1 2 = 1) (3 4 = 0) (.=.), gen(UNEM96)	// unemployment
recode V30 (1 2 = 1) (3 4 = 0) (.=.), gen(UNEM06)
recode za69_v26 (1 2 = 1) (3 4 = 0) (else=.), gen(UNEM16)
egen UNEM = rowmax(UNEM96 UNEM06 UNEM16)
label values UNEM YN
label variable UNEM "Gvmnt should provide for unemployed"
drop v41 V30 za69_v26								// cleanup

recode v42 (1 2 = 1) (3 4 = 0) (.=.), gen(RDIS96)	// reduce income differences
recode V31 (1 2 = 1) (3 4 = 0) (.=.), gen(RDIS06)
recode za69_v27 (1 2 = 1) (3 4 = 0) (else=.), gen(RDIS16)
egen RDIS = rowmax(RDIS96 RDIS06 RDIS16)
label values RDIS YN
label variable RDIS "Gvmnt should reduce income differences"
drop v42 V31 za69_v27								// cleanup

recode v39 (1 2 = 1) (3 4 = 0) (.=.), gen(ECAR96)	// provide for elderly
recode V28 (1 2 = 1) (3 4 = 0) (.=.), gen(ECAR06)
recode za69_v24 (1 2 = 1) (3 4 = 0) (else=.), gen(ECAR16)
egen ECAR = rowmax(ECAR96 ECAR06 ECAR16)
label values ECAR YN
label variable ECAR "Gvmnt should provide for the elderly"
drop v39 V28 za69_v24								// cleanup

recode v44 (1 2 = 1) (3 4 = 0) (.=.), gen(HOUS96)	// housing
recode V33 (1 2 = 1) (3 4 = 0) (.=.), gen(HOUS06)
recode za69_v29 (1 2 = 1) (3 4 = 0) (else=.), gen(HOUS16)
egen HOUS = rowmax(HOUS96 HOUS06 HOUS16)
label values HOUS YN
label variable HOUS "Gvmnt should provide decent housing"
drop v44 V33 za69_v29								// cleanup

recode v38 (1 2 = 1) (3 4 = 0) (.=.), gen(HLTH96)	// healthcare
recode V27 (1 2 = 1) (3 4 = 0) (.=.), gen(HLTH06)
recode za69_v23 (1 2 = 1) (3 4 = 0) (else=.), gen(HLTH16)	
egen HLTH = rowmax(HLTH96 HLTH06 HLTH16)
label values HLTH YN
label variable HLTH "Gvmnt should provide healthcare"
drop v38 V27 za69_v23								// cleanup

//--------------- INDEPENDENT VARIABLES (person) ------------------------------

recode AGE (99/1000=.) 			// Age
replace AGE = DK_AGE if AGE == 0
replace AGE = v201 if AGE == .
replace AGE = age if AGE == . 
label variable AGE "Age (yrs)"
gen AGE2 = AGE * AGE
drop v201 age					//	cleanup

egen WOM = rowmax(sex v200 SEX)	// Gender
recode WOM (9=.)
replace WOM = WOM - 1	
label variable WOM "Woman"
label values WOM YN
drop sex v200 SEX				// cleanup

recode MARITAL ///
	(1 2	=	1	"Married")	///		Also including civil union
	(6		=	5	"Never married")	///
	(3 4 	=	3	"Divorced/separated")	///
	(5		=	2	"Widowed")	///
	(else	=	.	)	///
	, gen(M16)

egen MARR = rowmax(v202 marital M16)
recode MARR ///
	(1		=	1	"Married")	///
	(5		=	2	"Never married")	///
	(3 4 	=	3	"Divorced/separated")	///
	(2		=	4	"Widowed")	///
	, gen(MSTAT)

tab MSTAT, gen(MST)
label variable MST1 "Marital status: Married"
label variable MST2 "Marital status: Never married"
label variable MST3 "Marital status: Divorced"
label variable MST4 "Marital status: Widowed"
label values MST? YN
drop MARR M16 v202 marital MARITAL		// cleanup

recode HOMPOP (0 99 = .)				// Household size
egen HHSZ = rowmax(hompop v273 HOMPOP)	
label variable HHSZ "Household size (persons)"
drop HOMPOP hompop v273					// cleanup

// children in household, omitted
drop HHCHILDR HHTODD hhcycle v274	// cleanup

** 	NOTE: B&F codes "incomplete university" (6 in 1996; 4 in 2006) as "secondary education"
recode v205 (5 6 =0) (1/4=1) (7 = 2) (else=.), gen(EDLVL96)	// level of education
recode degree (3 4 =0) (0/2=1) (5 = 2) (else=.), gen(EDLVL06)
recode DEGREE (3 4 =0) (0/2=1) (5/6 = 2) (else=.), gen(EDLVL16)	
egen EDLVL = rowmax(EDLVL96 EDLVL06 EDLVL16)
tab EDLVL, gen(EDL)
label variable EDL1 "Education: secondary"
label variable EDL2 "Education: primary only"
label variable EDL3 "Education: university"
label values EDL? YN
drop EDLV* degree DEGREE v205		// cleanup

// region (omitted)

**	NOTE: B&F codes 4 - helping in family business - as "part-time"
recode MAINSTAT						///	labor market status, 2016
	(1 4	= 	0	"Full time")	///
	(0		=	1	"Part time")	///	
	(2		=	2	"Unemployed")	///
	(3 5/9	= 	3	"Not in labor force")	///
	(else	= 	.						)	///
	, gen(LSTATUS16)	
replace LSTATUS16 = 1 if EMPREL == 4		/// helping with family business considered working

recode WRKHRS							///	30 or more hours fulltime
	(1/29 98	=	1	"Part time")	///
	(30/97		=	0	"Full time")	///
	(99 0 		= 	.				)	///
	if cntry == 208 |	/// Denmark
	cntry == 372 | /// Ireland
	cntry == 826 |	/// UK/GB
	cntry == 578		/// Norway	
	, gen(WSTAT_30)
	
recode WRKHRS							///	36 or more hours fulltime	
	(1/35 98	=	1	"Part time")	///
	(36/97		=	0	"Full time")	///
	(99 0 		= 	.				)	///
	if cntry == 752 |	/// Sweden
	cntry == 250 |	/// France 
	cntry == 554 |	///	New zealand
	cntry == 840 /// USA
	, gen(WSTAT_36)

recode WRKHRS							///	35 or more hours fulltime
	(1/34 98	=	1	"Part time")	///
	(35/97		=	0	"Full time")	///
	(99 0 		= 	.				)	///
	if cntry == 36 |	/// Australia
	cntry == 246 |	/// Finland
	cntry == 276 |	/// Germany (NOTE: not specified)
	cntry == 392 |	/// Japan	
	cntry == 724 |	/// Spain
	cntry == 756	/// Switzerland (NOTE: not specified in earlier codebooks)
	, gen(WSTAT_35)
	
egen WSTAT = rowmax(WSTAT_30 WSTAT_36 WSTAT_35)
	
replace LSTATUS16 = WSTAT if LSTATUS16 == 0 & WSTAT != .

recode v206							///	labor market status, 1996
	(1		=	0	"Full time")	///
	(2/4	=	1	"Part time")	///	
	(5		=	2	"Unemployed")	///
	(6/10	= 	3	"Not in labor force")	///
	, gen(LSTATUS96)	
recode wrkst						///	labor market status, 2006
	(1		=	0	"Full time")	///
	(2/4	=	1	"Part time")	///
	(5		=	2	"Unemployed")	///
	(6/10	= 	3	"Not in labor force")	///
	, gen(LSTATUS06)	
egen LSTATUS = rowmax (LSTATUS96 LSTATUS06 LSTATUS16)

tab LSTATUS, gen(EMP)
label variable EMP1 "Employment: Full-time"
label variable EMP2 "Employment: Part-time"
label variable EMP3 "Employment: Unemployed"
label variable EMP4 "Employment: Not in force"
label values EMP? YN

recode EMPREL	///		self employment
	(2 3	= 	1 	"Yes")	///
	(9 .	=	.		)	///
	(else	=	0	"No")	///
	, gen(SEMP16)

gen SEMP = 1 if v213 == 1 | wrktype == 4 // self employed
recode SEMP (.=0)
replace SEMP = . if LSTATUS == .
replace SEMP = SEMP16 if SEMP == .
label variable SEMP "Self-employed"
label values SEMP YN

drop LSTATUS LSTATUS96 LSTATUS06 LSTATUS16 WSTAT* WRKHRS EMPREL v206 wrkst MAINSTAT

** 	NOTE: B&F uses user-written zscore for standardization, and claims
**	to adjust for household size but 100% correlation with personal calculation
drop BE_INC CL_INC CZ_INC GE_INC HR_INC HU_INC IL_INC IN_INC IS_INC KR_INC ///
	LT_INC LV_INC PH_INC RU_INC SI_INC SK_INC SR_INC TH_INC TR_INC TW_INC ///
	VE_INC ZA_INC
	
recode JP_INC (99999999 = .)
recode AU_INC DK_INC NO_INC (9999997/9999999 = .)
recode CH_INC DE_INC ES_INC FI_INC FR_INC GB_INC NZ_INC SE_INC US_INC (999997/999999 = .)

replace AU_INC = . if cntry != 36
replace CH_INC = . if cntry != 756
replace DE_INC = . if cntry != 276
replace DK_INC = . if cntry != 208
replace ES_INC = . if cntry != 724
replace FI_INC = . if cntry != 246
replace FR_INC = . if cntry != 250 
replace GB_INC = . if cntry != 826
replace JP_INC = . if cntry != 392
replace NO_INC = . if cntry != 578
replace NZ_INC = . if cntry != 554
replace SE_INC = . if cntry != 752
replace US_INC = . if cntry != 840

egen inc = rowmax(*_INC v218)	// standardized family income by country

egen mean_inc96 = mean(inc) if year == 1996, by(cntry)	
egen mean_inc06 = mean(inc) if year == 2006, by(cntry)
egen mean_inc16 = mean(inc) if year == 2016, by(cntry)
egen mean_inc = rowmax(mean_inc96 mean_inc06 mean_inc16)

egen sd_inc96 = sd(inc) if year == 1996, by(cntry)
egen sd_inc06 = sd(inc) if year == 2006, by(cntry)
egen sd_inc16 = sd(inc) if year == 2016, by(cntry)
egen sd_inc = rowmax(sd_inc96 sd_inc06 sd_inc16)

gen ZINC = (inc - mean_inc) / sd_inc
drop inc mean_in* sd_in* *_INC v218							// cleanup

recode v220 (6=0) (5=1) (1/4 = 2) (else=.), gen(REL96)		// religious attendance
recode attend (8=0) (6 7=1) (1/5 = 2) (else=.), gen(REL06)	
recode ATTEND (8=0) (6 7=1) (1/5 = 2) (else=.), gen(REL16)	
egen REL = rowmax(REL96 REL06 REL16)
tab REL, gen(RATT)
label variable RATT1 "Religious attendance: none"
label variable RATT2 "Religious attendance: low"
label variable RATT3 "Religious attendance: high"
label values RATT? YN

drop REL* v220 attend ATTEND								// cleanup

egen WT = rowmax(weight v325 WEIGHT)	// weight

************************ ETHNICITY ********************************************
// 1996
recode v324	///
	(1 3 5 6 8 11 12 15 16 17 19 20 23 24 25 26 40 42 43 44/47 51 54 56	///
	57 62/66 70/75 77/79 84/87 89 91 18 27 92 95 98		=	1 	"minority")	///
	(4 9 10 14 21 28 29 30 31 32 34 35 36 38 39 41 48 49 50 53 58/61 	///
	68 69 76 80 81 82/83 88 90 94 96				=	0 	"majority")	///
	(else											=	9	"unknown")	///
	, gen(ethn_96)
replace ethn_96 = . if cntry == 250 | cntry == 372 | cntry == 392 | ///
	cntry == 554 | cntry == 578 | cntry == 724	
replace ethn_96 = . if year != 1996

// 2006
recode ethnic	///
	(1 3 5 6 8 11 15 16 17 20 23 24 25 40 43 44/47	///
	54 57 62/66 70/75 77/79 82.2 84/87 89 91 96 18 27 95 98		=	1 	"minority")	///
	(10 14 21 30 31 32 34 35 36 38 39 41 48 49 50 53 58/61 	///
	68 69 76 80 81 82 82.1 83 88 90 94				=	0 	"majority")	///
	(else											=	9	"unknown")	///
	, gen(ethn_06)
replace ethn_06 = . if cntry == 36 | cntry == 208 | cntry == 250 | ///
	cntry == 372 | cntry == 578 | cntry == 724 | cntry == 756 | cntry == 826	
replace ethn_06 = . if year != 2006

// 2016
gen country = cntry

* Ethnicity
gen ethnicity=.
label define ethnicity 0 "0 Majority" 1 "1 Minority" 9 "9 Unknown", replace
label values ethnicity ethnicity

* Ethnicity: Australia
replace ethnicity=0 if AU_ETHN1==1 | AU_ETHN1==2 | AU_ETHN1==3
replace ethnicity=1 if AU_ETHN1>3 & AU_ETHN1<99
replace ethnicity=9 if AU_ETHN1==99

* Ethnicity: Belgium

* Ethnicity: Canda

* Ethnicity: Switzerland

* Ethnicity: Germany
replace ethnicity=1 if DE_ETHN1>0 & DE_ETHN1<.
replace ethnicity=0 if DE_ETHN1==276
replace ethnicity=9 if DE_ETHN1==996 | DE_ETHN1==999

* Ethnicity: Denmark
replace ethnicity=0 if DK_ETHN1==1
replace ethnicity=1 if DK_ETHN1==2 | DK_ETHN1==3 | DK_ETHN1==4 | (DK_ETHN1==99 & DK_ETHN2==1) | (DK_ETHN1==99 & DK_ETHN2==3)
replace ethnicity=9 if DK_ETHN1==98 | (DK_ETHN1==99 & DK_ETHN2==99)

* Ethnicity: Spain

* Ethnicity: Finland
replace ethnicity=0 if FI_ETHN1==1 | FI_ETHN1==2
replace ethnicity=1 if (FI_ETHN1>=3 & FI_ETHN1<99)
replace ethnicity=9 if FI_ETHN1==99

* Ethnicity: France
replace ethnicity=1 if FR_ETHN1>0 & FR_ETHN1<99
replace ethnicity=0 if FR_ETHN1==5
replace ethnicity=9 if FR_ETHN1==99

* Ethnicity: UK
replace ethnicity=1 if GB_ETHN1>0
replace ethnicity=0 if GB_ETHN1==9

* Ethnicity: Iceland
replace ethnicity=0 if IS_ETHN1==2
replace ethnicity=1 if IS_ETHN1==1
replace ethnicity=9 if IS_ETHN1==99

* Ehnicity: Ireland

* Ethnicity: Japan
replace ethnicity=0 if JP_ETHN1==1
replace ethnicity=1 if JP_ETHN1==2
replace ethnicity=9 if JP_ETHN1==99

* Ethnicity: Netherlands

* Ethnicity: Norway
replace ethnicity=0 if NO_ETHN1==1 | (NO_ETHN1==99 & NO_ETHN2==1)
replace ethnicity=1 if NO_ETHN1>1 & NO_ETHN1<99 | (NO_ETHN1==99 & NO_ETHN2>1 & NO_ETHN2<99)
replace ethnicity=9 if NO_ETHN1==99 & NO_ETHN2==99

* Ethnicity: New Zealand
replace ethnicity=1 if NZ_ETHN1>0 & NZ_ETHN1<99
replace ethnicity=0 if NZ_ETHN1==2
replace ethnicity=9 if NZ_ETHN1==99

* Ethnicity: Sweden
replace ethnicity=1 if SE_ETHN1>0 & SE_ETHN1<9999
replace ethnicity=0 if SE_ETHN1==752
replace ethnicity=9 if SE_ETHN1==9999

* Ethnicity: USA
replace ethnicity=0 if inlist(US_ETHN1,3,4,6,7,8,9,10,11,12,13,14,15,16,17,18,19,21,22,24,25,26,27,32,36,96)
replace ethnicity=1 if inlist(US_ETHN1,1,5,20,23,28,29,30,31,33,34,35,37,38,39,40,41)
replace ethnicity=9 if inlist(US_ETHN1,98,99)

replace ethnicity = . if year != 2016

egen MIG = rowmax(ethnicity ethn_96 ethn_06)

drop country

//--------------------- INDEPENDENT VARIABLES (country) ------------------------

merge m:1 cntry year using countrydata_52.dta, keep(matched)

ren fbstock		 	foreignpct		
ren fbmig			netmig			
ren socx_oecd		socx			
ren wdi_empprilo	emprate			
ren noecdstock		nonoecdstock	
ren noecdmig		nonoecdmig

label variable foreignpct "Percent foreign born"
label variable oecdstock "Percent foreign born, OECD"
label variable nonoecdstock "Percent foreign born, non-OECD"
label variable netmig "Net migration, points"
label variable oecdmig "Net migration from OECD, points"
label variable nonoecdmig "Net migration from non-OECD, points"
label variable socx	"Welfare spendings"
label variable socdem "Welfare regime: Social dem"		// not used here
label variable liberal "Welfare regime: Liberal"
label variable emprate "Employment rate"

save cri_extension, replace


//--------------------- ANALYSIS -------------------------------

use cri_extension, clear
drop if missing(AGE, AGE2, WOM, EDL2, ZINC, EMP2, SEMP, cntry, year, ///
	foreignpct, socx, emprate, JOBS, UNEM, RDIS, ECAR, HOUS, HLTH)	// NOTE: run to include only observations w/o missing

// TABLE 4 - Extended replication
global z AGE AGE2 WOM EDL2 EDL3 ZINC EMP2 EMP3 EMP4 SEMP i.cntry i.year
global x3 foreignpct emprate

qui logit JOBS $x3 $z if socx != . , or
margins, dydx (foreignpct) saving ("t52m1",replace)

qui logit UNEM $x3 $z if socx != . , or
margins, dydx( foreignpct) saving ("t52m2",replace)

qui logit RDIS $x3 $z if socx != . , or
margins, dydx( foreignpct) saving ("t52m3",replace)

qui logit ECAR $x3 $z if socx != . , or
margins, dydx( foreignpct) saving ("t52m4",replace)

qui logit HOUS $x3 $z if socx != . , or
margins, dydx( foreignpct) saving ("t52m5",replace)

qui logit HLTH $x3 $z if socx != . , or
margins, dydx( foreignpct) saving ("t52m6",replace)

	
// TABLE 5 - Extended replication, flow
drop if missing(AGE, AGE2, WOM, EDL2, ZINC, EMP2, SEMP, cntry, year, ///
	netmig, foreignpct, socx, emprate, JOBS, UNEM, RDIS, ECAR, HOUS, HLTH)	// NOTE: run to include only observations w/o missing	
drop if cntry == 276 | cntry == 554 | cntry == 826

global x4 netmig foreignpct
*PI adjustment
replace netmig=netmig/10
//

qui logit JOBS $x4 $z , or
margins, dydx( netmig) saving ("t52m7",replace)

qui logit UNEM $x4 $z, or
margins, dydx( netmig) saving ("t52m8",replace)

qui logit RDIS $x4 $z, or
margins, dydx( netmig) saving ("t52m9",replace)

qui logit ECAR $x4 $z , or
margins, dydx( netmig) saving ("t52m10",replace)
 
qui logit HOUS $x4 $z, or
margins, dydx( netmig) saving ("t52m11",replace)

qui logit HLTH $x4 $z, or
margins, dydx( netmig) saving ("t52m12",replace)



//--------------------- EXTENSION of ANALYSIS -------------------------------

use cri_extension, clear

drop if missing(AGE, AGE2, WOM, EDL2, ZINC, EMP2, SEMP, cntry, year, ///
	oecdstock, nonoecdstock, socx, emprate, JOBS, UNEM, RDIS, ECAR, HOUS, HLTH)	// NOTE: run to include only observations w/o missing
drop if cntry == 372

// TABLE 4 - Extension
global z AGE AGE2 WOM EDL2 EDL3 ZINC EMP2 EMP3 EMP4 SEMP i.cntry i.year
global x3 oecdstock nonoecdstock emprate

qui logit JOBS $x3 $z if socx != . , or
margins, dydx(oecdstock) saving ("t52m13",replace)
margins, dydx(nonoecdstock) saving ("t52m19",replace)
qui logit UNEM $x3 $z if socx != . , or
margins, dydx(oecdstock) saving ("t52m14",replace)
margins, dydx(nonoecdstock) saving ("t52m20",replace)
qui logit RDIS $x3 $z if socx != . , or
margins, dydx(oecdstock) saving ("t52m15",replace)
margins, dydx(nonoecdstock) saving ("t52m21",replace)
qui logit ECAR $x3 $z if socx != . , or
margins, dydx(oecdstock) saving ("t52m16",replace)
margins, dydx(nonoecdstock) saving ("t52m22",replace)
qui logit HOUS $x3 $z if socx != . , or
margins, dydx(oecdstock) saving ("t52m17",replace)
margins, dydx(nonoecdstock) saving ("t52m23",replace)
qui logit HLTH $x3 $z if socx != . , or
margins, dydx(oecdstock) saving ("t52m18",replace)
margins, dydx(nonoecdstock) saving ("t52m24",replace)
	
// TABLE 5 - Extended replication
use cri_extension, clear
drop if missing(AGE, AGE2, WOM, EDL2, ZINC, EMP2, SEMP, cntry, year, ///
	oecdmig, nonoecdmig, oecdstock, nonoecdstock, socx, emprate, JOBS, UNEM, RDIS, ECAR, HOUS, HLTH)	// NOTE: run to include only observations w/o missing
drop if cntry == 276 | cntry == 554 | cntry == 826
*PI adjustment
replace oecdmig=oecdmig/10
replace nonoecdmig=nonoecdmig/10
//

global x4 oecdmig nonoecdmig oecdstock nonoecdstock

qui logit JOBS $x4 $z , or
margins, dydx(oecdmig) saving ("t52m25",replace)
margins, dydx(nonoecdmig) saving ("t52m31",replace)
qui logit UNEM $x4 $z, or
margins, dydx(oecdmig) saving ("t52m26",replace)
margins, dydx(nonoecdmig) saving ("t52m32",replace)
qui logit RDIS $x4 $z, or
margins, dydx(oecdmig) saving ("t52m27",replace)
margins, dydx(nonoecdmig) saving ("t52m33",replace)
qui logit ECAR $x4 $z , or
margins, dydx(oecdmig) saving ("t52m28",replace)
margins, dydx(nonoecdmig) saving ("t52m34",replace)
qui logit HOUS $x4 $z, or
margins, dydx(oecdmig) saving ("t52m29",replace)
margins, dydx(nonoecdmig) saving ("t52m35",replace)
qui logit HLTH $x4 $z, or
margins, dydx(oecdmig) saving ("t52m30",replace)
margins, dydx(nonoecdmig) saving ("t52m36",replace)

use t52m1,clear
foreach x of numlist 2/36 {
append using t52m`x'
}
gen f=[_n]
gen factor = "Immigrant Stock" if f<7
replace factor = "Immigrant Flow, 1-year" if f>6&f<13
replace factor = "Western Immigrant Stock" if f>12&f<19
replace factor = "Non-Western Immigrant Stock" if f>18&f<25
replace factor = "Western Immigrant Flow, 1-year" if f>24&f<31
replace factor = "Non-Western Immigrant Flow, 1-year" if f>30

gen id = "t52m1"
foreach x of numlist 2/36 {
replace id = "t52m`x'" if f==`x'
}

clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
order factor AME lower upper id
keep factor AME lower upper id
save team52, replace

foreach i of numlist 1/36 {
erase "t52m`i'.dta"
}
erase cri_extension.dta
}
*==============================================================================*
*==============================================================================*
*==============================================================================*


























// TEAM 54
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team54.dta"
  if _rc==0   {
    display "Team 54 already exists, skipping to next code chunk"
  }
  else {
  
version 15
use "cri_macro.dta", clear

//using UN data because available for 1980s although not perfectly comparable
rename migstock_un foreignpct
rename mignet_un netmigpct
rename wdi_empprilo emprate
rename socx_oecd socx

foreach x of varlist _all  {
gen `x'miss=0
capture confirm string var `x'
if _rc==0 {
replace `x'miss=1 if `x'=="" 
         }
else {
replace `x'miss=1 if `x'==. 
}
}

//pushing forward netmigpct for 2016 data as 2016 data all missing
encode country, gen(c)
xtset c year
destring netmigpct, replace
replace netmigpct=l.netmigpct if year==2016
drop c

save "l2clean.dta", replace

use "ZA1490.dta", clear

decode V3, gen (country)

rename V2 id

* Check all of these *

replace country="United States" if country=="usa"
replace country="Australia" if country=="aus"
replace country="United Kingdom" if country=="gb"
replace country="Austria" if country=="a"
replace country="Italy" if country=="i"
replace country="Germany" if country=="d"

gen year=1985

* elderly
rename V104 elderly
label variable elderly "Old Age Care"
* unemployed
rename V106 unemployed  
label variable unemployed "Unemployed"

* reduce income differences
rename V107 ReduceIncDiff
label variable ReduceIncDiff "Reduce Income Differences"

* provide jobs
rename V101 jobs
label variable jobs "Jobs"

codebook jobs



* coding probably should and definitely should as "affirmative answers"
label define supportgov 1 "Support" 0 "Oppose"

foreach x in elderly unemployed ReduceIncDiff jobs {
gen `x'NotDummy = `x'
recode `x' 3/4=0 1/2=1
label values `x' supportgov
}

recode V118 1=0  2=1, into(Female)

rename V117 age
gen agesq = age * age

//inconsistent levels of education in each country so that codes aren't equivalent.
gen education=.
la def education 1 "Primary or lower" 
la def education 2 "Secondary", add
la def education 3 "University or higher", add
la val education education

replace education=1 if country=="Australia" & inlist(V123,1, 2)
replace education=2 if country=="Australia" & inlist(V123, 3, 4, 5, 6)
replace education=3 if country=="Australia" & inlist(V123, 7, 8)

replace education=1 if country=="Austria" & inlist(V123, 3, 4)
replace education=2 if country=="Austria" & inlist(V123, 5, 6, 7)
replace education=3 if country=="Austria" & inlist(V123, 8)

replace education=1 if country=="Germany" & inlist(V123, 1, 3)
replace education=2 if country=="Germany" & inlist(V123, 4 ,5 ,6)
replace education=3 if country=="Germany" & inlist(V123, 7)

replace education=1 if country=="Italy" & inlist(V123,1, 2, 3)
replace education=2 if country=="Italy" & inlist(V123,4, 5, 6, 7)
replace education=3 if country=="Italy" & inlist(V123,8,9)

replace education=1 if country=="United Kingdom" & inlist(V123,3)
replace education=2 if country=="United Kingdom" & inlist(V123, 4, 5, 6, 7, 9)
replace education=3 if country=="United Kingdom" & inlist(V123,8)

replace education=1 if country=="United States" & inlist(V123, 1, 2)
replace education=2 if country=="United States" & inlist(V123, 3, 4)
replace education=3 if country=="United States" & inlist(V123,5, 6)

recode V109 1=3 2=4 .=2, into(workstatus)
replace workstatus=1 if V109==2 & V108<35

label define workstat 1 "Part-time" 2 "Not active" 3 "Active unemployed" 4 "Full time"
label values workstatus workstat

//

rename V141 weight

//adding two extra controls that were omitted from the replication instructions
recode V112 (1/2=1 "Self-employed") (3 .=0 "Employee/inactive/unemployed"), into(selfemployed)

//Brady et al on relative income is just standardized income i.e. z-score
egen mean = mean(V128), by(country)
egen z = sd(V128), by(country)
replace z = (V128 - mean) / z
rename z relativeinc

keep  id age agesq Female elderly unemployed ReduceIncDiff jobs year country ///
	education workstatus weight elderlyNotDummy unemployedNotDummy ReduceIncDiffNotDummy ///
	jobsNotDummy selfemployed relativeinc

save "cleanissp1985.dta", replace

use "ZA1950.dta", clear

decode v3, gen (country)

rename v2 id

* Check all of these *

replace country="Germany" if country=="D-E" | country=="D-W"
replace country="Israel" if country=="il"
replace country="Ireland" if country=="irl"
replace country="Hungary" if country=="h"
replace country="United States" if country=="usa"
replace country="Australia" if country=="aus"
replace country="United Kingdom" if country=="gb" |country=="nirl"
replace country="Italy" if country=="i"
replace country="Norway" if country=="n"

tab country

gen year=1990

* elderly
rename v52 elderly
label variable elderly "Old Age Care"
* unemployed
rename v54 unemployed
label variable unemployed "Unemployed"

* reduce income differences
rename v55 ReduceIncDiff
label variable ReduceIncDiff "Reduce Income Differences"

* provide jobs
rename v49 jobs
label variable jobs "Jobs"

codebook jobs


* coding probably should and definitely should as "affirmative answers"
label define supportgov 1 "Support" 0 "Oppose"

foreach x in elderly unemployed ReduceIncDiff jobs {
gen `x'NotDummy = `x'
recode `x' 3/4=0 1/2=1
label values `x' supportgov
}

recode v59 1=0  2=1, into(Female)

rename v60 age
gen agesq = age * age

//tnb have assumed the coding is standardized by 1990 on education variable as too hard to check at the moment
recode v81 1/3=1 4/5=2 6/7=3, into(education)
label define ed 1 "Primary or lower" 2 "Secondary" 3 "University or higher"
label values education ed

recode v63 1=4 2=1 3=1 4=2 5=3 6=2 7=2 8=2 9=2 10=2 99=., into(workstatus)

label define workstat 1 "Part-time" 2 "Not active" 3 "Active unemployed" 4 "Full time"
label values workstatus workstat
tab v63 workstatus 

rename v114 weight

//adding two extra controls that were omitted from the replication instructions
recode v72 (1=1 "Self-employed") (2 9 .=0 "Employee/inactive/unemployed"), into(selfemployed)

//Brady et al on relative income is just standardized income i.e. z-score
egen mean = mean(v100), by(country)
egen z = sd(v100), by(country)
replace z = (v100 - mean) / z
rename z relativeinc

keep  id age agesq Female elderly unemployed ReduceIncDiff jobs year country ///
	education workstatus weight elderlyNotDummy unemployedNotDummy ReduceIncDiffNotDummy ///
	jobsNotDummy selfemployed relativeinc


save "cleanissp1990.dta", replace

use "ZA2900.dta", clear

decode v3, gen (country)

rename v2 id

* Check all of these *

replace country="Germany" if country=="D-E" | country=="D-W"
replace country="Israel" if country=="IL-A" | country=="IL-J"
replace country="Ireland" if country=="irl"
replace country="New Zealand" if country=="nz"
replace country="Poland" if country=="pl"
replace country="United States" if country=="usa"
replace country="Australia" if country=="aus"
replace country="Russia" if country=="rus"
replace country="Czech Republic" if country=="cz"
replace country="United Kingdom" if country=="gb"
replace country="Slovenia" if country=="slo"
replace country="Latvia" if country=="lv"
replace country="Bulgaria" if country=="bg"
replace country="Canada" if country=="cdn"
replace country="Switzerland" if country=="ch"
replace country="Spain" if country=="e"
replace country="France" if country=="f"
replace country="Hungary" if country=="h"
replace country="Italy" if country=="i"
replace country="Japan" if country=="j"
replace country="Norway" if country=="n"
replace country="Philippines" if country=="rp"
replace country="Sweden" if country=="s"
replace country="Cyprus" if country=="cy"

gen year=1996

* elderly
rename v39 elderly
label variable elderly "Old Age Care"
* unemployed
rename v41 unemployed
label variable unemployed "Unemployed"

* reduce income differences
rename v42 ReduceIncDiff
label variable ReduceIncDiff "Reduce Income Differences"

* provide jobs
rename v36 jobs
label variable jobs "Jobs"

codebook jobs

* coding probably should and definitely should as "affirmative answers"
label define supportgov 1 "Support" 0 "Oppose"

foreach x in elderly unemployed ReduceIncDiff jobs {
gen `x'NotDummy = `x'
recode `x' 3/4=0 1/2=1
label values `x' supportgov
}

recode v200 1=0  2=1, into(Female)

rename v201 age
gen agesq = age * age


recode v205 1/3=1 4/5=2 6/7=3, into(education)
label define ed 1 "Primary or lower" 2 "Secondary" 3 "University or higher"
label values education ed


recode v206 1=4 2=1 3=1 4=2 5=3 6=2 7=2 8=2 9=2 10=2 99=., into(workstatus)

label define workstat 1 "Part-time" 2 "Not active" 3 "Active unemployed" 4 "Full time"
label values workstatus workstat

rename v325 weight

//adding two extra controls that were omitted from the replication instructions
recode v213 (1=1 "Self-employed") (2 .=0 "Employee/inactive/unemployed"), into(selfemployed)

//Brady et al on relative income is just standardized income i.e. z-score
egen mean = mean(v218), by(country)
egen z = sd(v218), by(country)
replace z = (v218 - mean) / z
rename z relativeinc

keep  id age agesq Female elderly unemployed ReduceIncDiff jobs year country ///
	education workstatus weight elderlyNotDummy unemployedNotDummy ReduceIncDiffNotDummy ///
	jobsNotDummy selfemployed relativeinc


save "cleanissp1996.dta", replace

* 2006

use "ZA4700.dta", clear

decode V3a, gen (country)

* make a unique ID number
duplicates report V2

codebook country
replace country = "Australia" if country=="AU-Australia"
replace country = "Canada" if country=="CA-Canada"
replace country = "Switzerland" if country=="CH-Switzerland"
replace country = "Chile" if country=="CL-Chile"
replace country = "Czech Republic" if country=="CZ-Czech Republic"
replace country = "Denmark" if country=="DK-Denmark"
replace country = "Dominican Republic" if country=="DO-Dominican Republic"
replace country = "Spain" if country=="ES-Spain"
replace country = "Finland" if country=="FI-Finland"
replace country = "France" if country=="FR-France"
replace country = "Croatia" if country=="HR-Croatia"
replace country = "Hungary" if country=="HU-Hungary"
replace country = "Ireland" if country=="IE-Ireland"
replace country = "Japan" if country=="JP-Japan"
replace country = "South Korea" if country=="KR-South Korea"
replace country = "Latvia" if country=="LV-Latvia"
replace country = "Netherlands" if country=="NL-Netherlands"
replace country = "Norway" if country=="NO-Norway"
replace country = "New Zealand" if country=="NZ-New Zealand"
replace country = "Philippines" if country=="PH-Philippines"
replace country = "Poland" if country=="PL-Poland"
replace country = "Portugal" if country=="PT-Portugal"
replace country = "Russia" if country=="RU-Russia"
replace country = "Sweden" if country=="SE-Sweden"
replace country = "Slovenia" if country=="SI-Slovenia"
replace country = "Taiwan" if country=="TW-Taiwan"
replace country = "United States" if country=="US-United States"
replace country = "Uruguay" if country=="UY-Uruguay"
replace country = "Venezuela" if country=="VE-Venezuela"
replace country = "South Africa" if country=="ZA-South Africa"
replace country = "United Kingdom" if country=="GB-Great Britain"
replace country = "Germany" if country=="DE-Germany"
replace country = "Israel" if country=="IL-Israel"


gen year = 2006

* elderly
rename V28 elderly
label variable elderly "Old Age Care"
* unemployed
rename V30 unemployed
label variable unemployed "Unemployed"

* reduce income differences
rename V31 ReduceIncDiff
label variable ReduceIncDiff "Reduce Income Differences"

* provide jobs
rename V25 jobs
label variable jobs "Jobs"



* coding probably should and definitely should as "affirmative answers"
label define supportgov 1 "Support" 0 "Oppose"

foreach x in elderly unemployed ReduceIncDiff jobs {
gen `x'NotDummy = `x'
recode `x' 3/4=0 1/2=1
label values `x' supportgov
}

recode sex 1=0  2=1, into(Female)

gen agesq = age * age

recode degree 0/1=1 2/3=2 4/5=3, into(education)
label define ed 1 "Primary or lower" 2 "Secondary" 3 "University or higher"
label values education ed

recode wrkst 1=4 2=1 3=1 4=2 5=3 6=2 7=2 8=2 9=2 10=2 97/99=., into(workstatus)

label define workstat 1 "Part-time" 2 "Not active" 3 "Active unemployed" 4 "Full time"
label values workstatus workstat

gen id = _n

//adding two extra controls that were omitted from the replication instructions
recode wrktype (4=1 "Self-employed") (1/3 5 .=0 "Employee/inactive/unemployed"), into(selfemployed)

//Brady et al on relative income is just standardized income i.e. z-score
gen income=.
local incvars "AU_INC CA_INC CH_INC CL_INC CZ_INC DE_INC DK_INC DO_INC ES_INC FI_INC FR_INC GB_INC HR_INC HU_INC IE_INC IL_INC JP_INC KR_INC LV_INC NL_INC NO_INC NZ_INC PH_INC PL_INC PT_INC RU_INC SE_INC SI_INC TW_INC US_INC UY_INC VE_INC ZA_INC"
foreach i in `incvars' {
replace income=`i' if income==.
}
*

egen mean = mean(income), by(country)
egen z = sd(income), by(country)
replace z = (income - mean) / z
rename z relativeinc

keep  age agesq Female elderly unemployed ReduceIncDiff jobs year country ///
	education workstatus weight elderlyNotDummy unemployedNotDummy ReduceIncDiffNotDummy ///
	jobsNotDummy selfemployed relativeinc

save "cleanissp2006.dta", replace

use "ZA6900_v2-0-0.dta", clear

rename country COUNTRY
gen country=""

rename CASEID id

* Check all of these *
codebook country
replace country = "Australia" if COUNTRY==36
replace country = "Switzerland" if COUNTRY==756
replace country = "Chile" if COUNTRY==152
replace country = "Czech Republic" if COUNTRY==203
replace country = "Denmark" if COUNTRY==208
replace country = "Spain" if COUNTRY==724
replace country = "Finland" if COUNTRY==246
replace country = "France" if COUNTRY==250
replace country = "Croatia" if COUNTRY==191
replace country = "Hungary" if COUNTRY==348
replace country = "Japan" if COUNTRY==392
replace country = "Latvia" if COUNTRY==428
replace country = "Norway" if COUNTRY==578
replace country = "New Zealand" if COUNTRY==554
replace country = "Philippines" if COUNTRY==608
replace country = "Russia" if COUNTRY==643
replace country = "Sweden" if COUNTRY==752
replace country = "Slovenia" if COUNTRY==705
replace country = "United States" if COUNTRY==840
replace country = "Venezuela" if COUNTRY==862
replace country = "South Africa" if COUNTRY==710
replace country = "United Kingdom" if COUNTRY==826
replace country = "Germany" if COUNTRY==276
replace country = "Israel" if COUNTRY==376
replace country = "Belgium" if COUNTRY==56
replace country = "Taiwan" if COUNTRY==158
replace country = "Georgia" if COUNTRY==268
replace country = "Iceland" if COUNTRY==352
replace country = "India" if COUNTRY==356
replace country = "South Korea" if COUNTRY==410
replace country = "Lithuania" if COUNTRY==440
replace country = "Slovakia" if COUNTRY==703
replace country = "Suriname" if COUNTRY==740
replace country = "Thailand" if COUNTRY==764
replace country = "Turkey" if COUNTRY==792

ta COUNTRY if country==""
tab country

gen year=2016

* elderly
rename v24 elderly
label variable elderly "Old Age Care"
* unemployed
rename v26 unemployed
label variable unemployed "Unemployed"

* reduce income differences
rename v27 ReduceIncDiff
label variable ReduceIncDiff "Reduce Income Differences"

* provide jobs
rename v21 jobs
label variable jobs "Jobs"

codebook jobs

//in 2016 they added a can't choose option, here it's recoded 8to missing

* coding probably should and definitely should as "affirmative answers"
label define supportgov 1 "Support" 0 "Oppose"

foreach x in elderly unemployed ReduceIncDiff jobs {
gen `x'NotDummy = `x'
recode `x' 3/4=0 1/2=1 8/9=.
label values `x' supportgov
}

recode SEX 1=0  2=1 9=., into(Female)

rename AGE age
recode age (0 999=.)
gen agesq = age * age

//need to do this by country specific education variables
gen education=.
replace education=1 if AU_DEGR==1
replace education=2 if inlist(AU_DEGR, 2, 3, 4, 5)
replace education=3 if inlist(AU_DEGR, 6, 7)
replace education=1 if inlist(CH_DEGR, 1, 2)
replace education=2 if inlist(CH_DEGR, 3, 4, 5, 6, 7, 8, 10, 11, 12, 13, 14, 15, 16)
replace education=3 if inlist(CH_DEGR, 17, 18, 19, 20, 21, 22, 23)
replace education=1 if inlist(CL_DEGR, 1, 2, 3)
replace education=2 if inlist(CL_DEGR, 4, 5, 6, 7)
replace education=3 if inlist(CL_DEGR, 8, 9, 10)
replace education=1 if inlist(CZ_DEGR, 1, 2)
replace education=2 if inlist(CZ_DEGR, 3, 4, 5, 6, 7, 8)
replace education=3 if inlist(CZ_DEGR, 9, 10 11)
replace education=1 if inlist(DK_DEGR, 1, 2, 3)
replace education=2 if inlist(DK_DEGR, 4, 5, 6, 7, 8, 9, 13)
replace education=3 if inlist(DK_DEGR, 10, 11, 12)
replace education=1 if inlist(ES_DEGR , 1, 2, 3, 4, 5, 6)
replace education=2 if inlist(ES_DEGR , 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 21, 22, 23)
replace education=3 if inlist(ES_DEGR , 24, 25, 26, 27)
replace education=1 if inlist(FI_DEGR, 1, 2)
replace education=2 if inlist(FI_DEGR, 3, 4, 5, 6)
replace education=3 if inlist(FI_DEGR, 7, 8, 9)
replace education=1 if inlist(FR_DEGR, 1, 2)
replace education=2 if inlist(FR_DEGR, 3, 4, 5, 6, 78)
replace education=3 if inlist(FR_DEGR, 9, 10)
replace education=1 if inlist(HR_DEGR, 1, 2)
replace education=2 if inlist(HR_DEGR, 3, 4, 5, 6)
replace education=3 if inlist(HR_DEGR, 7)
replace education=1 if inlist(HU_DEGR, 1, 2)
replace education=2 if inlist(HU_DEGR, 3, 4, 5, 6)
replace education=3 if inlist(HU_DEGR, 7, 8, 9)
replace education=1 if inlist(JP_DEGR, 1)
replace education=2 if inlist(JP_DEGR, 2, 3)
replace education=3 if inlist(JP_DEGR, 4, 5, 6, 7)
replace education=1 if inlist(LV_DEGR , 1, 2)
replace education=2 if inlist(LV_DEGR ,3, 4, 5)
replace education=3 if inlist(LV_DEGR , 6, 7)
replace education=1 if inlist(NO_DEGR, 1, 2)
replace education=2 if inlist(NO_DEGR, 3, 4, 5, 6)
replace education=3 if inlist(NO_DEGR, 7, 8, 9)
replace education=1 if inlist(NZ_DEGR , 1, 2, 3)
replace education=2 if inlist(NZ_DEGR , 4, 5, 6)
replace education=3 if inlist(NZ_DEGR , 7, 8)
replace education=1 if inlist(PH_DEGR, 1, 2, 3)
replace education=2 if inlist(PH_DEGR, 4, 4, 6, 7)
replace education=3 if inlist(PH_DEGR, 8, 9, 10)
replace education=1 if inlist(RU_DEGR, 1)
replace education=2 if inlist(RU_DEGR, 2, 3, 4, 5, 6)
replace education=3 if inlist(RU_DEGR, 7, 8, 9)
replace education=1 if inlist(SE_DEGR, 1, 2, 3)
replace education=2 if inlist(SE_DEGR, 4, 5, 6, 7, 8, 9)
replace education=3 if inlist(SE_DEGR, 10, 11, 12, 13)
replace education=1 if inlist(SI_DEGR , 1, 2, 3)
replace education=2 if inlist(SI_DEGR , 4, 5, 6)
replace education=3 if inlist(SI_DEGR , 7, 8, 9, 10, 11, 12)
replace education=1 if inlist(US_DEGR, 1)
replace education=2 if inlist(US_DEGR, 2)
replace education=3 if inlist(US_DEGR, 3, 4, 5)
replace education=1 if inlist(VE_DEGR, 1, 2, 3)
replace education=2 if inlist(VE_DEGR, 4, 5, 6, 7, 8, 9)
replace education=3 if inlist(VE_DEGR, 10, 11, 12, 13, 14, 15)
replace education=1 if inlist(ZA_DEGR, 1, 2, 3, 4, 5, 6, 7, 8, 9)
replace education=2 if inlist(ZA_DEGR, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21)
replace education=3 if inlist(ZA_DEGR, 22, 23, 24, 25, 26, 27)
replace education=1 if inlist(GB_DEGR, 1)
replace education=2 if inlist(GB_DEGR, 2, 3, 4, 5)
replace education=3 if inlist(GB_DEGR, 6)
replace education=1 if inlist(DE_DEGR, 1, 2, 3)
replace education=2 if inlist(DE_DEGR, 4, 5, 6, 7)
replace education=3 if inlist(DE_DEGR, 8, 9, 10, 11, 12, 13, 14)
replace education=1 if inlist(IL_DEGR, 1, 2)
replace education=2 if inlist(IL_DEGR, 3, 4, 5, 6, 7, 8, 10)
replace education=3 if inlist(IL_DEGR, 11, 12, 13, 14)
replace education=1 if inlist(BE_DEGR, 1, 2)
replace education=2 if inlist(BE_DEGR, 3, 4, 5, 6, 7, 8, 9, 10)
replace education=3 if inlist(BE_DEGR, 11, 12, 13, 14)
replace education=1 if inlist(TW_DEGR, 1, 2, 3)
replace education=2 if inlist(TW_DEGR, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17)
replace education=3 if inlist(TW_DEGR, 18, 19, 20, 21)
replace education=1 if inlist(GE_DEGR, 1, 2)
replace education=2 if inlist(GE_DEGR, 3)
replace education=3 if inlist(GE_DEGR, 4, 5, 6, 7)
replace education=1 if inlist(IS_DEGR, 1, 2, 3)
replace education=2 if inlist(IS_DEGR, 4, 5, 6, 7, 8, 9)
replace education=3 if inlist(IS_DEGR, 10, 11, 12, 13, 14, 15, 16, 17)
replace education=1 if inlist(IN_DEGR, 1, 2, 3, 4)
replace education=2 if inlist(IN_DEGR, 5, 6)
replace education=3 if inlist(IN_DEGR, 7, 8, 9)
replace education=1 if inlist(KR_DEGR, 1, 2, 3)
replace education=2 if inlist(KR_DEGR, 4, 5, 6, 7, 8, 9)
replace education=3 if inlist(KR_DEGR, 10, 11, 12, 13, 14, 15)
replace education=1 if inlist(LT_DEGR, 1, 2, 3)
replace education=2 if inlist(LT_DEGR, 4, 5, 6, 7, 8, 9, 10)
replace education=3 if inlist(LT_DEGR, 11, 12, 13, 14, 15, 16, 17)
replace education=1 if inlist(SK_DEGR, 1, 2)
replace education=2 if inlist(SK_DEGR, 3, 4, 5, 6, 7, 8, 9)
replace education=3 if inlist(SK_DEGR, 10, 11, 12)
replace education=1 if inlist(SR_DEGR, 1, 2, 3)
replace education=2 if inlist(SR_DEGR, 4, 5, 6, 7)
replace education=3 if inlist(SR_DEGR, 8, 9, 10, 11, 12, 13, 14, 15, 16)
replace education=1 if inlist(TH_DEGR, 1, 2, 3)
replace education=2 if inlist(TH_DEGR, 4, 5, 6)
replace education=3 if inlist(TH_DEGR, 7, 8, 9)
replace education=1 if inlist(TR_DEGR, 1, 2)
replace education=2 if inlist(TR_DEGR, 3, 4)
replace education=3 if inlist(TR_DEGR, 5, 6)

label define ed 1 "Primary or lower" 2 "Secondary" 3 "University or higher"
label values education ed


recode MAINSTAT 1=4 2=3 3=2 4=4 5=2 6=2 7=2 8=2 9=2  99=., into(workstatus)
replace workstatus=1 if WRKHRS<35
label define workstat 1 "Part-time" 2 "Not active" 3 "Active unemployed" 4 "Full time"
label values workstatus workstat

rename WEIGHT weight

//adding two extra controls that were omitted from the replication instructions
recode EMPREL (2=1 "Self-employed") (0 1 4 9 .=0 "Employee/inactive/unemployed"), into(selfemployed)

//Brady et al on relative income is just standardized income i.e. z-score
//used household income where had the choice
//or the income measure that's present for more respondents
gen income=.
local incvars "AU_INC CH_INC CL_INC CZ_INC DK_INC ES_INC FI_INC FR_INC HR_INC HU_INC JP_INC LV_INC NO_INC NZ_INC PH_INC RU_INC SE_INC SI_INC US_INC VE_INC"
foreach i in `incvars' {
replace income=`i' if income==.
}
*

egen mean = mean(income), by(country)
egen z = sd(income), by(country)
replace z = (income - mean) / z
rename z relativeinc

keep  id age agesq Female elderly unemployed ReduceIncDiff jobs year country ///
	education workstatus weight elderlyNotDummy unemployedNotDummy ReduceIncDiffNotDummy ///
	jobsNotDummy selfemployed relativeinc


save "cleanissp2016.dta", replace

use "cleanissp1985.dta", clear
append using  "cleanissp1990.dta"
append using  "cleanissp1996.dta"
append using  "cleanissp2006.dta"
append using  "cleanissp2016.dta"

merge m:1 year country using "l2clean.dta"
drop if _merge==2
egen sdyear = sd(year), by(country)
drop if sdyear==0
drop if netmigpct==.
encode country, gen(ctry)
tostring year, gen(yr)
gen ctryyear = country + yr
encode ctryyear , gen(cy)

save "merge_data_54.dta", replace

use "merge_data_54.dta", clear

replace netmigpct=netmigpct/10
recode elderlyNotDummy unemployedNotDummy ReduceIncDiffNotDummy jobsNotDummy (8/9=.)

recode education 8/9=.
tab education, gen(eduDummy)
tab year, gen(yearDummy)
tab ctry, gen(ctryDummy)
tab workstatus, gen(workDummy)

replace socx = "." if socx ==".."
destring socx foreignpct emprate netmigpct, replace

*Drop unavailable data*
local indVars foreignpct
local controls Female age agesq eduDummy1 eduDummy3  workDummy2 workDummy3 workDummy4 
local years yearDummy3 yearDummy4 yearDummy5
local countries ctryDummy2 ctryDummy3 ctryDummy4 ctryDummy5 ctryDummy6 ctryDummy7 ctryDummy8 ctryDummy9 ctryDummy10 ctryDummy11 ctryDummy12 ctryDummy13 ctryDummy14 ctryDummy15 ctryDummy16 ctryDummy17 ctryDummy18 ctryDummy19 ctryDummy20 ctryDummy21 ctryDummy22 ctryDummy23  ctryDummy25 ctryDummy26

sem ///
(`indVars' `controls' `years' `countries' -> elderlyNotDummy) ///
(`indVars' `controls' `years' `countries' -> unemployedNotDummy)  ///
(`indVars' `controls' `years' `countries'  -> ReduceIncDiffNotDummy)  /// 
(`indVars' `controls' `years' `countries'  -> jobsNotDummy)  ///
[pweight = weight], vce(cluster ctryyear) ///
cov( e.elderlyNotDummy*e.unemployedNotDummy e.elderlyNotDummy*e.ReduceIncDiffNotDummy e.elderlyNotDummy*e.jobsNotDummy e.unemployedNotDummy*e.ReduceIncDiffNotDummy e.unemployedNotDummy*e.jobsNotDummy e.ReduceIncDiffNotDummy*e.jobsNotDummy) nocapslatent

gen sample = e(sample)

drop if sample!=1

*** MIMIC model ***

*Just stock*
local indVars foreignpct
local controls Female age agesq eduDummy1 eduDummy3  workDummy2 workDummy3 workDummy4 
local years yearDummy3 yearDummy4 yearDummy5
local countries ctryDummy2 ctryDummy3 ctryDummy4 ctryDummy5 ctryDummy6 ctryDummy7 ctryDummy8 ctryDummy9 ctryDummy10 ctryDummy11 ctryDummy12 ctryDummy13 ctryDummy14 ctryDummy15 ctryDummy16 ctryDummy17 ctryDummy18 ctryDummy19 ctryDummy20 ctryDummy21 ctryDummy22 ctryDummy23  ctryDummy25 ctryDummy26

eststo mimic1: sem ///
(`indVars' `controls' `years' `countries' -> latentSocial) ///
(latentSocial -> elderlyNotDummy unemployedNotDummy ReduceIncDiffNotDummy jobsNotDummy@1) /// 
[pweight = weight], vce(cluster ctryyear) latent(latentSocial ) nocapslatent 

*Stock + socx*
local indVars foreignpct socx
local controls Female age agesq eduDummy1 eduDummy3  workDummy2 workDummy3 workDummy4 
local years yearDummy3 yearDummy4 yearDummy5
local countries ctryDummy2 ctryDummy3 ctryDummy5 ctryDummy6 ctryDummy7 ctryDummy8 ctryDummy9 ctryDummy10 ctryDummy11 ctryDummy12 ctryDummy13 ctryDummy14 ctryDummy15 ctryDummy16 ctryDummy17 ctryDummy19 ctryDummy21 ctryDummy22 ctryDummy23  ctryDummy25 ctryDummy26

eststo mimic1socx: sem ///
(`indVars' `controls' `years' `countries' -> latentSocial) ///
(latentSocial -> elderlyNotDummy unemployedNotDummy ReduceIncDiffNotDummy jobsNotDummy@1) /// 
[pweight = weight], vce(cluster ctryyear) latent(latentSocial ) nocapslatent


*Stock + emprate*
local indVars foreignpct emprate
local controls Female age agesq eduDummy1 eduDummy3  workDummy2 workDummy3 workDummy4 
local years yearDummy4 yearDummy5
local countries ctryDummy2 ctryDummy3 ctryDummy4 ctryDummy5 ctryDummy6 ctryDummy7 ctryDummy8 ctryDummy9 ctryDummy10 ctryDummy11 ctryDummy12 ctryDummy13 ctryDummy14 ctryDummy15 ctryDummy16 ctryDummy17 ctryDummy18 ctryDummy19 ctryDummy20 ctryDummy21 ctryDummy22 ctryDummy23  ctryDummy25 ctryDummy26

eststo mimic1emprate: sem ///
(`indVars' `controls' `years' `countries' -> latentSocial) ///
(latentSocial -> elderlyNotDummy unemployedNotDummy ReduceIncDiffNotDummy jobsNotDummy@1) /// 
[pweight = weight], vce(cluster ctryyear) latent(latentSocial ) nocapslatent


*Just change*
local indVars netmigpct
local controls Female age agesq eduDummy1 eduDummy3  workDummy2 workDummy3 workDummy4 
local years yearDummy3 yearDummy4 yearDummy5
local countries ctryDummy2 ctryDummy3 ctryDummy4 ctryDummy5 ctryDummy6 ctryDummy7 ctryDummy8 ctryDummy9 ctryDummy10 ctryDummy11 ctryDummy12 ctryDummy13 ctryDummy14 ctryDummy15 ctryDummy16 ctryDummy17 ctryDummy18 ctryDummy19 ctryDummy20 ctryDummy21 ctryDummy22 ctryDummy23  ctryDummy25 ctryDummy26

eststo mimic2: sem ///
(`indVars' `controls' `years' `countries' -> latentSocial) ///
(latentSocial -> elderlyNotDummy unemployedNotDummy ReduceIncDiffNotDummy jobsNotDummy@1) /// 
[pweight = weight], vce(cluster ctryyear) latent(latentSocial ) nocapslatent


*Change + socx*
local indVars netmigpct socx
local controls Female age agesq eduDummy1 eduDummy3  workDummy2 workDummy3 workDummy4 
local years yearDummy3 yearDummy4 yearDummy5
local countries ctryDummy2 ctryDummy3 ctryDummy5 ctryDummy6 ctryDummy7 ctryDummy8 ctryDummy9 ctryDummy10 ctryDummy11 ctryDummy12 ctryDummy13 ctryDummy14 ctryDummy15 ctryDummy16 ctryDummy17 ctryDummy19 ctryDummy21 ctryDummy22 ctryDummy23  ctryDummy25 ctryDummy26

eststo mimic2socx: sem ///
(`indVars' `controls' `years' `countries' -> latentSocial) ///
(latentSocial -> elderlyNotDummy unemployedNotDummy ReduceIncDiffNotDummy jobsNotDummy@1) /// 
[pweight = weight], vce(cluster ctryyear) latent(latentSocial ) nocapslatent 

*Change + emprate*
local indVars netmigpct emprate
local controls Female age agesq eduDummy1 eduDummy3  workDummy2 workDummy3 workDummy4 
local years yearDummy4 yearDummy5
local countries ctryDummy2 ctryDummy3 ctryDummy4 ctryDummy5 ctryDummy6 ctryDummy7 ctryDummy8 ctryDummy9 ctryDummy10 ctryDummy11 ctryDummy12 ctryDummy13 ctryDummy14 ctryDummy15 ctryDummy16 ctryDummy17 ctryDummy18 ctryDummy19 ctryDummy20 ctryDummy21 ctryDummy22 ctryDummy23  ctryDummy25 ctryDummy26

eststo mimic2emprate: sem ///
(`indVars' `controls' `years' `countries' -> latentSocial) ///
(latentSocial -> elderlyNotDummy unemployedNotDummy ReduceIncDiffNotDummy jobsNotDummy@1) /// 
[pweight = weight], vce(cluster ctryyear) latent(latentSocial ) nocapslatent


*Stock and change*
local indVars foreignpct netmigpct
local controls Female age agesq eduDummy1 eduDummy3  workDummy2 workDummy3 workDummy4 
local years yearDummy3 yearDummy4 yearDummy5
local countries ctryDummy2 ctryDummy3 ctryDummy4 ctryDummy5 ctryDummy6 ctryDummy7 ctryDummy8 ctryDummy9 ctryDummy10 ctryDummy11 ctryDummy12 ctryDummy13 ctryDummy14 ctryDummy15 ctryDummy16 ctryDummy17 ctryDummy18 ctryDummy19 ctryDummy20 ctryDummy21 ctryDummy22 ctryDummy23  ctryDummy25 ctryDummy26

eststo mimic3: sem ///
(`indVars' `controls' `years' `countries' -> latentSocial) ///
(latentSocial -> elderlyNotDummy unemployedNotDummy ReduceIncDiffNotDummy jobsNotDummy@1) /// 
[pweight = weight], vce(cluster ctryyear) latent(latentSocial ) nocapslatent


*Stock and change + socx*
local indVars foreignpct netmigpct socx
local controls Female age agesq eduDummy1 eduDummy3  workDummy2 workDummy3 workDummy4 
local years yearDummy3 yearDummy4 yearDummy5
local countries ctryDummy2 ctryDummy3 ctryDummy5 ctryDummy6 ctryDummy7 ctryDummy8 ctryDummy9 ctryDummy10 ctryDummy11 ctryDummy12 ctryDummy13 ctryDummy14 ctryDummy15 ctryDummy16 ctryDummy17 ctryDummy19 ctryDummy21 ctryDummy22 ctryDummy23  ctryDummy25 ctryDummy26

eststo mimic3socx: sem ///
(`indVars' `controls' `years' `countries' -> latentSocial) ///
(latentSocial -> elderlyNotDummy unemployedNotDummy ReduceIncDiffNotDummy jobsNotDummy@1) /// 
[pweight = weight], vce(cluster ctryyear) latent(latentSocial ) nocapslatent


*Stock and change + emprate*
local indVars foreignpct netmigpct emprate
local controls Female age agesq eduDummy1 eduDummy3  workDummy2 workDummy3 workDummy4 
local years yearDummy4 yearDummy5
local countries ctryDummy2 ctryDummy3 ctryDummy4 ctryDummy5 ctryDummy6 ctryDummy7 ctryDummy8 ctryDummy9 ctryDummy10 ctryDummy11 ctryDummy12 ctryDummy13 ctryDummy14 ctryDummy15 ctryDummy16 ctryDummy17 ctryDummy18 ctryDummy19 ctryDummy20 ctryDummy21 ctryDummy22 ctryDummy23  ctryDummy25 ctryDummy26

eststo mimic3emprate: sem ///
(`indVars' `controls' `years' `countries' -> latentSocial) ///
(latentSocial -> elderlyNotDummy unemployedNotDummy ReduceIncDiffNotDummy jobsNotDummy@1) /// 
[pweight = weight], vce(cluster ctryyear) latent(latentSocial ) nocapslatent

*PI NOTE: Regression coefficient is equivalent to AME when model is linear.

local results mimic1 mimic1socx mimic1emprate mimic2 mimic2socx mimic2emprate mimic3 mimic3 mimic3socx mimic3socx mimic3emprate mimic3emprate
local m = 1

foreach r of local results {
preserve
drop id
est restore `r'
gen n = [_n]
keep if n == 1
gen id = "t54m`m'"
if `m' < 4 | `m' == 7 | `m' == 9 | `m' == 11 {
gen factor = "Stock, current"
gen AME = _b[foreignpct]
gen lower = _b[foreignpct] - 1.96 * _se[foreignpct]
gen upper = _b[foreignpct] + 1.96 * _se[foreignpct]
}
else {
gen factor = "Flow, 1-year"
gen AME = _b[netmigpct]
gen lower = _b[netmigpct] - 1.96 * _se[netmigpct]
gen upper = _b[netmigpct] + 1.96 * _se[netmigpct]
}
order factor AME lower upper id
keep factor AME lower upper id
save "t54m`m'.dta", replace
restore
local m = `m' + 1
}

use t54m1.dta, clear
foreach i of numlist 2/12 {
append using t54m`i'.dta
}
save team54.dta, replace

foreach i of numlist 1/12 {
erase "t54m`i'.dta"
}

erase "cleanissp1985.dta"
erase "cleanissp1990.dta"
erase "cleanissp1996.dta"
erase "cleanissp2006.dta"
erase "cleanissp2016.dta"
erase "merge_data_54.dta"
erase "l2clean.dta"

}
*==============================================================================*
*==============================================================================*
*==============================================================================*































// TEAM 58
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*
capture confirm file "team58.dta"
  if _rc==0   {
    display "Team 58 already exists, skipping to next code chunk"
  }
  else {

* ISSP 2016 (19.09.2018 version)
use "ZA6900_v2-0-0.dta", clear

* Sample of Countries
keep if country == 36 | country ==56  | country == 152 | country ==191 | country ==203 ///
| country ==208 | country ==246 | country == 250 | country == 276 ///
| country == 348 | country ==352  | country == 372 | country == 392 ///
| country ==410  | country ==428  | country == 554 | country == 578 ///
| country ==703 | country ==705 | country == 724| country == 752 | country == 756 | country == 826 | country == 840  

label values country country
label define country 36 "Australia", modify
label define country 56 "Belgium", modify
label define country 152 "Chile", modify
label define country 191 "Croatia", modify
label define country 203 "Czech Republic", modify
label define country 208 "Denmark" , modify
label define country 246 "Finland" , modify
label define country 250 "France", modify
label define country 276 "Germany", modify
label define country 826 "Great Britain", modify
label define country 348 "Hungary", modify
label define country 352 "Iceland", modify
label define country 372 "Ireland", modify
label define country 392 "Japan", modify
label define country 410 "South Korea", modify
label define country 428 "Latvia", modify
label define country 554 "New Zealand", modify
label define country 578 "Norway", modify
label define country 703 "Slovakia", modify
label define country 705 "Slovenia", modify
label define country 724 "Spain", modify
label define country 752 "Sweden", modify
label define country 756 "Switzerland", modify

label define country 840 "USA", modify

* ID variables
gen wave=2016
set type double

*respid 2016
gen respid=CASEID

***Dependent Variables***
* Jobs for everyone
recode v21 (1=4) (2=3) (3=2) (4=1) (8 9=.), gen(Jobs) // metric version; I recode to 1=least support
recode v21 (1 2 = 1) (3 4 = 0) (8 9 =.), gen(Jobs_d) // dichotomized version

* Old age
recode v24  (1=4) (2=3) (3=2) (4=1)(8 9=.), gen(OldLS) // metric version; I recode to 1=least support
recode v24 (1 2 = 1) (3 4 = 0) (8 9 =.), gen(OldLS_d) // dichotomized version

* Unemployed
recode v26  (1=4) (2=3) (3=2) (4=1)(8 9=.), gen(Unemp) // metric version; I recode to 1=least support
recode v26 (1 2 = 1) (3 4 = 0) (8 9 =.), gen(Unemp_d) // dichotomized version

* Reduce Income Diffs
recode v27  (1=4) (2=3) (3=2) (4=1)(8 9=.), gen(IncomeDif) // metric version; I recode to 1=least support
recode v27 (1 2 = 1) (3 4 = 0) (8 9 =.), gen(IncomeDif_d) // dichotomized version

* Housing
recode v29  (1=4) (2=3) (3=2) (4=1)(8 9=.), gen(Housing) // metric version; I recode to 1=least support
recode v29 (1 2 = 1) (3 4 = 0) (8 9 =.), gen(Housing_d) // dichotomized version

* Health Care
recode v23  (1=4) (2=3) (3=2) (4=1)(8 9=.), gen(Health) // metric version; I recode to 1=least support
recode v23 (1 2 = 1) (3 4 = 0) (8 9 =.), gen(Health_d) // dichotomized version


***Sociodemographics***
recode SEX (1 = 0) (2 = 1) (9=.), gen(Female)

recode AGE (999=.) (0=.) // Denmark will be dropped
rename AGE Age

gen Age_squared = Age^2

* Age groups based on Danish
gen Age_groups=DK_AGE
recode Age_groups 0=.
recode Age_groups .=22 if Age<=25
recode Age_groups .=31 if Age>25 & Age<36
recode Age_groups .=41 if Age>35 & Age<46
recode Age_groups .=51 if Age>45 & Age<56
recode Age_groups .=61 if Age>55 & Age<66
recode Age_groups .=70 if Age>=66

label variable Age_groups "Age_groups"
label define Age_groups 22 "15-24", add
label define Age_groups 31 "25-35", add
label define Age_groups 41 "36-45", add
label define Age_groups 51 "46-55", add
label define Age_groups 61 "56-65", add
label define Age_groups 70 "66 and above", add
label values Age_groups Age_groups, nofix

* Note that due to Danish data only Age groups, only the new var Age_groups includes Denmark and all other countries

*Education
label list DEGREE
gen education = 0
recode education 0 = 1 if DEGREE >0 & DEGREE<= 2  // primary up to lower secondary
recode education 0 = 2 if DEGREE >=3 & DEGREE<=5  // upper secondary, post secondary towards labor market, lower level tertiary first stage
recode education 0 = 3 if DEGREE == 6 // Master, Doctor
recode education 0 =. if DEGREE==9 

*labels
label variable education "education"
label define education 0 "no formal education" , add
label define education 1 "primary" , add
label define education 2 "secondary and post-secondary tertiary" , add
label define education 3 "university" , add
label values education education

*Employment
gen employed=.
replace employed=1 if MAINSTAT==1 // EMPLOYED 
replace employed=2 if MAINSTAT==3 | MAINSTAT==4 | MAINSTAT==8 // NOT YET EMPLOYED
replace employed=3 if MAINSTAT==6  //RETIRED
replace employed=4 if MAINSTAT==7 // HOUSEWORK
replace employed=5 if MAINSTAT==5 | MAINSTAT==9 // NOT IN LABOUR /NEVER IN LABOUR FORCE
replace employed=6 if MAINSTAT==2 // UNEMPLOYED

label variable employed "employed"
label define employed 1 "employed" , add
label define employed 2 "not yet employed" , add
label define employed 3 "retired" , add
label define employed 4 "housework", add
label define employed 5 "not/never in labour force", add
label define employed 6 "unemployed", add
label values employed employed 


* loop to generate hhincome
gen hhincome=.
replace hhincome=AU_INC if c_alphan=="AU"
replace hhincome=BE_INC if c_alphan=="BE"
replace hhincome=CH_INC if c_alphan=="CH"
replace hhincome=CL_INC if c_alphan=="CL"
replace hhincome=CZ_INC if c_alphan=="CZ"
replace hhincome=DE_INC if c_alphan=="DE"
replace hhincome=DK_INC if c_alphan=="DK"
replace hhincome=ES_INC if c_alphan=="ES"
replace hhincome=FI_INC if c_alphan=="FI"
replace hhincome=FR_INC if c_alphan=="FR"
replace hhincome=GB_INC if c_alphan=="GB-GBN"     
replace hhincome=HR_INC if c_alphan=="HR"      
replace hhincome=HU_INC if c_alphan=="HU"           
replace hhincome=IS_INC if c_alphan=="IS"      
replace hhincome=JP_INC if c_alphan=="JP"      
replace hhincome=KR_INC if c_alphan=="KR"          
replace hhincome=LV_INC if c_alphan=="LV"      
replace hhincome=NO_INC if c_alphan=="NO"     
replace hhincome=NZ_INC if c_alphan=="NZ"      
replace hhincome=SE_INC if c_alphan=="SE"
replace hhincome=SI_INC if c_alphan=="SI"
replace hhincome=SK_INC if c_alphan=="SK"
replace hhincome=US_INC if c_alphan=="US"

bysort country: tab hhincome, mis

* household size
label list HOMPOP
gen hhsize=HOMPOP
recode hhsize (0=.) (99=.) 


bysort respid: gen hhincpp=hhincome/hhsize  //7.711 missings
bysort country: egen sdhhincp=sd(hhincpp) // standard deviation of hhincpp pro Land
bysort country: egen meanhhincpp=mean(hhincpp)

gen z1hhincpp=(hhincpp-meanhhincpp)/sdhhincp // standardized version of hhincpp
bysort country: table z1hhincpp, mis //  control

*marital status

gen married=1 if MARITAL==1 | MARITAL==2
replace married = 0 if MARITAL>=3 & MARITAL<7


* political interest

* ! political interest; I recode to 0 no/not very much and 1 yes (including fairly, very)
* !! NZ code: (3=4) (4=5) then match with v46
gen polint=0 if NZ_v46==3 | NZ_v46==4
replace polint=0 if v46==4 | v46==5
replace polint=1 if NZ_v46==1 | NZ_v46==2
replace polint=1 if v46==1 | v46==2 | v46==3

sort country respid

save "CRI_ISSP_2016_subsample", replace


****************************

*** Preparation of ISSP 2006 data***
use "ZA4700.dta", clear


* ID variables
gen wave=2006
rename V2 respid
des respid

rename V3a country


* Sample of Countries
keep if country == 36 | country ==56  | country == 152 | country ==191 | country ==203 ///
| country ==208 | country ==246 | country == 250 | country == 276 ///
| country == 348 | country ==352  | country == 372 | country == 392 ///
| country ==410  | country ==428  | country == 554 | country == 578 ///
| country ==703 | country ==705 | country == 724| country == 752 | country == 756 | country == 826 | country == 840  
* Belgium, Iceland, Slovakia missing


***Dependent Variables***

***Dependent Variables***
* Jobs for everyone
recode V25 (1=4) (2=3) (3=2) (4=1) (8 9=.), gen(Jobs) // metric version; I recode to 1=least support
recode V25 (1 2 = 1) (3 4 = 0) (8 9 =.), gen(Jobs_d) // dichotomized version


* Old age
recode V28  (1=4) (2=3) (3=2) (4=1)(8 9=.), gen(OldLS) // metric version; I recode to 1=least support
recode V28 (1 2 = 1) (3 4 = 0) (8 9 =.), gen(OldLS_d) // dichotomized version

* Unemployed
recode V30  (1=4) (2=3) (3=2) (4=1)(8 9=.), gen(Unemp) // metric version; I recode to 1=least support
recode V30 (1 2 = 1) (3 4 = 0) (8 9 =.), gen(Unemp_d) // dichotomized version

* Reduce Income Diffs
recode V31  (1=4) (2=3) (3=2) (4=1)(8 9=.), gen(IncomeDif) // metric version; I recode to 1=least support
recode V31 (1 2 = 1) (3 4 = 0) (8 9 =.), gen(IncomeDif_d) // dichotomized version

*neu 20181107

* Housing
recode V33 (1=4) (2=3) (3=2) (4=1)(8 9=.), gen(Housing) // metric version; I recode to 1=least support
recode V33 (1 2 = 1) (3 4 = 0) (8 9 =.), gen(Housing_d) // dichotomized version

* Health Care
recode V27  (1=4) (2=3) (3=2) (4=1)(8 9=.), gen(Health) // metric version; I recode to 1=least support
recode V27 (1 2 = 1) (3 4 = 0) (8 9 =.), gen(Health_d) // dichotomized version

***Sociodemographics***
gen Female = 1 if sex == 2
replace Female = 0 if sex == 1

rename age Age
gen Age_squared = Age^2


* Age groups based on Danish Age groups in 2016 sample
gen Age_groups=.
recode Age_groups .=22 if Age<=25
recode Age_groups .=31 if Age>25 & Age<36
recode Age_groups .=41 if Age>35 & Age<46
recode Age_groups .=51 if Age>45 & Age<56
recode Age_groups .=61 if Age>55 & Age<66
recode Age_groups .=70 if Age>=66

label variable Age_groups "Age_groups"
label define Age_groups 22 "15-24", add
label define Age_groups 31 "15-35", add
label define Age_groups 41 "36-45", add
label define Age_groups 51 "46-55", add
label define Age_groups 61 "56-65", add
label define Age_groups 70 "66 and above", add
label values Age_groups Age_groups, nofix


*Education
gen education= 0
replace education = 1 if degree ==1 | degree==2 // primary up to secondary not finished (above lowest qualification)
replace education = 2 if degree == 3 | degree == 4
replace education = 3 if degree ==5
replace education=. if degree==. 

*labels
label variable education "education"
label define education 0 "no formal education" , add
label define education 1 "primary" , add
label define education 2 "secondary and post-secondary tertiary" , add
label define education 3 "university" , add
label values education education

*Employment
gen employed=.
replace employed=1 if wrkst==1 | wrkst==2 | wrkst==3 | wrkst==4 // employed
replace employed=2 if wrkst==6 // not yet
replace employed=3 if wrkst==7 // retired
replace employed=4 if wrkst==8 // housework
replace employed=5 if wrkst==9 | wrkst==10 // not /never employed
replace employed=6 if wrkst==5 // unemployed

label variable employed "employed"
label define employed 1 "employed" , add
label define employed 2 "not yet employed" , add
label define employed 3 "retired" , add
label define employed 4 "housework", add
label define employed 5 "not/never in labour force", add
label define employed 6 "unemployed", add
label values employed employed 

* loop to generate hhincome
gen hhincome=.
replace hhincome=AU_INC if country==36
replace hhincome=CH_INC if country==756
replace hhincome=CL_INC if country==152
replace hhincome=CZ_INC if country==203
replace hhincome=DE_INC if country==276
replace hhincome=DK_INC if country==208
replace hhincome=ES_INC if country==724
replace hhincome=FI_INC if country==246
replace hhincome=FR_INC if country==250
replace hhincome=GB_INC if country==826     
replace hhincome=HR_INC if country==191      
replace hhincome=HU_INC if country==348           
replace hhincome=JP_INC if country==392      
replace hhincome=KR_INC if country==410          
replace hhincome=LV_INC if country==428      
replace hhincome=NO_INC if country==578     
replace hhincome=NZ_INC if country==554      
replace hhincome=SE_INC if country==752

replace hhincome=SI_INC if country==705
replace hhincome=US_INC if country==840

bysort country: tab hhincome, mis

* household size
gen hhsize=hompop

bysort respid: gen hhincpp=hhincome/hhsize  // 6.609 missings
bysort country: egen sdhhincp=sd(hhincpp) // standard deviation of hhincpp pro Land
bysort country: egen meanhhincpp=mean(hhincpp)

gen z1hhincpp=(hhincpp-meanhhincpp)/sdhhincp // standardized version of hhincpp
bysort country: tab z1hhincpp, mis //  control

*marital status
gen married=1 if marital==1 
replace married = 0 if marital>=2 & marital!=.

* political interest
* ! political interest; I recode to 0 no/not very much and 1 yes (including fairly, very)
gen polint=0 if V44>=4 & V44!=.
replace polint=1 if V44<=3 & V44!=.

sort country respid

save "CRI_ISSP_2006_subsample", replace

****************

* merge with the 2016 data
merge country respid using "CRI_ISSP_2016_subsample", force

sort country respid

generate year = 0
replace year = 2006 if V1 == 4700
replace year = 2016 if V1 == .
order year, after(respid)

* get rid of all variables that are not needed
keep respid country year Age Jobs Jobs_d OldLS OldLS_d Unemp Unemp_d IncomeDif IncomeDif_d Health Health_d Housing Housing_d ///
Female Age_squared Age_groups education employed married hhsize polint z1hhincpp

save "CRI_ISSP_2006_2016_pooled_jk.dta", replace

*** CRI MACRO DATA

import delimited "cri_macro.csv",clear

keep if iso_country == 36 | iso_country ==56  | iso_country == 152 | iso_country ==191 | iso_country ==203 ///
| iso_country ==208 | iso_country ==246 | iso_country == 250 | iso_country == 276 ///
| iso_country == 348 | iso_country ==352  | iso_country == 372 | iso_country == 392 ///
| iso_country ==410  | iso_country ==428  | iso_country == 554 | iso_country == 578 | iso_country ==703 /// 
| iso_country ==705 | iso_country == 724| iso_country == 752 | iso_country == 756 | iso_country == 826 | iso_country == 840  

drop gini_wid gdp_twn gdp_wb gni_wb ginim_dolt gini_wb top10_wid mcp migstock_wb migstock_oecd pop_wb al_ethnic dpi_tf wdi_unempilo country
rename iso_country country

keep if year == 1995 | year == 1996 | year == 2004 | year == 2005 | year == 2013 | year == 2014 | year == 2015

replace socx_oecd = "." if socx_oecd == ".."
destring socx_oecd, replace

reshape wide gdp_oecd-socx_oecd, i(country) j(year)

merge 1:1 country using "welfare_regime_subset23.dta"
drop _merge

save "macro_wideformat_1911.dta", replace

*Data structures and Models 
use "CRI_ISSP_2006_2016_pooled_jk.dta", clear

merge m:n country using "macro_wideformat_1911.dta"
drop _merge


*****Build correct data structure******

gen stock = .
replace stock = migstock_un2005 if year == 2006
replace stock = migstock_un2015 if year == 2016

gen change1 = .
replace change1 = migstock_un2005-migstock_un2004 if year == 2006
replace change1 = migstock_un2015-migstock_un2014 if year == 2016

gen change10 = .
replace change10 = migstock_un2005-migstock_un1995 if year == 2006
replace change10 = migstock_un2005-migstock_un1996 if year == 2006 & country == 36  // no data for Australia 1995, use of 1996 in exchange
replace change10 = migstock_un2015-migstock_un2005 if year == 2016

gen mignet = .
replace mignet = mignet_un2005 if year == 2006
replace mignet = mignet_un2015 if year == 2016

rename welf_regime regime

gen employ = .
replace employ = wdi_empprilo2005 if year == 2006
replace employ = wdi_empprilo2015 if year == 2016

gen socex = .
replace socex = socx_oecd2005 if year == 2006
replace socex = socx_oecd2015 if year == 2016
replace socex = socx_oecd2013 if year == 2016 & country == 392  // No data for Japan 2015 - is exchanged with data for 2013.

gen gdp = .
replace gdp = gdp_oecd2005 if year == 2006
replace gdp = gdp_oecd2015 if year == 2016

gen gini = .
replace gini = ginid_solt2005 if year == 2006
replace gini = ginid_solt2015 if year == 2016

drop gdp_oecd1995-socx_oecd2015

egen land = group(country)
replace land = . if land == 2 | land == 6 | land == 11 | land == 12 | land == 18
recode land (1=6) (13=11) (14=12) (15=13) (16=14) (17=15) (19=16) (20=17) (21=18) (22=19) (23=20) (24=21)

save "Data_final_58.dta", replace


******Models*******
*******************

****All countries****

*PI adjustment
replace mignet=mignet/10
replace change10=change10/10
//

//Jobs
meologit Jobs c.stock c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
margins, dydx(stock) saving("t58m1.dta",replace)

meologit Jobs c.change1 c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
margins, dydx(change1) saving("t58m7.dta",replace)

qui meologit Jobs c.change10 c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
margins, dydx(change10) saving("t58m13.dta", replace) 

qui meologit Jobs c.stock##c.change10 c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
margins, dydx(stock) saving("t58m19.dta", replace)
margins, dydx(change10) saving("t58m25.dta",replace)

qui meologit Jobs mignet c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
margins, dydx(mignet) saving("t58m31.dta",replace)


//Support for Unemployed
meologit Unemp c.stock c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
est store Unemp
margins, dydx(stock) saving("t58m2.dta",replace)

meologit Unemp c.change1 c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
est store Unemp1
margins, dydx(change1) saving("t58m8.dta",replace)

meologit Unemp c.change10 c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
est store Unemp10
margins, dydx(change10) saving("t58m14.dta", replace) 

meologit Unemp c.stock##c.change10 c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
est store Unempx
margins, dydx(stock) saving("t58m20.dta", replace)
margins, dydx(change10) saving("t58m26.dta",replace)

meologit Unemp mignet c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
est store Unempnet
margins, dydx(mignet) saving("t58m32.dta",replace)


//Income Differences
meologit IncomeDif c.stock c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
est store IncomeDif
margins, dydx(stock) saving("t58m3.dta",replace)

meologit IncomeDif c.change1 c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
est store IncomeDif1
margins, dydx(change1) saving("t58m9.dta",replace)

meologit IncomeDif c.change10 c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
est store IncomeDif10
margins, dydx(change10) saving("t58m15.dta", replace) 

meologit IncomeDif c.stock##c.change10 c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
est store IncomeDifx
margins, dydx(stock) saving("t58m21.dta", replace)
margins, dydx(change10) saving("t58m27.dta",replace)

meologit IncomeDif mignet c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
est store IncomeDifnet
margins, dydx(mignet) saving("t58m33.dta",replace)

//Old people living standard
meologit OldLS c.stock c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
est store OldLS
margins, dydx(stock) saving("t58m4.dta",replace)

meologit OldLS c.change1 c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
est store OldLS1
margins, dydx(change1) saving("t58m10.dta",replace)

meologit OldLS c.change10 c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
est store OldLS10
margins, dydx(change10) saving("t58m16.dta", replace) 

meologit OldLS c.stock##c.change10 c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
est store OldLSx
margins, dydx(stock) saving("t58m22.dta", replace)
margins, dydx(change10) saving("t58m28.dta",replace)

meologit OldLS mignet c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
est store OldLSnet
margins, dydx(mignet) saving("t58m34.dta",replace)

//Housing
meologit Housing c.stock c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
est store Housing
margins, dydx(stock) saving("t58m5.dta",replace)

meologit Housing c.change1 c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
est store Housing1
margins, dydx(change1) saving("t58m11.dta",replace)

meologit Housing c.change10 c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
est store Housing10
margins, dydx(change10) saving("t58m17.dta", replace) 

meologit Housing c.stock##c.change10 c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
est store Housingx
margins, dydx(stock) saving("t58m23.dta", replace)
margins, dydx(change10) saving("t58m29.dta",replace)

meologit Housing mignet c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
est store Housingnet
margins, dydx(mignet) saving("t58m35.dta",replace)

//Health
meologit Health c.stock c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
margins, dydx(stock) saving("t58m6.dta",replace)

meologit Health c.change1 c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
margins, dydx(change1) saving("t58m12.dta",replace)

meologit Health c.change10 c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
margins, dydx(change10) saving("t58m18.dta", replace) 

meologit Health c.stock##c.change10 c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
margins, dydx(stock) saving("t58m24.dta", replace)
margins, dydx(change10) saving("t58m30.dta",replace)

meologit Health mignet c.employ c.socex c.gdp c.gini Female ib22.Age_groups ib1.education ib1.employed c.z1hhincpp c.hhsize married polint i.year || country:, intmethod(mc) evaltype(gf0) ///
	cov(un) intpoints(7) or
margins, dydx(mignet) saving("t58m36.dta",replace)

use t58m1.dta, clear
foreach i of numlist 2/36 {
append using "t58m`i'.dta"
}

/* This team argued for effects being different by response. Therefore,
we allow their margins to be categorical as well. We consider the 
cutpoints in recreating a single linear effect
Treat four ordered logits as 1, 2, 3 and 4 and then estimate the 
difference between the population mean with this coding scheme and 
the predicted population mean based on the likelihood of being in each
category given a 1 point higher value of the indep. variable. This gives 
an approximation of what the overall population mean would be given 
unequal effect intervals.

The alternative to this would be to predict(xb) and have a linear effect,
but our coding here allows the sampled values in the data to change
differently for each parameter given a 1 point change in the 
independent variable */

gen id = [_n]
gen id2 = id-72
replace id = id2 if id>72

recode id (1/4 25/28 49/52 =1)(5/8 29/32 53/56 =2) ///
(9/12 33/36 57/60 =3)(13/16 37/40 61/64 =4) ///
(17/20 41/44 65/68 =5)(21/24 45/48 69/72 =6), gen(dv)

*This finds the number of respondents in each category of
*the ologit for each model (4 per model)
recode id ///
( 1 25 49 73  97 121 = 6714)  /// 
( 2 26 50 74  98 122 = 13513) ///
( 3 27 51 75  99 123 = 19720) ///
( 4 28 52 76 100 124 = 17065) /// /* jobs */
( 5 29 53 77 101 125 = 424)   ///
( 6 30 54 78 102 126 = 2397)  ///
( 7 31 55 79 103 127 = 19804) ///
( 8 32 56 80 104 128 = 35703) /// /* old */
( 9 33 57 81 105 129 = 4036)  ///
(10 34 58 82 106 130 = 11847) ///
(11 35 59 83 107 131 = 26381) ///
(12 36 60 84 108 132 = 14121) /// /* unemp */
(13 37 61 85 109 133 = 4595)  /// 
(14 38 62 86 110 134 = 9839)  ///
(15 39 63 87 111 135 = 18850) ///
(16 40 64 88 112 136 = 23452) /// /* incdif */
(17 41 65 89 113 137 = 2497)  ///
(18 42 66 90 114 138 = 8912)  ///
(19 43 67 91 115 139 = 27272) ///
(20 44 68 92 116 140 = 18050) /// /* house */
(21 45 69 93 117 141 = 494)   /// 
(22 46 70 94 118 142 = 2073)  ///
(23 47 71 95 119 143 = 16940) ///
(24 48 72 96 120 144 = 38820) /// /* health */
, gen(pop)

*This takes the total number of respondents listwise
recode id ///
( 1 25 49 73  97 121 = 57012)  /// 
( 5 29 53 77 101 125 = 58328)  ///
( 9 33 57 81 105 129 = 56385)  ///
(13 37 61 85 109 133 = 56736)  /// 
(17 41 65 89 113 137 = 56731)  ///
(21 45 69 93 117 141 = 58327)  /// 
(*=.), gen(tpop)

*This assigns 1,2,3&4 as values to each category
recode id ///
( 1 25 49 73  97 121 = 1) /// 
( 2 26 50 74  98 122 = 2) ///
( 3 27 51 75  99 123 = 3) ///
( 4 28 52 76 100 124 = 4) /// /* jobs */
( 5 29 53 77 101 125 = 1) ///
( 6 30 54 78 102 126 = 2) ///
( 7 31 55 79 103 127 = 3) ///
( 8 32 56 80 104 128 = 4) /// /* old */
( 9 33 57 81 105 129 = 1) ///
(10 34 58 82 106 130 = 2) ///
(11 35 59 83 107 131 = 3) ///
(12 36 60 84 108 132 = 4) /// /* unemp */
(13 37 61 85 109 133 = 1) /// 
(14 38 62 86 110 134 = 2) ///
(15 39 63 87 111 135 = 3) ///
(16 40 64 88 112 136 = 4) /// /* incdif */
(17 41 65 89 113 137 = 1) ///
(18 42 66 90 114 138 = 2) ///
(19 43 67 91 115 139 = 3) ///
(20 44 68 92 116 140 = 4) /// /* house */
(21 45 69 93 117 141 = 1) /// 
(22 46 70 94 118 142 = 2) ///
(23 47 71 95 119 143 = 3) ///
(24 48 72 96 120 144 = 4) /// /* health */
, gen(score)


gen mean = ((score*pop)+(score[_n+1]*pop[_n+1]) ///
+(score[_n+2]*pop[_n+2])+(score[_n+3]*pop[_n+3]))/tpop

gen margmean = ( ///
score*(pop+(pop*_margin)) + ///
score[_n+1]*(pop[_n+1]+(pop[_n+1]*_margin[_n+1])) + ///
score[_n+2]*(pop[_n+2]+(pop[_n+2]*_margin[_n+2])) + ///
score[_n+3]*(pop[_n+3]+(pop[_n+3]*_margin[_n+3])) ///
)/tpop

gen margmean_lb = ( ///
score*(pop+(pop*(_ci_lb))) + ///
score[_n+1]*(pop[_n+1]+(pop[_n+1]*(_ci_lb[_n+1]))) + ///
score[_n+2]*(pop[_n+2]+(pop[_n+2]*(_ci_lb[_n+2]))) + ///
score[_n+3]*(pop[_n+3]+(pop[_n+3]*(_ci_lb[_n+3]))) ///
)/tpop

gen margmean_ub = ( ///
score*(pop+(pop*(_ci_ub))) + ///
score[_n+1]*(pop[_n+1]+(pop[_n+1]*(_ci_ub[_n+1]))) + ///
score[_n+2]*(pop[_n+2]+(pop[_n+2]*(_ci_ub[_n+2]))) + ///
score[_n+3]*(pop[_n+3]+(pop[_n+3]*(_ci_ub[_n+3]))) ///
)/tpop

gen AME = margmean - mean
gen lower = margmean_lb - mean
gen upper = margmean_ub - mean
drop if AME == .
gen factor = .
gen n = [_n]
drop id
gen id = "t58m1"
foreach n of numlist 2/36 {
replace id = "t58m`n'" if `n'==n
}
order factor AME lower upper id
keep factor AME lower upper id
save "team58.dta", replace

foreach n of numlist 1/36 {
erase "t58m`n'.dta"
}

erase "Data_final_58.dta"
erase "macro_wideformat_1911.dta"
erase "CRI_ISSP_2006_2016_pooled_jk.dta"
erase "CRI_ISSP_2006_subsample.dta"
erase "CRI_ISSP_2016_subsample.dta"
}
*==============================================================================*
*==============================================================================*
*==============================================================================*



























// TEAM 60
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*This team was unable to provide their data wrangling code.

capture confirm file "team60.dta"
  if _rc==0   {
    display "Team 60 already exists, skipping to next code chunk"
  }
  else {

use alldata2_60.dta, clear

melogit Old_Age_Care foreignpct Female Age AgeSq dless dmore dpart dnact dact || cntry: 
margins,dydx(foreignpct) saving("t60m4",replace)
melogit Unemployed foreignpct Female Age AgeSq dless dmore dpart dnact dact || cntry: 
margins,dydx(foreignpct) saving("t60m3",replace)
melogit Reduce_Income_Differences foreignpct Female Age AgeSq dless dmore dpart dnact dact || cntry: 
margins,dydx(foreignpct) saving("t60m2",replace)
melogit Jobs foreignpct Female Age AgeSq dless dmore dpart dnact dact || cntry: 
margins,dydx(foreignpct) saving("t60m1",replace)
tab cntry if e(sample)==1

melogit Old_Age_Care foreignpct socx Female Age AgeSq dless dmore dpart dnact dact i.Year || cntry: 
margins,dydx(foreignpct) saving("t60m8",replace)
melogit Unemployed foreignpct socx Female Age AgeSq dless dmore dpart dnact dact i.Year || cntry: 
margins,dydx(foreignpct) saving("t60m7",replace)
melogit Reduce_Income_Differences foreignpct socx Female Age AgeSq dless dmore dpart dnact dact i.Year || cntry: 
margins,dydx(foreignpct) saving("t60m6",replace)
melogit Jobs foreignpct socx Female Age AgeSq dless dmore dpart dnact dact i.Year || cntry: 
margins,dydx(foreignpct) saving("t60m5",replace)
tab cntry if e(sample)==1

melogit Old_Age_Care foreignpct emprate Female Age AgeSq dless dmore dpart dnact dact i.Year || cntry: 
margins,dydx(foreignpct) saving("t60m12",replace)
melogit Unemployed foreignpct emprate Female Age AgeSq dless dmore dpart dnact dact i.Year || cntry: 
margins,dydx(foreignpct) saving("t60m11",replace)
melogit Reduce_Income_Differences foreignpct emprate Female Age AgeSq dless dmore dpart dnact dact i.Year || cntry: 
margins,dydx(foreignpct) saving("t60m10",replace)
melogit Jobs foreignpct emprate Female Age AgeSq dless dmore dpart dnact dact i.Year || cntry: 
margins,dydx(foreignpct) saving("t60m9",replace)
tab cntry if e(sample)==1

melogit Old_Age_Care netmigpct Female Age AgeSq dless dmore dpart dnact dact || cntry: 
margins,dydx(netmigpct) saving("t60m16",replace)
melogit Unemployed netmigpct Female Age AgeSq dless dmore dpart dnact dact || cntry: 
margins,dydx(netmigpct) saving("t60m15",replace)
melogit Reduce_Income_Differences netmigpct Female Age AgeSq dless dmore dpart dnact dact || cntry: 
margins,dydx(netmigpct) saving("t60m14",replace)
melogit Jobs netmigpct Female Age AgeSq dless dmore dpart dnact dact || cntry: 
margins,dydx(netmigpct) saving("t60m13",replace)
tab cntry if e(sample)==1

melogit Old_Age_Care netmigpct socx Female Age AgeSq dless dmore dpart dnact dact i.Year || cntry: 
margins,dydx(netmigpct) saving("t60m20",replace)
melogit Unemployed netmigpct socx Female Age AgeSq dless dmore dpart dnact dact i.Year || cntry: 
margins,dydx(netmigpct) saving("t60m19",replace)
melogit Reduce_Income_Differences netmigpct socx Female Age AgeSq dless dmore dpart dnact dact i.Year || cntry: 
margins,dydx(netmigpct) saving("t60m18",replace)
melogit Jobs netmigpct socx Female Age AgeSq dless dmore dpart dnact dact i.Year || cntry: 
margins,dydx(netmigpct) saving("t60m17",replace)
tab cntry if e(sample)==1

melogit Old_Age_Care netmigpct emprate Female Age AgeSq dless dmore dpart dnact dact i.Year || cntry: 
margins,dydx(netmigpct) saving("t60m24",replace)
melogit Unemployed netmigpct emprate Female Age AgeSq dless dmore dpart dnact dact i.Year || cntry: 
margins,dydx(netmigpct) saving("t60m23",replace)
melogit Reduce_Income_Differences netmigpct emprate Female Age AgeSq dless dmore dpart dnact dact i.Year || cntry: 
margins,dydx(netmigpct) saving("t60m22",replace)
melogit Jobs netmigpct emprate Female Age AgeSq dless dmore dpart dnact dact i.Year || cntry: 
margins,dydx(netmigpct) saving("t60m21",replace)
tab cntry if e(sample)==1

use t60m1,clear
foreach x of numlist 2/24 {
append using t60m`x'
}
gen factor = .

gen f = _n

gen id ="t60m1"
foreach x of numlist 2/24 {
replace id = "t60m`x'" if f==`x'
}
clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
order factor AME lower upper id
keep factor AME lower upper id
save team60, replace

foreach x of numlist 1/24 {
erase "t60m`x'.dta"
}

}











// TEAM 64
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team64.dta"
  if _rc==0   {
    display "Team 64 already exists, skipping to next code chunk"
  }
  else {
version 14.2
clear
clear mata
clear matrix

************** Prepare 2006 ISSP Dataset
*Load Dataset
use ZA4700.dta,clear

* Keep Variables Needed for the Analyses
keep V2 V3a  V27 V28 V30 V31 V33 V25 sex age degree wrkst PARTY_LR
rename V2 CASEID

* Country ISO-CODES
rename V3a country

*country selection:
keep if inlist(country, 36, 56, 756, 203, 276, 208, 724, 246, 250, 826, 348, 352, 392, 428, 578, 554, 752, 703, 705, 840) 

******DVs********

*index of all six dependent variables:
egen dv_index = rowmean(V25 - V33) // default option creates mean over all valid answers - missings are ignored 

drop V28 V30 V31 V25 V27 V33

*Recode Covariates Ind-Lev
recode sex (1=0) (2=1)
label define Sex 0 "Male" 1 "Female", modify
label value sex Sex

* for analysis including Denmark: age for 2016  only in categories
gen age_cat = age
recode age_cat (15/25 = 22) (26/35 = 31) (36/45 = 41) (46/55 = 51) (56/65 = 61) (66/99 = 70)

*Age already named and coded
gen age2=age^2

* Eudcation
recode degree (0/1=1) (2/4=2) (5=3), gen(edu)
drop degree

*Employment
recode wrkst (1=4) (2/3=1) (4=2) (6/10=2) (5=3), gen(employ)
drop wrkst

* Ideology
gen ideo=PARTY_LR
replace ideo=. if inlist(ideo, 6, 7)

drop PARTY_LR

*Year Variable
gen year=2006

*Save Dataset
save issp_2006.dta, replace

********************************************************************************
********************** Preparation ISSP 2016 ***********************************
********************************************************************************

* Prepare 2016 ISSP
use ZA6900_v2-0-0.dta, clear

*keep all necessary variables plus administrative variables:
keep doi country c_sample c_alphan CASEID WEIGHT v21 v23 v24 v26 v27 v29 ///
SEX BIRTH AGE DK_AGE EDUCYRS DEGREE TOPBOT MAINSTAT WORK WRKHRS *_INC PARTY_LR

*country selection:
keep if inlist(country, 36, 56, 756, 203, 276, 208, 724, 246, 250, 826, 348, 352, 392, 428, 578, 554, 752, 703, 705, 840) 


******DVs********
mvdecode v21 - v29, mv(8 =.a\9 = .b) //can't choose  = .a, no answer = .b

*index of all six dependent variables:
egen dv_index = rowmean(v21 - v29) // default option creates mean over all valid answers - missings are ignored 

drop v21-v29

******IVs********
*gender:
recode SEX (1=0) (2=1) (9 = .b), gen(sex)
label define Sex 0 "Male" 1 "Female", modify
label value sex Sex
tab SEX sex, m
drop SEX


*age:
*For Denmark, age is only available in categories (DK_AGE).
rename AGE age
mvdecode age, mv(0 = .c\999 = .b) // .c = not applicable (Denmark), .b = no answer
gen age2 = age^2

*adjust age to Danish standard, for analysis including Denmark:
gen age_cat = age
recode age_cat (15/25 = 22) (26/35 = 31) (36/45 = 41) (46/55 = 51) (56/65 = 61) (66/99 = 70)
replace age_cat = DK_AGE if country == 208
lab val age_cat DK_AGE

drop DK_AGE

* education:
gen edu = DEGREE
recode edu (0/1=1) (2/4=2) (5/6=3) (9=.b)
label define EDU 1 "Primary" 2 "Secondary" 3 "University" , modify
lab val edu EDU

drop DEGREE


* employment status:
gen employ = MAINSTAT
recode employ (1 4 =1) (2 = 4) (3 5/9 = 3) (99=.b)
recode employ (1 = 2) if inrange(WRKHRS, 1, 32) // defining part-time category - randomly set below 33 working hours
label define EMPL 1 "Full-Time" 2 "Part-Time" 3 "Not-Active" 4 "Active Unemployed" , modify
lab val employ EMPL

drop MAINSTAT WRKHRS


*study year
gen year=2016

* PARTY_LR - R: Party voted for in last general election: left-right // einziges Problem: not available for GB
gen ideo=PARTY_LR
replace ideo=. if inlist(ideo, 0, 6, 96, 96, 97, 98, 99)

* Keep Vars
keep country dv_index sex age age2 age_cat edu employ year ideo CASEID

* Save Dataset
save issp_2016.dta, replace



********************************************************************************
********************** ISSP DATA MERGE *****************************************
********************************************************************************
use issp_2006.dta, clear
append using issp_2016.dta

fre country - healthcare

foreach var of varlist country - ideo {
tab `var' year, m
}



********************************************************************************
********************** COUNTRY DATA MERGE **************************************
********************************************************************************
*Merge Country Level Data to ISSP Data

preserve
clear
import excel "Macrodata_64.xlsx", sheet("Daten") first 


foreach var of varlist inflowt1 inflowpctt1 migstock_total_oecdt1 migstock_pct_oecdt1 ///
MIPEX_fullscore_2014 MIPEX_without_edu_health_2007_20 MIPEX_empl_2007_2014 mcp socx_oecdt1{
destring `var', replace
}
save "cntry_data_64.dta", replace
restore

sort country year
merge m:1 country year using "cntry_data_64.dta"
* für Slovakia, Belgium und Iceland haben wir keine Ind-Level Data für 2006
* Irgendwie hatten wir im DS insg. 20 countries, hier aber doch nur 19 :D
tab country year
drop if _merge==2
drop _merge


foreach var of varlist inflowpctt1 mignet_un_pctt1 migstock_pct_oecdt1 {
sort country
display "*************`var' ************"
by country: tab `var' year
}

* Post Soviet Dummy
gen postsoviet=0
replace postsoviet=1 if inlist(country, 203, 246, 348, 428, 703, 705)
tab country postsoviet

save merged_data_64.dta, replace

  

********************************************************************************
********************** DATA ANALYSES *******************************************
********************************************************************************

use merged_data_64.dta,clear


* Ind-Lev-Controls:

local fbindlev       "sex age age2 ib2.edu ib4.employ"
local indlev        "sex age age2 ideo ib2.edu ib4.employ"
local 2006			"if year==2006"
local 2016			"if year==2016"
local ml	 		"|| country:, mle"


********************** Random Intercept Models
*PI adjustments
* DV is reverse coded
*check inflowpct1, is it in pct or 1,000?


**************** IV: MigStock (wb)
* Controls: Ind.-Lev
xtmixed dv_index migstock_pct_wbt1 `indlev' `2006' `ml' 
margins, dydx(migstock_pct) saving("t64m1",replace)
xtmixed dv_index migstock_pct_wbt1 `indlev' `2016' `ml' 
margins, dydx(migstock_pct) saving("t64m2",replace)

* Controls: Ind.-Lev + Social Welfare Expend. + postsoviet
xtmixed dv_index migstock_pct_wbt1 socx_oecdt1 postsoviet `indlev' `2006' `ml' 
margins, dydx(migstock_pct) saving("t64m3",replace)
xtmixed dv_index migstock_pct_wbt1 socx_oecdt1 postsoviet `indlev' `2016' `ml' 
margins, dydx(migstock_pct) saving("t64m4",replace)

* Controls: Ind.-Lev + Employment + postsoviet
xtmixed dv_index migstock_pct_wbt1 wdi_unempilo postsoviet `indlev' `2006' `ml' 
margins, dydx(migstock_pct) saving("t64m5",replace)
xtmixed dv_index migstock_pct_wbt1 wdi_unempilo postsoviet  `indlev' `2016' `ml' 
margins, dydx(migstock_pct) saving("t64m6",replace)

* Controls: Ind.-Lev + MIPEX_without_edu_health + postsoviet
xtmixed dv_index migstock_pct_wbt1 MIPEX_without_edu_health_2007_20 postsoviet `indlev' `2006' `ml' 
margins, dydx(migstock_pct) saving("t64m7",replace)
xtmixed dv_index migstock_pct_wbt1 MIPEX_without_edu_health_2007_20 postsoviet `indlev' `2016' `ml' 
margins, dydx(migstock_pct) saving("t64m8",replace)



local fbindlev       "sex age age2 ib2.edu ib4.employ"
local indlev        "sex age age2 ideo ib2.edu ib4.employ"
local 2006			"if year==2006"
local 2016			"if year==2016"
local ml	 		"|| country:, mle"

**************** IV: Inflow
* Controls: Ind.-Lev
xtmixed dv_index inflowpctt1 `indlev' `2006' `ml' 
margins, dydx(inflowpctt1) saving("t64m9",replace)
xtmixed dv_index inflowpctt1 `indlev' `2016' `ml' 
margins, dydx(inflowpctt1) saving("t64m10",replace)


* Controls: Ind.-Lev + Social Welfare Expend. + postsoviet
xtmixed dv_index inflowpctt1 socx_oecdt1 postsoviet `indlev' `2006' `ml'
margins, dydx(inflowpctt1) saving("t64m11",replace)
xtmixed dv_index inflowpctt1 socx_oecdt1 postsoviet `indlev' `2016' `ml' 
margins, dydx(inflowpctt1) saving("t64m12",replace)

* Controls: Ind.-Lev + Employment + postsoviet
xtmixed dv_index inflowpctt1 wdi_unempilo postsoviet `indlev' `2006' `ml'
margins, dydx(inflowpctt1) saving("t64m13",replace)
xtmixed dv_index inflowpctt1 wdi_unempilo postsoviet  `indlev' `2016' `ml' 
margins, dydx(inflowpctt1) saving("t64m14",replace)

* Controls: Ind.-Lev + MIPEX_without_edu_health + postsoviet
xtmixed dv_index inflowpctt1 MIPEX_without_edu_health_2007_20 postsoviet `indlev' `2006' `ml'
margins, dydx(inflowpctt1) saving("t64m15",replace)
xtmixed dv_index inflowpctt1 MIPEX_without_edu_health_2007_20 postsoviet `indlev' `2016' `ml' 
margins, dydx(inflowpctt1) saving("t64m16",replace)

use t64m1,clear
foreach x of numlist 2/16 {
append using t64m`x'
}

gen factor = "Stock"
replace factor = "Flow" if [_n]>8

gen id = "t64m1"
foreach x of numlist 2/16 {
replace id = "t64m`x'" if [_n]==`x'
}

clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
order factor AME lower upper id
keep factor AME lower upper id
save team64, replace

foreach x of numlist 1/16 {
erase t64m`x'.dta
}

erase merged_data_64.dta
erase cntry_data_64.dta
erase issp_2016.dta
erase issp_2006.dta

 }
*==============================================================================*
*==============================================================================*
*==============================================================================*

































// TEAM 65
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team65.dta"
  if _rc==0   {
    display "Team 65 already exists, skipping to next code chunk"
  }
  else {
*PI rewrote their cleaning code in Stata. They used SPSS, but did it manually
*with the drop down menus, so the coding has some missing steps.


*1996
use ZA2900.dta, clear
g OldCare = .
	replace OldCare = 0 if v39 == 3 | v39 == 4
	replace OldCare = 1 if v39 == 1 | v39 == 2

g Unemployed = .
	replace Unemployed = 0 if v41 == 3 | v41 == 4
	replace Unemployed = 1 if v41 == 1 | v41 == 2
	
g ReduceDiff = .
	replace ReduceDiff = 0 if v42 == 3 | v42 == 4
	replace ReduceDiff = 1 if v42 == 1 | v42 == 2

g Jobs = .
	replace Jobs = 0 if v36 == 3 | v36 == 4
	replace Jobs = 1 if v36 == 1 | v36 == 2

recode v200 (1=0)(2=1)(*=.), gen(female)

recode v205 (1/4=1)(5/6=0)(*=.), gen(educ_prim)
recode v205 (5/6=1)(1/4=0)(*=.), gen(educ_sec)
recode v205 (7=1)(5/6=0)(1/4=0)(*=.), gen(educ_ter)

gen age = v201
gen age_sq = age*age

recode v206 (2/3=1)(1 5 4 6 7/10 =0)(*=.), gen(emp_part)
recode v206 (4 6/10=1)(1/3 5=0)(*=.), gen(emp_notact)
recode v206 (5=1)(1/4 6/10=0)(*=.), gen(emp_unemp)
recode v206 (1=1)(2/10=0)(*=.), gen(emp_full)

recode v3 (1=36)(2=276)(3=276)(4=826)(6=840)(8=348)(10=372)(11=528)(12=578) ///
(13=752)(14=203)(15=705)(16=616)(18=643)(19=554)(20=124)(22=376)(23=376)(24=392) ///
(25=724)(26=428)(27=250)(30=756), gen(cntry)
drop if cntry<36

gen year2006=0
gen year2016=0
keep OldCare Unemployed ReduceDiff Jobs female age age_sq ///
educ_prim educ_ter emp_part emp_notact emp_unemp year2006 year2016 cntry


save 1996_65.dta, replace

*2006
use ZA4700.dta, clear	

g OldCare = .
	replace OldCare = 0 if V28 == 3 | V28 == 4
	replace OldCare = 1 if V28 == 1 | V28 == 2

g Unemployed = .
	replace Unemployed = 0 if V30 == 3 | V30 == 4
	replace Unemployed = 1 if V30 == 1 | V30 == 2

g ReduceDiff = .
	replace ReduceDiff = 0 if V31 == 3 | V31 == 4
	replace ReduceDiff = 1 if V31 == 1 | V31 == 2

g Jobs = .
	replace Jobs = 0 if V25 == 3 | V25 == 4
	replace Jobs = 1 if V25 == 1 | V25 == 2

recode sex (1=0)(2=1)(*=.), gen(female)

recode degree (0/1=1)(2/5=0)(*=.), gen(educ_prim)
recode degree (2/4=1)(0/1 5=0)(*=.), gen(educ_sec)
recode degree (5=1)(0/4=0)(*=.), gen(educ_ter)

gen age_sq = age*age

recode wrkst (2/3=1)(1 5 4 6 7/10 =0)(*=.), gen(emp_part)
recode wrkst (4 6/10=1)(1/3 5=0)(*=.), gen(emp_notact)
recode wrkst (5=1)(1/4 6/10=0)(*=.), gen(emp_unemp)
recode wrkst (1=1)(2/10=0)(*=.), gen(emp_full)

gen cntry = V3a	
gen year2006=1
gen year2016=0
keep OldCare Unemployed ReduceDiff Jobs female age age_sq ///
educ_prim educ_ter emp_part emp_notact emp_unemp year2006 year2016 cntry

save 2006_65.dta, replace

*2016		
use ZA6900_v2-0-0, clear
g OldCare = .
	replace OldCare = 0 if v24 == 3 | v24 == 4
	replace OldCare = 1 if v24 == 1 | v24 == 2

g Unemployed = .
	replace Unemployed = 0 if v26 == 3 | v26 == 4
	replace Unemployed = 1 if v26 == 1 | v26 == 2
	
g ReduceDiff = .
	replace ReduceDiff = 0 if v27 == 3 | v27 == 4
	replace ReduceDiff = 1 if v27 == 1 | v27 == 2

g Jobs = .
	replace Jobs = 0 if v21 == 3 | v21 == 4
	replace Jobs = 1 if v21 == 1 | v21 == 2 

recode SEX (1=0)(2=1)(*=.), gen(female)

*we added 6, change if it doesn't work at the end
recode DEGREE (0/1=1)(2/5=0)(*=.), gen(educ_prim)
recode DEGREE (2/4=1)(0/1 5=0)(*=.), gen(educ_sec)
*recode DEGREE (5/6=1)(0/4=0)(*=.), gen(educ_ter)
recode DEGREE (5=1)(0/4=0)(*=.), gen(educ_ter)


gen age = AGE
gen age_sq = age*age

recode MAINSTAT (1=1)(2/8=0)(*=.), gen(emp_part)
recode emp_part (1=0) if WRKHRS >= 35
recode MAINSTAT (4/8=1)(1/3=0)(*=.), gen(emp_notact)
recode MAINSTAT (2=1)(1 3/8=0)(*=.), gen(emp_unemp)
recode MAINSTAT (1=1)(2/8=0)(*=.), gen(emp_full)
recode emp_full (1=0) if WRKHRS < 35

gen cntry = country

recode cntry (36 158 191 203 208 246 250 276 348 376 ///
392 410 428 554 578 705 724 826 840	= 1), gen(drop)
drop if drop!=1

gen year2016=1
gen year2006=0
keep OldCare Unemployed ReduceDiff Jobs female age age_sq ///
educ_prim educ_ter emp_part emp_notact emp_unemp year2006 year2016 cntry

save 2016_65.dta, replace

append using 1996_65.dta
append using 2006_65.dta

recode cntry (152 214 484 608 710 862 858 792 850=1), gen(drop)
drop if drop==1

gen age_sq_meancentrd = age_sq - 4021.179
recode cntry (191 203 348 428 616 643 705 =1)(*=0), gen(statesocialist)

gen year=1996 if year2006==0 & year2016==0
replace year=2006 if year2006==1
replace year=2016 if year2016==1

*L2
preserve
use cri_macro1.dta, clear
gen foreignpct = migstock_wb[_n-1]
destring foreignpct, replace
gen incrimmig1y = foreignpct - foreignpct[_n-1]
gen incrimmig10y = foreignpct - foreignpct[_n-10]
destring socx_oecd, replace
destring wdi_empprilo, replace
gen emprate = wdi_empprilo
gen socx = socx_oecd
sort cntry year
save team65merge, replace
restore

sort cntry year
merge m:m cntry year using team65merge.dta
drop if _merge==2


*PI Note. Estimates are nearly identical, but not exact.

* ANALYSES
xtset cntry

local dep "OldCare Unemployed ReduceDiff Jobs" 
local iv "female age age_sq_meancentrd educ_prim educ_ter emp_part emp_notact emp_unemp year2006 year2016"
local i 1

foreach j of local dep{
	xtlogit `j' foreignpct statesocialist `iv', or
	margins, dydx(foreignpct) saving("t65m`i'.dta", replace)
	est sto M`i'
	local i = `i' + 1
}

foreach j of local dep{
	xtlogit `j' foreignpct socx statesocialist `iv', or
	margins, dydx(foreignpct) saving("t65m`i'.dta", replace)
	est sto M`i'
	local i = `i' + 1
}

foreach j of local dep{
	xtlogit `j' foreignpct emprate statesocialist `iv', or
	margins, dydx(foreignpct) saving("t65m`i'.dta", replace)
	est sto M`i'
	local i = `i' + 1
}

foreach j of local dep{
	xtlogit `j' incrimmig1y statesocialist `iv', or
	margins, dydx(incrimmig1y) saving("t65m`i'.dta", replace)
	est sto M`i'
	local i = `i' + 1
}

foreach j of local dep{
	xtlogit `j' incrimmig1y socx statesocialist `iv', or
	margins, dydx(incrimmig1y) saving("t65m`i'.dta", replace)
	est sto M`i'
	local i = `i' + 1
}

foreach j of local dep{
	xtlogit `j' incrimmig1y emprate statesocialist `iv', or
	margins, dydx(incrimmig1y) saving("t65m`i'.dta", replace)
	est sto M`i'
	local i = `i' + 1
}

*PI adjustment
replace incrimmig10y=incrimmig10y/10
//

foreach j of local dep{
	xtlogit `j' incrimmig10y statesocialist `iv', or
	margins, dydx(incrimmig10y) saving("t65m`i'.dta", replace)
	est sto M`i'
	local i = `i' + 1
}

foreach j of local dep{
	xtlogit `j' incrimmig10y socx statesocialist `iv', or
	margins, dydx(incrimmig10y) saving("t65m`i'.dta", replace)
	est sto M`i'
	local i = `i' + 1
}

foreach j of local dep{
	xtlogit `j' incrimmig10y emprate statesocialist `iv', or
	margins, dydx(incrimmig10y) saving("t65m`i'.dta", replace)
	est sto M`i'
	local i = `i' + 1
}

use t65m1.dta, clear
foreach i of numlist 2/36 {
append using t65m`i'.dta
}

gen factor = "Stock"
replace factor = "Flow" if [_n]>12
gen id = "t65m1"
foreach i of numlist 2/36 {
replace id = "t65m`i'" if [_n]==`i'
}
clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
order factor AME lower upper id
keep factor AME lower upper id
save team65, replace

foreach x of numlist 1/36 {
erase "t65m`x'.dta"
}
erase "team65merge.dta"
erase "1996_65.dta"
erase "2006_65.dta"
erase "2016_65.dta"

}
*==============================================================================*
*==============================================================================*
*==============================================================================*

























// TEAM 68
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team68.dta"
  if _rc==0   {
    display "Team 68 already exists, skipping to next code chunk"
  }
  else {

global w2 ZA4700			// 2006
global w3 ZA6900_v2-0-0		// 2016

global l2 macros

*************** MACROS *************
************************************

insheet using "cri_macro.csv", clear

drop if year<2000 | year >=2017

preserve 
import excel ISO using "Macros_Sample_68.xlsx", sheet("Overview") clear 
drop if inlist(ISO, "ISO", "")
destring ISO, gen(iso_country)
drop ISO
tempfile cntry
save `cntry'
restore

merge m:1 iso_country using `cntry', nogen keep(matched)

replace socx_oecd="" if inlist(socx_oecd, ".", "..", "#VALUE!")
destring socx_oecd, replace	
bysort country: egen foo= count(socx_oecd)
drop if foo==0
drop foo	


drop gdp_wb gdp_twn	
drop ginim_dolt gini_wb gini_wid 
drop wdi_unempilo
drop migstock_wb migstock_oecd	
drop gni_wb	top10_wid mcp al_ethnic dpi_tf

tempfile macros
save `macros'


*******************************************************************************

**************************
*** Additional macros ****

* MIPEX
import excel using "MIPEX.xlsx", sheet("wide") clear first
destring mipex_*, replace
reshape long mipex_, i(iso_country) j(year)
rename mipex_ mipex
export excel using "MIPEX.xlsx", sheet("long") sheetmodify
tempfile mipex
save `mipex'

* Migration Inflow
import excel using "Mig_Inflow_OECD.xlsx", sheet("wide") clear first
destring miginflow_*, replace
reshape long miginflow_, i(iso_country) j(year)
rename miginflow_ miginflow
export excel using "Mig_Inflow_OECD.xlsx", sheet("long") sheetmodify
tempfile miginflow
save `miginflow'

* Refugee Inflow
import excel using "Ref_Inflow_OECD.xlsx", sheet("wide") clear first
destring refinflow_*, replace
reshape long refinflow_, i(iso_country) j(year)
rename refinflow_ refinflow
export excel using "Ref_Inflow_OECD.xlsx", sheet("long") sheetmodify
tempfile refinflow
save `refinflow'

* Infos 
use `macros', clear
merge 1:1 iso_country year using `mipex', nogen keep(master match) keepusing(mipex)
merge 1:1 iso_country year using `miginflow', nogen keep(master match) keepusing(miginflow)
merge 1:1 iso_country year using `refinflow', nogen keep(master match) keepusing(refinflow)


* GDP
gen foo1= gdp_oecd if year==2006
gen foo2= gdp_oecd if year==2016

bysort iso_country: egen gdp2006= max(foo1)
bysort iso_country: egen gdp2016= max(foo2)

drop foo*

* Gini 
gen foo11= ginid_solt if year==2006
gen foo12= ginid_solt if year==2004

gen foo21= ginid_solt if year==2016
bysort iso_country: replace foo21= ginid_solt[_n-1] if ginid_solt==.
gen foo22= ginid_solt if year==2014

bysort iso_country: egen gini_12006= max(foo11)
bysort iso_country: egen gini_22006= max(foo12)	
bysort iso_country: egen gini_12016= max(foo21)
bysort iso_country: egen gini_22016= max(foo22)	

drop foo*

* Employment rate
gen foo1= wdi_empprilo if year==2006
gen foo2= wdi_empprilo if year==2016

bysort iso_country: egen emplr2006= max(foo1)
bysort iso_country: egen emplr2016= max(foo2)

drop foo*

* Social welfare expenditures
gen foo11= socx_oecd if year==2006
gen foo12= socx_oecd if year==2003

gen foo21= socx_oecd if year==2016
bysort iso_country: replace foo21= socx_oecd[_n-1] if socx_oecd==.
gen foo22= socx_oecd if year==2013

bysort iso_country: egen socx_12006= max(foo11)
bysort iso_country: egen socx_22006= max(foo12)	
bysort iso_country: egen socx_12016= max(foo21)
bysort iso_country: egen socx_22016= max(foo22)	

drop foo*

* Immigrant Stock 
gen foo1= migstock_un if year==2005
gen foo2= migstock_un if year==2015

bysort iso_country: egen migstock2006= max(foo1)
bysort iso_country: egen migstock2016= max(foo2)

drop foo*


* Net-Migration 
gen foo1= mignet_un if year==2005
gen foo2= mignet_un if year==2015

bysort iso_country: egen mignet2006= max(foo1)
bysort iso_country: egen mignet2016= max(foo2)

drop foo*


* Mig Inflow 					
gen foo11= (miginflow/pop_wb)*1000 if year==2005
gen foo12= foo11
replace foo12= (miginflow/pop_wb)*1000 if year==2007 & country=="Slovenia"
gen foo21= (miginflow/pop_wb)*1000 if year==2015
gen foo22= foo21
replace foo22= (miginflow/pop_wb)*1000 if year==2010 & country=="Turkey"

bysort iso_country: egen miginflow_12006= max(foo11)
bysort iso_country: egen miginflow_22006= max(foo12)
bysort iso_country: egen miginflow_12016= max(foo21)
bysort iso_country: egen miginflow_22016= max(foo22)

drop foo*	

* Refugee Inflow 
tab country year if refinflow!=.	

gen foo1= (refinflow/pop_wb)*1000 if year==2005
gen foo2= (refinflow/pop_wb)*1000 if year==2015

bysort iso_country: egen refinflow2006= max(foo1)
bysort iso_country: egen refinflow2016= max(foo2)

drop foo*								


* MIPEX
tab country year if mipex!=.											
								
gen foo11= mipex if year==2007				
bysort iso_country: replace foo11= mipex[_n+1] if mipex==.
gen foo12= mipex if year==2010				
bysort iso_country: egen foo13= mean(mipex)		

gen foo21= mipex if year==2014	
gen foo22= mipex if year==2014
bysort iso_country: egen foo23= mean(mipex)	

bysort iso_country: egen mipex_12006= max(foo11)
bysort iso_country: egen mipex_22006= max(foo12)
bysort iso_country: egen mipex_32006= max(foo13)
bysort iso_country: egen mipex_12016= max(foo21)
bysort iso_country: egen mipex_22016= max(foo22)
bysort iso_country: egen mipex_32016= max(foo23)
								
drop foo*	

keep iso_country *2006 *2016

sample 1, count by(iso_country)
reshape long gdp gini_1 gini_2 emplr socx_1 socx_2 migstock mignet miginflow_1 miginflow_2 refinflow mipex_1 mipex_2 mipex_3, i(iso_country) j(year)


save "macros.dta", replace

***2006***

use  "${w2}.dta", clear

***** AVs *****
***************

*** Old age care (agecare)
clonevar att_agecare = V28

*** Unemployed (unemp)
clonevar att_unemp = V30

*** Reduce Income Differences (incdiff)
clonevar att_incdiff = V31

*** Jobs (jobs)
clonevar att_jobs = V25

*** Health care (healthcare) V33
clonevar att_healthcare = V27

*** Housing (housing) 
clonevar att_housing = V33

unab att: att_*
label define att 4 "Definitely should be" 3 "Probably should be" 2 "Probably should not be" 1 "Definitely should not be"
foreach var of local att {
	replace `var'=5-`var'
	label value `var' att

}

***** UVs *****
*************** 

*** Country (cntry)	
rename V3a cntry

*** Year (year) 
gen year=2006  

*** Female (female)
recode sex (1 = 0 "male")(2 = 1 "female"), gen(female)
label var female "Female"

*** Age (age) 
label var age "Age"

*** Age-squared (age_2)
gen age_2 = age*age
label var age_2 "Age-squared"

*** Education categories (edu)

recode degree (0 1 = 1 "Primary or less") (2 3 = 0 "Secondary") ///
			(4 5 = 2 "University or more"), gen(edu)
label variable edu "Education"			

*** Employed vs unemployed/not active (emp)
recode wrkst (1 2 3 = 1 "employed") (4/10 = 0 "unemployed / not active")  ///
			 , gen(emp)
label variable emp "Employed"	
		
*** Marital status	
recode marital (1 4 = 0 "Married") (5 = 1 "Never married") (3 = 2 "Divorced") (2 = 3 "Widowed"), generate(married)
label variable married "Marital status"

*** Relative income (household)
generate income = .
decode cntry, generate(cntry_s)		// Country-string Variable

unab income: *_INC					// Local mit allen INC-Vars
foreach var of local income {	

	local country=substr("`var'",1,2)			// schneide Länderkürzel aus
	bysort cntry: center `var', stand			// erstelle stand. Variable	
	replace income = c_`var' if regex(cntry_s, "`country'")	// ersetze neue Var mit stand. Wert, wenn cntry_s==entspr. Länderkürzel
}
// Test
assert income==c_AU_INC if cntry==36
assert income==c_SI_INC if cntry==705


*** Household size
rename hompop  hh_size
label variable hh_size "Household size"


*** Children in household
recode hhcycle (1 5 9 11 13 15 17 19 21 23 25 = 0 "No") (2 3 4 6 7 8 10 12 14 16 18 20 22 24 26 28 = 1 "yes") (95=.), generate(children)
label variable children "Children in HH"


*** Rural/Urban
recode urbrural (1 = 0 "Urban") (4 5 = 1 "Rural") (2 3 = 2 "Suburb/Town"), generate(urban)
label variable urban "Urban"

*** Religious attendance
recode attend (8 = 0 "no attendance") (6 7 = 1 "Low religious attendance") (1 2 3 4 5 = 2 "High religious attendance"), generate(religion)
label variable religion "Religous attendance"
			
order V2 year cntry att_* age age_2 female married hh_size children urban edu emp income religion
keep V2 year cntry att_* age age_2 female married hh_size children urban edu emp income religion


save "${w2}_prep.dta", replace

***2016***

***** AVs *****
***************
use "${w3}.dta", clear 
*** Old age care (agecare)
clonevar att_agecare = v24
replace att_agecare =. if inlist(att_agecare, 8, 9)

*** Unemployed (unemp)
clonevar att_unemp = v26
replace att_unemp =. if inlist(att_unemp, 0, 8, 9)

*** Reduce Income Differences (incdiff)
clonevar att_incdiff = v27
replace att_incdiff =. if inlist(att_incdiff, 8, 9)

*** Jobs (jobs)
clonevar att_jobs = v21
replace att_jobs =. if inlist(att_jobs, 8, 9)

*** Health care (healthcare)
clonevar att_healthcare = v23
replace att_healthcare =. if inlist(att_healthcare, 8, 9)

*** Housing (housing) 
clonevar att_housing = v29
replace att_housing =. if inlist(att_housing, 8, 9)

unab att: att_*
label define att 4 "Definitely should be" 3 "Probably should be" 2 "Probably should not be" 1 "Definitely should not be"
foreach var of local att {
	replace `var'=5-`var'
	label value `var' att

}


***** UVs *****
*************** 

rename CASEID V2

*** Country (cntry)	
rename country cntry

*** Year (year) 
gen year=2016  

*** Female (female)
recode SEX (1 = 0 "male")(2 = 1 "female") (9=.), gen(female)
label var female "Female"

*** Age (age)
recode AGE (0 999=.), gen(age) 
label var age "Age"

recode DK_AGE (0 = .)
replace age = DK_AGE if cntry == 208

*** Age-squared (age_2)
gen age_2 = age*age
label var age_2 "Age-squared"


*** Education categories (edu)

recode DEGREE (0 1 = 1 "Primary or less") (2 3 4 = 0 "Secondary") ///
			(5 6 = 2 "University or more") (9 = .), gen(edu)
label variable edu "Education"			


*** Employed vs unemployed/not active (emp)
recode WORK (1 = 1 "employed") (2 3 = 0 "unemployed / not active") (9 = .) ///
			 , gen(emp)
label variable emp "Employed"		
	
	
*** Marital status	
recode MARITAL (1 2 3 = 0 "Married") (6 = 1 "Never married") (4 = 2 "Divorced") ///
				(5 = 3 "Widowed") (7 9 =.) , generate(married)
label variable married "Marital status"


*** Relative income (Household)
// Missings
mvdecode BE_INC CH_INC CZ_INC DE_INC ES_INC FI_INC FR_INC GB_INC GE_INC HR_INC HU_INC IL_INC IN_INC LT_INC LV_INC NZ_INC PH_INC RU_INC SE_INC SI_INC SK_INC SR_INC TH_INC TR_INC US_INC ZA_INC ///
	, mv(999990 999997 999998 999999=.a) 
mvdecode AU_INC CL_INC DK_INC IS_INC NO_INC TW_INC VE_INC, mv(9999990 9999998 9999997 9999999=.a) 
mvdecode JP_INC, mv(99999990 99999999 =.a) 
mvdecode KR_INC, mv(999999990 999999998 =.a) 

generate income = .
decode cntry, generate(cntry_s)		// Country-string Variable

unab income: *_INC					// Local mit allen INC-Vars
display "`income'"
foreach var of local income {	

	local country=substr("`var'",1,2)			// schneide Länderkürzel aus
	bysort cntry: center `var', stand			// erstelle stand. Variable	
	replace income = c_`var' if regex(cntry_s, "`country'")	// ersetze neue Var mit stand. Wert, wenn cntry_s==entspr. Länderkürzel
}
// Test
assert income==c_AU_INC if cntry==36
assert income==c_SI_INC if cntry==705


*** Household size
// Achtung: Sprünge in der Skala, in zwei Ländern Abweichungen -> trotzdem metrisch verwendbar
recode HOMPOP (99 0 = .), generate(hh_size)
label variable hh_size "Household size"


*** Children in household
gen children =.
replace children = 0 if HHCHILDR==0 & HHTODD==0
replace children = 1 if (inlist(HHCHILDR,1,2,3,4,5,6,7,8,9,11,13) | inrange(HHTODD,1,6))
label variable children "Children in HH"


*** Rural/Urban
recode URBRURAL (1 = 0 "Urban") (4 5 = 1 "Rural") (2 3 = 2 "Suburb/Town") ///
					(0 7 8 9=.), generate(urban)
label variable urban "Urban"

*** Religious attendance
recode ATTEND (8 = 0 "no attendance") (6 7 = 1 "Low religious attendance") ///
			(1 2 3 4 5 = 2 "High religious attendance") (0 97 98 99=.), generate(religion)		
label variable religion "Religous attendance"
			
order V2 year cntry att_* age age_2 female married hh_size children urban edu emp income religion
keep  V2 year cntry att_* age age_2 female married hh_size children urban edu emp income religion


save "${w3}_prep.dta", replace

*** Append & Merge ***

use "${w2}_prep.dta", clear
append using "${w3}_prep.dta"
sort V2 year

// Merge with L2-Data
rename cntry iso_country
merge m:1 iso_country year using "${l2}.dta" , keep(3)

save "data_prep_15.dta", replace

erase "${w2}_prep.dta"
erase "${w3}_prep.dta"
 
 
***  
use "data_prep_15.dta", clear

egen att_index= rowmean(att_*)


* Sample restriction
gen sample=1
foreach x of varlist age age_2 female married hh_size children urban edu emp income religion miginflow_1 refinflow migstock gdp gini_2 emplr socx_2 mipex_2 {
	replace sample=0 if `x'==.
}

*** Descriptive ***
*******************

label define V3A 352 "IS-Iceland", modify
decode iso_country, generate(cntry_s)
replace cntry_s = substr(cntry_s,4,.)

*PI adjustment
replace miginflow_1=miginflow_1/10
//

*** Main analysis ***
*********************
loc a=1
loc b=8
loc c=15
loc d=22
loc e=29
loc f=36
loc g=43
loc h=50
loc i=57
loc j=64
loc k=71
loc l=78
loc m=85
loc n=92
loc o=99
loc p=106

*PI reordered DVs to follow our scheme
foreach x of varlist att_jobs att_unemp att_incdiff att_agecare att_housing att_healthcare att_index  {

	qui mixed `x' age age_2 female i.married hh_size children i.urban i.edu emp income i.religion miginflow_1 || iso_country: || year: if sample==1
	margins,dydx(miginflow_1) saving("t68m`b'",replace)
	tab iso_country if e(sample)==1 & `a'==1
	qui mixed `x' age age_2 female i.married hh_size children i.urban i.edu emp income i.religion migstock || iso_country: || year: if sample==1
	margins,dydx(migstock) saving("t68m`a'",replace)
	tab iso_country if e(sample)==1 & `a'==1
	qui mixed `x' age age_2 female i.married hh_size children i.urban i.edu emp income i.religion miginflow_1 migstock || iso_country: || year: if sample==1
	tab iso_country if e(sample)==1 & `a'==1
	margins,dydx(migstock) saving("t68m`c'",replace)
	margins,dydx(miginflow_1) saving("t68m`d'",replace)
	qui mixed `x' age age_2 female i.married hh_size children i.urban i.edu emp income i.religion miginflow_1 migstock gdp  || iso_country: || year: if sample==1
	tab iso_country if e(sample)==1 & `a'==1
	margins,dydx(migstock) saving("t68m`e'",replace)
	margins,dydx(miginflow_1) saving("t68m`f'",replace)
	qui mixed `x' age age_2 female i.married hh_size children i.urban i.edu emp income i.religion miginflow_1 migstock gini_2 || iso_country: || year: if sample==1
	tab iso_country if e(sample)==1 & `a'==1
	margins,dydx(migstock) saving("t68m`g'",replace)
	margins,dydx(miginflow_1) saving("t68m`h'",replace)
	qui mixed `x' age age_2 female i.married hh_size children i.urban i.edu emp income i.religion miginflow_1 migstock emplr || iso_country: || year: if sample==1
	tab iso_country if e(sample)==1 & `a'==1
	margins,dydx(migstock) saving("t68m`i'",replace)
	margins,dydx(miginflow_1) saving("t68m`j'",replace)
	qui mixed `x' age age_2 female i.married hh_size children i.urban i.edu emp income i.religion miginflow_1 migstock socx_2 || iso_country: || year: if sample==1
	tab iso_country if e(sample)==1 & `a'==1
	margins,dydx(migstock) saving("t68m`k'",replace)
	margins,dydx(miginflow_1) saving("t68m`l'",replace)
	qui mixed `x' age age_2 female i.married hh_size children i.urban i.edu emp income i.religion miginflow_1 migstock mipex_2 || iso_country: || year: if sample==1
	tab iso_country if e(sample)==1 & `a'==1
	margins,dydx(migstock) saving("t68m`m'",replace)
	margins,dydx(miginflow_1) saving("t68m`n'",replace)
	qui mixed `x' age age_2 female i.married hh_size children i.urban i.edu emp income i.religion miginflow_1 migstock gdp gini_2 emplr socx_2 mipex_2 || iso_country: || year: if sample==1
	tab iso_country if e(sample)==1 & `a'==1
	margins,dydx(migstock) saving("t68m`o'",replace)
	margins,dydx(miginflow_1) saving("t68m`p'",replace)
	loc a=`a'+1
	loc b=`b'+1
	loc c=`c'+1
	loc d=`d'+1
	loc e=`e'+1
	loc f=`f'+1
	loc g=`g'+1
	loc h=`h'+1
	loc i=`i'+1
	loc j=`j'+1
	loc k=`k'+1
	loc l=`l'+1
	loc m=`m'+1
	loc n=`n'+1
	loc o=`o'+1
	loc p=`p'+1
}


use t68m1,clear
foreach x of numlist 2/112 {
append using t68m`x'
}
gen f=[_n]
gen factor = "Stock" 
replace factor = "Flow" if (f>7 & f<15)|(f>21 & f<29)|(f>35 & f<43)|(f>49 & f<57)|(f>63 & f<71)|(f>77 & f<85)|(f>91 & f<99)|f>105

gen id ="t68m1"
foreach x of numlist 2/112 {
replace id = "t68m`x'" if f==`x'
}
clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
order factor AME lower upper id
keep factor AME lower upper id
save team68, replace


foreach x of numlist 1/112{
erase t68m`x'.dta
}

erase data_prep_15.dta
erase macros.dta
}
*==============================================================================*
*==============================================================================*
*==============================================================================*



























// TEAM 72
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team72.dta"
  if _rc==0   {
    display "Team 72 already exists, skipping to next code chunk"
  }
  else {

********************************************************************************
* PREPARE 1996 DATA

use "ZA2900.dta", clear

gen job = .
replace job = 1 if (v36==1)|(v36==2)
replace job = 0 if (v36==3)|(v36==4)
label define yesno 1 "Yes" 0 "No"
label values job yesno
label variable job "Gvmt should provide jobs"

gen employ = .
replace employ = 1 if (v41==1)|(v41==2)
replace employ = 0 if (v41==3)|(v41==4)
label values employ yesno
label variable employ "Gvmt should provide living for unemployed"

gen income = .
replace income = 1 if (v42==1)|(v42==2)
replace income = 0 if (v42==3)|(v42==4)
label values income yesno
label variable income "Gvmt should reduce income inequality"

gen old = .
replace old = 1 if (v39==1)|(v39==2)
replace old = 0 if (v39==3)|(v39==4)
label values old yesno
label variable old "Gvmt should provide living for old"

capture drop house
gen house = .
replace house = 1 if (v44==1)|(v44==2)
replace house = 0 if (v44==3)|(v44==4)
label values house yesno
label variable house "Gvmt should provide housing"

gen sick = .
replace sick = 1 if (v38==1)|(v38==2)
replace sick = 0 if (v38==3)|(v38==4)
label values sick yesno
label variable sick "Gvmt should provide healthcare"


* Individual Level Controls:

* Age and Age-Squared in Years
gen age = v201
label variable age "Age in Years"

gen agesq = age*age
label variable agesq "Age Squared"

* Female is coded one

gen female = .
replace female = 1 if (v200==2)
replace female = 0 if (v200==1)
label values female yesno
label variable female "Female"

* With married as a reference, dummies indicate never married, divorced,
* and widowed

tab v202, gen(marital)

rename marital1 married
label variable married "Married"
label values married yesno

rename marital2 widowed
label variable widowed "Widowed"
label values widowed yesno

rename marital3 divorced
label variable divorced "Divorced"
label values divorced yesno

rename marital4 separated
label variable separated "Separated"
label values separated yesno

rename marital5 single
label variable single "Never Married"
label values single yesno


egen divsep = rmax(divorced separated)
label variable divsep "Divorced or Separated"
label values divsep yesno

* Household size
gen hhsize = v273
label variable hhsize "Household Size"

* Binary indicator for children in the household

gen childhh = 0 if (v274!=.)
replace childhh = 1 if (v274==2)|(v274==3)|(v274==4)| ///
						(v274==6)|(v274==7)|(v274==8)| ///
						(v274==10)|(v274==12)|(v274==14)| ///
						(v274==16)|(v274==18)|(v274==20)| ///
						(v274==22)|(v274==24)|(v274==26)
label values childhh yesno
label variable childhh "Children in the HHld"
				
* Dummies for suburb/town and rural are relative to urban.

gen urban = 0 if (v275!=.)
replace urban = 1 if (v275==1)
label values urban yesno
label variable urban "Lives in Urban Area"

gen town = 0 if (v275!=.)
replace town = 1 if (v275==2)
label values town yesno
label variable town "Lives in Suburbs/Town"

capture drop rural
gen rural = 0 if (v275!=.)
replace rural = 1 if (v275==3)
label values rural yesno
label variable rural "Lives in Rural Area"


gen lowed = 0 if (v205!=.)
replace lowed = 1 if (v205>=1)&(v205<=4)
label values lowed yesno
label variable lowed "Education Less than High School"

gen meded = 0 if (v205!=.)
replace meded = 1 if (v205>=5)&(v205<=6)
label values meded yesno
label variable meded "Education High School"

capture drop highed
gen highed = 0 if (v205!=.)
replace highed = 1 if (v205==7)
label values highed yesno
label variable highed "Education Degree of Above"



* This variable is employment status
tab v206

* This variable shows whether public or private
tab v212 

* This variable shows whether they are self employed
tab v213

capture drop ft
gen ft = 0 if (v206!=.)
replace ft = 1 if (v206==1)
label values ft yesno
label variable ft "Full Time Employment"

gen pt = 0 if (v206!=.)
replace pt = 1 if (v206==2)|(v206==3)|(v206==4)
label values pt yesno
label variable pt "Part Time Employment"

gen out = 0 if (v206!=.)
replace out = 1 if (v206>=6)&(v206<=10)
label values out yesno
label variable out "Out of the Labour Market"

gen un = 0 if (v206!=.)
replace un = 1 if (v206==5)
label values un yesno
label variable un "Unemployed"


gen ftself = 0 if (v206!=.)
replace ftself = 1 if (ft==1)&(v213==1)
label values ftself yesno
label variable ftself "Full Time Self Employed"

gen ftpub = 0 if (v206!=.)
replace ftpub = 1 if (ft==1)&((v212==1)|(v212==2))
label values ftpub yesno
label variable ftpub "Full Time Self Public"


gen ftpriv = 0 if (v206!=.)
replace ftpriv = 1 if (ft==1)&((v212==3)|(v212==6))
label values ftpriv yesno
label variable ftpriv "Full Time Private"


gen incomescore = .
label variable incomescore "Country Income Z Scores"

levelsof v3, local(countries)
foreach value of local countries {
	zscore v218 if v3 == `value', listwise
	replace incomescore = z_v218 if v3 ==`value'
	drop z_v218
}

gen religion = .
replace religion = 1 if (v220==6)
replace religion = 2 if (v220>=4)&(v220<=5)
replace religion = 3 if (v220>=1)&(v220<=3)
label define religion 1 "Never" 2 "Low" 3 "High"
label values religion religion
label variable religion "Religious Attendance"
tab religion, gen(religion)
rename religion1 lowrelig
label variable lowrelig "Low Religious Attendance"
rename religion2 highrelig
label variable highrelig "High Religious Attendance"
tab1 lowrelig highrelig

gen country = .
replace country = 1 if (v3==1)
replace country = 2 if (v3==20)
replace country = 5 if (v3==27)
replace country = 6 if (v3==2)|(v3==3)
replace country = 7 if (v3==10)
replace country = 8 if (v3==24)
replace country = 10 if (v3==19)
replace country = 11 if (v3==12)
replace country = 13 if (v3==25)
replace country = 14 if (v3==13)
replace country = 15 if (v3==30)
replace country = 16 if (v3==4)
replace country = 17 if (v3==6)
label define country 1 "Australia" 2 "Canada"  3 "Denmark"  ///
					4 "Finland"  5 "France"  6 "Germany"  ///
					7 "Ireland"  8 "Japan"  9 "Netherlands"  ///
					10 "New Zealand"  11 "Norway"  12 "Portugal"  ///
					13 "Spain"  14 "Sweden"  15 "Switzerland"  ///
					16 "UK"  17 "USA" 
label values country country
numlabel country, add

keep lowrelig highrelig incomescore pt out un ftpub ftself ftpriv lowed meded highed ///
		urban rural town childhh hhsize divsep single widowed married ///
		female age agesq sick house old income employ job country v2
		
capture drop year
gen year = .
replace year = 1996
label variable year "Data Year"

sort country

save "1996ISSP.dta", replace


********************************************************************************
* PREPARE 2006 DATA

use "ZA4700.dta", clear

gen job = .
replace job = 1 if (V25==1)|(V25==2)
replace job = 0 if (V25==3)|(V25==4)
label define yesno 1 "Yes" 0 "No"
label values job yesno
label variable job "Gvmt should provide jobs"

gen employ = .
replace employ = 1 if (V30==1)|(V30==2)
replace employ = 0 if (V30==3)|(V30==4)
label values employ yesno
label variable employ "Gvmt should provide living for unemployed"

gen income = .
replace income = 1 if (V31==1)|(V31==2)
replace income = 0 if (V31==3)|(V31==4)
label values income yesno
label variable income "Gvmt should reduce income inequality"

gen old = .
replace old = 1 if (V28==1)|(V28==2)
replace old = 0 if (V28==3)|(V28==4)
label values old yesno
label variable old "Gvmt should provide living for old"

capture drop house
gen house = .
replace house = 1 if (V33==1)|(V33==2)
replace house = 0 if (V33==3)|(V33==4)
label values house yesno
label variable house "Gvmt should provide housing"

capture drop sick
gen sick = .
replace sick = 1 if (V27==1)|(V27==2)
replace sick = 0 if (V27==3)|(V27==4)
label values sick yesno
label variable sick "Gvmt should provide healthcare"

* Individual Level Controls:

* Age and Age-Squared in Years

label variable age "Age in Years"

gen agesq = age*age
label variable agesq "Age Squared"

* Female is coded one
gen female = .
replace female = 1 if (sex==2)
replace female = 0 if (sex==1)
label values female yesno
label variable female "Female"

* With married as a reference, dummies indicate never married, divorced,
* and widowed
tab marital, gen(marital)

rename marital1 married
label variable married "Married"
label values married yesno

rename marital2 widowed
label variable widowed "Widowed"
label values widowed yesno

rename marital3 divorced
label variable divorced "Divorced"
label values divorced yesno

rename marital4 separated
label variable separated "Separated"
label values separated yesno

rename marital5 single
label variable single "Never Married"
label values single yesno

* The category separated is not mentioned in the paper so we will group
* this category with divorced.

egen divsep = rmax(divorced separated)
label variable divsep "Divorced or Separated"
label values divsep yesno

* Household size
gen hhsize = hompop
label variable hhsize "Household Size"

* Binary indicator for children in the household

gen childhh = 0 if (hhcycle!=.)
replace childhh = 1 if (hhcycle==2)|(hhcycle==3)|(hhcycle==4)| ///
						(hhcycle==6)|(hhcycle==7)|(hhcycle==8)| ///
						(hhcycle==10)|(hhcycle==12)|(hhcycle==14)| ///
						(hhcycle==16)|(hhcycle==18)|(hhcycle==20)| ///
						(hhcycle==22)|(hhcycle==24)|(hhcycle==26)| ///
						(hhcycle==28)|(hhcycle==29)
label values childhh yesno
label variable childhh "Children in the HHld"

gen urban = 0 if (urbrural!=.)
replace urban = 1 if (urbrural==1)
label values urban yesno
label variable urban "Lives in Urban Area"


gen town = 0 if (urbrural!=.)
replace town = 1 if (urbrural==2)|(urbrural==3)
label values town yesno
label variable town "Lives in Suburbs/Town"

gen rural = 0 if (urbrural!=.)
replace rural = 1 if (urbrural==4)|(urbrural==5)
label values rural yesno
label variable rural "Lives in Rural Area"

* Education uses secondary degree as a reference, with dummies for less than
* secondary and university or above.
gen lowed = 0 if (degree!=.)
replace lowed = 1 if (degree>=0)&(degree<=2)
label values lowed yesno
label variable lowed "Education Less than High School"

gen meded = 0 if (degree!=.)
replace meded = 1 if (degree>=3)&(degree<=4)
label values meded yesno
label variable meded "Education High School"

gen highed = 0 if (degree!=.)
replace highed = 1 if (degree==5)
label values highed yesno
label variable highed "Education Degree of Above"


gen ft = 0 if (wrkst!=.)
replace ft = 1 if (wrkst==1)
label values ft yesno
label variable ft "Full Time Employment"

gen pt = 0 if (wrkst!=.)
replace pt = 1 if (wrkst==2)|(wrkst==3)|(wrkst==4)
label values pt yesno
label variable pt "Part Time Employment"

gen out = 0 if (wrkst!=.)
replace out = 1 if (wrkst>=6)&(wrkst<=10)
label values out yesno
label variable out "Out of the Labour Market"

gen un = 0 if (wrkst!=.)
replace un = 1 if (wrkst==5)
label values un yesno
label variable un "Unemployed"


gen ftself = 0 if (wrkst!=.)
replace ftself = 1 if (ft==1)&(wrktype==4)
label values ftself yesno
label variable ftself "Full Time Self Employed"

capture drop ftpub
gen ftpub = 0 if (wrkst!=.)
replace ftpub = 1 if (ft==1)&((wrktype==1)|(wrktype==2))
label values ftpub yesno
label variable ftpub "Full Time Self Public"

gen ftpriv = 0 if (wrkst!=.)
replace ftpriv = 1 if (ft==1)&((wrktype==3)|(wrktype==6))
label values ftpriv yesno
label variable ftpriv "Full Time Private"

gen incomescore = .
label variable incomescore "Country Income Z Scores"
local incvars = "AU_INC CA_INC CH_INC CL_INC CZ_INC DE_INC DK_INC DO_INC ES_INC FI_INC FR_INC GB_INC HR_INC HU_INC IE_INC IL_INC JP_INC KR_INC LV_INC NL_INC NO_INC NZ_INC PH_INC PL_INC PT_INC RU_INC SE_INC SI_INC TW_INC US_INC UY_INC VE_INC ZA_INC" 
foreach incvar of local incvars {
	zscore `incvar', listwise
	replace incomescore=z_`incvar' if z_`incvar'!=.
	drop z_`incvar'
}

gen religion = .
replace religion = 1 if (attend==8)
replace religion = 2 if (attend>=6)&(attend<=7)
replace religion = 3 if (attend>=1)&(attend<=5)
label define religion 1 "Never" 2 "Low" 3 "High"
label values religion religion
label variable religion "Religious Attendance"
tab religion, gen(religion)
rename religion1 lowrelig
label variable lowrelig "Low Religious Attendance"
rename religion2 highrelig
label variable highrelig "High Religious Attendance"

* We recode the country variable to match the 1996 data set
capture drop country
gen country = .
replace country = 1 if (V3==36)
replace country = 2 if (V3==124)
replace country = 3 if (V3==208)
replace country = 4 if (V3==246)
replace country = 5 if (V3==250)
replace country = 6 if (V3==376.1)|(V3==376.2)
replace country = 7 if (V3==372)
replace country = 8 if (V3==392)
replace country = 9 if (V3==528)
replace country = 10 if (V3==554)
replace country = 11 if (V3==578)
replace country = 12 if (V3==620)
replace country = 13 if (V3==724)
replace country = 14 if (V3==752)
replace country = 15 if (V3==756)
replace country = 16 if (V3==826.1)
replace country = 17 if (V3==840)
label define country 1 "Australia" 2 "Canada"  3 "Denmark"  ///
					4 "Finland"  5 "France"  6 "Germany"  ///
					7 "Ireland"  8 "Japan"  9 "Netherlands"  ///
					10 "New Zealand"  11 "Norway"  12 "Portugal"  ///
					13 "Spain"  14 "Sweden"  15 "Switzerland"  ///
					16 "UK"  17 "USA" 
label values country country


keep lowrelig highrelig incomescore pt out un ftpub ftself ftpriv lowed meded highed ///
		urban rural town childhh hhsize divsep single widowed married ///
		female age agesq sick house old income employ job country V2
		
gen year = .
replace year = 2006
label variable year "Data Year"

save "2006ISSP.dta", replace


********************************************************************************
* Country Level Variables

use "bradyfinnigan2014countrydata.dta", clear

* STOCK: Percent foreign born of the total population

label variable foreignpct "Percent Foreign Born"

* FLOWS: Net migration during the year (i.e. the number of immigrants minus the
* number of emigrants, including citizens and noncitizens) as a percent of the 
* population. 

*PI note, Brady and Finnigan's data source WDI is 5-year migration rates as a percent
*PI adjustment
replace netmigpct=netmigpct/5
//
label variable netmigpct "Net Migration PCT"

* Social welfare expenditures as a percent of GDP
label variable socx "Social Welfare Expenditure"

* Dummies for social democratic regime, and liberal regime (conservative/
* christian democratic = reference)

tab1 socdem liberal
label variable socdem "Social Democratic Regime"
label variable liberal "Liberal Regime"

* Employment rate (total employees as a percent of 18 to 65 year olds)

tab emprate
label variable emprate "Employment Rate"

* Institutional context of immigrant inclusion with the multiculturalism
* policy index (MCP). 

label variable mcp "Multiculturalism Policy Index"


* We recode the country variable to match our coding in the 1996 and 2006 data
capture drop country
gen country = cntry
recode country (36=1) (124=2) (208=3) (246=4) (250=5) (276=6) ///
				(372=7) (392=8) (528=9) (554=10) (578=11) ///
				(620=12) (724=13) (752=14) (756=15) (826=16) ///
				(840=17)
label variable country "Country"
label define country 1 "Australia" 2 "Canada"  3 "Denmark"  ///
					4 "Finland"  5 "France"  6 "Germany"  ///
					7 "Ireland"  8 "Japan"  9 "Netherlands"  ///
					10 "New Zealand"  11 "Norway"  12 "Portugal"  ///
					13 "Spain"  14 "Sweden"  15 "Switzerland"  ///
					16 "UK"  17 "USA" 
label values country country
drop if country>17


keep foreignpct netmigpct socx socdem liberal emprate mcp country year

save "countrydata_73.dta", replace



* GINI Coefficient Variable

import delimited "cri_macro.csv", clear 

codebook, compact

rename country labelcountry

* We recode the country variable to match our coding in the 1996 and 2006 data
tab iso_country  
capture drop country
gen country = iso_country 
recode country (36=1) (124=2) (208=3) (246=4) (250=5) (276=6) ///
				(372=7) (392=8) (528=9) (554=10) (578=11) ///
				(620=12) (724=13) (752=14) (756=15) (826=16) ///
				(840=17)
label variable country "Country"
label define country 1 "Australia" 2 "Canada"  3 "Denmark"  ///
					4 "Finland"  5 "France"  6 "Germany"  ///
					7 "Ireland"  8 "Japan"  9 "Netherlands"  ///
					10 "New Zealand"  11 "Norway"  12 "Portugal"  ///
					13 "Spain"  14 "Sweden"  15 "Switzerland"  ///
					16 "UK"  17 "USA" 
label values country country
drop if country>17

* We are going to use income inequality variables
* lagged one year from the dependent variables
* So we keep measures from 1995 and 2005

keep if (year==1995)|(year==2005)

* The measures are lagged one year
* So we will rename the years to allow them to be linked
* to the appropriate year's outcome variable

recode year (1995=1996)
recode year (2005=2006)


keep country ginid_solt year

* We are going to change the gini percent into a proportion to aide 
* interpretation

summ ginid_solt

gen gini = 100*ginid_solt
label variable gini "GINI Coefficient"
summ gini

sort country year

merge 1:1 country year using "countrydata_73.dta"

drop _merge

save "countrydatagini.dta", replace


********************************************************************************
* POOLED 1996 and 2006 DATA

use "2006ISSP.dta", clear
append using "1996ISSP.dta"
merge m:1 country year using "countrydatagini.dta"
sort _merge
keep if (_merge==3)
drop _merge

*Create a dummy for year
tab year, gen(yrdummy)
rename yrdummy1 year96
label variable year96 "Year 1996"
rename yrdummy2 year06
label variable year06 "Year 2006"

* Keep only countries that are in both years
drop if (country==3)|(country==4)|(country==9)|(country==12)

* Create dummies for country
capture drop countryfe
quietly tab country, gen(countryfe)
tab1 countryfe*

save "ISSP9606.dta", replace

********************************************************************************
* ANALYSIS


* Analysis
* Combined Analysis of the 1996 and 2006 Data

use "ISSP9606.dta", clear

global depvars "job employ income old house sick"
global controls "gini age agesq female lowed highed pt un out ftself ftpub incomescore lowrelig highrelig"
global cntryvars "foreignpct netmigpct socx emprate"


loc i=1
foreach depvar in $depvars {
	qui logit `depvar' foreignpct $controls countryfe*
	margins, dydx(foreignpct) saving("t72m`i'",replace)
	loc i=`i'+1
}
loc i=7
foreach depvar in $depvars {
	qui logit `depvar' netmigpct $controls countryfe*
	margins, dydx(netmigpct) saving("t72m`i'",replace)
	loc i=`i'+1
}

use t72m1,clear
foreach x of numlist 2/12 {
append using t72m`x'
}

gen f=[_n]
gen factor = "Stock"
replace factor = "Flow" if f>6

gen id = "t72m1"
foreach x of numlist 2/12 {
replace id = "t72m`x'" if f==`x'
}

clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
order factor AME lower upper id
keep factor AME lower upper id
save team72, replace

foreach x of numlist 1/12 {
erase t72m`x'.dta
}

erase ISSP9606.dta
erase countrydata_73.dta
erase countrydatagini.dta
erase 2006ISSP.dta
erase 1996ISSP.dta
 }
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*


























// TEAM 73
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team73.dta"
  if _rc==0   {
    display "Team 73 already exists, skipping to next code chunk"
  }
  else {
use "ZA2900.dta",clear

gen iso2 = ""
	replace iso2 = "AU" if v3 == 1
	replace iso2 = "DE" if v3 == 2 | v3 == 3
	replace iso2 = "GB" if v3 == 4
	replace iso2 = "US" if v3 == 6
	replace iso2 = "IE" if v3 == 10
	replace iso2 = "NO" if v3 == 12
	replace iso2 = "SE" if v3 == 13
	replace iso2 = "NZ" if v3 == 19
	replace iso2 = "CA" if v3 == 20
	replace iso2 = "JP" if v3 == 24
	replace iso2 = "ES" if v3 == 25
	replace iso2 = "FR" if v3 == 27
	replace iso2 = "CH" if v3 == 30
	
keep if iso2 != ""
	
* ssc install kountry 
kountry iso2, from(iso2c) to(iso3n)
rename _ISO3N_ cntry

*** Technical variables
gen respid = v2
bys iso2: egen mean_weight = mean(v325)

* fixing weights for Germany
gen tweight = v325 / mean_weight if iso2 != "DE"
bys cntry: egen nobs = count(respid)
bys v3: egen nobs_de = count(respid) if iso2 == "DE"
replace tweight = v325 * 1.17724  / mean_weight if v3 == 2
replace tweight = v325 * 0.62266 / mean_weight if v3 == 3

*** Welfare attitudes 
recode v36 (4=0) (3=1) (2=2) (1=3), gen(govjobs4)
recode v38 (4=0) (3=1) (2=2) (1=3), gen(govsick4)
recode v39 (4=0) (3=1) (2=2) (1=3), gen(govold4)
recode v41 (4=0) (3=1) (2=2) (1=3), gen(govunempl4)
recode v42 (4=0) (3=1) (2=2) (1=3), gen(govincome4)
recode v44 (4=0) (3=1) (2=2) (1=3), gen(govhousing4)

*** Individual-level variables

gen age = v201
gen age_sq = age * age
recode v200 (1=0) (2=1), gen(female)

recode v202 (1 = 1) (3 4 = 2) (2 = 3) (5 = 4), gen(maritals)
lab def maritals 1 "married" 2 "divorced" 3 "widowed" 4 "not married"
lab val maritals maritals

recode v205 (1 2 3 4 = 1) (5 6 = 2) (7 = 3), gen(educ3)
lab def educ3 1 "Less than high school" 2 "High school" 3 "Higher completed"
lab val educ3 educ3

recode v273 (7/34 = 7), gen(hhsize)

recode v274 (2 3 4 6 7 8 10 12 14 16 18 20 22 24 26 = 1) ///
	(1 5 9 11 13 15 17 19 21 23 27 = 0) (95 = .), gen(hhkids)

recode v275 (1 = 1) (2 = 2) (3 = 3), gen(urbanrural)	
lab def urbanrural 1 "urban" 2 "suburban" 3 "rural"
lab val urbanrural urbanrural

recode v206 (1 2 3 = 1) (5 = 2) (4 6 7 8 9 10 = 3), gen(employment)
lab def employment 1 "employed" 2 "unemployed" 3 "not in labor force"
lab val employment employment

gen zincome = .
levelsof cntry if v218 != ., local(surveys)
foreach s of local surveys {
	di "`s'"
	egen zincome_1 = std(v218) if cntry == `s'
		replace zincome = zincome_1 if cntry == `s'
		drop zincome_1			
}	

gen ln_zincome = ln(zincome +1)

recode v220 (1 2 3 4 = 3) (5 = 2) (6 = 1), gen(religion)
lab def religion 1 "none" 2 "low" 3 "high"
lab val religion religion


***
keep iso2 cntry respid tweight nobs ///
	govjobs4 govsick4 govold4 govunempl4 govincome4 govhousing4 ///
	age age_sq female maritals educ3 hhsize hhkids urbanrural ///
	employment zincome ln_zincome religion
	
save "ISSP_1996.dta", replace


/// CLEANING ISSP/2006

use "ZA4700.dta",clear

gen cntry = V3a
kountry cntry, from(iso3n) to(iso2c)
rename _ISO2C_ iso2

keep if inlist(cntry, 36, 124, 756, 276, 250, 724, 372, 392, 578, 554, 752, 826, 840)

gen respid = V2
bys iso2: egen mean_weight = mean(weight)

* fixing weights for Germany
gen tweight = weight / mean_weight if iso2 != "DE"
bys cntry: egen nobs = count(respid)
bys V3: egen nobs_de = count(respid) if iso2 == "DE"
replace tweight = weight * 1.1834919  / mean_weight if V3 == 276.1
replace tweight = weight * 0.6157382 / mean_weight if V3 == 276.2

*** Welfare attitudes 
recode V25 (4=0) (3=1) (2=2) (1=3), gen(govjobs4)
recode V27 (4=0) (3=1) (2=2) (1=3), gen(govsick4)
recode V28 (4=0) (3=1) (2=2) (1=3), gen(govold4)
recode V30 (4=0) (3=1) (2=2) (1=3), gen(govunempl4)
recode V31 (4=0) (3=1) (2=2) (1=3), gen(govincome4)
recode V33 (4=0) (3=1) (2=2) (1=3), gen(govhousing4)

*** Individual-level variables

gen age_sq = age * age
recode sex (1=0) (2=1), gen(female)

recode marital (1 = 1) (3 4 = 2) (2 = 3) (5 = 4), gen(maritals)
lab val maritals maritals

recode degree (0 1 2 = 1) (3 4 = 2) (5 = 3), gen(educ3)
lab val educ3 educ3

recode hompop (7/34 = 7), gen(hhsize)

recode hhcycle (2 3 4 6 7 8 10 12 14 16 18 20 22 24 26 28 = 1) ///
	(1 5 9 11 13 15 17 19 21 23 25 = 0) (95 = .), gen(hhkids)

recode urbrural (1 = 1) (2 3 = 2) (4 5 = 3), gen(urbanrural)	
lab val urbanrural urbanrural
	
recode wrkst (1 2 3 = 1) (5 = 2) (4 6 7 8 9 10 = 3), gen(employment)
lab val employment employment

egen income = rowtotal(AU_INC-ZA_INC), missing
	
gen zincome = .
levelsof cntry if income != ., local(surveys)
foreach s of local surveys {
	di "`s'"
	egen zincome_1 = std(income) if cntry == `s'
		replace zincome = zincome_1 if cntry == `s'
		drop zincome_1			
}	

gen ln_zincome = ln(zincome +1)

recode attend (1 2 3 4 5 = 3) (6 7 = 2) (8 = 1), gen(religion)
lab val religion religion

***
keep cntry iso2 respid tweight nobs ///
	govjobs4 govsick4 govold4 govunempl4 govincome4 govhousing4 ///
	age age_sq female maritals educ3 hhsize hhkids urbanrural employment ///
	income zincome ln_zincome religion
	
save "ISSP_2006.dta", replace

/// CLEANING ISSP/2016

use "ZA6900_v2-0-0.dta",clear

gen iso2 = substr(c_alphan, 1, 2)
kountry iso2, from(iso2c) to(iso3n)
rename _ISO3N_ cntry

keep if inlist(cntry, 36, 756, 276, 250, 724, 826, 392, 578, 554, 752, 840)

gen respid = CASEID
gen tweight = WEIGHT

*** Welfare attitudes 
recode v21 (4=0) (3=1) (2=2) (1=3) (8 9 = .), gen(govjobs4)
recode v23 (4=0) (3=1) (2=2) (1=3) (8 9 = .), gen(govsick4)
recode v24 (4=0) (3=1) (2=2) (1=3) (8 9 = .), gen(govold4)
recode v26 (4=0) (3=1) (2=2) (1=3) (8 9 = .), gen(govunempl4)
recode v27 (4=0) (3=1) (2=2) (1=3) (8 9 = .), gen(govincome4)
recode v29 (4=0) (3=1) (2=2) (1=3) (8 9 = .), gen(govhousing4)

*** Individual-level variables

recode AGE (999 = .), gen(age)
gen age_sq = AGE * AGE
recode SEX (1=0) (2=1) (9=.), gen(female)

recode MARITAL (1 2 = 1) (3 4 = 2) (5 = 3) (6 = 4) (9 = .), gen(maritals)
lab def marital 1 "married" 2 "divorced" 3 "widowed" 4 "not married"
lab val marital marital

recode DEGREE (0 1 2 = 1) (3 4 = 2) (5 6 = 3) (9 = .), gen(educ3)
lab def educ3 1 "Less than high school" 2 "High school" 3 "Higher completed"
lab val educ3 educ3

recode HOMPOP (7/34 = 7) (0 99 = .), gen(hhsize)

gen hhkids = 1 if (HHCHILDR>0 & HHCHILDR<96) | (HHTODD>0 & HHTODD<96)
	replace hhkids = 0 if HHCHILDR == 0 & HHTODD == 0

recode URBRURAL (1 = 1) (2/3 = 2) (4 5 = 3) (7 9 = .), gen(urbanrural)
lab def urbanrural 1 "urban" 2 "suburban" 3 "rural"
lab val urbanrural urbanrural

*lab def employment 1 "employed" 2 "unemployed" 3 "not in labor force"

recode MAINSTAT (1 = 1) (2 = 2) (3 4 5 6 7 8 9 = 3) (99=.), gen(employment)
lab val employment employment

foreach var of varlist AU_INC-ZA_INC {
	recode `var' (9999990 9999999 999990 999997 999998 999999 = .) ///
		(99999990 99999999 9999998 = .) (999999990 = .)
}

egen income = rowtotal(AU_INC-ZA_INC), missing
	
gen zincome = .
levelsof cntry if income != ., local(surveys)
foreach s of local surveys {
	di "`s'"
	egen zincome_1 = std(income) if cntry == `s'
		replace zincome = zincome_1 if cntry == `s'
		drop zincome_1			
}	

gen ln_zincome = ln(zincome +1)

recode ATTEND (1 2 3 4 = 3) (5 6 7 = 2) (8 = 1) (97 98 99 = .), gen(religion)
lab val religion religion

***
keep iso2 cntry respid tweight ///
	govjobs4 govsick4 govold4 govunempl4 govincome4 govhousing4 ///
	age age_sq female marital educ3 hhsize hhkids urbanrural employment ///
	religion income zincome ln_zincome
	
save "ISSP_2016.dta", replace

*** MERGING ***

use "ISSP_1996.dta", clear
gen year = 1996
append using "ISSP_2006.dta"
recode year (.=2006)
append using "ISSP_2016.dta"
recode year (.=2016)

foreach var of varlist _all {
	lab var `var' ""
}

foreach var of varlist iso2 cntry ///
	govjobs4 govsick4 govold4 govunempl4 govincome4 govhousing4 ///
	age age_sq female maritals educ3 hhsize hhkids urbanrural employment ///
	zincome ln_zincome religion year {
	fre `var'
}

egen cntry_year = concat(iso2 year)	

qui ologit govjobs4 govsick4 govold4 govunempl4 govincome4 govhousing4 ///
	female i.maritals i.educ3 i.hhsize  ///
	i.employment ln_zincome i.religion ///
	i.cntry i.year [pw = tweight], vce(robust)

keep if e(sample)

*** Weights: calibrating and calculating equal population weights (1000 respondents per sample)

bys cntry_year: egen mean_tweight = mean(tweight)
fre mean_tweight
gen tweight_cal = tweight / mean_tweight
bys cntry_year: egen mean_tweight_cal = mean(tweight_cal)

bys cntry_year: egen sum_tweight_cal = sum(tweight_cal)

gen tweight_cal_1000 = tweight_cal * 1000 / sum_tweight_cal

save "ISSP_1996_2006_2016.dta", replace


*** MACRO VARIABLES

import delimited "OECD inflation.csv", clear

rename ïlocation iso3
rename value inflation
rename time year

kountry iso3, from(iso3c) to(iso3n)
rename _ISO3N_ cntry
keep iso3 cntry inflation year
keep if cntry != .
save "OECD inflation.dta", replace

*** PI adjustment, will not run otherwise
*had to rename iso varaible 'cntry'

*** CONTINUE
merge 1:1 cntry year using "cri_macro_73.dta"
drop if _merge == 2

drop if _merge == 2

keep if year > 1984 & year <= 2016 
keep if inlist(cntry, 36, 124, 756, 276, 250, 724, 372, 392, 578, 554, 752, 826, 840)
drop _merge

sort cntry year
gen ginid_solt_f = ginid_solt
by cntry: replace ginid_solt_f = ginid_solt[_n-1] if year==2015

replace socx_oecd = "" if inlist(socx_oecd, ".", "..")

destring socx_oecd, gen(socx_oecd_n)
	
foreach var of varlist mignet_un migstock_un inflation ginid_solt_f gdp_oecd wdi_empprilo socx_oecd_n {
	sort cntry year
	by cntry: gen `var'_lag1 = `var'[_n-1] if year==year[_n-1]+1
}
keep if inlist(year, 1991, 1996, 2001, 2006, 2011, 2016)

sort cntry year
by cntry: gen migstock_un_lag5 = migstock_un_lag1[_n-1] if year==year[_n-1]+5

*PI added
destring migstock_un_lag1, replace
destring migstock_un_lag5, replace
destring gdp_oecd_lag1, replace
destring mignet_un_lag1, replace


gen migstock_un_diff_1_5 = (migstock_un_lag1-migstock_un_lag5)


gen ginid_solt_f_100_lag1 = ginid_solt_f_lag1
gen ln_gdp_oecd_lag1 = ln(gdp_oecd_lag1)


save "macro_inflation.dta", replace

*** MERGED

use "ISSP_1996_2006_2016.dta", clear

merge m:1 cntry year using "macro_inflation.dta"

drop if _merge==2
drop _merge

***** NO COUNTRY-LEVEL CONTROLS
local n = 1
foreach var of varlist govjobs4 govunempl4 govincome4 govold4 govhousing4 govsick4 {

	ologit `var' female i.maritals i.educ3 i.hhsize ///
			i.employment i.religion ///
			migstock_un_lag1 ///
			i.cntry i.year [pw = tweight_cal_1000], vce(robust)	
	margins, dydx(migstock_un_lag1) atmeans saving("t73m`n'.dta", replace)
	local n = `n'+1
}
local n = 7
foreach var of varlist govjobs4 govunempl4 govincome4 govold4 govhousing4 govsick4 {

	quietly ologit `var' female i.maritals i.educ3 i.hhsize ///
			i.employment ln_zincome i.religion ///
			mignet_un_lag1 ///
			i.cntry i.year [pw = tweight_cal_1000], vce(robust)	
	est store model_net_`var'
    margins, dydx(mignet_un_lag1) atmeans saving("t73m`n'.dta", replace)	
	local n = `n'+1
}

use t73m1.dta, clear
foreach n of numlist 2/12 {
append using t73m`n'.dta
}

gen id = [_n]
gen id2 = id-24
replace id = id2 if id>24

recode id (1/4 =1)(5/8 =2) ///
(9/12 =3)(13/16 =4) ///
(17/20 =5)(21/24 =6), gen(dv)

recode id ///
( 1 25  = 4584)  /// 
( 2 26  = 8450) ///
( 3 27  = 9894) ///
( 4 28  = 6944) /// /* jobs */
( 5 29  = 2151)  ///
( 6 30  = 6549) ///
( 7 31  = 14839) ///
( 8 32  = 6333) /// /* unemp */
( 9 33  = 3502)  /// 
(10 34  = 6640)  ///
(11 35  = 9823) ///
(12 36  = 9907) /// /* incdif */
(13 37  = 555)   ///
(14 38  = 2397)  ///
(15 39  = 19804) ///
(16 40  = 35703) /// /* old */
(17 41  = 290)  ///
(18 42  = 1569)  ///
(19 43  = 11263) ///
(20 44  = 16750) /// /* house */
(21 45  = 1595)   /// 
(22 46  = 5710)  ///
(23 47  = 14967) ///
(24 48  = 7600) /// /* health */
, gen(pop)

recode id (1 5 9 13 17 21 25 29 33 = 29872)(*=.), gen(tpop)

recode id ///
( 1 25  = 1) /// 
( 2 26  = 2) ///
( 3 27  = 3) ///
( 4 28  = 4) /// /* jobs */
( 5 29  = 1) ///
( 6 30  = 2) ///
( 7 31  = 3) ///
( 8 32  = 4) /// /* unemp */
( 9 33  = 1) /// 
(10 34  = 2) ///
(11 35  = 3) ///
(12 36  = 4) /// /* incdif */
(13 37  = 1) ///
(14 38  = 2) ///
(15 39  = 3) ///
(16 40  = 4) /// /* old */
(17 41  = 1) ///
(18 42  = 2) ///
(19 43  = 3) ///
(20 44  = 4) /// /* house */
(21 45  = 1) /// 
(22 46  = 2) ///
(23 47  = 3) ///
(24 48  = 4) /// /* health */
, gen(score)

gen mean = ((score*pop)+(score[_n+1]*pop[_n+1]) ///
+(score[_n+2]*pop[_n+2])+(score[_n+3]*pop[_n+3]))/tpop

gen margmean = ( ///
score*(pop+(pop*_margin)) + ///
score[_n+1]*(pop[_n+1]+(pop[_n+1]*_margin[_n+1])) + ///
score[_n+2]*(pop[_n+2]+(pop[_n+2]*_margin[_n+2])) + ///
score[_n+3]*(pop[_n+3]+(pop[_n+3]*_margin[_n+3])) ///
)/tpop

gen margmean_lb = ( ///
score*(pop+(pop*_ci_lb)) + ///
score[_n+1]*(pop[_n+1]+(pop[_n+1]*_ci_lb[_n+1])) + ///
score[_n+2]*(pop[_n+2]+(pop[_n+2]*_ci_lb[_n+2])) + ///
score[_n+3]*(pop[_n+3]+(pop[_n+3]*_ci_lb[_n+3])) ///
)/tpop

gen margmean_ub = ( ///
score*(pop+(pop*_ci_ub)) + ///
score[_n+1]*(pop[_n+1]+(pop[_n+1]*_ci_ub[_n+1])) + ///
score[_n+2]*(pop[_n+2]+(pop[_n+2]*_ci_ub[_n+2])) + ///
score[_n+3]*(pop[_n+3]+(pop[_n+3]*_ci_ub[_n+3])) ///
)/tpop

gen AME = margmean - mean
gen lower = margmean_lb - mean
gen upper = margmean_ub - mean
drop if AME == .
gen factor = .
gen n = [_n]
drop id
gen id = "t73m1"
foreach n of numlist 2/12 {
replace id = "t73m`n'" if `n'==n
}


order factor AME lower upper id
keep factor AME lower upper id
save "team73.dta", replace

foreach n of numlist 1/12 {
erase "t73m`n'.dta"
}
erase macro_inflation.dta
erase cri_macro_73.dta
erase ISSP_1996_2006_2016.dta
erase ISSP_2016.dta
erase ISSP_2006.dta
erase ISSP_1996.dta
  }

*==============================================================================*
*==============================================================================*
*==============================================================================*


















 
 
 
 
 
 
 
 
 
 
 
 
 
// TEAM 75
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team75.dta"
  if _rc==0   {
    display "Team 75 already exists, skipping to next code chunk"
  }
  else {

use "ZA2900.dta", clear 

recode v3 (1=36) (2/3=276) (4=826) (6=840) (8=348) (9=.) (10=372) (12=578) (13=752) (14=203) (15=705) (16=616) (17=.) (18=643) (19=554) (20=124) (21=608) (22/23=376) (24=392) (25=724) (26=428) (27=250) (28=.) (30=756), gen(v3a)
label define cntrylbl 36 "Australia" 124 "Canada" 152 "Chile" 158 "Taiwan" 191 "Croatia" 203 "Czech" 208 "Denmark" 246 "Finland" 250 "France" 276 "Germany" 348 "Hungary" 372 "Ireland" 376 "Isreal" 392 "Japan" 410 "S Korea" 428 "Latvia" 528 "Netherlands" 554 "New Zealand" 578 "Norway" 608 "Philippines" 616 "Poland" 620 "Portugal" 643 "Russia" 705 "Slovenia" 724 "Spain" 752 "Sweden" 756 "Switzerland" 826 "Great Britain" 840 "United States" 
label values v3a cntrylbl

**** GOV RESPONSIBILITY ****

// Provide jobs for everyone
recode v36 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
recode govjobs (1/2=0) (3/4=1), gen(dgovjobs)

// Provide healthcare for the sick
recode v38 (1=4) (2=3) (3=2) (4=1), gen(govhcare)
recode govhcare (1/2=0) (3/4=1), gen(dhcare)

// Provide living standard for the old
recode v39 (1=4) (2=3) (3=2) (4=1), gen(govretire)
recode govretire (1/2=0) (3/4=1), gen(dgovretire)

// Provide living standard for the unemployed
recode v41 (1=4) (2=3) (3=2) (4=1), gen(govunemp)
recode govunemp (1/2=0) (3/4=1), gen(dgovunemp)

// Reduce income diff bw rich and poor
recode v42 (1=4) (2=3) (3=2) (4=1), gen(govincdiff)
recode govincdiff (1/2=0) (3/4=1), gen(dgovincdiff)

// Provide decent housing to those who can't afford it
recode v44 (1=4) (2=3) (3=2) (4=1), gen(govhousing)
recode govhousing (1/2=0) (3/4=1), gen(dgovhous)


*****************************
***** CONTROL VARIABLES *****
*****************************

// AGE
rename v201 age
gen agesq=age*age

// SEX
recode v200 (1=0) (2=1), gen(female)

// MARITAL STATUS
** missing for Spain
rename v202 marst
recode marst (5=1) (nonmiss=0), gen(nevermar)
recode marst (2/5=0), gen(married)
recode marst (3/4=1) (nonmiss=0), gen(divorced)
recode marst (2=1) (nonmiss=0), gen(widow)

// STEADY LIFE PARTNER
recode v203 (2=0), gen(partner)

// HOUSEHOLD SIZE
// top-coded at 8 for Great Britain, 9 for Slovenia
rename v273 hhsize

// CHILDREN IN HH
recode v274 (2/4=1) (6/8=1) (nonmiss=0), gen(kidshh)
local i = 10
while `i' < 27 {
	replace kidshh=1 if v274==`i'
	local i = `i' + 2
}

// RURAL
recode v275 (3=1) (nonmiss=0), gen(rural)
recode v275 (2=1) (nonmiss=0), gen(suburb)

// COUNTRY/PLACE OF BIRTH
rename v324 ETHNIC

// EDUCATION
rename v204 edyears
rename v205 edcat
recode edcat (1/3=1) (4=2) (5=3) (6=4) (7=5), gen(degree)
label define edlabels 1 "Primary/less" 2 "Some Secondary" 3 "Secondary" 4 "Some Higher Ed" 5 "University or higher"
label values degree edlabels

recode degree (1/2=1) (nonmiss=0), gen(lesshs)
recode degree (3/4=1) (nonmiss=0), gen(hs)
recode degree (5=1) (nonmiss=0), gen(univ)

// OCCUPATION
// see page 127 (210 of pdf) in codebook
rename v208 isco
rename v209 occ2
rename v215 hourswrk

recode v206 (2/10=0), gen(ftemp)
recode v206 (2/4=1) (nonmiss=0), gen(ptemp)
recode v206 (5=1) (nonmiss=0), gen(unemp)
recode v206 (6/10=1) (nonmiss=0), gen(nolabor)

gen selfemp=v213==1
replace selfemp=. if v206==.
gen pubemp=(v212==1 | v212==2)
replace pubemp=. if v206==.
gen pvtemp=(selfemp==0 & pubemp==0)
replace pvtemp=. if v206==.

// INCOME
rename v218 faminc

gen inczscore=.
levelsof v3a, local(cntries)
foreach cntryval of local cntries {
	zscore faminc if v3a==`cntryval', listwise
	replace inczscore=z_faminc if v3a==`cntryval'
	drop z_faminc
}

// UNION MEMBER
recode v222 (2=0), gen(union)

// POLITICAL PARTY 
rename v223 party

// RELIGIOUS ATTENDANCE
recode v220 (1/2=1) (nonmiss=0), gen(highrel)
recode v220 (3/5=1) (nonmiss=0), gen(lowrel)
recode v220 (6=1) (nonmiss=0), gen(norel)
rename v220 religion

*** TECHNICAL VARIABLES ***

// year
gen year=1996
gen yr2006=0

// country identifier
rename v3a cntry

// weights
rename v325 wghts


save "ISSP96recode.dta", replace


*** 2006 ***

use "ZA4700.dta", clear 


*******************************
***** DEPENDENT VARIABLES *****
*******************************

**** GOV RESPONSIBILITY ****

// Provide jobs for everyone
recode V25 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
recode govjobs (1/2=0) (3/4=1), gen(dgovjobs)

// Provide healthcare for the sick
recode V27 (1=4) (2=3) (3=2) (4=1), gen(govhcare)
recode govhcare (1/2=0) (3/4=1), gen(dhcare)

// Provide living standard for the old
recode V28 (1=4) (2=3) (3=2) (4=1), gen(govretire)
recode govretire (1/2=0) (3/4=1), gen(dgovretire)

// Provide living standard for the unemployed
recode V30 (1=4) (2=3) (3=2) (4=1), gen(govunemp)
recode govunemp (1/2=0) (3/4=1), gen(dgovunemp)

// Reduce income diff bw rich and poor
recode V31 (1=4) (2=3) (3=2) (4=1), gen(govincdiff)
recode govincdiff (1/2=0) (3/4=1), gen(dgovincdiff)

// Provide decent housing to those who can't afford it
recode V33 (1=4) (2=3) (3=2) (4=1), gen(govhousing)
recode govhousing (1/2=0) (3/4=1), gen(dgovhous)

**** TRUST ****

// Only a few people to trust
rename V54 trustfew
recode trustfew (1/2 = 0) (3/5 = 1), gen(dtrust)

// People will take advantage
rename V55 takeadv
recode takeadv (1/2 = 0) (3/5 = 1), gen(dtakeadv)


*****************************
***** CONTROL VARIABLES *****
*****************************

// AGE
* rename AGE age // does not make sense
gen agesq=age*age

// SEX
recode sex (1=0) (2=1), gen(female)

// MARITAL STATUS
rename marital marst
recode marst (5=1) (nonmiss=0), gen(nevermar)
recode marst (2/5=0), gen(married)
recode marst (3/4=1) (nonmiss=0), gen(divorced)
recode marst (2=1) (nonmiss=0), gen(widow)

// STEADY LIFE PARTNER
recode cohab (2=0), gen(partner)

// HOUSEHOLD SIZE
// top-coded at 8 for Sweden, 9 for Denmark
rename hompop hhsize

// CHILDREN IN HH
recode hhcycle (2/4=1) (6/8=1) (nonmiss=0), gen(kidshh)
local i = 10
while `i' < 29 {
	replace kidshh=1 if hhcycle==`i'
	local i = `i' + 2
}

// RURAL
recode urbrural (1/3=0) (4/5=1), gen(rural)
recode urbrural (2/3=1) (nonmiss=0), gen(suburb)

// EDUCATION
// see pg 97 in codebook
* recode edcat (0=1), gen(degree) // var does not exist; is replaced accordingly
replace degree=1 if degree==0 
label define edlabels 1 "Primary/less" 2 "Some Secondary" 3 "Secondary" 4 "Some Higher Ed" 5 "University or higher"
label values degree edlabels

recode degree (1/2=1) (nonmiss=0), gen(lesshs)
recode degree (3/4=1) (nonmiss=0), gen(hs)
recode degree (5=1) (nonmiss=0), gen(univ)

// OCCUPATION
rename wrkst empstat
rename ISCO88 isco // see pg 137 in codebook
rename wrkhrs hourswrk

recode empstat (2/10=0), gen(ftemp)
recode empstat (2/4=1) (nonmiss=0), gen(ptemp)
recode empstat (5=1) (nonmiss=0), gen(unemp)
recode empstat (6/10=1) (nonmiss=0), gen(nolabor)

gen selfemp=wrktype==4
replace selfemp=. if empstat==.
gen pubemp=(wrktype==1 | wrktype==2)
replace pubemp=. if empstat==.
gen pvtemp=(selfemp==0 & pubemp==0)
replace pvtemp=. if empstat==.

// INCOME
gen inczscore=.
local incvars = "AU_INC CA_INC CH_INC CL_INC CZ_INC DE_INC DK_INC DO_INC ES_INC FI_INC FR_INC GB_INC HR_INC HU_INC IE_INC IL_INC JP_INC KR_INC LV_INC NL_INC NO_INC NZ_INC PH_INC PL_INC PT_INC RU_INC SE_INC SI_INC TW_INC US_INC UY_INC VE_INC ZA_INC" 
foreach incvar of local incvars {
	zscore `incvar', listwise
	replace inczscore=z_`incvar' if z_`incvar'!=.
	drop z_`incvar'
}

// UNION MEMBER
ren union union2
recode union2 (2/3=0), gen(union)

// POLITICAL PARTY
rename PARTY_LR party

// RELIGIOUS ATTENDANCE
recode attend (1/3=1) (nonmiss=0), gen(highrel)
recode attend (4/7=1) (nonmiss=0), gen(lowrel)
recode attend (8=1) (nonmiss=0), gen(norel)
rename attend religion

*** TECHNICAL VARIABLES ***

// Country Identifier
rename V3a cntry

// weights
rename weight wghts

// year
gen year=2006
gen yr2006=1

gen mail=mode==34


save "ISSP06recode.dta", replace

*** 2016 ***

use "ZA6900_v2-0-0.dta", clear 

**** GOV RESPONSIBILITY ****
// Provide jobs for everyone
recode v21 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
replace govjobs=. if govjobs>5
recode govjobs (1/2=0) (3/4=1), gen(dgovjobs)

// Provide healthcare for the sick
recode v23 (1=4) (2=3) (3=2) (4=1), gen(govhcare)
replace govhcare=. if govhcare>5
recode govhcare (1/2=0) (3/4=1), gen(dhcare)

// Provide living standard for the old
recode v24 (1=4) (2=3) (3=2) (4=1), gen(govretire)
replace govretire=. if govretire>5
recode govretire (1/2=0) (3/4=1), gen(dgovretire)

// Provide living standard for the unemployed
recode v26 (1=4) (2=3) (3=2) (4=1), gen(govunemp)
replace govunemp=. if govunemp>5
recode govunemp (1/2=0) (3/4=1), gen(dgovunemp)

// Reduce income diff bw rich and poor
recode v27 (1=4) (2=3) (3=2) (4=1), gen(govincdiff)
replace govincdiff=. if govincdiff>5
recode govincdiff (1/2=0) (3/4=1), gen(dgovincdiff)

// Provide decent housing to those who can't afford it
recode v29 (1=4) (2=3) (3=2) (4=1), gen(govhousing)
replace govhousing=. if govhousing>5
recode govhousing (1/2=0) (3/4=1), gen(dgovhous)


*****************************
***** CONTROL VARIABLES *****
*****************************

// AGE

rename AGE age 
replace age=. if age>99
gen agesq=age*age

// SEX
ren SEX sex 
recode sex (1=0) (2=1) (9=.), gen(female)

// MARITAL STATUS
rename MARITAL marst
replace marst = . if marst>=7
recode marst (6=1) (nonmiss=0), gen(nevermar)
recode marst (1/2=1) (3/6=0), gen(married)
recode marst (3/4=1) (nonmiss=0), gen(divorced)
recode marst (5=1) (nonmiss=0), gen(widow)

// STEADY LIFE PARTNER
ren PARTLIV cohab 
replace cohab=. if cohab>3
recode cohab (2/3=0), gen(partner)

// HOUSEHOLD SIZE
// top-coded at 8 for Sweden, 9 for Denmark
rename HOMPOP hhsize

// CHILDREN IN HH
gen kidshh=HHCHILDR
replace kidshh=. if kidshh>13


// RURAL
replace URBRURAL=. if URBRURAL>=7
recode URBRURAL (1/3=0) (4/5=1), gen(rural)
recode URBRURAL (2/3=1) (nonmiss=0), gen(suburb)


// EDUCATION
// see pg 97 in codebook
* recode edcat (0=1), gen(degree) // var does not exist; is replaced accordingly
ren DEGREE degree
replace degree=. if degree==9
replace degree=1 if degree==0 // I dont like that coding
label define edlabels 1 "Primary/less" 2 "Some Secondary" 3 "Secondary" 4 "Some Higher Ed" 5 "University or higher"
label values degree edlabels

recode degree (1/2=1) (nonmiss=0), gen(lesshs)
recode degree (3/4=1) (nonmiss=0), gen(hs)
recode degree (5/6=1) (nonmiss=0), gen(univ)

// OCCUPATION
rename WORK empstat
rename ISCO08 isco 
rename WRKHRS hourswrk


replace empstat=. if empstat==9
recode empstat (2/3=0), gen(ftemp)
recode empstat (2=1) (nonmiss=0), gen(unemp)
recode empstat (3=1) (nonmiss=0), gen(nolabor)


gen selfemp=0
replace selfemp=1 if EMPREL==3 | EMPREL==4
replace selfemp=. if empstat==.


gen pubemp=TYPORG2==1
replace pubemp=. if empstat==.

gen pvtemp=(selfemp==0 & pubemp==0)
replace pvtemp=. if empstat==.


// INCOME
// earnings and family income are country specific
// dividing family income by the squareroot of hh size and transforming to country-specific z-scores
// generating a cross-country income variable using within-country z-scores

gen inczscore=.


foreach incvar of varlist AU_INC-ZA_INC {
	replace `incvar'=. if `incvar'>=900000
	zscore `incvar', listwise
	replace inczscore=z_`incvar' if z_`incvar'!=.
	drop z_`incvar'
}

// UNION MEMBER
replace UNION=. if UNION>3
ren UNION union2
recode union2 (2/3=0), gen(union)

// POLITICAL PARTY
replace PARTY_LR=. if PARTY_LR<1 | PARTY_LR>5
rename PARTY_LR party

// RELIGIOUS ATTENDANCE
replace ATTEND=. if ATTEND<1 | ATTEND>8
ren ATTEND attend 

recode attend (1/4=1) (nonmiss=0), gen(highrel)
recode attend (5/7=1) (nonmiss=0), gen(lowrel)
recode attend (8=1) (nonmiss=0), gen(norel)
rename attend religion

*** TECHNICAL VARIABLES ***

// Country Identifier
rename country cntry

// weights
rename WEIGHT wghts

// year
gen year=2016
gen yr2016=1

gen mail=MODE==34

save "ISSP16recode.dta", replace


************************
***** MERGING DATA *****
************************
* Preparation aggregate data
import excel "cri_macro.xlsx", sheet("cri_macro") firstrow clear
ren iso_country cntry

ren migstock_un foreignpct
ren mignet_un netmigpct 
ren socx_oecd socx 
ren wdi_empprilo emprate

foreach var of varlist foreignpct netmigpct socx emprate {
replace `var'="" if `var'=="." | `var'==".." 
destring `var', replace dpcomma
}

* Lags
foreach var of varlist foreignpct netmigpct socx emprate {
	forvalues number = 1/10 {
	bys cntry: gen `var'_l`number' = `var'[_n-`number']
	}
}

save "cri_macro_75.dta", replace

use "ISSP06recode.dta", clear
append using "ISSP96recode.dta"
append using "ISSP16recode.dta", force


sort cntry year
merge m:1 cntry year using "cri_macro_75.dta"


recode cntry (36=1) (124=1) (208=1) (246=1) (250=1) (276=1) (372=1) (392=1) (528=1) (554=1) (578=1) (620=1) (724=1) (752=1) (756=1) (826=1) (840=1) (else=0), gen(orig17)
recode cntry (36=1) (124=1) (250=1) (276=1) (372=1) (392=1) (554=1) (578=1) (724=1) (752=1) (756=1) (826=1) (840=1) (else=0), gen(orig13)

***Keep affluent countries
save "ISSP960616.dta", replace

* ====================================================================
* Analysis part	                     				   	   			 =
* ====================================================================


global data "ISSP960616.dta"

use $data, clear
keep if orig17==1
keep if inlist(year, 1996, 2006, 2016)

global depvars "dgovjobs dgovunemp dgovincdiff dgovretire dgovhous dhcare"
global controls "age agesq female lesshs univ unemp nolabor selfemp inczscore"
global cntryvars "foreignpct socx emprate"

egen allcontrols = rowmiss($controls)
recode allcontrols (0=1) (nonmiss=0)

quietly tab cntry, gen(cntryfe)

* Country_year identifier
tostring year, gen(y2)
tostring cntry, gen(cntry2)
gen str32 cntryyear = y2+cntry2

* Harmonisation of employment status
gen ftptemp=.
replace ftptemp=0 if year==2016 & ftemp==0
replace ftptemp=0 if (year==1996 | year==2006) & (ftemp==0 & ptemp==0)
replace ftptemp=1 if year==2016 & ftemp==1
replace ftptemp=1 if (year==1996 | year==2006) & (ftemp==1 | ptemp==1)

destring foreignpct, replace
destring socx, replace
destring emprate, replace


*************************************************************************
* Generate Within Between Variables                                     *
*************************************************************************
*** IVs
egen foreignpct_mean = mean(foreignpct), by(cntry)
gen foreignpct_w = foreignpct - foreignpct_mean

egen socx_mean = mean(socx), by(cntry)
gen socx_w = socx - socx_mean

egen emprate_mean = mean(emprate), by(cntry)
gen emprate_w = emprate - emprate_mean

global cntryvars_WBRE "foreignpct_mean foreignpct_w socx_mean socx_w emprate_mean emprate_w"

foreach var of varlist dgovjobs dgovunemp dgovincdiff dgovretire dgovhous dhcare {
bys cntryyear: egen `var'_per = mean(`var')
}

foreach var of varlist dgovjobs_per dgovunemp_per dgovincdiff_per dgovretire_per dgovhous_per dhcare_per {
egen `var'_mean = mean(`var'), by(cntry)
gen `var'_w = `var' - `var'_mean
}

gen Japan = 0
replace Japan = 1 if cntry==392

/* PI adjustment:
The team standardized all DVs, skip this step to get comprable effect sizes 

* Standardization:
	foreach var of varlist $controls socx emprate {
		qui sum `var'
		replace `var' = (`var' - `r(min)') / (`r(max)'-`r(min)')
	}
*/

* ANALYSES
loc i=1
foreach var of varlist $depvars {
xtmelogit `var' $controls $cntryvars if Japan==0 || cntry: || cntryyear:, iterate(25) 
margins,dydx(foreignpct) atmeans saving("t75m`i'",replace)
loc i=`i'+1
}

*PI adjustment
replace foreignpct_w=foreignpct_w/7.75
//
local countryvarsnew2 = "foreignpct_w socx_w emprate_w foreignpct_mean socx_mean emprate_mean"	
global depvars "dgovjobs dgovunemp dgovincdiff dgovretire dgovhous dhcare"
loc t=7
loc x=13
foreach var of varlist $depvars {
capture noisily xtmelogit `var' $controls `countryvarsnew2' if Japan!=1 || cntry: || cntryyear:, iterate(50)
margins,dydx(foreignpct_w) saving("t75m`t'",replace)
margins,dydx(foreignpct_mean) saving("t75m`x'",replace)
loc t=`t'+1
loc x=`x'+1
}

use t75m1,clear
foreach x of numlist 2/18 {
append using t75m`x'
}

gen f=[_n]
gen factor = "Stock"
replace factor = "Flow, per wave" if (f>6&f<13)

gen id = "t75m1"
foreach x of numlist 2/18 {
replace id = "t75m`x'" if f==`x'
}


clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
order factor AME lower upper id
keep factor AME lower upper id
*model 14 does not converge after 50
*count this as not significant by applying artifical CIs
replace lower = -.21 if id == "t75m14"
replace upper = 0.14 if id == "t75m14"
save team75, replace 

foreach n of numlist 1/18 {
erase t75m`n'.dta
}

erase ISSP960616.dta
erase cri_macro_75.dta
erase ISSP16recode.dta
erase ISSP06recode.dta
erase ISSP96recode.dta

}
*==============================================================================*
*==============================================================================*
*==============================================================================*























// TEAM 83
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team83.dta"
  if _rc==0   {
    display "Team 83 already exists, skipping to next code chunk"
  }
  else {
version 15.1
set more off

***1996 survey
use "ZA2900.dta", clear
*rename and recode outcomes
**Old Age Care
recode v39 (1=4) (2=3) (3=2) (4=1), gen(govoldagecare)
recode govoldagecare (1/2=0) (3/4=1), gen(oldagecare)
**unemployment
recode v41 (1=4) (2=3) (3=2) (4=1), gen(govunemployment)
recode govunemployment (1/2=0) (3/4=1), gen(unemployment)
**Income Differences
recode v42 (1=4) (2=3) (3=2) (4=1), gen(govreduceincomedifferences)
recode govreduceincomedifferences (1/2=0) (3/4=1), gen(reduceincomedifferences)
**Jobs
recode v36 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
recode govjobs (1/2=0) (3/4=1), gen(jobs)
**Provide healthcare for the sick
recode v38 (1=4) (2=3) (3=2) (4=1), gen(govhealthcare)
recode govhealthcare (1/2=0) (3/4=1), gen(healthcare)
**Provide decent housing to those who can't afford it
recode v44 (1=4) (2=3) (3=2) (4=1), gen(govhousing)
recode govhousing (1/2=0) (3/4=1), gen(housing)


*recode employment categories
gen emplstatus=v206
replace emplstatus=2 if v206==2 | v206==3
*Note that I was unsure on how to categorize "Employed, less than part-time"
replace emplstatus=3 if v206==4 | v206==6 | v206==7 | v206==8 | v206==9 | v206==10
replace emplstatus=4 if v206==5
label define emplstatus 1 "Full-time" 2 "Part-time" 3 "Not active" 4 "Active unemployed"
label values emplstatus emplstatus

*recode education categories 1= primary or less, 2= secondary, 3=university
gen edu=1
replace edu=2 if v205==5 | v205==6
replace edu=3 if v205==7
label define edu 1 "Primary" 2 "Secondary" 3 "University"
label values edu edu

*rename age & sex
rename v200 sex
rename v201 age
replace age=. if age==999
*gen age squared
gen age2=age*age

**recode country names
gen country=""
replace country="Australia" if v3=="aus":V3
replace country="Canada" if v3=="cdn":V3
replace country="Czech Republic" if v3=="cz":V3
replace country="France" if v3=="f":V3
replace country="Germany" if v3=="D-W":V3 | v3=="D-E":V3
replace country="Hungary" if v3=="h":V3
replace country="Ireland" if v3=="irl":V3
replace country="Israel" if v3=="IL-J":V3 | v3=="IL-A":V3
replace country="Japan" if v3=="j":V3
replace country="Latvia" if v3=="lv":V3
replace country="New Zealand" if v3=="nz":V3
replace country="Norway" if v3=="n":V3
replace country="Poland" if v3=="pl":V3
replace country="Russia" if v3=="rus":V3
replace country="Slovenia" if v3=="slo":V3
replace country="Spain" if v3=="e":V3
replace country="Sweden" if v3=="s":V3
replace country="Switzerland" if v3=="ch":V3
replace country="United Kingdom" if v3=="gb":V3
replace country="United States" if v3=="usa":V3

gen isocode=.
replace isocode=36 if country=="Australia"
replace isocode=250 if country=="France"
replace isocode=276 if country=="Germany"
replace isocode=392 if country=="Japan"
replace isocode=554 if country=="New Zealand"
replace isocode=578 if country=="Norway"
replace isocode=724 if country=="Spain"
replace isocode=752 if country=="Sweden"
replace isocode=756 if country=="Switzerland"
replace isocode=826 if country=="United Kingdom"
replace isocode=840 if country=="United States"
keep if isocode== 36 | isocode== 250 | isocode== 276 | isocode== 392 | isocode== 554 | isocode== 578 | isocode== 724 | isocode== 752 | isocode== 756 | isocode== 826 | isocode== 840

*income
rename v218 faminc
gen inczscore=.
levelsof isocode, local(cntries)
foreach cntryval of local cntries {
zscore faminc if isocode==`cntryval', listwise
replace inczscore=z_faminc if isocode==`cntryval'
drop z_faminc
}

*gen time variable
gen year=1996

*clean data
keep isocode country year sex age age2 edu emplstatus inczscore oldagecare unemployment reduceincomedifferences jobs healthcare housing
save "1996.dta", replace


***2006 survey
use "ZA4700.dta", clear

*rename and recode outcomes
**Old Age Care
recode V28 (1=4) (2=3) (3=2) (4=1), gen(govoldagecare)
recode govoldagecare (1/2=0) (3/4=1), gen(oldagecare)
**unemployment
recode V30 (1=4) (2=3) (3=2) (4=1), gen(govunemployment)
recode govunemployment (1/2=0) (3/4=1), gen(unemployment)
**Income Differences
recode V31 (1=4) (2=3) (3=2) (4=1), gen(govreduceincomedifferences)
recode govreduceincomedifferences (1/2=0) (3/4=1), gen(reduceincomedifferences)
**Jobs
recode V25 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
recode govjobs (1/2=0) (3/4=1), gen(jobs)
**Provide healthcare for the sick
recode V27 (1=4) (2=3) (3=2) (4=1), gen(govhealthcare)
recode govhealthcare (1/2=0) (3/4=1), gen(healthcare)
**Provide decent housing to those who can't afford it
recode V33 (1=4) (2=3) (3=2) (4=1), gen(govhousing)
recode govhousing (1/2=0) (3/4=1), gen(housing)

*recode employment categories
gen emplstatus=wrkst
replace emplstatus=2 if wrkst==2 | wrkst==3
*Note that I was unsure on how to categorize "Employed, less than part-time"
replace emplstatus=3 if wrkst==4 | wrkst==6 | wrkst==7 | wrkst==8 | wrkst==9 | wrkst==10
replace emplstatus=4 if wrkst==5
label define emplstatus 1 "Full-time" 2 "Part-time" 3 "Not active" 4 "Active unemployed"
label values emplstatus emplstatus

*recode education categories 0= primary or less, 1= secondary, 2=university
gen edu=1
replace edu=2 if degree==3 | degree==4
replace edu=3 if degree==5
label define edu 1 "Primary" 2 "Secondary" 3 "University"
label values edu edu

*gen age squared
replace age=. if age==999
gen age2=age*age

*income
gen inczscore=.
local incvars = "AU_INC CA_INC CH_INC CL_INC CZ_INC DE_INC DK_INC DO_INC ES_INC FI_INC FR_INC GB_INC HR_INC HU_INC IE_INC IL_INC JP_INC KR_INC LV_INC NL_INC NO_INC NZ_INC PH_INC PL_INC PT_INC RU_INC SE_INC SI_INC TW_INC US_INC UY_INC VE_INC ZA_INC"
foreach incvar of local incvars {
zscore `incvar', listwise
replace inczscore=z_`incvar' if z_`incvar'!=.
drop z_`incvar'
}

*gen time variable
gen year=2006

*country ID
rename V3a isocode
gen country=""
replace country="Australia" if isocode== 36
replace country="France" if isocode== 250
replace country="Germany" if isocode== 276
replace country="Japan" if isocode== 392
replace country="New Zealand" if isocode== 554
replace country="Norway" if isocode== 578
replace country="Spain" if isocode== 724
replace country="Sweden" if isocode== 752
replace country="Switzerland" if isocode== 756
replace country="United Kingdom" if isocode== 826
replace country="United States" if isocode== 840

*clean data
keep isocode country year sex age age2 edu emplstatus inczscore oldagecare unemployment reduceincomedifferences jobs healthcare housing
keep if isocode== 36 | isocode== 250 | isocode== 276 | isocode== 392 | isocode== 554 | isocode== 578 | isocode== 724 | isocode== 752 | isocode== 756 | isocode== 826 | isocode== 840
save "2006.dta", replace


***2016 data
use "ZA6900_v2-0-0.dta", clear

*rename and recode outcomes
**Old Age Care
recode v24 (1=4) (2=3) (3=2) (4=1), gen(govoldagecare)
recode govoldagecare (1/2=0) (3/4=1), gen(oldagecare)
**unemployment
recode v26 (1=4) (2=3) (3=2) (4=1), gen(govunemployment)
recode govunemployment (1/2=0) (3/4=1), gen(unemployment)
**Income Differences
recode v27 (1=4) (2=3) (3=2) (4=1), gen(govreduceincomedifferences)
recode govreduceincomedifferences (1/2=0) (3/4=1), gen(reduceincomedifferences)
**Jobs
recode v21 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
recode govjobs (1/2=0) (3/4=1), gen(jobs)
**Provide healthcare for the sick
recode v23 (1=4) (2=3) (3=2) (4=1), gen(govhealthcare)
recode govhealthcare (1/2=0) (3/4=1), gen(healthcare)
**Provide decent housing to those who can't afford it
recode v29 (1=4) (2=3) (3=2) (4=1), gen(govhousing)
recode govhousing (1/2=0) (3/4=1), gen(housing) 
 
*recode employment categories
gen emplstatus=.
replace emplstatus=1 if MAINSTAT==1
replace emplstatus=4 if MAINSTAT==2
replace emplstatus=3 if MAINSTAT>2
replace emplstatus=2 if MAINSTAT==1 & WRKHRS<31
label define emplstatus 1 "Full-time" 2 "Part-time" 3 "Not active" 4 "Active unemployed"
label values emplstatus emplstatus
 
*recode education categories 0= primary or less, 1= secondary, 2=university
gen edu=1
replace edu=2 if DEGREE==2 | DEGREE==3 | DEGREE==4
replace edu=3 if DEGREE==5 | DEGREE==6
label define edu 1 "Primary" 2 "Secondary" 3 "University"
label values edu edu

*gen age squared
rename AGE age
replace age=. if age==999
gen age2=age*age

*income
gen inczscore=.
local incvars = "AU_RINC CH_RINC CL_RINC CZ_RINC DE_RINC DK_RINC ES_RINC FI_RINC FR_RINC GB_RINC HR_RINC HU_RINC IL_RINC JP_RINC KR_RINC LV_RINC NO_RINC NZ_RINC PH_RINC RU_RINC SE_RINC SI_RINC TW_RINC US_RINC VE_RINC ZA_RINC"
foreach incvar of local incvars {
zscore `incvar', listwise
replace inczscore=z_`incvar' if z_`incvar'!=.
drop z_`incvar'
}

*gen time variable
gen year=2016

*country ID
rename country isocode
gen country=""
replace country="Australia" if isocode== 36
replace country="France" if isocode== 250
replace country="Germany" if isocode== 276
replace country="Japan" if isocode== 392
replace country="New Zealand" if isocode== 554
replace country="Norway" if isocode== 578
replace country="Spain" if isocode== 724
replace country="Sweden" if isocode== 752
replace country="Switzerland" if isocode== 756
replace country="United Kingdom" if isocode== 826
replace country="United States" if isocode== 840

rename SEX sex
keep isocode country year sex age age2 edu emplstatus inczscore oldagecare unemployment reduceincomedifferences jobs healthcare housing
keep if isocode== 36 | isocode== 250 | isocode== 276 | isocode== 392 | isocode== 554 | isocode== 578 | isocode== 724 | isocode== 752 | isocode== 756 | isocode== 826 | isocode== 840
save "2016.dta", replace

*combine data
use "1996.dta", clear
append using "2006.dta"
append using "2016.dta"

**set reference categories for edu and emplstatus
fvset base 2 edu
fvset base 1 emplstatus
recode sex (1=0) (2=1), gen(female)
replace female=. if female==9
quietly tab isocode, gen(cntryfe)
global depvars "oldagecare unemployment reduceincomedifferences jobs healthcare housing"
foreach depvar in $depvars {
replace `depvar'=. if `depvar'==8 | `depvar'==9
}
save "finaldata.dta", replace

***Compile country-level data
import excel "cri_macro.xlsx", sheet("cri_macro") firstrow clear
keep migstock_un mignet_un wdi_empprilo iso_country year
destring migstock_un mignet_un wdi_empprilo, replace 
rename iso_country isocode
keep if isocode== 36 | isocode== 250 | isocode== 276 | isocode== 392 | isocode== 554 | isocode== 578 | isocode== 724 | isocode== 752 | isocode== 756 | isocode== 826 | isocode== 840
keep if year== 1995 | year== 2005 | year== 2015
replace year = year+1
save "countrydataCRI.dta", replace

*socx
import excel "socx_oecd_83.xlsx", firstrow clear
destring y*, replace 
reshape long y, i(country) j(year) 
rename y socx

gen isocode=.
replace isocode=36 if country=="Australia"
replace isocode=250 if country=="France"
replace isocode=276 if country=="Germany"
replace isocode=392 if country=="Japan"
replace isocode=554 if country=="New Zealand"
replace isocode=578 if country=="Norway"
replace isocode=724 if country=="Spain"
replace isocode=752 if country=="Sweden"
replace isocode=756 if country=="Switzerland"
replace isocode=826 if country=="United Kingdom"
replace isocode=840 if country=="United States"
keep if isocode== 36 | isocode== 250 | isocode== 276 | isocode== 392 | isocode== 554 | isocode== 578 | isocode== 724 | isocode== 752 | isocode== 756 | isocode== 826 | isocode== 840
keep if year== 1995 | year== 2005 | year== 2015
replace socx =23.1 if country=="Japan" & year== 2015
replace year = year+1
save "socx.dta", replace

use "finaldata.dta", clear

merge m:1 isocode year using "socx.dta"
drop _m
merge m:1 isocode year using "countrydataCRI.dta"
drop _m
save "finaldata.dta", replace

use "finaldata.dta", clear
global depvars "oldagecare unemployment reduceincomedifferences jobs healthcare housing"
global controls "female age age2 i.edu i.emplstatus socx wdi_empprilo"

***ANALYSES***
*PI adjustment
replace mignet_un=mignet_un/10
*Table3: Regression estimates for percentage foreign born
loc i=1
foreach depvar in $depvars {
qui logit `depvar' migstock_un $controls i.year i.isocode, robust
margins, dydx(migstock_un) saving("t83m`i'",replace)
loc i=`i'+1
}
*Table4: Regression estimates for net migration
loc i=7
foreach depvar in $depvars {
qui logit `depvar' mignet_un $controls i.year i.isocode, robust
margins,dydx(mignet_un) saving("t83m`i'",replace)
loc i=`i'+1
}
use t83m1,clear
foreach x of numlist 2/12 {
append using t83m`x'
}

gen f=[_n]
gen factor = "Stock"
replace factor = "Flow" if f>6

gen id = "t83m1"
foreach x of numlist 2/12{
replace id = "t83m`x'" if f==`x'
}

clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
order factor AME lower upper id
keep factor AME lower upper id
save team83, replace

erase 1996.dta
erase 2006.dta
erase 2016.dta
erase countrydataCRI.dta
erase socx.dta
erase finaldata.dta

foreach x of numlist 1/12 {
erase t83m`x'.dta
}
}
*==============================================================================*
*==============================================================================*
*==============================================================================*
































// TEAM 86
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team86.dta"
  if _rc==0   {
    display "Team 86 already exists, skipping to next code chunk"
  }
  else {


// Original cleaning and merging of ISSP available as supplemental .zip file
// file available upon request

version 14.2

use full_data2_86,clear
drop insamp // recreate below

replace pctnonwest=pctnonwest-pctmuslim
replace pctnonwest_L5=pctnonwest_L5-pctmuslim_L5
replace pctnonwest_L10=pctnonwest_L10-pctmuslim_L10

foreach x of any pctforborn pctmuslim pctwest pctnonwest {
   gen  d5_`x'=(`x'_L5-`x')/`x'_L5
   label var d5_`x' "5-yr change" 
   gen d10_`x'=(`x'_L10-`x')/`x'_L10
   label var d10_`x' "10-yr change"
   }
	
// Local macros identify analysis variables and source variables
	
local rvar      "age age2 female                                              i.educ emp_p unemp not_labor emp_self            rel_inc" 
local rvar06    "age age2 female i.marital_r house_size child ib1.urban       i.educ emp_p unemp not_labor emp_self emp_public rel_inc i.religion"
local depvar    "tjobs templ tincome tretirement thousing thealthcare"

//  Create flags for (a) pooled sample (b) 1996 Table S2 sample and (c) 2006 sample

* 2006     Sample flag 17 countries 
egen insamp = anymatch(cntry),  ///
     values(36 124 208 246 250 276 372 392 528 554 578 620 724 752 756 826 840)
keep if insamp
	
markout insamp `rvar'  // all samples must have these variables
tab year insamp,m

* 1996-2016 Sample flag 13 countries
gen byte intwo=insamp     // flag for pooled sample of 13 countries
recode intwo 1=0 if cntry==208 | cntry==246 | cntry==528 | cntry==620 // Lose DK FI NL PT
recode intwo 1=0 if year==2016
label var intwo "2-Wave Pooled sample"


// Copy inpool from insamp and lose observations in Ireland, Canada, DK, FI, NL, PT 
gen byte inpool=insamp
// Lose Ireland, Canada, DK FI NL PT
recode inpool 1=0 if cntry==124 |cntry==208 | cntry==246 | cntry==528 | cntry==620 | cntry==372
label var inpool "3-Wave Pooled sample"
tab year inpool                  

*==============================================================================*
*==============================================================================*

*These are their preferred models (Table 4 with 'eststo' commands removed, as in their pdf report)

local rvar      "age age2 female                                              i.educ emp_p unemp not_labor emp_self            rel_inc" 
local depvar    "tjobs templ tincome tretirement thousing thealthcare"
loc a=1
loc b=7
loc c=13
loc d=19
loc e=25
loc f=31
loc g=37
loc h=43
loc i=49
foreach var of varlist `depvar' {
 
  logistic `var' pctwest pctnonwest pctmuslim `rvar' i.cntry i.year if inpool, or 
  margins, dydx(pctwest) saving("t86m`a'",replace)
  margins, dydx(pctnonwest) saving("t86m`b'",replace)
  margins, dydx(pctmuslim) saving("t86m`c'",replace)
  logistic `var' pctwest pctnonwest pctmuslim socx `rvar' i.cntry i.year if inpool, or 
  margins, dydx(pctwest) saving("t86m`d'",replace)
  margins, dydx(pctnonwest) saving("t86m`e'",replace)
  margins, dydx(pctmuslim) saving("t86m`f'",replace)
  logistic `var' pctwest pctnonwest pctmuslim emprate `rvar' i.cntry i.year if inpool, or 
  margins, dydx(pctwest) saving("t86m`g'",replace)
  margins, dydx(pctnonwest) saving("t86m`h'",replace)
  margins, dydx(pctmuslim) saving("t86m`i'",replace)
  loc a=`a'+1
  loc b=`b'+1
  loc c=`c'+1
  loc d=`d'+1
  loc e=`e'+1
  loc f=`f'+1
  loc g=`g'+1
  loc h=`h'+1
  loc i=`i'+1
  }
use t86m1, clear
foreach x of numlist 2/54 {
append using t86m`x'
}

gen f=[_n]
gen factor = .
gen id = "t86m1"
foreach x of numlist 2/54 {
replace id ="t86m`x'" if f==`x'
}
clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
order factor AME lower upper id
keep factor AME lower upper id
save team86, replace

foreach x of numlist 1/54 {
erase t86m`x'.dta
}
}
*==============================================================================*
*==============================================================================*
*==============================================================================*

























// TEAM 95
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team95.dta"
  if _rc==0   {
    display "Team 95 already exists, skipping to next code chunk"
  }
  else {
  version 15
  macro drop _all


*******************************************************************************
	* Preparation country data, provided by crowd initiative
	clear
	import excel cri_macro.xlsx, sheet("cri_macro") firstrow
	keep iso_country country year migstock_wb mignet_un wdi_empprilo socx_oecd
	keep if year==1995 | year==2005 | year==2015

	* Lag macro data
	recode year (1995=1996) (2005=2006) (2015=2016)

	* Immigrant stock
	* Def.: % foreign-born / total population
	rename migstock_wb foreignpct, m
	lab var foreignpct "Immigrant Stock (WB)"

	* Change in immigrant stock
	rename mignet_un netmigpct
	lab var netmigpct "Change in Immigrant Stock (UN)"

	* Social Welfare Expenditures
	rename socx_oecd socx
	lab var socx "Social Welfare Expenditures (OECD)"

	* Employment Rate
	rename wdi_empprilo emprate
	lab var emprate "Employment Rate (WDI)"

	* Destring
	replace socx="." if socx==".."
	destring foreignpct netmigpct socx emprate, replace
	drop country
	rename iso_country country

	* Get rid of years with missings
	drop if foreignpct>=. | netmigpct>=. | socx>=. | emprate>=.

	* Keep if macro data in at least two years
	bysort country: gen obs=_N
	keep if obs>=2
	drop obs
*PI adjustment
replace netmigpct=netmigpct/10
//
	sort country year
	save "macro_95.dta", replace

	********************************************************************************
	* Preparation ZA2900 (1996)

	use "ZA2900", clear

	** Identification
	clonevar id_96=v2
	gen year=1996
	recode v3 (1=36) (2/3=276) (4=826) (5=826) (6=840) (8=348) (9=380 "Italy") (10=372) (11=528) (12=578) (13=752) ///
	(14=203) (15=705) (16=616) (17=100 "Bulgaria") (18=643) (19=554) (20=124) (21=608) (22/23=376) (24=392) (25=724) (26=428) (27=250) (28=196 "Cyprus") (30=756), gen(country)

	********************************************************************************
	* Dependent Variables

	* v39: "provide a decent living for the old"
	clonevar oldagecare_ord=v39 /*expansion*/

	* v41: "provide a decent standard of living for the unemployed"
	clonevar unemployed_ord=v41 /*expansion*/

	* v42: "reduce income differences"
	clonevar income_ord=v42

	* v36: "provide a job for everyone who wants one"
	clonevar jobs_ord=v36  /*expansion*/


	********************************************************************************
	* Individual level control variables

	* v200: Respondent's sex
	gen female=1 if v200==2
	replace female=0 if v200==1
	lab var female "Female"
	lab def sex 0"male" 1"female"
	lab val female sex

	* v201: Respondent's age
	gen age=v201
	lab var age "Age"

	* v205: Education
	gen education=1 if inlist(v205,2,3,4)		// "incompl secondary" is in this category!
	replace education=2 if inlist(v205,5,6)
	replace education=3 if v205==7
	lab var education "Education"
	lab def education 1"Primary or less" 2"Secondary" 3"University or more"
	lab val education education

	* v206: Employment
	gen employment=1 if v206==1 // full-time
	replace employment=2 if inlist(v206,2,3)	// part-time, also "less part-time"
	replace employment=3 if inlist(v206,4,6,7,8,9,10) // inactive
	// this category includes "help family member", students, retired, houseman, disabled, other
	replace employment=4 if v206==5		// unemployed
	lab var employment "Employment"
	lab def employment 1"Full-time" 2"Part-time" 3"Not active" 4"Active unemployed"
	lab val employment employment


	keep id_96 year country oldagecare* unemployed* income* job* female age education employment
	sort country
	save "ISSP1996.dta", replace


	********************************************************************************
	* Preparation ZA4700 (2006)

	use "ZA4700", clear

	* identification
	clonevar id_06=V2
	clonevar country=V3a
	gen year=2006

	********************************************************************************
	* Dependent Variables

	* V28: "provide a decent living for the old"
	clonevar oldagecare_ord=V28

	* V30: "provide a decent standard of living for the unemployed"
	clonevar unemployed_ord=V30

	* V31: "reduce income differences"
	clonevar income_ord=V31

	* V25: "provide a job for everyone who wants one"
	clonevar jobs_ord=V25

	********************************************************************************
	* Individual level control variables

	* sex: Respondent's sex
	gen female=1 if sex==2
	replace female=0 if sex==1
	lab var female "Female"
	lab def sex 0"male" 1"female"
	lab val female sex
	* age: Respondent's age
	lab var age "Age"

	* degree: Education
	* Different categories as above
	gen education=1 if inlist(degree,0,1,2)		// "above lowest" is here
	replace education=2 if inlist(degree, 3,4) // "above higher sec" is here
	replace education=3 if degree==5 // only univesity
	replace education=. if inlist(educyrs, 95, 96) // still in school/university
	lab var education "Education"
	lab def education 1"Primary or less" 2"Secondary" 3"University or more"
	lab val education education


	* wrkst: Employment
	* How classify "help family members"?
	gen employment=1 if wrkst==1 // full-time
	replace employment=2 if inlist(wrkst,2,3)	// part-time, also "less part-time"
	replace employment=3 if inlist(wrkst,4,6,7,8,9,10) // inactive
	// this category includes "help family member", students, retired, houseman, disabled, other
	replace employment=4 if wrkst==5		// unemployed
	lab var employment "Employment"
	lab def employment 1"Full-time" 2"Part-time" 3"Not active" 4"Active unemployed"
	lab val employment employment


	keep id_06 year country oldagecare* unemployed* income* jobs* female age education employment
	sort country
	save "ISSP2006.dta", replace


	* Preparation ZA6900 (2016)

	use "ZA6900_v2-0-0", clear

	* identification
	clonevar id_16=CASEID
	rename country country_orig
	clonevar country=country_orig // Variable heißt bereits country. Umbenennung,um Originalvar nicht zu überschreiben?
	gen year=2016

	********************************************************************************
	* Dependent Variables

	* v24: "provide a decent living for the old"
	clonevar oldagecare_ord=v24
	replace oldagecare_ord=. if v24>4

	* v26: "provide a decent standard of living for the unemployed"
	clonevar unemployed_ord=v26
	replace unemployed_ord=. if v26>4 | v26==0

	* v27: "reduce income differences"
	clonevar income_ord=v27
	replace income_ord=. if v27>4


	* v21: "provide a job for everyone who wants one"
	clonevar jobs_ord=v21
	replace jobs_ord=. if v21>4

	********************************************************************************
	* Individual level control variables

	* SEX: Respondent's sex
	gen female=1 if SEX==2
	replace female=0 if SEX==1
	lab var female "Female"
	lab def sex 0"male" 1"female", replace
	lab val female sex

	* AGE: Respondent's age
	gen age=AGE
	replace age=22 if DK_AGE==22  // Allocation DENMARK due to other age categories
	replace age=31 if DK_AGE==31
	replace age=41 if DK_AGE==41
	replace age=61 if DK_AGE==61
	replace age=70 if DK_AGE==70 // how treat those who are "above 65 years"?
	replace age=. if AGE==999
	lab var age "Age"

	* DEGREE: Education
	* Different categories as above
	gen education=1 if inlist(DEGREE, 0,1)		// "no formal" and "primary" is here
	replace education=2 if inlist(DEGREE, 2,3,4) // "lower sec", "upper sec" and "post sec, non tert" is here
	replace education=3 if inlist(DEGREE, 5,6) // "lower tert" and "upper tert" is here
	replace education=. if inlist(EDUCYRS, 95, 96) // still in school/university
	lab var education "Education"
	lab def education 1"Primary or less" 2"Secondary" 3"University or more"
	lab val education education

	* MAINSTAT and WRKHRS: Employment
	* definition: 30 hrs weekly and above=fulltime
	gen employment=1 if MAINSTAT==1 & WRKHRS>=30 & WRKHRS<=96 // full-time, here defined as 30 hrs/week
	replace employment=2 if MAINSTAT==1 & WRKHRS>=1 & WRKHRS<=29 // part-time, here less than 30 hrs/week
	replace employment=3 if inlist(MAINSTAT, 3,4,5,6,7,8,9)				// inactive
	// this category includes: in education, apprenticeship/trainee, sick/disabled, retired, domestic work
	// compulsatory military service, other
	replace employment=4 if MAINSTAT==2 	// unemployed
	lab var employment "Employment"
	lab def employment 1"Full-time" 2"Part-time" 3"Not active" 4"Active unemployed", replace
	lab val employment employment


	keep id_16 year country oldagecare* unemployed* income* jobs* female age education employment
	sort country
	save "ISSP2016.dta", replace



	********************************************************************************
	append using "ISSP1996.dta"
	append using "ISSP2006.dta"

	label define COUNTRY 	100 "Bulgaria" 124 "Canada" 196 "Cyprus"214 "Dominican Republic" ///
							372 "Canada" 380 "Italy"528 "Netherlands" ///
							616 "Poland" 620 "Portugal"858 "Uruguay", modify

	numlabel COUNTRY, add force

	********************************************************************************
	* Merge country data

	sort country year
	merge m:1 country year using "macro_95.dta"
	bysort _merge: tab country year, m
	** Exclude countries without macro information
	drop if _merge==1
	drop if _merge==2
	capture drop _merge
	drop if emprate==. | foreignpct==. | socx==. | netmigpct==.
	*Exclude countries taking part in ISSP only once
	drop if inlist(country, 56, 352, 380, 528, 620, 703)

	********************************************************************************
	* Preparation of analysis

	egen varmiss=rowmiss(oldagecare* unemployed* income* jobs* female age education employment)

	drop if varmiss>0
	capture drop varmiss

	* center age because of age^2
	sum age
	gen c_age=age-r(mean)
	lab var c_age "age (centered)"

*-------------------------------------------------*
*** EXPANSION: ALTERNATIVE MODEL SPECIFICATIONS ***
*-------------------------------------------------*

* prepare time-constant variable foreignpct_1996

gen foreignpct_1996_help=foreignpct if year==1996
bysort country: egen foreignpct_1996=min(foreignpct_1996_help)
capture drop foreignpct_1996_help

global ilcontrols "female c.c_age##c.c_age i.b2.education i.b1.employment i.country i.year, cluster(country)"


*------------------------------------------------------------------*
* Preferred models, pdf suggests linear models
*ordered models have the same expectation (and results) 
* - 2 margins per outcome --> both macro controls, OLS *	
*------------------------------------------------------------------*


*PI adjustment
*Team did not recode agreement to be higher values
foreach var in oldagecare_ord unemployed_ord income_ord jobs_ord  {
	replace `var' = (`var'-5)*(-1)
}
//

* M1-M4: foreignpct, all macro controls
local i=1
foreach var in jobs_ord unemployed_ord income_ord oldagecare_ord  {
	qui reg `var' c.foreignpct##c.foreignpct socx emprate $ilcontrols
	margins, dydx(foreignpct) saving ("t95m`i'",replace)
	local i=`i'+1
	}
	
	
* M5-M8: netmigpct, all macro controls
local i=5
foreach var in jobs_ord unemployed_ord income_ord oldagecare_ord {
	qui reg `var' c.netmigpct##c.netmigpct##c.foreignpct_1996 socx emprate $ilcontrols
	margins, dydx(netmigpct) saving("t95m`i'",replace)
	local i=`i'+1
	}


use t95m1,clear
foreach x of numlist 2/8 {
append using t95m`x'
}

gen f=[_n]
gen factor = "Stock"
replace factor = "Flow, 1-year" if f>4

gen id = "t95m1"
foreach x of numlist 2/8 {
replace id = "t95m`x'" if f==`x'
}


clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
order factor AME lower upper id
keep factor AME lower upper id
save team95, replace 

foreach x of numlist 1/8 {
erase t95m`x'.dta
}

erase macro_95.dta
}	
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

































// TEAM 96
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*
capture confirm file "team96.dta"
  if _rc==0   {
    display "Team 96 already exists, skipping to next code chunk"
  }
  else {


********************************
********** ISSP 1996 ***********
********************************

use "ZA2900.dta", clear
recode v3 (1=36) (2/3=276) (4=826) (6=840) (8=348) (9=.) (10=372) (12=578) (13=752) (14=203) (15=705) (16=616) (17=.) (18=643) (19=554) (20=124) (21=608) (22/23=376) (24=392) (25=724) (26=428) (27=250) (28=.) (30=756), gen(v3a)
label define cntrylbl 36 "Australia" 124 "Canada" 152 "Chile" 158 "Taiwan" 191 "Croatia" 203 "Czech" 208 "Denmark" 246 "Finland" 250 "France" 276 "Germany" 348 "Hungary" 372 "Ireland" 376 "Isreal" 392 "Japan" 410 "S Korea" 428 "Latvia" 528 "Netherlands" 554 "New Zealand" 578 "Norway" 608 "Philippines" 616 "Poland" 620 "Portugal" 643 "Russia" 705 "Slovenia" 724 "Spain" 752 "Sweden" 756 "Switzerland" 826 "Great Britain" 840 "United States" 
label values v3a cntrylbl

****************************************
***** ROLE OF GOVERNMENT VARIABLES *****
****************************************

**** GOV RESPONSIBILITY ****
// All variables originally coded 1 to 4, "should be" to "should not be"

// Provide jobs for everyone
recode v36 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
recode govjobs (1/2=0) (3/4=1), gen(dgovjobs)

// Provide healthcare for the sick
recode v38 (1=4) (2=3) (3=2) (4=1), gen(govhcare)
recode govhcare (1/2=0) (3/4=1), gen(dhcare)

// Provide living standard for the old
recode v39 (1=4) (2=3) (3=2) (4=1), gen(govretire)
recode govretire (1/2=0) (3/4=1), gen(dgovretire)

// Provide living standard for the unemployed
recode v41 (1=4) (2=3) (3=2) (4=1), gen(govunemp)
recode govunemp (1/2=0) (3/4=1), gen(dgovunemp)

// Reduce income diff bw rich and poor
recode v42 (1=4) (2=3) (3=2) (4=1), gen(govincdiff)
recode govincdiff (1/2=0) (3/4=1), gen(dgovincdiff)

// Provide decent housing to those who can't afford it
recode v44 (1=4) (2=3) (3=2) (4=1), gen(govhousing)
recode govhousing (1/2=0) (3/4=1), gen(dgovhous)


*****************************
***** CONTROL VARIABLES *****
*****************************

// AGE
rename v201 age
gen agesq=age*age

// SEX
recode v200 (1=0) (2=1), gen(female)

// MARITAL STATUS
** missing for Spain
rename v202 marst
recode marst (5=1) (nonmiss=0), gen(nevermar)
recode marst (2/5=0), gen(married)
recode marst (3/4=1) (nonmiss=0), gen(divorced)
recode marst (2=1) (nonmiss=0), gen(widow)

// STEADY LIFE PARTNER
recode v203 (2=0), gen(partner)

// HOUSEHOLD SIZE
// top-coded at 8 for Great Britain, 9 for Slovenia
rename v273 hhsize

// CHILDREN IN HH
recode v274 (2/4=1) (6/8=1) (nonmiss=0), gen(kidshh)
local i = 10
while `i' < 27 {
	replace kidshh=1 if v274==`i'
	local i = `i' + 2
}

// RURAL
recode v275 (3=1) (nonmiss=0), gen(rural)
recode v275 (2=1) (nonmiss=0), gen(suburb)

// COUNTRY/PLACE OF BIRTH
rename v324 ETHNIC

// EDUCATION
rename v204 edyears
rename v205 edcat
recode edcat (1/3=1) (4=2) (5=3) (6=4) (7=5), gen(degree)
label define edlabels 1 "Primary/less" 2 "Some Secondary" 3 "Secondary" 4 "Some Higher Ed" 5 "University or higher"
label values degree edlabels

recode degree (1/2=1) (nonmiss=0), gen(lesshs)
recode degree (3/4=1) (nonmiss=0), gen(hs)
recode degree (5=1) (nonmiss=0), gen(univ)

// OCCUPATION
// see page 127 (210 of pdf) in codebook
rename v208 isco
rename v209 occ2
rename v215 hourswrk

recode v206 (2/10=0), gen(ftemp)
recode v206 (2/4=1) (nonmiss=0), gen(ptemp)
recode v206 (5=1) (nonmiss=0), gen(unemp)
recode v206 (6/10=1) (nonmiss=0), gen(nolabor)

gen selfemp=v213==1
replace selfemp=. if v206==.
gen pubemp=(v212==1 | v212==2)
replace pubemp=. if v206==.
gen pvtemp=(selfemp==0 & pubemp==0)
replace pvtemp=. if v206==.

// INCOME
// constructing country-specific z-scores, then a standardized cross-country income variable
rename v218 faminc

gen inczscore=.
levelsof v3a, local(cntries)
foreach cntryval of local cntries {
	zscore faminc if v3a==`cntryval', listwise
	replace inczscore=z_faminc if v3a==`cntryval'
	drop z_faminc
}

// UNION MEMBER
recode v222 (2=0), gen(union)

// POLITICAL PARTY 
rename v223 party

// RELIGIOUS ATTENDANCE
recode v220 (1/2=1) (nonmiss=0), gen(highrel)
recode v220 (3/5=1) (nonmiss=0), gen(lowrel)
recode v220 (6=1) (nonmiss=0), gen(norel)
rename v220 religion

*** TECHNICAL VARIABLES ***

// year
gen year=1996
gen yr2006=0
gen yr2016=0

// country identifier
rename v3a cntry

// weights
rename v325 wghts

save "ISSP96recode.dta", replace


********************************
********** ISSP 2006 ***********
********************************

use "ZA4700.dta", replace

*******************************
***** DEPENDENT VARIABLES *****
*******************************

**** GOV RESPONSIBILITY ****
// All variables originally coded 1 to 4, "should be" to "should not be"
// reverse coded, then dichotomous version collapses to "should be"/'maybe should be" and "maybe should not be"/"should not be"

// Provide jobs for everyone
recode V25 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
recode govjobs (1/2=0) (3/4=1), gen(dgovjobs)

// Provide healthcare for the sick
recode V27 (1=4) (2=3) (3=2) (4=1), gen(govhcare)
recode govhcare (1/2=0) (3/4=1), gen(dhcare)

// Provide living standard for the old
recode V28 (1=4) (2=3) (3=2) (4=1), gen(govretire)
recode govretire (1/2=0) (3/4=1), gen(dgovretire)

// Provide living standard for the unemployed
recode V30 (1=4) (2=3) (3=2) (4=1), gen(govunemp)
recode govunemp (1/2=0) (3/4=1), gen(dgovunemp)

// Reduce income diff bw rich and poor
recode V31 (1=4) (2=3) (3=2) (4=1), gen(govincdiff)
recode govincdiff (1/2=0) (3/4=1), gen(dgovincdiff)

// Provide decent housing to those who can't afford it
recode V33 (1=4) (2=3) (3=2) (4=1), gen(govhousing)
recode govhousing (1/2=0) (3/4=1), gen(dgovhous)

*****************************
***** CONTROL VARIABLES *****
*****************************

// AGE
gen agesq=age*age /*AOP change 1: AGE was already renamed as age*/

// SEX
recode sex (1=0) (2=1), gen(female) /*AOP change 2: SEX was named as sex*/

// MARITAL STATUS
rename marital marst /*AOP change 3: MARITAL was marital*/
recode marst (5=1) (nonmiss=0), gen(nevermar)
recode marst (2/5=0), gen(married)
recode marst (3/4=1) (nonmiss=0), gen(divorced)
recode marst (2=1) (nonmiss=0), gen(widow)

// STEADY LIFE PARTNER
recode cohab (2=0), gen(partner) /*AOP change 4: COHAB was cohab*/

// HOUSEHOLD SIZE
// top-coded at 8 for Sweden, 9 for Denmark
rename hompop hhsize /*AOP change 5: HOMPOP was hompop*/

// CHILDREN IN HH
recode hhcycle (2/4=1) (6/8=1) (nonmiss=0), gen(kidshh) /*AOP change 6: HHCYCLE was hhcycle*/
local i = 10
while `i' < 29 {
	replace kidshh=1 if hhcycle==`i'
	local i = `i' + 2
}

// RURAL
recode urbrural (1/3=0) (4/5=1), gen(rural) /*AOP change 7: URBRURAL was urbrural*/
recode urbrural (2/3=1) (nonmiss=0), gen(suburb)

// EDUCATION
// see pg 97 in codebook
rename educyrs edyears /*AOP change 8: EDUCYRS was educyrs*/
rename degree edcat  /*AOP change 9: DEGREE was degree*/
recode edcat (0=1), gen(degree)
label define edlabels 1 "Primary/less" 2 "Some Secondary" 3 "Secondary" 4 "Some Higher Ed" 5 "University or higher"
label values degree edlabels

recode degree (1/2=1) (nonmiss=0), gen(lesshs)
recode degree (3/4=1) (nonmiss=0), gen(hs)
recode degree (5=1) (nonmiss=0), gen(univ)

// OCCUPATION
rename wrkst empstat  /*AOP change 10: WRKST was wrkst*/
rename ISCO88 isco // see pg 137 in codebook 
**rename wrkhrs hourswrk /*AOP change 11: WRKHRS was already renamed hourswrk*/

recode empstat (2/10=0), gen(ftemp)
recode empstat (2/4=1) (nonmiss=0), gen(ptemp)
recode empstat (5=1) (nonmiss=0), gen(unemp)
recode empstat (6/10=1) (nonmiss=0), gen(nolabor)

gen selfemp=wrktype==4 /*AOP change 12: WRKTYPE was wrktype*/
replace selfemp=. if empstat==.
gen pubemp=(wrktype==1 | wrktype==2)
replace pubemp=. if empstat==.
gen pvtemp=(selfemp==0 & pubemp==0)
replace pvtemp=. if empstat==.

// INCOME
// earnings and family income are country specific
// dividing family income by the squareroot of hh size and transforming to country-specific z-scores
// generating a cross-country income variable using within-country z-scores

gen inczscore=.
local incvars = "AU_INC CA_INC CH_INC CL_INC CZ_INC DE_INC DK_INC DO_INC ES_INC FI_INC FR_INC GB_INC HR_INC HU_INC IE_INC IL_INC JP_INC KR_INC LV_INC NL_INC NO_INC NZ_INC PH_INC PL_INC PT_INC RU_INC SE_INC SI_INC TW_INC US_INC UY_INC VE_INC ZA_INC" 
foreach incvar of local incvars {
	zscore `incvar', listwise
	replace inczscore=z_`incvar' if z_`incvar'!=.
	drop z_`incvar'
}

// UNION MEMBER
recode union (2/3=0), gen(union1) /*AOP change 13: UNION was union, but was not recoded, thus the next two lines*/
rename union union_old /*renaming union1 that we just created*/
rename union1 union

// POLITICAL PARTY
rename PARTY_LR party

// RELIGIOUS ATTENDANCE
recode attend (1/3=1) (nonmiss=0), gen(highrel)/*AOP change 14: ATTEND was attend*/
recode attend (4/7=1) (nonmiss=0), gen(lowrel)
recode attend (8=1) (nonmiss=0), gen(norel)
rename attend religion

*** TECHNICAL VARIABLES ***

// Country Identifier
rename V3a cntry

// weights
rename weight wghts

// year
gen year=2006
gen yr2006=1
gen yr2016=0

gen mail=mode==34 /*AOP change 15: MODE was mode*/

save  "ISSP06recode.dta", replace

************************
***** MERGING DATA *****
************************

append using "ISSP96recode.dta"

save "ISSP9606.dta", replace


********************************
********** ISSP 2016 ***********
********************************

use "ZA6900_v2-0-0", clear
// This command does not recode all the 1996 countries though.
*recode v3 (1=36) (2/3=276) (4=826) (6=840) (8=348) (9=.) (10=372) (12=578) (13=752) (14=203) (15=705) (16=616) (17=.) (18=643) (19=554) (20=124) (21=608) (22/23=376) (24=392) (25=724) (26=428) (27=250) (28=.) (30=756), gen(v3a)
gen countrylbl = country
label define countrylbl 36 "Australia" 124 "Canada" 152 "Chile" 158 "Taiwan" 191 "Croatia" 203 "Czech" 208 "Denmark" 246 "Finland" 250 "France" 276 "Germany" 348 "Hungary" 372 "Ireland" 376 "Isreal" 392 "Japan" 410 "S Korea" 428 "Latvia" 528 "Netherlands" 554 "New Zealand" 578 "Norway" 608 "Philippines" 616 "Poland" 620 "Portugal" 643 "Russia" 705 "Slovenia" 724 "Spain" 752 "Sweden" 756 "Switzerland" 826 "Great Britain" 840 "United States" 
label values countrylbl


**** GOV RESPONSIBILITY dgovjobs dgovunemp dgovincdiff dgovretire dgovhous dhcare****
// All variables originally coded 1 to 4, "should be" to "should not be"

// Provide jobs for everyone - 2016
recode v21 (1=4) (2=3) (3=2) (4=1), gen(govjobs)
recode govjobs (1/2=0) (3/4=1), gen(dgovjobs)

tab dgovjobs
replace dgovjobs = . if dgovjobs ==8
replace dgovjobs = . if dgovjobs ==9


// Provide healthcare for the sick - 2016
recode v23 (1=4) (2=3) (3=2) (4=1), gen(govhcare)
recode govhcare (1/2=0) (3/4=1), gen(dhcare)
tab dhcare
replace dhcare = . if dhcare ==8
replace dhcare = . if dhcare ==9

// Provide living standard for the old- 2016
recode v24 (1=4) (2=3) (3=2) (4=1), gen(govretire)
recode govretire (1/2=0) (3/4=1), gen(dgovretire)

tab dgovretire
replace dgovretire = . if dgovretire==8
replace dgovretire = . if dgovretire==9


// Provide living standard for the unemployed- 2016
recode v26 (1=4) (2=3) (3=2) (4=1), gen(govunemp)
recode govunemp (1/2=0) (3/4=1), gen(dgovunemp)
tab dgovunemp
replace dgovunemp = . if dgovunemp ==8
replace dgovunemp = . if dgovunemp ==9


// Reduce income diff bw rich and poor- 2016
recode v27 (1=4) (2=3) (3=2) (4=1), gen(govincdiff)
recode govincdiff (1/2=0) (3/4=1), gen(dgovincdiff)
tab dgovincdiff 
replace dgovincdiff = . if dgovincdiff ==8
replace dgovincdiff = . if dgovincdiff ==9



// Provide decent housing to those who can't afford it - 2016
recode v29 (1=4) (2=3) (3=2) (4=1), gen(govhousing)
recode govhousing (1/2=0) (3/4=1), gen(dgovhous)
tab dgovhous
replace dgovhous = . if dgovhous ==8
replace dgovhous = . if dgovhous ==9

su dgovjobs dgovunemp dgovincdiff dgovretire dgovhous dhcare



*****************************
***** CONTROL VARIABLES ***** age female univ lesshs  ptemp unemp nolabor selfemp inczscore yr2006
*****************************

// AGE
tostring AGE, gen (AGE_str)
tab AGE_str
gen age =  AGE_str
replace age = "." if age =="0"
replace age = "." if age =="999"
destring age, replace
gen agesq=age*age

// SEX
recode SEX (1=0) (2=1), gen(female) 
replace female = . if female==9
tab female

// MARITAL STATUS
tostring MARITAL, gen (MARITAL_str)
gen marst =  MARITAL  
recode marst (6=1) (nonmiss=0), gen(nevermar)
recode marst (1/2=1) (nonmiss=0), gen(married)
recode marst (3/4=1) (nonmiss=0), gen(divorced)
recode marst (5=1) (nonmiss=0), gen(widow)

// EDUCATION
rename EDUCYRS edyears /*AOP change 8: EDUCYRS was educyrs*/
rename DEGREE edcat  /*AOP change 9: DEGREE was degree*/
recode edcat (0=1), gen(degree)
label define edlabels 1 "Primary/less" 2 "Some Secondary" 3 "Secondary" 4 "Some Higher Ed" 5 "University or higher"
label values degree edlabels

recode degree (1/2=1) (nonmiss=0), gen(lesshs)
recode degree (3/4=1) (nonmiss=0), gen(hs)
recode degree (5/6=1) (nonmiss=0), gen(univ)

// OCCUPATION
recode WORK (2/3=1) (nonmiss=0), gen(unemp)
recode WRKHRS (0=1) (nonmiss=0), gen(unemp1)

gen ptemp = 0
replace ptemp = 1 if WRKHRS<40

recode EMPREL (2/3=1) (nonmiss=0), gen(selfemp)

// INCOME
// earnings and family income are country specific
// dividing family income by the squareroot of hh size and transforming to country-specific z-scores
// generating a cross-country income variable using within-country z-scores

*drop inczscore
gen inczscore=.
local incvars = "AU_INC  CH_INC CL_INC CZ_INC DE_INC DK_INC ES_INC FI_INC FR_INC GB_INC HR_INC HU_INC IL_INC JP_INC KR_INC LV_INC NO_INC NZ_INC PH_INC RU_INC SE_INC SI_INC TW_INC US_INC VE_INC ZA_INC" 
foreach incvar of local incvars {
	zscore `incvar', listwise
	replace inczscore=z_`incvar' if z_`incvar'!=.
	drop z_`incvar'
}

*** TECHNICAL VARIABLES ***

// year
gen year=2016
gen yr2006=0
gen yr2016=1
// country identifier
rename country cntry

// weights
rename WEIGHT wghts

************************
***** MERGING DATA *****
************************

append using "ISSP9606.dta", force

sort cntry year
preserve
use cri_macro.dta,clear
rename iso_country cntry
save cri_macro_96.dta,replace
restore
merge m:1 cntry year using "cri_macro_96.dta"
sort cntry year
*The way it is coded here, there is no data for netmigpct in 2016
*PI adjusment
replace mignet_un = mignet_un[_n-1] if year==2016

recode cntry (36=1) (124=1) (208=1) (246=1) (250=1) (276=1) (372=1) (392=1) (528=1) (554=1) (578=1) (620=1) (724=1) (752=1) (756=1) (826=1) (840=1) (else=0), gen(orig17)
recode cntry (36=1) (124=1) (250=1) (276=1) (372=1) (392=1) (554=1) (578=1) (724=1) (752=1) (756=1) (826=1) (840=1) (else=0), gen(orig13)
rename (migstock_wb migstock_un migstock_oecd mignet_un wdi_empprilo socx_oecd) (foreignpct_wb foreignpct_un foreignpct_oecd netmigpct emprate socx),replace

save "ISSP960616_appended1.dta", replace


********************* ANALYSES *****************************

******************************
***** 1996-2006 ANALYSES *****
******************************

keep if orig13

gen age50 = 0
replace age50 =1 if age>=50

global depvars "dgovjobs dgovunemp dgovincdiff dgovretire dgovhous dhcare"

global controls "age female univ lesshs  ptemp unemp selfemp inczscore yr2006 yr2016"

egen allcontrols = rowmiss($controls)
recode allcontrols (0=1) (nonmiss=0)
quietly tab cntry, gen(cntryfe)


destring foreignpct_un foreignpct_wb foreignpct_oecd netmigpct socx emprate, replace force
keep if year==1996|year==2006|year==2016

*PI adjustment
replace netmigpct=netmigpct/10
//


*** APPROACH 1: Brady & Finnigan plus 2016 wave
loc i=1
foreach depvar in $depvars {
		logit `depvar' c.foreignpct_un $controls cntryfe*
		margins,dydx(foreignpct_un) saving("t96m`i'",replace)
		loc i=`i'+1
	}

loc i=7
foreach depvar in $depvars {
		logit `depvar' c.foreignpct_un socx $controls cntryfe*
		margins,dydx(foreignpct_un) saving("t96m`i'",replace)
		loc i=`i'+1
	}

loc i=13
foreach depvar in $depvars {
		logit `depvar' c.foreignpct_un emprate $controls cntryfe*
		margins,dydx(foreignpct_un) saving("t96m`i'",replace)
		loc i=`i'+1
	}

loc i=25
foreach depvar in $depvars {
		logit `depvar' c.netmigpct $controls cntryfe*
		margins,dydx(netmigpct) saving("t96m`i'",replace)
		loc i=`i'+1
		tab cntry year if e(sample)==1
	}
loc i=31
foreach depvar in $depvars {
		logit `depvar' c.netmigpct socx $controls cntryfe*
		margins,dydx(netmigpct) saving("t96m`i'",replace)
		loc i=`i'+1
		}
loc i=37
foreach depvar in $depvars {
		logit `depvar' c.netmigpct emprate $controls cntryfe*
		margins,dydx(netmigpct) saving("t96m`i'",replace)
		loc i=`i'+1
	}
loc i=19
loc t=43
foreach depvar in $depvars {
		logit `depvar' c.netmigpct foreignpct_un $controls cntryfe*
		margins,dydx(foreignpct_un) saving("t96m`i'",replace)
		margins,dydx(netmigpct) saving("t96m`t'",replace)
		loc i=`i'+1
		loc t=`t'+1
	}

*** APPROACH 2 is to compare different groups, cannot compare here.

*** APPROACH 3: a first differences strategy ***

*PI adjusment // had to remove some lines that referred to non-existant variables
rename emprate emprate_m
rename foreignpct_un foreignpct_m
rename pop_wb pop_m
rename socx socx_m
rename netmigpct netmigpct_m



** step 1: generate aggregate attitudes per country - use 26(?) countries
** 6DVs dgovjobs dgovunemp dgovincdiff dgovretire dgovhous dhcare
** 3 summary measures for each: mean, median, sd 
egen meanjobs = mean(dgovjobs), by(cntry year)
egen meanunemp = mean(dgovunemp), by(cntry year)
egen meanincdiff = mean(dgovincdiff), by(cntry year)
egen meanretire = mean(dgovretire), by(cntry year)
egen meanhous = mean(dgovhous), by(cntry year)
egen meancare = mean(dhcare), by(cntry year)

egen medjobs = median(dgovjobs), by(cntry year)
egen medunemp = median(dgovunemp), by(cntry year)
egen medincdiff = median(dgovincdiff), by(cntry year)
egen medretire = median(dgovretire), by(cntry year)
egen medhous = median(dgovhous), by(cntry year)
egen medcare = median(dhcare), by(cntry year)

egen sdjobs = sd(dgovjobs), by(cntry year)
egen sdunemp = sd(dgovunemp), by(cntry year)
egen sdincdiff = sd(dgovincdiff), by(cntry year)
egen sdretire = sd(dgovretire), by(cntry year)
egen sdhous = sd(dgovhous), by(cntry year)
egen sdcare = sd(dhcare), by(cntry year)

egen iqrjobs = iqr(dgovjobs), by(cntry year)
egen iqrunemp = iqr(dgovunemp), by(cntry year)
egen iqrincdiff = iqr(dgovincdiff), by(cntry year)
egen iqrretire = iqr(dgovretire), by(cntry year)
egen iqrhous = iqr(dgovhous), by(cntry year)
egen iqrcare = iqr(dhcare), by(cntry year)

collapse (mean)meanjobs = meanjobs (first)meanjobs2= meanjobs (mean)meanunemp (mean)meanincdiff ///
(mean)meanretire (mean)meanhous (mean)meancare (mean)medjobs (mean)medunemp (mean)medincdiff (mean)medretire ///
(mean)medhous (mean)medcare (mean)sdjobs (mean)sdunemp (mean)sdincdiff (mean)sdretire (mean)sdhous (mean)sdcare ///
(mean)iqrjobs (mean)iqrunemp (mean)iqrincdiff (mean)iqrretire (mean)iqrhous (mean)iqrcare ///
(mean)foreignpct_m (mean)pop_m (mean)socx_m (mean)netmigpct_m, by(cntry year)




sort cntry year
merge m:1 cntry year using "cri_macro_96.dta"
*PI added these commands
drop _merge
drop mignet_un
//
merge m:1 cntry year using "netmigpct_96.dta"

*PI adjustment, these variables are already numeric
gen emprate= wdi_empprilo
gen socx= socx_oecd
gen foreignpct_wb = migstock_wb
gen foreignpct_un = migstock_un
gen foreignpct_oecd = migstock_oecd
gen netmigpct = mignet_un


sort cntry year
** step 4A: create the difference variables for DVs: 2016 - 2006
gen meanjobs_diff9606 = meanjobs - l10.meanjobs if year==2006
gen meanjobs_diff0616 = meanjobs - l10.meanjobs if year==2016

gen meanunemp_diff9606 = meanunemp - l10.meanunemp if year==2006
gen meanunemp_diff0616 = meanunemp - l10.meanunemp if year==2016

gen meanincdiff_diff9606 = meanincdiff - l10.meanincdiff if year==2006
gen meanincdiff_diff0616 = meanincdiff - l10.meanincdiff if year==2016

gen meanretire_diff9606 = meanretire - l10.meanretire if year==2006
gen meanretire_diff0616 = meanretire - l10.meanretire if year==2016

gen meanhous_diff9606 = meanhous - l10.meanhous if year==2006
gen meanhous_diff0616 = meanhous - l10.meanhous if year==2016

gen meancare_diff9606 = meancare - l10.meancare if year==2006
gen meancare_diff0616 = meancare - l10.meancare if year==2016
   

gen sdjobs_diff9606 = sdjobs - l10.sdjobs if year==2006
gen sdjobs_diff0616 = sdjobs - l10.sdjobs if year==2016
 
gen sdunemp_diff9606 = sdunemp - l10.sdunemp if year==2006
gen sdunemp_diff0616 = sdunemp - l10.sdunemp if year==2016
 
gen sdincdiff_diff9606 = sdincdiff - l10.sdincdiff if year==2006
gen sdincdiff_diff0616 = sdincdiff - l10.sdincdiff if year==2016

gen sdretire_diff9606 = sdretire - l10.sdretire if year==2006
gen sdretire_diff0616 = sdretire - l10.sdretire if year==2016
 
gen sdhous_diff9606 = sdhous - l10.sdhous if year==2006
gen sdhous_diff0616 = sdhous - l10.sdhous if year==2016
 
gen sdcare_diff9606 = sdcare - l10.sdcare if year==2006
gen sdcare_diff0616 = sdcare - l10.sdcare if year==2016
      
 
** step 4B: create the difference variables for IVs: 2016 - 2006
*PI had to add this command, seems to have been forgotten
gen lag_netmigpct = l10.netmigpct
gen netmig_diff9606 = netmigpct - lag_netmigpct if year==2006
gen netmig_diff0616 = netmigpct - lag_netmigpct if year==2016

gen lag_foreignpctun = l10.foreignpct_un
gen forborn_diff9606 = foreignpct_un - lag_foreignpctun if year==2006
gen forborn_diff0616 = foreignpct_un - lag_foreignpctun if year==2016

 order year cntry netmigpct lag_ne netmig_diff* foreignpct_un lag_for forborn_di* meanjobs* 
 

** preferred models

global depvars9606 "meanjobs_diff9606 meanunemp_diff9606 meanincdiff_diff9606 meanretire_diff9606 meanhous_diff9606 meancare_diff9606"
global depvars0616 "meanjobs_diff0616 meanunemp_diff0616 meanincdiff_diff0616 meanretire_diff0616 meanhous_diff0616 meancare_diff0616"

****First diffs with means

*PI reomved the cluster commands because they are redundant when there are only 11 cases

*PI adjustment, make it change per year
replace forborn_diff9606 = forborn_diff9606/10
replace forborn_diff0616 = forborn_diff0616/10
//
loc i = 49
loc t = 55
foreach depvar in $depvars9606 {
	reg `depvar' forborn_diff9606 
	margins, dydx(forborn_diff9606) saving("t96m`i'",replace)
	reg `depvar' netmig_diff9606
	margins, dydx(netmig_diff9606) saving("t96m`t'",replace)
	loc i = `i'+1
	loc t = `t'+1
	}

loc i = 61
loc t = 67
foreach depvar in $depvars0616 {
	reg `depvar' forborn_diff0616
	margins, dydx(forborn_diff0616) saving("t96m`i'",replace)
	reg `depvar' netmig_diff0616
	margins, dydx(netmig_diff0616) saving("t96m`t'",replace)
	loc i = `i'+1
	loc t = `t'+1
	}
	
****last table: both IVs
loc i = 73
loc t = 79
foreach depvar in $depvars9606 {
	reg `depvar' forborn_diff9606 netmig_diff9606
	margins, dydx(forborn_diff9606) saving("t96m`i'",replace)  
	margins, dydx(netmig_diff9606) saving("t96m`t'",replace)
	loc i = `i'+1
	loc t = `t'+1

	}
loc i = 85
loc t = 91
foreach depvar in $depvars0616 {
	reg `depvar' forborn_diff0616 netmig_diff0616
	margins, dydx(forborn_diff0616) saving("t96m`i'",replace)
	margins, dydx(netmig_diff0616) saving("t96m`t'",replace)
	loc i = `i'+1
	loc t = `t'+1
	}	

use t96m1.dta, clear
foreach m of numlist 2/96 {
append using t96m`m'.dta
}

gen id = "t96m1"
foreach n of numlist 2/96 {
replace id = "t96m`n'" if `n' == [_n]
}

gen factor = .
clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
order factor AME lower upper id
keep factor AME lower upper id
save team96, replace 

foreach x of numlist 1/96 {
erase t96m`x'.dta
}

erase ISSP960616_appended1.dta
erase ISSP06recode.dta
erase ISSP9606.dta
erase ISSP96recode.dta

  }
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*































// TEAM 97
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team97.dta"
  if _rc==0   {
    display "Team 97 already exists, skipping to next code chunk"
  }
  else {
use "dat_expansion.dta", clear

destring cntry, replace
destring year, replace

egen obs_waves=nvals(year), by(cntry)
drop if cntry==643
keep if obs_waves==3

*PI adjustment
replace netmigpct2 = netmigpct2/10
//

// Preferred models indicated by team	
// Models including Trust and Efficacy, (building from net migration models):
eststo clear

		
eststo m3v1: gologit2 jobs_ord ///
			netmigpct2 socx2 ///
			i.female c.age##c.age i.education i.employment i.self_employment rel_income ///
			i.trust_cs i.trust_pol i.efficacy /// 
			i.cntry i.year 
			
eststo m3v2: gologit2 unempl_ord ///
			netmigpct2 socx2 ///
			i.female c.age##c.age i.education i.employment i.self_employment rel_income ///
			i.trust_cs i.trust_pol i.efficacy ///
			i.cntry i.year

eststo m3v3: gologit2 income_ord ///
			netmigpct2 socx2 ///
			i.female c.age##c.age i.education i.employment i.self_employment rel_income ///
			i.trust_cs i.trust_pol i.efficacy ///
			i.cntry i.year
			
eststo m3v4: gologit2 old_ord ///
			netmigpct2 socx2 ///
			i.female c.age##c.age i.education i.employment i.self_employment rel_income ///
			i.trust_cs i.trust_pol i.efficacy ///
			i.cntry i.year
			
eststo m3v5: gologit2 hous_ord ///
			netmigpct2 socx2 ///
			i.female c.age##c.age i.education i.employment i.self_employment rel_income ///
			i.trust_cs i.trust_pol i.efficacy ///
			i.cntry i.year
			
eststo m3v6: gologit2 health_ord ///
			netmigpct2 socx2 ///
			i.female c.age##c.age i.education i.employment i.self_employment rel_income ///
			i.trust_cs i.trust_pol i.efficacy ///
			i.cntry i.year



	
// Models including Trust and Efficacy, (building from migration stock models):

eststo m4v1: gologit2 jobs_ord ///
			foreignpct2 socx2 ///
			i.female c.age##c.age i.education i.employment i.self_employment rel_income ///
			i.trust_cs i.trust_pol i.efficacy /// 
			i.cntry i.year 
			
eststo m4v2: gologit2 unempl_ord ///
			foreignpct2 socx2 ///
			i.female c.age##c.age i.education i.employment i.self_employment rel_income ///
			i.trust_cs i.trust_pol i.efficacy ///
			i.cntry i.year

eststo m4v3: gologit2 income_ord ///
			foreignpct2 socx2 ///
			i.female c.age##c.age i.education i.employment i.self_employment rel_income ///
			i.trust_cs i.trust_pol i.efficacy ///
			i.cntry i.year
			
eststo m4v4: gologit2 old_ord ///
			foreignpct2 socx2 ///
			i.female c.age##c.age i.education i.employment i.self_employment rel_income ///
			i.trust_cs i.trust_pol i.efficacy ///
			i.cntry i.year
			
eststo m4v5: gologit2 hous_ord ///
			foreignpct2 socx2 ///
			i.female c.age##c.age i.education i.employment i.self_employment rel_income ///
			i.trust_cs i.trust_pol i.efficacy ///
			i.cntry i.year
			
eststo m4v6: gologit2 health_ord ///
			foreignpct2 socx2 ///
			i.female c.age##c.age i.education i.employment  rel_income ///
			i.trust_cs i.trust_pol i.efficacy ///
			i.cntry i.year

local i = 7
foreach num of numlist 1/6 {
est restore m3v`num'
margins, dydx(netmigpct2) saving("t97m`i'",replace)
local i = `i'+1
}

local i = 1
foreach num of numlist 1/6 {
est restore m4v`num'
margins, dydx(foreignpct2) saving("t97m`i'",replace)
local i = `i'+1
}

use t97m1.dta, clear
foreach i of numlist 2/12 {
append using t97m`i'
}

gen id = [_n]
gen id2 = id-24
replace id = id2 if id>24

recode id (1/4 =1)(5/8 =2) ///
(9/12 =3)(13/16 =4) ///
(17/20 =5)(21/24 =6), gen(dv)

recode id ///
( 1 25  = 4311)  /// 
( 2 26  = 8763) ///
( 3 27  = 12124) ///
( 4 28  = 10963) /// /* jobs */
( 5 29  = 2719)   ///
( 6 30  = 8000)  ///
( 7 31  = 16954) ///
( 8 32  = 8179) /// /* unemp */
( 9 33  = 3451)  ///
(10 34  = 7045) ///
(11 35  = 11736) ///
(12 36  = 13680) /// /* incdif */
(13 37  = 277)  /// 
(14 38  = 1476)  ///
(15 39  = 12978) ///
(16 40  = 22082) /// /* old */
(17 41  = 1558)  ///
(18 42  = 5981)  ///
(19 43  = 17805) ///
(20 44  = 10584) /// /* house */
(21 45  = 374)   /// 
(22 46  = 1405)  ///
(23 47  = 11444) ///
(24 48  = 23857) /// /* health */
, gen(pop)

recode id (1 25  = 36161)(5 29 = 35852) (9 33 = 35921) ///
(13 37 = 36831)(17 41 = 35928)(21 45 = 37080)(*=.), gen(tpop)

recode id ///
( 1 25  = 1) /// 
( 2 26  = 2) ///
( 3 27  = 3) ///
( 4 28  = 4) /// /* jobs */
( 5 29  = 1) ///
( 6 30  = 2) ///
( 7 31  = 3) ///
( 8 32  = 4) /// /* unemp */
( 9 33  = 1) ///
(10 34  = 2) ///
(11 35  = 3) ///
(12 36  = 4) /// /* incdif */
(13 37  = 1) /// 
(14 38  = 2) ///
(15 39  = 3) ///
(16 40  = 4) /// /* old */
(17 41  = 1) ///
(18 42  = 2) ///
(19 43  = 3) ///
(20 44  = 4) /// /* house */
(21 45  = 1) /// 
(22 46  = 2) ///
(23 47  = 3) ///
(24 48  = 4) /// /* health */
, gen(score)

gen mean = ((score*pop)+(score[_n+1]*pop[_n+1]) ///
+(score[_n+2]*pop[_n+2])+(score[_n+3]*pop[_n+3]))/tpop

gen margmean = ( ///
score*(pop+(pop*_margin)) + ///
score[_n+1]*(pop[_n+1]+(pop[_n+1]*_margin[_n+1])) + ///
score[_n+2]*(pop[_n+2]+(pop[_n+2]*_margin[_n+2])) + ///
score[_n+3]*(pop[_n+3]+(pop[_n+3]*_margin[_n+3])) ///
)/tpop

gen margmean_lb = ( ///
score*(pop+(pop*(_ci_lb))) + ///
score[_n+1]*(pop[_n+1]+(pop[_n+1]*(_ci_lb[_n+1]))) + ///
score[_n+2]*(pop[_n+2]+(pop[_n+2]*(_ci_lb[_n+2]))) + ///
score[_n+3]*(pop[_n+3]+(pop[_n+3]*(_ci_lb[_n+3]))) ///
)/tpop

gen margmean_ub = ( ///
score*(pop+(pop*(_ci_ub))) + ///
score[_n+1]*(pop[_n+1]+(pop[_n+1]*(_ci_ub[_n+1]))) + ///
score[_n+2]*(pop[_n+2]+(pop[_n+2]*(_ci_ub[_n+2]))) + ///
score[_n+3]*(pop[_n+3]+(pop[_n+3]*(_ci_ub[_n+3]))) ///
)/tpop

gen AME = margmean - mean
gen lower = margmean_lb - mean
gen upper = margmean_ub - mean
drop if AME == .
gen factor = .
gen n = [_n]
drop id
gen id = "t97m1"
foreach n of numlist 2/12 {
replace id = "t97m`n'" if `n'==n
}
order factor AME lower upper id
keep factor AME lower upper id
save "team97.dta", replace

foreach n of numlist 1/12 {
erase "t97m`n'.dta"
}

 }
*==============================================================================*
*==============================================================================*
*==============================================================================*






























// TEAM 101
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

capture confirm file "team101.dta"
  if _rc==0   {
    display "Team 101 already exists, skipping to next code chunk"
  }
  else {




**L2data
use "L2data.dta", clear

gen id=0
replace id=1 if country== "Australia"
replace id=2 if country== "Canada"
replace id=4 if country== "France"
replace id=5 if country== "Germany"
replace id=8 if country== "Isreal"
replace id=9 if country== "Japan"
replace id=11 if country== "New Zealand"
replace id=12 if country== "Norway"
replace id=16 if country== "Spain"
replace id=17 if country== "Sweden"
replace id=18 if country== "Switzerland"
replace id=19 if country== "United Kingdom"
replace id=20 if country== "United States"

recode id (0=.)(1=1 "Australia")(2=2 "Canada")(4=4 "France")(5=5 "Germany") ///
(8=8 "Isreal")(9=9 "Japan")(11=11 "New Zealand")(12=12 "Norway") ///
(16=16 "Spain")(17=17 "Sweden")(18=18 "Switzerland")(19=19 "United Kingdom")(20=20 "United States"),gen(id2)    	

save "L2datav2.dta", replace

**ZA2900
clear
use "ZA2900.dta"

gen id=0
replace id=1 if v3== 1
replace id=2 if v3== 20
replace id=4 if v3== 27
replace id=5 if v3== 2
replace id=5 if v3== 3
replace id=8 if v3== 22
replace id=8 if v3== 23
replace id=9 if v3== 24
replace id=11 if v3== 19
replace id=12 if v3== 12
replace id=16 if v3== 25
replace id=17 if v3== 13
replace id=18 if v3== 30
replace id=19 if v3== 4
replace id=20 if v3== 6

recode id (0=.)(1=1 "Australia")(2=2 "Canada")(4=4 "France")(5=5 "Germany") ///
(8=8 "Isreal")(9=9 "Japan")(11=11 "New Zealand")(12=12 "Norway") ///
(16=16 "Spain")(17=17 "Sweden")(18=18 "Switzerland")(19=19 "United Kingdom")(20=20 "United States"),gen(id2)    	

gen year=1996

recode v36 (1=1)(2=1)(3=0)(4=0), gen(jobs)
recode v38 (1=1)(2=1)(3=0)(4=0), gen(oldage)
recode v41 (1=1)(2=1)(3=0)(4=0), gen(unemployed)
recode v42 (1=1)(2=1)(3=0)(4=0), gen(Reduceincome)
recode v200 (1=0)(2=1), gen(female)

gen age=v201
gen agesq=age*age

recode v205 (1=.)(2=1 "primary")(3=1)(4=2 "secondary")(5=2)(6=3)(7=3 "university"),gen(edu)
recode v205 (1=.)(2=8 "primary")(3=1)(4=12 "secondary")(5=12)(6=16)(7=16 "university"),gen(edu2)
recode v206 (1=1 "FT")(8=1)(4=1)(2=2 "PT")(3=2)(5=3 "active unemployed")(10=4 "not active")(9=4)(7=4)(6=3),gen(employed)  //
recode v206 (1=1 " has a job")(8=1)(4=1)(2=1)(3=1)(5=0 "has no job")(10=0)(9=0)(7=0)(6=0),gen(employed2)  //

rename v218 income

save "ZA2900v2.dta", replace

**ZA4700
clear
use "ZA4700.dta"

gen id=0
replace id=1 if V3== 36
replace id=2 if V3== 124
replace id=4 if V3== 250
replace id=5 if V3== 276.1
replace id=5 if V3== 276.2
replace id=8 if V3== 376.1
replace id=8 if V3== 376.2
replace id=9 if V3== 392
replace id=11 if V3== 554
replace id=12 if V3== 578
replace id=16 if V3== 724
replace id=17 if V3== 752
replace id=18 if V3== 756
replace id=19 if V3== 826.1
replace id=20 if V3== 840

gen year=2006

recode id (0=.)(1=1 "Australia")(2=2 "Canada")(4=4 "France")(5=5 "Germany") ///
(8=8 "Isreal")(9=9 "Japan")(11=11 "New Zealand")(12=12 "Norway") ///
(16=16 "Spain")(17=17 "Sweden")(18=18 "Switzerland")(19=19 "United Kingdom")(20=20 "United States"),gen(id2)    	

recode V25 (1=1)(2=1)(3=0)(4=0), gen(jobs)
recode V28 (1=1)(2=1)(3=0)(4=0), gen(oldage)
recode V30 (1=1)(2=1)(3=0)(4=0), gen(unemployed)
recode V31 (1=1)(2=1)(3=0)(4=0), gen(Reduceincome)

recode sex (1=0)(2=1), gen(female)

gen agesq=age*age

recode degree (0=.)(1=1 "primary")(1=1)(3=2 "secondary")(3=2)(5=3 "university"),gen(edu)
recode degree (0=.)(1=8 "primary")(1=1)(3=12 "secondary")(3=2)(5=16 "university"),gen(edu2)
recode wrkst (1=1 "FT")(8=1)(4=1)(2=2 "PT")(3=2)(5=3 "active unemployed")(10=4 "not active")(9=4)(7=4)(6=3),gen(employed)  //
recode wrkst (1=1 " has a job")(8=1)(4=1)(2=1)(3=1)(5=0 "No Job")(10=0 "has no job")(9=0)(7=0)(6=0),gen(employed2)

save "ZA4700v2.dta",replace

*******
*Merge*
*******

//1996

clear

use "ZA2900v2.dta", clear

merge m:m id2 using "L2datav2.dta", force

save "20180906_1996combine.dta", replace

//2006

clear 

*The merge was failing so PIs reversed the use and the merge files
*Starting with the ISSP data seems to fix the problem

use "ZA4700v2.dta", clear

merge m:m id2 using "L2datav2.dta"

save "20180906_2006combine.dta", replace

***EXTENSION***

clear
import delimited "cri_macro.csv"

keep gdp_oecd mcp migstock_oecd al_ethnic wdi_unempilo socx_oecd iso_country country year

keep if year==1996 | year==2006


gen id=0
replace id=1 if country== "Australia"
replace id=2 if country== "Canada"
replace id=4 if country== "France"
replace id=5 if country== "Germany"
replace id=8 if country== "Isreal"
replace id=9 if country== "Japan"
replace id=11 if country== "New Zealand"
replace id=12 if country== "Norway"
replace id=16 if country== "Spain"
replace id=17 if country== "Sweden"
replace id=18 if country== "Switzerland"
replace id=19 if country== "United Kingdom"
replace id=20 if country== "United States"

recode id (0=.)(1=1 "Australia")(2=2 "Canada")(4=4 "France")(5=5 "Germany") ///
(8=8 "Isreal")(9=9 "Japan")(11=11 "New Zealand")(12=12 "Norway") ///
(16=16 "Spain")(17=17 "Sweden")(18=18 "Switzerland")(19=19 "United Kingdom")(20=20 "United States"),gen(id2)    	

rename gdp_oecd gdp_2016
rename mcp multicultural
rename migstock_oecd percentfb
rename al_ethnic ethnicity
rename wdi_unempilo unemploymentp 

save "L2datav3.dta", replace // New Variables for research design



*******
*Merge*
*******

preserve 
use L2datav3.dta,clear
destring socx_oecd, replace force
save L2datav3.dta,replace
restore

//1996

clear

use "20180906_1996combine.dta", clear
drop _merge

*Had to adjust this command
merge m:m id2 year using "L2datav3.dta"


save "20181121_1996combine.dta", replace

//2006

clear 

use "20180906_2006combine.dta", clear
drop _merge

merge m:m id2 year using "L2datav3.dta"

save "20181121_2006combine.dta", replace


**ANALYSIS**


**************************
***Analysis***************
**************************


*********************
*********************

*1996 
clear
use "20181121_1996combine.dta"


xtset, clear 
xtset id2

*PI adjustment
replace netmigpct=netmigpct/10
//

drop if year==2006

//Jobs
//Immigrant Stock
xtlogit jobs female agesq b2.edu b1.employed gdp_2016 foreignpct ethnicity multicultural unemploymentp, or
margins,dydx(foreignpct) saving ("t101m1",replace) // 1
//Immigrant Stock and Social Welfare
qui xtlogit jobs female agesq b2.edu b1.employed foreignpct socx gdp_2016 multicultural ethnicity unemploymentp  , or
margins,dydx(foreignpct) saving ("t101m5",replace) // 5
//Immigrant Stock and Employment rate
qui xtlogit jobs female agesq b2.edu b1.employed foreignpct emprate gdp_2016 multicultural ethnicity unemploymentp  , or
margins,dydx(foreignpct) saving ("t101m9",replace) // 9
//Change in immigrant stock
qui xtlogit jobs female agesq b2.edu b1.employed netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or
margins,dydx(netmigpct) saving ("t101m13",replace) // 13
//Social welfare and change in immigrant stock
qui xtlogit jobs female agesq b2.edu b1.employed socx netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or
margins,dydx(netmigpct) saving ("t101m17",replace) // 17
//Employment rate and change in immigrant stock
qui xtlogit jobs female agesq b2.edu b1.employed emprate netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or
margins,dydx(netmigpct) saving ("t101m21",replace) // 21

//Unemployment
//Immigrant Stock
qui xtlogit unemployed female agesq b2.edu b1.employed foreignpct gdp_2016 multicultural ethnicity unemploymentp  , or
margins,dydx(foreignpct) saving ("t101m2",replace) // 2
//Immigrant Stock and Social Welfare
qui xtlogit unemployed female agesq b2.edu b1.employed foreignpct socx gdp_2016 multicultural ethnicity unemploymentp  , or
margins,dydx(foreignpct) saving ("t101m6",replace) // 6
//Immigrant Stock and Employment rate
qui xtlogit unemployed female agesq b2.edu b1.employed foreignpct emprate gdp_2016 multicultural ethnicity unemploymentp  , or
margins,dydx(foreignpct) saving ("t101m10",replace) // 10
//Change in immigrant stock
qui xtlogit unemployed female agesq b2.edu b1.employed netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or
margins,dydx(netmigpct) saving ("t101m14",replace) // 14
//Social welfare and change in immigrant stock
qui xtlogit unemployed female agesq b2.edu b1.employed socx netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or
margins,dydx(netmigpct) saving ("t101m18",replace) // 18
//Employment rate and change in immigrant stock
qui xtlogit unemployed female agesq b2.edu b1.employed emprate netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or
margins,dydx(netmigpct) saving ("t101m22",replace) // 22


//Reduceincome
//Immigrant Stock
qui xtlogit Reduceincome female agesq b2.edu b1.employed foreignpct gdp_2016 multicultural ethnicity unemploymentp  , or
margins,dydx(foreignpct) saving ("t101m3",replace) // 3
//Immigrant Stock and Social Welfare
qui xtlogit Reduceincome female agesq b2.edu b1.employed foreignpct socx gdp_2016 multicultural ethnicity unemploymentp  , or
margins,dydx(foreignpct) saving ("t101m7",replace) // 7
//Immigrant Stock and Employment rate
qui xtlogit Reduceincome female agesq b2.edu b1.employed foreignpct emprate gdp_2016 multicultural ethnicity unemploymentp  , or
margins,dydx(foreignpct) saving ("t101m11",replace) // 11
//Change in immigrant stock
qui xtlogit Reduceincome female agesq b2.edu b1.employed netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or
margins,dydx(netmigpct) saving ("t101m15",replace) // 15
//Social welfare and change in immigrant stock
qui xtlogit Reduceincome female agesq b2.edu b1.employed socx netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or
margins,dydx(netmigpct) saving ("t101m19",replace) // 19
//Employment rate and change in immigrant stock
qui xtlogit Reduceincome female agesq b2.edu b1.employed emprate netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or
margins,dydx(netmigpct) saving ("t101m23",replace)  // 23

//Oldage
//Immigrant Stock
qui xtlogit oldage female agesq b2.edu b1.employed foreignpct gdp_2016 multicultural ethnicity unemploymentp  , or
*margins,dydx(foreignpct) saving ("t101m4",replace) // 4
//Immigrant Stock and Social Welfare
qui xtlogit oldage female agesq b2.edu b1.employed foreignpct socx gdp_2016 multicultural ethnicity unemploymentp  , or
*margins,dydx(foreignpct) saving ("t101m8",replace) // 8
//Immigrant Stock and Employment rate
qui xtlogit oldage female agesq b2.edu b1.employed foreignpct emprate gdp_2016 multicultural ethnicity unemploymentp  , or
*margins,dydx(foreignpct) saving ("t101m12",replace) // 12
//Change in immigrant stock
qui xtlogit oldage female agesq b2.edu b1.employed netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or
*margins,dydx(netmigpct) saving ("t101m16",replace) //16
//Social welfare and change in immigrant stock
qui xtlogit oldage female agesq b2.edu b1.employed socx netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or
*margins,dydx(netmigpct) saving ("t101m20",replace) // 20
//Employment rate and change in immigrant stock
qui xtlogit oldage female agesq b2.edu b1.employed emprate netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or
*margins,dydx(netmigpct) saving ("t101m24",replace) // 24


*2006
clear

use "20181121_2006combine.dta",clear

drop if year==1996
xtset id2

*PI adjustment
replace netmigpct=netmigpct/10
//

//Jobs
//Immigrant Stock
xtlogit jobs female agesq b2.edu b1.employed foreignpct gdp_2016 multicultural ethnicity unemploymentp  , or
margins,dydx(foreignpct) saving ("t101m25",replace) // 25
tab id2 if e(sample)==1
//Immigrant Stock and Social Welfare
xtlogit jobs female agesq b2.edu b1.employed foreignpct socx gdp_2016 multicultural ethnicity unemploymentp  , or iterate(100)
margins,dydx(foreignpct) saving ("t101m29",replace) // 29
//Immigrant Stock and Employment rate
xtlogit jobs female agesq b2.edu b1.employed foreignpct emprate gdp_2016 multicultural ethnicity unemploymentp  , or iterate(100)
margins,dydx(foreignpct) saving ("t101m33",replace) // 33
//Change in immigrant stock
xtlogit jobs female agesq b2.edu b1.employed netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or iterate(100)
margins,dydx(netmigpct) saving ("t101m37",replace) // 37
//Social welfare and change in immigrant stock
xtlogit jobs female agesq b2.edu b1.employed socx netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or iterate(100)
margins,dydx(netmigpct) saving ("t101m41",replace) // 41
//Employment rate and change in immigrant stock
xtlogit jobs female agesq b2.edu b1.employed emprate netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or iterate(100)
margins,dydx(netmigpct) saving ("t101m45",replace) // 45


//Unemployment
//Immigrant Stock
xtlogit unemployed female agesq b2.edu b1.employed foreignpct gdp_2016 multicultural ethnicity unemploymentp  , or iterate(100)
margins,dydx(foreignpct) saving ("t101m26",replace) // 26
//Immigrant Stock and Social Welfare
xtlogit unemployed female agesq b2.edu b1.employed foreignpct socx gdp_2016 multicultural ethnicity unemploymentp  , or 
margins,dydx(foreignpct) saving ("t101m30",replace) // 30
//Immigrant Stock and Employment rate
xtlogit unemployed female agesq b2.edu b1.employed foreignpct emprate gdp_2016 multicultural ethnicity unemploymentp  , or iterate(100)
margins,dydx(foreignpct) saving ("t101m34",replace) // 34
//Change in immigrant stock
xtlogit unemployed female agesq b2.edu b1.employed netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or iterate(100)
margins,dydx(netmigpct) saving ("t101m38",replace) // 38
//Social welfare and change in immigrant stock
xtlogit unemployed female agesq b2.edu b1.employed socx netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or iterate(100)
margins,dydx(netmigpct) saving ("t101m42",replace) // 42
//Employment rate and change in immigrant stock
xtlogit unemployed female agesq b2.edu b1.employed emprate netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or iterate(100)
margins,dydx(netmigpct) saving ("t101m46",replace) // 46


//Reduceincome
//Immigrant Stock
xtlogit Reduceincome female agesq b2.edu b1.employed foreignpct gdp_2016 multicultural ethnicity unemploymentp  , or
margins,dydx(foreignpct) saving ("t101m27",replace) // 27
//Immigrant Stock and Social Welfare
xtlogit Reduceincome female agesq b2.edu b1.employed foreignpct socx gdp_2016 multicultural ethnicity unemploymentp  , or iterate(100)
margins,dydx(foreignpct) saving ("t101m31",replace) // 31
//Immigrant Stock and Employment rate
xtlogit Reduceincome female agesq b2.edu b1.employed foreignpct emprate gdp_2016 multicultural ethnicity unemploymentp  , or iterate(100)
margins,dydx(foreignpct) saving ("t101m35",replace) // 35
//Change in immigrant stock
xtlogit Reduceincome female agesq b2.edu b1.employed netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or iterate(100)
margins,dydx(netmigpct) saving ("t101m39",replace) // 39
//Social welfare and change in immigrant stock
xtlogit Reduceincome female agesq b2.edu b1.employed socx netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or  iterate(100)
margins,dydx(netmigpct) saving ("t101m43",replace) // 43
//Employment rate and change in immigrant stock
xtlogit Reduceincome female agesq b2.edu b1.employed emprate netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or iterate(100)
margins,dydx(netmigpct) saving ("t101m47",replace) // 47

//Oldage
//Immigrant Stock
xtlogit oldage female agesq b2.edu b1.employed foreignpct gdp_2016 multicultural ethnicity unemploymentp  , or iterate(100)
margins,dydx(foreignpct) saving ("t101m28",replace) // 28
//Immigrant Stock and Social Welfare
xtlogit oldage female agesq b2.edu b1.employed foreignpct socx gdp_2016 multicultural ethnicity unemploymentp  , or iterate(100)
margins,dydx(foreignpct) saving ("t101m32",replace) // 32
//Immigrant Stock and Employment rate
xtlogit oldage female agesq b2.edu b1.employed foreignpct emprate gdp_2016 multicultural ethnicity unemploymentp  , or iterate(16)
margins,dydx(foreignpct) saving ("t101m36",replace) // 36
//Change in immigrant stock
xtlogit oldage female agesq b2.edu b1.employed netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or iterate(100)
margins,dydx(netmigpct) saving ("t101m40",replace) // 40
//Social welfare and change in immigrant stock
xtlogit oldage female agesq b2.edu b1.employed socx netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or iterate(100)
margins,dydx(netmigpct) saving ("t101m44",replace) // 44
//Employment rate and change in immigrant stock
xtlogit oldage female agesq b2.edu b1.employed emprate netmigpct gdp_2016 multicultural ethnicity unemploymentp  , or iterate(100)
margins,dydx(netmigpct) saving ("t101m48",replace) // 48


use t101m1,clear
foreach x of numlist 2/48 {
append using t101m`x'
}

gen f=[_n]
gen factor = "Stock"
replace factor = "Flow, 1-year" if f>12&f<25|f>36

gen id ="t101m1"
foreach x of numlist 2/48 {
replace id = "t101m`x'" if f==`x'
}

clonevar AME = _margin
clonevar lower = _ci_lb
clonevar upper = _ci_ub
order factor AME lower upper id
keep factor AME lower upper id
save team101, replace 

foreach i of numlist 1/48 {
erase t101m`i'.dta
}
erase 20181121_1996combine.dta
erase 20181121_2006combine.dta
erase 20180906_1996combine.dta
erase 20180906_2006combine.dta
erase ZA4700v2.dta
erase ZA2900v2.dta
erase L2datav3.dta

}

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*
























// Combine results
*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*

*==============================================================================*
*==============================================================================*
*==============================================================================*
version 15

// AMEs
use team0.dta, clear
foreach t of numlist 2/101 {
capture append using team`t'.dta, force
}
drop factor
gen error = upper-AME
order AME error lower upper id
save stata_ame.dta, replace


