# Título: SAZONALIDADE DA SOJA BRASILEIRA
# Autor: Relatório por: Ricardo Aguirre Leal (ricardo.leal@furg.br)
# Data: Versão 1.0 -- format(Sys.time(), "%d de %B de %Y")

# Bibliotecas
library(readxl)
library(seasonal)
library(seasonalview)
library(strucchange)
library(vars)
library(strucchange)
# ---------
# Tydiverse:
library(dplyr)
library(ggplot2)
# ---------
library(magrittr) # MASKED '%>%' from dplyr; 'extract' from tidyr; and 'set_names' from purrr


# Caminho dos dados
main_dir <- getwd()
exp_path <- file.path(main_dir, "exportacao.xlsx")

# Leitura dos dados
export <- read_xlsx(exp_path)

# Cabeçalho das tabelas de dados
head(export)

# Função para criar as séries de tempo
f_ts <- function(x, a, m) ts(x, start = c(a, m), freq = 12)

# Série temporal
ts_export = f_ts(select(export, 5), a=export$ano[1], m=1)

# Ajuste sazonal via X13-Arima com transformação log
seas_export = seas(ts_export, transform.function = "log", x11 = "")
summary(seas_export)

### Sazonalidade da exportação de soja: Quantidade exportada
# Usando sazonalidade constante, tipo multiplicativa
autoplot(decompose(ts_export, type="multiplicative"))
# Usando sazonalidade constante, tipo aditiva
autoplot(decompose(ts_export, type="additive"))
# Usando sazonalidade variando no tempo, com X13_ARIMA/SEATS
autoplot(seas_export)

ssazon = seas_export$series$d10
autoplot(ssazon)
ggmonthplot(ssazon)

### Ajustando modelo ARIMA e sazonalidade manualmente (seas)
regarima1 = view(seas_export)

### Ajustando modelo ARIMA automaticamente
(regarima1 = auto.arima(select(export, 5), seasonal = T, ) %>% summary())

### Definindo modelo SARIMA manualmente
(regarima3 = arima(x = select(export, 5), c(2,1,1), seasonal = c(1,0,0)))
(regarima4 = arima(x = select(export, 5), c(2,1,1), seasonal = c(0,0,0)))

# ---------
# Testes de ajuste dos modelo
Acf(ts_export, 36)
Pacf(ts_export, 36)

Acf(resid(seas_export))
Pacf(resid(seas_export))

Acf(resid(regarima1))
Pacf(resid(regarima1))

shapiro.test(resid(regarima1))
shapiro.test(resid(seas_export))
hist(resid(seas_export))
# um valor de p < 0.05 indica que você rejeitou a hipótese nula
# ou seja, seus dados não possuem distribuição normal

time_index = 1:length(ts_export)
efp_res <- efp(ts_export ~ time_index)
plot(efp_res)
# (H0): Não há diferença nos parâmetros do modelo 
# antes e depois do ponto de quebra.


