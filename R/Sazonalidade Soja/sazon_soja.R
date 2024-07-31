# Título: SAZONALIDADE DA SOJA BRASILEIRA
# Autor: Relatório por: Ricardo Aguirre Leal (ricardo.leal@furg.br)
# Data: Versão 1.0 -- format(Sys.time(), "%d de %B de %Y")

# Bibliotecas
library(readxl)
library(fda)
library(KernSmooth)
library(foreach)
library(stargazer)
library(seasonal)
library(seasonalview) # "view" masked by tibble
library(dynlm)
library(tsDyn)
library(strucchange)
library(forecast)
library(vars)
# library(doParallel); (ncores=detectCores())
# library(beepr); library(iterators)
# library(foreign); library(visreg)
# ---------
# Tydiverse:
library(dplyr)
library(tidyr)
library(ggplot2)
library(tibble)
library(lubridate)
library(purrr)    # MASKED "accumulate"; and "when" from foreach
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
f_ts <- function(x, a, m) { 
  if(is.null(m)) {
    y <- ts(x, start = c(a), freq = 1) 
  } else
    y <- ts(x, start = c(a, m), freq = 12)
  return(y)
}

# Listas de séries temporais
lts_export <- lapply(select(export, -(1:3)), f_ts, a=export$ano[1], m=1)


# Ajuste sazonal via X13-Arima com transformação log
lseas_export <- lapply(lts_export, seas, transform.function = "log", x11 = "")


# Sazonalidade da exportação de soja: Quantidade exportada
autoplot(decompose(lts_export$qtd_exp, type="multiplicative"))
autoplot(lseas_export$qtd_exp)
ssazon = lseas_export$qtd_exp$series$d10
autoplot(ssazon)
ggmonthplot(ssazon)

zs_qtd_expl = ssazon %>% as.zooreg() %>% window(end=as.yearmon("2022-12"))
zs_qtd_expl %>% aggregate(month(.), mean)
zs_qtd_expl %>% aggregate(year(.),  mean)
(zs_min_qy = zs_qtd_expl %>% aggregate(year(.),  min)); autoplot(zs_min_qy)
(zs_max_qy = zs_qtd_expl %>% aggregate(year(.),  max)); autoplot(zs_max_qy)
(zs_amp_qy = zs_max_qy - zs_min_qy); autoplot(zs_amp_qy)


# ++++++++
num_anos <- length(ssazon) / frequency(ssazon)

msazon = foreach(i = 1:num_anos, .combine=cbind) %do% {
  ssazon[ (1+12*(i-1)) : (12*i) ]
}
dimnames(msazon) = list(1:12, start(ssazon)[1]:(end(ssazon)[1]))

# Configurações
kernel <- "epanech"  # "epanech","normal" etc
bandwidth <- "over"  # "stdev", "minim", "iqr" for direct plug-in methodology
# "over" for over smoothed bandwidth selector (Wand & Jones, 1995)
gridsize <- 1024 * 1    # points at which to estimate the density

ordem = 4         # ordem do spline [ = grau + 1 ]
nknots = 12      # qtd de nos, ou breaks
range_dens <- c(0, 3)  # min & max to compute the density

ybase = create.bspline.basis(c(1,12), nbasis=(nknots+ordem), norder=ordem)
fmsazon = Data2fd(1:12, msazon)

plot(fmsazon)

d1_fmsazon = deriv.fd(fmsazon, 1) # velocidade 
d2_fmsazon = deriv.fd(fmsazon, 2) # aceleração

fmsazon_m = mean.fd(fmsazon); plot(fmsazon_m)
d1_fmsazon_m = deriv.fd(fmsazon_m, 1) # velocidade 
d2_fmsazon_m = deriv.fd(fmsazon_m, 2) # aceleração

xdens = seq(1, 12, by = 0.01)
plot( eval.fd(xdens, d1_fmsazon),  eval.fd(xdens, d2_fmsazon), 
      type = "l", xlab="Velocidade (1ª deriv)", ylab="Aceleração (2ª deriv)")
abline(h=0, v=0, col = "red")
plot( eval.fd(xdens, d1_fmsazon_m),  eval.fd(xdens, d2_fmsazon_m), 
      type = "l", xlab="Velocidade (1ª deriv)", ylab="Aceleração (2ª deriv)")
abline(h=0, v=0, col = "red")

