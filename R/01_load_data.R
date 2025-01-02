# Configuración inicial del proyecto
if (!require("renv")) install.packages("renv")
renv::init()

# Instalar y cargar paquetes necesarios
packages <- c(
  "tidyverse",  # Para manipulación de datos
  "readxl",     # Para leer archivos Excel
  "sf",         # Para datos geográficos
  "here",       # Para manejo de rutas
  "DiagrammeR", # Para diagramas ER
  "usethis"     # Para configuración de Git
)

# Instalar paquetes faltantes
new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

# Cargar paquetes
lapply(packages, library, character.only = TRUE)

# Configurar Git
usethis::use_git()

# Guardar información de la sesión
sessionInfo_content <- capture.output(sessionInfo())
writeLines(sessionInfo_content, "docs/session_info.md")
