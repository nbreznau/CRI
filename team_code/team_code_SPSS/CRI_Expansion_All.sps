  * Encoding: UTF-8.
*/
THE CROWDSOURCED REPLICATION INITIATIVE (CRI)
-
Principal Investigators:
   Nate Breznau
   Alexander Wuttke
   Eike Mark Rinke
-
-
 Expansion Phase Replication Files
 All R Using Teams
 -
 https://osf.io/bs46f/wiki/home/
  - 
 Code Compiled by 
   Nate Breznau, breznau.nate@gmail.com
   Hung Nguyen, hunghvnguyen@gmail.com 
 -
     Note: All teams have been anonymized. All code has been left in its original
     form, except the working directories have been modified, non-essential code
     removed and estimation of average marginal effects included when not present
-
     For all code to run, the user needs the following files placed in C:/data/ (or equivalent working directory)
-
Provided by the PIs
       bradyfinnigan2014countrydata.dta
       cri_macro.csv
       ZA2900.dta
       ZA4700.dta
       ZA6900_v2-0-0.dta  
-
Provided by the Teams
       t33.ISSPcnrtymergedJasper.sav             *Team 33's worked up data
.
******************************************************************************************************************************************
*Set WD

CD 'C:\data'.






*TEAM 33
*************************************************************************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************

*************************************************************************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************

*************************************************************************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************


*Does not provide code to work up the data, only models. 
*thus, we call directly on the data provided by the team. 
*The team reports that
*- Step 1: reduce the ISPP1996 and ISPP2006 datasets to have only the relevant variables, 
*- Step 2: merge those reduced files (so that we have data on each variable from both 1996 and 2006), 
*- Step 3: merge this ISPP-merged file with the country data,
*- Step 4: reduce the file to have only respondents from countries in the original manuscript we tried to replicate, named this file "ISSPcnrtymergedJasper".

GET FILE = 't33.ISSPcnrtymergedJasper.sav'.
EXECUTE.


*PIs reordered models to fit with our the logic of the meta-analysis. 
*Also added OMS commands to extract results.
*PI recoded ChangeinImmigrantStock

COMPUTE ChangeinImmigrantStock = ChangeinImmigrantStock/10.


OMS
   /select tables
   /if commands = ['Mixed'] SUBTYPES =['Parameter Estimates']
   /destination format = SAV outfile = 't33m1.sav'.
MIXED Jobs WITH ImmigrantStock SocialWelfareExpenditures EmploymentRate 
    ChangeinImmigrantStock Female Age AgeSquared Degree parttime notactive activeunemployed
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=ImmigrantStock SocialWelfareExpenditures EmploymentRate ChangeinImmigrantStock Female Age 
    AgeSquared Degree parttime notactive activeunemployed | SSTYPE(3)
  /METHOD=ML
  /PRINT=SOLUTION
  /RANDOM=INTERCEPT | SUBJECT(cntry) COVTYPE(VC).
OMSEND.

OMS
   /select tables
   /if commands = ['Mixed'] SUBTYPES =['Parameter Estimates']
   /destination format = SAV outfile = 't33m2.sav'.
MIXED Unemployed WITH ImmigrantStock SocialWelfareExpenditures EmploymentRate 
    ChangeinImmigrantStock Female Age AgeSquared Degree parttime notactive activeunemployed
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=ImmigrantStock SocialWelfareExpenditures EmploymentRate ChangeinImmigrantStock Female Age 
    AgeSquared Degree parttime notactive activeunemployed | SSTYPE(3)
  /METHOD=ML
  /PRINT=SOLUTION
  /RANDOM=INTERCEPT | SUBJECT(cntry) COVTYPE(VC).
OMSEND.

OMS
   /select tables
   /if commands = ['Mixed'] SUBTYPES =['Parameter Estimates']
   /destination format = SAV outfile = 't33m3.sav'.
MIXED ReduceIncomeDifferences WITH ImmigrantStock SocialWelfareExpenditures EmploymentRate 
    ChangeinImmigrantStock Female Age AgeSquared Degree parttime notactive activeunemployed
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=ImmigrantStock SocialWelfareExpenditures EmploymentRate ChangeinImmigrantStock Female Age 
    AgeSquared Degree parttime notactive activeunemployed | SSTYPE(3)
  /METHOD=ML
  /PRINT=SOLUTION
  /RANDOM=INTERCEPT | SUBJECT(cntry) COVTYPE(VC).
OMSEND.

OMS
   /select tables
   /if commands = ['Mixed'] SUBTYPES =['Parameter Estimates']
   /destination format = SAV outfile = 't33m4.sav'.
MIXED OldAgeCare WITH ImmigrantStock SocialWelfareExpenditures EmploymentRate 
    ChangeinImmigrantStock Female Age AgeSquared Degree parttime notactive activeunemployed
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=ImmigrantStock SocialWelfareExpenditures EmploymentRate ChangeinImmigrantStock Female Age 
    AgeSquared Degree parttime notactive activeunemployed | SSTYPE(3)
  /METHOD=ML
  /PRINT=SOLUTION
  /RANDOM=INTERCEPT | SUBJECT(cntry) COVTYPE(VC).
OMSEND.



OMS
   /select tables
   /if commands = ['Mixed'] SUBTYPES =['Parameter Estimates']
   /destination format = SAV outfile = 't33m5.sav'.
MIXED socialpolicy WITH ImmigrantStock SocialWelfareExpenditures EmploymentRate 
    ChangeinImmigrantStock Female Age AgeSquared Degree parttime notactive activeunemployed
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=ImmigrantStock SocialWelfareExpenditures EmploymentRate ChangeinImmigrantStock Female Age 
    AgeSquared Degree parttime notactive activeunemployed | SSTYPE(3)
  /METHOD=ML
  /PRINT=SOLUTION
  /RANDOM=INTERCEPT | SUBJECT(cntry) COVTYPE(VC).
OMSEND.

OMS
   /select tables
   /if commands = ['Mixed'] SUBTYPES =['Parameter Estimates']
   /destination format = SAV outfile = 't33m6.sav'.
MIXED Jobs WITH ImmigrantStock SocialWelfareExpenditures ChangeinImmigrantStock Female Age 
    AgeSquared Degree parttime notactive activeunemployed
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=ImmigrantStock SocialWelfareExpenditures ChangeinImmigrantStock Female Age AgeSquared 
    Degree parttime notactive activeunemployed | SSTYPE(3)
  /METHOD=ML
  /PRINT=SOLUTION
  /RANDOM=INTERCEPT | SUBJECT(cntry) COVTYPE(VC).
OMSEND.

OMS
   /select tables
   /if commands = ['Mixed'] SUBTYPES =['Parameter Estimates']
   /destination format = SAV outfile = 't33m7.sav'.
MIXED Unemployed WITH ImmigrantStock SocialWelfareExpenditures ChangeinImmigrantStock Female Age 
    AgeSquared Degree parttime notactive activeunemployed
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=ImmigrantStock SocialWelfareExpenditures ChangeinImmigrantStock Female Age AgeSquared 
    Degree parttime notactive activeunemployed | SSTYPE(3)
  /METHOD=ML
  /PRINT=SOLUTION
  /RANDOM=INTERCEPT | SUBJECT(cntry) COVTYPE(VC).
OMSEND.

OMS
   /select tables
   /if commands = ['Mixed'] SUBTYPES =['Parameter Estimates']
   /destination format = SAV outfile = 't33m8.sav'.
MIXED ReduceIncomeDifferences WITH ImmigrantStock SocialWelfareExpenditures ChangeinImmigrantStock Female Age 
    AgeSquared Degree parttime notactive activeunemployed
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=ImmigrantStock SocialWelfareExpenditures ChangeinImmigrantStock Female Age AgeSquared 
    Degree parttime notactive activeunemployed | SSTYPE(3)
  /METHOD=ML
  /PRINT=SOLUTION
  /RANDOM=INTERCEPT | SUBJECT(cntry) COVTYPE(VC).
OMSEND.

OMS
   /select tables
   /if commands = ['Mixed'] SUBTYPES =['Parameter Estimates']
   /destination format = SAV outfile = 't33m9.sav'.
MIXED OldAgeCare WITH ImmigrantStock SocialWelfareExpenditures ChangeinImmigrantStock Female Age 
    AgeSquared Degree parttime notactive activeunemployed
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=ImmigrantStock SocialWelfareExpenditures ChangeinImmigrantStock Female Age AgeSquared 
    Degree parttime notactive activeunemployed | SSTYPE(3)
  /METHOD=ML
  /PRINT=SOLUTION
  /RANDOM=INTERCEPT | SUBJECT(cntry) COVTYPE(VC).
OMSEND.

OMS
   /select tables
   /if commands = ['Mixed'] SUBTYPES =['Parameter Estimates']
   /destination format = SAV outfile = 't33m10.sav'.
MIXED socialpolicy WITH ImmigrantStock SocialWelfareExpenditures ChangeinImmigrantStock Female Age 
    AgeSquared Degree parttime notactive activeunemployed
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=ImmigrantStock SocialWelfareExpenditures ChangeinImmigrantStock Female Age AgeSquared 
    Degree parttime notactive activeunemployed | SSTYPE(3)
  /METHOD=ML
  /PRINT=SOLUTION
  /RANDOM=INTERCEPT | SUBJECT(cntry) COVTYPE(VC).
OMSEND.

*Bind together results.
GET FILE = 't33m1.sav'.
SELECT IF (Var1 = "ImmigrantStock" OR Var1 = "ChangeinImmigrantStock").
COMPUTE AME = TRUNC(Estimate, 0.00001).
COMPUTE lower = TRUNC(LowerBound, 0.00001).
COMPUTE upper = TRUNC(UpperBound, 0.00001).
STRING id (A6).
COMPUTE id = 't33m1'.
COMPUTE sort = 1.
IF Var1 = 'ChangeinImmigrantStock' id = 't33m11'.
IF Var1 = 'ChangeinImmigrantStock' sort = 11.
SAVE OUTFILE 't33m1.sav'
  /KEEP = AME lower upper id sort.
EXECUTE.

GET FILE = 't33m2.sav'.
SELECT IF (Var1 = "ImmigrantStock" OR Var1 = "ChangeinImmigrantStock").
COMPUTE AME = TRUNC(Estimate, 0.00001).
COMPUTE lower = TRUNC(LowerBound, 0.00001).
COMPUTE upper = TRUNC(UpperBound, 0.00001).
STRING id (A6).
COMPUTE id = 't33m2'.
COMPUTE sort = 2.
IF Var1 = 'ChangeinImmigrantStock' id = 't33m12'.
IF Var1 = 'ChangeinImmigrantStock' sort = 12.
SAVE OUTFILE 't33m2.sav'
  /KEEP = AME lower upper id sort.
EXECUTE.

GET FILE = 't33m3.sav'.
SELECT IF (Var1 = "ImmigrantStock" OR Var1 = "ChangeinImmigrantStock").
COMPUTE AME = TRUNC(Estimate, 0.00001).
COMPUTE lower = TRUNC(LowerBound, 0.00001).
COMPUTE upper = TRUNC(UpperBound, 0.00001).
STRING id (A6).
COMPUTE id = 't33m3'.
COMPUTE sort = 3.
IF Var1 = 'ChangeinImmigrantStock' id = 't33m13'.
IF Var1 = 'ChangeinImmigrantStock' sort = 13.
SAVE OUTFILE 't33m3.sav'
  /KEEP = AME lower upper id sort.
EXECUTE.

GET FILE = 't33m4.sav'.
SELECT IF (Var1 = "ImmigrantStock" OR Var1 = "ChangeinImmigrantStock").
COMPUTE AME = TRUNC(Estimate, 0.00001).
COMPUTE lower = TRUNC(LowerBound, 0.00001).
COMPUTE upper = TRUNC(UpperBound, 0.00001).
STRING id (A6).
COMPUTE id = 't33m4'.
COMPUTE sort = 4.
IF Var1 = 'ChangeinImmigrantStock' id = 't33m14'.
IF Var1 = 'ChangeinImmigrantStock' sort = 14.
SAVE OUTFILE 't33m4.sav'
  /KEEP = AME lower upper id sort.
