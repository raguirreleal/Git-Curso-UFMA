# Script R para Análise das Exportações de Feijão em 2022

# 1. Instalar e carregar os pacotes necessários
install.packages("ggplot2")
install.packages("dplyr")
library(ggplot2)
library(dplyr)

# 2. Criar um data frame fictício com os dados de exportação
feijao_exportacao <- data.frame(
  País = c("Estados Unidos", "Venezuela", "Cuba", "Índia", "África do Sul"),
  Volume_Ton = c(50, 30, 25, 20, 25),
  Tipo_Feijao = c("Feijão Preto", "Feijão Carioca", "Feijão Preto", "Feijão Mungo", "Feijão Verde")
)

# 3. Exibir o resumo dos dados
print("Resumo das Exportações de Feijão em 2022")
print(feijao_exportacao)

# 4. Calcular o volume total exportado
volume_total_feijao <- sum(feijao_exportacao$Volume_Ton)
print(paste("Volume Total Exportado (em toneladas):", volume_total_feijao))

# 5. Criar um gráfico de barras para os principais destinos
ggplot(feijao_exportacao, aes(x = reorder(País, -Volume_Ton), y = Volume_Ton, fill = Tipo_Feijao)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Exportações de Feijão por País em 2022",
       x = "País",
       y = "Volume Exportado (Toneladas)") +
  geom_text(aes(label = Volume_Ton), vjust = -0.5)

# 6. Análise do impacto da produção interna
# Dados fictícios de produção interna
producao_interna <- data.frame(
  Mês = factor(c("Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"), 
               levels = c("Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez")),
  Producao_Mil_Ton = c(250, 260, 240, 230, 220, 210, 200, 190, 180, 170, 160, 150)
)

# Gráfico de linha da produção interna ao longo de 2022
ggplot(producao_interna, aes(x = Mês, y = Producao_Mil_Ton)) +
  geom_line(color = "darkgreen", size = 1) +
  geom_point(color = "blue", size = 2) +
  theme_minimal() +
  labs(title = "Produção Interna de Feijão em 2022",
       x = "Mês",
       y = "Produção (Mil Toneladas)")

# 7. Conclusão sobre o impacto das exportações e produção interna
print("A análise mostra que as exportações de feijão foram modestas em 2022, com a maior parte da produção destinada ao consumo interno.")

