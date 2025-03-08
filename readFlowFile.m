function img0 = readFlowFile(filename,inum)
TAG_FLOAT = 202021.25;  
if isempty(filename) == 1
    error('readFlowFile: empty filename');
end;

idx = findstr(filename, '.');
%idx = idx(end);

if length(filename(idx:end)) == 1
    error('readFlowFile: extension required in filename %s', filename);
end;

if strcmp(filename(idx:end), '.flo') ~= 1    
    error('readFlowFile: filename %s should have extension ''.flo''', filename);
end;

fid = fopen(filename, 'r');
if (fid < 0)
    error('readFlowFile: could not open %s', filename);
end;

tag     = fread(fid, 1, 'float32');
width   = fread(fid, 1, 'int32');
height  = fread(fid, 1, 'int32');

% sanity check

if (tag ~= TAG_FLOAT)
   error('readFlowFile(%s): wrong tag (possibly due to big-endian machine?)', filename);
end;
if (width < 1 || width > 99999)
    error('readFlowFile(%s): illegal width %d', filename, width);
end;
if (height < 1 || height > 99999)
    error('readFlowFile(%s): illegal height %d', filename, height);
end;

nBands = 2;

% arrange into matrix form
tmp = fread(fid, inf, 'float32');
tmp = reshape(tmp, [width*nBands, height]);
tmp = tmp';
img(:,:,1) = tmp(:, (1:width)*nBands-1);
img(:,:,2) = tmp(:, (1:width)*nBands);
%img(:,:,2) = tmp(:, (width+1:width*nBands));
img1(:,:,1) = img(:,:,1);
img1(:,:,2) = img(:,:,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%if inum > 8
img0(:,:,1) = fliplr(img(:,:,1)');%fliplr(-img(:,:,1)');
img0(:,:,2) = fliplr(-img(:,:,2)');
img00=sqrt((img0(:,:,1).^2)+(img0(:,:,2).^2));
trueMagSTD=std(img00(:))
%end


fclose(fid);
