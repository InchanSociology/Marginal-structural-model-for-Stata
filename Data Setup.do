clear all

cd "yourpath\KCYPS2010 m1[STATA]"

// Data Extracting

use "KCYPS2010 m1w1", clear
for num 2/7 : merge 1:1 id using "KCYPS2010 m1wX", nogen

save KCYPS_merge, replace

//Preparing 

// Recode birth year variables to handle missing values
for num 1/6 : recode brt2awX (-9=.)
for num 1/6 : recode brt2bwX (-9=.)
for num 1/6 : recode brt2cwX (-9=.)

// Recode family structure variables
for num 1/6 : recode fam1awX (-9=.)
for num 1/6 : recode fam1bwX (-9=.)
for num 1/6 : recode fam1cwX (-9=.)

// Calculate the average parental age
egen brt2 = rowmean(brt2aw1 brt2bw1) if fam1aw1 ==1 | fam1aw1 == 4
replace brt2 = (brt2aw1+brt2bw1)/2 if fam1bw1 ==1 & fam1aw1==6
replace brt2 = brt2aw1 if fam1bw1 == 2 
replace brt2 = brt2bw1 if fam1bw1 == 3 
replace brt2 = brt2cw1 if fam1bw1 == 9
gen AG=2010-brt2 // Parental age in 2010

// Recode parental education levels: 
// 1 = High school or less, 2 = Some college, 3 = Four-year college or more
recode hak2aw1 (1 = 2)
recode hak2bw1 (1 = 2)
recode hak2cw1 (1 = 2)

// Generate an education variable considering family structure
gen edu =. 
replace edu = hak2aw1 if hak2aw1 >= hak2bw1
replace edu = hak2bw1 if hak2bw1 >= hak2aw1
replace edu = hak2aw1 if fam1bw1 == 2
replace edu = hak2bw1 if fam1bw1 == 3
replace edu = hak2cw1 if fam1bw1 == 9 
recode edu (-9=.)
recode edu (2=1) (3=2) (4 5=3)


// Generate a gender variable: 0 = Female, 1 = Male

gen male=(genderw1==1)

//Time Varying Variable//

//Family structure variable: 0 = Both parents, 1 = Single parent
for num 1/6 : recode fam1bwX (-9 =.)
for num 1/6 : gen fam_strwX = 0
for num 1/6 : replace fam_strwX = 1 if fam1bwX == 1 | fam1bwX == 4 | fam1bwX == 5 | fam1bwX == 6
for num 1/6 : recode fam_strwX (0=1) (1=0)

// n-1 // 
gen fam_strprew1 = 0
gen fam_strprew2 =.
replace fam_strprew2 = fam_strw1
gen fam_strprew3 =.
replace fam_strprew3 = fam_strw2
gen fam_strprew4 =.
replace fam_strprew4 = fam_strw3
gen fam_strprew5 =.
replace fam_strprew5 = fam_strw4
gen fam_strprew6 =.
replace fam_strprew6 = fam_strw5


gen fam_str_wave1 = fam_strw1

// Parental subjective health status: 0 = Very good, 1 = Somewhat good, 2 = Poor
for num 1/6 : gen par3wX = par1wX
for num 1/6 : recode par3wX (-9=.)(4=3)
for num 1/6 : recode par3wX (1=0)(2=1)(3=2)

//n-1//
gen par3prew1 = 0
gen par3prew2 =.
replace par3prew2 = par3w1
gen par3prew3 =. 
replace par3prew3 = par3w2
gen par3prew4 =.
replace par3prew4 = par3w3
gen par3prew5 =.
replace par3prew5 = par3w4
gen par3prew6 =.
replace par3prew6 = par3w5

gen par3_wave1 = par3w1

// 0 = Employer with employees, 1 = Employer without employees, 2 = Wage earner, 3 = Unemployed

for num 1/6 : recode job5awX (-9=.)
for num 1/6 : recode job5bwX (-9=.)
for num 1/6 : recode job5cwX (-9=.)

