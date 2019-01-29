function y = CauchyCirve(x,alpha,beta)
  if (x<=alpha)
      y=0;
  else
      %mid = alpha * (x-alpha)^(-beta);
      %y=1/(1+mid);
      y=1-exp(-((x-alpha)/beta)*((x-alpha)/beta));
  end