#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(leaflet)
library(raster)
library(rgeos)
library(shiny)
library(tidyverse)
library(data.table)
library(lubridate)
library(fs)
library(rgdal)
library(chron)
library(shinythemes)

cab_data18 <- read_rds("taxi_data")

ui <- fluidPage(theme = shinytheme("cerulean"), 
              
   navbarPage("NYC Taxi Commission Analysis",
              
      tabPanel("Distribution Map of NYC",
               
        sidebarLayout(
      
           sidebarPanel(
        
             selectInput("pick", "Pickup/Dropoff Zone: ", choices = c("Pickup", "Dropoff"), selected = "Pickup")

           ),
         
      
         
      
      # Show a plot of the generated distribution
          mainPanel(
            leafletOutput("taxiMap")
          )
        )
      ),
      
      tabPanel("Tipping Analysis",
               
        sidebarLayout(
          
          sidebarPanel(
            
            selectInput("model", "Independent Variable: ", choices = c("Ride Distance", "Pickup Time", "Number of Passengers"), selected = "Ride Distance"),
            tags$h5(helpText("Please select a factor to analyze relationship with the amount passengers tip their cab driver.")),
            tags$h6(helpText("Distance refers to the length, in miles, of the ride,",
                             "Pickup Time refers to how much time the ride took from pickup to dropoff,",
                             "Number of Passengers refers to whether the passenger hailed a cab alone or with another person/group of people.")),
            # br() element to introduce extra vertical spacing
            br()
          ),
          
          mainPanel(
            plotOutput("tipPlot")
          )
        )
      ),
      tabPanel("Stat Analysis",
      
        sidebarLayout(
          
          mainPanel(
            
          )
        )
                       

        
      )
   )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$taxiMap <- renderLeaflet({
     tiles <- readOGR("taxi_zones", "taxi_zones")
     
     projection(tiles) = "+init=epsg:2263"
     tiles2 = spTransform(tiles, "+init=epsg:4326")
     
     labels <- tiles2$zone

     ride_type <- reactive({
       if (input$pick == "Pickup") {
         zone_count <- cab_data18 %>%
           dplyr::select(V8, V9) %>%
           complete(V9 = 1:263) %>%
           count(V9)
       } else if (input$pick == "Dropoff") {
         zone_count <- cab_data18 %>%
           dplyr::select(V8, V9) %>%
           complete(V9 = 1:263) %>%
           count(V9)
       }
       return(zone_count$n)
     })
     
     col <- reactive({
       if (input$pick == "Pickup") {
         col = "Blues"
       } else if (input$pick == "Dropoff") {
         col = "Reds"
       }
       return(col)
     })
 
     zone_count <- log(ride_type(), base = 10)
     
     tiles2@data <- tiles2@data %>%
       mutate(count = zone_count)
     
     pal <- colorNumeric(
       palette = col(),
       domain = tiles2$count)
     
     leaflet(tiles2) %>% 
       addTiles() %>% 
       addPolygons(fillOpacity = 0.75, weight = 3, label = labels, color = ~pal(count),
                   highlightOptions = highlightOptions(color = "white", weight = 5, bringToFront = TRUE))
     
   })
   
     x <- reactive({
       req(input$model)
       if (input$model == "Payment Type") {
         x_label <- "Payment Type"
       } else if (input$model == "Ride Distance") {
         x_label <- "Ride Distance"
       } else if (input$model == "Number of Passengers") {
         x_label <- "Number of Passengers"
       } else if (input$model == "Time of Pickup") {
         x_label <- "Time of Pickup"
       }
       })
     
     tips <- cab_data18 %>%
       mutate(V3 = as.POSIXct(V3, tz = "", format = "%Y-%m-%d %H:%M:%OS")) %>%
       separate("V3", into = c("date", "time"), sep = " ") %>%
       rename("Time of Pickup" = time, "Number of Passengers" = V4, "Ride Distance" = V5, "Payment Type" = V10, "tip" = V14, "total" = V17) %>%
       mutate(tip_per = tip / total) 
     
     mean_tip_per <- tips %>%
       na.omit(tip_per) %>%
       summarize(mean(tip_per)) 
     
     mean_tip <- tips %>%
       summarize(mean(tip))
     
     cash_tip_per <- tips %>%
       na.omit(tip_per) %>%
       filter("Payment Type" == "2") %>%
       summarize(mean(tip_per)) 

     card_tip_per <- tips %>%
       na.omit(tip_per) %>%
       filter("Payment Type" == "1") %>%
       summarize(mean(tip_per))
     
     output$tipPlot <- renderPlot({
       if (input$model == "Number of Passengers") {
         
         tips %>%
           filter(!is.na(`tip_per`),
                  `Number of Passengers` != "0") %>%
           group_by(`Number of Passengers`) %>%
           summarize(n = mean(tip)) %>%
           ggplot(aes(x = `Number of Passengers`, y = n)) +
           geom_col() +
           labs(x = "Number of Passengers", y = "Average Tip in $", title = "Average Tip by Number of Passengers per Ride", caption = "Data from NYc Taxi Commission")
         
       }
       else if (input$model == "Ride Distance") {
         
         tips %>%
           ggplot(aes(x = `Ride Distance`, y = tip)) +
           geom_point() +
           geom_smooth(method = "lm") +
           labs(x = "Ride Distance", y = "Tip in $", title = "Tip Amount by Ride Distance", caption = "Data from NYc Taxi Commission")
         
       }
       else if (input$model == "Pickup Time") {
         
         tips %>%
           mutate(`Time of Pickup` = as.numeric(chron(times=`Time of Pickup`))) %>%
           ggplot(aes(x = `Time of Pickup`, y = tip)) +
           geom_point() +
           labs(x = "Time of Pickup", y = "Tip in $", title = "Tip Amount by Pickup Time", caption = "Data from NYc Taxi Commission") +
           geom_smooth(method = "lm")
         
       }
     })

}

# Run the application 
shinyApp(ui = ui, server = server)

