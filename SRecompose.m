function imre = SRecompose( imde, dim ) 
map = gray(256); 
% subplot(4, 4, 1); image(imde);colormap(map); axis square; axis off; 
% [imrer, imrec] = recompose(imde, dim/4); 
% imgray = mat2gray(imrer); 
% imwrite(imgray, 'iimgraylr.bmp'); 
% subplot(4, 4, 2); image(imrer);colormap(map); axis square; axis off; 
%  
% imgray = mat2gray(imrec); 
% imwrite(imgray, 'iimgray1c.bmp'); 
% subplot(4, 4, 6); image(imrec);colormap(map);  axis square; axis off; 
%  

[imrer, imrec] = recompose(imde,dim); 
imre = imrec; 

 
