function [imrer, imrec] = recompose( imde, dim ) 
imrer = imde; 
imrec = imde; 
for i = 1:dim  
    for j = 1:2:dim   
        imrer(j, i) = imde((j+1)/2, i) - floor(imde(dim/2+(j+1)/2, i)/2); 
        imrer(j+1, i) = imde(dim/2+(j+1)/2, i) + imrer(j, i); 
    end 
end 
for i = 1:dim 
    for j = 1:2:dim 
        imrec(i, j) = imrer( i, (j+1)/2 ) - floor( imrer(i, dim/2+(j+1)/2)/2 );  
        imrec(i, j+1) = imrer( i, dim/2+(j+1)/2 ) + imrec(i, j); 
    end 
end 


