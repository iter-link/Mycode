%����A new reliable optimized image watermarking scheme based on the integer wavelet  transform 
%and singular value decomposition for copyright protection%%%%%%%%%%%%%%%%%%
clear
clc
I=imread('Boat.bmp'); %��ȡ����ͼ����ѡ��
wm=imread('clock.jpg'); %��ȡˮӡͼ��
%����ͼ��������С���任
[p,q]=size(I);
[r,c]=size(wm);
de = SDecompose(I, 512);
LL=de(1:p/2,1:q/2);
%ȡ��Ƶ�Ӵ���SVD
[U,S,V]=svd(LL);
%��ˮӡͼ����SVD
wm=double(wm);
[Uw,Sw,Vw]=svd(wm);

%ˮӡǶ��
%����ͼƬ�����ʵ�Ƕ��ǿ��
MZF=ones(p/2,q/2)*30;
S_new=S+MZF.*Uw;
LL_new=U*S_new*V';

%������С���任
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

%��ȡ��Կ
%����ˮӡͼ����һ������С���任
de_new = SDecompose(I1, 512);
LL1=de_new(1:p/2,1:q/2);

%ȡ��Ƶ�Ӵ���SVD
[U1,S1,V1]=svd(LL1);
S_new_1=S_new*U1;%����ˮӡͼ��I1,S_new_1��Sw*Vw'��Ϊ�㷨����Կ

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%³���Բ���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d=input('please input your choice��');
switch d
    case 1
        I1 = medfilt2(I1,[3,3]);
        PSNR1=psnr(I,I1);
        SSIM1=ssim(I,I1);
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
%         figure,imshow(I1)%������2*2����ֵ�˲���������ˮӡͼ��
    case 2
        aa=fspecial('average',[3,3]); %����ϵͳԤ�����3*3�˲���  
        I1=imfilter(I1,aa);%�����ɵ��˲��������˲�
        PSNR1=psnr(I,I1);
        SSIM1=ssim(I,I1);
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
%         figure,imshow(I1)%��ֵ�˲�
    case 3
        I1=imresize(I1,2);
        I1=imresize(I1,0.5);
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
%         figure,imshow(I1)%�ô���5*5����׼��Ϊ1.6�ĸ�˹�˲���������ˮӡͼ��
    case 4 
        I1=imrotate(I1,90,'crop');
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
%         figure,imshow(I1)%�ô���9*9����άά���˲���������ˮӡͼ��
    case 5
        I1=histeq(I1);%
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
%         figure,imshow(I1)%����ˮӡͼ����0.9��GammaУ��
    case 6
       I1=imnoise(I1,'gaussian',0,0.05);
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1) %����ˮӡͼ�����90�ȵ���ת
    case 7
        imwrite(I1,'I1.jpg','jpg','quality',75);
        I1=imread('I1.jpg');
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1) %����ˮӡͼ�����ѹ������Ϊ30��JPEGѹ��
    case 8
         I1=imnoise(I1,'salt & pepper',0.05);
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1)%���ɾ����ˮӡͼ���20��20�� 
    case 9
        temp1=randperm(512,20);
        temp2=randperm(512,20);
        I1(temp1,:)=0;
        I1(:,temp2)=0;
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1)%����ˮӡͼ����з���
    case 10
         hh=fspecial('gaussian',[3,3]);
        I1=imfilter(I1,hh,'conv');
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1)%����ˮӡͼ�����ֱ��ͼ����
    case 11
       I1=double(I1);
        h=[-1 -1 -1;-1 9 -1;-1 -1 -1];
        I1=conv2(I1,h,'same');
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1)%����ˮӡͼ��������·�ת,�з�ת
    case 12
        I1=flipud(I1);
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1)%����ˮӡͼ��������ҷ�ת���з�ת
    case 13
         I1=fliplr(I1);
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1)%�Ӱߵ�����  
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
        I1=I1.*A;%������Ĥ�ü�ͼ�������ڿ�ͼ
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1)%�ӽ�������  
    case 15
        se=translate(strel(1),[20,20]);
        I1=imdilate(I1,se);
         [FSIM1,~] = FeatureSIM(I,I1);
%          PSIM1 = PSIM(I,I1);
         ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
         figure,imshow(I1)%�Ӹ�˹����
    case 16
        I1(1:256,1:256)=0;
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1)%ͼ���������·ֱ�ƽ��20������  
    case 17   
       I1(257:512,1:256)=0;
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1);%�񻯹���
    case 18
        I1=imrotate(I1,45,'crop');
        [FSIM1,~] = FeatureSIM(I,I1);
%         PSIM1 = PSIM(I,I1);
        ADD_SSIM1 = ADD(double(I),double(I1),'SSIM');
        figure,imshow(I1)%����ˮӡͼ����20*20���ص��˶�ģ��
end


%ˮӡ��ȡ����
%����ˮӡͼ��������С���任
de_new1 = SDecompose(I1, 512);
LL11=de_new1(1:p/2,1:q/2);
%ȡ��Ƶ�Ӵ���SVD
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