EXECUTE.

GET FILE = 't33m5.sav'.
SELECT IF (Var1 = "ImmigrantStock" OR Var1 = "ChangeinImmigrantStock").
COMPUTE AME = TRUNC(Estimate, 0.00001).
COMPUTE lower = TRUNC(LowerBound, 0.00001).
COMPUTE upper = TRUNC(UpperBound, 0.00001).
STRING id (A6).
COMPUTE id = 't33m5'.
COMPUTE sort = 5.
IF Var1 = 'ChangeinImmigrantStock' id = 't33m15'.
IF Var1 = 'ChangeinImmigrantStock' sort = 15.
SAVE OUTFILE 't33m5.sav'
  /KEEP = AME lower upper id sort.
EXECUTE.

GET FILE = 't33m6.sav'.
SELECT IF (Var1 = "ImmigrantStock" OR Var1 = "ChangeinImmigrantStock").
COMPUTE AME = TRUNC(Estimate, 0.00001).
COMPUTE lower = TRUNC(LowerBound, 0.00001).
COMPUTE upper = TRUNC(UpperBound, 0.00001).
STRING id (A6).
COMPUTE id = 't33m6'.
COMPUTE sort = 6.
IF Var1 = 'ChangeinImmigrantStock' id = 't33m16'.
IF Var1 = 'ChangeinImmigrantStock' sort = 16.
SAVE OUTFILE 't33m6.sav'
  /KEEP = AME lower upper id sort.
EXECUTE.

GET FILE = 't33m7.sav'.
SELECT IF (Var1 = "ImmigrantStock" OR Var1 = "ChangeinImmigrantStock").
COMPUTE AME = TRUNC(Estimate, 0.00001).
COMPUTE lower = TRUNC(LowerBound, 0.00001).
COMPUTE upper = TRUNC(UpperBound, 0.00001).
STRING id (A6).
COMPUTE id = 't33m7'.
COMPUTE sort = 7.
IF Var1 = 'ChangeinImmigrantStock' id = 't33m17'.
IF Var1 = 'ChangeinImmigrantStock' sort = 17.
SAVE OUTFILE 't33m7.sav'
  /KEEP = AME lower upper id sort.
EXECUTE.

GET FILE = 't33m8.sav'.
SELECT IF (Var1 = "ImmigrantStock" OR Var1 = "ChangeinImmigrantStock").
COMPUTE AME = TRUNC(Estimate, 0.00001).
COMPUTE lower = TRUNC(LowerBound, 0.00001).
COMPUTE upper = TRUNC(UpperBound, 0.00001).
STRING id (A6).
COMPUTE id = 't33m8'.
COMPUTE sort = 8.
IF Var1 = 'ChangeinImmigrantStock' id = 't33m18'.
IF Var1 = 'ChangeinImmigrantStock' sort = 18.
SAVE OUTFILE 't33m8.sav'
  /KEEP = AME lower upper id sort.
EXECUTE.

GET FILE = 't33m9.sav'.
SELECT IF (Var1 = "ImmigrantStock" OR Var1 = "ChangeinImmigrantStock").
COMPUTE AME = TRUNC(Estimate, 0.00001).
COMPUTE lower = TRUNC(LowerBound, 0.00001).
COMPUTE upper = TRUNC(UpperBound, 0.00001).
STRING id (A6).
COMPUTE id = 't33m9'.
COMPUTE sort = 9.
IF Var1 = 'ChangeinImmigrantStock' id = 't33m19'.
IF Var1 = 'ChangeinImmigrantStock' sort = 19.
SAVE OUTFILE 't33m9.sav'
  /KEEP = AME lower upper id sort.
EXECUTE.

GET FILE = 't33m10.sav'.
SELECT IF (Var1 = "ImmigrantStock" OR Var1 = "ChangeinImmigrantStock").
COMPUTE AME = TRUNC(Estimate, 0.00001).
COMPUTE lower = TRUNC(LowerBound, 0.00001).
COMPUTE upper = TRUNC(UpperBound, 0.00001).
STRING id (A6).
COMPUTE id = 't33m10'.
COMPUTE sort = 10.
IF Var1 = 'ChangeinImmigrantStock' id = 't33m20'.
IF Var1 = 'ChangeinImmigrantStock' sort = 20.
SAVE OUTFILE 't33m10.sav'
  /KEEP = AME lower upper id sort.
EXECUTE.

GET FILE = 't33m1.sav'.
ADD FILES
  /FILE = 't33m1.sav'
  /FILE = 't33m2.sav'
  /FILE = 't33m3.sav'
  /FILE = 't33m4.sav'
  /FILE = 't33m5.sav'
  /FILE = 't33m6.sav'
  /FILE = 't33m7.sav'
  /FILE = 't33m8.sav'
  /FILE = 't33m9.sav'
  /FILE = 't33m10.sav'.
SORT CASES BY sort.
EXECUTE.

SAVE OUTFILE = 'team33.sav' /DROP sort.
EXECUTE.

SAVE TRANSLATE OUTFILE='C:\data\team33.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.

ERASE FILE = 't33m1.sav'.
ERASE FILE = 't33m2.sav'.
ERASE FILE = 't33m3.sav'.
ERASE FILE = 't33m4.sav'.
ERASE FILE = 't33m5.sav'.
ERASE FILE = 't33m6.sav'.
ERASE FILE = 't33m7.sav'.
ERASE FILE = 't33m8.sav'.
ERASE FILE = 't33m9.sav'.
ERASE FILE = 't33m10.sav'.
EXECUTE.
*************************************************************************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************

















*************************************************************************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************

*************************************************************************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************

*************************************************************************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************
*TEAM 35

*This is their replication code, this is not their expansion code, or at least not all of it. Emailed on 28.12.2019 asking for the original code.
*We use the file Mergeddata.dat that they provided for now.
* Encoding: UTF-8.
*Recoding 1996 dataset.

PRESERVE.
SET DECIMAL DOT.

GET STATA FILE = "C:\data\ZA2900.dta".

FILTER OFF.
USE ALL.
SELECT IF (v3 = 1 OR v3 = 2 OR v3 = 3 OR v3 = 4 OR v3 = 20 OR v3 = 27 OR v3 = 10 OR v3 = 24 OR v3 = 
    19 OR v3 = 12 OR v3 = 25 OR v3 = 13 OR v3 = 30 OR v3 = 6).

RECODE v3 (2 thru 3=2).
Recode v3 (1=36) (2=276) (4=826) (6=840) (10=372) (12=578) (13=752) (19=554) (20=124) (24=392) (25=724)
(27=250) (30=756) into v3a.

VALUE LABELS
v3a
36 'Australia'
276 'Germany'
826 'Great Britain'
840 'United States'
372 'Ireland'
578 'Norway'
752 'Sweden'
554 'New Zealand'
124 'Canada'
392 'Israel'
724 'Spain'
250 'France'
756 'Switzerland'.

RECODE v36 v38 v39 v41 v42 v44 (MISSING=SYSMIS) (1 thru 2=1) (3 thru 4=0) INTO jobs healthcare 
    retirement unemployment income housing.
RENAME VARIABLES (V201 = Age).

COMPUTE Age2=Age * Age.
RECODE v200 (MISSING=SYSMIS) (2=1) (1=0) INTO Female.
RECODE v205 (MISSING=SYSMIS) (1 thru 4=1) (ELSE=0) INTO Lessthansecondary.
RECODE v205 (MISSING=SYSMIS) (7=1) (ELSE=0) INTO University.
RECODE v206 (MISSING=SYSMIS) (2 thru 4=1) (ELSE=0) INTO parttime.
RECODE v206 (MISSING=SYSMIS) (5=1) (ELSE=0) INTO unemployed.
RECODE v206 (MISSING=SYSMIS) (6 thru 10=1) (ELSE=0) INTO nolabor.
RECODE v213 (1=1) (ELSE=0)  INTO selfemp.

IF  (MISSING(v206)) selfemp=$SYSMIS.

SORT CASES  BY v3.
SPLIT FILE SEPARATE BY v3.

DESCRIPTIVES VARIABLES=v218
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX.

SPLIT FILE OFF.

RENAME VARIABLES (Zv218 = relativeincome).


SAVE OUTFILE='t35 ISSP 1996 limited.sav'
  /DROP=v2 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20 v21 v22 v23 v24 v25 v26 v27 v28 v29 v30 v31 v32 v33 v34 v35 v36 v37 v38 v39 v40 v41 v42 v43 v44 v45 v46 v47 v48 v49 v50 v51 v52 v53 v54 v55 v56 v57 v58 v59 v60 v61 v62 v63 v64 v65 v66 v67 v68 v202 v203 v204 v205 v207 v208 v209 v210 v211 v214 v215 v216 v217 v219 v220 v221 v222 v223 v224 v225 v226 v227 v228 v229 v230 v231 v232 v233 v234 v235 v236 v237 v238 v239 v240 v241 v242 v243 v244 v245 v246 v247 v248 v249 v250 v251 v252 v253 v254 v255 v256 v257 v258 v259 v260 v261 v262 v263 v264 v265 v266 v267 v268 v269 v270 v271 v272 v274 v275 v276 v277 v278 v279 v280 v281 v282 v283 v284 v285 v286 v287 v288 v289 v290 v291 v292 v293 v294 v295 v296 v297 v298 v299 v300 v301 v302 v303 v304 v305 v306 v307 v308 v309 v310 v311 v312 v313 v314 v315 v316 v317 v318 v319 v320 v321 v322 v323 v324 v325
  /COMPRESSED.

*recoding 2006 dataset.

GET STATA FILE = "C:\data\ZA4700.dta".

FILTER OFF.
USE ALL.
SELECT IF (V3a = 36 OR V3a = 124 OR V3a = 250 OR V3a = 372 OR V3a = 392 OR V3a = 554 OR V3a = 578 
    OR V3a = 724 OR V3a = 752 OR V3a = 756 OR V3a = 840 OR V3a = 276 OR V3a = 826).


RECODE v25 v27 v28 v30 v31 v33 (MISSING=SYSMIS) (1 thru 2=1) (3 thru 4=0) INTO jobs healthcare 
    retirement unemployment income housing.

COMPUTE Age2=Age * Age.

RECODE sex (MISSING=SYSMIS) (2=1) (1=0) INTO Female.
RECODE degree (MISSING=SYSMIS) (0 thru 2=1) (ELSE=0) INTO Lessthansecondary.
RECODE degree (MISSING=SYSMIS) (5=1) (ELSE=0) INTO University.
RECODE wrkst (MISSING=SYSMIS) (2 thru 4=1) (ELSE=0) INTO parttime.
RECODE wrkst (MISSING=SYSMIS) (5=1) (ELSE=0) INTO unemployed.
RECODE wrkst (MISSING=SYSMIS) (6 thru 10=1) (ELSE=0) INTO nolabor.
RECODE wrktype (4=1) (ELSE=0)  INTO selfemp.
IF  (MISSING(wrkst)) selfemp=$SYSMIS.
DESCRIPTIVES VARIABLES=AU_INC CA_INC CH_INC DE_INC ES_INC FR_INC 
    GB_INC IE_INC JP_INC NO_INC NZ_INC SE_INC US_INC
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX.

IF  (SYSMIS(ZAU_INC) ~= 1) relativeincome=ZAU_INC.
IF  (SYSMIS(ZCA_INC) ~= 1) relativeincome=ZCA_INC.
IF  (SYSMIS(ZCH_INC) ~= 1) relativeincome=ZCH_INC.
IF  (SYSMIS(ZDE_INC) ~= 1) relativeincome=ZDE_INC.
IF  (SYSMIS(ZES_INC) ~= 1) relativeincome=ZES_INC.
IF  (SYSMIS(ZFR_INC) ~= 1) relativeincome=ZFR_INC.
IF  (SYSMIS(ZGB_INC) ~= 1) relativeincome=ZGB_INC.
IF  (SYSMIS(ZIE_INC) ~= 1) relativeincome=ZIE_INC.
IF  (SYSMIS(ZJP_INC) ~= 1) relativeincome=ZJP_INC.
IF  (SYSMIS(ZNO_INC) ~= 1) relativeincome=ZNO_INC.
IF  (SYSMIS(ZNZ_INC) ~= 1) relativeincome=ZNZ_INC.
IF  (SYSMIS(ZSE_INC) ~= 1) relativeincome=ZSE_INC.
IF  (SYSMIS(ZUS_INC) ~= 1) relativeincome=ZUS_INC.

