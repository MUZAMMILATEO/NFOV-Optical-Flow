function [D1_est, D2_est, color_u, color_v, delta, fx, fy, new_u, new_v, orig_u, orig_v] = register_lateo(A,B,lmbdacpy,mthdvar,fix0,lmbdafake,alpha_ord0,lambdaFrac)
alpha=100; 
ite=1500; 
ep=0;%1;
js=3;
%js=1;    
%%%%%%%%%%%%%%%%%%%%%%%%%%% The new algorithm parameter implementation %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%***********%%%%%%%%%*******%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alpha_ord=alpha_ord0;                                  
beta =0.1;                                     
delta=28.4588*lmbdacpy;                              
lmbda=lmbdafake;                                   %%%%%%%%%%%%%%%%%% Alternative choice 10*exp(10*lmbdacpy) %%%%%%%%%%%%%%%%%%
if mthdvar<3
    wndsz=349;                                      %%%%%%%%%%%%%%%%%% WNDSZ = 349 %%%%%%%%%%%%%%%%%%
else
    wndsz=5;
end    
%%%%%%%%% Evaluation of Grunwald-Letnikov derivative over a window size wndsz %%%%%%%%%
tmp_alp=alpha_ord+1;
wndcff=zeros(wndsz+1,1);
wndcff(1)=0.25;                                       %%%%%%%%%%%%%%%%%% Initializing the discretized Grunwald-Letnikov Derivative %%%%%%%%%%%%%%%%%%
for i=2:1:wndsz+1
    wndcff(i)=(1-tmp_alp/i)*wndcff(i-1);
end
tempwindow = wndcff;
wndcff = wndcff*4;                                   %%%%%%%%%%%%%%%%%% The evaluated value of the discretizied Grunwald-Letnikov Derivative over the prescribed window size %%%%%%%%%%%%%%%%%% 
wndcff=sum(wndcff);
curl=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%% The new algorithm parameter implemented %%%%%%%%%%%%%%%%%%%%%%%%%%%
uInitial = zeros(size(A(:,:,1)));                       %%%%%%%%%%%%%%%%%%%%% Pre-allocation of memory for time efficiency in algorithm
vInitial = zeros(size(B(:,:,1)));                       %%%%%%%%%%%%%%%%%%%%% Uncommenting the current and the next three lines would only unnecessarily repeat the same process as that in the line exactly above this one %%%%%%%%%%%%%%%%%%%%%
%% Convert images to grayscale
if size(size(A),2)==3
    A=rgb2gray(A);
end
if size(size(B),2)==3
    B=rgb2gray(B);
end
A=double(A);
B=double(B);

A=smoothImg(A,1);
B=smoothImg(B,1);

%%
% Set initial value for the flow vectors
u = uInitial;
v = vInitial;
% Estimate spatiotemporal derivatives
[fx, fy, ft] = computeDerivatives(A, B);

% Averaging kernel
%%
kernel_1=[1/12 1/6 1/12;1/6 0 1/6;1/12 1/6 1/12];
%%%%%%   Try this for the improvement %%%%%%%%%%
%d=1;
%Forder=1;                            %%%%%%%%%%%%% Uncomment these two lines if other value of d is desired %%%%%%%%%%%%%
%d=nchoosek(Forder,1);
%%%% %%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%
%kernel_1=d*[0 1/4 0;1/4 0 1/4;0 1/4 0];
%%%%%%% For Forder=0 %%%  %%%%%%
%kernel_1=1;
if mthdvar==0
for l=1:ite
    uAvg=conv2(u,kernel_1,'same');
    vAvg=conv2(v,kernel_1,'same');
   %%%Horn and Schunck Method to find u and v.
    u= uAvg - ( fx .* ( ( fx .* uAvg ) + ( fy .* vAvg ) + ft ) ) ./ ( alpha^2 + fx.^2 + fy.^2); 
    v= vAvg - ( fy .* ( ( fx .* uAvg ) + ( fy .* vAvg ) + ft ) ) ./ ( alpha^2 + fx.^2 + fy.^2);
end
elseif mthdvar==1
    tempwindow(1)=1;
    a = size(tempwindow,1);
    tempwindow0=tempwindow(2:a);
            tempmat=zeros(2*a-1);
            tempmat(a,a:2*a-1)=tempwindow;
            tempmat(a,a-1:-1:1)=tempwindow0;
            tempmat(a-1:-1:1,a)=tempwindow0;
            tempmat(a+1:2*a-1,a)=tempwindow0;
            if fix0>0
                delta=0.4;
            end
            [u,v] = warp_flow(A,B,5,5,tempmat,delta,beta,lmbda,wndcff);
            figure(100); imshow(u,[])
            figure(101); imshow(v,[])   
    
end
new_u = u;
new_v = v;
orig_u = u;
orig_v = v;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stdVal = sqrt(u.^2+v.^2);
stdVal = std(stdVal(:));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Give the final value of u and v which is used in the next
%%%%%%%%%%%%% iteration ********************************  %%%%%
filtgauss=fspecial('gaussian',5,1.5);                   %%%%%%%%%%% To estimate Depth %%%%%%%%%%
[szm, szn]=size(u);
fmag=zeros(szm,szn,2);
fmag(:,:,1)=imfilter(u,filtgauss,'conv','same');
fmag(:,:,2)=imfilter(v,filtgauss,'conv','same');
m = sqrt(sum(fmag.^2, 3));
%imwrite(mat2gray(m),'R:\Research Paper SCI\Data\088_blow19Txtr2\088_blow19Txtr2_mag_0.7_1000.png')
figure(13);
plotflow(fmag,'magscale');
title('Depth Estimation in case of parallex');          %%%%%%%%%%% To estimate Depth end %%%%%%%%%%
color_u=u;
color_v=v;
[r1, c1]=size(u);
r2=floor(r1./2^js);
c2=floor(c1./2^js);
u=imresize(u,[r2 c2]);
v=imresize(v,[r2 c2]);
[N2,M2]=size(u);
n_s = 1; n_e = N2;
m_s = 1; m_e = M2;
[Y,X]=meshgrid(m_s:m_e,n_s:n_e);
d2_flip = flipud(v(n_s:n_e,m_s:m_e));
d1_flip = flipud(u(n_s:n_e,m_s:m_e));
figure(2);
quiver(Y,X,flipud(u),flipud(-v),'b'); axis image; axis off;
title('Estimated Disparity Plot');
figure(3); image(A(1:1:(n_e-n_s+1)*2^js,1:1:(m_e-m_s+1)*2^js)); ...
colormap(gray(256)); axis image; axis off;
title('Estimated Disparity Plot (over reference image A)');
hold on;
[Y,X]=meshgrid(1:2^js:(m_e-m_s+1)*2^js,1:2^js:(n_e-n_s+1)*2^js);
quiver(Y,X,u,v,'r');
hold off;
D1_est=u;
D2_est=v;
figure, imshow(lmbda,[])
end

