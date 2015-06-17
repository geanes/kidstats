shinyUI(navbarPage(title = div(icon("child"), "KidStats"), windowTitle = "KidStats", theme = shinythemes::shinytheme("united"),
                   position = "fixed-top", inverse = TRUE, collapsible = TRUE,
                   header = tags$style(type = "text/css", "body {padding-top: 70px; padding-bottom: 70px;}"),
                   footer = HTML("
                     <div class = 'navbar navbar-inverse navbar-fixed-bottom'>
                       <div class = 'navbar-inner'>
                         <div class = 'container footer-margin-top'>
                           <span class = 'pull-left' style = 'padding-top: 5px;'><button id = 'exit_ks' type = 'button' class = 'btn btn-default action-button'><i class='fa fa-close'></i>Exit KidStats</button></span>
                           <span class = 'pull-right' style = 'color: white; padding-top: 10px;'>&copy; Kyra Stull  2014</span>
                         </div>
                       </div>
                     </div>"),
  tabPanel("Input", value = "input", icon = icon("gear"),
    # Sidebar
    sidebarPanel(
      selectizeInput("refsamp", "Reference Sample", choices = c("South Africa" = "za"), selected = "za", multiple = TRUE, width = "200px"),
      hr(),
      h4("Age"),
      radioButtons("transform", label = "Transformation",
        choices = list("None" = "none", "Square root" = "sqrt", "Cube root" = "cbrt"),
        selected = "none"),
      selectInput("ex_age", "Exclude from model:", multiple = TRUE, choices = c()),
      actionButton("evaluate_age", "Evaluate Age", icon = icon("calculator")),
      hr(),
      h4("Sex"),
      checkboxInput("bstrap_ca", label = "Bootstrap Classification Accuracy", value = FALSE),
      selectInput("ex_sex", "Exclude from model:", multiple = TRUE, choices = c()),
      actionButton("evaluate_sex", "Evaluate Sex", icon = icon("calculator"))
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
      ),
      hr(),
      fluidRow(
        column(1),
        column(3, htmlOutput("pred_f")),
        column(3, htmlOutput("pred_m")),
        column(1),
        column(2),
        column(2, htmlOutput("sampsize_sex"))
      )
    )
  ),

 # Output Panel
 tabPanel("Output", icon = icon("file"),
          sidebarPanel(
            # radioButtons('format', 'Report Format', c('PDF', 'HTML', 'Word'), inline = TRUE),
            radioButtons('format', 'Report Format', c('HTML', 'Word'), inline = TRUE),
            downloadButton('downloadReport')
          ),
          mainPanel(
            tabsetPanel(
              tabPanel("Age Estimation",
                  conditionalPanel(condition = "input.evaluate_age >= 1",
                    h2("Age Estimation"),
                    hr(),
                    verbatimTextOutput("earth_pred"),
                    verbatimTextOutput("earth_samp"),
                    hr(),
                    h4("Model Summary"),
                    verbatimTextOutput("earth_summary"),
                    h4("Variable Importance"),
                    verbatimTextOutput("earth_varimp"),
                    hr(),
                    h3("Diagnostic Plots"),
                    plotOutput("earth_modsel"),
                    plotOutput("earth_qq"),
                    plotOutput("earth_rvf")
                  )
              ),
              tabPanel("Sex Estimation",
                  conditionalPanel(condition = "input.evaluate_sex >= 1",
                    h2("Sex Estimation"),
                    hr(),
                    verbatimTextOutput("fda_pred"),
                    verbatimTextOutput("fda_samp"),
                    hr(),
                    h4("FDA Model Coefficients"),
                    verbatimTextOutput("fda_coef"),
                    h4("Variable Importance"),
                    verbatimTextOutput("fda_varimp"),
                    h4("Confusion Matrix"),
                    verbatimTextOutput("fda_confusion"),
                    h4("Classification Table"),
                    verbatimTextOutput("fda_ct"),
                    htmlOutput("fda_ca_title"),
                    verbatimTextOutput("fda_ca"),
                    plotOutput("fda_bca_plot")
                  )
              )
            )
          )
 ),

#   # Reference Sample table
#   tabPanel("Reference Sample", icon = icon("table"), fluidRow(
#     column(10, offset = 1, DT::dataTableOutput("table"))
#   )),

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
