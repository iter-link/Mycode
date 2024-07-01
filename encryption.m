function [ output ] = encryption( data,miu )

n=size(data,1);
x=zeros(1,1007);
y=zeros(1,1006);
tem=0;
for j=1:n/2
    tem=tem+sum(data(:,j));
end
x0=2*tem*10^(-3)/(n*n);
y0=2*(sum(sum(data))-tem)*10^(-3)/(n*n);
clear tem
x(1)=sin(pi*miu*(y0+3)*x0*(1-x0));
y(1)=sin(pi*miu*(x0+3)*y0*(1-y0));
for k=2:1006
    x(k)=sin(pi*miu*(y(k-1)+3)*x(k-1)*(1-x(k-1)));
    y(k)=sin(pi*miu*(x(k-1)+3)*y(k-1)*(1-y(k-1)));
end
x(1007)=sin(pi*miu*(y(1006)+3)*x(1006)*(1-x(1006)));

for k=1:5
    a(k)=floor(mod((x(999+k)*10^10-floor(x(999+k)*10^10))*10^5,256));
    b(k)=floor(mod((y(999+k)*10^10-floor(y(999+k)*10^10))*10^5,256));
end

p(1)=floor(mod((x(1005)*10^10-floor(x(1005)*10^10))*10^5,20))+20;
p(2)=floor(mod((y(1005)*10^10-floor(y(1005)*10^10))*10^5,20))+20;
p(3)=floor(mod((x(1006)*10^10-floor(x(1006)*10^10))*10^5,20))+20;
p(4)=floor(mod((y(1006)*10^10-floor(y(1006)*10^10))*10^5,20))+20;
p(5)=floor(mod((x(1007)*10^10-floor(x(1007)*10^10))*10^5,20))+20;

A1=[1 a(1);b(1) a(1)*b(1)+1];
A2=[1 a(2);b(2) a(2)*b(2)+1];
A3=[1 a(3);b(3) a(3)*b(3)+1];
A4=[1 a(4);b(4) a(4)*b(4)+1];

for i=1:n/2
    for j=1:n/2
    tem=mod(A1*[i;j],n/2);   
    if tem(1)==0
        tem(1)=n/2;
    end
    if tem(2)==0
        tem(2)=n/2;  
    end
    index1.x(i,j)=tem(1);
    index1.y(i,j)=tem(2);
    end
end

for i=1:n/2
    for j=1:n/2
    tem=mod(A2*[i;j+n/2],n/2); 
    if tem(1)==0
        tem(1)=n/2;
    end
    if tem(2)==0
        tem(2)=n/2;  
    end   
    index2.x(i,j)=tem(1);
    index2.y(i,j)=tem(2);
    end
end

for i=1:n/2
    for j=1:n/2
    tem=mod(A3*[i+n/2;j],n/2);  
    if tem(1)==0
        tem(1)=n/2;
    end
    if tem(2)==0
        tem(2)=n/2;  
    end  
    index3.x(i,j)=tem(1);
    index3.y(i,j)=tem(2);
    end
end

for i=1:n/2
    for j=1:n/2
    tem=mod(A4*[i+n/2;j+n/2],n/2);  
    if tem(1)==0
        tem(1)=n/2;
    end
    if tem(2)==0
        tem(2)=n/2;  
    end  
    index4.x(i,j)=tem(1);
    index4.y(i,j)=tem(2);
    end
end
clear tem

for i=1:n/2
    for j=1:n/2
        TEM1(index1.x(i,j),index1.y(i,j))=data(i,j);
    end
end

for i=1:n/2
    for j=1:n/2
        TEM2(index2.x(i,j),index2.y(i,j))=data(i,j+n/2);
    end
end

for i=1:n/2
    for j=1:n/2
        TEM3(index3.x(i,j),index3.y(i,j))=data(i+n/2,j);
    end
end

for i=1:n/2
    for j=1:n/2
        TEM4(index4.x(i,j),index4.y(i,j))=data(i+n/2,j+n/2);
    end
end
TEM=[TEM1 TEM2;TEM3 TEM4];

A5=[1 a(5);b(5) a(5)*b(5)+1];
for i=1:n
    for j=1:n
    tem=mod(A5*[i;j],n); 
    if tem(1)==0
        tem(1)=n;
    end
    if tem(2)==0
        tem(2)=n; 
    end
    index5.x(i,j)=tem(1);
    index5.y(i,j)=tem(2);
    end
end

for i=1:n
    for j=1:n
        output(index5.x(i,j),index5.y(i,j))=TEM(i,j);
    end
end



