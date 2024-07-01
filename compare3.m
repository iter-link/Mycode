
%%%%%%复现An efficient lossless robust watermarking scheme by integrating 
%%redistributed invariant wavelet and fractional Fourier transforms
clear
clc
I=imread('Barbara.bmp');
I=double(I);
wm=imread('logo1.png');
wm = rgb2gray(wm);
wm=imresize(wm, [64, 64]);
for i=1:64
    for j=1:64
    if wm(i,j)==255
        wm(i,j)=1;
    end
    end
end
for i=1:64
    for j=1:64
    if wm(i,j)>1
        wm(i,j)=0;
    end
    end
end
ww=reshape(wm,1,64*64);
[p,q]=size(I);
[r,c]=size(wm);



%%%版权注册过程
%生成master share

%对主图像做处理
[C,Sg,flag]=RIDWT(I);%对主图像做RIDWT
C11=C(1:p/2,1:q/2);
C12=C(1:p/2,q/2+1:q);
C21=C(p/2+1:p,1:q/2);
C22=C(p/2+1:p,q/2+1:q);
[cA1,cH1,cV1,cD1]=dwt2(C11,'haar');%取低频子带C11做一级haar小波分解
cA1f = frft2(cA1,0.5,0.24);%取低频子带cA1做FRFT
SS=choose(cA1f);
SS_avg=mean2(SS);
BM=zeros(r,c);
for i=1:r
    for j=1:c
        if SS(i,j)>=SS_avg
            BM(i,j)=1;
        else
            BM(i,j)=0;
        end
    end
end

for i=1:r
    for j=1:c
        if BM(i,j)==1
            MS(2*i-1:2*i,2*j-1:2*j)=[0,1;1,0];
        else
            MS(2*i-1:2*i,2*j-1:2*j)=[1,0;0,1];
        end
    end
end

B=ones(2);
for i=1:r
    for j=1:c
        if wm(i,j)==1
            OS(2*i-1:2*i,2*j-1:2*j)=MS(2*i-1:2*i,2*j-1:2*j);
        else
            OS(2*i-1:2*i,2*j-1:2*j)=B-MS(2*i-1:2*i,2*j-1:2*j);
        end
    end
end
PSNR=psnr(I,I);
II=I;
I1=I;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%鲁棒性测试%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
        temp1=randperm(512,20);
        temp2=randperm(512,20);
        I1(temp1,:)=0;
        I1(:,temp2)=0;
        PSNR1=psnr(I1,II);
        figure,imshow(I1)%随机删除载水印图像的20行20列 
    case 10
        hh=fspecial('gaussian',[3,3]);
        I1=imfilter(I1,hh,'conv');
        PSNR1=psnr(I1,II);
        figure,imshow(I1)%用窗口3*3高斯滤波作用于载水印图像
    case 11   
        I1=double(I1);
        h=[-1 -1 -1;-1 9 -1;-1 -1 -1];
        I1=conv2(I1,h,'same');
        I1=uint8(I1);
        PSNR1=psnr(I1,II);
        figure,imshow(I1);%锐化攻击
    case 12
        I1=flipud(I1);
        PSNR1=psnr(I1,II);
        figure,imshow(I1)
    case 13
        I1=fliplr(I1);
        PSNR1=psnr(I1,II);
        figure,imshow(I1)
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
        I1=uint8(I1);
        PSNR1=psnr(I1,II);
        figure,imshow(I1)%圆形区域裁剪
    case 15
        se=translate(strel(1),[20,20]);
        I1=imdilate(I1,se);
        PSNR1=psnr(I1,II);
        figure,imshow(I1)%图像向右向下分别平移20个像素   
    case 16
        I1=II;
        I1(1:256,1:256)=0;
        PSNR1=psnr(I1,II);
        figure,imshow(I1);
    case 17
        I1=II;
        I1(257:512,1:256)=0;
        PSNR1=psnr(I1,II);
        figure,imshow(I1);
    case 18
        I1=imrotate(I1,45,'crop');%对载水印图像进行90度的旋转
        PSNR1=psnr(I1,II);
        figure,imshow(I1)%图像向右向下分别平移20个像素 
end



I1=uint8(I1);
%%%版权认证过程
[C1,Sg1,flag1]=RIDWT(I1);%对遭受攻击的图像做RIDWT
C1_11=C1(1:p/2,1:q/2);
C1_12=C1(1:p/2,q/2+1:q);
C1_21=C1(p/2+1:p,1:q/2);
C1_22=C1(p/2+1:p,q/2+1:q);
[cA11,cH11,cV11,cD11]=dwt2(C1_11,'haar');%取低频子带C11做一级haar小波分解
cA1f1 = frft2(cA11,0.5,0.24);%取低频子带cA1做FRFT
SS1=choose(cA1f1);
SS1_avg=mean2(SS1);
BM1=zeros(r,c);
for i=1:r
    for j=1:c
        if SS1(i,j)>=SS1_avg
            BM1(i,j)=1;
        else
            BM1(i,j)=0;
        end
    end
end

for i=1:r
    for j=1:c
        if BM1(i,j)==1
            MS1(2*i-1:2*i,2*j-1:2*j)=[0,1;1,0];
        else
            MS1(2*i-1:2*i,2*j-1:2*j)=[1,0;0,1];
        end
    end
end

for i=1:2*r
    for j=1:2*c
        if (MS1(i,j)==0)&&(OS(i,j)==0)
            W(i,j)=0;
        elseif (MS1(i,j)==1)&&(OS(i,j)==1)
            W(i,j)=1;
        else
            W(i,j)=0;
%         W=bitxor(MS1,OS);
        end
    end
end
for i=1:r
    for j=1:c
        w=W(2*i-1,2*j-1)+W(2*i-1,2*j)+W(2*i,2*j-1)+W(2*i,2*j);
        if w>=2
            wm1(i,j)=1;
        else
            wm1(i,j)=0;
        end
    end
end
wm1=im2bw(wm1);
% figure,imshow(wm1)
NC=nc(wm,wm1);

