SAVE OUTFILE='t35 ISSP 2006 limited.sav'
  /DROP=version V2 V3 V4 V5 V6 V7 V8 V9 V10 V11 V12 V13 V14 V15 V16 V17 V18 V19 V20 V21 V22 V23 V24 V25 V26 V27 V28 V29 V30 V31 V32 V33 V34 V35 V36 V37 V38 V39 V40 V41 V42 V43 V44 V45 V46 V47 V48 V49 V50 V51 V52 V53 V54 V55 V56 V57 V58 V59 V60 V61 V62 V63 marital cohab educyrs AU_DEGR CA_DEGR CH_DEGR CL_DEGR CZ_DEGR DE_DEGR DK_DEGR DO_DEGR ES_DEGR FI_DEGR FR_DEGR GB_DEGR HR_DEGR HU_DEGR IE_DEGR IL_DEGR JP_DEGR KR_DEGR LV_DEGR NL_DEGR NO_DEGR NZ_DEGR PH_DEGR PL_DEGR PT_DEGR RU_DEGR SE_DEGR SI_DEGR TW_DEGR US_DEGR UY_DEGR VE_DEGR ZA_DEGR wrkhrs ISCO88 wrksup nemploy union spwrkst SPISCO88 spwrktyp AU_RINC CA_RINC CH_RINC CL_RINC CZ_RINC DE_RINC DK_RINC DO_RINC ES_RINC FI_RINC FR_RINC GB_RINC HR_RINC HU_RINC IE_RINC IL_RINC JP_RINC KR_RINC LV_RINC NL_RINC NO_RINC NZ_RINC PH_RINC PL_RINC PT_RINC RU_RINC SE_RINC SI_RINC TW_RINC US_RINC UY_RINC VE_RINC ZA_RINC AU_INC CA_INC CH_INC CL_INC CZ_INC DE_INC DK_INC DO_INC ES_INC FI_INC FR_INC GB_INC HR_INC HU_INC IE_INC IL_INC JP_INC KR_INC LV_INC NL_INC NO_INC NZ_INC PH_INC PL_INC PT_INC RU_INC SE_INC SI_INC TW_INC US_INC UY_INC VE_INC ZA_INC hhcycle PARTY_LR AU_PRTY CA_PRTY CH_PRTY CL_PRTY CZ_PRTY DE_PRTY DK_PRTY DO_PRTY ES_PRTY FI_PRTY FR_PRTY GB_PRTY HR_PRTY HU_PRTY IE_PRTY IL_PRTY JP_PRTY KR_PRTY LV_PRTY NL_PRTY NO_PRTY NZ_PRTY PH_PRTY PL_PRTY PT_PRTY RU_PRTY SE_PRTY SI_PRTY TW_PRTY US_PRTY UY_PRTY VE_PRTY ZA_PRTY VOTE_LE relig religgrp attend topbot AU_REG CA_REG CH_REG CL_REG CZ_REG DE_REG DK_REG DO_REG ES_REG FI_REG FR_REG GB_REG HR_REG HU_REG IE_REG IL_REG JP_REG KR_REG LV_REG NL_REG NO_REG NZ_REG PH_REG PL_REG PT_REG RU_REG SE_REG SI_REG TW_REG US_REG UY_REG VE_REG ZA_REG AU_SIZE CA_SIZE CH_SIZE CL_SIZE CZ_SIZE DE_SIZE DK_SIZE DO_SIZE ES_SIZE FI_SIZE FR_SIZE GB_SIZE HR_SIZE HU_SIZE IE_SIZE IL_SIZE JP_SIZE KR_SIZE LV_SIZE NL_SIZE NO_SIZE NZ_SIZE PH_SIZE PL_SIZE PT_SIZE RU_SIZE SE_SIZE SI_SIZE TW_SIZE US_SIZE UY_SIZE VE_SIZE ZA_SIZE urbrural ethnic mode
  /COMPRESSED.

*merging datasets.

GET FILE='t35 ISSP 1996 limited.sav'.
ADD FILES
    /FILE='t35 ISSP 2006 limited.sav'.


*contextual data.

IF  (V1 = 2900 AND V3a = 36) foreign=21.3.
IF  (V1 = 4700 AND V3a = 36) foreign=21.3.
IF  (V1 = 2900 AND V3a = 124) foreign=17.2.
IF  (V1 = 4700 AND V3a = 124) foreign=19.5.
IF  (V1 = 2900 AND V3a = 250) foreign=10.5.
IF  (V1 = 4700 AND V3a = 250) foreign=10.6.
IF  (V1 = 2900 AND V3a = 276) foreign=11.
IF  (V1 = 4700 AND V3a = 276) foreign=12.9.
IF  (V1 = 2900 AND V3a = 372) foreign=7.3.
IF  (V1 = 4700 AND V3a = 372) foreign=14.8.
IF  (V1 = 2900 AND V3a = 392) foreign=1.086.
IF  (V1 = 4700 AND V3a = 392) foreign=1.564.
IF  (V1 = 2900 AND V3a = 554) foreign=16.2.
IF  (V1 = 4700 AND V3a = 554) foreign=20.7.
IF  (V1 = 2900 AND V3a = 578) foreign=5.4.
IF  (V1 = 4700 AND V3a = 578) foreign=8.
IF  (V1 = 2900 AND V3a = 724) foreign=2.6.
IF  (V1 = 4700 AND V3a = 724) foreign=10.6.
IF  (V1 = 2900 AND V3a = 752) foreign=10.3.
IF  (V1 = 4700 AND V3a = 752) foreign=12.3.
IF  (V1 = 2900 AND V3a = 756) foreign=20.9.
IF  (V1 = 4700 AND V3a = 756) foreign=22.3.
IF  (V1 = 2900 AND V3a = 826) foreign=7.2.
IF  (V1 = 4700 AND V3a = 826) foreign=9.7.
IF  (V1 = 2900 AND V3a = 840) foreign=10.7.
IF  (V1 = 4700 AND V3a = 840) foreign=13.3.

IF  (V1 = 2900 AND V3a = 36) netmigration=1.294909.
IF  (V1 = 4700 AND V3a = 36) netmigration=3.144091.
IF  (V1 = 2900 AND V3a = 124) netmigration=2.189593.
IF  (V1 = 4700 AND V3a = 124) netmigration=3.334562.
IF  (V1 = 2900 AND V3a = 250) netmigration=0.4139686.
IF  (V1 = 4700 AND V3a = 250) netmigration=1.249477.
IF  (V1 = 2900 AND V3a = 276) netmigration=3.244507.
IF  (V1 = 4700 AND V3a = 276) netmigration=1.127769.
IF  (V1 = 2900 AND V3a = 372) netmigration=-0.0345817.
IF  (V1 = 4700 AND V3a = 372) netmigration=5.522926.
IF  (V1 = 2900 AND V3a = 392) netmigration=0.3772075.
IF  (V1 = 4700 AND V3a = 392) netmigration=0.0641849.
IF  (V1 = 2900 AND V3a = 554) netmigration=3.883378.
IF  (V1 = 4700 AND V3a = 554) netmigration=2.480079.
IF  (V1 = 2900 AND V3a = 578) netmigration=0.9734175.
IF  (V1 = 4700 AND V3a = 578) netmigration=1.825211.
IF  (V1 = 2900 AND V3a = 724) netmigration=0.8216873.
IF  (V1 = 4700 AND V3a = 724) netmigration=5.769343.
IF  (V1 = 2900 AND V3a = 752) netmigration=1.707225.
IF  (V1 = 4700 AND V3a = 752) netmigration=2.063754.
IF  (V1 = 2900 AND V3a = 756) netmigration=3.222483.
IF  (V1 = 4700 AND V3a = 756) netmigration=2.690054.
IF  (V1 = 2900 AND V3a = 826) netmigration=0.2884381.
IF  (V1 = 4700 AND V3a = 826) netmigration=1.573429.
IF  (V1 = 2900 AND V3a = 840) netmigration=2.465555.
IF  (V1 = 4700 AND V3a = 840) netmigration=1.919101.

IF  (V1 = 2900 AND V3a = 36) socexpen=16.6.
IF  (V1 = 4700 AND V3a = 36) socexpen=17.1.
IF  (V1 = 2900 AND V3a = 124) socexpen=18.
IF  (V1 = 4700 AND V3a = 124) socexpen=16.4.
IF  (V1 = 2900 AND V3a = 250) socexpen=28.8.
IF  (V1 = 4700 AND V3a = 250) socexpen=29.1.
IF  (V1 = 2900 AND V3a = 276) socexpen=27.
IF  (V1 = 4700 AND V3a = 276) socexpen=26.7.
IF  (V1 = 2900 AND V3a = 372) socexpen=14.7.
IF  (V1 = 4700 AND V3a = 372) socexpen=16.7.
IF  (V1 = 2900 AND V3a = 392) socexpen=14.5.
IF  (V1 = 4700 AND V3a = 392) socexpen=18.5.
IF  (V1 = 2900 AND V3a = 554) socexpen=18.9.
IF  (V1 = 4700 AND V3a = 554) socexpen=18.5.
IF  (V1 = 2900 AND V3a = 578) socexpen=22.5.
IF  (V1 = 4700 AND V3a = 578) socexpen=21.6.
IF  (V1 = 2900 AND V3a = 724) socexpen=21.3.
IF  (V1 = 4700 AND V3a = 724) socexpen=21.2.
IF  (V1 = 2900 AND V3a = 752) socexpen=31.6.
IF  (V1 = 4700 AND V3a = 752) socexpen=29.4.
IF  (V1 = 2900 AND V3a = 756) socexpen=18.
IF  (V1 = 4700 AND V3a = 756) socexpen=20.2.
IF  (V1 = 2900 AND V3a = 826) socexpen=19.9.
IF  (V1 = 4700 AND V3a = 826) socexpen=21.2.
IF  (V1 = 2900 AND V3a = 840) socexpen=15.1.
IF  (V1 = 4700 AND V3a = 840) socexpen=15.9.

IF  (V1 = 2900 AND V3a = 36) employ=68.38308.
IF  (V1 = 4700 AND V3a = 36) employ=72.97336.
IF  (V1 = 2900 AND V3a = 124) employ=66.95101.
IF  (V1 = 4700 AND V3a = 124) employ=72.6968.
IF  (V1 = 2900 AND V3a = 250) employ=58.16968.
IF  (V1 = 4700 AND V3a = 250) employ=61.84714.
IF  (V1 = 2900 AND V3a = 276) employ=64.15186.
IF  (V1 = 4700 AND V3a = 276) employ=67.40676.
IF  (V1 = 2900 AND V3a = 372) employ=56.061.
IF  (V1 = 4700 AND V3a = 372) employ=69.33929.
IF  (V1 = 2900 AND V3a = 392) employ=74.41402.
IF  (V1 = 4700 AND V3a = 392) employ=76.22028.
IF  (V1 = 2900 AND V3a = 554) employ=71.75603.
IF  (V1 = 4700 AND V3a = 554) employ=76.01437.
IF  (V1 = 2900 AND V3a = 578) employ=74.37257.
IF  (V1 = 4700 AND V3a = 578) employ=76.38436.
IF  (V1 = 2900 AND V3a = 724) employ=47.5752.
IF  (V1 = 4700 AND V3a = 724) employ=64.84596.
IF  (V1 = 2900 AND V3a = 752) employ=70.34079.
IF  (V1 = 4700 AND V3a = 752) employ=72.93346.
IF  (V1 = 2900 AND V3a = 756) employ=82.60143.
IF  (V1 = 4700 AND V3a = 756) employ=84.54134.
IF  (V1 = 2900 AND V3a = 826) employ=68.31567.
IF  (V1 = 4700 AND V3a = 826) employ=70.2231.
IF  (V1 = 2900 AND V3a = 840) employ=71.77013.
IF  (V1 = 4700 AND V3a = 840) employ=71.92974.

