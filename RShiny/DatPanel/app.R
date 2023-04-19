## 探索性数据展板Shiny app

library(shiny)
library(tidyverse)

# 载入数据
load("data/ecostats.rda")
countries = unique(ecostats$Region)
# 用户界面
ui = fluidPage(
  titlePanel("交互探索ecostats 数据"),
  sidebarLayout( # 侧边栏带下拉选项选择地区
    sidebarPanel(
      selectInput("name", "选择地区：", choices = countries,
                  selected = "黑龙江")),
    mainPanel( # 主面板带图形和数据表的切换标签
      tabsetPanel(
        tabPanel("人均GDP 图", plotly::plotlyOutput("eco_plot")),
        tabPanel("数据表", DT::dataTableOutput("eco_data"))))
  )
)

# 定义服务器逻辑: 绘制折线图、创建数据表
server = function(input, output) {
  selected = reactive({
    ecostats %>%
      filter(Region == input$name)
  })
  # 绘制折线图
  output$eco_plot = plotly::renderPlotly({
    p = ggplot(selected(), aes(Year, gdpPercap)) +
      geom_line(color = "red", linewidth = 1.2) +
      labs(title = paste0(input$name, "人均GDP 变化趋势"),
           x = "年份", y = "人均GDP")
    plotly::ggplotly(p) # 渲染plotly 对象
  })
  # 创建数据表
  output$eco_data = DT::renderDataTable({
    DT::datatable(selected(), extensions = "Buttons",
                  caption = paste0(input$name, "数据"),
                  options = list(dom = "Bfrtip",
                                 buttons = c("copy", "csv", "excel", "pdf", "print")))
  })
}
# 运行App
shinyApp(ui = ui, server = server)