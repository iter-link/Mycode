function obj=func2(x)
I=imread('C:\mydata\image\image1\Car.bmp'); %读取载体图像（已选）
wm=imread('clock.jpg'); %读取水印图像
%mandril_gray.tif 2.bmp Boat.bmp pirate.tif Couple.bmp
% figure,imshow(I);
%%%%%%%%%%对主图像做处理%%%%%%%%%%%
[m,n]=size(I);
%对主图像做1级重新分配不变整数小波变换
II=I;
I=double(I);
[ C,Sg,flag] = RI_RFrWT(I,x(1),x(2));%%可通过调整变换阶数优化效果
cA1=C(1:m/2,1:n/2);
cH1=C(1:m/2,n/2+1:n);
cV1=C(m/2+1:m,1:n/2);
cD1=C(m/2+1:m,n/2+1:n);
[UU1,SS1,VV1]=svd(cA1);
[UU2,SS2,VV2]=svd(cD1);

%%%%%%%%%%对水印图像做处理%%%%%%%%%
[r,c]=size(wm);%获取水印图像的尺寸
wm=double(wm);
[Cw,Sgw,flagw] = RI_RFrWT(wm,0,0);%%可通过调整变换阶数优化效果
cAw=Cw(1:r/2,1:c/2);
cHw=Cw(1:r/2,c/2+1:c);
cVw=Cw(r/2+1:r,1:c/2);
cDw=Cw(r/2+1:r,c/2+1:c);


%%%%%%%%%%%%%%%%%%%%%%%%水印嵌入过程%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k1=x(3);% Barbara PSNR+NC1
k2=x(4);% Barbara %%可通过调整嵌入强度优化效果
% k1=0.07;
% k2=0.04;
% k1=0.08;
% k2=0.05;
% k1=0.035;%Baboon PSNR
% k2=0.01;%Baboon PSNR
% k1=0.045;% house
% k2=0.01;%house
% k1=0.045;%boat.man.couple.airplane
% k2=0.01; %boat.man.couple.airplane14
% k1=0.04; %NC2,NC3,4,
% k2=0.01; %NC2,NC3,4
cAw1=zeros(size(SS1));
cAw1(1:size(cAw,1),1:size(cAw,2))=cAw;
S1=SS1+k1*cAw1;
S2=SS2+k2*cAw1;
[Uw,Sw,Vw]=svd(S1);
[Uw1,Sw1,Vw1]=svd(S2);
If1=UU1*Sw*VV1';
If2=UU2*Sw1*VV2';

image=[If1,cH1;cV1,If2];
I1 = IRI_RFrWT(image,flag,Sg,-x(1),-x(2));
I1=uint8(I1);
% figure,imshow(I1);
PSNR=psnr(I1,II);
NCsum=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%鲁棒性测试%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for d=1:18
    I2=I1;
    switch d
    case 1
        I2 = medfilt2(I2,[3,3]);
    case 2
        aa=fspecial('average',[3,3]); %生成系统预定义的3*3滤波器  
        I2=imfilter(I2,aa);%用生成的滤波器进行滤波
    case 3
        I2=imresize(I2,2);
        I2=imresize(I2,0.5); 
    case 4
        I2=imrotate(I2,90,'crop');
    case 5
        I2=histeq(I2);%figure,imshow(I1)%对载水印图像进行直方图均衡化
    case 6
         I2=imnoise(I2,'gaussian',0,0.05);
    case 7
        imwrite(I2,'I1.jpg','jpg','quality',75);
        I2=imread('I1.jpg');
    case 8
        I2=imnoise(I2,'salt & pepper',0.05); 
    case 9
        temp1=randperm(512,20);
        temp2=randperm(512,20);
        I2(temp1,:)=0;
        I2(:,temp2)=0;
    case 10
        hh=fspecial('gaussian',[3,3]);
        I2=imfilter(I2,hh,'conv');
    case 11   
        I2=double(I2);
        h=[-1 -1 -1;-1 9 -1;-1 -1 -1];
        I2=conv2(I2,h,'same');
    case 12
        I2=flipud(I2);
    case 13
        I2=fliplr(I2);
    case 14
        I2=double(I2);
        A=zeros(512);
        for i=1:512
            for j=1:512
                if ((i-256)^2+(j-256)^2)<=256^2
                    A(i,j)=1;
                end
            end
        end
        I2=I2.*A;%利用掩膜裁剪图像，类似于抠图
    case 15
        se=translate(strel(1),[20,20]);
        I2=imdilate(I2,se);
    case 16
        I2(1:256,1:256)=0;
    case 17
        I2(257:512,1:256)=0;
    case 18
        I2=imrotate(I1,45,'crop');%对载水印图像进行90度的旋转
    end

%%%%%%%%%%%%%%%%%%%%%%%%水印提取过程%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I2=double(I2);
[ C1,Sg1,flag1] = RI_RFrWT(I2,x(1),x(2));
cA11=C1(1:m/2,1:n/2);
cD11=C1(m/2+1:m,n/2+1:n);
[UU3,SS3,VV3]=svd(cA11);
[UU4,SS4,VV4]=svd(cD11);
% Vw=encryption(Vw,0.9);
SS5=Uw*SS3*Vw';
SS6=Uw1*SS4*Vw1';
LLw1=(SS5-SS1)/x(3);
LLw2=(SS6-SS2)/x(4);
LLw1=LLw1(1:r/2,1:c/2);
LLw2=LLw2(1:r/2,1:c/2);
image1=[LLw1,cHw;cVw,cDw];
image2=[LLw2,cHw;cVw,cDw];
wm1 = IRI_RFrWT(image1,flagw,Sgw,0,0);
wm2 = IRI_RFrWT(image2,flagw,Sgw,0,0);
wm1=uint8(wm1);
wm2=uint8(wm2);
% figure,imshow(wm1)
% figure,imshow(wm2)
NC1=nc(wm,wm1);
NC2=nc(wm,wm2);
NCmax=max(NC1,NC2);
NCsum=NCsum+NCmax;
end
obj=0.4/PSNR+0.6/NCsum;
end