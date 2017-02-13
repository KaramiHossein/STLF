function [corp]=LoadForecastingsimilar_new(yy,mm,dd,days,corp,InputData)
%System Short Term Load Forecasting By Neural Network Method.
%This function matlab(M) File Computes Forecasted Load for a Time Horison.
%-----------------------------------------------------------------------
%day is the prediction horizon
%L is the length of the window
%mode is the prediction mode:1=fixed window  2=gliding window
%first_year is the first year that must be used
% Example :
% LoadForecastingsimilar_new(93,5,15,2,corp,InputData)


L=7;
mode=2;

% Determining Special Shamsi Days(spshd)
shcal=[1 1; 1 2; 1 3; 1 4 ; 1 12; 1 13; 3 14; 3 15; 11 22; 12 29;6 30];
ghcal = InputData.cal.Ghcal;

Adays=zeros(size(InputData.cal.calH,1),1);
for i=1:size(Adays,1)
    if InputData.cal.calH(i,5)~=1
        if sum((InputData.cal.calH(i,2)==shcal(:,1)).*(InputData.cal.calH(i,3)==shcal(:,2)))~=0
            ok=find((InputData.cal.calH(i,2)==shcal(:,1)).*(InputData.cal.calH(i,3)==shcal(:,2)));
            Adays(i,1)=ok+16;
        else
            ok=find((InputData.cal.calH(i,1)==ghcal(:,1))&(InputData.cal.calH(i,2)==ghcal(:,2))&(InputData.cal.calH(i,3)==ghcal(:,3)));
            if size(ok,1)~=0
                Adays(i,1)=ghcal(ok,4);
            end
        end
    end
end

% Build Ramezan Day matrix
daysramezan=zeros(1,size(InputData.cal.calH,1));
ll=find(Adays==16); % find first day of ramezan
ll2 = find(Adays==14); %find eid fetr
%if ramezan be in first month
if (ll2(1)<ll(1))
    daysramezan(1:(ll2(1)-1))=1;
end
for i=1:length(ll)
    lll = find(Adays((ll(i)+1):(ll(i)+30))==14,1,'first');
    kk=min(ll(i)+lll-1,size(daysramezan,2));
    daysramezan(ll(i))=2;
    daysramezan((ll(i)+1):kk)=1;
end

% added by m karimi 6/31 & 1 ramezan not important in this step
ll=find(InputData.cal.calH(:,5)==7 | InputData.cal.calH(:,5)==8);
InputData.cal.calH(ll,5)=1;
%
daytypes=zeros(1,size(InputData.cal.calH,1));

ll=find(InputData.cal.calH(:,5)==6);
InputData.cal.calH(ll,5)=1;
ll=find(InputData.cal.calH(:,5)~=1);
daytypes(ll)=5;
ll=find((InputData.cal.calH(:,5)==1)&(InputData.cal.calH(:,4)==1));
daytypes(ll)=1;
ll=find((InputData.cal.calH(:,5)==1)&(InputData.cal.calH(:,4)==6));
daytypes(ll)=3;
ll=find((InputData.cal.calH(:,5)==1)&(InputData.cal.calH(:,4)==7));
daytypes(ll)=4;
ll=find((InputData.cal.calH(2:end,5)==1)&(InputData.cal.calH(1:(end-1),5)~=1));
daytypes(ll+1)=6;
ll=find(daytypes==0);
daytypes(ll)=2;


% find selected day
i=find((InputData.cal.calH(:,1)==yy)&(InputData.cal.calH(:,2)==mm)&(InputData.cal.calH(:,3)==dd));

% corp = FitWeatherZone(yy,mm,dd,corp,InputData,daytypes); %% its temporary

zoneNo=length(corp.zone);

for z = 1:zoneNo
    mm2=mm;
    dd2=dd;
    yy2 =yy;
    
    corp.zone{1,z}.FittedWeather = []; %% its temporary
    
    AA = InputData.Zone{1,z}.Load.Manategh;
    AA(:,1:5) = InputData.cal.calH;
    flagD = InputData.Zone{1,z}.flag;
    
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
        
        [prediction]=similarpredict(AA(1:k,:),yy2,mm2,dd2,daytypes(1:k),Adays(1:k),daysramezan(1:k),L,InputData.Zone{1,z}.Weather,corp.zone{1,z}.FittedWeather,flagD(1:k,:));
        
        Actual=InputData.Zone{1,z}.Load.Manategh(k,6:29);
        [mapes, errors] = calcError(prediction, Actual,mm2);
        AA(k,6:29)=prediction;
        
        Prediction.Manategh=[Prediction.Manategh; prediction];
        Mapes.Manategh=[Mapes.Manategh;mapes];
        Errors.Manategh=[Errors.Manategh;errors];

        if ~strcmp(corp.name,'system')
            knew=find((InputData.Zone{1,z}.Load.Interchange(:,1)==yy2)&(InputData.Zone{1,z}.Load.Interchange(:,2)==mm2)&(InputData.Zone{1,z}.Load.Interchange(:,3)==dd2));
            
            INDUSTRIAL=InputData.Zone{1,z}.Load.Industrial;
            PUMP=InputData.Zone{1,z}.Load.Pump;
            INTERCHANGE=InputData.Zone{1,z}.Load.Interchange;
            
            if k-i>0
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
        else
            Prediction.Total=[Prediction.Manategh];
            Mapes.Total=[Mapes.Manategh];
            Errors.Total=[Errors.Manategh];
            Prediction.Manategh=[];
            Mapes.Manategh=[];
            Errors.Manategh=[];
        end
        
        
        
        
        if (k<size(InputData.Zone{1,z}.Load.Manategh,1))
            dd2=AA(k+1,3);
            mm2=AA(k+1,2);
            yy2=AA(k+1,1);
        end
    end
    corp.zone{1,z}.Similar.Predict=Prediction;
    corp.zone{1,z}.Similar.Mapes=Mapes;
    corp.zone{1,z}.Similar.Errors=Errors;
end
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
        A1=A1+corp.zone{1,z}.Similar.Predict.Manategh(k,1:24);
        A2=A2+corp.zone{1,z}.Similar.Predict.Industrial(k,1:24);
        A3=A3+corp.zone{1,z}.Similar.Predict.Interchange(k,1:24);
        A4=A4+corp.zone{1,z}.Similar.Predict.Pump(k,1:24);
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
corp.Similar.Predict=FinalPredict;
corp.Similar.Mapes = MapesFinal;
corp.Similar.Errors = errorsFinal;

