# Statistics
Kidstats communicates with __R__ (R Core Team, 2013) and uses the `earth` (Milborrow, 2013) and `mda` (Leisch et al., 2011) packages to produce the statistical outputs. The `earth` package employs *multivariate adaptive regression splines (MARS)* for age at death estimation and the `mda` package employs *flexible discriminant analysis (FDA)* for sex estimation. 
<br><br>
In the output for the age at death estimation, 95% prediction intervals (upper and lower) will be provided. Additionally, bootstrapped correct classification accuracies will be provided with the sex estimation. 
<br><br>
*__Please note:__ 1) When the subadults are younger, univariate models using diaphyseal lengths produce the narrowest prediction intervals. In contrast, when the subadults are older, multivariate models using numerous (or all available) measurements produce the narrowest prediction intervals. MARS will choose the best fit model (whether it is univariate or multivariate) based on least squares. 2) Incorporating as many measurements as possible for the sex estimation portion will yield the highest correct classification accuracies in sex estimation. Univariate models, and even single element bone models, yield fairly impractical results (Stull, 2013).*

---

### Multivariate Adaptive Regression Splines (MARS)
Details below are largely taken from Stull et al. (2014). For more information on *MARS* please look into Friedman, 1991; Hastie et al., 2009; Milborrow, 2013, 2015.
<br><br>
*MARS* is a flexible, nonparametric regression modeling technique that incorporates linear regression, truncated basis functions, and binary recursive partitioning to approximate the underlying function and model relationships (Friedman, 1991; De Veaux and Ungar, 1994; Muñoz and Felicísimo, 2004; Butte et al., 2010). *MARS* identifies the basis function, f(X), by subdividing X into regions and obtaining estimates of f(X) for each region (Friedman, 1991; Sekulic and Kowalski, 1992). Piecewise linear basis functions are conducted for each predictor variable (x) and every possible value of t (the knot) and take the form of a constant, a hinge function, or a combination of hinge functions.
<br><br>
The knot (t) forms a reflected pair for each predictor variable and represents a change in slope or transition between polynomials (Friedman, 1991; Sekulic and Kowalski, 1992; Muñoz and Felicísimo, 2004; Hastie et al., 2009; Butte et al., 2010). Only the hinge functions that result in a positive value is used in the final regression formula. For example, if hinge functions for a model are (HDL – 222) and (222 – HDL), the knot is at 222 mm. The first hinge function is used if the diaphyseal length is greater than 222 mm and the second hinge function is used if the diaphyseal length is smaller than 222 mm.
<br><br>
Forward and backward iterative selection constructs the basis functions for the final *MARS* model (Friedman, 1991, 1993). The forward pass deliberately overfits the training data, and the backward pruning pass removes excess basis functions that no longer contribute to the fit, which is based on the generalized criterion value (GCV). The GCV is an approximation of the prediction error ascertained by leave-one-out cross-validation (Friedman, 1991, 1993; Milborrow, 2013). The knot and variable that provides the best fit are retained in the model, and the coefficients for each function are estimated by minimizing the residual sum of squares (Friedman, 1991; Sekulic and Kowalski, 1992; De Veaux and Ungar, 1994; Hastie et al., 2009).
<br><br>
*MARS* models are built through k-fold cross-validation. The data is separated in to K equal sized parts and the model is fit with the K – 1 parts. The prediction error of the fitted model is calculated when predicting the kth part, or the out-of-fold data (Efron and Tibshirani, 1993; Friedman and Kohavi, 1999; Hastie et al., 2009). The process is conducted for all parts (k = 1, 2, . . . K) and the prediction error is averaged across all out-of-fold predictions. The program uses K = 10 because it allows for a lower variance, but a possibly higher bias. However, if the training sample has at least 100 observations the bias is alleviated (Efron and Tibshirani, 1993).Each training set will be a different size because the dataset specific to each variable is different; the largest univariate samples (i.e., HDL, FDL) have training sets with more than 100 observations though all of the univariate breadths and multivariate samples will not.  

<br>

