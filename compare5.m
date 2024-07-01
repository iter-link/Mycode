clear
clc
I=imread('Boat.bmp'); 
wm=imread('clock.jpg'); %读取水印图像
[m,n]=size(I);
[ C,Sg,flag] = RI_IWT(I);
cA1=C(1:m/2,1:n/2);
cH1=C(1:m/2,n/2+1:n);
cV1=C(m/2+1:m,1:n/2);
cD1=C(m/2+1:m,n/2+1:n);
[QI1,RI1]=qr(cA1);
[QI2,RI2]=qr(cD1);
[UU1,SS1,VV1]=svd(RI1);
[UU2,SS2,VV2]=svd(RI2);


%%%%%%%%%%对水印图像做处理%%%%%%%%%
[r,c]=size(wm);%获取水印图像的尺寸
% %帐篷映射
q1=0.53;
q2=0.78;
x1(1)=0.83;
x2(1)=0.28;
for i=1:r*c
   if (x1(i)>0)&&(x1(i)<=q1)
       x1(i+1)=x1(i)/q1;
   elseif (x1(i)>q1)&&(x1(i)<1)
       x1(i+1)=(1-x1(i))/(1-q1);
   end
   if (x2(i)>0)&&(x2(i)<=q2)
       x2(i+1)=x2(i)/q2;
   elseif (x2(i)>q2)&&(x2(i)<1)
       x2(i+1)=(1-x2(i))/(1-q2);
   end
end
X1=x1(2:end);
X2=x2(2:end);
%将产生的随机序列转化为矩阵,并做hessenberg分解
K1=reshape(X1,r,r);
K2=reshape(X2,c,c);
[Q1,R1]=qr(K1);
[Q2,R2]=qr(K2);
%水印图像的随机化
wm=double(wm);
wmn=Q1*wm*Q2;
[Cw,Sgw,flagw] = RI_IWT(wm);
cAw=Cw(1:r/2,1:c/2);
cHw=Cw(1:r/2,c/2+1:c);
cVw=Cw(r/2+1:r,1:c/2);
cDw=Cw(r/2+1:r,c/2+1:c);


%%%%%%%%%%%%%%%%%%%%%%%%水印嵌入过程%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%根据图片调整适当嵌入强度
k1=0.036;
k2=0.1;
cAw1=zeros(size(SS1));
cAw1(1:size(cAw,1),1:size(cAw,2))=cAw;
S1=SS1+k1*cAw1;
S2=SS2+k2*cAw1;
[Qw1,Rw1]=qr(S1);
[Qw2,Rw2]=qr(S2);
[Uw,Sw,Vw]=svd(Rw1);
[Uw1,Sw1,Vw1]=svd(Rw2);
If1=QI1*UU1*Sw*VV1';
If2=QI2*UU2*Sw1*VV2';

% image=[If1,cH1;cV1,cD1];
image=[If1,cH1;cV1,If2];
%一级重新分配不变整数逆小波变换
I1 = IRI_IWT(image,flag,Sg);
I1=uint8(I1);
% figure,imshow(I1)
% save as I1;
% imwrite('I1.jpg');
PSNR=psnr(I1,I);
SSIM=ssim(I1,I);



%帐篷映射
q1=3.85;
q2=3.76;
x1(1)=0.83;
x2(1)=0.28;
for i=1:r*c
       x1(i+1)=x1(i)*q1*(1-x1(i));
       x2(i+1)=x2(i)*q2*(1-x2(i));
