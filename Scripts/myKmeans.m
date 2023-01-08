function dataK = myKmeans(data,k,HM)


idxClus = kmeans(data,k);
dataK = [data,idxClus];

if nargin > 2
    
    n = length(unique(dataK(:,end)));
    CM = jet(n);
    
    
    if ~HM
        for i = 1:n
            figure;
            plot(dataK(dataK(:,end)==i,1:end-1)','color',CM(i,:),...
                'LineStyle','-','LineWidth',4);
            hold on;
            plot(mean(dataK(dataK(:,end)==i,1:end-1))','k','LineWidth',2);
            
        end
        
    else
        for i = 1:n
            HeatMap(dataK(dataK(:,end)==i,1:96))
        end
        
    end
    
end
