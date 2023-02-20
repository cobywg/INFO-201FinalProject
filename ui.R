library(bslib)
library(markdown)
library(plotly)



# Load Data Frame
instagram_data <- read.csv("data/instagram-global-top-1000.csv", stringsAsFactors = FALSE)

# Home Page
intro_tab <- tabPanel(
  "Introduction",
  fluidPage(
    includeMarkdown("intro.md"),
  )
)

# Make sure only unique options are available
unique_country1 <- unique(instagram_data$Audience.Country)

# Widget for Chart 1
chart1_widget <- selectInput(inputId = "chart1_widget",
                             label = "Select Country",
                             choices = unique_country1,
                             selected = unique_country1[1],
                             multiple = TRUE)

# Chart 1
chart1_tab <- tabPanel(
  "Chart 1",
  fluidRow(column(chart1_widget, width = 8)),
  fluidRow(column(plotlyOutput(outputId = "chart1"), width = 12)),
  textOutput(outputId = "message1"))

# Widget for Chart 2

country_unique <- unique(instagram_data$Audience.Country)

country_check <- selectInput(inputId = "country_dropdown", 
                             label = "Countries",
                             choices = country_unique,
                             selected = country_unique[1],
                             multiple = TRUE)

# Chart 2
chart2_tab <- tabPanel("Chart 2",
                       sidebarLayout(
                         sidebarPanel(country_check),
                         mainPanel(plotlyOutput("scatter_plot"),
                                   textOutput(outputId = "explanation")
                         )
                       )
)


# Widget for Chart 3
eng_check <- radioButtons(
    inputId = "user_selection_line",
    label = "Engagment Selection",
    choices = c("Engagement Average"= 1, "Authentic Engagement" = 2),
    selected = 1
  )

main_panel_plot <- mainPanel(
  plotlyOutput("influencer_plot")
)

chart3_tab <- tabPanel(
  "Chart 3",
  sidebarLayout(
    sidebarPanel(eng_check),
    main_panel_plot,
  ),
  fluidPage(includeMarkdown("linegraph.md"))
)


# Conclusion Page
conclusion_tab <- tabPanel(
  "Conclusion",
  fluidPage(
    includeMarkdown("conclusion.md"),
  )
)

# Theme
my_theme <- bs_theme(bg = "#0b3d91",
                     fg = "white",
                     primary = "#FCC780")

my_theme <- bs_theme_update(my_theme,
                            bootswatch = "minty")

ui <- navbarPage(
  theme = my_theme,
  h2(strong("Influencers Worldwide")),
  intro_tab,
  chart1_tab,
  chart2_tab,
  chart3_tab,
  conclusion_tab
)
