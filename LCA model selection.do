clear 

cd "yourpath\KCYPS2010 m1[STATA]"

use "PT_CE_KCYPS", clear

// Latent Class Analysis (LCA) to determine the optimal number of groups

// Run GSEM with a specified number of latent classes (replace "4" with your desired number of classes)
// Note: Replace "lclass(c 4)" with lclass(c X) where X is the number of classes you want to test.

gsem(povertyw1 povertyw2 povertyw3 povertyw4 povertyw5 povertyw6 <-), logit lclass(c 4) nonrtolerance

//1. AIC 2. BIC 3. ABIC 4. Entropy

// Model fit indices

// AIC (Akaike Information Criterion)
scalar AIC_class = -2*e(ll) + 2*e(rank)
di "AIC: " AIC_class

// BIC (Bayesian Information Criterion)
scalar BIC_class = -2*e(ll) + log(e(N))*e(rank)
di "BIC: " BIC_class

estat lcgof

// Adjusted BIC (ABIC)
scalar ABIC_class = -2 * e(ll) + e(rank) * ln((e(N)+2) / 24)
di "Adjusted BIC (ABIC): " ABIC_class

// Entropy
lcaentropy
di "Entropy calculated. Check output for details."


// Visualize Trajectories

/*
margins, predict(outcome(povertyw1) class(1)) predict(outcome(povertyw2) class(1)) predict(outcome(povertyw3) class(1)) predict(outcome(povertyw4) class(1)) predict(outcome(povertyw5) class(1)) predict(outcome(povertyw6) class(1))

marginsplot, noci recast(line) xtitle("") ytitle("") xlabel(1 "중1" 2 "중2" 3 "중3" 4 "고1" 5 "고2" 6 "고3") ytitle("Predicted probabilities") title("Trajectory 1") name(plot1)

margins, predict(outcome(povertyw1) class(2)) predict(outcome(povertyw2) class(2)) predict(outcome(povertyw3) class(2)) predict(outcome(povertyw4) class(2)) predict(outcome(povertyw5) class(2)) predict(outcome(povertyw6) class(2))

marginsplot, noci recast(line) xtitle("") ytitle("") xlabel(1 "중1" 2 "중2" 3 "중3" 4 "고1" 5 "고2" 6 "고3") ytitle("Predicted probabilities") title("Trajectory 2") name(plot2)

margins, predict(outcome(povertyw1) class(3)) predict(outcome(povertyw2) class(3)) predict(outcome(povertyw3) class(3)) predict(outcome(povertyw4) class(3)) predict(outcome(povertyw5) class(3)) predict(outcome(povertyw6) class(3))

marginsplot, noci recast(line) xtitle("") ytitle("") xlabel(1 "중1" 2 "중2" 3 "중3" 4 "고1" 5 "고2" 6 "고3") ytitle("Predicted probabilities") title("Trajectory 3") name(plot3)

margins, predict(outcome(povertyw1) class(4)) predict(outcome(povertyw2) class(4)) predict(outcome(povertyw3) class(4)) predict(outcome(povertyw4) class(4)) predict(outcome(povertyw5) class(4)) predict(outcome(povertyw6) class(4))

marginsplot, noci recast(line) xtitle("") ytitle("") xlabel(1 "중1" 2 "중2" 3 "중3" 4 "고1" 5 "고2" 6 "고3") ytitle("Predicted probabilities") title("Trajectory 4") name(plot4)

graph combine plot1 plot2 plot3 plot4, ycommon

*/


predict cpost*, classposteriorpr
egen max = rowmax(cpost*)
gen class = 1 if cpost1==max
replace class = 2 if cpost2==max
replace class = 3 if cpost3==max
replace class = 4 if cpost4==max
tabulate class

save PT_CE_KCYPS, replace

