function [nightPeakPredict,dayPeakPredict]=peakpredictZ(AIn,Apeak,prediction,dayPH,nightPH,dPH,nPH)

A=AIn(1:(end-1),:);

tempN=[];
tempD=[];
for i=1:15
    dayP1 = A(end-i+1,dPH(i)+5);
    nightP1 = A(end-i+1,nPH(i)+5);   
    tempD=[tempD Apeak(end-i+1,2)-dayP1];
    tempN=[tempN Apeak(end-i+1,1)-nightP1];
end
dayP = prediction(dayPH);
dayN = prediction(nightPH);

if isempty(tempD)
    tempD=0;
end
if isempty(tempN)
    tempN=0;
end

dayPeakPredict=dayP+mean(tempD);
nightPeakPredict=dayN+mean(tempN);
