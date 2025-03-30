#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#


fluidPage(
  titlePanel("Permutation Test & Bootstrapping"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("n", "Sample Size per Group:", min = 10, max = 100, value = 30),
      numericInput("mean_diff", "True Mean Difference:", value = 1, step = 0.1),
      numericInput("n_perm", "Number of Permutations:", value = 1000, step = 100),
      actionButton("go", "Run Simulation")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Permutation Test",
                 br(),
                 p("This app demonstrates the difference between permutation testing and bootstrapping."),
                 plotOutput("perm_plot"),
                 br(),
                 plotOutput("boot_plot"),
                 br(),
                 verbatimTextOutput("perm_pvalue"),
                 verbatimTextOutput("boot_ci")
        )
      )
    )
  )
)