#### OUTPUT VARIABLES in the EXTENDED/LONG REPORT
- The out-of- fold R-squared (cross-validated R2) is averaged from the left-out subset, which is an estimate of the model performance on independent data (Efron and Tibshirani, 1993; Hastie et al., 2009; Milborrow, 2013). 
<br><br>
- The generalized R-squared (GRSq) is based on the raw GCV and is a generalization of model performance. Adding terms (or hinge functions) generally always increases the R2 statistic, but the GRSq may actually decrease because of the reduction of predictive powers (Milborrow, 2013).
<br><br>
- *Variable importance*:  *MARS* conducts automatic variable selection based on the effect of the variable on the response variable, which is averaged for the entire population. The varImp function (from the caret package [Kuhn, 2015]) tracks the changes in model statistics (i.e., GCV) for each predictor variable and accumulates the reduction in the statistic when each predictor’s feature is added to the model (Kuhn, 2015). The reduction is then used as the variable importance measure. The predictor variable has an importance value of zero if it was never used in any of the *MARS* basis functions after pruning. Within the earth function, the varImp is a wrapper to the evimp function in the earth package. There are three statistics that can be used to estimate variable importance in MARS models: 1) the number of model subsets that include the variable, 2) variables that cause for a decreased residual sum of squares, and 3) the GCV criterion, if the GCV increases, the variable has less importance (Milborrow, 2013). 

<br>

__95% Prediction Intervals (PIs)__
<br>
The variance of the predicted values is used to estimate PIs (Stull and Milborrow, 2014; Milborrow, 2015). As opposed to a constant variance model, which would assume homoscedasticity, the linear model (varmod.method="lm") uses iteratively reweighted least squares (IRLS) to model heteroscedasticity (Milborrow, 2013).
<br><br>
 To build the variance model earth models how the residuals vary with the predicted response. earth first builds a MARS model as usual, then internally applies a linear model (lm) to the original earth model’s absolute residuals. Specifically, it uses the variance estimated from the original model to determine the weights for the residual model. Iteration stops when the lm coefficients change by less than 1%. IRLS is necessary because in general the residuals are themselves heteroscedastic, especially when using any type of biological data. Following model creation, the test data is used to validate the models and to compare model performance.
<br><br>
*More detailed information, including the R code and examples, can be found in Milborrow, 2015.*
<br><br>

---

### Flexible Discriminant Analysis (FDA)
*Flexible discriminant analysis (FDA)* is a nonparametric version of discriminant analysis that substitutes linear regression with a nonparametric regression method. By analogy, the more flexible, nonparametric fit results in a more flexible classifier (Hastie et al., 1993). Overall, the flexible modeling is often stated to be better at separating classes compared to linear discriminant analysis (Friedman, 1991; Reynes et al., 2006; Milborrow, 2013). 
<br><br>
Though numerous nonparametric regression models use basis expansions, the authors chose to use Friedman’s (1991) *MARS* to enlarge multivariate space. The *MARS* algorithm is as described above, with a modification for a multiple response variable. Additional descriptions of *FDA* can be found in Hastie et al. (1993, 2009). 
<br><br>
Analyses were conducted using the `fda` function in the `mda` package in __R__, which was based on the original S code written by Hastie and Tibshirani (Leisch et al., 2011; R Core Team, 2013). 
<br><br>
Stepwise selection of variables and cross-validation are inherent to *FDA*, thus superfluous variables are removed from variable creation and classifications are more realistic than optimistic.

<br><br>

#### Classification Accuracies: The Bootstrap
A bootstrap is automatically conducted for each classification accuracy associated with sex estimation. The model is subject to 1000 iterations and the classification error of the bootstrapped results are averaged and generally provide a more realistic classification error. 

The bootstrap is a resampling method and is the most suitable resampling method for smaller sample sizes, which can be an issue when incorporating many measurements. The bootstrap process consists of generating B bootstrap samples (a 1000 in this program), estimating the model of each B sample, and then applying the fitted model to the original samples (Efron, 1979; Efron and Tibshirani, 1993; Michie et al., 1994; Hastie et al., 2009). An important note is that the B bootstrapped datasets keep the same sample size as the raw data but are sampled with replacement from the training data. Thus, the bootstrapped samples are not identical to the original sample and some observations may be omitted entirely. Approximately 63% of the B sample will be unique observations from the original sample, the remaining 37% of the B sample will be duplicates of the original sample (Michie et al., 1994; Kohavi, 1995). 
