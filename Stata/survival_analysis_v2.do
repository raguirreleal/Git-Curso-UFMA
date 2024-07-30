*-----------------------------------------
* Artigo Evasão FURG
* Estimação e análise de modelos de sobrevivência
* By: Edurado Tillman & Ricardo Leal
*-----------------------------------------

clear
set more off
*---
// Troque ... abaixo pelo caminho correto e delete *
*cd "...\Git Curso UFMA\Stata"
use "base_trat_short_v2.dta", replace
*use "base_trat_long.dta", replace

*-----------------------------------------
* Excluir registros: 
*-----------------------------------------
// Cuidar forma de ingresso: excluir mobilidades internacional/nacional, outros e transf
// PSVO, PECG, Selecao Campo, Indigena, Quilombola e Uruguai não tem ENEM! 
// Fica só SISU e Vagaremanescente
bys id: keep if inlist(ingresso, "SISU", "VagaRema")
gen vagarema = (ingresso=="VagaRema")
	label variable vagarema "Ingresso por Vaga Remanescente"
drop ingresso
*---
aorder

*-----------------------------------------
* Estimação Modelo - Evasão UNIVERSIDADE
*-----------------------------------------
stset spell, id(id) failure(t_evadiu_univ=1) 
*---
stdescribe
stsum
*---
global xlist_dudu ntfinal idadeingresso sexo_fem branco escola_pub cota_renda aaf_defic nasceu_campus auxilio monit_estag turno_noite coefrend vagarema
global xlist_dudu_u ntfinal idadeingresso sexo_fem branco escola_pub cota_renda aaf_defic nasceu_campus auxilio monit_estag turno_noite coefrend vagarema i.unid_acad
global xlist_1 ntfinal idadeingresso sexo_fem branco escola_pub aaf_defic nasceu_campus auxilio monit_estag turno_noite coefrend vagarema i.unid_acad 
global xlist_2 ntfinal idadeingresso sexo_fem branco escola_pub aaf_defic nasceu_campus auxilio monit_estag turno_noite coefrend vagarema prop_conclu prop_conclu2 // i.unid_acad
global xlist_3 ntfinal idadeingresso sexo_fem branco cota_renda nasceu_campus auxilio monit_estag turno_noite coefrend vagarema prop_conclu prop_conclu2 // i.unid_acad
global xlist_4 ntfinal idadeingresso sexo_fem branco cotista nasceu_campus auxilio monit_estag turno_noite coefrend vagarema prop_conclu prop_conclu2 duracao_curso i.unid_acad
global xlist_5 ntfinal idadeingresso sexo_fem branco cotista nasceu_campus auxilio monit_estag turno_noite coefrend prop_conclu prop_conclu2 prop_conclu3 duracao_curso i.unid_acad i.campus // vagarema
*-----------------------------------------
* Teste variaveis mudam de valor no tempo
stvary $xlist_dudu
stvary ntfinal idadeingresso sexo_fem preto_pardo cotista nasceu_campus auxilio monit_estag turno_noite coefrend branco prop_conclu prop_conclu2 duracao_curso unid_acad campus // xlist_5
*---
sts graph, hazard    
sts graph, cumhaz    
sts graph, survival 
*-----------------------------------------
* Parametric models
//Cox proportional hazard model coefficients and hazard rates
stcox $xlist_dudu,   vce(cluster id) nohr
stcox $xlist_dudu_u, vce(cluster id) nohr
stcox $xlist_1,      vce(cluster id) nohr
stcox $xlist_2,      vce(cluster id) nohr
stcox $xlist_3,      vce(cluster id) nohr
stcox $xlist_4,      vce(cluster id) nohr
stcox $xlist_5,      vce(cluster id) nohr

*---
// Exponential regression coefficients and hazard rates
*streg $xlist if curso_anual==0 & curso_4anos==1, nohr dist(exponential)
*streg $xlist if curso_anual==0 & curso_4anos==1, dist(exponential)
*---
// Weibull regression coefficients and hazard rates
*streg $xlist if curso_anual==0 & curso_4anos==1, nohr dist(weibull)
*streg $xlist if curso_anual==0 & curso_4anos==1, dist(weibull)
*---
//Gompertz regression coefficients and hazard rates
*streg $xlist, nohr dist(gompertz)
*streg $xlist, dist(gompertz)

*-----------------------------------------
* Estimação Modelo - Evasão UNIVERSIDADE (Ctrl Curso)
*-----------------------------------------
stset spell, id(id) failure(t_qtd_evadiu=1) 
*---
stdescribe
stsum
*-----------------------------------------
* Controlando por Evasao de Curso
stcrreg ntfinal idadeingresso sexo_fem preto_pardo escola_pub cota_renda aaf_defic nasceu_campus auxilio monit_estag turno_noite coefrend vagarema i.unid_acad, compete(t_qtd_evadiu==2) vce(cluster id)
*---
stcurve, cif


