clear
clc
I=imread('Barbara.bmp'); %读取载体图像（已选）
% figure,
% imhist(im2uint8(I));
wm=imread('clock.jpg'); %读取水印图像
%Barbara.bmp mandril_gray.tif 2.bmp Boat.bmp pirate.tif Couple.bmp
% figure,imshow(I);
%%%%%%%%%%对主图像做处理%%%%%%%%%%%

[m,n]=size(I);
%对主图像做1级重新分配不变整数小波变换
II=I;
I=double(I);
[ C,Sg,flag] = RI_RFrWT(I,0.75,0.75);%%可通过调整变换阶数优化效果
cA1=C(1:m/2,1:n/2);
cH1=C(1:m/2,n/2+1:n);
cV1=C(m/2+1:m,1:n/2);
cD1=C(m/2+1:m,n/2+1:n);
[UU1,SS1,VV1]=svd(cA1);
[UU2,SS2,VV2]=svd(cD1);
%%%%%%%%%%对水印图像做处理%%%%%%%%%
[r,c]=size(wm);%获取水印图像的尺寸
wm=double(wm);
[Cw,Sgw,flagw] = RI_RFrWT(wm,0,0);
cAw=Cw(1:r/2,1:c/2);
cHw=Cw(1:r/2,c/2+1:c);
cVw=Cw(r/2+1:r,1:c/2);
cDw=Cw(r/2+1:r,c/2+1:c);


%%%%%%%%%%%%%%%%%%%%%%%%水印嵌入过程%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k1=0.04;
k2=0.01;
cAw1=zeros(size(SS1));
cAw1(1:size(cAw,1),1:size(cAw,2))=cAw;
S1=SS1+k1*cAw1;
S2=SS2+k2*cAw1;
[Uw,Sw,Vw]=svd(S1);
[Uw1,Sw1,Vw1]=svd(S2);
If1=UU1*Sw*VV1';
If2=UU2*Sw1*VV2';

image=[If1,cH1;cV1,If2];
I1 = IRI_RFrWT(image,flag,Sg,-0.75,-0.75);
I1=uint8(I1);
figure,imshow(I1);
PSNR=psnr(I1,II);
figure,
imhist(im2uint8(I1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%鲁棒性测试%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d=input('please input your choice：');
switch d
    case 1
        I1 = medfilt2(I1,[3,3]);
        PSNR1=psnr(I1,II);
        figure,imshow(I1)%将窗口3*3的中值滤波作用于载水印图像
    case 2
        aa=fspecial('average',[3,3]); %生成系统预定义的3*3滤波器  
        I1=imfilter(I1,aa);%用生成的滤波器进行滤波
        PSNR1=psnr(I1,II);
        figure,imshow(I1)%3*3均值滤波
    case 3
        I1=imresize(I1,2);
        I1=imresize(I1,0.5); 
        PSNR1=psnr(I1,II);
        figure,imshow(I1)%对载水印图像进行放缩，先放大两倍,再缩小1/2
    case 4
        I1=imrotate(I1,90,'crop');
        PSNR1=psnr(I1,II);
        figure,imshow(I1) %对载水印图像进行90度的旋转
    case 5
        I1=histeq(I1);%figure,imshow(I1)%对载水印图像进行直方图均衡化
        PSNR1=psnr(I1,II);
        figure,imshow(I1)
    case 6
         I1=imnoise(I1,'gaussian',0,0.05);
         PSNR1=psnr(I1,II);
         figure,imshow(I1)%加均值为0方差为0.05的高斯噪声
    case 7
        imwrite(I1,'I1.jpg','jpg','quality',75);
        I1=imread('I1.jpg');
        PSNR1=psnr(I1,II);
        figure,imshow(I1) %对载水印图像进行压缩因子为30的JPEG压缩
    case 8
        I1=imnoise(I1,'salt & pepper',0.05);
        PSNR1=psnr(I1,II);
        figure,imshow(I1)%加密度为0.05的椒盐噪声  
    case 9
        I1=imnoise(I1,'speckle',0.05);
        PSNR1=psnr(I1,II);
        figure,imshow(I1)
    case 10
        temp1=randperm(512,20);
        temp2=randperm(512,20);
        I1(temp1,:)=0;
        I1(:,temp2)=0;
        PSNR1=psnr(I1,II);
        figure,imshow(I1)%随机删除载水印图像的20行20列 
    case 11
        hh=fspecial('gaussian',[3,3]);
        I1=imfilter(I1,hh,'conv');
        PSNR1=psnr(I1,II);
        figure,imshow(I1)%用窗口3*3高斯滤波作用于载水印图像
    case 12   
        I1=double(I1);
        h=[-1 -1 -1;-1 9 -1;-1 -1 -1];
        I1=conv2(I1,h,'same');
        I1=uint8(I1);
        PSNR1=psnr(I1,II);
        figure,imshow(I1);%锐化攻击
    case 13
        I1=flipud(I1);
        PSNR1=psnr(I1,II);
        figure,imshow(I1)
    case 14
        I1=fliplr(I1);
        PSNR1=psnr(I1,II);
        figure,imshow(I1)
    case 15
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
        I1=uint8(I1);
        PSNR1=psnr(I1,II);
        figure,imshow(I1)%圆形区域裁剪
    case 16
        se=translate(strel(1),[20,20]);
        I1=imdilate(I1,se);
        PSNR1=psnr(I1,II);
        figure,imshow(I1)%图像向右向下分别平移20个像素   
    case 17
        I1=II;
        I1(1:256,1:256)=0;
        PSNR1=psnr(I1,II);
        figure,imshow(I1);
    case 18
        I1=II;
        I1(257:512,1:256)=0;
        PSNR1=psnr(I1,II);
        figure,imshow(I1);
    case 19
        I1=imrotate(I1,45,'crop');%对载水印图像进行90度的旋转
        PSNR1=psnr(I1,II);
        figure,imshow(I1)%图像向右向下分别平移20个像素 
end



%%%%%%%%%%%%%%%%%%%%%%%%水印提取过程%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I1=double(I1);
[ C1,Sg1,flag1] = RI_RFrWT(I1,0.75,0.75);
cA11=C1(1:m/2,1:n/2);
cD11=C1(m/2+1:m,n/2+1:n);
[UU3,SS3,VV3]=svd(cA11);
[UU4,SS4,VV4]=svd(cD11);
SS5=Uw*SS3*Vw';
SS6=Uw1*SS4*Vw1';
LLw1=(SS5-SS1)/k1;
LLw2=(SS6-SS2)/k2;
LLw1=LLw1(1:r/2,1:c/2);
LLw2=LLw2(1:r/2,1:c/2);
image1=[LLw1,cHw;cVw,cDw];
image2=[LLw2,cHw;cVw,cDw];
wm1 = IRI_RFrWT(image1,flagw,Sgw,0,0);
wm2 = IRI_RFrWT(image2,flagw,Sgw,0,0);
wm1=uint8(wm1);
wm2=uint8(wm2);
NC1=nc(wm,wm1);
NC2=nc(wm,wm2);
if NC1>NC2
    figure,imshow(wm1);
else
    figure,imshow(wm2);
end



