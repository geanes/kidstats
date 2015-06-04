shinyUI(navbarPage(title = div(icon("child"), "kidstats"), windowTitle = "kidstats", theme = shinythemes::shinytheme("united"),
                   position = "fixed-top", inverse = TRUE, collapsible = TRUE,
                   header = tags$style(type = "text/css", "body {padding-top: 70px; padding-bottom: 70px;}"),
                   footer = HTML("
                     <div class = 'navbar navbar-inverse navbar-fixed-bottom'>
                       <div class = 'navbar-inner'>
                         <div class = 'container footer-margin-top'>
                           <span class = 'pull-right' style = 'color: white; padding-top: 10px;'>&copy; Kyra Stull  2014</span>
                         </div>
                       </div>
                     </div>"),
  tabPanel("Input", value = "input", icon = icon("gear"),
# Sidebar
    sidebarPanel(
      selectizeInput("refsamp", "Reference Sample", choices = c("South Africa" = "za"), selected = "za", multiple = TRUE, width = "200px"),
     # fileInput("refsamp", label = "Reference data"),
      radioButtons("transform", label = "Transformation",
        choices = list("None" = "none", "Square root" = "sqrt", "Cube root" = "cbrt"),
        selected = "none"),
     br(),
     actionButton("evaluate", "Evaluate", icon = icon("calculator"))
    ),
# Main panel
   mainPanel(fluidRow(column(10, offset = 1, tableOutput("el_table"))),
   hr(),
# quick results panel
    fluidRow(
      column(1),
      column(2, htmlOutput("lwr")),
      column(2, htmlOutput("age")),
      column(2, htmlOutput("upr")),
      column(1),
      column(2, htmlOutput("rsq")),
      column(2, htmlOutput("sampsize"))
    ))
  ),

# Output Panel
 tabPanel("Output", icon = icon("file"),
          sidebarPanel(
            radioButtons('format', 'Report Format', c('PDF', 'HTML', 'Word'), inline = TRUE),
            downloadButton('downloadReport')
          ),
          mainPanel()
 ),

# Reference Sample table
  tabPanel("Reference Sample", icon = icon("table"), fluidRow(
    column(10, offset = 1, DT::dataTableOutput("table"))
  )),

# About Panel
 tabPanel("About", icon = icon("info-circle"),
    tabsetPanel(
      tabPanel("Overview", includeMarkdown(system.file('ksapp/www/md/overview.md', package = 'kidstats'))),
      tabPanel("Operation", includeMarkdown(system.file('ksapp/www/md/operation.md', package = 'kidstats'))),
      tabPanel("Measurements", includeMarkdown(system.file('ksapp/www/md/measurements.md', package = 'kidstats'))),
      tabPanel("Statistics", includeMarkdown(system.file('ksapp/www/md/statistics.md', package = 'kidstats'))),
      tabPanel("References", includeMarkdown(system.file('ksapp/www/md/references.md', package = 'kidstats')))
    )
 )
))
