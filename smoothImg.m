function smoothedImg=smoothImg(img,segma)
if nargin<2
    segma=1;
end

G=gaussFilter(segma);
smoothedImg=conv2(img,G,'same');
smoothedImg=conv2(smoothedImg,G','same');