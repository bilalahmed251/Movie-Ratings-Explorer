library(shiny)
library(ggplot2)
library(dplyr)

data_file = read.csv("movies.csv")

clean_data = data_file %>%
  filter(!is.na(imdb_rating), !is.na(audience_score), !is.na(mpaa_rating))

ui = fluidPage(
  titlePanel("Movie Ratings Explorer"),
  sidebarLayout(
    sidebarPanel(
      selectInput("x_var", "X-Axis:", choices = names(clean_data), selected = "imdb_rating"),
      selectInput("y_var", "Y-Axis:", choices = names(clean_data), selected = "audience_score"),
      selectInput("group_by", "Color By:", choices = c("mpaa_rating", "title_type", "genre"), selected = "mpaa_rating"),
      sliderInput("transparency", "Opacity:", min = 0.1, max = 1, value = 0.8),
      sliderInput("point_size", "Point Size:", min = 1, max = 8, value = 3)
    ),
    mainPanel(
      plotOutput("scatter_plot")
    )
  )
)

server = function(input, output) {
  output$scatter_plot = renderPlot({
    ggplot(clean_data, aes(x = .data[[input$x_var]], y = .data[[input$y_var]], color = .data[[input$group_by]])) +
      geom_point(alpha = input$transparency, size = input$point_size) +
      theme_minimal() +
      labs(x = input$x_var, y = input$y_var, color = input$group_by)
  })
}

shinyApp(ui = ui, server = server)
