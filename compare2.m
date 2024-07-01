%%Multipurpose image watermarking in the domain of dwt based on svd and abc. Pattern Recognition Letters
%Pattern Recognition Letters （2017）
%对主图像做三级DWT,奇异值分解
%对水印图像做一级DWT和奇异值分解
clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%读入载体图像和水印图像%%%%%%%%%%%%%%%%%%%%%%%%%
I=imread('Barbara.bmp'); %读取载体图像（已选）
wm=imread('clock.jpg'); %读取水印图像
wm=imresize(wm,[128,128]);
% wm=rgb2gray(wm);%将彩色图像转化为灰度图像
% figure,imshow(wm)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%水印图像预处理%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[r,c]=size(wm);%获取水印图像的尺寸
[cAw,cHw,cVw,cDw]=dwt2(wm,'haar');
[Uaw,Saw,Vaw]=svd(cAw);
[Uhw,Shw,Vhw]=svd(cHw);
[Uvw,Svw,Vvw]=svd(cVw);
[Udw,Sdw,Vdw]=svd(cDw);
PCaw=Uaw*Saw;
PChw=Uhw*Shw;
PCvw=Uvw*Svw;
PCdw=Udw*Sdw;

%%%%%%%%%%%%%%%%%%%%%%%%%%水印嵌入%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[p,q]=size(I);%获取载体图像的尺寸
%根据图片调整适当嵌入强度
k1= 0.06;
k2= 0.08;
k3= 0.12;
k4= 0.12;
[cA1,cH1,cV1,cD1]=dwt2(I,'haar');
[cA2,cH2,cV2,cD2]=dwt2(cA1,'haar');
[cA3,cH3,cV3,cD3]=dwt2(cA2,'haar');
[Ua,Sa,Va]=svd(cA3);
[Uh,Sh,Vh]=svd(cH3);
[Uv,Sv,Vv]=svd(cV3);
[Ud,Sd,Vd]=svd(cD3);
PCaw1=zeros(size(Sa));
PChw1=zeros(size(Sa));
PCvw1=zeros(size(Sa));
PCdw1=zeros(size(Sa));
PCaw1(1:size(PCaw,1),1:size(PCaw,2))=PCaw;
PChw1(1:size(PChw,1),1:size(PChw,2))=PChw;
PCvw1(1:size(PCvw,1),1:size(PCvw,2))=PCvw;
PCdw1(1:size(PCdw,1),1:size(PCdw,2))=PCdw;
Sa_modify=Sa+k1*PCaw1;
Sh_modify=Sh+k2*PChw1;
Sv_modify=Sv+k3*PCvw1;
Sd_modify=Sd+k4*PCdw1;
cA3_modify=Ua*Sa_modify*Va';
cH3_modify=Uh*Sh_modify*Vh';
cV3_modify=Uv*Sv_modify*Vv';
cD3_modify=Ud*Sd_modify*Vd';
cA2_modify=idwt2(cA3_modify,cH3_modify,cV3_modify,cD3_modify,'haar',[p/4,q/4]);
cA1_modify=idwt2(cA2_modify,cH2,cV2,cD2,'haar',[p/2,q/2]);
I1=idwt2(cA1_modify,cH1,cV1,cD1,'haar',[p,q]);
I1=uint8(I1);
figure,imshow(I1)
PSNR=psnr(I1,I);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%鲁棒性测试%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d=input('please input your choice：');
switch d
  case 1
        I1 = medfilt2(I1,[3,3]);
        PSNR1=psnr(I1,I);
        figure,imshow(I1)%将窗口3*3的中值滤波作用于载水印图像
    case 2
        aa=fspecial('average',[3,3]); %生成系统预定义的3*3滤波器  
        I1=imfilter(I1,aa);%用生成的滤波器进行滤波
        PSNR1=psnr(I1,I);
        figure,imshow(I1)%3*3均值滤波
    case 3
        I1=imresize(I1,2);
        I1=imresize(I1,0.5); 
        PSNR1=psnr(I1,I);
        figure,imshow(I1)%对载水印图像进行放缩，先放大两倍,再缩小1/2
    case 4
        I1=imrotate(I1,90,'crop');
        PSNR1=psnr(I1,I);
        figure,imshow(I1) %对载水印图像进行90度的旋转
    case 5
        I1=histeq(I1);%figure,imshow(I1)%对载水印图像进行直方图均衡化
        PSNR1=psnr(I1,I);
        figure,imshow(I1)
    case 6
         I1=imnoise(I1,'gaussian',0,0.05);
         PSNR1=psnr(I1,I);
         figure,imshow(I1)%加均值为0方差为0.05的高斯噪声
    case 7
        imwrite(I1,'I1.jpg','jpg','quality',75);
        I1=imread('I1.jpg');
        PSNR1=psnr(I1,I);
        figure,imshow(I1) %对载水印图像进行压缩因子为30的JPEG压缩
    case 8
        I1=imnoise(I1,'salt & pepper',0.05);
        PSNR1=psnr(I1,I);
        figure,imshow(I1)%加密度为0.05的椒盐噪声  
    case 9
        temp1=randperm(512,20);
        temp2=randperm(512,20);
        I1(temp1,:)=0;
        I1(:,temp2)=0;
        PSNR1=psnr(I1,I);
        figure,imshow(I1)%随机删除载水印图像的20行20列 
    case 10
        hh=fspecial('gaussian',[3,3]);
        I1=imfilter(I1,hh,'conv');
        PSNR1=psnr(I1,I);
        figure,imshow(I1)%用窗口3*3高斯滤波作用于载水印图像
    case 11   
        I1=double(I1);
        h=[-1 -1 -1;-1 9 -1;-1 -1 -1];
        I1=conv2(I1,h,'same');
        I1=uint8(I1);
        PSNR1=psnr(I1,I);
        figure,imshow(I1);%锐化攻击
    case 12
        I1=flipud(I1);
        PSNR1=psnr(I1,I);
        figure,imshow(I1)
    case 13
        I1=fliplr(I1);
        PSNR1=psnr(I1,I);
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
        PSNR1=psnr(I1,I);
        figure,imshow(I1)%圆形区域裁剪
    case 15
        se=translate(strel(1),[20,20]);
        I1=imdilate(I1,se);
        PSNR1=psnr(I1,I);
        figure,imshow(I1)%图像向右向下分别平移20个像素   
    case 16
        I1(1:256,1:256)=0;
        figure,imshow(I1);
    case 17
        I1(257:512,1:256)=0;
        figure,imshow(I1);
    case 18
        I1=imrotate(I1,45,'crop');%对载水印图像进行90度的旋转
        figure,imshow(I1)%图像向右向下分别平移20个像素 
