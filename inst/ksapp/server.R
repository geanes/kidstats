shinyServer(function(input, output) {
  # get the reference data from the selectize input
  refdata <- reactive({
    input$evaluate
    isolate({
    if(length(input$refsamp) == 0) return(NULL)
    switch(input$refsamp,
           "za" = salb_za,
           NULL)
    })
  })

  # elements is the newdata data.frame
  elements <- reactive({
    input$evaluate
    isolate({
    elements <- c()
     if(!is.na(input$fmxl)) elements <- c(elements, "f_mxl" = input$fmxl)
     if(!is.na(input$fmsb)) elements <- c(elements, "f_msb" = input$fmsb)
     if(!is.na(input$fdb)) elements <- c(elements, "f_db" = input$fdb)
     if(!is.na(input$tmxl)) elements <- c(elements, "t_mxl" = input$tmxl)
     if(!is.na(input$tpb)) elements <- c(elements, "t_pb" = input$tpb)
     if(!is.na(input$tmsb)) elements <- c(elements, "t_msb" = input$tmsb)
     if(!is.na(input$tdb)) elements <- c(elements, "t_db" = input$tdb)
     if(!is.na(input$hmxl)) elements <- c(elements, "h_mxl" = input$hmxl)
     if(!is.na(input$hpb)) elements <- c(elements, "h_pb" = input$hpb)
     if(!is.na(input$hmsb)) elements <- c(elements, "h_msb" = input$hmsb)
     if(!is.na(input$hdb)) elements <- c(elements, "h_db" = input$hdb)
     if(!is.na(input$rmxl)) elements <- c(elements, "r_mxl" = input$rmxl)
     if(!is.na(input$rpb)) elements <- c(elements, "r_pb" = input$rpb)
     if(!is.na(input$rmsb)) elements <- c(elements, "r_msb" = input$rmsb)
     if(!is.na(input$rdb)) elements <- c(elements, "r_db" = input$rdb)
     if(!is.na(input$umxl)) elements <- c(elements, "u_mxl" = input$umxl)
     if(!is.na(input$umsb)) elements <- c(elements, "u_msb" = input$umsb)
     if(length(elements) == 0)  return(NULL)
     return(data.frame(as.list(elements)))
    })
  })

# construct elements input table
  el_names <- c("<h4>Elements</h4>", "<h5>Femur</h5>", "<h5>Tibia</h5>", "<h5>Humerus</h5>", "<h5>Radius</h5>", "<h5>Ulna</h5>")
  el_meas <- c("Max. Length", "Prox. Breadth", "MS. Breadth", "Dist. Breadth")
  mxl <- c("Max. Length",
    "<input id='fmxl' class='shiny-bound-input' type='number' value='NA' min='0' max='1000'>",
    "<input id='tmxl' class='shiny-bound-input' type='number' value='NA' min='0' max='1000'>",
    "<input id='hmxl' class='shiny-bound-input' type='number' value='NA' min='0' max='1000'>",
    "<input id='rmxl' class='shiny-bound-input' type='number' value='NA' min='0' max='1000'>",
    "<input id='umxl' class='shiny-bound-input' type='number' value='NA' min='0' max='1000'>"
  )
  pb <- c("Prox. Breadth",
    NA,
    "<input id='tpb' class='shiny-bound-input' type='number' value='NA' min='0' max='1000'>",
    "<input id='hpb' class='shiny-bound-input' type='number' value='NA' min='0' max='1000'>",
    "<input id='rpb' class='shiny-bound-input' type='number' value='NA' min='0' max='1000'>",
    NA
  )
  msb <- c("MS. Breadth",
    "<input id='fmsb' class='shiny-bound-input' type='number' value='NA' min='0' max='1000'>",
    "<input id='tmsb' class='shiny-bound-input' type='number' value='NA' min='0' max='1000'>",
    "<input id='hmsb' class='shiny-bound-input' type='number' value='NA' min='0' max='1000'>",
    "<input id='rmsb' class='shiny-bound-input' type='number' value='NA' min='0' max='1000'>",
    "<input id='umsb' class='shiny-bound-input' type='number' value='NA' min='0' max='1000'>"
  )
  db <- c("Dist. Breadth",
    "<input id='fdb' class='shiny-bound-input' type='number' value='NA' min='0' max='1000'>",
    "<input id='tdb' class='shiny-bound-input' type='number' value='NA' min='0' max='1000'>",
    "<input id='hdb' class='shiny-bound-input' type='number' value='NA' min='0' max='1000'>",
    "<input id='rdb' class='shiny-bound-input' type='number' value='NA' min='0' max='1000'>",
    NA
  )

  output$el_table <-renderTable({
    data.frame(el_names, mxl, pb, msb, db)
  }, sanitize.text.function = function(x) x, sanitize.rownames.function = function(x) x, sanitize.colnames.function = function(x) x, include.rownames = FALSE, include.colnames = FALSE)

  # create the reference data from the raw data
  refsamp <- reactive({
    if(is.null(refdata()) | is.null(elements())) return(NULL)
    ref <- na.omit(dplyr::select_(refdata(), .dots = c("age_y", names(elements()))))
    return(ref)
  })

  # output the reference data in the reference sample section of the ui
  output$table <- renderDataTable({
    if(is.null(refsamp())) return(NULL)
    refsamp()
  })

  # create the model and predict the age
  earth_mod <- reactive({
    input$evaluate
    # exclude age_y from the variable dataset
    x <- dplyr::select_(refsamp(), ~-age_y)
    # extract age_y from the reference sample
    isolate({
    y <- switch(input$transform,
      sqrt = sqrt(dplyr::select_(refsamp(), ~age_y)),
      cbrt = (dplyr::select_(refsamp(), ~age_y))^(1/3),
      dplyr::select_(refsamp(), ~age_y)
    )})
    # create the model and make predictions
    model <- earth::earth(x = x, y = y, varmod.method = "lm", ncross = 30, nfold = 10)
    rsq <- round(model$grsq, digits = 4)
    estage <- predict(model, newdata = elements(), interval = "pint")

    isolate({
    estage <- switch(input$transform,
      sqrt = round(estage^2, digits = 2),
      cbrt = round(estage^3, digits = 2),
      round(estage, digits = 2)
    )})
    # prepare return object
    message <- c()
    message[1] <- estage[1]
    message[2] <- estage[2]
    message[3] <- estage[3]
    message[4] <- rsq
    return(message)
  })

 # output the estage value
 output$age <- renderText({
   if(input$evaluate == 0) return(paste0("<i class = 'fa fa-circle-thin fa-2x' style = 'padding-top: 25px; color: #DDD;'></i>"))
   if(is.null(refsamp())) return(paste0("<i class = 'fa fa-circle-thin fa-2x' style = 'padding-top: 25px; color: #DDD;'></i>"))
   estage <- earth_mod()[1]
   if(is.null(estage)) return(print(""))
   message <- paste(h5("Estimated age:"), h3(sprintf("%.2f", estage)), sep = " ")
   return(message)
 })
 # output lwr
 output$lwr <- renderText({
   if(input$evaluate == 0) return(paste0("<i class = 'fa fa-circle-thin fa-2x' style = 'padding-top: 25px; color: #DDD;'></i>"))
   if(is.null(refsamp())) return(paste0("<i class = 'fa fa-circle-thin fa-2x' style = 'padding-top: 25px; color: #DDD;'></i>"))
   lwr <- earth_mod()[2]
   if(is.null(lwr)) return(print(""))
   message <- paste(h5("Lower PI:"), h3(sprintf("%.2f", lwr)), sep = " ")
   return(message)
 })
 # output upr
 output$upr <- renderText({
   if(input$evaluate == 0) return(paste0("<i class = 'fa fa-circle-thin fa-2x' style = 'padding-top: 25px; color: #DDD;'></i>"))
   if(is.null(refsamp())) return(paste0("<i class = 'fa fa-circle-thin fa-2x' style = 'padding-top: 25px; color: #DDD;'></i>"))
   upr <- earth_mod()[3]
   if(is.null(upr)) return(print(""))
   message <- paste(h5("Upper PI:"), h3(sprintf("%.2f", upr)), sep = " ")
   return(message)
 })
 # output Rsq
 output$rsq <- renderText({
   if(input$evaluate == 0) return(paste0("<i class = 'fa fa-circle-thin fa-2x' style = 'padding-top: 25px; color: #DDD;'></i>"))
   if(is.null(refsamp())) return(paste0("<i class = 'fa fa-circle-thin fa-2x' style = 'padding-top: 25px; color: #DDD;'></i>"))
   rsq <- earth_mod()[4]
   if(is.null(rsq)) return(print(""))
   message <- paste(h5("Model R^2:"), h3(sprintf("%.4f", rsq)), sep = " ")
   return(message)
 })
 # output sample size
 output$sampsize <- renderText({
   if(input$evaluate == 0) return(paste0("<i class = 'fa fa-circle-thin fa-2x' style = 'padding-top: 25px; color: #DDD;'></i>"))
   if(is.null(refsamp())) return(paste0("<i class = 'fa fa-circle-thin fa-2x' style = 'padding-top: 25px; color: #DDD;'></i>"))
   samp <- nrow(refsamp())
   message <- paste(h5("Sample size:"), h3(samp), sep = " ")
   return(message)
 })

})
