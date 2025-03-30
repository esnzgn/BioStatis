#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
source("./sys_req.R")
# Define server logic required to draw a histogram
function(input, output, session) {
    
    observeEvent(input$go, {
      set.seed(123)
      group1 <- rnorm(input$smpl_siz, mean = 0, sd = 1)
      group2 <- rnorm(input$smpl_siz, mean = input$mean_diff, sd = 1)
      
      # group1 <- rnorm(100, mean = 0, sd = 1)
      # group2 <- rnorm(100, mean = 2, sd = 1)
      
      original_diff <- mean(group2) - mean(group1)
      combined <- c(group1, group2)
      
      # Permutation Test
      perm_diffs <- replicate(input$n_perm, {
        shuffled <- sample(combined)
        mean(shuffled[1:input$smpl_siz]) - mean(shuffled[(input$smpl_siz + 1):(2*input$smpl_siz)])
      })
      
      # Permutation Test
      # perm_diffs <- replicate(100, {
      #   shuffled <- sample(combined)
      #   mean(shuffled[1:100]) - mean(shuffled[(100 + 1):(2*100)])
      # })
      
      output$perm_plot <- renderPlot({
        ggplot(data.frame(perm_diffs), aes(x = perm_diffs)) +
          geom_histogram(color = "black", fill = "skyblue", bins = 30) +
          geom_vline(xintercept = original_diff, color = "red", linetype = "dashed") +
          labs(title = "Permutation Distribution", x = "Mean Differences", y = "Frequency")
      })
      
      p_value <- mean(c(abs(perm_diffs) >= abs(original_diff)))
      
      output$perm_pvalue <- renderPrint({
        cat("Permutation Test P-value:\n")
        cat(round(p_value, 4))
      })
      
      # Bootstrapping
      boot_diffs <- replicate(input$n_perm, {
        g1_boot <- sample(group1, replace = TRUE)
        g2_boot <- sample(group2, replace = TRUE)
        mean(g2_boot) - mean(g1_boot)
      })
      
      # boot_diffs <- replicate(100, {
      #   g1_boot <- sample(group1, replace = TRUE)
      #   g2_boot <- sample(group2, replace = TRUE)
      #   mean(g2_boot) - mean(g1_boot)
      # })
      
      output$boot_plot <- renderPlot({
        ggplot(data.frame(boot_diffs), aes(x = boot_diffs)) +
          geom_histogram(color = "black", fill = "orange", bins = 30) +
          geom_vline(xintercept = quantile(boot_diffs, c(0.025, 0.975)), color = "red", linetype = "dashed") +
          labs(title = "Bootstrap Distribution", x = "Mean Differences", y = "Frequency")
      })
      
      output$boot_ci <- renderPrint({
        ci <- quantile(boot_diffs, c(0.025, 0.975))
        cat("Bootstrapped 95% Confidence Interval:\n")
        print(round(ci, 4))
      })
    })
  }