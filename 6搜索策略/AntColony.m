function [maxX,maxY,maxValue]=AntColony
Ant=200;
Times=50;
Rou=0.8;
P0=0.2;
Lower_1=-1;
Upper_1=1;
Lower_2=-1;
Upper_2=1;

for i=1:Ant
    X(i,1)=(Lower_1+(Upper_1-Lower_1)*rand);
    X(i,2)=(Lower_2+(Upper_2-Lower_2)*rand);
    Tau(i)=F(X(i,1),X(i,2));
end

step=0.05;
f='-(x.^2+2*y.^2-0.3*cos(3*pi*x)-0.4*cos(4*pi*y)+0.7)';
[x,y]=meshgrid(Lower_1:step:Upper_1,Lower_2:step:Upper_2);
z=eval(f);
figure(1);
mesh(x,y,z);
hold on;
plot3(X(:,1),X(:,2),Tau,'k*')
hold on;
text(0.1,0.8,-0.1,'蚂蚁的初始分布位置')
xlabel('x');ylabel('y');zlabel('f(x,y)');

for T=1:Times
    lamda=1/T;
    [Tau_Best(T),BestIndex]=max(Tau);
    for i=1:Ant
        P(T,i)=(Tau(BestIndex)-Tau(i))/Tau(BestIndex);
    end
    for i=1:Ant
        if P(T,i)<P0
            temp1=X(i,1)+(2*rand-1)*lamda;
            temp2=X(i,2)+(2*rand-1)*lamda;
        else
            temp1=X(i,1)+(Upper_1-Lower_1)*(rand-0.5);
            temp2=X(i,2)+(Upper_2-Lower_2)*(rand-0.5);
        end
        if temp1<Lower_1
            temp1=Lower_1;
        end
        if temp1>Upper_1
            temp1=Upper_1;
        end
        if temp2<Lower_2
            temp2=Lower_2;
        end
        if temp2>Upper_2
            temp2=Upper_2;
        end
        if F(temp1,temp2)>F(X(i,1),X(i,2))
            X(i,1)=temp1;
            X(i,2)=temp2;
        end
    end
    for i=1:Ant
        Tau(i)=(1-Rou)*Tau(i)+F(X(i,1),X(i,2));
    end
end

figure(2);
mesh(x,y,z);
hold on;
x=X(:,1);y=X(:,2);
plot3(x,y,eval(f),'k*');
hold on;
text(0.1,0.8,-0.1,'蚂蚁的最终分布位置');
xlabel('x');
ylabel('y');
zlabel('f(x,y)');

[max_value,max_index]=max(Tau);
maxX=X(max_index,1);
maxY=X(max_index,2);
maxValue=F(X(max_index,1),X(max_index,2));

function [F]=F(x1,x2);
    F=-(x1.^2+2*x2.^2-0.3*cos(3*pi*x1)-0.4*cos(4*pi*x2)+0.7);
    
  