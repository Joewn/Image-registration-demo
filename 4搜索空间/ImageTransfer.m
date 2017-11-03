function ImageTransfer(filename,x,y,ang)
f=imread(filename);
OldImage=rgb2gray(f);
figure,imshow(OldImage);title('原图');
[nrows,ncols]=size(OldImage);
width=nrows;
height=ncols;
NewImage=uint8(zeros(width,height));

a=(width-1)/2;
c=a;
b=(height-1)/2;
d=b;

rad=pi/180*ang;
t1=[1 0 0;0 1 0;x,y,1];
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
            NewImage(i,j)=0;
        else
            if (source_x/double(uint16(source_x))==1.0) && (source_y/double(uint16(source_y))==1.0)
                NewImage(i,j)=OldImage(int16(source_x),int16(source_y));
            else
                a=double(uint16(source_x));
                b=double(uint16(source_y));
                x11=double(OldImage(a,b));
                x12=double(OldImage(a,b+1));
                x21=double(OldImage(a+1,b));
                x22=double(OldImage(a+1,b+1));
                NewImage(i,j)=uint8((b+1-source_y)*((source_x-a)*x21+(a+1-source_x)*x11)+(source_y-b)*((source_x-a)*x22+(a+1-source_x)*x12));
            end
        end
    end
end
I=NewImage;
figure,imshow(I);title('处理后图像');