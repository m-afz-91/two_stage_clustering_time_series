function dataH = myHC(data,k,HM)


%%%%%
% dissimilarity = pdist(data,@emdDist);
% Z = linkage(dissimilarity,'weighted');
%%%%%


%%%%%
Z = linkage(data,'ward','euclidean');
%%%%%

c = cluster(Z,'maxclust',k);
dataH = [data,c];

if nargin > 2
    n = length(unique(dataH(:,end)));
    CM = jet(n);
    
    %evalH = perfMet (dataH);
    
    if ~HM
        for i = 1:n
            figure;
            plot(dataH(dataH(:,end)==i,1:end-1)','color',CM(i,:),...
                'LineStyle','-','LineWidth',2);
            hold on;
            plot(mean(dataH(dataH(:,end)==i,1:end-1))','k','LineWidth',2);
        end
        
    else
        for i = 1:n
            HeatMap(dataH(dataH(:,end)==i,1:96))
        end
        
    end
end