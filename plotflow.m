function [] = plotflow(f, kind)    
  
  if (nargin < 2)
    kind = 'vector';
  end
  
  switch (kind)
   case {'quiver', 'vector'}
    s = size(f);
%     step = max(s / 120);
%     step = max(s / 60);
    step = max(s / 40);
%     step = max(s / 20);
    
    [X, Y] = meshgrid(1:step:s(2), s(1):-step:1);
    u = interp2(f(:, :, 1), X, Y);
    v = interp2(f(:, :, 2), X, Y);
    
%     quiver(X, -Y, u, -v, 0.7);
    quiver(X, -Y, u, -v, 1, 'k', 'LineWidth', 1);
    axis image;
    
   case 'rgb'
    b = f(:, :, 1);
    b = b - min(b(:));
    b = b / max(b(:));
    
    g = f(:, :, 2);
    g = g - min(g(:));
    g = g / max(g(:));

    r = zeros(size(b));
    
    [ignore, rad] = cart2pol(f(:, :, 1), f(:, :, 2));
    
    nanidx  = isnan(f(:, :, 1)) & isnan(f(:, :, 2));
    zeroidx = (rad < 0.1);
    
    r(nanidx) = 0;
    g(nanidx) = 0;
    b(nanidx) = 0;
    r(zeroidx) = 1;
    g(zeroidx) = 1;
    b(zeroidx) = 1;
    
    im = cat(3, r, g, b);
    image(im);
    
   case 'hsv'
    [theta, rho] = cart2pol(f(:, :, 1), f(:, :, 2));
    
    theta = (theta + pi) / (2*pi);
    rho   = rho / max(rho(:));
    
    im = cat(3, theta, ones(size(theta)), rho);
    image(hsv2rgb(im));
    
   case {'bw', 'bwscale'}
    f1 = f(:, :, 1);
    f2 = f(:, :, 2);
    im = [f1, f2];
    
    m = max(abs(im(:)));
    imagesc(im, [-m m]);
    colormap gray(256);
    axis image
    axis off
    if (strcmp(kind, 'bwscale'))
      title(['[' num2str(min(im(:))) '; ' num2str(max(im(:))) ']'])
      colorbar
    end
    
   case {'mag', 'magscale'}
    m = sqrt(sum(f.^2, 3));
    imagesc(m);
    colormap gray(256);
    axis image
    axis off
    if (strcmp(kind, 'magscale'))
      title(['[' num2str(max(m(:))) ']'])
      colorbar
    end
    
   otherwise
    error('Invalid plot type');
  end
end

