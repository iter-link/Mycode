function [imder, imdec] = decompose(imMat, dim)
imder = imMat;
imdec = imMat;
for i = 1:dim  
    for j = 1:2:dim  
        imder(i, dim/2+(j+1)/2) = imMat(i, j+1) - imMat(i, j); 
        imder(i, (j+1)/2) = imMat(i, j) + floor(imder(i, dim/2+(j+1)/2)/2);
    end
end

for i = 1:dim 
    for j = 1:2:dim
        imdec(dim/2+(j+1)/2, i) = imder(j+1, i) - imder(j, i); 
        imdec((j+1)/2, i) = imder(j, i) + floor(imdec(dim/2+(j+1)/2, i)/2);
    end
end

