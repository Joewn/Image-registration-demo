function Hough_LineDetect(filename,degree_range,line_length,dtheta,drho)

if nargin<5
    drho=1;
end
if nargin<4
    dtheta=1;
end
if nargin<3
    line_length=100;
end
if nargin<2
    degree_range=[-90,90];
end

I1=imread(filename);
I=rgb2gray(I1);
%figure,imshow(I);
[width,height]=size(I);
BI=edge(I);

dtheta=dtheta*pi/180;
radian_upper=max(degree_range*pi/180);
radian_lower=min(degree_range*pi/180);
radian_range=radian_upper-radian_lower;

rho_max=(sqrt(width^2+height^2));
nrho=ceil(2*rho_max/drho);
theta_value=[radian_lower:dtheta:radian_upper];
ntheta=length(theta_value);

rho_matrix=zeros(nrho,ntheta);
hough_line=zeros(width,height);

[rows,cols]=find(BI);
pointcount=length(rows);
rho_value=zeros(pointcount,ntheta);
for i=1:pointcount
    m=rows(i);
    n=cols(i);
    for k=1:ntheta
        rho=(m*cos(theta_value(k)))+(n*sin(theta_value(k)));
        rho_index=round((rho+rho_max)/drho);
        rho_matrix(rho_index,k)=rho_matrix(rho_index,k)+1;
        rho_value(rho_index,k)=rho;
    end
end

index=find(rho_matrix>line_length);
for k=1:length(index)
    [rho_th,theta_th]=ind2sub(size(rho_matrix),index(k));
    theta=theta_value(theta_th);
    rho=rho_value(rho_th,theta_th);
    for i=1:pointcount
        x=rows(i);
        y=cols(i);
        rate=(x*cos(theta)+y*sin(theta))/rho;
        if (rate>1-10^-3 & rate<1+10^-3)
            hough_line(x,y)=1;
        end
    end
end

figure;imshow(I);title('原始图像')
figure;imshow(BI);title('边缘检测后的图像')
figure;imshow(hough_line);title('hough变换检测到的直线');