*dummies country and time.

RECODE V1 (4700=1) (MISSING=SYSMIS) (ELSE=0) INTO dummie2006.
RECODE V3a (MISSING=SYSMIS) (36=1) (ELSE=0) INTO Australia.
RECODE V3a (MISSING=SYSMIS) (124=1) (ELSE=0) INTO Canada.
RECODE V3a (MISSING=SYSMIS) (250=1) (ELSE=0) INTO France.
RECODE V3a (MISSING=SYSMIS) (276=1) (ELSE=0) INTO Germany.
RECODE V3a (MISSING=SYSMIS) (372=1) (ELSE=0) INTO Ireland.
RECODE V3a (MISSING=SYSMIS) (392=1) (ELSE=0) INTO Japan.
RECODE V3a (MISSING=SYSMIS) (554=1) (ELSE=0) INTO NewZealand.
RECODE V3a (MISSING=SYSMIS) (578=1) (ELSE=0) INTO Norway.
RECODE V3a (MISSING=SYSMIS) (724=1) (ELSE=0) INTO Spain.
RECODE V3a (MISSING=SYSMIS) (752=1) (ELSE=0) INTO Sweden.
RECODE V3a (MISSING=SYSMIS) (756=1) (ELSE=0) INTO Switzerland.
RECODE V3a (MISSING=SYSMIS) (826=1) (ELSE=0) INTO UnitedKingdom.
RECODE V3a (MISSING=SYSMIS) (840=1) (ELSE=0) INTO UnitedStates.

SAVE OUTFILE='t35 ISSP merged.sav'
  /COMPRESSED.
EXECUTE.


*Output for Mplus

*Team has not yet submitted code to produce the file "mergeddata.dat", PI's renamed it to "t35.mergeddata.dat"

ERASE FILE = 't35 ISSP merged.sav'.
ERASE FILE = 't35 ISSP 2006 limited.sav'.
ERASE FILE = 't35 ISSP 1996 limited.sav'.
EXECUTE.

*************************************************************************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************










*TEAM 41
*************************************************************************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************

*************************************************************************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************

*************************************************************************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************

*Code not provided, analysis done in Mplus
*We import their Mplus results in the CRI_Expansion_All.R file 


*************************************************************************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************







*************************************************************************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************

*************************************************************************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************

*************************************************************************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************
*TEAM 70

*Works up data, analysis done in Mplus.

* Encoding: UTF-8.
GET STATA FILE = 'ZA2900.dta'.
EXECUTE.

*OldAgeCare

compute OldAgeCare_96=-999.
if (v39=1) OldAgeCare_96=4.
if (v39=2) OldAgeCare_96=3.
if (v39=3) OldAgeCare_96=2.
if (v39=4) OldAgeCare_96=1.
missing values OldAgeCare_96 (-999).
variable labels OldAgeCare_96 'OldAgeCare - ...provide a decent standard of living for the old'.

fre v39 OldAgeCare_96.


*Unemployed

compute Unemployed_96=-999.
if (v41=1) Unemployed_96=4.
if (v41=2) Unemployed_96=3.
if (v41=3) Unemployed_96=2.
if (v41=4) Unemployed_96=1.
missing values Unemployed_96 (-999).
variable labels Unemployed_96 'Unemployed -  ... reduce income differences between the rich and the poor'.
fre v41 Unemployed_96.


*ReduceIncomeDifferences

compute ReduceIncomeDifferences_96=-999.
if (v42=1) ReduceIncomeDifferences_96=4.
if (v42=2) ReduceIncomeDifferences_96=3.
if (v42=3) ReduceIncomeDifferences_96=2.
if (v42=4) ReduceIncomeDifferences_96=1.
missing values ReduceIncomeDifferences_96 (-999).
variable labels ReduceIncomeDifferences_96 'ReduceIncomeDifferences -  ... reduce income differences between the rich and the poor'.
fre v42 ReduceIncomeDifferences_96.

*Jobs

compute Jobs_96=-999.
if (v36=1) Jobs_96=4.
if (v36=2) Jobs_96=3.
if (v36=3) Jobs_96=2.
if (v36=4) Jobs_96=1.
missing values Jobs_96 (-999).
variable labels Jobs_96 'Jobs -  ... reduce income differences between the rich and the poor'.
fre v36 Jobs_96.


*Control variables

fre v200 v201 v205 v206.

compute Female_96=-999.
if (v200=1) Female_96=0.
if (v200=2) Female_96=1.
missing values Female_96 (-999).
variable labels Female_96 'Female/Sex'.
fre v200 Female_96.

compute age_96=v201.
missing values age_96 (-999).
variable labels age_96 'Age'.
fre age_96 v201.

compute age_sq_96=age_96*age_96.
missing values age_sq_96 (-999).
variable labels age_sq_96 'Age squared'.
fre age_96 age_sq_96.

compute education_96=-999.
if (v205 LE 4) education_96=0.
if (v205 GE 5 and v205 LT 99) education_96=1.
if (v205 = 99) education_96=-999.
missing values education_96 (-999).
variable labels education_96 'Education categories - high education >= secondary completed'.
fre v205 education_96.

compute employment_96=-999.
if (v206=1) employment_96=1.
if (v206 GE 2 and v206 LT 99) employment_96=0.
if (v206 = 99) employment_96=-999.
missing values employment_96 (-999).
variable labels employment_96 'Employment categories - full time employed'.
fre v206 employment_96.

***Create simplified dataset only with relevant variables

SAVE OUTFILE='t70.ZA2900_short.sav'
  /Keep OldAgeCare_96 Unemployed_96 ReduceIncomeDifferences_96 Jobs_96 
Female_96 age_96 age_sq_96 education_96 employment_96 v3
  /COMPRESSED.

GET FILE = 't70.ZA2900_short.sav'.
EXECUTE.
***Preparation merging


compute cntry=-999.
if (v3=1) cntry=36.
if (v3=2) cntry=276.
if (v3=3) cntry=276.
if (v3=4) cntry=826.
if (v3=6) cntry=840.
if (v3=8) cntry=348.
if (v3=22) cntry=376.
if (v3=23) cntry=376.
if (v3=10) cntry=372.
if (v3=11) cntry=528.
if (v3=12) cntry=578.
if (v3=13) cntry=752.
if (v3=14) cntry=203.
if (v3=15) cntry=705.
if (v3=16) cntry=616.
if (v3=18) cntry=643.
if (v3=19) cntry=554.
if (v3=20) cntry=124.
if (v3=24) cntry=392.
if (v3=25) cntry=724.
if (v3=26) cntry=428.
if (v3=27) cntry=250.
if (v3=30) cntry=756.

missing values cntry (-999).
variable labels cntry 'country according to country file'.
formats cntry(f3.0).
DATASET NAME dat1.
EXECUTE.

GET STATA FILE = 'bradyfinnigan2014countrydata.dta'.
USE ALL.
SELECT IF year = 1996.
compute netmigpct  = netmigpct/5.
DATASET NAME dat2.
EXECUTE.

***Merge.


DATASET ACTIVATE dat1.
sort cases by cntry.
EXECUTE.

MATCH FILES /FILE=*
  /TABLE='dat2'
  /BY cntry.
EXECUTE.

recode age_96 (sysmis=-999).
missing values age_96 (-999).

recode age_sq_96 (sysmis=-999).
missing values age_sq_96 (-999).

recode emprate foreignpct socx netmigpct (sysmis=-999).
missing values emprate foreignpct socx netmigpct (-999).

***Export relevant variables to .dat-file

SET DECIMAL=DOT.
SAVE TRANSLATE /OUTFILE='96.dat'
    /TYPE=TAB /MAP /REPLACE
    /KEEP   OldAgeCare_96 Unemployed_96 ReduceIncomeDifferences_96 Jobs_96
Female_96 age_96 age_sq_96 education_96 employment_96 
cntry emprate foreignpct socx netmigpct.
DATASET CLOSE dat1.
EXECUTE.

ERASE FILE = 't70.ZA2900_short.sav'.

**************************************************************************************************************************************

* Encoding: UTF-8.
***Compute dependent variables ZA4700

DATASET CLOSE ALL.
GET STATA FILE = 'ZA4700.dta'.
EXECUTE.

*OldAgeCare

compute OldAgeCare_06=-999.
if (v28=1) OldAgeCare_06=4.
if (v28=2) OldAgeCare_06=3.
if (v28=3) OldAgeCare_06=2.
if (v28=4) OldAgeCare_06=1.
missing values OldAgeCare_06 (-999).
variable labels OldAgeCare_06 'OldAgeCare - ...provide a decent standard of living for the old'.

*Unemployed

compute Unemployed_06=-999.
if (v30=1) Unemployed_06=4.
if (v30=2) Unemployed_06=3.
if (v30=3) Unemployed_06=2.
if (v30=4) Unemployed_06=1.
missing values Unemployed_06 (-999).
variable labels Unemployed_06 'Unemployed -  ... reduce income differences between the rich and the poor'.

*ReduceIncomeDifferences

compute ReduceIncomeDifferences_06=-999.
if (v31=1) ReduceIncomeDifferences_06=4.
if (v31=2) ReduceIncomeDifferences_06=3.
if (v31=3) ReduceIncomeDifferences_06=2.
if (v31=4) ReduceIncomeDifferences_06=1.
missing values ReduceIncomeDifferences_06 (-999).
variable labels ReduceIncomeDifferences_06 'ReduceIncomeDifferences -  ... reduce income differences between the rich and the poor'.

*Jobs
compute Jobs_06=-999.
if (v25=1) Jobs_06=4.
if (v25=2) Jobs_06=3.
if (v25=3) Jobs_06=2.
if (v25=4) Jobs_06=1.
missing values Jobs_06 (-999).
variable labels Jobs_06 'Jobs -  ... reduce income differences between the rich and the poor'.
if sysmis(Jobs_06) Jobs_06 = -999.


*Control variables
compute Female_06=-999.
if (sex=1) Female_06=0.
if (sex=2) Female_06=1.
missing values Female_06 (-999).
variable labels Female_06 'Female/Sex'.

compute age_06=age.
missing values age_06 (-999).
variable labels age_06 'Age'.

compute age_sq_06=age_06*age_06.
missing values age_sq_06 (-999).
variable labels age_sq_06 'Age squared'.

compute education_06=-999.
if (degree LE 2) education_06=0.
if (degree GE 3 and degree LT 8) education_06=1.
if (degree GE 8) education_06=-999.
missing values education_06 (-999).
variable labels education_06 'Education categories - high education >= higher secondary completed'.

compute employment_06=-999.
if (wrkst=1) employment_06=1.
if (wrkst GE 2 and wrkst LT 96) employment_06=0.
if (wrkst GE 97) employment_06=-999.
missing values employment_06 (-999).
variable labels employment_06 'Employment categories - full time employed'.

***Create simplified dataset only with relevant variables

SAVE OUTFILE='t70.ZA4700_short.sav'
  /Keep OldAgeCare_06 Unemployed_06 ReduceIncomeDifferences_06 Jobs_06 
Female_06 age_06 age_sq_06 education_06 employment_06 v3
  /COMPRESSED.

compute cntry=v3.
APPLY DICTIONARY from *
  /SOURCE VARIABLES = v3
  /TARGET VARIABLES = cntry.
variable label cntry 'Country according to country file'.
fre v3 cntry.

***merge

sort cases by cntry. 
DATASET NAME dat3.
EXECUTE.

GET STATA FILE = 'bradyfinnigan2014countrydata.dta'.
USE ALL.
SELECT IF year EQ 2006.
compute netmigpct = netmigpct/5.
DATASET NAME dat2.
EXECUTE.

***Merge.

DATASET ACTIVATE dat3.
sort cases by cntry.
EXECUTE.

MATCH FILES /FILE=*
  /TABLE='dat2'
  /BY cntry.
EXECUTE.

recode age_06 (sysmis=-999).
missing values age_06 (-999).

recode age_sq_06 (sysmis=-999).
missing values age_sq_06 (-999).

recode emprate foreignpct socx netmigpct (sysmis=-999).
missing values emprate foreignpct socx netmigpct (-999).

***Export relevant variables to .dat-file

