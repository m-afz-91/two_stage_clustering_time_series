function plotTimeSeries(dataTempLib2,lastTime)


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Sort cluster number based on quantity (1st cluster with highest number of observations)
    

    clusInfo = [];
    
    for i = 1:length(unique(dataTempLib2(:,end)))
        
        temp = dataTempLib2(dataTempLib2(:,end)==i,1:lastTime);
        countNo = size(temp,1);
        clusInfo = [clusInfo; i,countNo];
        
    end
    clusInfo = sortrows(clusInfo,-2);
    clusInfo = [clusInfo,[1:length(unique(dataTempLib2(:,end)))]'];
    
    
    dataTemp2=[]; dataTempSign2 = [];
    for j = 1:length(unique(dataTempLib2(:,end)))
        temp = dataTempLib2(dataTempLib2(:,end)==j,1:end);
        idx=clusInfo(find(clusInfo(:,1)==j),3); temp(:,end)=idx; 
        dataTemp2 = [dataTemp2;temp];

        
    end
    dataTempLib2 = dataTemp2;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    
    
%%%%%%%%% Plot

for i = 1:length(unique(dataTempLib2(:,end)))
    
    % Row and column for plots
    rowPlot = ceil(length(unique(dataTempLib2(:,end)))/6);
    rowPlot = min(5,rowPlot);
    colPlot = 6;
    %
    
    kAvg = length(unique(dataTempLib2(:,end)));
    temp = dataTempLib2(dataTempLib2(:,end)==i,1:lastTime);
    centroid = temp; % cluster centroid
    
    
    if size(temp,1)>1
%          centroid = mean(temp);
              centroid=DBA(temp);
    end
    
    temp = dataTempLib2(dataTempLib2(:,end)==i,1:lastTime);
    
    if i<=30
        figure(7);
        subplot(rowPlot,colPlot,i);
        plot1 = plot(temp');
        
    elseif i<=60
        figure(8);
        subplot(rowPlot,colPlot,i-30);
        plot1 = plot(temp');
        
    elseif i<=90
        figure(9);
        subplot(rowPlot,colPlot,i-60);
        plot1 = plot(temp');
    else
        figure(10);
        subplot(rowPlot,colPlot,i-90);
        plot1 = plot(temp');
        
    end
    
    
    
    if size(temp,1)<50
        col = 0.2;
    elseif size(temp,1)<200
        col = 0.1;
    else
        col = 0.025;
    end
    
    for j = 1:size(plot1,1)
        plot1(j).Color=[0,0,0,col];
    end
    
    hold on;
    plot(centroid','r','LineWidth',2.5);
    ylim([0 2*max(centroid)])

    title({['#',num2str(i),', Frequency: ',num2str(sprintf('%1.3f',(size(temp,1)./size(dataTempLib2,1))))]})
    
    set(gca,'XTick',[0; 24;  48;  72;  96])
    set(gca,'XTickLabel',[0;6;12;18;24])
    
end