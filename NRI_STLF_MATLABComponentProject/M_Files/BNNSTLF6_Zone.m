function [corp]=BNNSTLF6_Zone(yy,mm,dd,days,corp,InputData)
% yy is the year
% mm is month
% dd is day
% day is the number of days which will be predicted
% N is number of perivious year for training
% corp_load_name is Load name of desired corporation, for example: system
% Example:
% BNNSTLF6(84,1,10,1,2,'system',{'T_tehran','T_tabriz','T_ahvaz'},3,10)

%% Read Data
calH=InputData.cal.calH;
calD=InputData.cal.calD;
Ghcal=InputData.cal.Ghcal;
lct=find(calH(:,1) == yy & calH(:,2) ==mm & calH(:,3) == dd );

zoneNo=length(corp.zone);

for z=1:zoneNo
    mm2=mm;
    dd2=dd;
    yy2 =yy;
    lsys=InputData.Zone{1,z}.Load.Manategh;
    weatherdata=InputData.Zone{1,z}.Weather;
    
    if isempty(weatherdata.Temp)
        weatherdata=weatherdata.Temp;%%% must change!!!!!!
    else
        weatherdata=weatherdata.Temp{1,1};%%% must change!!!!!!
    end
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
    for k=lct:lct+days-1
        [prediction]=BNNpredict(lsys(1:k,:),yy2,mm2,dd2,weatherdata,calH,calD,Ghcal);
        
        Actual=InputData.Zone{1,z}.Load.Manategh(k,6:29);
        if sum(lsys(k,6:29)==0)>0 && sum(lsys(k,6:29)~=0)<24
            prediction(1,1:(24-sum(lsys(k,6:29)==0)))=lsys(k,6:5+(24-sum(lsys(k,6:29)==0)));
            mapes=[];
            errors=[];
        else
            [mapes, errors] = calcError(prediction, Actual,mm2);
        end
        
        lsys(k,6:29)=prediction;
        
        Prediction.Manategh=[Prediction.Manategh; prediction];
        Mapes.Manategh=[Mapes.Manategh;mapes];
        Errors.Manategh=[Errors.Manategh;errors];
        
%         if ~strcmp(corp.name,'system')
            knew=find((InputData.Zone{1,z}.Load.Interchange(:,1)==yy2)&(InputData.Zone{1,z}.Load.Interchange(:,2)==mm2)&(InputData.Zone{1,z}.Load.Interchange(:,3)==dd2));
            
            INDUSTRIAL=InputData.Zone{1,z}.Load.Industrial;
            PUMP=InputData.Zone{1,z}.Load.Pump;
            INTERCHANGE=InputData.Zone{1,z}.Load.Interchange;
            
            if k-lct>0
                PUMP(knew-1,6:29)=PredictionPump;
                INDUSTRIAL(knew-1,6:29)=PredictionIndustrial;
                INTERCHANGE(knew-1,6:29)=PredictionInterchange;
            end
            
            if max(sum(InputData.Zone{1,z}.Load.Manategh(k,6:29)==0),sum(isnan(InputData.Zone{1,z}.Load.Manategh(k,6:29))))>0
                hhh=24-max(sum(InputData.Zone{1,z}.Load.Manategh(k,6:29)==0),sum(isnan(InputData.Zone{1,z}.Load.Manategh(k,6:29))));
            else
                hhh=0;
            end
            
            PredictionPump=[PUMP(knew,6:6+hhh-1) mean(PUMP(-3+knew:-1+knew,6+hhh:29))];
            PredictionIndustrial=[INDUSTRIAL(knew,6:6+hhh-1) mean(INDUSTRIAL(-7+knew:knew-1,6+hhh:29))];
            PredictionInterchange=[INTERCHANGE(knew,6:6+hhh-1) mean(INTERCHANGE(-7+knew:knew-1,6+hhh:29))];
            
            ActualPump=InputData.Zone{1,z}.Load.Pump(knew,6:29);
            ActualIndustrial=InputData.Zone{1,z}.Load.Industrial(knew,6:29);
            ActualInterchange=InputData.Zone{1,z}.Load.Interchange(knew,6:29);
            
            [mapesPump, errorsPump] = calcError(PredictionPump, ActualPump,mm2);
            [mapesIndustrial, errorsIndustrial] = calcError(PredictionIndustrial, ActualIndustrial,mm2);
            [mapesInterchange, errorsInterchange] = calcError(PredictionInterchange, ActualInterchange,mm2);
            
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
            [mapesTotal, errorsTotal] = calcError(PredictTotal, ActualTotal,mm2);
            Prediction.Total=[Prediction.Total; PredictTotal];
            Mapes.Total=[Mapes.Total;mapesTotal];
            Errors.Total=[Errors.Total;errorsTotal];