SET DECIMAL=DOT.
SAVE TRANSLATE OUTFILE='06.dat'
    /TYPE=TAB /MAP /REPLACE
    /KEEP   OldAgeCare_06 Unemployed_06 ReduceIncomeDifferences_06 Jobs_06
Female_06 age_06 age_sq_06 education_06 employment_06 
cntry emprate foreignpct socx netmigpct.
EXECUTE.

ERASE FILE = 't70.ZA4700_short.sav'.







*************************************************************************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************

*************************************************************************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************

*************************************************************************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************
*TEAM 77


* Encoding: UTF-8.
** Preparation data set for CRI Extension        ** . 
** JvdN Nov 7 - 2018                                      ** . 

** Import data from stata . 
DATASET CLOSE ALL.
GET STATA FILE='ZA6900_v2-0-0.dta'.
EXECUTE.
** DROP COUNTRIES . 
RECODE country 
(36=1)
(56=1)
(152=1)
(203=1)
(208=1)
(246=1)
(250=1)
(276=1)
(348=1)
(352=1)
(376=1)
(392=1)
(410=1)
(428=1)
(440=1)
(578=1)
(703=1)
(705=1)
(724=1)
(752=1)
(756=1)
(792=1)
(826=1)
(840=1)
(ELSE = 0), into include . 
EXECUTE . 
SELECT IF include = 1 . 
FREQUENCIES country . 

*** INDIVIDUAL LEVEL VARIABLES *** . 
RENAME VARIABLES 
v21 = jobs
v23 = healthcare
v24 = retirement
v26 = unemployment
v27 = income_diff
v29 = housing . 


** AGE -- differs for Denmark -- NEED TO ADJUST . 
** Denmark used categories; therefore recoded age to match Denmark . 
FREQUENCIES AGE DK_AGE . 
MISSING VALUES age (0, 999) .
MISSING VALUES DK_age (0) . 
COMPUTE age_cat = DK_AGE . 
FREQUENCIES age_cat . 
IF (age LE 25) age_cat  = 22 . 
IF (age GE 26 AND age LE 35) age_cat = 31 . 
IF (age GE 36 AND age LE 45) age_cat = 41 . 
IF (age GE 46 AND age LE 55) age_cat = 51 . 
IF (age GE 56 AND age LE 65) age_cat = 61 . 
IF (age GE 66) age_cat = 70 .
FREQUENCIES age_cat age . 
RECODE age_cat (22 =1)(31=2)(41=3)(51=4)(61=5)(70=6), INTO agecat . 
VALUE LABELS agecat 
1 'up to 25yrs'
2 '26-35 yrs'
3 '36-45 yrs'
4 '46-55 yrs'
5 '56-65 yrs'
6 '66 yrs and older' . 
if sysmis (agecat) agecat = -99.
missing values agecat (-99).
FREQUENCIES agecat .  

** Gender . 
RECODE SEX (1=0) (2=1) (9=-9), into female . 
VALUE LABELS female 1 'female' 0 'male' -9 'no answer' .
recode female (-9 = -99).
MISSING VALUES female (-99) .
crosstabs female by sex. 
frequencies female.
** Family status . 

** treat "civil partnership" as "married" and separated (but still legally married/in civil partnership)" as "divorced" . 
RECODE marital (1 2 = 0) (6 = 1), into fs_nvrmarried .
RECODE marital (1 2 = 0) (3 4 = 1), into fs_divorced .
RECODE marital (1 2 = 0) (5 = 1), into fs_widowed .

CROSSTABS marital by fs_nvrmarried . 
CROSSTABS marital by fs_divorced . 
CROSSTABS marital by fs_widowed . 
if sysmis (fs_nvrmarried) fs_nvrmarried = -99.
if sysmis (fs_divorced) fs_divorced = -99.
if sysmis (fs_widowed) fs_widowed = -99.
missing values fs_nvrmarried fs_divorced fs_widowed (-99).
frequencies fs_nvrmarried fs_divorced fs_widowed.
** Household size .  
* "not a private household" = missing value .  
RECODE HOMPOP (14 THRU 27 = 13) (ELSE = COPY), into HH_size . 
VALUE LABELS HH_size 13 '13 persons or more' 0 'not a private household'.
recode HH_size (99 = -99). 
MISSING VALUES HH_size (-99) . 
FREQUENCIES HH_size. 

FREQUENCIES HHCHILDR HHTODD . 
MISSING VALUES HHCHILDR HHTODD (96, 99) . 
COMPUTE HH_child = -99 . 
IF (HHCHILDR = 0) AND (HHTODD = 0) HH_child = 0 . 
IF (HHCHILDR GE 1) OR (HHTODD GE 1) HH_child = 1 . 
CROSSTABS HHCHILDR BY HHTODD . 
MISSING VALUES HH_child (-99) . 
FREQUENCIES HH_child . 
** Urbanization . 

FREQUENCIES urbrural .
RECODE urbrural (1 = 0) (2 3 = 1), into suburb . 
RECODE urbrural (1 = 0) (4 5 = 1), into rural . 
CROSSTABS urbrural BY suburb . 
CROSSTABS urbrural BY rural . 

if sysmis (suburb) suburb = -99.
if sysmis (rural) rural = -99.
missing values suburb rural (-99).
FREQUENCIES suburb rural.

** Education .
** I counted "lower secondary" as ""less than secondary", mainly because of the group sizes.
FREQUENCIES degree . 
recode degree (0=1) (1=1) (2=1)(9=SYSMIS) (ELSE=0) into edu_lesssec.
recode degree (3=1) (9=SYSMIS) (ELSE=0) into edu_sec.
recode degree (4=1) (5=1)(6=1) (9=SYSMIS) (ELSE=0) into edu_highersec. 

if sysmis (edu_lesssec) edu_lesssec = -99.
if sysmis (edu_sec) edu_sec = -99.
if sysmis (edu_highersec) edu_highersec = -99.
missing values edu_lesssec edu_sec edu_highersec (-99).
frequencies edu_lesssec edu_sec edu_highersec.


** Labor market status // employment . 
FREQUENCIES MAINSTAT . 
MISSING VALUES MAINSTAT (99) . 
RECODE MAINSTAT (1=1) (2 3 4 5 6 7 8 = 0), into d_work . 
CROSSTABS MAINSTAT BY d_work . 
if sysmis (d_work) d_work = -99.
missing values d_work (-99).
frequencies d_work.
** relativev income . 

MISSING VALUES
BE_INC CH_INC CL_INC CZ_INC DE_INC
ES_INC FI_INC FR_INC GB_INC
HU_INC IL_INC IS_INC LT_INC
LV_INC SE_INC SI_INC SK_INC
TR_INC US_INC (999990 THRU HIGHEST) . 
MISSING VALUES 
AU_INC CL_INC DK_INC IS_INC
NO_INC (9999990 THRU HIGHEST) . 
MISSING VALUES
JP_INC (99999990 THRU HIGHEST) . 
MISSING VALUES
KR_INC (999999990 THRU HIGHEST) . 

FREQUENCIES AU_INC BE_INC CH_INC CL_INC CZ_INC DE_INC DK_INC
ES_INC FI_INC FR_INC GB_INC HU_INC IL_INC IS_INC JP_INC
KR_INC LT_INC LV_INC NO_INC SE_INC SI_INC SK_INC TR_INC US_INC  .  

** Standardize income per country . 
DESCRIPTIVES AU_INC BE_INC CH_INC CL_INC CZ_INC DE_INC DK_INC
ES_INC FI_INC FR_INC GB_INC HU_INC IL_INC IS_INC JP_INC
KR_INC LT_INC LV_INC NO_INC SE_INC SI_INC SK_INC TR_INC US_INC 
/SAVE . 

** combine into one variable. 
COMPUTE relinc = SUM(ZAU_INC TO ZUS_INC) . 
VARIABLE LABELS relinc 'standardized income per country' . 
if sysmis(relinc) relinc = -99.
missing values relinc (-99).
frequencies relinc.
EXECUTE . 

** DROP VARIABLES . 
DELETE VARIABLES studyno version doi c_sample c_alphan
v1 to v20 v22 v25 v28 v30 to v63 SEX to ZA_REG 
SUBSCASE DATEYR DATEMO DATEDY MODE 
include age_cat ZAU_INC to ZUS_INC . 

SAVE OUTFILE = 'ISSP2016_reduced.sav' . 

*** ADD COUNTRY VARS . 
** % foreign born	. 
RECODE country 
(36=28.48535426)
(56=11.09635185)
(152=2.674438894)
(203=4.004006505)
(208=10.9649635)
(246=5.982078695)
(250=12.22333359)
(276=13.66166471)
(348=5.021128573)
(352=12.16189421)
(376=24.26203954)
(392=1.78261324)
(410=2.259347532)
(428=13.24789411)
(440=4.476974227)
(578=14.70646911)
(703=3.327468536)
(705=11.61071469)
(724=12.76343865)
(752=17.02393128)
(756=29.30723371)
(792=5.662161016)
(826=13.11062346)
(840=15.20036966), INTO pct_frnb . 

** 10yr change . 
RECODE country
(36=3.88442351)
(56=2.359582628)
(152=0.885167939)
(203=0.732207311)
(208=2.631586894)
(246=2.133880757)
(250=1.13726132)
(276=2.02568732)
(348=1.232407428)
(352=3.057375527)
(376=-3.88422867)
(392=0.19580271)
(410=1.090847106)
(428=-3.09683253)
(440=-1.365610569)
(578=6.313169568)
(703=0.852405583)
(705=1.22316318)
(724=2.61854287)
(752=4.21155495)
(756=4.51688779)
(792=3.729895552)
(826=2.84421368)
(840=1.69561897), INTO change_10yr . 

** mignet .
RECODE country 
(36=8)
(56=4.7)
(152=0.9)
(203=1.1)
(208=3.8)
(246=3)
(250=1.1)
(276=4.4)
(348=0.6)
(352=-1.3)
(376=0.5)
(392=0.6)
(410=0.7)
(428=-8.1)
(440=-9.7)
(578=8.8)
(703=0.4)
(705=1.6)
(724=-2.4)
(752=5.3)
(756=9.8)
(792=4.3)
(826=3.1)
(840=2.9), INTO mignet . 

** social welfare expenditures .
RECODE country 
(36=19.1)
(56=29)
(152=11.2)
(203=19.4)
(208=28.7)
(246=30.8)
(250=31.5)
(276=25.3)
(348=20.6)
(352=15.2)
(376=16.1)
(392=23.1)
(410=10.4)
(428=14.5)
(440= -99)
(578=25.1)
(703=18.6)
(705=22.8)
(724=24.6)
(752=27.1)
(756=19.7)
(792=13.5)
(826=21.5)
(840=19.3), INTO swf_ex . 

** socdem .
RECODE country 
(36=0)
(56=0)
(152=-99)
(203=-99)
(208=1)
(246=1)
(250=0)
(276=0)
(348=-99)
(352=-99)
(376=-99)
(392=0)
(410=-99)
(428=-99)
(440=-99)
(578=1)
(703=-99)
(705=-99)
(724=0)
(752=1)
(756=0)
(792=-99)
(826=0)
(840=0) , INTO reg_socdem .

** liberal . 
RECODE country 
(36=1)
(56=0)
(152=-99)
(203=-99)
(208=0)
(246=0)
(250=0)
(276=0)
(348=-99)
(352=-99)
(376=-99)
(392=1)
(410=-99)
(428=-99)
(440=-99)
(578=0)
(703=-99)
(705=-99)
(724=0)
(752=0)
(756=0)
(792=-99)
(826=1)
(840=1) , INTO reg_liberal .

** empl_rate .
RECODE country 
(36=60.891998)
(56=49.095001)
(152=58.344002)
(203=57.001999)
(208=58.251999)
(246=53.000999)
(250=49.436001)
(276=57.669998)
(348=51.206001)
(352=71.125)
(376=60.250999)
(392=57.231998)
(410=58.610001)
(428=54.487999)
(440=53.868999)
(578=61.661999)
(703=53.493)
(705=52.258999)
(724=46.875)
(752=59.879002)
(756=65.382004)
(792=45.077999)
(826=59.622002)
(840=58.942001) , INTO empl_rate . 

