function EdgeDetect1(filename)
f=imread(filename);
figure,imshow(f);title('原始图像')
[width,height,l]=size(f);
if l>1
    f=rgb2gray(f);
end
g=zeros(width,height);
h=zeros(width,height);
df=im2double(f);

wx=[-1 0;1 0];
wy=[-1 1;0 0];
for i=2:width-1
    for j=2:height-1
        gw=[df(i,j) df(i,j+1);df(i+1,j) df(i+1,j+1)];
        g(i,j)=sqrt((sum(sum(wx.*gw)))^2+(sum(sum(wy.*gw)))^2);
    end
end

T=0.25*max(g(:));
h=g>=T;
figure,imshow(h);title('边缘检测结果')