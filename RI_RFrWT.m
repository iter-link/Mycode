function [ C,Sg,flag] = RI_RFrWT(image1,a,b)
[m,n]=size(image1);
A11=zeros(m/2,n/2);
A12=zeros(m/2,n/2);
A21=zeros(m/2,n/2);
A22=zeros(m/2,n/2);
A11=image1(1:m/2,1:n/2);
A12=image1(1:m/2,n/2+1:n);
A21=image1(m/2+1:m,1:n/2);
A22=image1(m/2+1:m,n/2+1:n);
mean=zeros(2,2);
mean(1,1)=mean2(A11);
mean(1,2)=mean2(A12);
mean(2,1)=mean2(A21);
mean(2,2)=mean2(A22);
NM=zeros(2,2);
NM(1,1)=mean(1,1)+mean(1,2)+mean(2,1)+mean(2,2);
NM(1,2)=mean(1,1)-mean(1,2)+mean(2,1)-mean(2,2);
NM(2,1)=mean(1,1)-mean(2,1)+mean(1,2)-mean(2,2);
NM(2,2)=mean(1,1)-mean(1,2)+mean(2,2)-mean(2,1);
Sg=zeros(2,2);
for i=1:2
    for j=1:2
        if NM(i,j)>0
            Sg(i,j)=1;
        elseif NM(i,j)<0
            Sg(i,j)=-1;
        end
    end
end
RI=zeros(m,n);
for i=1:m 
    for j=1:n
        if (i<=m/2)&&(j<=n/2)
                RI(2*i-1,2*j-1)=image1(i,j);
        elseif (i<=m/2)&&(j>n/2)
                RI(2*i-1,2*j-n)=image1(i,3*n/2-j+1);
        elseif (i>m/2)&&(j<=n/2)
            RI(2*i-m,2*j-1)=image1(3*m/2-i+1,j); 
        else
            RI(2*i-m,2*j-n)=image1(3*m/2-i+1,3*n/2-j+1); 
        end
    end       
end
RI=frft2(RI,a,b);
de = SDecompose(RI, m);
cA1=de(1:m/2,1:n/2);
cH1=de(1:m/2,n/2+1:n);
cV1=de(m/2+1:m,1:n/2);
cD1=de(m/2+1:m,n/2+1:n);

B=zeros(m,n);
B(1:m/2,1:n/2)=Sg(1,1)*cA1;
B(1:m/2,n/2+1:n)=Sg(1,2)*cH1;
B(m/2+1:m,1:n/2)=Sg(2,1)*cV1;
B(m/2+1:m,n/2+1:n)=Sg(2,2)*cD1;

C=zeros(m,n);
flag=0;
if abs(NM(2,1))<abs(NM(1,2))
    C=B;
else
    C11=B(1:m/2,1:n/2)';
    C12=B(m/2+1:m,1:n/2)';
    C21=B(1:m/2,n/2+1:n)';
    C22=B(m/2+1:m,n/2+1:n)';
    C=[C11,C12;C21,C22];
    flag=1;
end

end

