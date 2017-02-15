function [Data]=ReadData(yy,N,corp,AppPath)

ZoneNo=length(corp.zone);
corp_name=corp.name;

Data.Zone=cell(1,ZoneNo);
for zone=1:ZoneNo
    Data.Zone{1,zone}.Load.Manategh=[];
    Data.Zone{1,zone}.Load.Industrial=[];
    Data.Zone{1,zone}.Load.Interchange=[];
    %     Data.Zone{1,zone}.Load.Peak=[];
    Data.Zone{1,zone}.Load.Pump=[];
    Data.Zone{1,zone}.flag=[];
    if isempty(corp.zone{1, zone}.weathername)
        Data.Zone{1,zone}.Weather.Nebulosity={};
        Data.Zone{1,zone}.Weather.Humidity={};
        Data.Zone{1,zone}.Weather.Temp={};
    else
        Data.Zone{1,zone}.Weather.Nebulosity=cell(1,1);
        Data.Zone{1,zone}.Weather.Humidity=cell(1,1);
        Data.Zone{1,zone}.Weather.Temp=cell(1,1);
    end
end

loadDataPath=[AppPath,'\LoadData'];
weatherDataPath = [AppPath,'\WeatherData'];
calendarDataPath = [AppPath,'\Calendar'];
calH=[];
calD=[];

