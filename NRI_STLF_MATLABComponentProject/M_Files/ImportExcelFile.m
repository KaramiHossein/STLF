% ImportData
function ImportExcelFile(address,yy,mm,dd)
DailyData=xlsread(address,'„‰«ÿﬁ');

cd('LoadData');
name1=['L_TotalManategh',num2str(yy),'.xls'];

ZoneData=xlsread(name1,'Tehran');
Day=find(ZoneData(:,1)==yy & ZoneData(:,2)==mm & ZoneData(:,3)==dd);
%% Tehran
for j=1:24
    xls_DailyData(1,j)={num2str(DailyData(8,j))};
end
text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Tehran',text1);

%% Mazandaran
for j=1:24
    xls_DailyData(1,j)={num2str(DailyData(15,j))};
end
text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Mazandaran',text1);

%% Gilan
for j=1:24
    xls_DailyData(1,j)={num2str(DailyData(22,j))};
end
text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Gilan',text1);

%% Semnan
for j=1:24
    xls_DailyData(1,j)={num2str(DailyData(29,j))};
end
text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Semnan',text1);

%% Zanjan
for j=1:24
    xls_DailyData(1,j)={num2str(DailyData(36,j))};
end
text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Zanjan',text1);

%% Azarbayejan
for j=1:24
    xls_DailyData(1,j)={num2str(DailyData(43,j))};
end
text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Azarbayejan',text1);

%% Bakhtar
for j=1:24
    xls_DailyData(1,j)={num2str(DailyData(50,j))};
end
text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Bakhtar',text1);

%% Gharb
for j=1:24
    xls_DailyData(1,j)={num2str(DailyData(57,j))};
end
text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Gharb',text1);

%% Esfehan
for j=1:24
    xls_DailyData(1,j)={num2str(DailyData(64,j))};
end
text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Esfehan',text1);

%% Khozestan
for j=1:24
    xls_DailyData(1,j)={num2str(DailyData(71,j))};
end
text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Khozestan',text1);

%% Fars
for j=1:24
    xls_DailyData(1,j)={num2str(DailyData(78,j))};
end
text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Fars',text1);

%% Yazd
for j=1:24
    xls_DailyData(1,j)={num2str(DailyData(85,j))};
end
text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Yazd',text1);

%% Kerman
for j=1:24
    xls_DailyData(1,j)={num2str(DailyData(92,j))};
end
text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Kerman',text1);

%% Hormozgan
for j=1:24
    xls_DailyData(1,j)={num2str(DailyData(99,j))};
end
text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Hormozgan',text1);

%% Khorasan
for j=1:24
    xls_DailyData(1,j)={num2str(DailyData(106,j))};
end
text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Khorasan',text1);

%% Sistan
for j=1:24
    xls_DailyData(1,j)={num2str(DailyData(113,j))};
end
text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData,'Sistan',text1);

%% Manategh
summation=zeros(1,24);
for i=1:16
    summation=summation+DailyData(1+7*i,1:24);
end
for j=1:24
    xls_DailyData_manategh(1,j)={num2str(summation(1,j))};
end
name1=['L_Manategh',num2str(yy),'.xls'];
text1=['F',num2str(Day),':','AC',num2str(Day)];
xlswrite(name1,xls_DailyData_manategh,'sheet1',text1);
cd('..');