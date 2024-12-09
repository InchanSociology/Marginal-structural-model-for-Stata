clear 

cd "yourpath\KCYPS2010 m1[STATA]"

use "PT_CE_KCYPS", clear

recode class (2=3) (3=2)
lab def class 1 "no" 3 "high" 2 "middle" 4 "persistent"
lab val class class

egen aver_pov = rowmean(povertyw*)

//Model 1


logit univ ib1.class AG i.edu male , robust

//reference 바꿔보기//
logit univ ib2.class AG i.edu male , robust
logit univ ib3.class AG i.edu male , robust


//Model 2
logit univ ib1.class AG i.edu male aver_sib aver_fam aver_par3 aver_job1 aver_job2 aver_job3,  robust

//reference 바꿔보기//
logit univ ib2.class AG i.edu male aver_sib aver_fam aver_par3 aver_job1 aver_job2 aver_job3,  robust
logit univ ib3.class AG i.edu male aver_sib aver_fam aver_par3 aver_job1 aver_job2 aver_job3,  robust



//Model 3
logit univ ib1.class AG i.edu male fam_str_wave1 par3_wave1 job_wave1 sib_wave1  [pw=fw6], robust

logit univ ib2.class AG i.edu male fam_str_wave1 par3_wave1 job_wave1 sib_wave1  [pw=fw6], robust
logit univ ib3.class AG i.edu male fam_str_wave1 par3_wave1 job_wave1 sib_wave1  [pw=fw6], robust


//Model 3 - Male vs Female
logit univ ib1.class AG i.edu male fam_str_wave1 par3_wave1 job_wave1 sib_wave1  [pw=fw6]if male == 0, robust
logit univ ib1.class AG i.edu male fam_str_wave1 par3_wave1 job_wave1 sib_wave1  [pw=fw6]if male == 1, robust

logit univ ib1.class AG i.edu fam_str_wave1 par3_wave1 job_wave1 sib_wave1 [pw=fw6] if male == 0, robust
logit univ ib1.class AG i.edu fam_str_wave1 par3_wave1 job_wave1 sib_wave1 [pw=fw6] if male == 1, robust


//Men subgroup // 


mlogit model3 ib1.class AG sib i.edu male fam_str_wave1 par3_wave1 job_wave1 [pw=fw7], base(0) robust ,if male == 1
mlogit model3 ib2.class AG sib i.edu male fam_str_wave1 par3_wave1 job_wave1 [pw=fw7], base(0) robust ,if male == 1

//Women subgroup // 

mlogit model3 ib1.class AG sib i.edu male fam_str_wave1 par3_wave1 job_wave1 [pw=fw7], base(0) robust ,if male == 0 
mlogit model3 ib2.class AG sib i.edu male fam_str_wave1 par3_wave1 job_wave1 [pw=fw7], base(0) robust ,if male == 0 

