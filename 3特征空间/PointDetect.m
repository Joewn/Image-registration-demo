function PointDetect(filename,number)
f1=imread(filename);
f=rgb2gray(f1);
figure,imshow(f);
[width,height]=size(f);
h=zeros(width,height);
%figure,imshow(h)      
if number>width*height
    number=width*height;
end
df=im2double(f);
w=[-1 -1 -1;-1 8 -1;-1 -1 -1];
g=imfilter(df,w);
g=abs(g)./8;
[data index]=sort(g(:));
T=data(width*height-number+1);
for i=1:width
    for j=1:height
        if g(i,j)>=T
            h(i,j)=1;
        end
    end
end
figure,imshow(h)