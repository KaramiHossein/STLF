
function [corp]=LoadForecastingNeuroFuzzy_new(yy,mm,dd,days,corp,InputData)

[Adays,daytypes,daysramezan]=DayType(InputData);

for I=1:length(corp.zone)
    
    A=InputData.Zone{1,I}.Load.Manategh;
    
    weatherdata=InputData.Zone{1,I}.Weather;
    
    if isempty(weatherdata.Temp)
        TT=weatherdata.Temp;
    else
        TT=weatherdata.Temp{1,1};
    end
    
    i=find((A(:,1)==yy)&(A(:,2)==mm)&(A(:,3)==dd));
    A2=A;
    
    Prediction.Manategh=[];
    Mapes.Manategh=[];
    Errors.Manategh=[];
    Prediction.Pump=[];
    Mapes.Pump=[];
    Errors.Pump=[];
    Prediction.Interchange=[];
    Mapes.Interchange=[];
    Errors.Interchange=[];
    Prediction.Industrial=[];
    Mapes.Industrial=[];
    Errors.Industrial=[];
    Prediction.Total=[];
    Mapes.Total=[];
    Errors.Total=[];
    
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
        
        
        [net,INPUTsNUM,TempNUM]=LoadTraining_online(InputData.Zone{1,I}.flag(1:k-1,:),SPECIAL,A2(k,1),A2(k,2),A2(k,3),A2(1:k-1,:),KomakTemp,InputData,k,A2(k,6:29),TAToday);
        
        if ~isempty(TT)
            KomakTemp=TT(1:k,:);
        end
        [prediction]=NeuroFuzzypredict_Final(net,TempNUM,INPUTsNUM,A2(1:k-1,:),KomakTemp,A2(k,6:29));
        if sum(isnan(prediction))>0
            for III=1:16
                InputData.Zone{1,III}.Weather.Temp=[];
            end
            TT=[];
            [net,INPUTsNUM,TempNUM]=LoadTraining_online(InputData.Zone{1,I}.flag(1:k-1,:),SPECIAL,A2(k,1),A2(k,2),A2(k,3),A2(1:k-1,:),[],InputData,k,A2(k,6:29),TAToday);
            [prediction]=NeuroFuzzypredict_Final(net,TempNUM,INPUTsNUM,A2(1:k-1,:),[],A2(k,6:29));
        end
       Actual=InputData.Zone{1,I}.Load.Manategh(k,6:29);
        [mapes, errors] = calcError(prediction, Actual,A2(k,2));
        A2(k,6:29)=prediction;

        Prediction.Manategh=[Prediction.Manategh; prediction];
        Mapes.Manategh=[Mapes.Manategh;mapes];
        Errors.Manategh=[Errors.Manategh;errors];
        
        if ~strcmp(corp.name,'system')
            knew=find((InputData.Zone{1,I}.Load.Interchange(:,1)==A2(k,1))&(InputData.Zone{1,I}.Load.Interchange(:,2)==A2(k,2))&(InputData.Zone{1,I}.Load.Interchange(:,3)==A2(k,3)));
            
            INDUSTRIAL=InputData.Zone{1,I}.Load.Industrial;
            PUMP=InputData.Zone{1,I}.Load.Pump;
            INTERCHANGE=InputData.Zone{1,I}.Load.Interchange;
            
            if k-i>0
                PUMP(knew-1,6:29)=PredictionPump;
                INDUSTRIAL(knew-1,6:29)=PredictionIndustrial;
                INTERCHANGE(knew-1,6:29)=PredictionInterchange;
            end
            
            if max(sum(InputData.Zone{1,I}.Load.Manategh(k,6:29)==0),sum(isnan(InputData.Zone{1,I}.Load.Manategh(k,6:29))))>0
                hhh=24-max(sum(InputData.Zone{1,I}.Load.Manategh(k,6:29)==0),sum(isnan(InputData.Zone{1,I}.Load.Manategh(k,6:29))));
            else
                hhh=0;
            end
            
            PredictionPump=[PUMP(knew,6:6+hhh-1) mean(PUMP(-3+knew:-1+knew,6+hhh:29))];
            PredictionIndustrial=[INDUSTRIAL(knew,6:6+hhh-1) mean(INDUSTRIAL(-7+knew:knew-1,6+hhh:29))];
            PredictionInterchange=[INTERCHANGE(knew,6:6+hhh-1) mean(INTERCHANGE(-7+knew:knew-1,6+hhh:29))];
            
            ActualPump=InputData.Zone{1,I}.Load.Pump(knew,6:29);
            ActualIndustrial=InputData.Zone{1,I}.Load.Industrial(knew,6:29);
            ActualInterchange=InputData.Zone{1,I}.Load.Interchange(knew,6:29);
            
            [mapesPump, errorsPump] = calcError(PredictionPump, ActualPump,A2(k,2));
            [mapesIndustrial, errorsIndustrial] = calcError(PredictionIndustrial, ActualIndustrial,A2(k,2));
            [mapesInterchange, errorsInterchange] = calcError(PredictionInterchange, ActualInterchange,A2(k,2));
            
            Prediction.Pump=[Prediction.Pump; PredictionPump];
            Mapes.Pump=[Mapes.Pump;mapesPump];
            Errors.Pump=[Errors.Pump;errorsPump];
            
            Prediction.Industrial=[Prediction.Industrial; PredictionIndustrial];
            Mapes.Industrial=[Mapes.Industrial;mapesIndustrial];
            Errors.Industrial=[Errors.Industrial;errorsIndustrial];
            
            Prediction.Interchange=[Prediction.Interchange; PredictionInterchange];
            Mapes.Interchange=[Mapes.Interchange;mapesInterchange];
            Errors.Interchange=[Errors.Interchange;errorsInterchange];
            
            PredictTotal=PredictionInterchange+PredictionIndustrial+PredictionPump+prediction;
            ActualTotal=Actual+ActualInterchange+ActualIndustrial+ActualPump;
            [mapesTotal, errorsTotal] = calcError(PredictTotal, ActualTotal,A2(k,2));
            Prediction.Total=[Prediction.Total; PredictTotal];
            Mapes.Total=[Mapes.Total;mapesTotal];
            Errors.Total=[Errors.Total;errorsTotal];
        else
            Prediction.Total=[Prediction.Manategh];
            Mapes.Total=[Mapes.Manategh];
            Errors.Total=[Errors.Manategh];
            Prediction.Manategh=[];
            Mapes.Manategh=[];
            Errors.Manategh=[];
        end
        
        
        
    
        
    end
    
    corp.zone{1,I}.Neuro.Predict=Prediction;
    corp.zone{1,I}.Neuro.Mapes=Mapes;
    corp.zone{1,I}.Neuro.Errors=Errors;
