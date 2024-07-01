clc;
%%复现 
%%Double-encrypted watermarking algorithm based on cosine transform and fractional Fourier 
%%transform in invariant wavelet domain

%%%%%%%%%%%%%%%%%%%%%%%%%%%%读入载体图像和水印图像%%%%%%%%%%%%%%%%%%%%%%%%%
% I=imread('C:\Users\Administrator\desktop\Man.jpg'); %读取载体图像
I=imread('Boat.bmp'); %读取载体图像（已选）
wm=imread('clock.jpg'); %读取水印图像


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%水印图像预处理%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%图像位置置乱：猫脸变换（Arnold变换）
%猫脸变换只能用于N*N的图像
[r,c]=size(wm);%获取水印图像的尺寸
wme=zeros(2*r,2*c);
for i=1:r
    for j=1:c
        wme(2*i-1,2*j-1)=wm(i,j);
        wme(2*i-1,2*j)=wm(i,j);
        wme(2*i,2*j-1)=wm(i,j);
        wme(2*i,2*j)=wm(i,j);
    end
end
wmn=catface1(wme,3,5,2*r,2*c,21);
% wmn=catface1(wm,3,5,r,c,21);


%%%%%%%%%%%%%%%%%%%%%%%%%%水印嵌入%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[p,q]=size(I);%获取载体图像的尺寸
k1= 0.15                                                                                                                                                                                                                                                                                                          ;
k2= 0.03;
%对载体图像做DCT变换，然后RIDWT
Ie=zeros(2*p,2*q);
for i=1:p
    for j=1:q
        Ie(2*i-1,2*j-1)=I(i,j);
        Ie(2*i-1,2*j)=I(i,j);
        Ie(2*i,2*j-1)=I(i,j);
        Ie(2*i,2*j)=I(i,j);
    end
end
% [C,Sg,flag]=RIDWT(I);
[C,Sg,flag]=RIDWT(Ie);
pic=dct2(C);
%     [cA1,cH1,cV1,cD1]=dwt2(I,'haar');
%     [cA2,cH2,cV2,cD2]=dwt2(cA1,'haar');
%     [cA3,cH3,cV3,cD3]=dwt2(cA2,'haar');
% LL=pic(1:p/2,1:q/2);
% HL=pic(1:p/2,q/2+1:q);
% LH=pic(p/2+1:p,1:q/2);
% HH=pic(p/2+1:p,q/2+1:q);
% LL=pic(1:p,1:q);
% HL=pic(1:p,q+1:2*q);
% LH=pic(p+1:2*p,1:q);
% HH=pic(p+1:2*p,q+1:2*q);
% 
% % [cA1,cH1,cV1,cD1]=dwt2(LL,'haar');
% % [cA1_1,cH1_1,cV1_1,cD1_1]=dwt2(HH,'haar');
% [U,S,V]=svd(cA1);%对低频系数矩阵LL进行奇异值分解
% [UU,SS,VV]=svd(cA1_1);%对高频系数矩阵HH进行奇异值分解
LL=pic(1:p,1:q);
HL=pic(1:p,q+1:2*q);
LH=pic(p+1:2*p,1:q);
HH=pic(p+1:2*p,q+1:2*q);
[U,S,V]=svd(LL);%对低频系数矩阵LL进行奇异值分解
[UU,SS,VV]=svd(HH);%对高频系数矩阵HH进行奇异值分解

%对预处理后的水印图像做DCT变换，再进行一级haar小波分解
% wmn1=dct2(wmn);
% [C1,Sg1,flag1]=RIDWT(wmn);

