library(shiny)
library(leaflet)
library(dplyr)
library(sf)

# Supondré que 'comunas_santiago' ya es un objeto sf con las columnas 'geometry' y 'nombre_comuna'

# Definir paleta
paleta <- c("#DCA761", "#CFB567", "#BFBC71", "#9EA887", "#819897")

# Interfaz de usuario
ui <- fluidPage(
  titlePanel("Visualización de Participación Electoral"),
  
  # Diseño con barra lateral
  sidebarLayout(
    sidebarPanel(
      h4("Configuración"),
      
      # Selector de comuna
      selectInput(inputId = "comuna",
                  label = "Selecciona una comuna:",
                  choices = unique(comunas_santiago$nombre_comuna),
                  selected = unique(comunas_santiago$nombre_comuna)[1])
    ),
    
    mainPanel(
      # Salida del mapa interactivo
      leafletOutput(outputId = "mapa"),
      
      # Texto explicativo
      tags$hr(),
      h4("Detalles"),
      p("Este gráfico muestra la participación electoral por comuna en la 2da vuelta de 2021. Ajusta la comuna con las opciones disponibles.")
    )
  )
)

# Lógica del Servidor
server <- function(input, output) {
  
  output$mapa <- renderLeaflet({
    # Filtrar la comuna seleccionada
    comuna_filtrada <- comunas_santiago %>% 
      filter(nombre_comuna == input$comuna)
    
    # Verificar si la geometría está presente
    if(nrow(comuna_filtrada) > 0) {
      
      # Crear el mapa interactivo con leaflet
      leaflet(data = comuna_filtrada) %>%
        addTiles() %>%
        addPolygons(
          fillColor = ~colorNumeric(palette = rev(paleta), domain = comuna_filtrada$participacion_comuna)(participacion_comuna),
          weight = 1,
          color = "black",
          fillOpacity = 0.7,
          popup = ~paste("Comuna:", nombre_comuna, "<br>Participación:", participacion_comuna, "%")
        ) %>%
        setView(lng = mean(st_coordinates(comuna_filtrada)[,1]), lat = mean(st_coordinates(comuna_filtrada)[,2]), zoom = 10)
      
    } else {
      # Si no hay datos, mostrar un mensaje de error
      leaflet() %>%
        addTiles() %>%
        addPopups(lng = -70.6483, lat = -33.4489, popup = "No hay datos para la comuna seleccionada.")
    }
  })
}

# Lanzar la aplicación
shinyApp(ui = ui, server = server)
