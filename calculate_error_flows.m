function [D1_err, D2_err, D1_c, D2_c, D1_est, D2_est, AEE, AME, NAME, ENG, RMS] = calculate_error_flows(ImageData1, ImageData2, D1_est, D2_est, D1_c, D2_c, N, M, N1, M1, js, fx, fy)

[N_d_est, M_d_est] = size(D1_est);

% cut away borders from D1_est and D2_est
buf_N = round((N-N1)/2/2^js); 
buf_M = round((M-M1)/2/2^js);

D1_est = (D1_est(buf_N+1:end-buf_N,buf_M+1:end-buf_M));
D2_est = (D2_est(buf_N+1:end-buf_N,buf_M+1:end-buf_M));

D1_c = imresize(D1_c,size(D1_est),'bilinear'); 
D2_c = imresize(D2_c,size(D2_est),'bilinear'); 

D1_err =(D1_c) - (D1_est);
D2_err =(D2_c) - (D2_est);
[v h] = size(D1_err);
Prod = v*h;
AEE = sum(sqrt((D1_err(:)).^2 + (D2_err(:)).^2))/Prod;
GTMag = sqrt(D1_c(:).^2 + D2_c(:).^2);
ESTMag = sqrt(D1_est(:).^2 + D2_est(:).^2);
NAME = sum(abs(GTMag - ESTMag)./GTMag)/Prod;
AME = sum(abs(GTMag - ESTMag))/Prod;
fx = imresize(fx,size(D2_est),'bilinear');
fy = imresize(fy,size(D2_est),'bilinear');
ENG = sum(abs(D1_err(:).*fy(:) - D2_err(:).*fx(:)))/Prod;
ImageData1 = imresize(ImageData1,size(D2_est),'bilinear');
ImageData2 = imresize(ImageData2,size(D2_est),'bilinear');
IMWarp = imwarp(ImageData1,-D1_est,-D2_est,1);
IMWarpcpy = double(IMWarp(:));
ImageData2cpy = double(ImageData2(:));
RMS = sqrt(sum((IMWarpcpy - ImageData2cpy).^2)/Prod);