% [cAw1,cHw1,cVw1,cDw1]=dwt2(wmn,'haar');
% LLw=C1(1:r/2,1:c/2);
% HLw=C1(1:r/2,c/2+1:c);
% LHw=C1(r/2+1:r,1:c/2);
% HHw=C1(r/2+1:r,c/2+1:c);
% [Uw,Sw,Vw]=svd(wmn);%对低频系数矩阵cAw1进行奇异值分解
% cAwf1 = frft2(cAw1,0.75,0.75);
cAwf1 = frft2(wmn,0.75,0.75);
[cAw1,cHw1,cVw1,cDw1]=dwt2(cAwf1,'haar');
% cAw1 = frnt2(wmn,0.75,0.75,2);
[Uw,Sw,Vw]=svd(cAw1);%对低频系数矩阵cAw1进行奇异值分解
%在载体图像RIDWT低频区域嵌入水印111
Sw1=zeros(size(LL));
% Sw1=zeros(size(cA1));
Sw1(1:size(Sw,1),1:size(Sw,2))=Sw;
S1=S+k1*Sw1;
LL1=U*S1*V';
% LL1=idwt2(LL1,cH1,cV1,cD1,'haar',[p/2,q/2]);
% LL1=idwt2(LL1,cH1,cV1,cD1,'haar',[p,q]);
%在载体图像RIDWT高频区域嵌入水印
S2=SS+k2*Sw1;
HH1=UU*S2*VV';
% HH1=idwt2(HH1,cH1_1,cV1_1,cD1_1,'haar',[p/2,q/2]);
% HH1=idwt2(HH1,cH1_1,cV1_1,cD1_1,'haar',[p,q]);

image=[LL1,HL;LH,HH1];
% I1=idct2(image);
% % I1= real(frrct2(image,-0.5,-0.5));
% I1=IRIDWT(I1,flag,Sg);
image1=idct2(image);
image1=IRIDWT(image1,flag,Sg);
I1=zeros(p,q);
for i=1:p
    for j=1:q
        I1(i,j)=(image1(2*i-1,2*j-1)+image1(2*i-1,2*j)+image1(2*i,2*j-1)+image1(2*i,2*j))/4;
    end
end
I1=uint8(I1);
% figure,imshow(I1)
PSNR=psnr(I1,I);

%%%%%%%%%%%%%%%%%%%%%%%%%%水印提取%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%对载水印图像进行RIDWT
% NCans=[];
% for k=1:18
    I1k=attack2(I1,0);
    Ie1=zeros(2*p,2*q);
    for i=1:p
        for j=1:q
            Ie1(2*i-1,2*j-1)=I1k(i,j);
            Ie1(2*i-1,2*j)=I1k(i,j);
            Ie1(2*i,2*j-1)=I1k(i,j);
            Ie1(2*i,2*j)=I1k(i,j);
        end
    end
    % [C2,Sg2,flag2]=RIDWT(I1);
    [C2,~,~]=RIDWT(Ie1);
    I2=dct2(C2);
    LL2=I2(1:p,1:q);
