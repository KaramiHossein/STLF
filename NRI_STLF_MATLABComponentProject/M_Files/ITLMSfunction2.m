function [Pn,Tn]=ITLMSfunction2(P,T,num)
%% Addidg Code by Mostafa Gholami
% ITLMS Code to Densification of Database
if nargin == 3 && isempty(num)==0
    PP=P(:,num);
    TT=T(:,num);
    num0=[];
    for i=1:size(P,2)
        if isempty(find(num == i)) == 1
            num0=[num0,i];
        end
    end
    if size(num,2) == size(P,2)
        num0=num;
    end
else
    PP=P;
    TT=T;
end
XX=[PP;TT];
    X0DB=[P;T];
    Landa=0.1;
    stdev=std(X0DB',1);
    stdevp=stdev*sqrt(2);
    VX=0;
    VXX0=0;
    for i=1:size(XX,2)
        for k=1:size(X0DB,2)
            Gind=0;
            for t=1:size(XX,1)
                Gind=Gind+((XX(t,i)-X0DB(t,k))/stdevp(1,t))^2;
            end
            VXX0=VXX0+exp(Gind/-2);
        end
        for k=1:size(XX,2)
            Gind=0;
            for t=1:size(XX,1)
                Gind=Gind+((XX(t,i)-XX(t,k))/stdevp(1,t))^2;
            end
            VX=VX+exp(Gind/-2);
        end
    end
    VX=VX/size(XX,2)^2;
    VXX0=VXX0/(size(XX,2)*size(X0DB,2));
    c1=(1-Landa)/VX;
    c2=(2*Landa)/VXX0;
    maxerror=1;
    XNEW=XX;
    Xnew=zeros(size(XX,1),size(XX,2));
    while maxerror > 1e-6
        for i=1:size(XX,2)
            S1=0;S2=0;
            S3=0;S4=0;
            for k=1:size(XX,2)
                GindS1=0;
                for t=1:size(XX,1)
                    GindS1=GindS1+((XX(t,i)-XX(t,k))/stdevp(1,t))^2;
                end
                S1=S1+exp(GindS1/-2).*XX(:,k);
                S3=S3+exp(GindS1/-2);
            end
            for k=1:size(X0DB,2)
                GindS2=0;
                for t=1:size(XX,1)
                    GindS2=GindS2+((XX(t,i)-X0DB(t,k))/stdevp(1,t))^2;
                end
                S2=S2+exp(GindS2/-2).*X0DB(:,k);
                S4=S4+exp(GindS2/-2);
            end
            Xnew(:,i)=(c1.*S1+c2.*S2)./(c1.*S3+c2.*S4);
            error=0;
            for t=1:size(XX,1)
                error=error+(Xnew(t,i)-XX(t,i))^2;
            end
            error(i,1)=sqrt(error);
        end
        XNEW=[XNEW,Xnew];
        XX=Xnew;
        if size(XNEW,2)>300
            maxerror=1e-8;
        else
            maxerror=max(error);
        end
    end
    if nargin==3 && isempty(num)==0
        Pn=[P(:,num0),XNEW(1:size(P,1),:)];
        Tn=[T(:,num0),XNEW(size(P,1)+1:end,:)];
    else
        Pn=[P,XNEW(1:size(P,1),:)];
        Tn=[T,XNEW(size(P,1)+1:end,:)];
    end
