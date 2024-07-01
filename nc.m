function NC = nc(image1,image2)
%衡量提取的水印与原始水印的相似程度
%计算nc（归一化相关系数）
if (size(image1))~=(size(image2))
    error('image1<>image2');
end
image1=double(image1);
image2=double(image2);
[M,N]=size(image1);
d1=0;
d2=0;
d3=0;
for i=1:M
    for j=1:N
        d1=d1+image1(i,j)*image2(i,j);
        d2=d2+image1(i,j)*image1(i,j);
        d3=d3+image2(i,j)*image2(i,j);
    end
end
NC=d1/(sqrt(d2)*sqrt(d3));
return

end

