function LineDetect(filename,direction)
f1=imread(filename);
f=rgb2gray(f1);
figure,imshow(f);
[width,height]=size(f);
number=100;
h=zeros(width,height);
%figure,imshow(h)       
if number>width*height
    number=width*height;
end
df=im2double(f);
switch direction
    case 0
        w=[-1 -1 -1;4 4 4;-1 -1 -1];
    case 45
        w=[-1 -1 4;-1 4 -1;4 -1 -1]; 
    case 90
        w=[-1 4 -1;-1 4 -1;-1 4 -1];
    case 135
        w=[4 -1 -1;-1 4 -1;-1 -1 4]; 
    otherwise 
        w=[-1 -1 -1;4 4 4;-1 -1 -1];
end
g=imfilter(df,w);
g=abs(g)./8;
[data,index]=sort(g(:));
T=data(width*height-number+1);
for i=1:width
    for j=1:height
        if g(i,j)>=T
            h(i,j)=1;
        end
    end
end
figure,imshow(h)