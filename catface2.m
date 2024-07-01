function wm1=catface2(wm1,a,b,r,c,n)
wmI1=wm1;
for i=1:n
    for y=1:r
        for x=1:c            
            xx=mod((a*b+1)*(x-1)-b*(y-1),r)+1;
            yy=mod(-a*(x-1)+(y-1),r)+1  ;        
            wm1(yy,xx)=wmI1(y,x);                   
        end
    end
   wmI1=wm1;
end
% figure;imshow(wm1,[])
end

