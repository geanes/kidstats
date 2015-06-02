# Statistics
Kidstats communicates with __R__ (R Core Team, 2013) and uses the `earth` (Milborrow, 2013) and `mda` (Leisch et al., 2011) packages to produce the statistical output. The `earth` package employs *multivariate adaptive regression splines (MARS)* for age at death estimation and the `mda` package employs *flexible discriminant analysis (FDA)* for sex estimation. 
<br><br>
In the output for the age at death estimation, 95% prediction intervals (upper and lower) will be provided. Additionally, overall correct classification accuracies will be provided with the sex estimation. 
<br><br>
*__Please note:__ Incorporating as many measurements as possible will yield the highest correct classification accuracies. Univariate models, and even single element bone models, yield fairly impractical results (Stull, 2013).*

---

### Multivariate Adaptive Regression Splines (MARS)
Details below are largely taken from Stull et al. (2014). For more information on *MARS* please look into Friedman, 1991; Hastie et al., 2009; Milborrow, 2013, 2015.
<br><br>
*MARS* is a flexible, nonparametric regression modeling technique that requires no assumptions about the relationships among the variables (De Veaux and Ungar; Friedman, 1991; Butte et al., 2010). Linear regression, truncated basis functions, and binary recursive partitioning are incorporated into MARS to approximate the underlying function and model relationships (Muñoz and Felicísimo, 2004). The ultimate goal of *MARS* is to identify the basis function, f(X), which is estimated by subdividing X into regions and obtaining estimates of f(X) for each region (Friedman, 1991; Sekulic and Kowalski, 1992). Piecewise linear basis functions are conducted for each predictor variable (x) and every possible value of t, the knot, and take the form of a constant, a hinge function, or a combination of hinge functions.
<br><br>
The knot (t) forms a reflected pair for each predictor variable and represents a change in slope or transition between polynomials (Friedman, 1991; Sekulic and Kowalski, 1992; Muñoz and Felicísimo, 2004; Hastie et al., 2009; Butte et al., 2010). The hinge function that results in a positive value is used. For example, if hinge functions for a model are (HDL – 222) and (222 – HDL), the change in slope is at 222 mm, and the first hinge function is used if the diaphyseal length is greater than 222 mm and the second hinge function is used if the diaphyseal length is smaller than 222 mm.
<br><br>
Forward and backward iterative selection constructs a set of basis functions for the final *MARS* model (Friedman, 1991, 1993). The forward pass deliberately overfits the training data, and the backward pruning pass removes excess basis functions that no longer contribute to the accuracy of the fit, which is based on the general- ized criterion value (GCV). The GCV is an approximation of the prediction error ascertained by leave-one-out cross-validation (Friedman, 1991, 1993; Milborrow, 2013). The knot and variable that provides the best fit are retained in the model, and the coefficients for each function are estimated by minimizing the residual sum of squares (Friedman, 1991; Sekulic and Kowalski, 1992; De Veaux and Ungar, 1994; Hastie et al., 2009).
<br><br>
*MARS* models were built through k-fold cross- validation. k-fold cross-validation separates the data into K equal sized parts. The model is fit with the K – 1 parts and the prediction error of the fitted model is calculated when predicting the kth part, or the out-of-fold data (Efron and Tibshirani, 1993; Friedman and Kohavi, 1999; Hastie et al., 2009). The process is conducted for k = 1, 2, . . . K and the prediction error is averaged across all out-of-fold pre- dictions. The current study uses K = 10 because it allows for a lower variance, but a possibly higher bias; however, this bias is alleviated if the training sample has at least 100 observations (Efron and Tibshirani, 1993). 
<br><br>
Each training set will be a different size because the dataset specific to each variable is different; the largest univariate samples (i.e., HDL, FDL) have training sets with more than 100 observations though all of the univariate breadths and multivariate samples will not. The out-of- fold R-squared (cross-validated R2) is averaged from the left-out subset, which is an estimate of the model performance on independent data (Efron and Tibshirani, 1993; Hastie et al., 2009; Milborrow, 2013). The generalized R-squared (GRSq) is based on the raw GCV and is a generalization of model performance. Adding terms (or hinge functions) generally always increases the R2 statistic, but the GRSq may actually decrease because of the reduction of predictive powers (Milborrow, 2013).
<br><br>
__95% Prediction Intervals (PIs)__
<br>
The variance of the predicted values is used to estimate PIs (Stull and Milborrow, 2014; Milborrow, 2015). As opposed to a constant variance model, which would assume homoscedasticity, the linear model uses iteratively reweighted least squares (IRLS) to model heteroscedasticity (Milborrow, 2013).
<br><br>
 To build the variance model, earth models how the residuals vary with the predicted response. earth first builds a MARS model as usual, then internally applies a linear model (lm) to the original earth model’s absolute residuals. Specifically, it uses the variance estimated from the original model to determine the weights for the residual model. Iteration stops when the lm coefficients change by less than 1%. IRLS is necessary because in general the residuals are themselves heteroscedastic, especially when using any type of biological data. Following model creation, the test data is used to validate the models and to compare model performance.
<br><br>
*More detailed information, including the R code and examples, can be found in Milborrow, 2015.*
<br><br>

---

### Flexible Discriminant Analysis (FDA)
*Flexible discriminant analysis (FDA)* is a nonparametric version of discriminant analysis that substitutes linear regression with a nonparametric regression method. By analogy, the more flexible, nonparametric fit results in a more flexible classifier (Hastie et al., 1993). Overall, the flexible modeling is better at separating classes compared to linear discriminant analysis (Friedman, 1991; Reynes et al., 2006; Milborrow, 2013). 
<br><br>
Though numerous nonparametric regression models use basis expansions, the authors chose to use Friedman’s (1991) *MARS* to enlarge multivariate space. The *MARS* algorithm is as described above, with a modification for a multiple response variable. Additional descriptions of *FDA* can be found in Hastie et al. (1993, 2009). 
<br><br>
Analyses were conducted using the `fda` function in the `mda` package in __R__, which was based on the original S code written by Hastie and Tibshirani (Leisch et al., 2011; R Core Team, 2013). 
<br><br>
Stepwise selection of variables and cross-validation are inherent to *FDA*, thus superfluous variables are removed from variable creation and classifications are more realistic than optimistic.

---

TODO:
BOOTSTRAP?
