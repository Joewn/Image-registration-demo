function [FusionImage,RegistrationImage]=Fusion(handles)
I=handles.Old_I;
J=handles.Old_J;
x=handles.RegistrationParameters(1);
y=handles.RegistrationParameters(2);
ang=-handles.RegistrationParameters(3);

[nrows,ncols]=size(J);
width=nrows;
height=ncols;
new_J=uint8(zeros(width,height));

a=(width-1)/2;
c=a;
b=(height-1)/2;
d=b;
 
rad=pi/180*ang;
t1=[1 0 0;0 1 0;x y 1];
t2=[1 0 0;0 1 0;-a -b 1];
t3=[cos(rad) -sin(rad) 0;sin(rad) cos(rad) 0;0 0 1];
t4=[1 0 0;0 1 0;c d 1];
T=t2*t3*t4*t1;
tform=maketform('affine',T);

tx=zeros(width,height);
ty=zeros(width,height);
for i=1:width
    for j=1:height
        tx(i,j)=i;
    end
end
for i=1:width
    for j=1:height
        ty(i,j)=j;
    end
end
[w z]=tforminv(tform,tx,ty);

for i=1:width
    for j=1:height
        source_x=w(i,j);
        source_y=z(i,j);
        if (source_x>=width-1 || source_y>=height-1 || double(uint16(source_x))<=0 || double(uint16(source_y))<=0)
            new_J(i,j)=J(i,j);
        else
            if (source_x/double(uint16(source_x))==1.0) && (source_y/double(uint16(source_y))==1.0)
                new_J(i,j)=J(int16(source_x),int16(source_y));
            else
                a=double(uint16(source_x));
                b=double(uint16(source_y));
                x11=double(J(a,b));
                x12=double(J(a,b+1));
                x21=double(J(a+1,b));
                x22=double(J(a+1,b+1));
                new_J(i,j)=uint8((b+1-source_y)*((source_x-a)*x21+(a+1-source_x)*x11)+(source_y-b)*((source_x-a)*x22+(a+1-source_x)*x12));
            end
        end
    end
end
J=new_J;

I=uint8(I);
J=uint8(J);
RegistrationImage=uint8(J);

I=double(I)/255;
J=double(J)/255;
IJ=double(zeros(width,height));
for m=1:width
    for n=1:height
        if I(m,n)>0.999 || J(m,n)>0.999
            IJ(m,n)=0.8;
        elseif I(m,n)==0 || J(m,n)==0
            IJ(m,n)=0.01;
        else
            IJ(m,n)=(I(m,n)*0.3+J(m,n)*0.7);
        end
    end
end
IJ=IJ*255;
IJ=uint8(IJ);
FusionImage=IJ;
