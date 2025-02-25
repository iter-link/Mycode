function Iw = IRIDWT(image,flag,Sg)
%图像的重新分布不变小波逆变换

[m,n]=size(image);
I=zeros(m,n);
if flag==0
    I=image;
elseif flag==1
    I(1:m/2,1:n/2)=image(1:m/2,1:n/2)';
    I(1:m/2,n/2+1:n)=image(m/2+1:m,1:n/2)';
    I(m/2+1:m,1:n/2)=image(1:m/2,n/2+1:n)';
    I(m/2+1:m,n/2+1:n)=image(m/2+1:m,n/2+1:n)';
end
LL=Sg(1,1)*I(1:m/2,1:n/2);
HL=Sg(1,2)*I(1:m/2,n/2+1:n);
LH=Sg(2,1)*I(m/2+1:m,1:n/2);
HH=Sg(2,2)*I(m/2+1:m,n/2+1:n);
R=idwt2(LL,HL,LH,HH,'haar',[m,n]);
Iw=zeros(m,n);
for i=1:m 
    for j=1:n
        if (i<=m/2)&&(j<=n/2)
            Iw(i,j)=R(2*i-1,2*j-1);
        elseif (i<=m/2)&&(j>n/2)
            Iw(i,3*n/2-j+1)=R(2*i-1,2*j-n);
        elseif (i>m/2)&&(j<=n/2)
            Iw(3*m/2-i+1,j)=R(2*i-m,2*j-1); 
        else
            Iw(3*m/2-i+1,3*n/2-j+1)=R(2*i-m,2*j-n); 
        end
    end       
end
% figure,imshow(uint8(Iw))

end

