% Quick and dirty QR code to STL mesh converter - Top-level script
% Written by Christopher Thomas.


% Library path.
addpath('../library');


% Input file, output prefix.
filelist = { ...
  'input/qr-code-acc-lab-20230906.png', 'output/qr-code-acc-lab' ; ...
  'input/qr-code-m-use-20230906.png', 'output/qr-code-m-use' };


% Conversion parameters.

qrconfig = struct( 'qrsize', 25, ...
  'blockpitch', 1.0, 'blockwidth', 1.02, ...
  'blockheight', 3.0, 'slabheight', 1.0 );


filecount = size(filelist,1);

for fidx = 1:filecount
  qrMesh_convertFile( filelist{fidx,1}, filelist{fidx,2}, qrconfig );
end


%
% This is the end of the file.
