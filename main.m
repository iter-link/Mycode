clear
clc
I=imread('Barbara.bmp'); %��ȡ����ͼ����ѡ��
% figure,
% imhist(im2uint8(I));
wm=imread('clock.jpg'); %��ȡˮӡͼ��
%Barbara.bmp mandril_gray.tif 2.bmp Boat.bmp pirate.tif Couple.bmp
% figure,imshow(I);
%%%%%%%%%%����ͼ��������%%%%%%%%%%%

[m,n]=size(I);
%����ͼ����1�����·��䲻������С���任
II=I;
I=double(I);
[ C,Sg,flag] = RI_RFrWT(I,0.75,0.75);%%��ͨ�������任�����Ż�Ч��
cA1=C(1:m/2,1:n/2);
cH1=C(1:m/2,n/2+1:n);
cV1=C(m/2+1:m,1:n/2);
cD1=C(m/2+1:m,n/2+1:n);
[UU1,SS1,VV1]=svd(cA1);
[UU2,SS2,VV2]=svd(cD1);
%%%%%%%%%%��ˮӡͼ��������%%%%%%%%%
[r,c]=size(wm);%��ȡˮӡͼ��ĳߴ�
wm=double(wm);
[Cw,Sgw,flagw] = RI_RFrWT(wm,0,0);
cAw=Cw(1:r/2,1:c/2);
cHw=Cw(1:r/2,c/2+1:c);
cVw=Cw(r/2+1:r,1:c/2);
cDw=Cw(r/2+1:r,c/2+1:c);


%%%%%%%%%%%%%%%%%%%%%%%%ˮӡǶ�����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%³���Բ���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d=input('please input your choice��');
switch d
    case 1
        I1 = medfilt2(I1,[3,3]);
        PSNR1=psnr(I1,II);
        figure,imshow(I1)%������3*3����ֵ�˲���������ˮӡͼ��
    case 2
        aa=fspecial('average',[3,3]); %����ϵͳԤ�����3*3�˲���  
        I1=imfilter(I1,aa);%�����ɵ��˲��������˲�
        PSNR1=psnr(I1,II);
        figure,imshow(I1)%3*3��ֵ�˲�
    case 3
        I1=imresize(I1,2);
        I1=imresize(I1,0.5); 
        PSNR1=psnr(I1,II);
        figure,imshow(I1)%����ˮӡͼ����з������ȷŴ�����,����С1/2
    case 4
        I1=imrotate(I1,90,'crop');
        PSNR1=psnr(I1,II);
        figure,imshow(I1) %����ˮӡͼ�����90�ȵ���ת
    case 5
        I1=histeq(I1);%figure,imshow(I1)%����ˮӡͼ�����ֱ��ͼ���⻯
        PSNR1=psnr(I1,II);
        figure,imshow(I1)
    case 6
         I1=imnoise(I1,'gaussian',0,0.05);
         PSNR1=psnr(I1,II);
         figure,imshow(I1)%�Ӿ�ֵΪ0����Ϊ0.05�ĸ�˹����
    case 7
        imwrite(I1,'I1.jpg','jpg','quality',75);
        I1=imread('I1.jpg');
        PSNR1=psnr(I1,II);
        figure,imshow(I1) %����ˮӡͼ�����ѹ������Ϊ30��JPEGѹ��
    case 8
        I1=imnoise(I1,'salt & pepper',0.05);
        PSNR1=psnr(I1,II);
        figure,imshow(I1)%���ܶ�Ϊ0.05�Ľ�������  
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
        figure,imshow(I1)%���ɾ����ˮӡͼ���20��20�� 
    case 11
        hh=fspecial('gaussian',[3,3]);
        I1=imfilter(I1,hh,'conv');
        PSNR1=psnr(I1,II);
        figure,imshow(I1)%�ô���3*3��˹�˲���������ˮӡͼ��
    case 12   
        I1=double(I1);
        h=[-1 -1 -1;-1 9 -1;-1 -1 -1];
        I1=conv2(I1,h,'same');
        I1=uint8(I1);
        PSNR1=psnr(I1,II);
        figure,imshow(I1);%�񻯹���
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
        I1=I1.*A;%������Ĥ�ü�ͼ�������ڿ�ͼ
        I1=uint8(I1);
        PSNR1=psnr(I1,II);
        figure,imshow(I1)%Բ������ü�
    case 16
        se=translate(strel(1),[20,20]);
        I1=imdilate(I1,se);
        PSNR1=psnr(I1,II);
        figure,imshow(I1)%ͼ���������·ֱ�ƽ��20������   
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
        I1=imrotate(I1,45,'crop');%����ˮӡͼ�����90�ȵ���ת
        PSNR1=psnr(I1,II);
        figure,imshow(I1)%ͼ���������·ֱ�ƽ��20������ 
end



%%%%%%%%%%%%%%%%%%%%%%%%ˮӡ��ȡ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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



