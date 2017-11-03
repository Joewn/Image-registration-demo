function [mi]=PV(x,y,ang,handles)
a=handles.I;
a=double(a);
b=handles.J;
b=double(b);
[M,N]=size(a);
hab=zeros(256,256);
ha=zeros(1,256);
hb=zeros(1,256);
if max(max(a))~=min(min(a))
    a=(a-min(min(a)))/(max(max(a))-min(min(a)));
else 
    a=zeros(M,N);
end
if max(max(b))~=min(min(b))
    b=(b-min(min(b)))/(max(max(b))-min(min(b)));
else 
    b=zeros(M,N);
end
a=double(int16(a*255))+1;
b=double(int16(b*255))+1;
[width,height]=size(b);
u=(width-1)/2;
v=(height-1)/2;
rad=pi/180*ang;
t1=[1 0 0;0 1 0;x y 1];
t2=[1 0 0;0 1 0;-u -v 1];
t3=[cos(rad) -sin(rad) 0;sin(rad) cos(rad) 0;0 0 1];
t4=[1 0 0;0 1 0;u v 1];
T=t2*t3*t4*t1;
tform=maketform('affine',T);
coordinate_x=zeros(width,height);
coordinate_y=zeros(width,height);
for i=1:width
    for j=1:height
        coordinate_x(i,j)=i;
    end
end
for i=1:width
    for j=1:height
        coordinate_y(i,j)=j;
    end
end
[w z]=tforminv(tform,coordinate_x,coordinate_y);
for i=1:width
    for j=1:height
        source_x=w(i,j);
        source_y=z(i,j);
        if (source_x>=width-1 || source_y>=height-1 || double(uint16(source_x))<=1|| double(uint16(source_y))<=1)
            hab(a(1,1),a(1,1))=hab(a(1,1),a(1,1))+1;
        else
            m=fix(source_x);
            n=fix(source_y);
            index_b=b(i,j);
            index_a0=a(m,n);
            index_a1=a(m+1,n);
            index_a2=a(m,n+1);
            index_a3=a(m+1,n+1);
            dx=source_x-m;
            dy=source_y-n;
            hab(index_a0,index_b)=hab(index_a0,index_b)+(1-dx)*(1-dy);
            hab(index_a1,index_b)=hab(index_a1,index_b)+dx*(1-dy);
            hab(index_a2,index_b)=hab(index_a2,index_b)+(1-dx)*dy;
            hab(index_a3,index_b)=hab(index_a3,index_b)+dx*dy;
        end
    end
end

habsum=sum(sum(hab));
index=find(hab~=0);
pab=hab/habsum;
Hab=sum(sum(-pab(index).*log2(pab(index))));

pa=sum(pab');
index=find(pa~=0);
Ha = sum(sum(-pa(index).*log2(pa(index))));

pb=sum(pab);
index=find(pb~=0);
Hb = sum(sum(-pb(index).*log2(pb(index))));
mi=Ha+Hb-Hab;
