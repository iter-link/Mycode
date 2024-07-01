function SS=choose(image)
%从大小为N*N的矩阵中随机选取n*n个位置，并以所选位置的元素为中心，w*w为窗口组成n*n个新矩阵
[p,q]=size(image);
k=3;
rng(3);
a=[];
t=0;
while 1
    temp=randi([3,p-2],1);
    if(isempty(find(a==temp)))
        a=[a,temp];
        t=t+1;
    end
    if(t>=p/2)
        break;
    end
end

b=[];
t1=0;
while 1
    temp1=randi([3,q-2],1);
    if(isempty(find(b==temp1)))
        b=[b,temp1];
        t1=t1+1;
    end
    if(t1>=q/2)
        break;
    end
end

SS=zeros(p/2,q/2);
for i=1:p/2
    for j=1:q/2
        A=ones(p,q)*0.0231;
        A(a(i)-2:a(i)+2,b(j)-2:b(j)+2)=image(a(i)-2:a(i)+2,b(j)-2:b(j)+2);
        A=A(A~=0.0231);
        A1{i,j}=reshape(A,5,5);
        [U{i,j},S{i,j},V{i,j}]=svd(A1{i,j});
        SS(i,j)=S{i,j}(1,1);
    end
end
end