compute mignet = mignet/10.
compute change_10yr = change_10yr/10.
EXECUTE .
MISSING VALUES pct_frnb
change_10yr mignet
swf_ex reg_socdem
reg_liberal empl_rate (-99) . 


***Export relevant variables to .dat-file

RENAME VARIABLES    
country = cntr
jobs = job
healthcare = health
retirement = retire
unemployment = unempl
income_diff = incom
housing = hous
agecat = age
fs_nvrmarried = nevmar
fs_divorced = divorc
fs_widowed = widow
HH_size = HHsize 
HH_child = HHkids 
edu_lesssec = eduless 
edu_sec = edusec 
edu_highersec = eduhigh 
d_work = work 
pct_frnb = pctfr 
change_10yr = ch10yr  
swf_ex = swfex 
reg_socdem = regsd 
reg_liberal = reglib 
empl_rate = emplrat.


SET DECIMAL=DOT.
SAVE TRANSLATE OUTFILE='team77.dat'
    /TYPE=TAB /MAP /REPLACE
    /KEEP cntr job health retire unempl incom hous age female nevmar 
    divorc widow HHsize HHkids suburb rural eduless edusec eduhigh 
    work relinc pctfr ch10yr mignet swfex regsd reglib emplrat.
EXECUTE.



*************************************************************************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************

*************************************************************************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************

*************************************************************************************************************************************
*************************************************************************************************************************************
*************************************************************************************************************************************
*TEAM 93



* Encoding: UTF-8.

* SPSS Version 24

*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.
* DH 2016 data set.
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.

DATASET CLOSE ALL.
get stata file="ZA6900_v2-0-0.dta".


FREQUENCIES country age sex marital hompop hhchildr urbrural degree mainstat attend v24 v26 v27 v21 v29 v23.

RENAME VARIABLES country = cntry.
RECODE sex (1 = 0) (2 = 1) (SYSMIS = -99).
FREQUENCIES age.
COMPUTE age2 = age*age.
IF (age = 0) age2 = -99.
IF (age = 999) age2 = -99.

RECODE age (0 = -99) (999 = -99) (SYSMIS = -99).
FREQUENCIES age age2.

MISSING VALUES age age2 (-99).
FREQUENCIES age age2.

CROSSTABS age BY age2.

FREQUENCIES cntry sex age age2.

* Education categorical.
FREQUENCIES degree.
COMPUTE edup = 0.
IF (degree = 0 OR degree = 1) edup = 1.
IF (degree = 9) edup = -99.
IF sysmis(degree) edup = -99.
FREQUENCIES edup.
COMPUTE edus = 0.
IF (degree = 2 OR degree = 3 OR degree = 4) edus = 1.
IF (degree = 9) edus = -99.
IF sysmis(degree) edus = -99.
FREQUENCIES edus.
COMPUTE eduh = 0.
IF (degree = 5 OR degree = 6) eduh = 1.
IF (degree = 9) eduh = -99.
IF sysmis(degree) eduh = -99.
FREQUENCIES eduh.

* Employment status categories.
FREQUENCIES mainstat emprel work wrkhrs.

COMPUTE empna = 0.
IF (mainstat = 3 OR mainstat = 4 OR mainstat = 5 OR mainstat = 6 OR mainstat = 7 OR mainstat = 8) empna = 1.
IF (mainstat = 99 OR mainstat = 9) empna = -99.
COMPUTE empau = 0.
IF (mainstat = 2) empau = 1.
IF (mainstat = 99 OR mainstat = 9) empau = -99.
COMPUTE empft = 0.
IF (mainstat = 1 AND wrkhrs > 29) empft = 1.
IF (mainstat = 99 OR mainstat = 9) empft = -99.
FREQUENCIES empna empau empft.

COMPUTE emppt = 0.
IF (mainstat = 1 AND wrkhrs < 30) emppt = 1. 
IF (mainstat = 99 OR mainstat = 9) emppt = -99.
FREQUENCIES emppt empna empau empft.

RECODE wrkhrs (98 = -99) (99 = -99) (ELSE = COPY).
MISSING VALUES wrkhrs (-99).
FREQUENCIES wrkhrs.


* categorical: unemployed, full-time, part-time.
*emppt empna empau empft

FREQUENCIES emppt empft empau empna.
IF (empau = 1) empupf = 1.
IF (emppt = 1) empupf = 2. 
IF (empft = 1) empupf = 3.
RECODE empupf (sysmis = -99).

* categorical: unemployed, full-time, part-time, rest.
IF (empau = 1) empupfr = 1.
IF (emppt = 1) empupfr = 2. 
IF (empft = 1) empupfr = 3.
IF (empna = 1) empupfr = 4.
RECODE empupfr (sysmis = -99).

FREQUENCIES empupf empupfr.

* categorical: unemployed+sick, part-time+retired, full time, rest.
IF (mainstat = 2 OR mainstat = 5) empr = 1.
FREQUENCIES empr.
IF ((mainstat = 1 AND wrkhrs < 30) OR mainstat = 6) empr = 2.
IF (empft = 1) empr = 3.
IF (mainstat = 3 OR mainstat = 4 OR mainstat = 7 OR mainstat = 8) empr = 4.
RECODE empr (sysmes = -99).
FREQUENCIES empr.

IF (mainstat = 2 OR mainstat = 5) emp = 1.
IF  ((mainstat = 1 AND wrkhrs < 30) OR mainstat = 6) emp = 2.
IF (empft = 1) emp = 3.
RECODE emp (sysmes = -99).

FREQUENCIES empupf empupfr empr emp.



* DV continous.

FREQUENCIES v24 v26 v27 v21 v29 v23.

RECODE v24 (0 = -99) (8 = -99) (9 = -99) (1 = 4) (2 = 3) (3 = 2) (4 = 1) into oldc.
RECODE v26 (0 = -99) (8 = -99) (9 = -99) (1 = 4) (2 = 3) (3 = 2) (4 = 1) into unec.
RECODE v27 (0 = -99) (8 = -99) (9 = -99) (1 = 4) (2 = 3) (3 = 2) (4 = 1) into difc.
RECODE v21 (0 = -99) (8 = -99) (9 = -99) (1 = 4) (2 = 3) (3 = 2) (4 = 1) into jobc.
RECODE v29 (0 = -99) (8 = -99) (9 = -99) (1 = 4) (2 = 3) (3 = 2) (4 = 1) into hsec.
RECODE v23 (0 = -99) (8 = -99) (9 = -99) (1 = 4) (2 = 3) (3 = 2) (4 = 1) into sckc.

FREQUENCIES oldc unec difc jobc hsec sckc.
MISSING VALUES oldc unec difc jobc hsec sckc (-99).
FREQUENCIES oldc unec difc jobc hsec sckc.
CROSSTABS v24 BY oldc.
CROSSTABS v26 BY unec.
CROSSTABS v27 BY difc.
CROSSTABS v21 BY jobc.
CROSSTABS v29 BY hsec.
CROSSTABS v23 BY sckc.

* DV binary: 1 = should be, 0 = should not be.

RECODE v24 (0 = -99) (8 = -99) (9 = -99) (1 = 1) (2 = 1) (3 = 0) (4 = 0) into old.
RECODE v26 (0 = -99) (8 = -99) (9 = -99) (1 = 1) (2 = 1) (3 = 0) (4 = 0) into une.
RECODE v27 (0 = -99) (8 = -99) (9 = -99) (1 = 1) (2 = 1) (3 = 0) (4 = 0) into dif.
RECODE v21 (0 = -99) (8 = -99) (9 = -99) (1 = 1) (2 = 1) (3 = 0) (4 = 0) into job.
RECODE v29 (0 = -99) (8 = -99) (9 = -99) (1 = 1) (2 = 1) (3 = 0) (4 = 0) into hse.
RECODE v23 (0 = -99) (8 = -99) (9 = -99) (1 = 1) (2 = 1) (3 = 0) (4 = 0) into sck.

MISSING VALUES old une dif job hse sck (-99).
FREQUENCIES old une dif job hse sck.

MISSING VALUES cntry sex age age2 edup edus eduh emppt empna empau empft wrkhrs empupf empupfr empr emp
                            oldc unec difc jobc hsec sckc old une dif job hse sck (-99).
FREQUENCIES cntry sex age age2 edup edus eduh emppt empna empau empft wrkhrs empupf empupfr empr emp
                            oldc unec difc jobc hsec sckc old une dif job hse sck .

SORT CASES by cntry.
FORMATS cntry(f3.0).

SAVE OUTFILE 'ZA6900_NTSf.sav'
    /KEEP cntry sex age age2 edup edus eduh emppt empna empau empft wrkhrs empupf empupfr empr emp
               oldc unec difc jobc hsec sckc old une dif job hse sck .

*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.
*DH 2006 data set.
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.

DATASET CLOSE ALL.
get stata file="ZA4700.dta".

FREQUENCIES v1 v2 v3 v3a sex age degree spwrkst v28 v30 v31 v25.

RENAME VARIABLES v3a = cntry.
FREQUENCIES cntry.

RECODE sex (1 = 0) (2 = 1) (SYSMIS = -99).
FREQUENCIES sex.


COMPUTE age2 = age*age.

RECODE age2 (sysmis = -99).
FREQUENCIES age2.

RECODE age (SYSMIS = -99).
FREQUENCIES age.

CROSSTABS age BY age2.

* Education categorical.
COMPUTE edup = 0.
IF (degree = 0 OR degree = 1) edup = 1.
IF (degree = 8 OR degree = 9) edup = -99.
IF sysmis(degree) edup = -99.
FREQUENCIES edup.
COMPUTE edus = 0.
IF (degree = 2 OR degree = 3) edus = 1.
IF (degree = 8 OR degree = 9) edus = -99.
IF sysmis(degree) edus = -99.
FREQUENCIES edus.
COMPUTE eduh = 0.
IF (degree = 4 OR degree = 5) eduh = 1.
IF (degree = 8 OR degree = 9) eduh = -99.
IF sysmis(degree) eduh = -99.
FREQUENCIES eduh.

* Employment status categories.
COMPUTE emppt = 0.
IF (spwrkst = 2 OR spwrkst = 3) emppt = 1.
IF sysmis(spwrkst) emppt = -99.
COMPUTE empna = 0.
IF (spwrkst = 4 OR spwrkst = 6 OR spwrkst = 7 OR spwrkst = 8 OR spwrkst = 9 OR spwrkst = 10) empna = 1.
IF sysmis(spwrkst) empna = -99.
COMPUTE empau = 0.
IF (spwrkst = 5) empau = 1.
IF sysmis(spwrkst) empau = -99.
COMPUTE empft = 0.
IF (spwrkst = 1) empft = 1.
IF sysmis(spwrkst) empft = -99.
FREQUENCIES emppt empna empau empft.

FREQUENCIES wrkhrs.
RECODE wrkhrs (SYSMIS = -99) (ELSE = COPY).
FREQUENCIES wrkhrs.


* categorical: unemployed, full-time, part-time.
*emppt empna empau empft

FREQUENCIES emppt empft empau empna.
IF (empau = 1) empupf = 1.
IF (emppt = 1) empupf = 2. 
IF (empft = 1) empupf = 3.
RECODE empupf (sysmis = -99).

* categorical: unemployed, full-time, part-time, rest.
IF (empau = 1) empupfr = 1.
IF (emppt = 1) empupfr = 2. 
IF (empft = 1) empupfr = 3.
IF (empna = 1) empupfr = 4.
RECODE empupfr (sysmis = -99).

FREQUENCIES empupf empupfr.

* categorical: unemployed+sick, part-time+retired, full time, rest.
FREQUENCIES spwrkst.
IF (spwrkst = 5 OR spwrkst = 9) empr = 1.
FREQUENCIES empr.
IF (spwrkst = 2 OR spwrkst = 3 OR spwrkst = 7) empr = 2.
IF (empft = 1) empr = 3.
IF (spwrkst = 4 OR spwrkst = 6 OR spwrkst = 8 OR spwrkst = 10) empr = 4.
RECODE empr (sysmes = -99).
FREQUENCIES empr.