%     HL2=I2(1:p,q+1:2*q);
%     LH2=I2(p+1:2*p,1:q);
    HH2=I2(p+1:2*p,q+1:2*q);
    % LL2=I2(1:p/2,1:q/2);
    % HL2=I2(1:p/2,q/2+1:q);
    % LH2=I2(p/2+1:p,1:q/2);
    % HH2=I2(p/2+1:p,q/2+1:q);
    %%%%%%%%%提取嵌入低频区域的水印%%%%%%%%%%
    % [cA11,cH11,cV11,cD11]=dwt2(LL2,'haar');
    % [UI,SI,VI]=svd(cA11);%对低频系数矩阵LL2进行奇异值分解
    [~,SI,~]=svd(LL2);%对低频系数矩阵LL2进行奇异值分解
    Sw11=(SI-S)/k1;
    % %对奇异值阵进行降序排列
    % A=sort(diag(Sw11),'descend');
    A1=Sw11(1:r,1:c);
    % A1=Sw11(1:2*r,1:2*c);
    % A1=Sw11(1:r/2,1:c/2);
    cAw11=Uw*A1*Vw'; 
    % wm1=Uw*A1*Vw';  
    % image1=[cAw11,HLw;LHw,HHw];
    % wm1=IRIDWT(image1,flag1,Sg1);
    % wm1=idwt2(cAw11,cHw1,cVw1,cDw1,'haar',[r,c]);
    % wmn1=idwt2(cAw11,cHw1,cVw1,cDw1,'haar',[2*r,2*c]);
    wmn1=idwt2(cAw11,cHw1,cVw1,cDw1,'haar',[2*r,2*c]);
    wmn1 = real(frft2(wmn1,-0.75,-0.75));
    % wmn1 = real(frnt2(cAw11,-0.75,-0.75,2));
    % wmn1=idwt2(wmn1,cHw1,cVw1,cDw1,'haar',[2*r,2*c]);
    wme1=catface2(wmn1,3,5,2*r,2*c,21);
    % wme1=catface2(cAw11,3,5,2*r,2*c,21);
    wm1=zeros(r,c);
    for i=1:r
        for j=1:c
            wm1(i,j)=(wme1(2*i-1,2*j-1)+wme1(2*i-1,2*j)+wme1(2*i,2*j-1)+wme1(2*i,2*j))/4;
    %         wm1(i,j)=wme1(2*(i-1)+1,2*(j-1)+1);
        end
    end


    %%%%%%%%%提取嵌入高频区域的水印%%%%%%%%%%
    % [cA11_1,cH11_1,cV11_1,cD11_1]=dwt2(HH2,'haar');
    % [UUI,SSI,VVI]=svd(cA11_1);%对高频系数矩阵HH2进行奇异值分解
    [~,SSI,~]=svd(HH2);%对高频系数矩阵HH2进行奇异值分解
    Sw22=(SSI-SS)/k2;
    % B=sort(diag(Sw22),'descend');
    B1=Sw22(1:r,1:c);
    % B1=Sw22(1:2*r,1:2*c);
    % B1=Sw22(1:r/2,1:c/2);
    cAw12=Uw*B1*Vw';
    % wm2=Uw*B1*Vw';
    % image2=[cAw12,HLw;LHw,HHw];
    % wm2=IRIDWT(image2,flag1,Sg1);
    % wm2=idwt2(cAw12,cHw1,cVw1,cDw1,'haar',[r,c]);
    % wmn2=idwt2(cAw12,cHw1,cVw1,cDw1,'haar',[2*r,2*c]);
    wmn2=idwt2(cAw12,cHw1,cVw1,cDw1,'haar',[2*r,2*c]);
    wmn2 = real(frft2(wmn2,-0.75,-0.75));
    % wmn2=idwt2(wmn2,cHw1,cVw1,cDw1,'haar',[2*r,2*c]);
    % wmn2 = real(frnt2(cAw12,-0.75,-0.75,2));
    wme2=catface2(wmn2,3,5,2*r,2*c,21);
    % wme2=catface2(cAw12,3,5,2*r,2*c,21);
    wm2=zeros(r,c);
    for i=1:r
        for j=1:c
            wm2(i,j)=(wme2(2*i-1,2*j-1)+wme2(2*i-1,2*j)+wme2(2*i,2*j-1)+wme2(2*i,2*j))/4;
        end
    end
    wm1=uint8(wm1);
    wm2=uint8(wm2);
    % toc
%     figure,imshow(wm1)
%     figure,imshow(wm2)
    NC1=nc(wm,wm1);
    NC2=nc(wm,wm2);
    %猫脸变换复原
    % wm11=catface2(wmn1,3,5,r,c,21);
    % wm22=catface2(wmn2,3,5,r,c,21);
    % wm11=uint8(wm11);
    % wm22=uint8(wm22);
    % figure,imshow(wm11)
    % figure,imshow(wm22)
    % NC1=nc(wm,wm11);
    % NC2=nc(wm,wm22);
    u=[NC1,NC2];
    NC=max(u);
%     NCans=[NCans,NC];
% end


