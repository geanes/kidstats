# Operation
<br><br>
Although __KidStats__ can run with __R__, we recommend using <a target = "_blank" href = "http://www.rstudio.com/products/RStudio">RStudio</a>. __RStudio__ is an integrated development environment for __R__ that works with Shiny, includes __Pandoc__ (a program used to generate reports), and features used to develop the software. __RStudio__ or __R__ needs to be open for __KidStats__ to operate. Thus, if you close __R__ or __RStudio__ the web interface for __KidStats__ will be disabled. 

### Input
1. Collect the proper measurements *(see __Measurements__ section above)*. 
2. Enter these measurements into the appropriate boxes on the __Input__ page. 

<br><br>

----

### Age
1. On the left side of the __Input__ page, choose the type of __Transformation__ on age to be performed. A transformation isn't necessary but may provide a better fit, depending on the measurements available. It is acceptable to use all transformation options and choose the fit with the smallest prediction intervals. The results should be fairly similar, no matter what transformation is chosen.
2. Push the __Evaluate__ button to perform the analysis.
3. After analyzing the __Output__ page, you may wish to exclude variables from the modelling process, these variables can be chosen in the __Exclude__ box. The __Exclude__ box is dynamic, so it will only provide measurements to remove from model creation that you have provided measurements for. If you click in the box, the list will appear. Only individuals from the reference sample with *all* non-excluded measurements entered on the __Input__ page will be used in model creation. 
4. Once measurements have been chosen for exclusion from the model, repeat Steps 2 and 3 as necessary.

<br>

###  Age: Output
Upon evaluation, some output is provided directly beneath the measurement input boxes. Specifically, the point estimate, upper and lower 95% prediction intervals, the R-squared value for the model, and the sample size used in the evaluation are provided. A more detailed output is available from the __Output__ page under the *Age Estimation* tab.

<br><br>

----

### Sex
1. Push the __Evaluate__ button to perform the analysis.
2. After analyzing the __Output__ page (see below), you may wish to exclude variables from the modelling process, these variables can be chosen in the __Exclude__ box. The __Exclude__ box is dynamic, so it will only provide measurements to remove from model creation that you have provided measurements for. If you click in the box, the list will appear. 
3. If you wish to calculate the classification accuracy using the bootstrap method, check the __Bootstrap Classification Accuracy__ box. 
  - *Note: This will slow down the sex estimation process.*
4. Once measurements have been chosen for exclusion from the model, repeat Steps 2 and 3 as necessary.

### Sex: Output
Some output (male and female posterior probabilities and sample size) is provided directly beneath the measurement input boxes and age estimation results. A more detailed output is available on the __Output__ page under the *Sex Estimation* tab and includes the posterior probabilities when the unknown is used in the created model, the FDA coefficients, variable importance, a confusion matrix that illustrates the trends in classification/misclassification for the created model, and the bootstrapped classification accuracy.

<br>

**Comment: It is important, and almost imperative for the sex estimation analyses, to evaluate which variables were incorporated into the model in the extended reports. If variables were not included and have no variable importance (provided by a small evimp number [i.e., 0]) then they can be 'excluded' so they are removed from the next iteration of model creation. The removal of superfluous variables can increase the sample size, which will yield a more realistic prediction interval/classification accuracy. However, remember more variables incorporated into the sex estimation models generally yields higher classification accuracies. The overly optimistic effects of a small sample size can be mitigated by bootstrapping.** 
