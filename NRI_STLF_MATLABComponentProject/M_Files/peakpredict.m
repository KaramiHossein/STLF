function [nightPeakPredict,dayPeakPredict]=peakpredict(AIn,Apeak,prediction)
DayBound=15;
MWbound = 0;
SampleNo = 7;
A=AIn(1:(end-1),:);

tempN=[];
tempD=[];
i=1;
while size(tempD,2)<SampleNo && size(tempN,2)<SampleNo && i<DayBound
    dayP1 = max(A(end-i+1,16:22));
    dayN1 = max(A(end-i+1,23:28));
    if(Apeak(end-i+1,2)-dayP1>=MWbound)
        tempD=[tempD Apeak(end-i+1,2)-dayP1];
    end
    if(Apeak(end-i+1,1)-dayN1>=MWbound)
        tempN=[tempN Apeak(end-i+1,1)-dayN1];
    end
    i=i+1;
end
dayP = max(prediction(11:17));
dayN = max(prediction(18:23));

if isempty(tempD)
    tempD=0;
end
if isempty(tempN)
    tempN=0;
end

dayPeakPredict=dayP+mean(tempD);
nightPeakPredict=dayN+mean(tempN);