for i=yy-N:yy
    for zone=1:ZoneNo
        %% Load Data
        cd(loadDataPath);
        %% Load Manategh Data
        A1=[];
        name0=['L_',corp_name];
        name1=[name0,num2str(i),'.xls'];
        if(exist(name1)>0)
            A1=xlsread(name1,corp.zone{zone}.name);
        else
            name1=[name0,num2str(i),'.xlsx'];
            A1=xlsread(name1,corp.zone{zone}.name);
        end
        if size(A1,2)<31
            A1(end,31)=nan(1,1);
        end
        Data.Zone{1,zone}.Load.Manategh=[Data.Zone{1,zone}.Load.Manategh; A1(:,1:31)];
        
        %% Load Industrial Data
        if i>yy-2
            A2=[];
            name1=['L_Industrial',num2str(i),'.xls'];
            if(exist(name1)>0)
                A2=xlsread(name1,corp.zone{zone}.name);
            else
                name1=[name1,'x'];
                if strcmp(corp_name,'system') || strcmp(corp_name,'manategh')
                    excelObj = actxserver('Excel.Application');
                    excelWorkbook = excelObj.workbooks.Open([cd '\' name1]);
                    worksheets = excelObj.sheets;
                    numSheets = worksheets.Count;
                    A2=0;
                    for II=1:numSheets
                        A2=A2+xlsread(name1,worksheets.Item(II).Name);
                        if size(A2,2)<31
                            A2(end,31)=nan(1,1);
                        end
                    end
                    A2(:,1:5)=A2(:,1:5)/numSheets;
                else
                    A2=xlsread(name1,corp.zone{zone}.name);
                end
            end
            if size(A2,2)<31
                A2(end,31)=nan(1,1);
            end
            Data.Zone{1,zone}.Load.Industrial=[Data.Zone{1,zone}.Load.Industrial; A2(:,1:31)];
        end
        
        %% Load Interchange Data
        if i>yy-2
            A3=[];
            name1=['L_Interchange',num2str(i),'.xls'];
            if(exist(name1)>0)
                A3=xlsread(name1,corp.zone{zone}.name);
            else
                name1=[name1,'x'];
                if strcmp(corp_name,'system') || strcmp(corp_name,'manategh')
                    excelObj = actxserver('Excel.Application');
                    excelWorkbook = excelObj.workbooks.Open([cd '\' name1]);
                    worksheets = excelObj.sheets;
                    numSheets = worksheets.Count;
                    A3=0;
                    for II=1:numSheets
                        A3=A3+xlsread(name1,worksheets.Item(II).Name);
                        if size(A3,2)<31
                            A3(end,31)=nan(1,1);
                        end
                    end
                    A3(:,1:5)=A3(:,1:5)/numSheets;
                else
                    A3=xlsread(name1,corp.zone{zone}.name);
                end
            end
            if size(A3,2)<31
                A3(end,31)=nan(1,1);
            end
            Data.Zone{1,zone}.Load.Interchange=[Data.Zone{1,zone}.Load.Interchange; A3(:,1:31)];
        end
        
        %         %% Load Peak Data
        %         A4=[];
        %         name1=['L_Peak',num2str(i),'.xls'];
        %         if(exist(name1)>0)
        %             A4=xlsread(name1,corp.zone{zone}.name);
        %         else
        %             name1=[name1,'x'];
        %             A4=xlsread(name1,corp.zone{zone}.name);
        %         end
        %         Data.Zone{1,zone}.Load.Peak=[Data.Zone{1,zone}.Load.Peak; A4(:,1:7)];
        %
        %% Load Pump Data
        if i>yy-2
            A5=[];
            name1=['L_Pump',num2str(i),'.xls'];
            if(exist(name1)>0)
                A5=xlsread(name1,corp.zone{zone}.name);
            else
                name1=[name1,'x'];
                if strcmp(corp_name,'system') || strcmp(corp_name,'manategh')
                    excelObj = actxserver('Excel.Application');
                    excelWorkbook = excelObj.workbooks.Open([cd '\' name1]);
                    worksheets = excelObj.sheets;
                    numSheets = worksheets.Count;
                    A5=0;
                    for II=1:numSheets
                        A5=A5+xlsread(name1,worksheets.Item(II).Name);
                        if size(A5,2)<31
                            A5(end,31)=nan(1,1);
                        end
                    end
                    A5(:,1:5)=A5(:,1:5)/numSheets;
                else
                    A5=xlsread(name1,corp.zone{zone}.name);
                end
            end
            if size(A5,2)<31
                A5(end,31)=nan(1,1);
            end
            Data.Zone{1,zone}.Load.Pump=[Data.Zone{1,zone}.Load.Pump; A5(:,1:31)];
        end
        cd('..');
        
        %% days flag
        cd('flag');
        Df=[];
        name5=['flag',num2str(i),'.xls'];
        if(exist(name5)>0)
            Df=xlsread(name5);
        else
            name5=['flag',num2str(i),'.xlsx'];
            Df=xlsread(name5);
        end
        cd('..');
        Data.Zone{1,zone}.flag=[Data.Zone{1,zone}.flag; Df];
        
        %% temperature
        CityTempNo=length(corp.zone{zone}.weathername);
        if(CityTempNo ~=0)
            cd(weatherDataPath);
            for j=1:CityTempNo
                name1=['T_',corp.zone{zone}.weathername{j,1}];
                cd(name1);
                B=[];
                name2=[name1,num2str(i),'.xls'];
                if(exist(name2)>0)
                    B=xlsread(name2);
                else
                    name2=[name1,num2str(i),'.xlsx'];
                    B=xlsread(name2);
                end
                cd('..');
                Data.Zone{1,zone}.Weather.Temp{j,1}=[Data.Zone{1,zone}.Weather.Temp{j,1};B(:,1:8)];
            end
            cd('..');
        end
        
        %% humidity %%%% need to change!!!!!!!!!!
        CityHumidityNo=length(corp.zone{zone}.humidityname);
        if(CityHumidityNo ~=0)
            cd(weatherDataPath);
            for j=1:CityHumidityNo
                name1=['T_',corp.zone{zone}.humidityname{j,1}];
                cd(name1);
                B=[];
                name2=[name1,num2str(i),'.xls'];
                if(exist(name2)>0)
                    B=xlsread(name2);
                else
                    name2=[name1,num2str(i),'.xlsx'];
                    B=xlsread(name2);
                end
                cd('..');
                Data.Zone{1,zone}.Weather.Humidity{j,1}=[Data.Zone{1,zone}.Weather.Humidity{j,1};B(:,1:5)  B(:,13)];%% must change
            end
            cd('..');
        end
        
        %% nebulosity %%%% need to change!!!!!!!!!!
        CityNebulosityNo=length(corp.zone{zone}.nebulosityname);
        if(CityNebulosityNo ~=0)
            cd(weatherDataPath);
            for j=1:CityNebulosityNo
                name1=['T_',corp.zone{zone}.nebulosityname{j,1}];
                cd(name1);
                B=[];
                name2=[name1,num2str(i),'.xls'];
                if(exist(name2)>0)
                    B=xlsread(name2);
                else
                    name2=[name1,num2str(i),'.xlsx'];
                    B=xlsread(name2);
                end
                cd('..');
                Data.Zone{1,zone}.Weather.Nebulosity{j,1}=[Data.Zone{1,zone}.Weather.Nebulosity{j,1};B(:,1:5) B(:,25)];%% must change
            end
            cd('..');
        end
        
    end
    
    %% Calendar Set Up
    
    cd(calendarDataPath);
    name5=['caln',num2str(i),'.xls'];
    if(exist(name5)>0)
        E=xlsread(name5);
    else
        name5=['caln',num2str(i),'.xlsx'];
        E=xlsread(name5);
    end
    name6=['ghcal.xls'];
    if(exist(name6)>0)
        Egh=xlsread(name6);
    else
        name6=['ghcal.xlsx'];
        Egh=xlsread(name6);
    end
    calD=E;
    cd('..');
    calH=[calH;calD];
end

Data.cal.calH=calH;
Data.cal.calD=calD;
Data.cal.Ghcal=Egh;