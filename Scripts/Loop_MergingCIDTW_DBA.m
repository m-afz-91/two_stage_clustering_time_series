% Merging by fusing similarity metric average

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% CHANGE dataTemp, energyData, peakData, dataset, enerTemp,
%%%%%%%% and directory for filename (dataset and method)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Cluster merging based on hierarchical clustering
clc; clear; close all;
initClus = [50,70,90];
targClus = [10,20,30,40];


load('dataset.mat')
load('energyData.mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
grandFinalCor1 = []; % correlation cluster merged
grandFinalCor2 = []; % correlation cluster not merged
grandEvalMerged = []; % sse cluster merged
grandEvalNotMerged = []; % sse cluster not merged
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%

threMaxSize = 0.2; % largest cluster size threshold
threMinSize = 0.003; % largest cluster size threshold
%%%%%%%%%%%%%%%%%%

energyData = energyData1;
peakData = peakData1;
dataset = dataset1;
lastTime = 93; % last data index in daily profile (15-minute resolution by default)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



filtData = [];
windowSize = 2; % Filter parameter
b = (1/windowSize)*ones(1,windowSize);
a = 1;
lastTime1=96;

for n = 1 : size(dataset,1)
    filtData = [filtData;filter(b,a,dataset(n,1:lastTime1))];
end

profLibTar = []; profLibTar = [filtData,dataset(:,end-2:end)];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for tt = 1:numel(initClus)
    for ll = 1:numel(targClus)
        
        fileName = strcat('Result\Dataset\Non-normalized\ClusKmeans_',num2str(initClus(tt)),'.mat');
        load(fileName)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        dataTemp = clusResKmeans;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        
        dataTempNew = [];
        
        
        %%%%%%%%%%%%%%%
        
        idLib = sortrows(dataTemp,size(dataTemp,2));
        idLib = [idLib,transpose([1:size(idLib,1)])];
        
        
        noClus = length(unique(dataTemp(:,end))); % number of initial clusters
        sizeReduce = noClus - targClus(ll);
        mSize = round(sqrt(sizeReduce)); % size of subplots
        
        
        sizeLib = [];
        clusLib = {};
        
        %%%%%%%% Find centroid of k-means clustering for 2nd stage
        %%%%%%%% Use DBA for finding the centroid
        
        for i = 1:noClus
            temp = dataTemp(dataTemp(:,end)==i,1:lastTime);
            clusLib{i} = temp;
            
            if size(temp,1)>1
                dataTempNew = [dataTempNew;DBA(temp)];
            else
                dataTempNew = [dataTempNew;temp];
                
            end
            
            sizeLib = [sizeLib,size(temp,1)];
        end
        %%%%%%%%%%%%
        dataTempNew = [dataTempNew,transpose([1:size(dataTempNew,1)])];
        
        
        
        cnt = 1;
        % While number of clusters is higher than the desired value
        while noClus > targClus(ll)
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Metric 1 (MatDist1)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  CI-DTW
            
            dissimilarity = pdist(dataTempNew(:,1:lastTime),@cidtwDist);
            
            %%%%%%%%% Min-max normalization
            minVal = min(dissimilarity);
            maxVal = max(dissimilarity);
            dissimilarity = (dissimilarity - minVal)/(maxVal - minVal);
            %%%%%%%%%%
            
            matDist1 = squareform(dissimilarity); % Matrix of distance between clusters
            matDist1 = triu(matDist1);
            idx = 1e5*tril(ones(size(dataTempNew,1),size(dataTempNew,1)),0);
            matDist1 = max(matDist1,idx);
            
            
            
            %     %%%% Similarity matrix based on metric fusion
            
            matDist = matDist1;
            
            [minDist,distIdx]=min(matDist(:));
            
            
            [row,col] = ind2sub([size(matDist,1), size(matDist,2)],distIdx);
            idx1 = min(row,col);
            idx2 = max(row,col);
            
            %%%%%% Check cluster size (if size higher than threshold, don't merge)
            while ((sizeLib(idx1)+sizeLib(idx2))/sum(sizeLib))>threMaxSize
                matDist(idx1,idx2) = 1e5;
                matDist(idx2,idx1) = 1e5;
                [minDist,distIdx]=min(matDist(:));
                [row,col] = ind2sub([size(matDist,1), size(matDist,2)],distIdx);
                idx1 = min(row,col);
                idx2 = max(row,col);
                
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%
            %     figure;
            if cnt<=20
                figure(1)
                subplot(4,5,cnt)
            elseif cnt<=40
                figure(2)
                subplot(4,5,cnt-20)
            elseif cnt<=60
                figure(3)
                subplot(4,5,cnt-40)
            elseif cnt<=80
                figure(4)
                subplot(4,5,cnt-60)
            elseif cnt<=100
                figure(5)
                subplot(4,5,cnt-80)
            else
                figure(6)
                subplot(4,5,cnt-100)
            end
            
            
            
            temp1 = dataTemp(dataTemp(:,end)==idx1,1:lastTime); temp2 = dataTemp(dataTemp(:,end)==idx2,1:lastTime);
            
            
            if size(temp1,1)<50
                col1 = 0.15;
            elseif size(temp1,1)<200
                col1 = 0.025;
            elseif size(temp1,1)<900
                col1 = 0.015;
            else
                col1 = 0.007;
            end
            
            if size(temp2,1)<50
                col2 = 0.1;
            elseif size(temp2,1)<200
                col2 = 0.030;
            elseif size(temp2,1)<900
                col2 = 0.02;
            else
                col2 = 0.009;
            end
            
            plot1 = plot(temp1');
            for j = 1:size(plot1,1)
                plot1(j).Color=[0, 0.4470, 0.7410, col1];
            end
            
            hold on; plot2 = plot(temp2');
            for j = 1:size(plot2,1)
                plot2(j).Color=[0.8500, 0.3250, 0.0980, col2];
            end
            
            
            
            plot(dataTempNew(idx1,1:lastTime),'linewidth',2.5,'Color',[0, 0.4470, 0.7410]); hold on; plot(dataTempNew(idx2,1:lastTime),'linewidth',2.5,'Color',[0.8500, 0.3250, 0.0980])
            
            ylim([0 1.1*max(max(dataTempNew(idx1,1:lastTime-1)),max(dataTempNew(idx2,1:lastTime-1)))])
            
            xlabel('Time');
            ylabel('Power');
            title(num2str(minDist))
            set(gca,'XTick',[0; 23;  46;  70;  93])
            set(gca,'XTickLabel',[0;6;12;18;24])
            
            
            dataTemp(dataTemp(:,end)==idx2,end)=idx1;
            dataTemp(dataTemp(:,end)>idx2,end) = dataTemp(dataTemp(:,end)>idx2,end) - 1;
            
            dataTempNew(idx1,1:lastTime) = (sizeLib(idx1)*dataTempNew(idx1,1:lastTime)+sizeLib(idx2)*dataTempNew(idx2,1:lastTime))/(sizeLib(idx1)+sizeLib(idx2));
            dataTempNew(idx2,:) = [];
            
            sizeLib(idx1) = sizeLib(idx1) + sizeLib(idx2);
            sizeLib(idx2) = [];
            
            
            
            
            dataTempNew(:,end) = 1:size(dataTempNew,1);
            noClus = noClus - 1;
            cnt = cnt + 1;
            
        end
        
        dataTempLib2 = dataTemp;
        
        plotTimeSeries(dataTempLib2,lastTime)
        dataClusNew = dataTempLib2;
        
        
        
        figure;
        boxplot(energyData(:,1))
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        barQ = quantile(energyData(:,1),[0.05 0.25 0.50 0.75 0.95]);
        barQ = quantile(peakData(:,1),[0.05 0.25 0.50 0.75 0.95]);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%              If normalization is used
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % dataClusNew = []; % new clusters after accounting for magnitude
        % cntClus = 1;
        % for ii = 1:numel(unique(dataTempLib2(:,end)))
        %
        %     idxClus = find(dataTempLib2(:,end)==ii);
        %
        %     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % %     enerTemp = energyData(idxClus,:);
        %     enerTemp = peakData(idxClus,:);
        %     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %     idxLow = enerTemp(enerTemp(:,1)<barQ(2),:);
        %     idxHigh = enerTemp(enerTemp(:,1)>barQ(4),:);
        %     idxMed = enerTemp(enerTemp(:,1)<=barQ(4),:);
        %     idxMed = idxMed(idxMed(:,1)>=barQ(2),:);
        %
        %     if size(idxLow,1)/size(dataset,1)>threMinSize && size(idxMed,1)/size(dataset,1)>threMinSize && size(idxHigh,1)/size(dataset,1)>threMinSize
        %
        %         dataClusNew = [dataClusNew;dataset(idxLow(:,2),:),cntClus*ones(size(idxLow,1),1)];
        %         cntClus = cntClus + 1;
        %
        %         dataClusNew = [dataClusNew;dataset(idxMed(:,2),:),cntClus*ones(size(idxMed,1),1)];
        %         cntClus = cntClus + 1;
        %
        %         dataClusNew = [dataClusNew;dataset(idxHigh(:,2),:),cntClus*ones(size(idxHigh,1),1)];
        %         cntClus = cntClus + 1;
        %
        %     elseif size(idxMed,1)/size(dataset,1)>threMinSize && size(idxHigh,1)/size(dataset,1)>threMinSize
        %
        %         dataClusNew = [dataClusNew;dataset(idxLow(:,2),:),cntClus*ones(size(idxLow,1),1)];
        %         dataClusNew = [dataClusNew;dataset(idxMed(:,2),:),cntClus*ones(size(idxMed,1),1)];
        %         cntClus = cntClus + 1;
        %
        %         dataClusNew = [dataClusNew;dataset(idxHigh(:,2),:),cntClus*ones(size(idxHigh,1),1)];
        %         cntClus = cntClus + 1;
        %
        %     elseif size(idxLow,1)/size(dataset,1)>threMinSize && size(idxMed,1)/size(dataset,1)>threMinSize
        %
        %         dataClusNew = [dataClusNew;dataset(idxLow(:,2),:),cntClus*ones(size(idxLow,1),1)];
        %         cntClus = cntClus + 1;
        %
        %         dataClusNew = [dataClusNew;dataset(idxMed(:,2),:),cntClus*ones(size(idxMed,1),1)];
        %         dataClusNew = [dataClusNew;dataset(idxHigh(:,2),:),cntClus*ones(size(idxHigh,1),1)];
        %         cntClus = cntClus + 1;
        %     elseif size(idxLow,1)/size(dataset,1)>threMinSize && size(idxHigh,1)/size(dataset,1)>threMinSize
        %         dataClusNew = [dataClusNew;dataset(idxLow(:,2),:),cntClus*ones(size(idxLow,1),1)];
        %         dataClusNew = [dataClusNew;dataset(idxMed(:,2),:),cntClus*ones(size(idxMed,1),1)];
        %         cntClus = cntClus + 1;
        %         dataClusNew = [dataClusNew;dataset(idxHigh(:,2),:),cntClus*ones(size(idxHigh,1),1)];
        %         cntClus = cntClus + 1;
        %
        %     elseif size(idxLow,1)/size(dataset,1)>threMinSize
        %         dataClusNew = [dataClusNew;dataset(idxLow(:,2),:),cntClus*ones(size(idxLow,1),1)];
        %         cntClus = cntClus + 1;
        %         dataClusNew = [dataClusNew;dataset(idxMed(:,2),:),cntClus*ones(size(idxMed,1),1)];
        %         dataClusNew = [dataClusNew;dataset(idxHigh(:,2),:),cntClus*ones(size(idxHigh,1),1)];
        %         cntClus = cntClus + 1;
        %
        %     elseif size(idxMed,1)/size(dataset,1)>threMinSize
        %         dataClusNew = [dataClusNew;dataset(idxLow(:,2),:),cntClus*ones(size(idxLow,1),1)];
        %         cntClus = cntClus + 1;
        %         dataClusNew = [dataClusNew;dataset(idxMed(:,2),:),cntClus*ones(size(idxMed,1),1)];
        %         dataClusNew = [dataClusNew;dataset(idxHigh(:,2),:),cntClus*ones(size(idxHigh,1),1)];
        %         cntClus = cntClus + 1;
        %
        %
        %     elseif size(idxHigh,1)/size(dataset,1)>threMinSize
        %         dataClusNew = [dataClusNew;dataset(idxLow(:,2),:),cntClus*ones(size(idxLow,1),1)];
        %         dataClusNew = [dataClusNew;dataset(idxMed(:,2),:),cntClus*ones(size(idxMed,1),1)];
        %         cntClus = cntClus + 1;
        %         dataClusNew = [dataClusNew;dataset(idxHigh(:,2),:),cntClus*ones(size(idxHigh,1),1)];
        %         cntClus = cntClus + 1;
        %
        %     else
        %         dataClusNew = [dataClusNew;dataset(idxLow(:,2),:),cntClus*ones(size(idxLow,1),1)];
        %         dataClusNew = [dataClusNew;dataset(idxMed(:,2),:),cntClus*ones(size(idxMed,1),1)];
        %         dataClusNew = [dataClusNew;dataset(idxHigh(:,2),:),cntClus*ones(size(idxHigh,1),1)];
        %         cntClus = cntClus + 1;
        %
        %     end
        %
        %
        %
        % end
        %
        %
        % plotTimeSeries(dataClusNew,96)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        noClus2 = numel(unique(dataClusNew(:,end)));
        
        
        dataTempOrg1 = mySOM(dataset(:,1:lastTime),noClus2); % SOM
        
        % Cluster correlation
        kClus1 = unique(dataClusNew(:,end));
        [corrLib1,libSize1,finalCor1] = corrFunc(dataClusNew,kClus1,lastTime)
        kClus2 = unique(dataTempOrg1(:,end));
        [corrLib2,libSize2,finalCor2] = corrFunc(dataTempOrg1,kClus2,lastTime)
        
        grandFinalCor1 = [grandFinalCor1;finalCor1,targClus(ll),initClus(tt)];
        grandFinalCor2 = [grandFinalCor2;finalCor2,targClus(ll),initClus(tt)];
        
        disp(['Correlation proposed: ',num2str(finalCor1)])
        disp(['Correlation benchmark: ',num2str(finalCor2)])
        
        
        % WSEE
        evalMerged1 = myInternalValidation(dataClusNew(:,end),dataClusNew(:,1:lastTime),numel(kClus1));
        
        %
        evalNotMerged1 = myInternalValidation(dataTempOrg1(:,end),profLibTar(:,1:lastTime),numel(kClus2));
        
        grandEvalMerged = [grandEvalMerged;evalMerged1,targClus(ll),initClus(tt)];
        grandEvalNotMerged = [grandEvalNotMerged;evalNotMerged1,targClus(ll),initClus(tt)];
        
        disp(['WSSE proposed: ',num2str(evalMerged1)])
        disp(['WSSE benchmark: ',num2str(evalNotMerged1)])
        
        
    end
    
end


figure;
b = bar([grandFinalCor1(:,1),grandFinalCor2(:,1)],1)
b(1).FaceColor = [0 0.4470 0.7410];
b(2).FaceColor = [1 .84 0];
b(1).EdgeColor = 'none';
b(2).EdgeColor = 'none';

ylabel('Average weighted correlation');
xlabel('K')
set(gca,'XTick',[1:12])
set(gca,'XTickLabel',[10;20;30;40;10;20;30;40;10;20;30;40])
set(gca,'FontName','Times New Roman','FontSize',15)
legend('Two-stage','Benchmark')
hold on; plot([4.5 4.5],[0 1],'linestyle','--','linewidth',1.5,'color',[.25 .25 .25])
hold on; plot([8.5 8.5],[0 1],'linestyle','--','linewidth',1.5,'color',[.25 .25 .25])
ylim([min(grandFinalCor2(:,1))-.2 max(grandFinalCor1(:,1))+.1])
xlim([0 13])

figure;
b= bar([grandEvalMerged(:,1),grandEvalNotMerged(:,1)],1)
ylabel('WSSE (error)');
xlabel('K')
set(gca,'XTick',[1:12])
set(gca,'XTickLabel',[10;20;30;40;10;20;30;40;10;20;30;40])
set(gca,'FontName','Times New Roman','FontSize',15)
legend('Two-stage','Benchmark')
b(1).FaceColor = [0 0.4470 0.7410];
b(2).FaceColor = [1 .84 0];
b(1).EdgeColor = 'none';
b(2).EdgeColor = 'none';
hold on; plot([4.5 4.5],[0 10000000],'linestyle','--','linewidth',1.5,'color',[.25 .25 .25])
hold on; plot([8.5 8.5],[0 10000000],'linestyle','--','linewidth',1.5,'color',[.25 .25 .25])
ylim([0 1.2*max(grandEvalNotMerged(:,1))])
xlim([0 13])