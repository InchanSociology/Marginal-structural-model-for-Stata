# Replication materials for Poverty Trajectories and College Entracne

This repository contains replication materials for Inchan Hwang and Dohoon Lee. 2023. "Poverty Trajectories during Adolescence and 4-Year College Entrance." Korea Journal of Population Studies doi.org/10.31693/KJPS.2023.03.46.1.1

The empirical analysis is conducted using Stata 17. Replication material provided in this package:

1. Download of Korean Children and Youth Panel Survey 2010 (KCYPS 2010) 7th grade Cohort data via the NYPI
2. Stata Do-files for a) extracting and preparing b) LCA model selection and c) analyzing the data

Please get in touch via email if you have any questions.

## 1) Download of KCYPS 2010 via the NYPI homepage

The analysis uses data of the Korean Children and Youth Panel Survey 2010 (KCYPS 2010) 7th grade Cohort. Data access is granted by the National Youth Poicy Intitute in Korea.

- KCYPS 2010 Middle School Freshmen (7th grade), released September 29th 2017
Download from ([www.nypi.re.kr/archive/mps](https://www.nypi.re.kr/archive/mps))

### Required Data list

KCYPS2010 m1w1.dta
KCYPS2010 m1w2.dta
KCYPS2010 m1w3.dta
KCYPS2010 m1w4.dta
KCYPS2010 m1w5.dta
KCYPS2010 m1w6.dta
KCYPS2010 m1w7.dta

## 2) Stata Do-files for extracting and preparing

For replication of the empirical analyses, 3 Stata Do-files are provided.

### a) Data Setup.do

- reads each .dta file into Stata;
- renames and creates variables for analysis;
- saves the data set as Stata 14 file named "PTandCE_KCYPS.dta"

### b) LCA Model Selection.do

This script performs latent class analysis (LCA) to identify distinct poverty trajectory groups:

#### Fit LCA Models
- Uses `gsem` with the `lclass` option to test models with 2, 3, 4, or 5 classes.
- Replace `lclass(c 4)` with your desired number of classes.

#### Evaluate Model Fit
- Calculates key fit indices (**AIC**, **BIC**, **Adjusted BIC**, and **Entropy**) to determine the best class solution.
- it requires to install `lcaentropy` for entropy calculation

#### Visualize Trajectories
- Predicts probabilities for each class over six waves (e.g., grades 7 to 12).
- Generates individual class trajectory plots and combines them into a single graph.

#### Assign Classes
- Classifies individuals into the most likely class using posterior probabilities.
- Saves the final dataset with assigned classes.

## 3) Stata Do-files for results

#### Steps:
- **Model 1**:  
  - Predicts university enrollment (`univ`) based on poverty trajectory (`class`), controlling for time-constant variables(age, parental education, and gender).

- **Model 2**:  
  - Extends Model 1 by adding average time-varying from wave 1 to wave 6:
    - **Sibling count** (`aver_sib`), **family structure** (`aver_fam`), **parental health** (`aver_par3`), and **job types** (`aver_job1`, `aver_job2`, `aver_job3`).

- **Model 3**:  
  - Implements a **Marginal Structural Model (MSM)** using stabilized weights (`fw6`).
  - Includes wave-specific variables:
    - **Family structure** (`fam_str_wave1`), **parental health** (`par3_wave1`), **job types** (`job_wave1`), and **sibling count** (`sib_wave1`).
  
- Conducts subgroup analysis for males (`male == 1`) and females (`male == 0`).
