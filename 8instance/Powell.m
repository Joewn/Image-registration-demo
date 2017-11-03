function [RegistrationParameters]=Powell(handles)
e=0.1;
X0=[-5 -3 -4];
D=[1 0 0;0 1 0;0 0 1];
while(1)
    d1=D(1,:);
    [X1,fX1]=OneDimensionSearch(X0,d1,handles);
    d2=D(2,:);
    [X2,fX2]=OneDimensionSearch(X1,d2,handles);
    d3=D(3,:);
    [X3,fX3]=OneDimensionSearch(X2,d3,handles);
    fX0=PV(X0(1),X0(2),-X0(3),handles);
    Diff=[fX1-fX0 fX2-fX1 fX3-fX2];
    [maxDiff,m]=max(Diff);
    d4=X3-X0;
    temp1=X3-X0;
    Condition1=sum(temp1.*temp1);
    if Condition1<=e
        break
    end
    [X4,fX4,landa]=OneDimensionSearch(X0,d4,handles);
    X0=X4;
    temp2=X4-X3;
    Condition2=sum(temp2.*temp2);
    if Condition2<=e
        X3=X4;
        break
    end
    temp3=sqrt((fX4-fX0)/(maxDiff+eps));
    if (abs(landa)>temp3)
        D(4,:)=d4;
        for i=m:3
            D(i,:)=D(i+1,:);
        end
    end
end
RegistrationParameters(1)=-X3(1);
RegistrationParameters(2)=-X3(2);
RegistrationParameters(3)=-X3(3);
RegistrationParameters(4)=fX3;