for num 1/6 : gen father_jobwX = job5awX
for num 1/6 : replace father_jobwX = 4 if job1awX ==2
for num 1/6 : gen mother_jobwX = job5bwX
for num 1/6 : replace mother_jobwX = 4 if job1bwX ==2
for num 1/6 : gen guar_jobwX = job5cwX
for num 1/6 : replace guar_jobwX = 4 if job1cwX ==2

for num 1/6 : gen jobwX =. 
for num 1/6 : replace jobwX = father_jobwX if fam1awX ==1 | fam1awX == 4
for num 1/6 : replace jobwX = father_jobwX if fam1bwX ==1 & fam1awX==6
for num 1/6 : replace jobwX = father_jobwX if fam1bwX == 2
for num 1/6 : replace jobwX = mother_jobwX if fam1bwX == 3
for num 1/6 : replace jobwX = guar_jobwX if fam1bwX == 9

for num 1/6 : recode jobwX (4=3) (1=2) (3=1) (2=0)

//n-1//
gen jobprew1 = 0
gen jobprew2 =.
replace jobprew2 = jobw1
gen jobprew3 =.
replace jobprew3 = jobw2
gen jobprew4 =.
replace jobprew4 = jobw3
gen jobprew5 =.
replace jobprew5 = jobw4
gen jobprew6 =.
replace jobprew6 = jobw5

gen job_wave1 = jobw1

// Region of residence variable citywX - 0 Others, 1 Gyeonggi Province, 2 Metropolitan Areas, 3 Seoul

for num 1/6 : recode ara2awX (-9=.)
for num 1/6 : gen citywX = 0 if ara2awX == 31 | ara2awX == 32 | ara2awX == 33 | ara2awX == 34 |ara2awX == 35 | ara2awX == 36 | ara2awX == 37 | ara2awX == 38
for num 1/6 : replace citywX = 1 if ara2awX == 30
for num 1/6 : replace citywX = 2 if ara2awX == 20 | ara2awX == 21 | ara2awX == 22 |ara2awX == 23 | ara2awX == 24 | ara2awX == 25 | ara2awX == 26  
for num 1/6 : replace citywX = 3 if ara2awX == 10

//n-1//
gen cityprew1 = 0  
gen cityprew2 =.
replace cityprew2 = cityw1
gen cityprew3 =.
replace cityprew3 = cityw2
gen cityprew4 =.
replace cityprew4 = cityw3
gen cityprew5 =.
replace cityprew5 = cityw4
gen cityprew6 =.
replace cityprew6 = cityw5

gen city_wave1 = cityw1

// Sibling count variables

gen sib3 =.
replace sib3 = fam1e01w1 + fam1e02w1 + fam1e03w1 + fam1e04w1
replace sib3 = 3 if sib3 > 3

gen sib4 =.
replace sib4 = fam1e01w1 + fam1e02w1 + fam1e03w1 + fam1e04w1
replace sib4 = 4 if sib4 > 4

for num 1/6 : recode fam1e01wX (. = 0) (-9=0)
for num 1/6 : recode fam1e02wX (. = 0) (-9=0)
for num 1/6 : recode fam1e03wX (. = 0) (-9=0)
for num 1/6 : recode fam1e04wX (. = 0) (-9=0)

for num 1/6 : replace fam1e01wX =. if fam1dwX == .
for num 1/6 : replace fam1e02wX =. if fam1dwX == .
for num 1/6 : replace fam1e03wX =. if fam1dwX == .
for num 1/6 : replace fam1e04wX =. if fam1dwX == .

for num 1/6 : gen sibwX = fam1e01wX + fam1e02wX + fam1e03wX + fam1e04wX

// Command to limit sibling count to 3
for num 1/6 : replace sibwX = 3 if sibwX > 3


//n-1//
gen sibprew1 = 0
gen sibprew2 =.
replace sibprew2 = sibw1
gen sibprew3 =.
replace sibprew3 = sibw2
gen sibprew4 =.
replace sibprew4 = sibw3
gen sibprew5 =.
replace sibprew5 = sibw4
gen sibprew6 =.
replace sibprew6 = sibw5

