% ImportData
function ImportExcelFile(AppPath,address,yy,mm,dd)
DailyData=xlsread(address,'?????');
InterchangeData=xlsread(address,'?????? ???? ????');
% % InterchangeData=sum(InterchangeData(:,1:24));
IndustrialData=xlsread(address,'?????');
% DailyData=xlsread(address,'MANATEGH');
% InterchangeData=xlsread(address,'Ersali Boroon Marzi');
% InterchangeData=sum(InterchangeData(:,1:24));
% IndustrialData=xlsread(address,'SANAYE');

loadDataPath=[AppPath,'\LoadData'];
cd(loadDataPath);
name1=['L_TotalManategh',num2str(yy),'.xlsx'];

ZoneData=xlsread(name1,'Tehran');
Day=find(ZoneData(:,1)==yy & ZoneData(:,2)==mm & ZoneData(:,3)==dd);
%% Tehran
    xls_DailyData(1,1:26)=(DailyData(8,[1:24 26 28]));
    xls_SiahBishe(1,1:26)=(DailyData(119,[1:24 26 28]));

xls_DailyData=(xls_DailyData)-(xls_SiahBishe);
text1=['F',num2str(Day),':','AE',num2str(Day)];


%% SiahBishe
xlswrite(['L_Pump',num2str(yy),'.xlsx'],xls_SiahBishe,'Tehran',text1);
xlswrite(name1,xls_DailyData,'Tehran',text1);

%% Mazandaran
    xls_DailyData(1,1:26)=(DailyData(15,[1:24 26 28]));

text1=['F',num2str(Day),':','AE',num2str(Day)];
xlswrite(name1,xls_DailyData,'Mazandaran',text1);

%% Gilan
    xls_DailyData(1,1:26)=(DailyData(22,[1:24 26 28]));

text1=['F',num2str(Day),':','AE',num2str(Day)];
xlswrite(name1,xls_DailyData,'Gilan',text1);

%% Semnan
    xls_DailyData(1,1:26)=(DailyData(29,[1:24 26 28]));

text1=['F',num2str(Day),':','AE',num2str(Day)];
xlswrite(name1,xls_DailyData,'Semnan',text1);

%% Zanjan
    xls_DailyData(1,1:26)=(DailyData(36,[1:24 26 28]));

text1=['F',num2str(Day),':','AE',num2str(Day)];
xlswrite(name1,xls_DailyData,'Zanjan',text1);

%% Azarbayejan
    xls_DailyData(1,1:26)=(DailyData(43,[1:24 26 28]));

text1=['F',num2str(Day),':','AE',num2str(Day)];
xlswrite(name1,xls_DailyData,'Azarbayejan',text1);

%% Bakhtar
    xls_DailyData(1,1:26)=(DailyData(50,[1:24 26 28]));

text1=['F',num2str(Day),':','AE',num2str(Day)];
xlswrite(name1,xls_DailyData,'Bakhtar',text1);

%% Gharb
    xls_DailyData(1,1:26)=(DailyData(57,[1:24 26 28]));

text1=['F',num2str(Day),':','AE',num2str(Day)];
xlswrite(name1,xls_DailyData,'Gharb',text1);

%% Esfehan
    xls_DailyData(1,1:26)=(DailyData(64,[1:24 26 28]));

text1=['F',num2str(Day),':','AE',num2str(Day)];
xlswrite(name1,xls_DailyData,'Esfehan',text1);

%% Khozestan
    xls_DailyData(1,1:26)=(DailyData(71,[1:24 26 28]));

text1=['F',num2str(Day),':','AE',num2str(Day)];
xlswrite(name1,xls_DailyData,'Khozestan',text1);

%% Fars
    xls_DailyData(1,1:26)=(DailyData(78,[1:24 26 28]));

text1=['F',num2str(Day),':','AE',num2str(Day)];
xlswrite(name1,xls_DailyData,'Fars',text1);

%% Yazd
    xls_DailyData(1,1:26)=(DailyData(85,[1:24 26 28]));

text1=['F',num2str(Day),':','AE',num2str(Day)];
xlswrite(name1,xls_DailyData,'Yazd',text1);

%% Kerman
    xls_DailyData(1,1:26)=(DailyData(92,[1:24 26 28]));

text1=['F',num2str(Day),':','AE',num2str(Day)];
xlswrite(name1,xls_DailyData,'Kerman',text1);

%% Hormozgan
    xls_DailyData(1,1:26)=(DailyData(99,[1:24 26 28]));

text1=['F',num2str(Day),':','AE',num2str(Day)];
xlswrite(name1,xls_DailyData,'Hormozgan',text1);

