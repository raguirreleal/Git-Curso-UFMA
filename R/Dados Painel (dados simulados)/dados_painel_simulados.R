# Título: MODELO DADOS PAINEL (simulados)
# Autor: Relatório por: Ricardo Aguirre Leal (ricardo.leal@furg.br)
# Data: Versão 1.0 -- format(Sys.time(), "%d de %B de %Y")

# Instalar e carregar o pacote necessário
library(plm)

# 1. Simulando dados
set.seed(123)
countries = paste0("Country", 1:20)
years <- 2000:2009
data <- expand.grid(country = countries, year = years)

# Suponha que temos variáveis de interesse: PIB e Investimento em Educação
data$gdp <- rnorm(nrow(data), mean = 50000, sd = 500)
data$education_investment <- rnorm(nrow(data), mean = 2000, sd = 10)

# Adicionando efeito da política educacional
# Suponhamos que Country1 e Country2 implementaram novas políticas em 2005
data$policy_effect = 
  with(data, (country %in% c("Country1", "Country2") & year >= 2005) * 
         rnorm(nrow(data), mean = 1000, sd = 500))

# 2. Criando o modelo de dados em painel
pdata <- pdata.frame(data, index = c("country", "year"))

# Ajustar um modelo de efeitos fixos para ver o impacto do investimento em educação e política sobre o PIB
panel_model <- plm(gdp ~ education_investment + policy_effect, data = pdata, model = "within")

# 3. Análise e interpretação dos resultados
summary(panel_model)

# 4. Verificando diagnósticos adicionais
# Hausman Test
phtest(panel_model, plm(gdp ~ education_investment + policy_effect, data = pdata, model = "pooling"))  # Teste Hausman para escolha entre efeitos fixos e aleatórios
# Teste RESET para modelos de painel
plmtest(panel_model)
