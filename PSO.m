clear all;             
close all;              
clc;                    
N=10;                  %%����
D=4;                   
T=50;                  
c1=2;                 
c2=2;                 
w=0.8;           
aXmax=1;
aXmin=0;
aYmax=1;
aYmin=0;
avmax=0.2;
avmin=0.1;
Xmax=0.2;        %%���Ƕ��ǿ��
Xmin=0.01;    %%��СǶ��ǿ��           
Vmax=0.005;                
Vmin=0.003;   
x=rand(N,D);
x(1:N,1)=x(1:N,1)*(aXmax-aXmin)+aXmin;
x(1:N,2)=x(1:N,2)*(aYmax-aYmin)+aYmin;
x(1:N,3)=x(1:N,3)*(Xmax-Xmin)+Xmin;
x(1:N,4)=x(1:N,4)*(Xmax-Xmin)+Xmin;
% x=rand(N,D) * (Xmax-Xmin)+Xmin;
v=rand(N,D);
v(1:N,1:2)=x(1:N,1:2)*(avmax-avmin)+avmin;
v(1:N,3:4)=x(1:N,3:4)*(Vmax-Vmin)+Vmin;
% v=rand(N,D) * (Vmax-Vmin)+Vmin;
p=x;
pbest=ones(N,1);%%��ǰÿ����������λ��
for i=1:N
    pbest(i)=func2(x(i,:));%%�ڴ˴�����Ŀ�꺯��ֵ
end
%%%%%%%%%%%%%%%%%%%��ʼ��ȫ������λ�ú�����ֵ%%%%%%%%%%%%%%%%%%
g=ones(1,D);
gbest=inf;
for i=1:N
    if(pbest(i)<gbest)
        g=p(i,:);
        gbest=pbest(i);
    end
end
gb=ones(1,T);%���ڼ�¼ÿ����ȫ������

for i=1:T
    for j=1:N
        %%%%%%%%%%%%%%���¸�������λ�ú�����ֵ%%%%%%%%%%%%%%%%%
        if (func2(x(j,:))<pbest(j))%������
            p(j,:)=x(j,:);
            pbest(j)=func2(x(j,:));
        end
        %%%%%%%%%%%%%%%%����ȫ������λ�ú�����ֵ%%%%%%%%%%%%%%%
        if(pbest(j)<gbest)
            g=p(j,:);
            gbest=pbest(j);
        end
        
        v(j,:)=w*v(j,:)+c1*rand*(p(j,:)-x(j,:))+c2*rand*(g-x(j,:));
        x(j,:)=x(j,:)+v(j,:);
        %%%%%%%%%%%%%%%%%%%%�߽���������%%%%%%%%%%%%%%%%%%%%%%
        for ii=1:D
%             if (v(j,ii)>Vmax)  |  (v(j,ii)< Vmin)
%                 v(j,ii)=rand * (Vmax-Vmin)+Vmin;
%             end
%             if (x(j,ii)>Xmax)  |  (x(j,ii)< Xmin)
%                 x(j,ii)=rand * (Xmax-Xmin)+Xmin;
%             end
              if ii==1
                  if (v(j,ii)>avmax)|(v(j,ii)<avmin)
                   v(j,ii)=rand * (avmax-avmin)+avmin;
                  end
              end
              if ii==2
                  if (v(j,ii)>avmax)|(v(j,ii)<avmin)
                   v(j,ii)=rand * (avmax-avmin)+avmin;
                  end
              end
              if ii== 3
                  if(v(j,ii)>Vmax)|(v(j,ii)<Vmin)
                      v(j,ii)=rand * (Vmax-Vmin)+Vmin;
                  end
              end
              if ii== 4
                  if(v(j,ii)>Vmax)|(v(j,ii)<Vmin)
                      v(j,ii)=rand * (Vmax-Vmin)+Vmin;
                  end
              end
              if ii==1
                  if (x(j,ii)>aXmax)  |  (x(j,ii)< aXmin)
                   x(j,ii)=rand * (aXmax-aXmin)+aXmin;
                  end
              end
              if ii==2
                  if (x(j,ii)>aYmax)  |  (x(j,ii)< aYmin)
                   x(j,ii)=rand * (aYmax-aYmin)+aYmin;
                  end
              end
              if ii==3
                  if (x(j,ii)>Xmax)  |  (x(j,ii)<Xmin)
                   x(j,ii)=rand * (Xmax-Xmin)+Xmin;
                  end
              end
              if ii==4
                  if (x(j,ii)>Xmax)  |  (x(j,ii)< Xmin)
                   x(j,ii)=rand * (Xmax-Xmin)+Xmin;
                  end
              end
        end
       end
     gb(i)=gbest;
end
g;                                 
gb(end);                   



