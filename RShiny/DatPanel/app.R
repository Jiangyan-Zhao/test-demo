## 中心极限定理Shiny app
library(shiny)
library(tidyverse)

ui = fluidPage(
  titlePanel("演示中心极限定理"),
  sidebarLayout(position = "right", # 放到右侧
                sidebarPanel(
                  selectInput("distr", "分布：",
                              c("均匀", "二项", "泊松", "指数")),
                  sliderInput("samples", "随机变量数：", 1, 100, 10, step = 1),
                  sliderInput("nsim", "模拟样本量：", 1000, 10000, 1000, step = 100),
                  sliderInput("bins", "条形数", min = 10, max = 100, value = 50),
                  helpText("说明：从下拉选项选择分布, 并用滑动条选择
随机变量数和模拟样本量.")),
mainPanel(plotOutput("plot")))
)

server = function(input, output) {
  Xbar = reactive({
    n = input$samples # 随机变量个数
    m = input$nsim # 模拟样本量
    xs = switch(input$distr,
                "均匀" = runif(m * n, 0, 1),
                "二项" = rbinom(m * n, 10, 0.3),
                "泊松" = rpois(m * n, 5),
                "指数" = rexp(m * n), 1)
    data.frame(x = rowMeans(matrix(xs, ncol = n)))
  })
  output$plot = renderPlot({
    ggplot(Xbar(), aes(x)) +
      geom_histogram(alpha = 0.2, bins = input$bins,
                     fill = "steelblue", color = "black")
  })
}

shinyApp(ui = ui, server = server)