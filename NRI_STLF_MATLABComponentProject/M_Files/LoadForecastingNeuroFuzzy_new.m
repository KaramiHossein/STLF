
function [corp]=LoadForecastingNeuroFuzzy_new(yy,mm,dd,days,corp,InputData)

[Adays,daytypes,daysramezan]=DayType(InputData);

for I=1:length(corp.zone)
    
    A=InputData.lsyszone{1,I};
    
    weatherdata=InputData.weatherzone{1,I};
    
    if isempty(weatherdata.temp)
        TT=weatherdata.temp;
    else
        TT=weatherdata.temp{1,1};
    end
    
    i=find((A(:,1)==yy)&(A(:,2)==mm)&(A(:,3)==dd));
    A2=A;
    predictionfa=[];
    mapesfa=[];
    
    for k=i:i+days-1
        
        if Adays(k)==0
            SPECIAL=0;
        else
            SPECIAL=1;
        end
        
        if isempty(TT)
            KomakTemp=[];
            TAToday=[];
        else
            KomakTemp=TT(1:k-1,:);
            TAToday=TT(k,:);
        end
        if sum(A2(k,6:29)>0)>0 && sum(A2(k,6:29)>0)<24
            A2(k,(6+sum(A2(k,6:29)>0)):29)=nan(1,24-sum(A2(k,6:29)>0));
        else
            A2(k,6:29)=nan(1,24);
        end
        
        
        [net,INPUTsNUM,TempNUM]=LoadTraining_online(InputData.flag{1,I}(1:k-1,:),SPECIAL,A2(k,1),A2(k,2),A2(k,3),A2(1:k-1,:),KomakTemp,InputData,k,A2(k,6:29),TAToday);
        
        % etelaate bare roze morde nazar ra dar AToday migozarad , agar data
        % mojod nabod bejash NAN migozarad
        
        if ~isempty(TT)
            KomakTemp=TT(1:k,:);
        end
        [prediction]=NeuroFuzzypredict_Final(net,TempNUM,INPUTsNUM,A2(1:k-1,:),KomakTemp,A2(k,6:29));
        
        if sum(isnan(A(k,6:29)))==0
            mape=100*mean(abs(prediction-A(k,6:29))./A(k,6:29)); % motavaset khataye nesbi pishbini ra neshan midahad
            errors=100*(abs(prediction-A(k,6:29))./A(k,6:29));   % khataye nesbi pishbini baraye sahaye mokhtalefe roz
            
            
            if mm<7
                mapepeak=100*mean(abs(prediction(21:24)-A(k,26:29))./A(k,26:29));
                mapeord=100*mean(abs(prediction(9:20)-A(k,14:25))./A(k,14:25));
                mapelow=100*mean(abs(prediction(1:8)-A(k,6:13))./A(k,6:13));
            else
                mapepeak=100*mean(abs(prediction(18:21)-A(k,23:26))./A(k,23:26));
                mapeord=100*mean(abs(prediction(6:17)-A(k,11:22))./A(k,11:22));
                mapelow=100*mean(abs(prediction([1:5 22:24])-A(k,[6:10 27:29]))./A(k,[6:10 27:29]));
            end
            
            
            
            
        else
            %% agar bare roze k om dar ekhtiar bood
            mape=[];
            mapepeak=[];
            mapeord=[];
            mapelow=[];
            errors=[];
        end
        A2(k,6:29)=prediction;
        predictionfa=[predictionfa; prediction];
        %     Aa(k,6:29)=prediction;
        mapes=[mape;mapepeak;mapeord;mapelow];
        mapesfa=[mapesfa mapes];
        
        
        
        
        
        
        
    end
    
    corp.zone{1,I}.NeuroPredict=predictionfa;
    corp.zone{1,I}.NeuroMapes=mapesfa';
    corp.zone{1,I}.NeuroErrors=errors;
end
zoneNo=length(corp.zone);
predictionC =[];
actualC = [];
i=find((InputData.cal.calH(:,1)==yy)&(InputData.cal.calH(:,2)==mm)&(InputData.cal.calH(:,3)==dd));

for k=1:days
    prediction =[];
    actual = [];
    for z = 1:zoneNo
        prediction = [prediction;corp.zone{1,z}.NeuroPredict(k,:)];
        actual=[ actual; InputData.lsyszone{1,z}(i+k-1,6:29)];
    end
    TotActual=sum(actual,1);
    TotPrediction=sum(prediction,1);
    if ~strcmp(corp.name,'system')
        SiahBishe=InputData.SiahBishe;
        Industrial=InputData.Industrial;
        Interchange=InputData.Interchange;
        if k>1
            SiahBishe(i+k-2,6:29)=MeanSiahBishe;
            Industrial(i+k-2,6:29)=MeanIndustrial;
            Interchange(i+k-2,6:29)=MeanInterchange;
        end
        if max(sum(InputData.lsyszone{1,1}(i+k-1,6:29)==0),sum(isnan(InputData.lsyszone{1,1}(i+k-1,6:29))))>0
            hhh=24-max(sum(InputData.lsyszone{1,1}(i+k-1,6:29)==0),sum(isnan(InputData.lsyszone{1,1}(i+k-1,6:29))));
        else
            hhh=0;
        end
        MeanSiahBishe=[SiahBishe(i+k-1,6:6+hhh-1) mean(SiahBishe(i-3+k-1:i-1+k-1,6+hhh:29))];
        MeanIndustrial=[Industrial(i+k-1,6:6+hhh-1) mean(Industrial(i-7+k-1:i-1+k-1,6+hhh:29))];
        MeanInterchange=[Interchange(i+k-1,6:6+hhh-1) mean(Interchange(i-7+k-1:i-1+k-1,6+hhh:29))];
        TotPrediction=sum(prediction,1)+MeanInterchange+MeanIndustrial+MeanSiahBishe;
        TotActual=sum(actual,1)+InputData.Industrial(i+k-1,6:29)+InputData.Interchange(i+k-1,6:29)+InputData.SiahBishe(i+k-1,6:29);
    end
    
    predictionC =[predictionC; TotPrediction];
    actualC = [actualC; TotActual];
end
mapesC=[];
errorsC=[];
for k=1:days
    if sum(isnan(actualC(k,:)))~=0
        mapesC=[];
        errorsC=[];
    else
        [mapes, errors] = calcError(predictionC(k,:), actualC(k,:),InputData.cal.calH(i+k-1,2));
        mapesC=[mapesC;mapes];
        errorsC=[errorsC;errors];
    end
end
corp.NeuroPredict=predictionC;
corp.NeuroMapes = mapesC;
corp.NeuroErrors = errorsC;