end
   


%%%%%%%%%%%%%%%%%%%%%%%%%%水印提取%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[cA11,cH11,cV11,cD11]=dwt2(I1,'haar');
[cA22,cH22,cV22,cD22]=dwt2(cA11,'haar');
[cA33,cH33,cV33,cD33]=dwt2(cA22,'haar');
XL=cA33-cA3;
XH=cH33-cH3;
XV=cV33-cV3;
XD=cD33-cD3;
[Ua,Sa,Va]=svd(cA3);
[Uh,Sh,Vh]=svd(cH3);
[Uv,Sv,Vv]=svd(cV3);
[Ud,Sd,Vd]=svd(cD3);
PCL=Ua'*XL*Va/k1;
PCH=Uh'*XH*Vh/k2;
PCV=Uv'*XV*Vv/k3;
PCD=Ud'*XD*Vd/k4;
PCaw_ext=PCL(1:r/2,1:c/2);
PChw_ext=PCH(1:r/2,1:c/2);
PCvw_ext=PCV(1:r/2,1:c/2);
PCdw_ext=PCD(1:r/2,1:c/2);
cAw_ext=PCaw_ext*Vaw';
cHw_ext=PChw_ext*Vhw';
cVw_ext=PCvw_ext*Vvw';
cDw_ext=PCdw_ext*Vdw';
wm_ext=idwt2(cAw_ext,cHw_ext,cVw_ext,cDw_ext,'haar',[r,c]);
wm_ext=uint8(wm_ext);
figure,imshow(wm_ext)
NC=nc(wm,wm_ext);
