#' @import shiny
# library(shiny)
shinyUI(navbarPage(title = "kidstats", windowTitle = "kidstats", theme = shinythemes::shinytheme("united"),
                   position = "fixed-top", inverse = TRUE, collapsible = TRUE,
                   header = tags$style(type="text/css", "body {padding-top: 70px;}"),
  tabPanel("Input", value = "input",
# Sidebar
    sidebarPanel(
      selectizeInput("refsamp", "Reference Sample", choices = c("South Africa" = "za"), selected = "za", multiple = TRUE, width = "200px"),
     # fileInput("refsamp", label = "Reference data"),
      radioButtons("transform", label = "Transformation",
        choices = list("None" = "none", "Square root" = "sqrt", "Cube root" = "cbrt"),
        selected = "none"),
     br(),
     actionButton("evaluate", "Evaluate")
    ),
# Main panel
   mainPanel(fluidRow(column(10, offset = 1, tableOutput("el_table"))),
# quick results panel
    wellPanel(fluidRow(
      column(4, htmlOutput("age")),
      column(4, htmlOutput("rsq")),
      column(4, htmlOutput("sampsize"))
    )))
  ),
# tabPanel("Output", fluidRow(
#
# )),

# Reference Sample table
  tabPanel("Reference Sample", fluidRow(
    column(10, offset = 1, dataTableOutput("table"))
  ))

# tabPanel("About", fluidRow(
#   column(12, includeMarkdown("about.md"))
# ))
))
