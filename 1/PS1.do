clear all
set more off
cd "D:\My Drive\Sciences Po\Fall2025\Econometrics III\PS"
* Parameters
local n = 1000
local reps = 1000

* Store results
matrix results = J(`reps', 2, .)

forvalues r = 1/`reps' {
    clear
    set obs `n'

    * Generate uniform(0,1)
    gen y = runiform()

    * MM estimator: 2 * mean(y)
    quietly summarize y
    local thetaMM = 2 * r(mean)

    * ML estimator: max(y)
    summarize y, meanonly
    local thetaML = r(max)

    * Save into matrix
    matrix results[`r',1] = `thetaMM'
    matrix results[`r',2] = `thetaML'
}

* Put results into dataset
clear
svmat results

* Rename variables
rename results1 thetaMM
rename results2 thetaML

* Summary statistics
summarize thetaMM thetaML

* Save summary statistics to LaTeX
estpost summarize thetaMM thetaML
esttab using summstats.tex, ///
    cells("mean sd min max") ///
    nonumber nomtitle noobs ///
    label replace ///
    booktabs

* Histogram of MM estimator
histogram thetaMM, width(0.01) start(0.9) xline(1, lcolor(red)) ///
    title("Distribution of θ̂MM over 1000 replications") xtitle("θ̂MM") ytitle("Frequency")
graph export "thetaMM_hist.png",replace
* Histogram of ML estimator
histogram thetaML, width(0.001) start(0.99) xline(1, lcolor(red)) ///
    title("Distribution of θ̂ML over 1000 replications") xtitle("θ̂ML") ytitle("Frequency")
graph export "thetaML_hist.png",replace