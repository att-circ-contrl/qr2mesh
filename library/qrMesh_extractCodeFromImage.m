function codematrix = qrMesh_extractCodeFromImage( imagematrix, qrconfig )

% function codematrix = qrMesh_extractCodeFromImage( imagematrix, qrconfig )
%
% This converts an image containing a QR code into a boolean matrix that's
% true where QR code pixels are black and false elsewhere.
%
% NOTE - This assumes that the QR code is aligned with the image axes and
% that the code is dark against a light background.
%
% "imagematrix" is a Height x Width x Channels matrix with image data.
% "qrconfig" is a structure with configuration parameters, per QRCONFIG.txt.
%
% "codematrix" is a Size x Size boolean matrix indexed by (Y,X) that's true
%   for QR code pixels that were black and false elsewhere.


% Initialize to safe output.
codematrix = logical([]);



% Turn this into a boolean intensity map if it isn't one already.

imagematrix = double(imagematrix);
imagematrix = sum(imagematrix, 3);
threshval = median(imagematrix, 'all');
rawimg = (imagematrix >= threshval);

% NOTE - Reverse the image. Logical '1' is a code pixel (black).
rawimg = ~rawimg;



% Find the image extents and crop to content.
% FIXME - Blithely assume that it's ortho-aligned and has a light background.

% Remember that matrices are indexed by (y,x).

xscratch = sum(rawimg,1);
xscratch = find(xscratch > 0.5);

yscratch = sum(rawimg,2);
yscratch = find(yscratch > 0.5);

if isempty(xscratch) || isempty(yscratch)
  % No image pixels found; bail out.
  disp([ '###  No black pixels found in "' infile '"!.' ]);
  return;
end

xmin = min(xscratch);
xmax = max(xscratch);

ymin = min(yscratch);
ymax = max(yscratch);

% NOTE - We don't need to crop the image, we just need to know the extents.

% FIXME - Diagnostics.
%disp(sprintf('xx  Cropped to (%d,%d) - (%d,%d).', xmin, ymin, xmax, ymax));



% Downsample to the code resolution.

% NOTE - Tolerate getting a 1x1 cropped image.

codewidth = qrconfig.qrsize;

% Stride is divided by codewidth, not codewidth-1.
xstride = (xmax - xmin) / codewidth;
ystride = (ymax - ymin) / codewidth;

xstart = xmin + 0.5 * xstride;
ystart = ymin + 0.5 * ystride;

xrange = 0:(codewidth-1);
xrange = (xrange * xstride) + xstart;
xrange = round(xrange);

yrange = 0:(codewidth-1);
yrange = (yrange * ystride) + ystart;
yrange = round(yrange);

codematrix = false([ codewidth codewidth ]);
for xidx = 1:codewidth
  for yidx = 1:codewidth
    % Remember that we're indexed by Y,X.
    codematrix(yidx,xidx) = rawimg( yrange(yidx), xrange(xidx) );
  end
end



% Done.
end


%
% This is the end of the file.
