function I1=attack2(I1,k)
switch k
    case 1
        I1 = medfilt2(I1,[3,3]);
    case 2
        aa=fspecial('average',[3,3]);   
        I1=imfilter(I1,aa);%用生成的滤波器进行滤波
    case 3
        I1=imresize(I1,2);
        I1=imresize(I1,0.5); 
    case 4
        I1=imrotate(I1,90,'crop');
    case 5
        I1=histeq(I1);%figure,imshow(I1)%对载水印图像进行直方图均衡化
    case 6
         I1=imnoise(I1,'gaussian',0,0.05);
    case 7
        imwrite(I1,'I1.jpg','jpg','quality',75);
        I1=imread('I1.jpg');
    case 8
        I1=imnoise(I1,'salt & pepper',0.05);
    case 9
        temp1=randperm(512,20);
        temp2=randperm(512,20);
        I1(temp1,:)=0;
        I1(:,temp2)=0;
    case 10
        hh=fspecial('gaussian',[3,3]);
        I1=imfilter(I1,hh,'conv');
    case 11   
        I1=double(I1);
        h=[-1 -1 -1;-1 9 -1;-1 -1 -1];
        I1=conv2(I1,h,'same');
        I1=uint8(I1);
    case 12
        I1=flipud(I1);
    case 13
        I1=fliplr(I1);
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
    case 15
        se=translate(strel(1),[20,20]);
        I1=imdilate(I1,se);
    case 16
        I1(1:256,1:256)=0;
    case 17
        I1(257:512,1:256)=0;
    case 18
        I1=imrotate(I1,45,'crop');%对载水印图像进行90度的旋转
end