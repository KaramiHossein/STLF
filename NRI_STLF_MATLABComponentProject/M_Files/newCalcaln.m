function newCalcaln(Year)

Year=double(Year);

cd('Calendar');
name1=['caln',num2str(Year-1),'.xls'];
B=xlsread(name1);    % The Calendar of Previous Year

name2=['ghcal','.xls'];
D=xlsread(name2);     %The Ghamari Calendar

%For Considering Kabise Year
if (rem((Year-79),4)==0)
    L=366;
else L=365;
end

%The Weekday Type Of the Latest Day in Previous Year
calcod=B(size(B,1),4);
if calcod==7
    calcodnew=1;   %The Weekday Type Of the First Day in the specified Year
else calcodnew=calcod+1;
end

%For Considering Ghamari Codes  
for ee=1:size(D,1)
    if D(ee,1)==Year
        D1=D(ee:size(D,1),:);
        break;
    end
end

if D1(size(D1,1),1)~=Year
    for ee=1:size(D1,1)
        if  D1(ee,1)==Year+1 
            D2=D1(1:ee-1,:);
            break;
        end
    end
else D2=D1;
end

S=zeros(1,size(D2,1));
for i=1:size(D2,1)
    if ( D2(i,4)==1 |  D2(i,4)==2 | D2(i,4)==5 | D2(i,4)==6 | D2(i,4)==7 | D2(i,4)==8 | D2(i,4)==13 | D2(i,4)==15 )
        S(i)=5;      %Azaye Mazhabi Code
    elseif D2(i,4)==16
        S(i)=8;
    else
        S(i)=3;     %Jashne Mazhabi Code
    end
end

A=zeros(L,5);  %New Calendar 
for i=1:L-1
    A(i,1)=Year;        %Year Column
    A(i,2:3)=B(i,2:3);  %Month & Day Column 
    A(i,4)=calcodnew;   %Week Day Code Column
    if calcodnew==7
        calcodnew=1;
    else calcodnew=calcodnew+1;
    end
%     if ( i==185 )   %The Numbers of Special Conditions in Shamsi Calendar
%         A(i,5)=7;
    if ( i==1 | i==2 | i==3 | i==4 | i==12 | i==13 | i==328 | i==365)   %The Numbers of Jashne Melli Days
        A(i,5)=2;
    elseif (i==76 | i==77)  %The Numbers of azaye Melli Days 
        A(i,5)=4;
    else A(i,5)=1;  %Ordinary Days Code
    end    
end

A(L,1)=Year;
A(L,2)=12;
if L==365
    A(L,3)=29;
    A(L,5)=2;
else
    A(L,3)=30;
    A(L,5)=6;
end
A(L,4)=calcodnew;

for i=1:size(D2,1)
    for j=1:L
        if ( A(j,2)==D2(i,2) & A(j,3)==D2(i,3) )
            A(j,5)=S(i);
        end
    end
end

%For Considering Between Holiday Days
for i=5:(size(A,1)-1)
    if ( A(i-1,5)>=2 & A(i-1,5)<=5  &  A(i+1,5)>=2 & A(i+1,5)<=5  & A(i,5)==1 & A(i,4)~=7)
        A(i,5)=6;
    elseif ( A(i,4)==1  &  A(i,5)==1  &  A(i+1,5)>=2 & A(i+1,5)<=5 )
        A(i,5)=6;
    elseif ( A(i,4)==6  &  A(i,5)==1  &  A(i-1,5)>=2 & A(i-1,5)<=5 )
        A(i,5)=6;
    end
end
    
name3 = ['caln',num2str(Year),'.xls'];
xlswrite(name3,A);
cd('..');
