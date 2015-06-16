# Overview
 __KidStats__ permits the application of robust multivariate statistical analyses to produce subadult age and sex estimations with 95% prediction intervals and bootstrapped classification accuracies, respectively. Kidstats communicates with __R__ (R Core Team, 2013) and primarily uses the `earth` (Milborrow, 2013) and `mda` (Leisch et al., 2011) packages to produce the statistical outputs. The `earth` package employs *multivariate adaptive regression splines (MARS)* for age at death estimation and the `mda` package employs *flexible discriminant analysis (FDA)* for sex estimation. 
<br><br>
The only reference sample that is currently available for model creation is from South Africa (n = 1310). The subadults are between the ages of birth and 12 years and include individuals from the three largest South African social races. The even age distribution (minus a few smaller sample sizes at the two youngest age categories and the oldest age category) and large sample ensures the skeletal variation in the South African population is adequately captured for all ages. For more information regarding the sample demographics and size please see Stull (2013). The raw data can be downloaded from: http://kyrastull.weebly.com.
<br><br>
Future intentions include the incorporation of additional populations so there are numerous reference samples. If there is data available that has measurements comparable to the descriptions in the __Measurements__ section, please contact __Kyra Stull, PhD__ to discuss incorporating the samples into the application.

----

Kyra Stull, PhD <br>
Assistant Professor <br>
Department of Anthropology <br>
Idaho State University <br>
stulkyra@isu.edu <br>
http://www.isu.edu/anthro/stull.shtml

----

The latest version of KidStats can be found on [GitHub](https://github.com/geanes/kidstats).
<br>
Bug reports can be submitted [here](https://github.com/geanes/kidstats/issues).
