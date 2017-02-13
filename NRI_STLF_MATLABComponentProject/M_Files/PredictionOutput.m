function PredictionOutput(corp, actual, days, flgSimilar, flgBNN, flgNeuro, flgLSQ)

%%% 5 columns of actual is date data and 24 columns of actual is Load Data.


for lct=1:days
    if(actual(lct,4)==1)
        temp = 'Saturday';
    elseif(actual(lct,4)==2)
        temp = 'Sunday';
    elseif(actual(lct,4)==3)
        temp = 'Monday';
    elseif(actual(lct,4)==4)
        temp = 'Tuesday';
    elseif(actual(lct,4)==5)
        temp = 'Wednesday';
    elseif(actual(lct,4)==6)
        temp = 'Thursday';
    elseif(actual(lct,4)==7)
        temp = 'Friday';
    end
    if all(isnan(actual(lct,6:29))==0) && all(actual(lct,6:29)~=0)
        
        figure();
        hold on
        titleText = {['\bf',corp.name,' Load Forecasting,','\rm Date:',num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3)),', ',temp];};
        plot(actual(lct,6:29),'r');
        legendText={'Actual Load'};
        %
        legendText2={};
        predictError =[];
        Color = [];
        if(flgSimilar>0)
            titleText(end+1)={['SimilarDay: mape=',num2str(corp.Similar.Mapes.Total(lct,1)),'% ','maxError=',num2str(max(corp.Similar.Errors.Total(lct,:))),'%']};
            plot(corp.Similar.Predict.Total(lct,1:24),'b');
            legendText(end+1)={'SimilarDay Prediction'};
            %
            predictError=[predictError; corp.Similar.Errors.Total(lct,:)];
            legendText2(end+1)={'SimilarDay Errors'};
            Color =[Color;'b'];
        end
        if(flgBNN>0)
            titleText(end+1)={['BNN: mape=',num2str(corp.BNN.Mapes.Total(lct,1)),'% ','maxError=',num2str(max(corp.BNN.Errors.Total(lct,:))),'%']};
            plot(corp.BNN.Predict.Total(lct,1:24),'g');
            legendText(end+1)={'BNN Prediction'};
            %
            predictError=[predictError; corp.BNN.Errors.Total(lct,:)];
            legendText2(end+1)={'BNN Errors'};
            Color =[Color;'g'];
        end
        if(flgNeuro>0)
            titleText(end+1)={['NeuroFuuzy: mape=',num2str(corp.Neuro.Mapes.Total(lct,1)),'% ','maxError=',num2str(max(corp.Neuro.Errors.Total(lct,:))),'%']};
            plot(corp.Neuro.Predict.Total(lct,1:24),'c');
            legendText(end+1)={'NeuroFuuzy Prediction'};
            %
            predictError=[predictError; corp.Neuro.Errors.Total(lct,:)];
            legendText2(end+1)={'NeuroFuuzy Errors'};
            Color =[Color;'c'];
        end
        if(flgLSQ>0)
            titleText(end+1)={['LSQ: mape=',num2str(corp.LSQ.Mapes.Total(lct,1)),'% ','maxError=',num2str(max(corp.LSQ.Errors.Total(lct,:))),'%']};
            plot(corp.LSQ.Predict.Total(lct,1:24),'m');
            legendText(end+1)={'LSQ Prediction'};
            %
            predictError=[predictError; corp.LSQ.Errors.Total(lct,:)];
            legendText2(end+1)={'LSQ Errors'};
            Color =[Color;'m'];
        end
        
        legend(legendText,'Location','NorthWest');
        title(titleText);
        grid on;
        ylabel('Load');
        xlabel('Hour');
        hold off
        
        
        
        %         figure(lct+days);
        figure();
        hold on;
        hbar = bar(predictError');
        for ii=1:size(Color,1)
            set(hbar(ii),'FaceColor',Color(ii));
        end
        legend(legendText2,'Location','NorthWest');
        title(titleText);
        grid on;
        ylabel('Error');
        xlabel('Hour');
        hold off
        
    else
        %         figure(lct);
        figure();
        hold on
        titleText = {['\bf',corp.name,' Load Forecasting,','\rm Date:',num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3)), ', ',temp];};
        legendText={};
        
        if(flgSimilar>0)
            plot(corp.Similar.Predict.Total(lct,1:24),'b');
            legendText(end+1)={'SimilarDay Prediction'};
        end
        if(flgBNN>0)
            plot(corp.BNN.Predict.Total(lct,1:24),'g');
            legendText(end+1)={'BNN Prediction'};
        end
        if(flgNeuro>0)
            plot(corp.Neuro.Predict.Total(lct,1:24),'c');
            legendText(end+1)={'NeuroFuuzy Prediction'};
        end
        if(flgLSQ>0)
            plot(corp.LSQ.Predict.Total(lct,1:24),'m');
            legendText(end+1)={'LSQ Prediction'};
        end
        
        legend(legendText,'Location','NorthWest');
        title(titleText);
        grid on;
        ylabel('Load');
        xlabel('Hour');
        hold off
    end
