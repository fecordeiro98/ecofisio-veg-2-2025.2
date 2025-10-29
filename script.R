#' Script para a prática de germinação
#' Ecofisiologia vegetal
#' Felipe Cordeiro, Felipe Fernandes, Ivone Nascimento, Jaderson Coriolano, Joyce Micaely, Juliana Fonseca, Letícia Gonçalves
#' Script 1
#' R 4.5.1

# Início ------------------------------------------------------------------

## Bibliotecas ####
library(ggplot2)
library(dplyr)

## Importando os dados ####
dados <- read.csv('./dados.csv', header = T, sep = ',')

### Configurando os dados ####
dados <- dados |> 
  mutate(
    Réplica = factor(Réplica),
    Semente = factor(Semente),
    Tratamento = factor(Tratamento)
  )

#### Conferindo ####
str(dados)

## Separando por semente ####
carolina <- dados |> filter(Semente == 'Carolina')
mororó <- dados |> filter(Semente == 'Mororó')

# Gráficos ----------------------------------------------------------------

gráfico <- function(objeto, cor1, cor2, semente) {
  controle <- objeto |> filter(Tratamento == 'Controle')
  escarificada <- objeto |> filter(Tratamento == 'Escarificada')
  data <- data.frame(
    tratamento = c('Controle', 'Escarificação'),
    média = c(
      mean(controle$Germinadas),
      mean(escarificada$Germinadas)
    ),
    ep = c(
      sd(controle$Germinadas) / sqrt(length(controle$Germinadas)),
      sd(escarificada$Germinadas) / sqrt(length(escarificada$Germinadas))
    )
  )
  plotar <- ggplot(data, aes(tratamento, média)) +
    geom_col(
      fill = c(cor1, cor2),
      colour = 'black'
    ) +
    geom_errorbar(
      aes(
        ymin = média - ep,
        ymax = média + ep
      ),
      width = 0.2,
      colour = 'blue'
    ) +
    labs(
      title = 'Germinação',
      subtitle = semente,
      x = 'Tratamento',
      y = 'Sementes germinadas'
    ) +
    theme_bw()
  ggsave(
    paste0('./gráficos/', semente, '.png'),
    plot = plotar,
    height = 3,
    width = 4,
    dpi = 300,
    scale = 1.25
  )
}

gráfico(carolina, 'red', 'pink', 'Carolina')
gráfico(mororó, 'brown', 'beige', 'Mororó')

# Análises ----------------------------------------------------------------

## Carolina ####
aovCarolina <- aov(Germinadas ~ Tratamento, carolina)
summary(aovCarolina)

## Mororó ####
aovMororó <- aov(Germinadas ~ Tratamento, mororó)
summary(aovMororó)
