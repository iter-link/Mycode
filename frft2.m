function f2 = frft2(image,a1,a2)
%��ά��ɢ��������Ҷ�任����ɢ�㷨
[N,N]=size(image);
% image=double(image);
%%%%%%%%%%%%%%%%%%%%FRFT�˾��������%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%���ɷ�������Ҷ�任������ֵ���ɵĶԽ���%%%%%%%%%%%%%%%%%%
b1=a1*pi/2;
b2=a2*pi/2;
da1=zeros(1,N);
da2=zeros(1,N);

if (mod(N,2)~=0)
    for i=1:N
        da1(i)=exp(-j*b1*(i-1));
        da2(i)=exp(-j*b2*(i-1));
    end
else
    for i=1:N-1   
        da1(i)=exp(-j*b1*(i-1));
        da2(i)=exp(-j*b2*(i-1));
    end
    da1(N)=exp(-j*b1*N);
    da2(N)=exp(-j*b2*N);
end
Da1=diag(da1);
Da2=diag(da2);

%%%%%%%%%%%%%%�������������󣬽����õ�DFRFT�ĺ˾���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w=2*pi/N;
v1=zeros(1,N);
for i=1:N
    v1(i)=2*cos((i-1)*w);
end
v2=ones(N-1,1);
v3=ones(N-1,1);
S=diag(v1)+diag(v2,-1)+diag(v3,1);%�������Խ���
S(1,N)=1;
S(N,1)=1;
[V,~]=eig(S);
F1=V*Da1*V';
F2=V*Da2*V';
f2=F1*image*F2;
% f2=real(f2);
end