%% Khorasan
    xls_DailyData(1,1:26)=(DailyData(106,[1:24 26 28]));

text1=['F',num2str(Day),':','AE',num2str(Day)];
xlswrite(name1,xls_DailyData,'Khorasan',text1);

%% Sistan
    xls_DailyData(1,1:26)=(DailyData(113,[1:24 26 28]));

text1=['F',num2str(Day),':','AE',num2str(Day)];
xlswrite(name1,xls_DailyData,'Sistan',text1);

%% Manategh
summation=zeros(1,26);
for i=1:16
    summation=summation+DailyData(1+7*i,[1:24 26 28]);
end
summation=summation-DailyData(119,[1:24 26 28]);
    xls_DailyData_manategh(1,1:26)=(summation(1,[1:26]));

name1=['L_Manategh',num2str(yy),'.xlsx'];
text1=['F',num2str(Day),':','AE',num2str(Day)];
xlswrite(name1,xls_DailyData_manategh,'sheet1',text1);

%% Interchange
name1=['L_Interchange',num2str(yy),'.xlsx'];
InterchangeData(1,[1:25 27]);
xlswrite(name1,InterchangeData(1,[1:25 27]),'Mazandaran',text1);
xlswrite(name1,InterchangeData(2,[1:25 27]),'Gilan',text1);
xlswrite(name1,sum(InterchangeData([3:6],[1:25 27])),'Azarbayejan',text1);
xlswrite(name1,InterchangeData(7,[1:25 27]),'Gharb',text1);
xlswrite(name1,InterchangeData(8,[1:25 27]),'Khozestan',text1);
xlswrite(name1,sum(InterchangeData([9:10],[1:25 27])),'Khorasan',text1);
xlswrite(name1,InterchangeData(11,[1:25 27]),'sistan',text1);


% text1=['F',num2str(Day),':','AE',num2str(Day)];
% xlswrite(name1,xls_DailyData_Interchange,'',text1);

%% Industrial
name1=['L_Industrial',num2str(yy),'.xlsx'];
xlswrite(name1,sum(IndustrialData([6 11 86 136 226],[1:24 26 28])),'Esfehan',text1);
xlswrite(name1,IndustrialData(126,[1:24 26 28]),'Gharb',text1);
xlswrite(name1,sum(IndustrialData([61 71 241 101 246 251],[1:24 26 28])),'Azarbayejan',text1);
xlswrite(name1,sum(IndustrialData([56 201],[1:24 26 28])),'Khorasan',text1);
xlswrite(name1,sum(IndustrialData([231 31],[1:24 26 28])),'Semnan',text1);
xlswrite(name1,sum(IndustrialData([36 121 166 176 191 196 206 211],[1:24 26 28])),'Yazd',text1);
xlswrite(name1,sum(IndustrialData([16 21 66 116 256],[1:24 26 28])),'Khozestan',text1);
xlswrite(name1,sum(IndustrialData([26 41 76 106],[1:24 26 28])),'Bakhtar',text1);
xlswrite(name1,sum(IndustrialData([46 161 181 216 186],[1:24 26 28])),'Hormozgan',text1);
xlswrite(name1,sum(IndustrialData([146 51 81],[1:24 26 28])),'Kerman',text1);
xlswrite(name1,sum(IndustrialData([111 96 91 131 171],[1:24 26 28])),'Fars',text1);
xlswrite(name1,IndustrialData(156,[1:24 26 28]),'Zanjan',text1);
xlswrite(name1,IndustrialData(141,[1:24 26 28]),'Gilan',text1);
xlswrite(name1,sum(IndustrialData([221 151],[1:24 26 28])),'Mazandaran',text1);
xlswrite(name1,(IndustrialData(236,[1:24 26 28])),'Tehran',text1);


% summation=zeros(1,26);
% i=1;
% while 5*i<size(IndustrialData,1)
%     summation=summation+IndustrialData(5*i+1,1:26);
%     i=i+1;
% end
%     xls_DailyData_Industrial(1,1:26)=(summation(1,1:26));
% 
% text1=['F',num2str(Day),':','AE',num2str(Day)];
% xlswrite(name1,xls_DailyData_Industrial,text1);

%% system
xls_DailyData_system=xls_DailyData_manategh+sum(IndustrialData(6:5:256,[1:24 26 28]))+sum(InterchangeData([1:11],[1:25 27]))+xls_SiahBishe;
name1=['L_system',num2str(yy),'.xlsx'];
text1=['F',num2str(Day),':','AE',num2str(Day)];
xlswrite(name1,xls_DailyData_system,text1);


cd('..');