gen sib_wave1 = sibw1


for num 1/6 : recode incomewX (-9 -8=.)

// Poverty variables

// Household member count calculation (assuming grandparents count as one member)
for num 1/6 : gen parent_memwX = .
for num 1/6 : replace parent_memwX = 3 if fam1awX == 1 | fam1awX == 5
for num 1/6 : replace parent_memwX = 4 if fam1awX == 4
for num 1/6 : replace parent_memwX = 2 if fam1awX == 2 | fam1awX == 3
for num 1/6 : replace parent_memwX = 3 if fam1awX == 6 & fam1bw1 == 1
for num 1/6 : replace parent_memwX = 2 if fam1awX == 6 & fam1bw1 == 9

for num 1/6 : gen fam_memwX = .
for num 1/6 : replace fam_memwX =  parent_memwX + sibwX

// poverty threshold (version 1: 120% of minimum living cost)

gen povertyw1 = 0	
replace povertyw1 = 1 if incomew1 < 1237 & fam_memw1 == 2
replace povertyw1 = 1 if incomew1 < 1600 & fam_memw1 == 3
replace povertyw1 = 1 if incomew1 < 1963 & fam_memw1 == 4
replace povertyw1 = 1 if incomew1 < 2326 & fam_memw1 == 5
replace povertyw1 = 1 if incomew1 < 2690 & fam_memw1 == 6
replace povertyw1 = 1 if incomew1 < 3053 & fam_memw1 == 7


gen povertyw2 = 0
replace povertyw2 = 1 if incomew2 < 1306 & fam_memw2 == 2
replace povertyw2 = 1 if incomew2 < 1689 & fam_memw2 == 3
replace povertyw2 = 1 if incomew2 < 2073 & fam_memw2 == 4
replace povertyw2 = 1 if incomew2 < 2456 & fam_memw2 == 5
replace povertyw2 = 1 if incomew2 < 2840 & fam_memw2 == 6
replace povertyw2 = 1 if incomew2 < 3224 & fam_memw2 == 7


gen povertyw3 = 0
replace povertyw3 = 1 if incomew3 < 1357 & fam_memw3 == 2
replace povertyw3 = 1 if incomew3 < 1755 & fam_memw3 == 3
replace povertyw3 = 1 if incomew3 < 2154 & fam_memw3 == 4
replace povertyw3 = 1 if incomew3 < 2552 & fam_memw3 == 5
replace povertyw3 = 1 if incomew3 < 2950 & fam_memw3 == 6
replace povertyw3 = 1 if incomew3 < 3348 & fam_memw3 == 7

gen povertyw4 = 0
replace povertyw4 = 1 if incomew4 < 1403 & fam_memw4 == 2
replace povertyw4 = 1 if incomew4 < 1815 & fam_memw4 == 3
replace povertyw4 = 1 if incomew4 < 2227 & fam_memw4 == 4
replace povertyw4 = 1 if incomew4 < 2639 & fam_memw4 == 5
replace povertyw4 = 1 if incomew4 < 3051 & fam_memw4 == 6
replace povertyw4 = 1 if incomew4 < 3463 & fam_memw4 == 7

gen povertyw5 = 0
replace povertyw5 = 1 if incomew5 < 1480 & fam_memw5 == 2
replace povertyw5 = 1 if incomew5 < 1914 & fam_memw5 == 3
replace povertyw5 = 1 if incomew5 < 2348 & fam_memw5 == 4
replace povertyw5 = 1 if incomew5 < 2783 & fam_memw5 == 5
replace povertyw5 = 1 if incomew5 < 3217 & fam_memw5 == 6
replace povertyw5 = 1 if incomew5 < 3651 & fam_memw5 == 7

