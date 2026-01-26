# Script para a pratica de germinacao
# Ecofisiologia vegetal
# Felipe Cordeiro, Felipe Fernandes, Ivone Nascimento, Jaderson Coriolano, Joyce Micaely, Juliana Fonseca, Letícia Gonçalves
# Script 1
# R 4.5.1

# Inicio ------------------------------------------------------------------

## Bibliotecas ----
library(ggplot2)
library(dplyr)

## Importando os dados ----
dados <- read.csv('./dados.csv', header = T, sep = ',')

### Configurando os dados ----
dados <- dados |> 
  mutate(
    Réplica = factor(Réplica),
    Semente = factor(Semente),
    Tratamento = factor(Tratamento)
  )

#### Conferindo ----
str(dados)

## Separando por semente ----
carolina <- dados |> filter(Semente == 'Carolina')
mororo <- dados |> filter(Semente == 'Mororó')

# Graficos ----------------------------------------------------------------

grafico <- function(objeto, cor_1, cor_2, semente) {
  controle <- objeto |> filter(Tratamento == 'Controle')
  escarificada <- objeto |> filter(Tratamento == 'Escarificada')
  data <- data.frame(
    tratamento = c('Controle', 'Escarificação'),
    media = c(
      mean(controle$Germinadas),
      mean(escarificada$Germinadas)
    ),
    ep = c(
      sd(controle$Germinadas) / sqrt(length(controle$Germinadas)),
      sd(escarificada$Germinadas) / sqrt(length(escarificada$Germinadas))
    )
  )
  plotar <- ggplot(data, aes(tratamento, media)) +
    geom_col(
      fill = c(cor_1, cor_2),
      colour = 'black'
    ) +
    geom_errorbar(
      aes(
        ymin = media - ep,
        ymax = media + ep
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

grafico(carolina, 'red', 'pink', 'Carolina')
grafico(mororo, 'brown', 'beige', 'Mororó')

# Analises ----------------------------------------------------------------

## Carolina ----
aov_carolina <- aov(Germinadas ~ Tratamento, carolina)
summary(aov_carolina)

## Mororo ----
aov_mororo <- aov(Germinadas ~ Tratamento, mororo)
summary(aov_mororo)
