#' @import shiny
shinyServer(function(input, output) {

 refdata <- reactive({
   infile <- paste0("~/stats/kidstats/data/", input$refsamp)

   if (is.null(infile))
   return(NULL)

   ref <- get(load(infile))
   return(ref)
 })

# elements
 elements <- reactive({
   elements <-data.frame()

    if(!is.na(input$fmxl)){
      elements[nrow(elements) + 1, 1] <- "f_mxl"
      elements[nrow(elements), 2] <- input$fmxl
    }
    if(!is.na(input$fmsb)){
      elements[nrow(elements) + 1, 1] <- "f_msb"
      elements[nrow(elements), 2] <- input$fmsb
    }
    if(!is.na(input$fdb)){
      elements[nrow(elements) + 1, 1] <- "f_db"
      elements[nrow(elements), 2] <- input$fdb
    }

    if(!is.na(input$tmxl)){
      elements[nrow(elements) + 1, 1] <- "t_mxl"
      elements[nrow(elements), 2] <- input$tmxl
    }
    if(!is.na(input$tpb)){
      elements[nrow(elements) + 1, 1] <- "t_pb"
      elements[nrow(elements), 2] <- input$tpb
    }
    if(!is.na(input$tmsb)){
      elements[nrow(elements) + 1, 1] <- "t_msb"
      elements[nrow(elements), 2] <- input$tmsb
    }
    if(!is.na(input$tdb)){
      elements[nrow(elements) + 1, 1] <- "t_db"
      elements[nrow(elements), 2] <- input$tdb
    }

    if(!is.na(input$hmxl)){
      elements[nrow(elements) + 1, 1] <- "h_mxl"
      elements[nrow(elements), 2] <- input$hmxl
    }
    if(!is.na(input$hpb)){
      elements[nrow(elements) + 1, 1] <- "h_pb"
      elements[nrow(elements), 2] <- input$hpb
    }
    if(!is.na(input$hmsb)){
      elements[nrow(elements) + 1, 1] <- "h_msb"
      elements[nrow(elements), 2] <- input$hmsb
    }
    if(!is.na(input$hdb)){
      elements[nrow(elements) + 1, 1] <- "h_db"
      elements[nrow(elements), 2] <- input$hdb
    }

    if(!is.na(input$rmxl)){
      elements[nrow(elements) + 1, 1] <- "r_mxl"
      elements[nrow(elements), 2] <- input$rmxl
    }
    if(!is.na(input$rpb)){
      elements[nrow(elements) + 1, 1] <- "r_pb"
      elements[nrow(elements), 2] <- input$rpb
    }
    if(!is.na(input$rmsb)){
      elements[nrow(elements) + 1, 1] <- "r_msb"
      elements[nrow(elements), 2] <- input$rmsb
    }
    if(!is.na(input$rdb)){
      elements[nrow(elements) + 1, 1] <- "r_db"
      elements[nrow(elements), 2] <- input$rdb
    }

    if(!is.na(input$umxl)){
      elements[nrow(elements) + 1, 1] <- "u_mxl"
      elements[nrow(elements), 2] <- input$umxl
    }
    if(!is.na(input$umsb)){
      elements[nrow(elements) + 1, 1] <- "u_msb"
      elements[nrow(elements), 2] <- input$umsb
    }

    if(nrow(elements) == 0)  return(NULL)

    return(elements)
 })
# construct elements table
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


  refsamp <- reactive({
    if(is.null(refdata()) | is.null(elements())) return(NULL)
    data <- refdata()
    dat <- elements()
    dat_clean <- data[c("age_y", dat[[1]])]
    ref <- na.omit(dat_clean)
    return(ref)
  })


  output$table <- renderDataTable({
    if(is.null(refsamp())) return(NULL)
    refsamp()
  })


  earth_mod <- reactive({
    dat <- elements()
    ref <- refsamp()
    x <- ref[, -1]
    newdata <- as.data.frame(t(dat[, -1]))
    names(newdata) <- dat[[1]]

    y <- switch(input$transform,
      sqrt = sqrt(ref[, 1]),
      cbrt = (ref[, 1])^(1/3),
      ref[, 1]
    )

    model <- earth::earth(x = x, y = y)
    rsq <- round(model$grsq, digits = 4)
    estage <- predict(model, newdata = newdata)

    estage <- switch(input$transform,
      sqrt = round(estage^2, digits = 2),
      cbrt = round(estage^3, digits = 2),
      round(estage, digits = 2)
    )

    message <- c()
    message[1] <- estage
    message[2] <- rsq
    return(message)
  })


 output$age <- renderText({
   if(is.null(refsamp())) return(paste(h5("Input insufficient")))

   estage <- earth_mod()[1]
   if(is.null(estage)) return(print(""))
   message <- paste(h5("Estimated age:"), h3(estage), sep = " ")
   return(message)
 })


 output$rsq <- renderText({
   if(is.null(refsamp())) return(print(""))

   rsq <- earth_mod()[2]
   if(is.null(rsq)) return(print(""))
   message <- paste(h5("Model R^2:"), h3(rsq), sep = " ")
   return(message)
 })


 output$sampsize <- renderText({
   if(is.null(refsamp())) return(print(""))

   samp <- nrow(refsamp())
   message <- paste(h5("Sample size:"), h3(samp), sep = " ")
   return(message)
 })



})
