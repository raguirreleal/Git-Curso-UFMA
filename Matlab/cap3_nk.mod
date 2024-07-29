//Modelo NK - Capítulo 3 (ENTENDENDO OS MODELOS DSGE)
 var Y I C R K W L CM P PI A;
 varexo e;
 parameters sigma phi alpha beta delta rhoa psi theta;

 sigma = 2;
 phi = 1.5;
 alpha = 0.35;
 beta = 0.985;
 delta = 0.025;
 rhoa = 0.95;
 psi = 8;
 theta = 0.75;

 model(linear);
     #Pss = 1;
     #Rss = Pss*((1/beta)-(1-delta));
     #CMss = ((psi-1)/psi)*(1-beta*theta)*Pss;
     #Wss = (1-alpha)*(CMss^(1/(1-alpha)))*((alpha/Rss)^(alpha/(1-alpha)));
     #Yss = ((Rss/(Rss-delta*alpha*CMss))^(sigma/(sigma+phi)))
     *((Wss/Pss)*(Wss/((1-alpha)*CMss))^phi)^(1/(sigma+phi));
     #Kss = alpha*CMss*(Yss/Rss);
     #Iss = delta*Kss;
     #Css = Yss - Iss;
     #Lss = (1-alpha)*CMss*(Yss/Wss);
     //1-Oferta de Trabalho
     sigma*C + phi*L = W - P;         
     //2-Equação de Euler                       
     (sigma/beta)*(C(+1)-C)=(Rss/Pss)*(R(+1)-P(+1)); 
     //3-Lei de Movimento do Capital                   
     K = (1-delta)*K(-1) + delta*I; 
     //4-Função de Produção                         
     Y = A + alpha*K(-1) + (1-alpha)*L;
     //5-Demanda por Capital       
     K(-1) = Y - R;             
     //6-Demanda por Trabalho                                                                             
     L = Y - W;             
     //7-Custo Marginal
     CM = (1-alpha)*W + alpha*R - A;
     //8-Equação de Phillips                                     
     PI = beta*PI(+1)+((1-theta)*(1-beta*theta)/theta)*(CM-P); 
     //9-Taxa de Inflação Bruta                           
     PI = P - P(-1);
     //10-Condição de Equilíbrio no Mercado de Bens                         
     Yss*Y = Css*C + Iss*I;       
     //11-Choque de Produtividade                         
     A = rhoa*A(-1) + e;                                       
 end;

 steady;
 check(qz_zero_threshold=1e-20);

 shocks;
     var e;
     stderr 0.01;
 end;

 stoch_simul(qz_zero_threshold=1e-20) Y I C R K W L PI A;
//stoch_simul(nograph,qz_zero_threshold=1e-20) Y I C R K W L PI A;