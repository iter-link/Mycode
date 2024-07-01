function imde = SDecompose( imMat, dim )
imMat = double(imMat);
map = gray(256);
[imder, imdec] = decompose(imMat, dim);
imde = imdec;

