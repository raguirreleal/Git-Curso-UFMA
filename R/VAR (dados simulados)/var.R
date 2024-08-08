# Título: VAR (dados simulados)
# Autor: Ricardo Aguirre Leal (ricardo.leal@furg.br)
# Data: Versão 1.0 -- format(Sys.time(), "%d de %B de %Y")

library(vars)
library(tseries)
library(lmtest)

# 1. Simulando dados econômicos
set.seed(123)
pib <- cumsum(rnorm(100, mean = 0.5, sd = 0.1)) + 100  # Simulação simplificada de PIB
taxa_juros <- cumsum(rnorm(100, mean = 0, sd = 0.1)) + 5  # Simulação de taxa de juros
inflacao <- cumsum(rnorm(100, mean = 0.2, sd = 0.05)) + 2  # Simulação de inflação

dados_economicos <- data.frame(pib, taxa_juros, inflacao)

# Teste de Raiz Unitária
adf.test(pib)
adf.test(taxa_juros)
adf.test(inflacao)

# Teste de Cointegração
ca.jo <- ca.jo(dados_economicos, type = "trace", ecdet = "const", K = 2)
summary(ca.jo)


# 2. Criando o modelo VAR
modelo_var1 <- VAR(dados_economicos, type = "both", lag.max = 4)
modelo_var2 <- VAR(dados_economicos, type = "const", lag.max = 4)
# type = c("const", "trend", "both", "none")
# lag.max: Integer, determines the highest lag order for lag length selection 
summary(modelo_var1)
summary(modelo_var2)

# 4. Diagnósticos adicionais - Verificação de estabilidade
plot(stability(modelo_var2))

# Teste de Portmanteau para Autocorrelação Residual
serial.test(modelo_var2)
# (H0) do serial.test é que não existe autocorrelação serial nas resíduos 

# 5. Resposta ao Impulso 
plot(irf(modelo_var, impulse = "taxa_juros", response = "pib"))
plot(irf(modelo_var, impulse = "taxa_juros", response = "inflacao"))

# 6. Decomposição da Variância do Erro de Previsão
plot(fevd(modelo_var, n.ahead = 10))

