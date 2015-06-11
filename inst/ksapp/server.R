shinyServer(function(input, output, session) {
  # get the reference data from the selectize input
  refdata <- reactive({
    input$evaluate
    isolate({
    if (length(input$refsamp) == 0) return(NULL)
    switch(input$refsamp,
           "za" = salb_za,
           NULL)
    })
  })

  # construct elements input table
  el_names <- c("<h4>Elements</h4>", "<h5>Femur</h5>", "<h5>Tibia</h5>", "<h5>Humerus</h5>", "<h5>Radius</h5>", "<h5>Ulna</h5>")
  el_meas <- c("Diaphyseal Length", "Proximal Breadth", "Midshaft Breadth", "Distal Breadth")
  dl <- c("Diaphyseal Length",
    "<input id='fdl' class='shiny-bound-input' type='number' value='NA' min='0' max='500'>",
    "<input id='tdl' class='shiny-bound-input' type='number' value='NA' min='0' max='500'>",
    "<input id='hdl' class='shiny-bound-input' type='number' value='NA' min='0' max='500'>",
    "<input id='rdl' class='shiny-bound-input' type='number' value='NA' min='0' max='500'>",
    "<input id='udl' class='shiny-bound-input' type='number' value='NA' min='0' max='500'>"
  )
  pb <- c("Proximal Breadth",
    NA,
    "<input id='tpb' class='shiny-bound-input' type='number' value='NA' min='0' max='500'>",
    "<input id='hpb' class='shiny-bound-input' type='number' value='NA' min='0' max='500'>",
    "<input id='rpb' class='shiny-bound-input' type='number' value='NA' min='0' max='500'>",
    NA
  )
  msb <- c("Midshaft Breadth",
    "<input id='fmsb' class='shiny-bound-input' type='number' value='NA' min='0' max='500'>",
    "<input id='tmsb' class='shiny-bound-input' type='number' value='NA' min='0' max='500'>",
    "<input id='hmsb' class='shiny-bound-input' type='number' value='NA' min='0' max='500'>",
    "<input id='rmsb' class='shiny-bound-input' type='number' value='NA' min='0' max='500'>",
    "<input id='umsb' class='shiny-bound-input' type='number' value='NA' min='0' max='500'>"
  )
  db <- c("Distal Breadth",
    "<input id='fdb' class='shiny-bound-input' type='number' value='NA' min='0' max='500'>",
    "<input id='tdb' class='shiny-bound-input' type='number' value='NA' min='0' max='500'>",
    "<input id='hdb' class='shiny-bound-input' type='number' value='NA' min='0' max='500'>",
    "<input id='rdb' class='shiny-bound-input' type='number' value='NA' min='0' max='500'>",
    NA
  )
  # render elements input table
  output$el_table <- renderTable({
    data.frame(el_names, dl, pb, msb, db)
  }, sanitize.text.function = function(x) x, sanitize.rownames.function = function(x) x, sanitize.colnames.function = function(x) x, include.rownames = FALSE, include.colnames = FALSE)

  # elements is the newdata data.frame
  elements <- reactive({
    elements <- c()
    elements <- c(elements, "FDL" = input$fdl)
    elements <- c(elements, "FMSB" = input$fmsb)
    elements <- c(elements, "FDB" = input$fdb)
    elements <- c(elements, "TDL" = input$tdl)
    elements <- c(elements, "TPB" = input$tpb)
    elements <- c(elements, "TMSB" = input$tmsb)
    elements <- c(elements, "TDB" = input$tdb)
    elements <- c(elements, "HDL" = input$hdl)
    elements <- c(elements, "HPB" = input$hpb)
    elements <- c(elements, "HMSB" = input$hmsb)
    elements <- c(elements, "HDB" = input$hdb)
    elements <- c(elements, "RDL" = input$rdl)
    elements <- c(elements, "RPB" = input$rpb)
    elements <- c(elements, "RMSB" = input$rmsb)
    elements <- c(elements, "RDB" = input$rdb)
    elements <- c(elements, "UDL" = input$udl)
    elements <- c(elements, "UMSB" = input$umsb)
    elements <- data.frame(as.list(elements))
    elements <- elements[, which(!is.na(elements[1,])), drop = FALSE]
    if (length(elements) == 0)  return(NULL)
    return(elements)
  })

  # render exclude lists
  # change values for input$ex_age
   observe({
     opts <- c()
     if (length(elements() != 0) && !is.null(elements())) opts <- names(elements())
     updateSelectInput(session, "ex_age", choices = opts)
   })

  # create the reference data from the raw data
  refsamp <- reactive({
    if (is.null(refdata()) | is.null(elements())) return(NULL)
    ref <- dplyr::select_(refdata(), .dots = c("ID", "SEX", "AGE", names(elements())))
    return(ref)
  })

  age_samp <- reactive({
    if (is.null(refsamp())) return(NULL)
    samp <- dplyr::select_(refsamp(), .dots = c("-ID", "-SEX"))
    if (length(input$ex_age) != 0) {
      ex <- paste0("-", input$ex_age)
      samp <- na.omit(dplyr::select_(samp, .dots = ex))
    } else {samp <- na.omit(samp)}
    return(samp)
  })

#################################### MODEL ####################################

  # create the models and predict age and sex using newdata
  earth_mod <- reactive({
    input$evaluate
    isolate({
      if (is.null(age_samp()) || is.null(elements())) return(NULL)
      # exclude SEX and ID from the age model dataset and transform AGE
      earth_data <- age_samp()
        earth_data$AGE <- switch(input$transform,
          sqrt = sqrt(earth_data$AGE),
          cbrt = (earth_data$AGE) ^ (1/3),
          earth_data$AGE
        )
      # create formula
      earth_formula <- as.formula('AGE ~ .')
      # create age model and make predictions
      model_age <- earth::earth(earth_formula, data = earth_data, varmod.method = "lm", ncross = 30, nfold = 10)
      estage <- predict(model_age, newdata = elements(), interval = "pint")
      # undo AGE transform
      estage <- switch(input$transform,
        sqrt = round(estage ^ 2, digits = 2),
        cbrt = round(estage ^ 3, digits = 2),
        round(estage, digits = 2)
      )
      return(list(model_age, estage))
    })
  })


############################# OUTPUT ##########################################

#  # output the reference data in the reference sample section of the ui
#  output$table <- DT::renderDataTable({
#    if (is.null(refsamp())) return(NULL)
#    DT::datatable(refsamp(), rownames = FALSE, options = list(pageLength = 50))
#  })

 # output earth model predictions
 output$earth_pred <- renderPrint({
   if (is.null(earth_mod()) || is.null(elements())) return(NULL)
   pred <- earth_mod()[[2]]
   pred <- pred[, c(2, 1, 3)]
   return(pred)
 })
 # output sample size used in model
 output$earth_samp <- renderPrint({
   sampsize <- nrow(age_samp())
   message <- paste0("Sample size used in model: ", sampsize)
   return(message)
 })
 # output earth model summary
 output$earth_summary <- renderPrint({
   if (input$evaluate == 0) return(NULL)
   summary(earth_mod()[[1]])
 })
 # output earth model variable importance
 output$earth_varimp <- renderPrint({
   if (input$evaluate == 0) return(NULL)
   caret::varImp(earth_mod()[[1]])
 })
 # output earth model selection plot
 output$earth_modsel <- renderPlot({
   plot(earth_mod()[[1]], which = 1)
 })
 # output earth qq plot
 output$earth_qq <- renderPlot({
   plot(earth_mod()[[1]], which = 4)
 })
 # output earth rvf plot
 output$earth_rvf <- renderPlot({
   plot(earth_mod()[[1]], which = 3, level = .95, info = TRUE)
 })

 # output the estage value for quick output
 output$age <- renderText({
   if (input$evaluate == 0) return(paste0("<i class = 'fa fa-circle-thin fa-2x' style = 'padding-top: 25px; color: #DDD;'></i>"))
   if (is.null(earth_mod()) || is.null(elements())) return(paste0("<i class = 'fa fa-circle-thin fa-2x' style = 'padding-top: 25px; color: #DDD;'></i>"))
   estage <- earth_mod()[[2]][1]
   if (is.null(estage)) return(print(""))
   message <- paste(h5("Estimated age:"), h3(sprintf("%.2f", estage)), sep = " ")
   return(message)
 })
 # output lwr PI for quick output
 output$lwr <- renderText({
   if (input$evaluate == 0) return(paste0("<i class = 'fa fa-circle-thin fa-2x' style = 'padding-top: 25px; color: #DDD;'></i>"))
   if (is.null(earth_mod()) || is.null(elements())) return(paste0("<i class = 'fa fa-circle-thin fa-2x' style = 'padding-top: 25px; color: #DDD;'></i>"))
   lwr <- earth_mod()[[2]][2]
   if (is.null(lwr)) return(print(""))
   message <- paste(h5("Lower PI:"), h3(sprintf("%.2f", lwr)), sep = " ")
   return(message)
 })
 # output upr PI for quick output
 output$upr <- renderText({
   if (input$evaluate == 0) return(paste0("<i class = 'fa fa-circle-thin fa-2x' style = 'padding-top: 25px; color: #DDD;'></i>"))
   if (is.null(earth_mod()) || is.null(elements())) return(paste0("<i class = 'fa fa-circle-thin fa-2x' style = 'padding-top: 25px; color: #DDD;'></i>"))
   upr <- earth_mod()[[2]][3]
   if (is.null(upr)) return(print(""))
   message <- paste(h5("Upper PI:"), h3(sprintf("%.2f", upr)), sep = " ")
   return(message)
 })
 # output gRsq for quick output
 output$rsq <- renderText({
   if (input$evaluate == 0) return(paste0("<i class = 'fa fa-circle-thin fa-2x' style = 'padding-top: 25px; color: #DDD;'></i>"))
   if (is.null(earth_mod()) || is.null(elements())) return(paste0("<i class = 'fa fa-circle-thin fa-2x' style = 'padding-top: 25px; color: #DDD;'></i>"))
   rsq <- round(earth_mod()[[1]]$grsq, digits = 4)
   if (is.null(rsq)) return(print(""))
   message <- paste(h5("Model R^2:"), h3(sprintf("%.4f", rsq)), sep = " ")
   return(message)
 })
 # output sample size for quick output
 output$sampsize <- renderText({
   if (input$evaluate == 0) return(paste0("<i class = 'fa fa-circle-thin fa-2x' style = 'padding-top: 25px; color: #DDD;'></i>"))
   if (is.null(age_samp())) return(paste0("<i class = 'fa fa-circle-thin fa-2x' style = 'padding-top: 25px; color: #DDD;'></i>"))
   samp <- nrow(age_samp())
   message <- paste(h5("Sample size:"), h3(samp), sep = " ")
   return(message)
 })

 # output report download handler
 output$downloadReport <- downloadHandler(
   filename = function() {
     paste('kidstats-report', sep = '.', switch(
       input$format, PDF = 'pdf', HTML = 'html', Word = 'docx'
     ))
   },

   content = function(file) {
     src <- system.file('ksapp/www/md/report.Rmd', package = 'kidstats')

     # temporarily switch to the temp dir, in case you do not have write
     # permission to the current working directory
     owd <- setwd(tempdir())
     on.exit(setwd(owd))
     file.copy(src, 'report.Rmd')

     out <- rmarkdown::render('report.Rmd', switch(
       input$format,
       PDF = rmarkdown::pdf_document(), HTML = rmarkdown::html_document(css = system.file('ksapp/www/css/report.css', package = 'kidstats')), Word = rmarkdown::word_document()
     ))
     file.rename(out, file)
   }
 )

})
