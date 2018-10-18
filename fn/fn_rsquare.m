function R2=fn_rsquare (Y,Yfit) %computes the coefficient of determination ("R-square")

SStot = sum((Y - mean(Y)).^2);
SSres = sum((Y - Yfit).^2);
R2 = 1 - SSres/SStot;

