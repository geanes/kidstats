# Operation
<br><br>
Although __KidStats__ can run with __R__, we recommend using __RStudio__ (http://www.rstudio.com). __RStudio__ is an integrated development environment for __R__ that works well with Shiny, includes __Pandoc__ (a program used to generate reports) and features used to develop the software. __RStudio__ or __R__ needs to be open for __KidStats__ to operate. Thus, if you close __R__ or __RStudio__ the web interface for __KidStats__ will be diabled. 

### Input
1. Collect the proper measurements *(see __Measurements__ section above)*. 
2. Enter these measurements into the appropriate boxes on the __Input__ page.

<br><br>

----

### Age
1. On the __Input__ page, choose the type of __Transformation__ on age to be performed.  
2. Push the __Evaluate__ button for the analyses to be performed.
3. After analyzing the __Output__ page, you may wish to exclude variables from the modelling process, these variables can be chosen from the __Exclude__ dropdown.
4. Re-__Evaluate__ as necessary.

<br>

*Comment: A transformation isn't necessary but may provide a better fit, depending on the measurements available. It is acceptable to use all transformation options and choose the fit with the smallest prediction intervals. The results, no matter what transformation was chosen, should be fairly similar.*

<br>

###  Age: Output
Upon evaluation, some output is provided directly beneath the measurement input boxes. Specifically, the point estimate, upper and lower 95% prediction intervals, the R-squared value for the model, and the sample size used in the evaluation are provided. Extended output is available from the __Output__ page.
<br><br>
Only individuals from the reference sample with *all* non-excluded measurements entered on the __Input__ page will be used in model creation. 

<br><br>

----

### Sex
*Any special buttons they are pushing/choosing??*

### Sex: Output
The output for the sex estimation will include the sample size, a confusion matrix that illustrates the trends in classification/misclassification, and an overall classification accuracy. There is an associated extended report that will contain additional information, such as the variables that were used in model creation.

<br>

- Check the extended report to see which predictor variables have the least importance in model creation. These measurements can be removed and a new model can be created. 

<br>

**IMPORTANT USER NOTE: It is important, and almost imperative for the sex estimation analyses, to evaluate which variables were incorporated into the model in the extended reports. If variables were not included and have no variable importance (provided by a small evimp number [i.e., 0]) then they can be 'excluded' so they are removed from the next iteration of model creation. The removal of superfluous variables can increase the sample size, which will yield a more realistic prediction interval/classification accuracy.** 