gen povertyw6 = 0
replace povertyw6 = 1 if incomew6 < 1514 & fam_memw6 == 2
replace povertyw6 = 1 if incomew6 < 1958 & fam_memw6 == 3
replace povertyw6 = 1 if incomew6 < 2402 & fam_memw6 == 4
replace povertyw6 = 1 if incomew6 < 2847 & fam_memw6 == 5
replace povertyw6 = 1 if incomew6 < 3290 & fam_memw6 == 6
replace povertyw6 = 1 if incomew6 < 3733 & fam_memw6 == 7

//n-1//
gen povertyprew1 = 0
gen povertyprew2 =.
replace povertyprew2 = povertyw1
gen povertyprew3 =.
replace povertyprew3 = povertyw2
gen povertyprew4 =.
replace povertyprew4 = povertyw3
gen povertyprew5 =.
replace povertyprew5 = povertyw4
gen povertyprew6 =.
replace povertyprew6 = povertyw5

gen poverty_wave1 = povertyw1


///censoring dummy variabel for IPCW//////

gen censorw1 = 0
gen censorw2 = 1
replace censorw2 = 0 if survey1w2 == 1 & survey2w2 == 1
gen censorw3 = 1
replace censorw3 = 0 if survey1w3 == 1 & survey2w3 == 1
gen censorw4 = 1
replace censorw4 = 0 if survey1w4 == 1 & survey2w4 == 1
gen censorw5 = 1
replace censorw5 = 0 if survey1w5 == 1 & survey2w5 == 1
gen censorw6 = 1
replace censorw6 = 0 if survey1w6 == 1 & survey2w6 == 1

//n-1//
gen censorprew1 = 0
gen censorprew2 =.
replace censorprew2 = censorw1
gen censorprew3 =.
replace censorprew3 = censorw2
gen censorprew4 =.
replace censorprew4 = censorw3
gen censorprew5 =.
replace censorprew5 = censorw4
gen censorprew6 =.
replace censorprew6 = censorw5

reshape long survey1w survey2w genderw parentw brt2aw brt2bw brt2cw ara1aw ara2aw housew hak2aw hak2bw hak2cw job1aw job1bw job1cw job4aw job4bw job4cw job5aw job5bw job5cw incomew par1w par3w phy3aw fam1aw fam1bw fam1cw fam1dw fam1e01w fam1e02w fam1e03w fam1e04w cityw jobw povertyw par3prew jobprew cityprew povertyprew censorw censorprew fam_strw fam_strprew poverty2w sibw sibprew, i(id) j(wave)

gen entry = wave-1

//Stabilized censoring weights//

xi : logistic censorw censorprew povertyprew AG i.edu i.male par3prew i.jobprew fam_strprew sibprew
predict cpa if e(sample)
replace cpa=cpa*censorw+(1-cpa)*(1-censorw)
sort id wave
by id : replace cpa=cpa*cpa[_n-1] if _n!=1

xi :logistic censorw censorprew povertyprew AG i.edu i.male
predict cpa0 if e(sample)
replace cpa0=cpa0*censorw+(1-cpa0)*(1-censorw)
sort id wave
by id : replace cpa0=cpa0*cpa0[_n-1] if _n!=1

gen cw=1/cpa
gen csw=cpa0/cpa

///Stabilized IPTW //

xi : logistic povertyw povertyprew AG i.edu i.male i.fam_strw i.fam_strprew par3w par3prew i.jobw i.jobprew sibw sibprew
predict pa if e(sample)
replace pa=pa*povertyw+(1-pa)*(1-povertyw)
sort id wave 
by id : replace pa=pa*pa[_n-1] if _n!=1

xi :logistic povertyw povertyprew AG i.edu i.male
predict pa0 if e(sample)
replace pa0=pa0*povertyw+(1-pa0)*(1-povertyw)
sort id wave
by id : replace pa0=pa0*pa0[_n-1] if _n!=1

gen w=1/pa
gen sw=pa0/pa

gen fw = sw*csw

// censoring weight//

drop if wave == 7

sort id wave
gen fw_missing = missing(fw)
by id (fw_missing), sort : drop if fw_missing[_N]
by id (censorw), sort : drop if censorw[_N]