end
X1=x1(2:end);
X2=x2(2:end);
%将产生的随机序列转化为矩阵,并做hessenberg分解
K1=reshape(X1,r,r);
K2=reshape(X2,c,c);
[Q1,R1]=qr(K1);
[Q2,R2]=qr(K2);
Qw1new=Q1*Qw1*Q2;
Qw2new=Q1*Qw2*Q2;
Uwnew=Q1*Uw*Q2;
Vwnew=Q1*Vw*Q2;
Uw1new=Q1*Uw1*Q2;
Vw1new=Q1*Vw1*Q2;
Qw1newf=frft2(Qw1new,0.7,0.45);
Qw2newf=frft2(Qw2new,0.7,0.45);
Uwnewf=frft2(Uwnew,0.7,0.45);
Vwnewf=frft2(Vwnew,0.7,0.45);
Uw1newf=frft2(Uw1new,0.7,0.45);
Vw1newf=frft2(Vw1new,0.7,0.45);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%鲁棒性测试%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% d=input('please input your choice：');
% switch d
%     case 6
%          I1=imnoise(I1,'gaussian',0,0.05);    
%     case 8
%         I1=imnoise(I1,'salt & pepper',0.05); 
%     case 9
%         I1=imnoise(I1,'speckle',0.05);
% end
%%%%%%%%%%%%%%%%%%%%%%%%水印提取过程%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%帐篷映射
q11=3.85;
% q11=3.81;
q22=3.76;
% q22=3.75;
x11(1)=0.83;
% x11(1)=0.87;
x22(1)=0.28;
% x22(1)=0.27;
for i=1:r*c
       x11(i+1)=x11(i)*q11*(1-x11(i));
       x22(i+1)=x22(i)*q22*(1-x22(i));
end
X11=x11(2:end);
X22=x22(2:end);
%将产生的随机序列转化为矩阵,并做hessenberg分解
K11=reshape(X11,r,r);
K22=reshape(X22,c,c);
[Q11,R11]=qr(K11);
[Q22,R22]=qr(K22);
Qw1new1=frft2(Qw1newf,-0.7,-0.45);
% Qw1new1=frft2(Qw1newf,-0.69,-0.69);
Qw2new1=frft2(Qw2newf,-0.7,-0.45);
Uwnew1=frft2(Uwnewf,-0.7,-0.45);
Vwnew1=frft2(Vwnewf,-0.7,-0.45);
Uw1new1=frft2(Uw1newf,-0.7,-0.45);
Vw1new1=frft2(Vw1newf,-0.7,-0.45);
Qw11=Q11^(-1)*Qw1new1*Q22^(-1);
Qw21=Q11^(-1)*Qw2new1*Q22^(-1);
Uw11=Q11^(-1)*Uwnew1*Q22^(-1);
Vw11=Q11^(-1)*Vwnew1*Q22^(-1);
Uw12=Q11^(-1)*Uw1new1*Q22^(-1);
Vw12=Q11^(-1)*Vw1new1*Q22^(-1);
[ C1,Sg1,flag1] = RI_IWT(I1);
cA11=C1(1:m/2,1:n/2);
cD11=C1(m/2+1:m,n/2+1:n);
[QIw1,RIw1]=qr(cA11); 
[QIw2,RIw2]=qr(cD11);
[UU3,SS3,VV3]=svd(RIw1);
[UU4,SS4,VV4]=svd(RIw2);
%%提取奇异值阵S
% SS5=Qw1*Uw*SS3*Vw';
% SS6=Qw2*Uw1*SS4*Vw1';
SS5=Qw11*Uw11*SS3*Vw11';
SS6=Qw21*Uw12*SS4*Vw12';
LLw1=(SS5-SS1)/k1;
LLw2=(SS6-SS2)/k2;
LLw1=LLw1(1:r/2,1:c/2);
LLw2=LLw2(1:r/2,1:c/2);
image1=[LLw1,cHw;cVw,cDw];
image2=[LLw2,cHw;cVw,cDw];
%一级重新分配不变整数逆小波变换
wm1 = IRI_IWT(image1,flagw,Sgw);
wm2 = IRI_IWT(image2,flagw,Sgw);
% wm1=Q1^(-1)*wmn1*Q2^(-1);
% wm2=Q1^(-1)*wmn2*Q2^(-1);
wm1=uint8(wm1);
wm2=uint8(wm2);
% figure,imshow(wm1)
% figure,imshow(wm2)
NC1=nc(wm,wm1);
NC2=nc(wm,wm2);
NC=max(NC1,NC2);


