# pip install pandas
# pip install selenium
# pip install webdriver-manager
# pip install openpyxl

import pandas as pd
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
from selenium.common.exceptions import TimeoutException

# Carregar a planilha
file_path = 'QualisEcon2020.xlsx'
df = pd.read_excel(file_path)

# Converter a coluna "Econ" para o tipo object para evitar problemas de tipo
df['Econ'] = df['Econ'].astype(object)

# Configurar o serviço do ChromeDriver usando webdriver-manager
service = Service(ChromeDriverManager().install())

# Configurar o driver do Chrome
driver = webdriver.Chrome(service=service)

# URL do site
url = "https://sucupira.capes.gov.br/sucupira/public/consultas/coleta/veiculoPublicacaoQualis/listaConsultaGeralPeriodicos.jsf"

# Função para consultar e obter o último <td> texto para um ISSN específico
def consultar_issn(issn):
    driver.get(url)

    # Esperar até que a dropdown "Evento de Classificação" esteja presente na página
    WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.ID, "form:evento"))
    )

    # Selecionar o "Evento de Classificação"
    evento_select = Select(driver.find_element(By.ID, "form:evento"))
    evento_select.select_by_visible_text("CLASSIFICAÇÕES DE PERIÓDICOS QUADRIÊNIO 2017-2020")

    # Selecionar o "ISSN" e atribuir o valor
    issn_checkbox = driver.find_element(By.ID, "form:checkIssn")
    issn_checkbox.click()
    issn_input = driver.find_element(By.ID, "form:issn:issn")
    issn_input.click() 
    issn_input.send_keys(issn)

    # Clicar no botão "Consultar"
    consultar_button = driver.find_element(By.ID, "form:consultar")
    consultar_button.click()

    # Re-encontrar a div "resultados" após clicar em consultar para evitar StaleElementReferenceException
    WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.CLASS_NAME, "resultados"))
    )

    # Encontrar o tbody dentro da div "resultados"
    resultados_tbody = driver.find_element(By.XPATH, "//div[@class='resultados']//tbody")

    # Pegar o último <td> do primeiro <tr>
    primeiro_tr = resultados_tbody.find_element(By.TAG_NAME, "tr")
    ultimo_td = primeiro_tr.find_elements(By.TAG_NAME, "td")[-1]

    return ultimo_td.text

# Iterar sobre a lista de ISSNs e atualizar a coluna "Econ" conforme necessário
for index, row in df.iterrows():
    issn = row['ISSN']
    try:
        resultado = consultar_issn(issn)
        if resultado == "ECONOMIA":
            df.at[index, 'Econ'] = "ECONOMIA"
    except Exception as e:
        print(f"Erro ao consultar ISSN {issn}: {e}")

# Fechar o navegador
driver.quit()

# Salvar o dataframe atualizado de volta em uma planilha
output_file_path = 'QualisEcon2020_atualizado.xlsx'
df.to_excel(output_file_path, index=False)

print(f"Planilha atualizada salva em {output_file_path}")
