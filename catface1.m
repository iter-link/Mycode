function wmn=catface1(wm,a,b,r,c,n)
wmn=zeros(r,c);
for i=1:n
    for y=1:r
        for x=1:c           
            xx=mod((x-1)+b*(y-1),r)+1;
            yy=mod(a*(x-1)+(a*b+1)*(y-1),r)+1;        
            wmn(yy,xx)=wm(y,x);                
        end
    end
    wm=wmn;
end
% figure;
% imshow(wmn,[])