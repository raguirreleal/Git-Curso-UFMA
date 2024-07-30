//Modelo RBC - Capítulo 2 (ENTENDENDO OS MODELOS DSGE)
 //obs: W e R são reais na simulação

 var Y I C R K W L A ;
 varexo e;
 parameters sigma phi alpha beta delta rhoa;

 sigma = 2;
 phi = 1.5;
 alpha = 0.35;
 beta = 0.985;
 delta = 0.025;
 rhoa = 0.95;

 model(linear);
 #Pss = 1;
 #Rss = Pss*((1/beta)-(1-delta));
 #Wss = (1-alpha)*(Pss^(1/(1-alpha)))*((alpha/Rss)^(alpha/(1-alpha)));
 #Yss = ((Rss/(Rss-delta*alpha))^(sigma/(sigma+phi)))
 *(((1-alpha)^(-phi))*((Wss/Pss)^(1+phi)))^(1/(sigma+phi));
 #Kss = alpha*(Yss/Rss/Pss);
 #Iss = delta*Kss;
 #Css = Yss - Iss;
 #Lss = (1-alpha)*(Yss/Wss/Pss);
 //1-Oferta de trabalho
 sigma*C + phi*L = W; 
 //2-Equação de Euler           
 (sigma/beta)*(C(+1)-C)=Rss*R(+1); 
 //3-Lei de movimento do capital
 K = (1-delta)*K(-1)+delta*I; 
 //4-Função de produção   
 Y = A + alpha*K(-1) + (1-alpha)*L; 
 //5-Demanda por capital
 R = Y - K(-1);             
 //6-Demanda por trabalho     
 W = Y - L;           
 //7-Condição de equilíbrio           
 Yss*Y = Css*C + Iss*I; 
 //8-Choque de produtividade         
 A = rhoa*A(-1) + e;               
 end;

 steady;
 check;
 model_diagnostics;
 model_info;

 shocks;
 var e;
 stderr 0.01;
 end;

 stoch_simul;