end
obj= {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '};
obj1 = obj;
obj1(1,1)={['Date']};
obj1(1,2)={['Hour']};
obj1(1,3)={['Sum']};
for I=1:length(corp.zone)
    obj1(1,3+I)={corp.zone{1,I}.name};
end

%% Total
Total_xls_vector1={};
Total_xls_vector2={};
Total_xls_vector3={};
Total_xls_vector4={};
Total_xls_vector={};
for lct=1:days
    
    
    if(flgSimilar>0)
        Total_xls_vector1=obj;
        Total_xls_vector1(end,2)={'Similar Method'};
        Total_xls_vector1(end+1,:)= obj1;
        for II=1:26
            Total_xls_vector1(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
            Total_xls_vector1(end,2)={num2str(II)};
            if II==25
                Total_xls_vector1(end,2)={'Night Peak'};
            end
            if II==26
                Total_xls_vector1(end,2)={'Day Peak'};
            end
            Total_xls_vector1(end,3)={num2str(corp.Similar.Predict.Total(lct,II))};
            for I=1:length(corp.zone)
                Total_xls_vector1(end,3+I)={num2str(corp.zone{1, I}.Similar.Predict.Total(lct,II))};
            end
        end
        %         Total_xls_vector1=[Total_xls_vector1 {' '} {' '} {' '} {' '} ];
    end
    
    
    if(flgBNN>0)
        Total_xls_vector2=obj;
        Total_xls_vector2(end,2)={'BNN Method'};
        Total_xls_vector2(end+1,:)= obj1;
        for II=1:26
            Total_xls_vector2(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
            Total_xls_vector2(end,2)={num2str(II)};
            if II==25
                Total_xls_vector2(end,2)={'Night Peak'};
            end
            if II==26
                Total_xls_vector2(end,2)={'Day Peak'};
            end
            Total_xls_vector2(end,3)={num2str(corp.BNN.Predict.Total(lct,II))};
            for I=1:length(corp.zone)
                Total_xls_vector2(end,3+I)={num2str(corp.zone{1, I}.BNN.Predict.Total(lct,II))};
            end
        end
        %         Total_xls_vector2=[Total_xls_vector2 {' '} {' '} {' '} {' '} ];
    end
    
    
    if(flgNeuro>0)
        Total_xls_vector3=obj;
        Total_xls_vector3(end,2)={'Neuro-Fuzzy Method'};
        Total_xls_vector3(end+1,:)= obj1;
        for II=1:26
            Total_xls_vector3(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
            Total_xls_vector3(end,2)={num2str(II)};
            if II==25
                Total_xls_vector3(end,2)={'Night Peak'};
            end
            if II==26
                Total_xls_vector3(end,2)={'Day Peak'};
            end
            Total_xls_vector3(end,3)={num2str(corp.Neuro.Predict.Total(lct,II))};
            for I=1:length(corp.zone)
                Total_xls_vector3(end,3+I)={num2str(corp.zone{1, I}.Neuro.Predict.Total(lct,II))};
            end
        end
        %         Total_xls_vector3=[Total_xls_vector3 {' '} {' '} {' '} {' '} ];
    end
    
    
    if(flgLSQ>0)
        Total_xls_vector4=obj;
        Total_xls_vector4(end,2)={'BNN Method'};
        Total_xls_vector4(end+1,:)= obj1;
        for II=1:26
            Total_xls_vector4(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
            Total_xls_vector4(end,2)={num2str(II)};
            if II==25
                Total_xls_vector4(end,2)={'Night Peak'};
            end
            if II==26
                Total_xls_vector4(end,2)={'Day Peak'};
            end
            Total_xls_vector4(end,3)={num2str(corp.LSQ.Predict.Total(lct,II))};
            for I=1:length(corp.zone)
                Total_xls_vector4(end,3+I)={num2str(corp.zone{1, I}.LSQ.Predict.Total(lct,II))};
            end
        end
        %         Total_xls_vector4=[Total_xls_vector4 {' '} {' '} {' '} {' '} ];
    end
    Total_xls_vector=[Total_xls_vector;Total_xls_vector1 Total_xls_vector2 Total_xls_vector3 Total_xls_vector4];
    Total_xls_vector=[Total_xls_vector;cell(5,size(Total_xls_vector,2))];
    
end


%% Manategh
Manategh_xls_vector1={};
Manategh_xls_vector2={};
Manategh_xls_vector3={};
Manategh_xls_vector4={};
Manategh_xls_vector={};
for lct=1:days
    
    
    if(flgSimilar>0)
        Manategh_xls_vector1=obj;
        Manategh_xls_vector1(end,2)={'Similar Method'};
        Manategh_xls_vector1(end+1,:)= obj1;
        for II=1:26
            Manategh_xls_vector1(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
            Manategh_xls_vector1(end,2)={num2str(II)};
            if II==25
                Manategh_xls_vector1(end,2)={'Night Peak'};
            end
            if II==26
                Manategh_xls_vector1(end,2)={'Day Peak'};
            end
            Manategh_xls_vector1(end,3)={num2str(corp.Similar.Predict.Manategh(lct,II))};
            for I=1:length(corp.zone)
                Manategh_xls_vector1(end,3+I)={num2str(corp.zone{1, I}.Similar.Predict.Manategh(lct,II))};
            end
        end
        %         Manategh_xls_vector1=[Manategh_xls_vector1 {' '} {' '} {' '} {' '} ];
    end
    
    
    if(flgBNN>0)
        Manategh_xls_vector2=obj;
        Manategh_xls_vector2(end,2)={'BNN Method'};
        Manategh_xls_vector2(end+1,:)= obj1;
        for II=1:26
            Manategh_xls_vector2(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
            Manategh_xls_vector2(end,2)={num2str(II)};
            if II==25
                Manategh_xls_vector2(end,2)={'Night Peak'};
            end
            if II==26
                Manategh_xls_vector2(end,2)={'Day Peak'};
            end
            Manategh_xls_vector2(end,3)={num2str(corp.BNN.Predict.Manategh(lct,II))};
            for I=1:length(corp.zone)
                Manategh_xls_vector2(end,3+I)={num2str(corp.zone{1, I}.BNN.Predict.Manategh(lct,II))};
            end
        end
        %         Manategh_xls_vector2=[Manategh_xls_vector2 {' '} {' '} {' '} {' '} ];
    end
    
    
    if(flgNeuro>0)
        Manategh_xls_vector3=obj;
        Manategh_xls_vector3(end,2)={'Neuro-Fuzzy Method'};
        Manategh_xls_vector3(end+1,:)= obj1;
        for II=1:26
            Manategh_xls_vector3(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
            Manategh_xls_vector3(end,2)={num2str(II)};
            if II==25
                Manategh_xls_vector3(end,2)={'Night Peak'};
            end
            if II==26
                Manategh_xls_vector3(end,2)={'Day Peak'};
            end
            Manategh_xls_vector3(end,3)={num2str(corp.Neuro.Predict.Manategh(lct,II))};
            for I=1:length(corp.zone)
                Manategh_xls_vector3(end,3+I)={num2str(corp.zone{1, I}.Neuro.Predict.Manategh(lct,II))};
            end
        end
        %         Manategh_xls_vector3=[Manategh_xls_vector3 {' '} {' '} {' '} {' '} ];
    end
    
    
    if(flgLSQ>0)
        Manategh_xls_vector4=obj;
        Manategh_xls_vector4(end,2)={'BNN Method'};
        Manategh_xls_vector4(end+1,:)= obj1;
        for II=1:26
            Manategh_xls_vector4(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
            Manategh_xls_vector4(end,2)={num2str(II)};
            if II==25
                Manategh_xls_vector4(end,2)={'Night Peak'};
            end
            if II==26
                Manategh_xls_vector4(end,2)={'Day Peak'};
            end
            Manategh_xls_vector4(end,3)={num2str(corp.LSQ.Predict.Manategh(lct,II))};
            for I=1:length(corp.zone)
                Manategh_xls_vector4(end,3+I)={num2str(corp.zone{1, I}.LSQ.Predict.Manategh(lct,II))};
            end
        end
        %         Manategh_xls_vector4=[Manategh_xls_vector4 {' '} {' '} {' '} {' '} ];
    end
    Manategh_xls_vector=[Manategh_xls_vector;Manategh_xls_vector1 Manategh_xls_vector2 Manategh_xls_vector3 Manategh_xls_vector4];
    Manategh_xls_vector=[Manategh_xls_vector;cell(5,size(Manategh_xls_vector,2))];
    
    
    
end


%% Industrial
Industrial_xls_vector1={};
Industrial_xls_vector2={};
Industrial_xls_vector3={};
Industrial_xls_vector4={};
Industrial_xls_vector={};
for lct=1:days
    
    
    if(flgSimilar>0)
        Industrial_xls_vector1=obj;
        Industrial_xls_vector1(end,2)={'Similar Method'};
        Industrial_xls_vector1(end+1,:)= obj1;
        for II=1:26
            Industrial_xls_vector1(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
            Industrial_xls_vector1(end,2)={num2str(II)};
            if II==25
                Industrial_xls_vector1(end,2)={'Night Peak'};
            end
            if II==26
                Industrial_xls_vector1(end,2)={'Day Peak'};
            end
            Industrial_xls_vector1(end,3)={num2str(corp.Similar.Predict.Industrial(lct,II))};
            for I=1:length(corp.zone)
                Industrial_xls_vector1(end,3+I)={num2str(corp.zone{1, I}.Similar.Predict.Industrial(lct,II))};
            end
        end
        %         Industrial_xls_vector1=[Industrial_xls_vector1 {' '} {' '} {' '} {' '} ];
    end
    
    
    if(flgBNN>0)
        Industrial_xls_vector2=obj;
        Industrial_xls_vector2(end,2)={'BNN Method'};
        Industrial_xls_vector2(end+1,:)= obj1;
        for II=1:26
            Industrial_xls_vector2(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
            Industrial_xls_vector2(end,2)={num2str(II)};
            if II==25
                Industrial_xls_vector2(end,2)={'Night Peak'};
            end
            if II==26
                Industrial_xls_vector2(end,2)={'Day Peak'};
            end
            Industrial_xls_vector2(end,3)={num2str(corp.BNN.Predict.Industrial(lct,II))};
            for I=1:length(corp.zone)
                Industrial_xls_vector2(end,3+I)={num2str(corp.zone{1, I}.BNN.Predict.Industrial(lct,II))};
            end
        end
        %         Industrial_xls_vector2=[Industrial_xls_vector2 {' '} {' '} {' '} {' '} ];
    end
    
    
    if(flgNeuro>0)
        Industrial_xls_vector3=obj;
        Industrial_xls_vector3(end,2)={'Neuro-Fuzzy Method'};
        Industrial_xls_vector3(end+1,:)= obj1;
        for II=1:26
            Industrial_xls_vector3(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
            Industrial_xls_vector3(end,2)={num2str(II)};
            if II==25
                Industrial_xls_vector3(end,2)={'Night Peak'};
            end
            if II==26
                Industrial_xls_vector3(end,2)={'Day Peak'};
            end
            Industrial_xls_vector3(end,3)={num2str(corp.Neuro.Predict.Industrial(lct,II))};
            for I=1:length(corp.zone)
                Industrial_xls_vector3(end,3+I)={num2str(corp.zone{1, I}.Neuro.Predict.Industrial(lct,II))};
            end
        end
        %         Industrial_xls_vector3=[Industrial_xls_vector3 {' '} {' '} {' '} {' '} ];
    end
    
    
    if(flgLSQ>0)
        Industrial_xls_vector4=obj;
        Industrial_xls_vector4(end,2)={'BNN Method'};
        Industrial_xls_vector4(end+1,:)= obj1;
        for II=1:26
            Industrial_xls_vector4(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
            Industrial_xls_vector4(end,2)={num2str(II)};
            if II==25
                Industrial_xls_vector4(end,2)={'Night Peak'};
            end
            if II==26
                Industrial_xls_vector4(end,2)={'Day Peak'};
            end
            Industrial_xls_vector4(end,3)={num2str(corp.LSQ.Predict.Industrial(lct,II))};
            for I=1:length(corp.zone)
                Industrial_xls_vector4(end,3+I)={num2str(corp.zone{1, I}.LSQ.Predict.Industrial(lct,II))};
            end
        end
        %         Industrial_xls_vector4=[Industrial_xls_vector4 {' '} {' '} {' '} {' '} ];
    end
    Industrial_xls_vector=[Industrial_xls_vector;Industrial_xls_vector1 Industrial_xls_vector2 Industrial_xls_vector3 Industrial_xls_vector4];
    Industrial_xls_vector=[Industrial_xls_vector;cell(5,size(Industrial_xls_vector,2))];
    
    
end



%% Interchange
Interchange_xls_vector1={};
Interchange_xls_vector2={};
Interchange_xls_vector3={};
Interchange_xls_vector4={};
Interchange_xls_vector={};
for lct=1:days
    
    
    if(flgSimilar>0)
        Interchange_xls_vector1=obj;
        Interchange_xls_vector1(end,2)={'Similar Method'};
        Interchange_xls_vector1(end+1,:)= obj1;
        for II=1:26
            Interchange_xls_vector1(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
            Interchange_xls_vector1(end,2)={num2str(II)};
            if II==25
                Interchange_xls_vector1(end,2)={'Night Peak'};
            end
            if II==26
                Interchange_xls_vector1(end,2)={'Day Peak'};
            end
            Interchange_xls_vector1(end,3)={num2str(corp.Similar.Predict.Interchange(lct,II))};
            for I=1:length(corp.zone)
                Interchange_xls_vector1(end,3+I)={num2str(corp.zone{1, I}.Similar.Predict.Interchange(lct,II))};
            end
        end
        %         Interchange_xls_vector1=[Interchange_xls_vector1 {' '} {' '} {' '} {' '} ];
    end
    
    
    if(flgBNN>0)
        Interchange_xls_vector2=obj;
        Interchange_xls_vector2(end,2)={'BNN Method'};
        Interchange_xls_vector2(end+1,:)= obj1;
        for II=1:26
            Interchange_xls_vector2(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
            Interchange_xls_vector2(end,2)={num2str(II)};
            if II==25
                Interchange_xls_vector2(end,2)={'Night Peak'};
            end
            if II==26
                Interchange_xls_vector2(end,2)={'Day Peak'};
            end
            Interchange_xls_vector2(end,3)={num2str(corp.BNN.Predict.Interchange(lct,II))};
            for I=1:length(corp.zone)
                Interchange_xls_vector2(end,3+I)={num2str(corp.zone{1, I}.BNN.Predict.Interchange(lct,II))};
            end
        end
        %         Interchange_xls_vector2=[Interchange_xls_vector2 {' '} {' '} {' '} {' '} ];
    end
    
    
    if(flgNeuro>0)
        Interchange_xls_vector3=obj;
        Interchange_xls_vector3(end,2)={'Neuro-Fuzzy Method'};
        Interchange_xls_vector3(end+1,:)= obj1;
        for II=1:26
            Interchange_xls_vector3(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
            Interchange_xls_vector3(end,2)={num2str(II)};
            if II==25
                Interchange_xls_vector3(end,2)={'Night Peak'};
            end
            if II==26
                Interchange_xls_vector3(end,2)={'Day Peak'};
            end
            Interchange_xls_vector3(end,3)={num2str(corp.Neuro.Predict.Interchange(lct,II))};
            for I=1:length(corp.zone)
                Interchange_xls_vector3(end,3+I)={num2str(corp.zone{1, I}.Neuro.Predict.Interchange(lct,II))};
            end
        end
        %         Interchange_xls_vector3=[Interchange_xls_vector3 {' '} {' '} {' '} {' '} ];
    end
    
    
    if(flgLSQ>0)
        Interchange_xls_vector4=obj;
        Interchange_xls_vector4(end,2)={'BNN Method'};
        Interchange_xls_vector4(end+1,:)= obj1;
        for II=1:26
            Interchange_xls_vector4(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
            Interchange_xls_vector4(end,2)={num2str(II)};
            if II==25
                Interchange_xls_vector4(end,2)={'Night Peak'};
            end
            if II==26
                Interchange_xls_vector4(end,2)={'Day Peak'};
            end
            Interchange_xls_vector4(end,3)={num2str(corp.LSQ.Predict.Interchange(lct,II))};
            for I=1:length(corp.zone)
                Interchange_xls_vector4(end,3+I)={num2str(corp.zone{1, I}.LSQ.Predict.Interchange(lct,II))};
            end
        end
        %         Interchange_xls_vector4=[Interchange_xls_vector4 {' '} {' '} {' '} {' '} ];
    end
    Interchange_xls_vector=[Interchange_xls_vector;Interchange_xls_vector1 Interchange_xls_vector2 Interchange_xls_vector3 Interchange_xls_vector4];
    Interchange_xls_vector=[Interchange_xls_vector;cell(5,size(Interchange_xls_vector,2))];
    
    
end


%% Pump
Pump_xls_vector1={};
Pump_xls_vector2={};
Pump_xls_vector3={};
Pump_xls_vector4={};
Pump_xls_vector={};
for lct=1:days
    
    
    if(flgSimilar>0)
        Pump_xls_vector1=obj;
        Pump_xls_vector1(end,2)={'Similar Method'};
        Pump_xls_vector1(end+1,:)= obj1;
        for II=1:26
            Pump_xls_vector1(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
            Pump_xls_vector1(end,2)={num2str(II)};
            if II==25
                Pump_xls_vector1(end,2)={'Night Peak'};
            end
            if II==26
                Pump_xls_vector1(end,2)={'Day Peak'};
            end
            Pump_xls_vector1(end,3)={num2str(corp.Similar.Predict.Pump(lct,II))};
            for I=1:length(corp.zone)
                Pump_xls_vector1(end,3+I)={num2str(corp.zone{1, I}.Similar.Predict.Pump(lct,II))};
            end
        end
        %         Pump_xls_vector1=[Pump_xls_vector1 {' '} {' '} {' '} {' '} ];
    end
    
    
    if(flgBNN>0)
        Pump_xls_vector2=obj;
        Pump_xls_vector2(end,2)={'BNN Method'};
        Pump_xls_vector2(end+1,:)= obj1;
        for II=1:26
            Pump_xls_vector2(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
            Pump_xls_vector2(end,2)={num2str(II)};
            if II==25
                Pump_xls_vector2(end,2)={'Night Peak'};
            end
            if II==26
                Pump_xls_vector2(end,2)={'Day Peak'};
            end
            Pump_xls_vector2(end,3)={num2str(corp.BNN.Predict.Pump(lct,II))};
            for I=1:length(corp.zone)
                Pump_xls_vector2(end,3+I)={num2str(corp.zone{1, I}.BNN.Predict.Pump(lct,II))};
            end
        end
        %         Pump_xls_vector2=[Pump_xls_vector2 {' '} {' '} {' '} {' '} ];
    end
    
    
    if(flgNeuro>0)
        Pump_xls_vector3=obj;
        Pump_xls_vector3(end,2)={'Neuro-Fuzzy Method'};
        Pump_xls_vector3(end+1,:)= obj1;
        for II=1:26
            Pump_xls_vector3(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
            Pump_xls_vector3(end,2)={num2str(II)};
            if II==25
                Pump_xls_vector3(end,2)={'Night Peak'};
            end
            if II==26
                Pump_xls_vector3(end,2)={'Day Peak'};
            end
            Pump_xls_vector3(end,3)={num2str(corp.Neuro.Predict.Pump(lct,II))};
            for I=1:length(corp.zone)
                Pump_xls_vector3(end,3+I)={num2str(corp.zone{1, I}.Neuro.Predict.Pump(lct,II))};
            end
        end
        %         Pump_xls_vector3=[Pump_xls_vector3 {' '} {' '} {' '} {' '} ];
    end
    
    
    if(flgLSQ>0)
        Pump_xls_vector4=obj;
        Pump_xls_vector4(end,2)={'BNN Method'};
        Pump_xls_vector4(end+1,:)= obj1;
        for II=1:26
            Pump_xls_vector4(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
            Pump_xls_vector4(end,2)={num2str(II)};
            if II==25
                Pump_xls_vector4(end,2)={'Night Peak'};
            end
            if II==26
                Pump_xls_vector4(end,2)={'Day Peak'};
            end
            Pump_xls_vector4(end,3)={num2str(corp.LSQ.Predict.Pump(lct,II))};
            for I=1:length(corp.zone)
                Pump_xls_vector4(end,3+I)={num2str(corp.zone{1, I}.LSQ.Predict.Pump(lct,II))};
            end
        end
        %         Pump_xls_vector4=[Pump_xls_vector4 {' '} {' '} {' '} {' '} ];
    end
    Pump_xls_vector=[Pump_xls_vector;Pump_xls_vector1 Pump_xls_vector2 Pump_xls_vector3 Pump_xls_vector4];
    Pump_xls_vector=[Pump_xls_vector;cell(5,size(Pump_xls_vector,2))];
    
end



%% Errors
Errors_xls_vector1={};
Errors_xls_vector2={};
Errors_xls_vector3={};
Errors_xls_vector4={};
Errors_xls_vector={};
for lct=1:days
    
    if sum(isnan(actual(lct,6:29))==0) && sum(actual(lct,6:29)==0)<3
        if(flgSimilar>0)
            Errors_xls_vector1=obj;
            Errors_xls_vector1(end,2)={'Similar Method'};
            Errors_xls_vector1(end+1,:)= obj1;
            for II=1:24
                Errors_xls_vector1(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
                Errors_xls_vector1(end,2)={num2str(II)};
                Errors_xls_vector1(end,3)={num2str(corp.Similar.Errors.Total(lct,II))};
                for I=1:length(corp.zone)
                    Errors_xls_vector1(end,3+I)={num2str(corp.zone{1, I}.Similar.Errors.Total(lct,II))};
                end
            end
            %         Errors_xls_vector1=[Errors_xls_vector1 {' '} {' '} {' '} {' '} ];
        end
        
        
        if(flgBNN>0)
            Errors_xls_vector2=obj;
            Errors_xls_vector2(end,2)={'BNN Method'};
            Errors_xls_vector2(end+1,:)= obj1;
            for II=1:24
                Errors_xls_vector2(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
                Errors_xls_vector2(end,2)={num2str(II)};
                Errors_xls_vector2(end,3)={num2str(corp.BNN.Errors.Total(lct,II))};
                for I=1:length(corp.zone)
                    Errors_xls_vector2(end,3+I)={num2str(corp.zone{1, I}.BNN.Errors.Total(lct,II))};
                end
            end
            %         Errors_xls_vector2=[Errors_xls_vector2 {' '} {' '} {' '} {' '} ];
        end
        
        
        if(flgNeuro>0)
            Errors_xls_vector3=obj;
            Errors_xls_vector3(end,2)={'Neuro-Fuzzy Method'};
            Errors_xls_vector3(end+1,:)= obj1;
            for II=1:24
                Errors_xls_vector3(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
                Errors_xls_vector3(end,2)={num2str(II)};
                Errors_xls_vector3(end,3)={num2str(corp.Neuro.Errors.Total(lct,II))};
                for I=1:length(corp.zone)
                    Errors_xls_vector3(end,3+I)={num2str(corp.zone{1, I}.Neuro.Errors.Total(lct,II))};
                end
            end
            %         Errors_xls_vector3=[Errors_xls_vector3 {' '} {' '} {' '} {' '} ];
        end
        
        
        if(flgLSQ>0)
            Errors_xls_vector4=obj;
            Errors_xls_vector4(end,2)={'BNN Method'};
            Errors_xls_vector4(end+1,:)= obj1;
            for II=1:24
                Errors_xls_vector4(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
                Errors_xls_vector4(end,2)={num2str(II)};
                Errors_xls_vector4(end,3)={num2str(corp.LSQ.Errors.Total(lct,II))};
                for I=1:length(corp.zone)
                    Errors_xls_vector4(end,3+I)={num2str(corp.zone{1, I}.LSQ.Errors.Total(lct,II))};
                end
            end
            %         Errors_xls_vector4=[Errors_xls_vector4 {' '} {' '} {' '} {' '} ];
        end
    end
    Errors_xls_vector=[Errors_xls_vector;Errors_xls_vector1 Errors_xls_vector2 Errors_xls_vector3 Errors_xls_vector4];
    Errors_xls_vector=[Errors_xls_vector;cell(5,size(Errors_xls_vector,2))];
    
end



%% Mapes
Mapes_xls_vector1={};
Mapes_xls_vector2={};
Mapes_xls_vector3={};
Mapes_xls_vector4={};
Mapes_xls_vector={};
for lct=1:days
    MapeName=[{'Total'};{'Peak'};{'Ordinary'};{'Low'}];
    
    if sum(isnan(actual(lct,6:29))==0) && sum(actual(lct,6:29)==0)<3
        if(flgSimilar>0)
            Mapes_xls_vector1=obj;
            Mapes_xls_vector1(end,2)={'Similar Method'};
            Mapes_xls_vector1(end+1,:)= obj1;
            for II=1:4
                Mapes_xls_vector1(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
                Mapes_xls_vector1(end,2)=MapeName(II,1);
                Mapes_xls_vector1(end,3)={num2str(corp.Similar.Mapes.Total(lct,II))};
                for I=1:length(corp.zone)
                    Mapes_xls_vector1(end,3+I)={num2str(corp.zone{1, I}.Similar.Mapes.Total(lct,II))};
                end
            end
            %         Mapes_xls_vector1=[Mapes_xls_vector1 {' '} {' '} {' '} {' '} ];
        end
        
        
        if(flgBNN>0)
            Mapes_xls_vector2=obj;
            Mapes_xls_vector2(end,2)={'BNN Method'};
            Mapes_xls_vector2(end+1,:)= obj1;
            for II=1:4
                Mapes_xls_vector2(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
                Mapes_xls_vector2(end,2)=MapeName(II,1);
                Mapes_xls_vector2(end,3)={num2str(corp.BNN.Mapes.Total(lct,II))};
                for I=1:length(corp.zone)
                    Mapes_xls_vector2(end,3+I)={num2str(corp.zone{1, I}.BNN.Mapes.Total(lct,II))};
                end
            end
            %         Mapes_xls_vector2=[Mapes_xls_vector2 {' '} {' '} {' '} {' '} ];
        end
        
        
        if(flgNeuro>0)
            Mapes_xls_vector3=obj;
            Mapes_xls_vector3(end,2)={'Neuro-Fuzzy Method'};
            Mapes_xls_vector3(end+1,:)= obj1;
            for II=1:4
                Mapes_xls_vector3(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
                Mapes_xls_vector3(end,2)=MapeName(II,1);
                Mapes_xls_vector3(end,3)={num2str(corp.Neuro.Mapes.Total(lct,II))};
                for I=1:length(corp.zone)
                    Mapes_xls_vector3(end,3+I)={num2str(corp.zone{1, I}.Neuro.Mapes.Total(lct,II))};
                end
            end
            %         Mapes_xls_vector3=[Mapes_xls_vector3 {' '} {' '} {' '} {' '} ];
        end
        
        
        if(flgLSQ>0)
            Mapes_xls_vector4=obj;
            Mapes_xls_vector4(end,2)={'BNN Method'};
            Mapes_xls_vector4(end+1,:)= obj1;
            for II=1:4
                Mapes_xls_vector4(end+1,1)={[num2str(actual(lct,1)),'/',num2str(actual(lct,2)),'/',num2str(actual(lct,3))]};
                Mapes_xls_vector4(end,2)=MapeName(II,1);
                Mapes_xls_vector4(end,3)={num2str(corp.LSQ.Mapes.Total(lct,II))};
                for I=1:length(corp.zone)
                    Mapes_xls_vector4(end,3+I)={num2str(corp.zone{1, I}.LSQ.Mapes.Total(lct,II))};
                end
            end
            %         Mapes_xls_vector4=[Mapes_xls_vector4 {' '} {' '} {' '} {' '} ];
        end
    end
    Mapes_xls_vector=[Mapes_xls_vector;Mapes_xls_vector1 Mapes_xls_vector2 Mapes_xls_vector3 Mapes_xls_vector4];
    Mapes_xls_vector=[Mapes_xls_vector;cell(5,size(Mapes_xls_vector,2))];
    
end

%% Write to Excel
mh_xls_filename=['LoadForecastingResults',num2str(actual(1,1)),',',num2str(actual(1,2)),',',num2str(actual(1,3)),',',num2str(days),',',corp.name,'.xls'];
cd('ForecastingResults');
xlswrite(mh_xls_filename,Manategh_xls_vector,'Manategh');
xlswrite(mh_xls_filename,Interchange_xls_vector,'Interchange');
xlswrite(mh_xls_filename,Industrial_xls_vector,'Industrial');
xlswrite(mh_xls_filename,Pump_xls_vector,'Pump');
if sum(isnan(actual(1,6:29))==0) && sum(actual(1,6:29)==0)<3
    xlswrite(mh_xls_filename,Errors_xls_vector,'Errors');
    xlswrite(mh_xls_filename,Mapes_xls_vector,'Mapes');
end
xlswrite(mh_xls_filename,Total_xls_vector,'Total');
NAME = [cd '\' mh_xls_filename];
excelObj = actxserver('Excel.Application');
excelWorkbook = excelObj.workbooks.Open(NAME);
worksheets = excelObj.sheets;
excelObj.EnableSound = false;
worksheets.Item(1).Delete;
excelObj.EnableSound = true;
excelWorkbook.Save;
excelWorkbook.Close(false);
excelObj.Quit;
delete(excelObj);
cd('..')
