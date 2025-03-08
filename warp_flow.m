function [u,v] = warp_flow(im1,im2,pyr_lev,warp_num,tempmat,delta,beta,lmbda,wndcff)
%THIS FUNCTION TAKES INPUT IMAGES AS IM1 AND IM2, THE NUMBER OF
%PYRAMID LEVELS PYR_LEV, THE NUMBER OF WARPING TIMES IN EACH
%PYRAMID LEVEL GIVEN BY WARP_NUM.

if size(im1,3)>1
   im1 = rgb2gray(im1);
   im2 = rgb2gray(im2);
end

if ~isfloat(im1)
   im1 = double(im1);
   im2 = double(im2);
end
[m,n] = size(im1);
for lev = pyr_lev:-1:1
    tmp_im1 = imresize(im1,[ceil(0.5^(lev-1)*m) ceil(0.5^(lev-1)*n)]);
    tmp_im2 = imresize(im2,[ceil(0.5^(lev-1)*m) ceil(0.5^(lev-1)*n)]);
    [new_m,new_n] = size(tmp_im1);
    if lev == pyr_lev
        u = zeros(new_m,new_n);
        v = zeros(new_m,new_n);
    end
    lmbda = 100;
    u = imresize(u,[new_m new_n]);
    v = imresize(v,[new_m new_n]);
    delta_u = zeros(new_m,new_n);
    delta_v = delta_u;
    tmp_im1 = imwarp(tmp_im1,-u,-v,'true');
    for warping_number = 1:1:warp_num
        [fx,fy,ft] = computeDerivatives(tmp_im1,tmp_im2);
        for ite = 1:1:1500
            uAvg=conv2(delta_u,tempmat,'same');
            vAvg=conv2(delta_v,tempmat,'same');
            Thetha0 = delta_u.*fx +delta_v.*fy + ft;%%
            Thetha0 = delta*sqrt(1+((Thetha0/delta).^2));
            indxg=(Thetha0<eps);
            Thetha0(indxg) = eps;
            Thetha0=1./Thetha0;
            Tu=Thetha0.*(fx.^2) + 2*beta^2 + 2*lmbda*wndcff;
            Tv=Thetha0.*(fy.^2) + 2*beta^2 + 2*lmbda*wndcff;
            indxg=(Tu<eps & Tv<eps);
            Tu(indxg)=eps;
            Tv(indxg)=eps;
            Tu=1./Tu;
            Tv=1./Tv;
            delta_u=Tu.*(2*lmbda.*uAvg - Thetha0.*(fx.*fy.*delta_v + fx.*ft));
            delta_v=Tv.*(2*lmbda.*vAvg - Thetha0.*(fx.*fy.*delta_u + fy.*ft));
            indxg=(delta_u>999 & delta_v>999);
            delta_u(indxg)=0;
            delta_v(indxg)=0;
        end
      delta_u = medfilt2(delta_u,[5 5]);
      delta_v = medfilt2(delta_v,[5 5]);
      u = u + delta_u;
      v = v + delta_v;
      u = medfilt2(u,[5 5]);
      v = medfilt2(v,[5 5]);
      tmp_im1 = imwarp(tmp_im1,-delta_u,-delta_v,'true');
      delta_u = 0*delta_u;
      delta_v = 0*delta_v;
   end
end
end