IF (spwrkst = 5 OR spwrkst = 9)  emp = 1.
IF   (spwrkst = 2 OR spwrkst = 3 OR spwrkst = 7) emp = 2.
IF (empft = 1) emp = 3.
RECODE emp (sysmes = -99).

FREQUENCIES empupf empupfr empr emp.


*DV continuous.
FREQUENCIES v28 v30 v31 v25 v33 v27.

RECODE v28 (sysmis = -99) (1 = 4) (2 = 3) (3 = 2) (4 = 1) into oldc.
RECODE v30 (sysmis = -99) (1 = 4) (2 = 3) (3 = 2) (4 = 1) into unec.
RECODE v31 (sysmis = -99) (1 = 4) (2 = 3) (3 = 2) (4 = 1) into difc.
RECODE v25 (sysmis = -99) (1 = 4) (2 = 3) (3 = 2) (4 = 1) into jobc.
RECODE v33 (sysmis = -99) (1 = 4) (2 = 3) (3 = 2) (4 = 1) into hsec.
RECODE v27 (sysmis = -99) (1 = 4) (2 = 3) (3 = 2) (4 = 1) into sckc.

FREQUENCIES oldc unec difc jobc hsec sckc.
MISSING VALUES oldc unec difc jobc hsec sckc (-99).
FREQUENCIES oldc unec difc jobc hsec sckc.


*DVs categorical.
FREQUENCIES v28 v30 v31 v25 v33 v27.

COMPUTE old = 0.
IF (v28=1 OR v28 = 2) old = 1.
IF sysmis(v28) old = -99.
FREQUENCIES old.


COMPUTE une = 0.
IF (v30=1 OR v30 = 2) une = 1.
IF sysmis(v30) une = -99.
FREQUENCIES une.

COMPUTE dif = 0.
IF (v31=1 OR v31 = 2) dif = 1.
IF sysmis(v31) dif = -99.
FREQUENCIES dif.

COMPUTE job = 0.
IF (v25=1 OR v25 = 2) job = 1.
IF sysmis(v25) job = -99.
FREQUENCIES job.

COMPUTE hse = 0.
IF (v33 = 1 OR v33 = 2) hse = 1.
IF sysmis(v33) hse = -99.
FREQUENCIES hse.

COMPUTE sck = 0.
IF (v27 = 1 OR v27 = 2) sck = 1.
IF sysmis(v27) sck = -99.
FREQUENCIES sck.

MISSING VALUES cntry sex age age2 edup edus eduh emppt empna empau empft wrkhrs empupf empupfr empr emp
                            oldc unec difc jobc hsec sckc
                             old une dif job hse sck (-99).
FREQUENCIES cntry sex age age2 edup edus eduh emppt empna empau empft wrkhrs empupf empupfr empr emp
                        oldc unec difc jobc hsec sckc
                        old une dif job hse sck .

SORT CASES by cntry.
FORMATS cntry(f3.0).

SAVE OUTFILE 'ZA4700_NTSf.sav'
    /KEEP cntry sex age age2 edup edus eduh emppt empna empau empft wrkhrs empupf empupfr empr emp
                oldc unec difc jobc hsec sckc
               old une dif job hse sck .


*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.
* DH 1996 data set
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.

DATASET CLOSE ALL.
get stata file="ZA2900.dta".

FREQUENCIES v3 v200 v201 v205 v206 v39 v41 v42 v36.

*recode country variable.
RECODE v3 (1  = 36)   (2   = 276) (3  = 276)  (4  = 826)  (6  = 840)  (8  = 348)  (9  = -99 ) (10 = 372) (12 = 578) (13 = 752) (14 = 203)
                  (15 = 705) (16 = 616) (17 =  -99) (18 = 643) (19 = 554) (20 =  124) (21 = -99) (22 = 376) (23 = 376) (24 = 392)
                  (25 = 724) (26 = 428) (27 = 250) (28 = -99)  (30 = 756) (ELSE = -99)  INTO cntry.
FREQUENCIES cntry.

FREQUENCIES v200.
RECODE v200 (1 = 0) (2 = 1) (SYSMIS = -99) INTO sex.
FREQUENCIES sex.

COMPUTE age2 = v201*v201.
RECODE age2 (sysmis = -99).
FREQUENCIES age2.

RECODE v201 (SYSMIS = -99) (ELSE = COPY) into age.
FREQUENCIES age.

CROSSTABS age BY age2.

* Education categorical.
FREQUENCIES v205.
COMPUTE edup = 0.
IF (v205 = 1 OR v205 = 2 OR v205 = 3) edup = 1.
IF (v205 = 99) edup = -99.
IF sysmis(v205) edup = -99.
FREQUENCIES edup.
COMPUTE edus = 0.
IF (v205 = 4 OR v205 =5) edus = 1.
IF (v205 = 99) edus = -99.
IF sysmis(v205) edus = -99.
FREQUENCIES edus.
COMPUTE eduh = 0.
IF (v205 = 6 OR v205 = 7) eduh = 1.
IF (v205 = 99) eduh = -99.
IF sysmis(v205) eduh = -99.
FREQUENCIES eduh.

* Employment status categories.
FREQUENCIES v206.
COMPUTE emppt = 0.
IF (v206 = 2 OR v206 = 3) emppt = 1.
IF sysmis(v206) emppt = -99.
COMPUTE empna = 0.
IF (v206 = 4 OR v206 = 6 OR v206 = 7 OR v206 = 8 OR v206 = 9 OR v206 = 10) empna = 1.
IF sysmis(v206) empna = -99.
COMPUTE empau = 0.
IF (v206 = 5) empau = 1.
IF sysmis(v206) empau = -99.
COMPUTE empft = 0.
IF (v206 = 1) empft = 1.
IF sysmis(v206) empft = -99.
FREQUENCIES emppt empna empau empft.

FREQUENCIES v215.
RECODE v215 (SYSMIS = -99) (ELSE = COPY) INTO wrkhrs.
FREQUENCIES wrkhrs.


* categorical: unemployed, full-time, part-time.
*emppt empna empau empft

FREQUENCIES emppt empft empau empna.
IF (empau = 1) empupf = 1.
IF (emppt = 1) empupf = 2. 
IF (empft = 1) empupf = 3.
RECODE empupf (sysmis = -99).

* categorical: unemployed, full-time, part-time, rest.
IF (empau = 1) empupfr = 1.
IF (emppt = 1) empupfr = 2. 
IF (empft = 1) empupfr = 3.
IF (empna = 1) empupfr = 4.
RECODE empupfr (sysmis = -99).

FREQUENCIES empupf empupfr.

* categorical: unemployed+sick, part-time+retired, full time, rest.
FREQUENCIES v206.
IF (v206 = 5 OR v206 = 9) empr = 1.
FREQUENCIES empr.
IF (v206 = 2 OR v206 = 3 OR v206 = 7) empr = 2.
IF (empft = 1) empr = 3.
IF (v206 = 4 OR v206 = 6 OR v206 = 8 OR v206 = 10) empr = 4.
RECODE empr (sysmes = -99).
FREQUENCIES empr.

IF (v206 = 5 OR v206 = 9)  emp = 1.
IF (v206 = 2 OR v206 = 3 OR v206 = 7) emp = 2.
IF (empft = 1) emp = 3.
RECODE emp (sysmes = -99).

FREQUENCIES empupf empupfr empr emp.


*DVs continous.
FREQUENCIES v39 v41 v42 v36 v44 v38.

RECODE v39 (sysmis = -99) (1 = 4) (2 = 3) (3 = 2) (4 = 1) into oldc.
RECODE v41 (sysmis = -99) (1 = 4) (2 = 3) (3 = 2) (4 = 1) into unec.
RECODE v42 (sysmis = -99) (1 = 4) (2 = 3) (3 = 2) (4 = 1) into difc.
RECODE v36 (sysmis = -99) (1 = 4) (2 = 3) (3 = 2) (4 = 1) into jobc.
RECODE v44 (sysmis = -99) (1 = 4) (2 = 3) (3 = 2) (4 = 1) into hsec.
RECODE v38 (sysmis = -99) (1 = 4) (2 = 3) (3 = 2) (4 = 1) into sckc.

FREQUENCIES oldc unec difc jobc hsec sckc.

*DVs categorical.
FREQUENCIES v39 v41 v42 v36 v44 v38.
COMPUTE old = 0.
IF (v39=1 OR v39 = 2) old = 1.
IF sysmis(v39) old = -99.
FREQUENCIES old.

COMPUTE une = 0.
IF (v41=1 OR v41 = 2) une = 1.
IF sysmis(v41) une = -99.
FREQUENCIES une.

COMPUTE dif = 0.
IF (v42=1 OR v42 = 2) dif = 1.
IF sysmis(v42) dif = -99.
FREQUENCIES dif.

COMPUTE job = 0.
IF (v36=1 OR v36 = 2) job = 1.
IF sysmis(v36) job = -99.
FREQUENCIES job.

COMPUTE hse = 0.
IF (v44 = 1 OR v44 = 2) hse = 1.
IF sysmis(v44) hse = -99.

COMPUTE sck = 0.
IF (v38 = 1 OR v38 = 2) sck = 1.
IF sysmis(v38) sck = -99.

FREQUENCIES old une dif job hse sck.

MISSING VALUES cntry sex age age2 edup edus eduh emppt empna empau empft wrkhrs empupf empupfr empr emp
                             oldc unec difc jobc hsec sckc
                             old une dif job hse sck (-99).
FREQUENCIES cntry sex age age2 edup edus eduh emppt empna empau empft wrkhrs empupf empupfr empr emp
                         oldc unec difc jobc hsec sckc
                        old une dif job hse sck .

SORT CASES by cntry.
FORMATS cntry(f3.0).

SAVE OUTFILE 'ZA2900_NTSf.sav'
    /KEEP cntry sex age age2 edup edus eduh emppt empna empau empft wrkhrs empupf empupfr empr emp 
                oldc unec difc jobc hsec sckc
               old une dif job hse sck .

*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.
* Country level data.
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.

*1996.
DATASET CLOSE ALL.
GET DATA
  /TYPE=XLSX
  /FILE='cri_macro.xlsx'
  /SHEET=name 'cri_macro'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0.
EXECUTE.
DATASET NAME DataSet1 WINDOW=FRONT.

SELECT IF year = 1996.
FREQUENCIES year iso_country.

RENAME VARIABLES iso_country = cntry.
FREQUENCIES cntry.

SORT CASES BY cntry.
FORMATS cntry(f3.0).

SAVE OUTFILE 'CRI_macro1996_NTS.sav'.


*2006.
DATASET CLOSE ALL.
GET DATA
  /TYPE=XLSX
  /FILE='cri_macro.xlsx'
  /SHEET=name 'cri_macro'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0.
EXECUTE.
DATASET NAME DataSet1 WINDOW=FRONT.

SELECT IF year = 2006.
FREQUENCIES year iso_country.

RENAME VARIABLES iso_country = cntry.
FREQUENCIES cntry year.

SORT CASES BY cntry.
FORMATS cntry(f3.0).

SAVE OUTFILE 'CRI_macro2006_NTS.sav'.



*2016.
DATASET CLOSE ALL.
GET DATA
  /TYPE=XLSX
  /FILE='cri_macro.xlsx'
  /SHEET=name 'cri_macro'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0.
EXECUTE.
DATASET NAME DataSet1 WINDOW=FRONT.

SELECT IF year = 2016.
FREQUENCIES year iso_country.

RENAME VARIABLES iso_country = cntry.
FREQUENCIES cntry year.

SORT CASES BY cntry.
FORMATS cntry(f3.0).

SAVE OUTFILE 'CRI_macro2016_NTS.sav'.

*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.
* Matching country & individual level data.
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.

*1996.
DATASET CLOSE ALL. 
GET FILE 'ZA2900_NTSf.sav'.

MATCH FILES 
     /FILE='ZA2900_NTSf.sav'
    /TABLE 'CRI_macro1996_NTS.sav'
   /BY cntry.
EXECUTE.

SAVE OUTFILE 'ZA2900-macro1996f.sav'.

GET FILE 'ZA2900-macro1996f.sav'.
* 2006.
DATASET CLOSE ALL. 
GET FILE 'ZA4700_NTSf.sav'.

