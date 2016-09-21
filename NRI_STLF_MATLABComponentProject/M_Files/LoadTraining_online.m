function [Indtesta,net,INPUTsNUM,TempNUM]=LoadTraining_online(SPECIAL,yy,mm,dd,A,TT2,InputData,k,AToday,TAToday)

numberofneurons=15;
smothing_factor=1/3;

max_trainingdata=2000;

if ((mm==1)||(mm==7))
    IND1=[find((A(:,1)<yy).*(A(:,2)==mm));find((A(:,1)<yy).*(A(:,2)==mm+1))];
elseif ((mm==12)||(mm==6))
    IND1=[find((A(:,1)==yy).*(A(:,2)==mm-1));find((A(:,1)<yy).*(A(:,2)==mm-1));find((A(:,1)<yy).*(A(:,2)==mm))];
else
    IND1=[find((A(:,1)==yy).*(A(:,2)==mm-1));find((A(:,1)<yy).*(A(:,2)==mm+1));find((A(:,1)<yy).*(A(:,2)==mm));find((A(:,1)<yy).*(A(:,2)==mm-1))];
end


if ~isempty(TT2)
    A=[A TT2(:,7)];
    D=A(:,30);
    D=D';
    D1=D(1,:);
    DD1=repmat(D1',1,24);
    DF1=reshape(DD1',1,24*size(DD1,1));
    TT=[DF1];
    TempNUM=[0,24,168];
else
    TempNUM=[];
    TT=[];
end
B=A(:,6:29);
INPUTsNUM=[1;2;3;23;24;25;167;168;169];
CC=reshape(B',1,24*size(B,1));
FLAG=0;
[Adays,daytypes,daysramezan]=DayType(InputData);

if SPECIAL==0 && mm==1 && dd==14
    IND3=find((A(:,2)==mm).*(A(:,3)==dd).*(Adays(1:k-1,:)==0).*(A(:,4)==A(end-6,4)));
    if length(IND3)<5
        IND3=find((A(:,2)==mm).*(A(:,3)==dd).*(Adays(1:k-1,:)==0));
    end
    if length(IND3)<5
%         warndlg('Please Eneter More Data By Choosing Less First Year. The Results Maybe Inaccurate.','Increase Data')
    end
    daysnums=[];
    for I1=1:length(IND3)
        daysnums=[daysnums,[((IND3(I1)-1)*24+1):IND3(I1)*24]];
    end
    INPUTsNUM=[1;2;3;23;24;25;47;48;49;167;168;169];
    if ~isempty(TT2)
        TempNUM=[0,24,48,168];
    end
    if length(IND3)<5
        FLAG=1;
    else
        FLAG=0;
    end
    
elseif mm==12 && (dd==30 || dd==29 || dd==28)
    IND3=find((A(:,2)==mm).*(A(:,3)==dd).*(daysramezan(1:k-1,:)==daysramezan(k)).*(Adays(1:k-1,:)==Adays(k)).*(A(:,4)==A(end-6,4)));
    if length(IND3)<5
        IND3=find((A(:,2)==mm).*(A(:,3)==dd).*(Adays(1:k-1,:)==Adays(k)).*(daysramezan(1:k-1,:)==daysramezan(k)));
    end
    if length(IND3)<5
%         warndlg('Please Eneter More Data By Choosing Less First Year. The Results Maybe Inaccurate.','Increase Data')
    end
    daysnums=[];
    for I1=1:length(IND3)
        daysnums=[daysnums,[((IND3(I1)-1)*24+1):IND3(I1)*24]];
    end
    INPUTsNUM=[1;2;3;23;24;25];
    if ~isempty(TT2)
        TempNUM=[0,24];
    end
    if length(IND3)<5
        FLAG=1;
    else
        FLAG=0;
    end

elseif SPECIAL==0 && mm==6 && dd==31
    IND3=find((A(:,2)==mm).*(A(:,3)==dd).*(Adays(1:k-1,:)==0).*(A(:,4)==A(end-6,4)));
    if length(IND3)<5
        IND3=find((A(:,2)==mm).*(A(:,3)==dd).*(Adays(1:k-1,:)==0));
    end
    if length(IND3)<5
%         warndlg('Please Eneter More Data By Choosing Less First Year. The Results Maybe Inaccurate.','Increase Data')
    end
    daysnums=[];
    for I1=1:length(IND3)
        daysnums=[daysnums,[((IND3(I1)-1)*24+1):IND3(I1)*24]];
    end
    INPUTsNUM=[1;2;3;23;24;25];
    if ~isempty(TT2)
        TempNUM=[0,24];
    end
    if length(IND3)<5
        FLAG=1;
    else
        FLAG=0;
    end    
elseif Adays(k,1)>16 && mm==1 && (dd==3 || dd==2)
    IND3=find((A(:,2)==mm).*(A(:,3)==dd).*(A(:,4)==A(end-6,4)));
    if length(IND3)<5
        IND3=find((A(:,2)==mm).*(A(:,3)==dd));
    end
    if length(IND3)<5
%         warndlg('Please Eneter More Data By Choosing Less First Year. The Results Maybe Inaccurate.','Increase Data')
    end
    daysnums=[];
    for I1=1:length(IND3)
        daysnums=[daysnums,[((IND3(I1)-1)*24+1):IND3(I1)*24]];
    end
    INPUTsNUM=[1;2;3;23;24;25;47;48;49];
    if ~isempty(TT2)
        TempNUM=[0,24,48];
    end
    if length(IND3)<5
        FLAG=1;
    else
        FLAG=0;
    end
    daysnums=daysnums(find(daysnums>49));
        
elseif (Adays(k,1)==0 || Adays(k,1)>16) && mm==1 && (dd>=15 && dd<=21)
    IND3=find((A(:,2)==mm).*max(A(:,3)>=15,A(:,3)<=21).*(daytypes(1:k-1,1)==daytypes(k,1)).*(Adays(1:k-1,1)==Adays(k,1)).*(daysramezan(1:k-1,1)==daysramezan(k,1)));
    
    if length(IND3)<5
%         warndlg('Please Eneter More Data By Choosing Less First Year. The Results Maybe Inaccurate.','Increase Data')
    end
    daysnums=[];
    for I1=1:length(IND3)
        daysnums=[daysnums,[((IND3(I1)-1)*24+1):IND3(I1)*24]];
    end
    INPUTsNUM=[1;2;3;23;24;25;47;48;49];
    if ~isempty(TT2)
        TempNUM=[0,24,48];
    end
    if length(IND3)<5
        FLAG=1;
    else
        FLAG=0;
    end
    daysnums=daysnums(find(daysnums>49));
   
elseif Adays(k,1)>16 && mm==1 && (dd==4)
    IND3=find((A(:,2)==mm).*(A(:,3)==dd).*(A(:,4)==A(end-6,4)));
    if length(IND3)<5
        IND3=find((A(:,2)==mm).*(A(:,3)==dd));
    end
    if length(IND3)<5
%         warndlg('Please Eneter More Data By Choosing Less First Year. The Results Maybe Inaccurate.','Increase Data')
    end
    daysnums=[];
    for I1=1:length(IND3)
        daysnums=[daysnums,[((IND3(I1)-1)*24+1):IND3(I1)*24]];
    end
    INPUTsNUM=[1;2;3;23;24;25];
    if ~isempty(TT2)
        TempNUM=[0,24];
    end
    if length(IND3)<5
        FLAG=1;
    else
        FLAG=0;
    end
    daysnums=daysnums(find(daysnums>49));

elseif Adays(k,1)>16 && mm==1 && dd==1
    IND3=find((A(:,2)==mm).*(A(:,3)==dd).*(A(:,4)==A(end-6,4)));
    if length(IND3)<5
        IND3=find((A(:,2)==mm).*(A(:,3)==dd));
    end
    if length(IND3)<5
%         warndlg('Please Eneter More Data By Choosing Less First Year. The Results Maybe Inaccurate.','Increase Data')
    end
    daysnums=[];
    for I1=1:length(IND3)
        daysnums=[daysnums,[((IND3(I1)-1)*24+1):IND3(I1)*24]];
    end
    INPUTsNUM=[1;2;3;23;24;25];
    if ~isempty(TT2)
        TempNUM=[0];
    end
    if length(IND3)<5
        FLAG=1;
    else
        FLAG=0;
    end
    daysnums=daysnums(find(daysnums>25));

elseif SPECIAL==0 && mm==1 && dd==5
    IND3=find((A(:,1)>min(A(:,1))).*(A(:,2)==mm).*(A(:,3)==dd).*(Adays(1:k-1,:)==0).*(A(:,4)==A(end-6,4)));
    if length(IND3)<5
        IND3=find((A(:,2)==mm).*(A(:,3)==dd).*(Adays(1:k-1,:)==0));
    end
    if length(IND3)<5
%         warndlg('Please Eneter More Data By Choosing Less First Year. The Results Maybe Inaccurate.','Increase Data')
    end
    daysnums=[];
    for I1=1:length(IND3)
        daysnums=[daysnums,[((IND3(I1)-1)*24+1):IND3(I1)*24]];
    end
    INPUTsNUM=[1;2;3;23;24;25;47;48;49];
    if ~isempty(TT2)
        TempNUM=[0,24,48];
    end
    if length(IND3)<5
        FLAG=1;
    else
        FLAG=0;
    end
elseif Adays(k-1,1)==13     % After 21 Ramadan
    IND3=find(Adays(1:k-2,:)==Adays(k-1,1));
    IND3=IND3+1;
    daysnums=[];
    for I1=1:length(IND3)
        daysnums=[daysnums,[((IND3(I1)-1)*24+1):IND3(I1)*24]];
    end
    INPUTsNUM=[1;2;3;23;24;25;167;168;169];
    if ~isempty(TT2)
        TempNUM=[0,24,168];
    end
    FLAG=1;
    
  
    
else
    [Adays,daytypes,daysramezan]=DayType(InputData);
    Adays=Adays(1:k,:);
    daytypes=daytypes(1:k,:);
    daysramezan=daysramezan(1:k,:);
    daytypes2=repmat(daytypes(1:end-1),1,24);
    daytypesfinal=reshape(daytypes2',1,24*size(daytypes2,1));
    Adays2=repmat(Adays(1:end-1),1,24);
    Adaysfinal=reshape(Adays2',1,24*size(Adays2,1));
    daysramezan2=repmat(daysramezan(1:end-1),1,24);
    daysramezanfinal=reshape(daysramezan2',1,24*size(daysramezan2,1));
    
    
    if (Adaysfinal(end-167)~=0)||(Adaysfinal(end-168)~=0)||(Adaysfinal(end-169)~=0)
        INPUTsNUM=[1;2;3;23;24;25;47;48;49];
        [Adays,daytypes,daysramezan]=DayType2(InputData);
        Adays=Adays(1:k,:);
        daytypes=daytypes(1:k,:);
        daysramezan=daysramezan(1:k,:);
        daytypes2=repmat(daytypes(1:end-1),1,24);
        daytypesfinal=reshape(daytypes2',1,24*size(daytypes2,1));
        Adays2=repmat(Adays(1:end-1),1,24);
        Adaysfinal=reshape(Adays2',1,24*size(Adays2,1));
        daysramezan2=repmat(daysramezan(1:end-1),1,24);
        daysramezanfinal=reshape(daysramezan2',1,24*size(daysramezan2,1));
        if ~isempty(TT2)
            TempNUM=[0,24,48];
        end
    end
    
    
    if SPECIAL~=1
        daysnumsaa=find((daytypesfinal==daytypes(end))&(Adaysfinal==Adays(end))&(daysramezanfinal==daysramezan(end))) ;
    else
        daysnumsaa=find(Adaysfinal==Adays(end));
    end
    daysnums=daysnumsaa(find(daysnumsaa>max(INPUTsNUM)));
    
    IND2=[];
    for I1=1:size(daysnums,2)
        if sum(ceil(daysnums(1,I1)/24)==IND1)
            IND2=[IND2,I1];
        end
    end
    daysnums2=daysnums(1,IND2);
    daysnums(IND2)=[];
    if SPECIAL==1 || (Adaysfinal(end-23)~=0)||(Adaysfinal(end-24)~=0)||(Adaysfinal(end-25)~=0)
        daysnums=[daysnums2 daysnums];
    else
        daysnums=[daysnums2 ];
    end
    
end
if SPECIAL==1 
    FLAG=1;
end
OldSize=size(CC,2);ReformedSize=sum(AToday>0);CC=[CC,AToday(1:ReformedSize)];
daysnums=[OldSize+1:OldSize+ReformedSize daysnums ];
if ~isempty(TT2) && sum(AToday>0)>0
    TT=[TT,ones(1,ReformedSize)*TAToday(1,7)];
end
y1=CC(daysnums);
regrs_num=length(INPUTsNUM);
regrs_Temp=length(TempNUM);
ss=[];
for j=1:regrs_num
    ss=[ss;CC(daysnums-INPUTsNUM(j))];
end
tt=[];
if ~isempty(regrs_Temp)
    for k2=1:size(TT,1)
        for j=1:regrs_Temp
            tt=[tt;TT(k2,daysnums-TempNUM(j))];
        end
    end
end



ss=[ss;tt];
if FLAG==1 
    num=(find(InputData.lsyszone{1,1}(ceil(daysnums/24),4)==InputData.lsyszone{1,1}(k,4)))';
    [ss2,y12]=ITLMSfunction2(ss,y1,num);
    if sum(sum(isnan(ss2)))>0 || sum(sum(isnan(y12)))>0 
        ss=ss;y1=y1;
    else
        ss=ss2;y1=y12;
    end
end

% ss=[ss ss];
% y1=[y1 y1];
n=length(y1);
if n>max_trainingdata
    n=max_trainingdata;
    y1=y1(:,end-max_trainingdata+1:end);
    ss=ss(:,end-max_trainingdata+1:end);
end

a=1:n;
u=ss';
y=y1';

u_trn = u((rem(a,10)<6), :);
y_trn = y((rem(a,10)<6), :);

u_tst = u((rem(a,10)>5), :);
y_tst = y((rem(a,10)>5), :);
NNeuron = numberofneurons;
[Indtesta,net,mse_train,mse_test]=lolimot(TempNUM,u_trn,y_trn,NNeuron,smothing_factor, u_tst, y_tst);
