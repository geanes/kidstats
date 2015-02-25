#' @import shiny
shinyUI(
  navbarPage("kidstats", id = "nav", windowTitle = "kidstats", collapsable = FALSE,
   inverse = TRUE, theme = "kidstats_bootstrap.css", fluid = FALSE,

  footer=HTML("
    <div class = 'navbar navbar-inverse navbar-fixed-bottom' style='line-height:30px; height:30px;'>
      <div class = 'navbar-inner'>
        <div class = 'container footer-margin-top'>
          <p class = 'pull-right' style='color: white;'>&copy; Kyra Stull  2014</p>
        </div>
      </div>
    </div>"),


  tabPanel("Input", value = "input",


  fluidPage(

  wellPanel(
  fluidRow(
    column(4, fileInput("refsamp", label = h4("Reference data"))),
    column(1, offset = 1, br(),
      checkboxInput("all", label = strong("All"), value = FALSE),
      checkboxInput("femur", label = strong("Femur"), value = FALSE),
      checkboxInput("tibia", label = strong("Tibia"), value = FALSE)),
    column(1, br(),
      checkboxInput("humerus", label = strong("Humerus"), value = FALSE),
      checkboxInput("radius", label = strong("Radius"), value = FALSE),
      checkboxInput("ulna", label = strong("Ulna"), value = FALSE)),
    column(3, offset = 2,
      radioButtons("transform", label = h4("Transformation"),
        choices = list("None" = "none", "Square root" = "sqrt", "Cube root" = "cbrt"),
        selected = "none")
    )
  )),

  wellPanel(

  conditionalPanel("input.all == false & input.femur == false & input.tibia == false & input.humerus == false & input.radius == false & input.ulna == false",
    fluidRow(column(6, offset = 4, "Choose element(s) above."))
  ),

  # fluidRow(column(4, offset = 4, "(Measurements in mm)")),

  conditionalPanel("input.all == true | input.femur == true | input.tibia == true | input.humerus == true | input.radius == true | input.ulna == true",
  fluidRow(
  column(2, offset = 1, h5(style = "line-height = 10", "Maximum length")),
  column(2, offset = 1, h5(style = "line-height = 10", "Proximal breadth")),
  column(2, offset = 1, h5(style = "line-height = 10", "Mid-shaft breadth")),
  column(2, offset = 1, h5(style = "line-height = 10", "Distal breadth"))
  )),

  conditionalPanel("input.femur == true | input.all == true",
  fluidRow(
    column(1, h5("Femur")),
    column(2,
           numericInput("fmxl", label = "", value = NA, min = 0, max = 1000, step = 1)),
    # column(2, offset = 1,
    #       numericInput("fpb", label = "", value = NA, min = 0, max = 1000, step = 1)),
    column(2, offset = 4,
           numericInput("fmsb", label = "", value = NA, min = 0, max = 1000, step = 1)),
    column(2, offset = 1,
           numericInput("fdb", label = "", value = NA, min = 0, max = 1000, step = 1))
  )),


  conditionalPanel("input.tibia == true | input.all == true",
  fluidRow(
    column(1, h5("Tibia")),
    column(2,
           numericInput("tmxl", label = "", value = NA, min = 0, max = 1000, step = 1)),
    column(2, offset = 1,
           numericInput("tpb", label = "", value = NA, min = 0, max = 1000, step = 1)),
    column(2, offset = 1,
           numericInput("tmsb", label = "", value = NA, min = 0, max = 1000, step = 1)),
    column(2, offset = 1,
           numericInput("tdb", label = "", value = NA, min = 0, max = 1000, step = 1))
  )),


  conditionalPanel("input.humerus == true | input.all == true",
  fluidRow(
    column(1, h5("Humerus")),
    column(2,
           numericInput("hmxl", label = "", value = NA, min = 0, max = 1000, step = 1)),
    column(2, offset = 1,
           numericInput("hpb", label = "", value = NA, min = 0, max = 1000, step = 1)),
    column(2, offset = 1,
           numericInput("hmsb", label = "", value = NA, min = 0, max = 1000, step = 1)),
    column(2, offset = 1,
           numericInput("hdb", label = "", value = NA, min = 0, max = 1000, step = 1))
  )),


  conditionalPanel("input.radius == true | input.all == true",
  fluidRow(
    column(1, h5("Radius")),
    column(2,
           numericInput("rmxl", label = "", value = NA, min = 0, max = 1000, step = 1)),
    column(2, offset = 1,
           numericInput("rpb", label = "", value = NA, min = 0, max = 1000, step = 1)),
    column(2, offset = 1,
           numericInput("rmsb", label = "", value = NA, min = 0, max = 1000, step = 1)),
    column(2, offset = 1,
           numericInput("rdb", label = "", value = NA, min = 0, max = 1000, step = 1))
  )),


  conditionalPanel("input.ulna == true | input.all == true",
  fluidRow(
    column(1, h5("Ulna")),
    column(2,
           numericInput("umxl", label = "", value = NA, min = 0, max = 1000, step = 1)),
    column(2, offset = 4,
           numericInput("umsb", label = "", value = NA, min = 0, max = 1000, step = 1))
  ))),

  br(),br(), br(), br(),

  absolutePanel(bottom = 30, left = 0, right = 0, fixed = TRUE,
  div(style="padding: 4px; border-top: 1px solid #CCC; background: #FFFFEE;",
  fluidRow(
    # column(2,  actionButton("estimate", label = "Estimate age")),
    column(3, offset = 1, htmlOutput("age")),
    column(3, offset = 1, htmlOutput("rsq")),
    column(3, offset = 1, htmlOutput("sampsize"))
    )))

)),


# tabPanel("Output", fluidRow(
#
# )),

tabPanel("Reference Sample", fluidRow(
  dataTableOutput("table")
)),


# tabPanel("About", fluidRow(
#   column(12, includeMarkdown("about.md"))
# )),

br(), br()


))