// Command to remove students retaking the college entrance exam
drop if xd1aw7 == 1
drop pa pa0 w sw fw

// Stabilized IPTW Calculation after removing retaking students //

logistic povertyw povertyprew AG i.edu i.male i.fam_strw i.fam_strprew par3w par3prew i.jobw i.jobprew sibw sibprew
predict pa if e(sample)
replace pa=pa*povertyw+(1-pa)*(1-povertyw)
sort id wave
by id : replace pa=pa*pa[_n-1] if _n!=1

xi :logistic povertyw povertyprew AG i.edu i.male
predict pa0 if e(sample)
replace pa0=pa0*povertyw+(1-pa0)*(1-povertyw)
sort id wave
by id : replace pa0=pa0*pa0[_n-1] if _n!=1

gen w=1/pa
gen sw=pa0/pa

gen fw = sw*csw


// Balance check: Applying treatment status prediction model using fw //

xi : logistic povertyw povertyprew AG sib3 i.edu i.male par3w i.fam_strw i.fam_strprew i.jobw i.jobprew
xi : logistic povertyw povertyprew AG sib3 i.edu i.male par3w i.fam_strw i.fam_strprew i.jobw i.jobprew [pw = fw]

drop _Ifam_strw_1 _Ifam_strpr_1 _Ijobw_1 _Ijobw_2 _Ijobw_3 _Ijobprew_1 _Ijobprew_2 _Ijobprew_3

reshape wide survey1w survey2w genderw parentw brt2aw brt2bw brt2cw ara1aw ara2aw housew hak2aw hak2bw hak2cw job1aw job1bw job1cw job4aw job4bw job4cw job5aw job5bw job5cw incomew par1w par3w phy3aw fam1aw fam1bw fam1cw fam1dw fam1e01w fam1e02w fam1e03w fam1e04w cityw jobw povertyw par3prew jobprew cityprew povertyprew censorw censorprew fam_strw fam_strprew entry pa pa0 w sw cpa cpa0 cw csw fw poverty2w sibw sibprew , i(id) j(wave)

merge 1:1 id using "C:\Users\InchanHwang\Desktop\Inchan\Sociology\연구자료\2022년 연구자료\2022 빈곤궤적 대학진학\KCYPS 2010 Main - 복사본\KCYPS2010 m1[STATA]\KCYPS2010 m1w7"
drop if _merge == 2

gen xa3a = xa3aw7
gen xb1b = xb1bw7
gen xd1a = xd1aw7
gen xb1a = xb1aw7

// Create time-varying variables by averaging across waves (Model 2)
egen aver_fam = rowmean(fam_strw*)
egen aver_par3 = rowmean(par3w*)
egen aver_sib = rowmean(sibw*)

for num 1/6 : mark jobtv0_wX if jobwX == 0
for num 1/6 : mark jobtv1_wX if jobwX == 1
for num 1/6 : mark jobtv2_wX if jobwX == 2
for num 1/6 : mark jobtv3_wX if jobwX == 3
egen aver_job0 = rowmean(jobtv0_w*)
egen aver_job1 = rowmean(jobtv1_w*)
egen aver_job2 = rowmean(jobtv2_w*)
egen aver_job3 = rowmean(jobtv3_w*)

label define xb1b 1 "2-Year College" 2 "3-Year College" 3 "4-Year College" 4 "5~6-Year Program"
label values xb1b xb1b
label values job_wave1 jobw1
label values fam_str_wave1 fam_strw1

// univ = 0: Not enrolled + some college; 1: Four-year college

gen univ = 0
replace univ = 1 if xb1b == 3 | xb1b == 4
label define univ 0 "Did not enroll in 4-year college" 1 "4-Year College"
label values univ univ


// 1% trimming for weights to reduce influence of extreme values
replace sw6 = .0360826 if sw6 < .0360826
replace sw6 =  8.228861 if sw6 >  8.228861

replace fw6 = sw6 * csw6

save PT_CE_KCYPS, replace


