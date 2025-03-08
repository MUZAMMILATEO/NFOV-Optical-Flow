function O = imwarp(I, u, v, nopad)
    I = double(I);
  % Image size
  sx = size(I, 2); 
  sy = size(I, 1); 

  % Image size w/ padding
  spx = sx + 2;
  spy = sy + 2;
  
  
  if (nargin > 3 & nopad)  
    % Warped image coordinates
    [X, Y] = meshgrid(1:sx, 1:sy);
    XI = reshape(X + u, 1, sx * sy);
    YI = reshape(Y + v, 1, sx * sy);
    
    % Bound coordinates to valid region
    XI = max(1, min(sx - 1E-6, XI));
    YI = max(1, min(sy - 1E-6, YI));
    
    % Perform linear interpolation (faster than interp2)
    fXI = floor(XI);
    cXI = ceil(XI);
    fYI = floor(YI);
    cYI = ceil(YI);
    
    alpha_x = XI - fXI;
    alpha_y = YI - fYI;
    
    O = (1 - alpha_x) .* (1 - alpha_y) .* I(fYI + sy * (fXI - 1)) + ...
        alpha_x .* (1 - alpha_y) .* I(fYI + sy * (cXI - 1)) + ...
        (1 - alpha_x) .* alpha_y .* I(cYI + sy * (fXI - 1)) + ...
        alpha_x .* alpha_y .* I(cYI + sy * (cXI - 1));
  
  else
    % Pad image with NaNs
    Z = [NaN(1, sx+2); NaN(sy, 1), I, NaN(sy, 1); NaN(1, sx+2)];
    
    % Warped image coordinates in padded image
    [X, Y] = meshgrid(2:sx+1, 2:sy+1);
    XI = reshape(X + u, 1, sx * sy);
    YI = reshape(Y + v, 1, sx * sy);
    
    % Bound coordinates to valid region
    XI = max(1, min(spx - 1E-6, XI));
    YI = max(1, min(spy - 1E-6, YI));
    
    % Perform linear interpolation (faster than interp2)
    fXI = floor(XI);
    cXI = ceil(XI);
    fYI = floor(YI);
    cYI = ceil(YI);
    
    alpha_x = XI - fXI;
    alpha_y = YI - fYI;
    
    O = (1 - alpha_x) .* (1 - alpha_y) .* Z(fYI + spy * (fXI - 1)) + ...
        alpha_x .* (1 - alpha_y) .* Z(fYI + spy * (cXI - 1)) + ...
        (1 - alpha_x) .* alpha_y .* Z(cYI + spy * (fXI - 1)) + ...
        alpha_x .* alpha_y .* Z(cYI + spy * (cXI - 1));
  end
  
  O = reshape(O, sy, sx);