MATCH FILES 
     /FILE='ZA4700_NTSf.sav'
    /TABLE 'CRI_macro2006_NTS.sav'
   /BY cntry.
EXECUTE.

SAVE OUTFILE 'ZA4700-macro2006f.sav'.


* 2016.
DATASET CLOSE ALL. 
GET FILE 'ZA6900_NTSf.sav'.

MATCH FILES 
     /FILE='ZA6900_NTSf.sav'
    /TABLE 'CRI_macro2006_NTS.sav'
   /BY cntry.
EXECUTE.

SAVE OUTFILE 'ZA6900-macro2016f.sav'.


*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.
* Merging 2016, 2006 and 1996 data.
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.

DATASET CLOSE ALL. 
GET FILE  'ZA2900-macro1996f.sav'.


ADD FILES file='ZA2900-macro1996f.sav'
      /in=ZA2900
      /file = 'ZA4700-macro2006f.sav'
      /in=ZA4700
      /file = 'ZA6900-macro2016f.sav'
      /in=ZA6900.

SORT CASES BY cntry.

FREQUENCIES ZA2900 ZA4700 ZA6900.
IF (ZA2900 = 1) version = 1996.
IF (ZA4700 = 1) version = 2006.
IF (ZA6900 = 1) version = 2016.
FREQUENCIES version.

SAVE OUTFILE 'ZA2900-ZA4700-ZA6900_pooledf.sav'.


*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.
*Select relevant 13 countreis.
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.

DATASET CLOSE ALL.
GET FILE 'ZA2900-ZA4700-ZA6900_pooledf.sav'.

CROSSTABS country BY version.
*countries with individual level data from at least two years:
* Australia
* Canada (2)
* Czech Republic
* Denmark (2)
* Finland (2)
* France
* Germany
* Hungary
* Ireland (2)
* Israel
* Japan
* South Korea (2)
* Latvia
* new Zeeland
* Norway
* Poland (2)
* Russia
* Slovenia
* South Africa (2)
* Spain
* Sweden
* Switzerland
* Taiwan (2)
* UK
* US


SORT CASES  BY version.
SPLIT FILE SEPARATE BY version.
CROSSTABS country BY migstock_un.

* country level info (socx) 1996.

* 1996                                  2006                                2016
* Australia                            Australia                           Australia
*                                                                                 Belgium
* Canada                             Canada
*                                         Chile                                Chile
*                                         Croatia                             Croatia
* Czechia                            Czechia                            Czechia
*                                         Denmark                           Denmark
*                                         Finland                             Finland
* France                              France                              France
* Germany                           Germany                          Germany
* Hungary                            Hungary                            Hungary
*                                                                                 Iceland
*                                                                                 India
* Ireland                               Ireland
*                                         Israel                                Israel
* Japan                                Japan                               Japan
*                                         South Korea                      South Korea
* Latvia                                Latvia                                Latvia
*                                                                                 Lithuania
*                                         Netherlands
* New Zealand                     New Zealand                      New Zealand
* Norway                             Norway                                  Norway
* Poland                              Poland
*                                         Portugal
* Russia                              Russia                               Russia
*                                                                                  Slovakia
* Slovenia                            Slovenia                             Slovenia
*                                         South Africa                       South Africa
* Spain                                Spain                                Spain
* Sweden                            Sweden                              Sweden
* Switzerland                       Switzerland                         Switzerland
*                                         Taiwan                               Taiwan
*                                         The Netherlands
*                                                                                   Turkey
* UK                                    UK                                    UK
* US                                    US                                    US


* select countires with info on both years.

SPLIT FILE OFF.
SELECT IF cntry = 36 OR cntry = 203 OR cntry = 250 OR cntry = 276 OR cntry = 348 OR cntry = 392 OR cntry = 428 OR cntry = 554 OR 
                 cntry = 578 OR cntry = 705 OR cntry = 724 OR cntry = 752 OR cntry = 756 OR cntry = 826 OR cntry = 840.
CROSSTABS cntry BY country.

SAVE OUTFILE 'ZA2900-ZA6900_pooled-15countriesf.sav'.


*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.
* Data preparation for Mplus.
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.

DATASET CLOSE ALL.
GET FILE 'ZA2900-ZA6900_pooled-15countriesf.sav'.

FREQUENCIES cntry pop_wb al_ethnic.
ALTER TYPE gdp_oecd gdp_wb gni_wb ginid_solt ginim_dolt gini_wb gini_wid top10_wid mcp migstock_wb
                     migstock_un migstock_oecd mignet_un dpi_tf wdi_empprilo wdi_unempilo socx_oecd pop_wb al_ethnic (f10.3).
RECODE gdp_oecd gdp_wb gni_wb ginid_solt ginim_dolt gini_wb gini_wid top10_wid mcp migstock_wb
                        migstock_un migstock_oecd mignet_un pop_wb al_ethnic dpi_tf wdi_empprilo wdi_unempilo socx_oecd (sysmis = -99) (ELSE = copy).
IF (version = 2016) year = 2016.
DESCRIPTIVES cntry sex age age2 edup edus eduh emppt empna empau empft wrkhrs oldc unec difc jobc hsec sckc
                        old une dif job hse sck gdp_oecd gdp_wb gni_wb ginid_solt ginim_dolt gini_wb gini_wid top10_wid mcp migstock_wb
                        migstock_un migstock_oecd mignet_un pop_wb al_ethnic dpi_tf wdi_empprilo wdi_unempilo socx_oecd.
CROSSTABS cntry BY gdp_oecd gdp_wb gni_wb ginid_solt ginim_dolt gini_wb gini_wid top10_wid mcp migstock_wb
                        migstock_un migstock_oecd mignet_un pop_wb al_ethnic dpi_tf wdi_empprilo wdi_unempilo socx_oecd. 
CROSSTABS year BY gdp_oecd gdp_wb gni_wb ginid_solt ginim_dolt gini_wb gini_wid top10_wid mcp migstock_wb
                        migstock_un migstock_oecd mignet_un pop_wb al_ethnic dpi_tf wdi_empprilo wdi_unempilo socx_oecd.
MISSING VALUES cntry sex age age2 edup edus eduh emppt empna empau empft wrkhrs oldc unec difc jobc hsec sckc
                        old une dif job hse sck gdp_oecd gdp_wb gni_wb ginid_solt ginim_dolt gini_wb gini_wid top10_wid mcp migstock_wb
                        migstock_un migstock_oecd mignet_un pop_wb al_ethnic dpi_tf wdi_empprilo wdi_unempilo socx_oecd (-99).
FREQUENCIES cntry sex age age2 edup edus eduh emppt empna empau empft wrkhrs oldc unec difc jobc hsec sckc
                        old une dif job hse sck gdp_oecd gdp_wb gni_wb ginid_solt ginim_dolt gini_wb gini_wid top10_wid mcp migstock_wb
                        migstock_un migstock_oecd mignet_un pop_wb al_ethnic dpi_tf wdi_empprilo wdi_unempilo socx_oecd.
CODEBOOK  cntry sex age age2 edup edus eduh emppt empna empau empft wrkhrs oldc unec difc jobc hsec sckc
                        old une dif job hse sck gdp_oecd gdp_wb gni_wb ginid_solt ginim_dolt gini_wb gini_wid top10_wid mcp migstock_wb
                        migstock_un migstock_oecd mignet_un pop_wb al_ethnic dpi_tf wdi_empprilo wdi_unempilo socx_oecd.

*reduce variables' character length for Mplus.
RENAME VARIABLES ginid_solt = ginid_s.
RENAME VARIABLES ginim_dolt = ginim_d.
RENAME VARIABLES top10_wid = top10_w.
RENAME VARIABLES migstock_wb = mstockwb.
RENAME VARIABLES migstock_un = mstockun.
RENAME VARIABLES migstock_oecd = mstockoe.
RENAME VARIABLES mignet_un = mnetun.
RENAME VARIABLES al_ethnic = aleth.
RENAME VARIABLES wdi_empprilo = wdiemp.
RENAME VARIABLES wdi_unempilo = wdiunemp. 
RENAME VARIABLES socx_oecd = socx.
FREQUENCIES ginid_s ginim_d top10_w mstockwb mstockun mstockoe mnetun aleth wdiemp wdiunemp socx.

*Compute year dummy variables.
IF (year = 1996) y1996 = 1.
IF (year = 2006) y2006 = 1.
IF (year = 2016) y2016 = 1.
IF (year NE 1996) y1996 = 0.
IF (year NE 2006) y2006 = 0.
IF (year NE 2016) y2016 = 0.
FREQUENCIES y1996 y2006 y2016.
CROSSTABS year BY y1996 y2006 y2016.


*cntry = 36 OR cntry = 203 OR cntry = 250 OR cntry = 276 OR cntry = 348 OR cntry = 392 OR cntry = 428 OR cntry = 554 OR 
                 cntry = 578 OR cntry = 705 OR cntry = 724 OR cntry = 752 OR cntry = 756 OR cntry = 826 OR cntry = 840
*Compute country dummy variables.
IF (cntry = 36) aust = 1.
IF (cntry NE 36) aust = 0.
IF (cntry = 203) cz = 1.
IF (cntry NE 203) cz = 0.
IF (cntry = 250) fr = 1.
IF (cntry NE 250) fr = 0.
IF (cntry = 276) de = 1.
IF (cntry NE 276) de = 0.
IF (cntry = 348) hu = 1.
IF (cntry NE 348) hu = 0.
IF (cntry = 392) jp = 1.
IF (cntry NE 392) jp = 0.
IF (cntry = 428) lv = 1.
IF (cntry NE 428) lv = 0.
IF (cntry = 554) nz = 1.
IF (cntry NE 554) nz = 0.
IF (cntry = 578) nw = 1.
IF (cntry NE 578) nw = 0.
IF (cntry = 705) sl = 1.
IF (cntry NE 705) sl = 0.
IF (cntry = 724) sp = 1.
IF (cntry NE 724) sp = 0.
IF (cntry = 752) sw = 1.
IF (cntry NE 752) sw = 0.
IF (cntry = 756) ch = 1.
IF (cntry NE 756) ch = 0.
IF (cntry = 826) uk = 1.
IF (cntry NE 826) uk = 0.
IF (cntry = 840) us = 1.
IF (cntry NE 840) us = 0.
FREQUENCIES aust cz fr de hu jp lv nz nw sl sp sw ch uk us.


*dividing age and age2 by 100 to reduce variance (Mplus gave an error because of the high variance of age2).
COMPUTE aged = (age/100).
COMPUTE age2d = (age2/100).
DESCRIPTIVES aged age2d.
FREQUENCIES aged age2d.
RECODE aged age2d (SYSMIS = -99).
MISSING VALUES aged age2d (-99).
FREQUENCIES age aged age2d.

FREQUENCIES cntry sex age age2 aged age2d edup edus eduh emppt empna empau empft wrkhrs empupf empupfr empr emp
                        oldc unec difc jobc hsec sckc
                        old une dif job hse sck aust cz fr de hu jp lv nz nw sl sp sw ch uk us  y1996 y2006 y2016 
                        gdp_oecd gdp_wb gni_wb ginid_s ginim_d gini_wb gini_wid top10_w mcp mstockwb mstockun mstockoe 
                        mnetun pop_wb aleth dpi_tf wdiemp wdiunemp socx.
*Change mignet.

compute mnetun = mnetun/10.
execute.
 *Create Mplus file.
SET LOCALE = 'en_us'.
SET DECIMAL DOT.
SAVE TRANSLATE
   /TYPE = CSV
   /KEEP = cntry sex age age2 aged age2d edup edus eduh emppt empna empau empft wrkhrs empupf empupfr empr emp
                 oldc unec difc jobc hsec sckc
                 old une dif job hse sck aust cz fr de hu jp lv nz nw sl sp sw ch uk us year y1996 y2006 y2016 
                 gdp_oecd gdp_wb gni_wb ginid_s ginim_d gini_wb gini_wid top10_w mcp mstockwb mstockun mstockoe 
                 mnetun pop_wb aleth dpi_tf wdiemp wdiunemp socx
   /OUTFILE = 'team93.dat'.
EXECUTE.