%         else
%             Prediction.Total=[Prediction.Manategh];
%             Mapes.Total=[Mapes.Manategh];
%             Errors.Total=[Errors.Manategh];
%             Prediction.Manategh=[];
%             Mapes.Manategh=[];
%             Errors.Manategh=[];
%         end
        
        
        if (k<size(InputData.Zone{1,z}.Load.Manategh,1))
            dd2=lsys(k+1,3);
            mm2=lsys(k+1,2);
            yy2=lsys(k+1,1);
        end
    end
    corp.zone{1,z}.BNN.Predict=Prediction;
    corp.zone{1,z}.BNN.Mapes=Mapes;
    corp.zone{1,z}.BNN.Errors=Errors;
end
if ~strcmp(corp.name,'system')
    % summation of zones for corp
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
    knew=find((InputData.Zone{1,z}.Load.Interchange(:,1)==yy)&(InputData.Zone{1,z}.Load.Interchange(:,2)==mm)&(InputData.Zone{1,z}.Load.Interchange(:,3)==dd));
    
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
            A1=A1+corp.zone{1,z}.BNN.Predict.Manategh(k,1:24);
            A2=A2+corp.zone{1,z}.BNN.Predict.Industrial(k,1:24);
            A3=A3+corp.zone{1,z}.BNN.Predict.Interchange(k,1:24);
            A4=A4+corp.zone{1,z}.BNN.Predict.Pump(k,1:24);
            A5=A5+InputData.Zone{1,z}.Load.Manategh(lct+k-1,6:29);
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
        
        [mapes, errors] = calcError(FinalPredict.Manategh,FinalActual.Manategh,InputData.cal.calH(lct+k-1,2));
        MapesFinal.Manategh=[MapesFinal.Manategh;mapes];
        errorsFinal.Manategh=[errorsFinal.Manategh;errors];
        
        [mapes, errors] = calcError(FinalPredict.Pump,FinalActual.Pump,InputData.cal.calH(lct+k-1,2));
        MapesFinal.Pump=[MapesFinal.Pump;mapes];
        errorsFinal.Pump=[errorsFinal.Pump;errors];
        
        [mapes, errors] = calcError(FinalPredict.Interchange,FinalActual.Interchange,InputData.cal.calH(lct+k-1,2));
        MapesFinal.Interchange=[MapesFinal.Interchange;mapes];
        errorsFinal.Interchange=[errorsFinal.Interchange;errors];
        
        [mapes, errors] = calcError(FinalPredict.Industrial,FinalActual.Industrial,InputData.cal.calH(lct+k-1,2));
        MapesFinal.Industrial=[MapesFinal.Industrial;mapes];
        errorsFinal.Industrial=[errorsFinal.Industrial;errors];
        
        [mapes, errors] = calcError(FinalPredict.Manategh+FinalPredict.Industrial+FinalPredict.Pump+FinalPredict.Interchange,FinalActual.Manategh+FinalActual.Industrial+FinalActual.Pump+FinalActual.Interchange,InputData.cal.calH(lct+k-1,2));
        MapesFinal.Total=[MapesFinal.Total;mapes];
        errorsFinal.Total=[errorsFinal.Total;errors];
        
    end
    FinalPredict.Total=FinalPredict.Manategh+FinalPredict.Industrial+FinalPredict.Pump+FinalPredict.Interchange;
    corp.BNN.Predict=FinalPredict;
    corp.BNN.Mapes = MapesFinal;
    corp.BNN.Errors = errorsFinal;
else
    corp.BNN=corp.zone{1, 1}.BNN;
end