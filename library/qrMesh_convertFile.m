function qrMesh_convertFile( infile, outprefix, qrconfig )

% function qrMesh_convertFile( infile, outprefix, qrconfig )
%
% This converts an image file containing a QR code into two ASCII STL files,
% one with a positive die (encoding black pixels) and one with a negative
% die (encoding white pixels).
%
% The configuration parameters supplied are for the positive die. For the
% negative die, the block width is adjusted (so that if one was larger than
% the pitch, the other is smaller, and vice versa).
%
% "infile" is the name of the image file to read.
% "outprefix" is a prefix to use when building STL file names.
% "qrconfig" is a structure with configuration parameters, per QRCONFIG.txt.
%
% No return value.


% Read the image.
rawimg = imread(infile);


% Get the QR code pixels.
qrimg = qrMesh_extractCodeFromImage( rawimg, qrconfig );


% FIXME - Diagnostics.
%disp(size(qrimg));
%disp([ sum(qrimg,'all'), numel(qrimg) ]);

% FIXME - Diagnostics.
%imwrite( double( ~qrimg ), [ outprefix '.png' ] );


% Generate ASCII STL files.
positivemesh = qrMesh_generateCodeMesh( qrimg, qrconfig );
negativemesh = qrMesh_generateCodeMesh( ~qrimg, qrconfig );
helper_writeTextFile( [ outprefix '-positive.stl' ], positivemesh );
helper_writeTextFile( [ outprefix '-negative.stl' ], negativemesh );


% Done.
end



%
% Helper Functions

function helper_writeTextFile( filename, data )

  fid = fopen(filename, 'w');

  if 0 > fid
    disp([ '###  Unable to write to "' filename '"!' ]);
  else
    if ischar(data) && (~isempty(data))
      writecount = fwrite(fid, data, 'char*1');
    end

    fclose(fid);
  end

end


%
% This is the end of the file.
