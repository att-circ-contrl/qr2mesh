function meshtext = qrMesh_generateCodeMesh( codematrix, qrconfig )

% function meshtext = qrMesh_generateCodeMesh( codematrix, qrconfig )
%
% This converts a QR code matrix into a triangle mesh in ASCII STL format.
% The mesh contains a "slab" block and multiple "pixel" blocks.
%
% NOTE - The resulting mesh contains many intersecting independent meshes.
% This will need to be cleaned up (merged) with an editing tool before
% being used for most applications.
%
% "codematrix" is a Size x Size boolean matrix indexed by (Y,X) that's true
%   for QR code pixels that were black and false elsewhere.
% "qrconfig" is a structure with configuration parameters, per QRCONFIG.txt.
%
% "meshtext" is a character vector containing the ASCII STL mesh data.


% Various magic values.

newline = sprintf('\n');

halfwidth = 0.5 * qrconfig.blockwidth;
pitch = qrconfig.blockpitch;
qrsize = qrconfig.qrsize;
epsilon = 0.01 * qrconfig.slabheight;

% Make life easier and use 1-based indexing when computing this.
startval = - 0.5 * pitch * (qrsize - 1);
startval = startval - pitch;


% Header.
meshtext = [ 'solid qrcode' newline ];

% Slab.
meshtext = [ meshtext helper_makeBlock( ...
  startval + pitch - halfwidth, startval + pitch - halfwidth, 0, ...
  startval + (qrsize * pitch) + halfwidth, ...
  startval + (qrsize * pitch) + halfwidth, - qrconfig.slabheight ) ];


% Pixels.

for xidx = 1:qrsize
  for yidx = 1:qrsize
    % Remember that this is indexed by Y,X.
    if codematrix(yidx,xidx)
      meshtext = [ meshtext helper_makeBlock( ...
        startval + (xidx * pitch) - halfwidth, ...
        startval + (yidx * pitch) - halfwidth, - epsilon, ...
        startval + (xidx * pitch) + halfwidth, ...
        startval + (yidx * pitch) + halfwidth, qrconfig.blockheight ) ];
    end
  end
end


% Footer.
meshtext = [ meshtext newline 'endsolid qrcode' newline ];


% Done.
end



%
% Helper Functions


function blocktext = helper_makeBlock( x1, y1, z1, x2, y2, z2 )

  if x1 > x2
    scratch = x1;
    x1 = x2;
    x2 = scratch;
  end

  if y1 > y2
    scratch = y1;
    y1 = y2;
    y2 = scratch;
  end

  if z1 > z2
    scratch = z1;
    z1 = z2;
    z2 = scratch;
  end

  blocktext = '';

  % Pick vertex order carefully to keep windings consistent.
  % We're doing counterclockwise windings, with right-hand-rule normals.

  blocktext = [ blocktext helper_makeQuad( ...
    [ x1 y1 z1 ], [ x2 y1 z1 ], [ x2 y1 z2 ], [ x1 y1 z2 ] ) ];

  blocktext = [ blocktext helper_makeQuad( ...
    [ x1 y1 z1 ], [ x1 y2 z1 ], [ x2 y2 z1 ], [ x2 y1 z1 ] ) ];

  blocktext = [ blocktext helper_makeQuad( ...
    [ x1 y1 z1 ], [ x1 y1 z2 ], [ x1 y2 z2 ], [ x1 y2 z1 ] ) ];

  blocktext = [ blocktext helper_makeQuad( ...
    [ x2 y2 z2 ], [ x1 y2 z2 ], [ x1 y1 z2 ], [ x2 y1 z2 ] ) ];

  blocktext = [ blocktext helper_makeQuad( ...
    [ x2 y2 z2 ], [ x2 y2 z1 ], [ x1 y2 z1 ], [ x1 y2 z2 ] ) ];

  blocktext = [ blocktext helper_makeQuad( ...
    [ x2 y2 z2 ], [ x2 y1 z2 ], [ x2 y1 z1 ], [ x2 y2 z1 ] ) ];

end



function quadtext = helper_makeQuad( v1, v2, v3, v4 )

  quadtext = '';


  % Compute the normal. This is the normalized cross product.
  % Vertices are given in counterclockwise order with right-hand rule normals.
  normvec = cross(v2 - v1, v4 - v1);
  normvec = normvec / norm(normvec);


  % Triangle 1-2-3.

  quadtext = [ quadtext sprintf( ...
    '\nfacet normal %.4e %.4e %.4e\nouter loop\n', ...
    normvec(1), normvec(2), normvec(3) ) ];

  quadtext = [ quadtext sprintf( 'vertex %.4e %.4e %.4e\n', ...
    v1(1), v1(2), v1(3) ) ];
  quadtext = [ quadtext sprintf( 'vertex %.4e %.4e %.4e\n', ...
    v2(1), v2(2), v2(3) ) ];
  quadtext = [ quadtext sprintf( 'vertex %.4e %.4e %.4e\n', ...
    v3(1), v3(2), v3(3) ) ];

  quadtext = [ quadtext sprintf( 'endloop\nendfacet\n' ) ];


  % Triangle 1-3-4.

  quadtext = [ quadtext sprintf( ...
    '\nfacet normal %.4e %.4e %.4e\nouter loop\n', ...
    normvec(1), normvec(2), normvec(3) ) ];

  quadtext = [ quadtext sprintf( 'vertex %.4e %.4e %.4e\n', ...
    v1(1), v1(2), v1(3) ) ];
  quadtext = [ quadtext sprintf( 'vertex %.4e %.4e %.4e\n', ...
    v3(1), v3(2), v3(3) ) ];
  quadtext = [ quadtext sprintf( 'vertex %.4e %.4e %.4e\n', ...
    v4(1), v4(2), v4(3) ) ];

  quadtext = [ quadtext sprintf( 'endloop\nendfacet\n' ) ];

end



%
% This is the end of the file.
