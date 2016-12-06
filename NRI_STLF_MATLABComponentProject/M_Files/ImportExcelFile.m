% ImportData
function ImportExcelFile(AppPath,address,yy,mm,dd)
DailyData=xlsread(address,'„‰«ÿﬁ');
InterchangeData=xlsread(address,'«—”«·Ì »—Ê‰ „—“Ì');
InterchangeData=sum(InterchangeData(:,1:24));
IndustrialData=xlsread(address,'’‰«Ì⁄');

loadDataPath=[AppPath,'\LoadData'];
cd(loadDataPath);
name1=['L_TotalManategh',num2str(yy),'.xlsx'];

ZoneData=xlsread(name1,'Tehran');
Day=find(ZoneData(:,1)==yy & ZoneData(:,2)==mm & ZoneData(:,3)==dd);
%% Tehran
    xls_DailyData(1,1:24)=(DailyData(8,1:24));
    xls_SiahBishe(1,1:24)=(DailyData(119,1:24));

xls_DailyData=(xls_DailyData)-(xls_SiahBishe);
text1=['F',num2str(Day),':','AC',num2str(Day)];


%% SiahBishe
xlswrite(['L_SiahBishe',num2str(yy),'.xlsx'],xls_SiahBishe,text1);

%% Mazandaran
    xls_DailyData(1,1:24)=(DailyData(15,1:24));

text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Mazandaran',text1);

%% Gilan
    xls_DailyData(1,1:24)=(DailyData(22,1:24));

text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Gilan',text1);

%% Semnan
    xls_DailyData(1,1:24)=(DailyData(29,1:24));

text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Semnan',text1);

%% Zanjan
    xls_DailyData(1,1:24)=(DailyData(36,1:24));

text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Zanjan',text1);

%% Azarbayejan
    xls_DailyData(1,1:24)=(DailyData(43,1:24));

text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Azarbayejan',text1);

%% Bakhtar
    xls_DailyData(1,1:24)=(DailyData(50,1:24));

text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Bakhtar',text1);

%% Gharb
    xls_DailyData(1,1:24)=(DailyData(57,1:24));

text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Gharb',text1);

%% Esfehan
    xls_DailyData(1,1:24)=(DailyData(64,1:24));

text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Esfehan',text1);

%% Khozestan
    xls_DailyData(1,1:24)=(DailyData(71,1:24));

text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Khozestan',text1);

%% Fars
    xls_DailyData(1,1:24)=(DailyData(78,1:24));

text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Fars',text1);

%% Yazd
    xls_DailyData(1,1:24)=(DailyData(85,1:24));

text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Yazd',text1);

%% Kerman
    xls_DailyData(1,1:24)=(DailyData(92,1:24));

text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Kerman',text1);

%% Hormozgan
    xls_DailyData(1,1:24)=(DailyData(99,1:24));

text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Hormozgan',text1);

%% Khorasan
    xls_DailyData(1,1:24)=(DailyData(106,1:24));

text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Khorasan',text1);

%% Sistan
    xls_DailyData(1,1:24)=(DailyData(113,1:24));

text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Sistan',text1);

%% Manategh
summation=zeros(1,24);
for i=1:16
    summation=summation+DailyData(1+7*i,1:24);
end
summation=summation-DailyData(119,1:24);
    xls_DailyData_manategh(1,1:24)=(summation(1,1:24));

name1=['L_Manategh',num2str(yy),'.xlsx'];
text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData_manategh,'sheet1',text1);

%% Interchange
name1=['L_Interchange',num2str(yy),'.xlsx'];
    xls_DailyData_Interchange(1,1:24)=InterchangeData(1,1:24);

text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData_Interchange,text1);

%% Industrial
name1=['L_Industrial',num2str(yy),'.xlsx'];
summation=zeros(1,24);
i=1;
while 5*i<size(IndustrialData,1)
    summation=summation+IndustrialData(5*i+1,1:24);
    i=i+1;
end
    xls_DailyData_Industrial(1,1:24)=(summation(1,1:24));

text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData_Industrial,text1);

%% system
xls_DailyData_system=xls_DailyData_manategh+xls_DailyData_Industrial+xls_DailyData_Interchange+xls_SiahBishe;
name1=['L_system',num2str(yy),'.xlsx'];
text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData_system,text1);


cd('..');