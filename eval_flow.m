function [phif,stf,phic,stc,EEf,EEc,Ef] = eval_flow (Vx, Vy, Cx, Cy)

[sy1 sx1] = size(Cx)
[sy sx] = size(Vx)
if ((sx~=sx1) | (sy~=sy1))
	error ('Sizes don''t match');
end
EEf = acos((Vx.*Cx+Vy.*Cy+1)./sqrt(1+Vx.^2+Vy.^2)./sqrt(1+Cx.^2+Cy.^2));
Ef = EEf(~isnan(EEf)).*(180/pi);
phif = mean(Ef);
stf = std(Ef);
c = length(Ef)/sx/sy*100;
AUX1 = sqrt(Vx.^2+Vy.^2);
Nx = Vx./AUX1;
Ny = Vy./AUX1;
EEc = asin((Nx.*Cx+Ny.*Cy-AUX1)./sqrt(1+AUX1.^2)./sqrt(1+Cx.^2+Cy.^2));
Ec = EEc(~isnan(EEc)).*(180/pi);
phic = mean(Ec);
stc = std(Ec);




