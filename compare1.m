%复现A new reliable optimized image watermarking scheme based on the integer wavelet  transform 
%and singular value decomposition for copyright protection%%%%%%%%%%%%%%%%%%
clear
clc
I=imread('Boat.bmp'); %读取载体图像（已选）
wm=imread('clock.jpg'); %读取水印图像
%对主图像做整数小波变换
[p,q]=size(I);
[r,c]=size(wm);
de = SDecompose(I, 512);
LL=de(1:p/2,1:q/2);
%取低频子带做SVD
[U,S,V]=svd(LL);
%对水印图像做SVD
wm=double(wm);
[Uw,Sw,Vw]=svd(wm);

%水印嵌入
%根据图片调整适当嵌入强度
MZF=ones(p/2,q/2)*30;
S_new=S+MZF.*Uw;
LL_new=U*S_new*V';

%逆整数小波变换
de1=de;
de1(1:p/2,1:q/2)=LL_new;
I1 = SRecompose(de1, 512);
I1=uint8(I1);
% % figure,imshow(I1)
PSNR=psnr(I,I1);
SSIM=ssim(I,I1);  
[FSIM,~] = FeatureSIM(I,I1);
% % PSIM = PSIM(double(I),double(I1));
% ADD_SSIM = ADD(double(I),double(I1),'SSIM');

%获取密钥
%对载水印图像做一级整数小波变换
de_new = SDecompose(I1, 512);
LL1=de_new(1:p/2,1:q/2);

%取低频子带做SVD
[U1,S1,V1]=svd(LL1);
S_new_1=S_new*U1;%将载水印图像I1,S_new_1，Sw*Vw'作为算法的秘钥

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%鲁棒性测试%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d=input('please input your choice：');
switch d
    case 1
        I1 = medfilt2(I1,[3,3]);
        PSNR1=psnr(I,I1);
        SSIM1=ssim(I,I1);
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
%         figure,imshow(I1)%将窗口2*2的中值滤波作用于载水印图像
    case 2
        aa=fspecial('average',[3,3]); %生成系统预定义的3*3滤波器  
        I1=imfilter(I1,aa);%用生成的滤波器进行滤波
        PSNR1=psnr(I,I1);
        SSIM1=ssim(I,I1);
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
%         figure,imshow(I1)%均值滤波
    case 3
        I1=imresize(I1,2);
        I1=imresize(I1,0.5);
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
%         figure,imshow(I1)%用窗口5*5，标准差为1.6的高斯滤波作用于载水印图像
    case 4 
        I1=imrotate(I1,90,'crop');
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
%         figure,imshow(I1)%用窗口9*9，二维维纳滤波作用于载水印图像
    case 5
        I1=histeq(I1);%
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
%         figure,imshow(I1)%对载水印图像做0.9的Gamma校正
    case 6
       I1=imnoise(I1,'gaussian',0,0.05);
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1) %对载水印图像进行90度的旋转
    case 7
        imwrite(I1,'I1.jpg','jpg','quality',75);
        I1=imread('I1.jpg');
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1) %对载水印图像进行压缩因子为30的JPEG压缩
    case 8
         I1=imnoise(I1,'salt & pepper',0.05);
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1)%随机删除载水印图像的20行20列 
    case 9
        temp1=randperm(512,20);
        temp2=randperm(512,20);
        I1(temp1,:)=0;
        I1(:,temp2)=0;
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1)%对载水印图像进行放缩
    case 10
         hh=fspecial('gaussian',[3,3]);
        I1=imfilter(I1,hh,'conv');
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1)%对载水印图像进行直方图均衡
    case 11
       I1=double(I1);
        h=[-1 -1 -1;-1 9 -1;-1 -1 -1];
        I1=conv2(I1,h,'same');
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1)%对载水印图像进行上下翻转,行翻转
    case 12
        I1=flipud(I1);
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1)%对载水印图像进行左右翻转，列翻转
    case 13
         I1=fliplr(I1);
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1)%加斑点噪声  
    case 14
        I1=double(I1);
        A=zeros(512);
        for i=1:512
            for j=1:512
                if ((i-256)^2+(j-256)^2)<=256^2
                    A(i,j)=1;
                end
            end
        end
        I1=I1.*A;%利用掩膜裁剪图像，类似于抠图
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1)%加椒盐噪声  
    case 15
        se=translate(strel(1),[20,20]);
        I1=imdilate(I1,se);
         [FSIM1,~] = FeatureSIM(I,I1);
%          PSIM1 = PSIM(I,I1);
         ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
         figure,imshow(I1)%加高斯噪声
    case 16
        I1(1:256,1:256)=0;
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1)%图像向右向下分别平移20个像素  
    case 17   
       I1(257:512,1:256)=0;
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1);%锐化攻击
    case 18
        I1=imrotate(I1,45,'crop');
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1)%对载水印图像做20*20像素的运动模糊
end


%水印提取过程
%对载水印图像做整数小波变换
de_new1 = SDecompose(I1, 512);
LL11=de_new1(1:p/2,1:q/2);
%取低频子带做SVD
[UU,SS,VV]=svd(LL11);
% S_new1=S_new_1/U1;
S_new1=S_new_1/UU;
% Uw11=(SS-S)./MZF;
Uw11=(S_new-SS)./MZF;
% Uw111=Uw11(1:r,1:c);
wm1=Uw11*Sw*Vw';
wm1=uint8(wm1);
figure,imshow(wm1)
NC=nc(wm,wm1); 
% % PSNRwm1=psnr(wm,wm1);
[FSIMwm1,~] = FeatureSIM(wm,wm1);
% ADD_SSIMwm1 = ADD(double(wm),double(wm1),'SSIM');
