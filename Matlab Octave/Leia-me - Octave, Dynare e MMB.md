# Link para download do Octave:
https://octave.org/
# Link para download do Dynare:
https://www.dynare.org/
# Link para download do Macroeconomic Model Data Base (MMB):
https://www.macromodelbase.com/

Sugestão: Instalar Octave, Dynare e MMB tudo junto, para garantir a compatibilidade e evitar configurações adicionais.
*Link para download Octave-Dynare-MMB no Windows:*
https://www.macromodelbase.com/download
...no botão "Download All-in-one installer (Windows)"
*Link para Guia do Usuário do MMB:*
https://www.macromodelbase.com/files/userguide.pdf?67881c1bad

----

# Calculando os modelos DSGE com o Dynare 
O arquivo "cap2_rbc.mod" contém o código em Dynare do modelo DSGE de Ciclos Reais de Negócios (RBC), constante no Cap 2 do livro do Celso Costa. Para executá-lo e obter os resultados de forma numérica e gráfica, siga os seguintes passos. 
**No Matlab:**
- Abra o Matlab e situe o diretório na pasta onde está o arquivo "cap2_rbc.mod". Você pode fazer isso de várias formas: através do módulo à esquerda "Current Folder", da barra de endereço ou (preferência) cliclando no ícone "Browse for folder" ao lado da barra de endereço, selecionando a pasta desejada.
- Digite, no módulo "Command Window" o comando "dynare cap2_rbc". Este comando irá executar o Dynare para o arquivo "cap2_rbc.mod". Aguarde o término do processamento e você verá os resultados neste mesmo módulo, nas variáveis, visíveis no módulo "Workspace" e na nova janela com o gráfico.
**No Octave**
- Abra o Octave e situe o diretório na pasta onde está o arquivo "cap2_rbc.mod". Você pode fazer isso de várias formas: assim como no Matlab, procure o módulo à esquerda e use as opções de navegação.
- Digite, no módulo "Janela de Comandos" o comando "dynare cap2_rbc". O resultado será assim como foi descrito para o Matlab.