end

MapesFinal.Manategh=[];
errorsFinal.Manategh=[];
MapesFinal.Industrial=[];
errorsFinal.Industrial=[];
MapesFinal.Interchange=[];
errorsFinal.Interchange=[];
MapesFinal.Pump=[];
errorsFinal.Pump=[];
MapesFinal.Total=[];
errorsFinal.Total=[];
FinalPredict.Manategh=[];
FinalPredict.Industrial=[];
FinalPredict.Interchange=[];
FinalPredict.Pump=[];
FinalActual.Manategh=[];
FinalActual.Industrial=[];
FinalActual.Interchange=[];
FinalActual.Pump=[];
i=find((InputData.cal.calH(:,1)==yy)&(InputData.cal.calH(:,2)==mm)&(InputData.cal.calH(:,3)==dd));
knew=find((InputData.Zone{1,1}.Load.Interchange(:,1)==yy)&(InputData.Zone{1,1}.Load.Interchange(:,2)==mm)&(InputData.Zone{1,1}.Load.Interchange(:,3)==dd));
zoneNo=length(corp.zone);

for k=1:days
    A1=0;
    A2=0;
    A3=0;
    A4=0;
    A5=0;
    A6=0;
    A7=0;
    A8=0;
    for z=1:zoneNo
        A1=A1+corp.zone{1,z}.Neuro.Predict.Manategh(k,1:24);
        A2=A2+corp.zone{1,z}.Neuro.Predict.Industrial(k,1:24);
        A3=A3+corp.zone{1,z}.Neuro.Predict.Interchange(k,1:24);
        A4=A4+corp.zone{1,z}.Neuro.Predict.Pump(k,1:24);
        A5=A5+InputData.Zone{1,z}.Load.Manategh(i+k-1,6:29);
        A6=A6+InputData.Zone{1,z}.Load.Industrial(knew-1+k-1,6:29);
        A7=A7+InputData.Zone{1,z}.Load.Interchange(knew-1+k-1,6:29);
        A8=A8+InputData.Zone{1,z}.Load.Pump(knew-2+k-1,6:29);
    end
    
    FinalPredict.Manategh=[FinalPredict.Manategh;A1];
    FinalPredict.Industrial=[FinalPredict.Industrial;A2];
    FinalPredict.Interchange=[FinalPredict.Interchange;A3];
    FinalPredict.Pump=[FinalPredict.Pump;A4];
    FinalActual.Manategh=[FinalActual.Manategh;A5];
    FinalActual.Industrial=[FinalActual.Industrial;A6];
    FinalActual.Interchange=[FinalActual.Interchange;A7];
    FinalActual.Pump=[FinalActual.Pump;A8];
    
    [mapes, errors] = calcError(FinalPredict.Manategh,FinalActual.Manategh,InputData.cal.calH(i+k-1,2));
    MapesFinal.Manategh=[MapesFinal.Manategh;mapes];
    errorsFinal.Manategh=[errorsFinal.Manategh;errors];
    
    [mapes, errors] = calcError(FinalPredict.Pump,FinalActual.Pump,InputData.cal.calH(i+k-1,2));
    MapesFinal.Pump=[MapesFinal.Pump;mapes];
    errorsFinal.Pump=[errorsFinal.Pump;errors];
    
    [mapes, errors] = calcError(FinalPredict.Interchange,FinalActual.Interchange,InputData.cal.calH(i+k-1,2));
    MapesFinal.Interchange=[MapesFinal.Interchange;mapes];
    errorsFinal.Interchange=[errorsFinal.Interchange;errors];
    
    [mapes, errors] = calcError(FinalPredict.Industrial,FinalActual.Industrial,InputData.cal.calH(i+k-1,2));
    MapesFinal.Industrial=[MapesFinal.Industrial;mapes];
    errorsFinal.Industrial=[errorsFinal.Industrial;errors];
    
    [mapes, errors] = calcError(FinalPredict.Manategh+FinalPredict.Industrial+FinalPredict.Pump+FinalPredict.Interchange,FinalActual.Manategh+FinalActual.Industrial+FinalActual.Pump+FinalActual.Interchange,InputData.cal.calH(i+k-1,2));
    MapesFinal.Total=[MapesFinal.Total;mapes];
    errorsFinal.Total=[errorsFinal.Total;errors];

end
FinalPredict.Total=FinalPredict.Manategh+FinalPredict.Industrial+FinalPredict.Pump+FinalPredict.Interchange;
corp.Neuro.Predict=FinalPredict;
corp.Neuro.Mapes = MapesFinal;
corp.Neuro.Errors = errorsFinal;