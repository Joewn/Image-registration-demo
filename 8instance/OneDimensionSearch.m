function [Y,fY,landa]=OneDimensionSearch(X,direction,handles)

a=-5;
b=5;
e=0.0001;
c=a+0.382*(b-a);
d=a+0.618*(b-a);
Fc=Fx(c,X,direction,handles);
Fd=Fx(d,X,direction,handles);
n=0;
while(b-a>=e)
    if Fc>Fd
        Fc=Fd;
        a=c;
        b=b;
        c=d;
        d=a+0.628*(b-a);
        Fd=Fx(d,X,direction,handles);
    else
        Fd=Fc;
        a=a;
        b=d;
        d=c;
        c=a+0.382*(b-a);
        Fc=Fx(c,X,direction,handles);
    end
end
Y=X+((b+a)/2)*direction;
landa=(b-a)/2;
fY=-Fx(landa,X,direction,handles);

function [fx]=Fx(x,X,direction,handles)
fx=-PV(X(1)+direction(1)*x,X(2)+direction(2)*x,-X(3)+direction(3)*x,handles);
