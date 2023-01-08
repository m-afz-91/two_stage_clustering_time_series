% Merging by fusing similarity metric average
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% OUTPUT:
% dataTempLib2, dataTempSign and idLib 




% Cluster merging based on hierarchical clustering
clc; clear; close all;
load('Results\clusterRes_120_LMH.mat') % load clustered data
load('Results\clusterCenterDBA.mat') % load centroid with DBA (results should be extracted from the previous file)

%%%%%%%%%%%%%%%%%%
targClus = 40; % number of target clusters
threMaxSize = 0.1; % largest cluster size threshold
threVal = [10;12;20;40;45;50]; % threshold value for each group
%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%
% only cluster index as label
% Compile Low, Medium, and High in one matrix
dataTempLib2 = [];
for ii = 1:size(dataTempLib,2)
    cnt = max(dataTempLib{ii}(:,end));
    dataTempLib{ii}(:,end) = cnt*(ii-1) + dataTempLib{ii}(:,end);
    dataTempLib2 = [dataTempLib2;dataTempLib{ii}];
end

dataTemp = dataTempLib2;
dataTemp = sortrows(dataTemp,size(dataTemp,2));

%%%%%
% id index as label
% Compile Low, Medium, and High in one matrix
idLib = [];
for ii = 1:size(dataTempSignLib,2)
    cnt = max(dataTempSignLib{ii}(:,end));
    dataTempSignLib{ii}(:,end) = cnt*(ii-1) + dataTempSignLib{ii}(:,end);
    idLib = [idLib;dataTempSignLib{ii}];
end
idLib = sortrows(idLib,size(idLib,2));
idLib = [idLib,transpose([1:size(idLib,1)])];
% idLib = idLib(:,end-4:end);
%%%%%%



%%%%%%%%%%%%%%%


noClus = length(unique(dataTemp(:,end))); % number of initial clusters
sizeReduce = noClus - targClus;
mSize = round(sqrt(sizeReduce)); % size of subplots
lastTime = size(dataTemp,2) - 1;



cnt = 1;

noClus = length(unique(dataTemp(:,end))); % Number of clusters initialized
% dataTemp = dataTempLib2; % dataTemp has final merged cluster
dataTempOrg = dataTemp; % dataTemp is the benchmark (the number of clusters will be set equal to merged ones)
dtwLib = []; % library of covariance difference


%%%%%%%%%%%%%%
figure(1);
boxplot(max(dataTempNew(:,1:end-1)'))
barQ = quantile(max(dataTempNew(:,1:end-1)'),[0.05 0.25 0.50 0.75 0.95]);
barQ = [0,barQ];


threLib = [];
for ii = 1:numel(barQ)-1
    threLib = [threLib;barQ(ii),barQ(ii+1),threVal(ii)];
end
threLib = [threLib;barQ(end),barQ(end)+1000,threVal(end)];
%%%%%%%%%%%%%%%

stopFlag = false;
ii = 1; % First cluster index
while ~stopFlag
    jj = ii+1; % Second cluster index
    while jj < noClus
        
        
        set1 = dataTempNew(dataTempNew(:,end)==ii,1:lastTime);
        set2 = dataTempNew(dataTempNew(:,end)==jj,1:lastTime);
        
        dtwDist = pdist([set1;set2],@cidtwDist);
        
        
        dtwLib = [dtwLib;dtwDist];
        
        rangeDiff = max(max(set1)-min(set1),max(set2)-min(set2)); % Cluster range (max of both ii and  jj)
        
        
        threIdx = max(find(rangeDiff>threLib(:,1))); % threshold
        thre = threLib(threIdx,3);
        
        if dtwDist < thre
            
            %%%%%%%%%%%%%%%%%%     figure;
            if cnt<=20
                figure(2)
                subplot(4,5,cnt)
            elseif cnt<=40
                figure(3)
                subplot(4,5,cnt-20)
            elseif cnt<=60
                figure(4)
                subplot(4,5,cnt-40)
            elseif cnt<=80
                figure(5)
                subplot(4,5,cnt-60)
            elseif cnt<=100
                figure(6)
                subplot(4,5,cnt-80)
            else
                figure(7)
                subplot(4,5,cnt-100)
            end
            
            
            
            temp1 = dataTemp(dataTemp(:,end)==ii,1:end-1); temp2 = dataTemp(dataTemp(:,end)==jj,1:end-1);
            
            
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
            
            
            
            plot(dataTempNew(ii,1:lastTime-1),'linewidth',2.5,'Color',[0, 0.4470, 0.7410]); hold on; plot(dataTempNew(jj,1:lastTime-1),'linewidth',2.5,'Color',[0.8500, 0.3250, 0.0980])
            
            ylim([0 1.3*max(max(dataTempNew(ii,1:lastTime-1)),max(dataTempNew(jj,1:lastTime-1)))])
            
            xlabel('Time');
            ylabel('Power');
            title(num2str(dtwDist))
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            dataTemp(dataTemp(:,end)==jj,end) = ii; % Merge
            
            idLib(idLib(:,end-1)==jj,end-1) = ii;
            
            % Rename cluster index after merging
            dataRest1 = dataTemp(dataTemp(:,end)<=jj,:);
            dataRestID1 = idLib(idLib(:,end-1)<=jj,:);
            
            dataRest2 = dataTemp(dataTemp(:,end)>jj,:);
            dataRestID2 = idLib(idLib(:,end-1)>jj,:);
            
            dataRest2(:,end) = dataRest2(:,end) - 1;
            dataRestID2(:,end-1) = dataRestID2(:,end-1) - 1;
            
            dataTemp = [dataRest1;dataRest2];
            idLib = [dataRestID1;dataRestID2];
            
            dataTempNew(ii,1:lastTime-1) = (sizeLib(ii)*dataTempNew(ii,1:lastTime-1)+sizeLib(jj)*dataTempNew(jj,1:lastTime-1))/(sizeLib(ii)+sizeLib(jj));
            
            sizeLib(ii) = sizeLib(ii) + sizeLib(jj);
            sizeLib(jj) = [];
        

            % Reduce number of cluster by one
            noClus = noClus - 1;
            cnt = cnt + 1;
            dataTempNew(jj,:) = [];
            dataTempNew(:,end) = 1:size(dataTempNew,1);
            

            
        else % if not merged, add jj by one
            jj = jj + 1;
            
            jj
        end
        
        if jj >= noClus % if all jj visited, add ii by one
            ii = ii +1;
            ii
        end
        
        if ii >= noClus - 1 % if all ii visited, stop
            stopFlag = true;
        end
        
    end
end

dataTempLib2 = dataTemp;
dataTempSign = [dataTemp(:,1:end-1),idLib(:,end-4:end-2),dataTemp(:,end)];

%%%%


%%%

dataTempOrg1 = mySOM(dataTempOrg(:,1:lastTime),noClus); % SOM
dataTempOrg2 = mySOM(dataTempOrg(:,1:lastTime),10); % SOM (k=10)


% Cluster correlation
kClus1 = unique(dataTempLib2(:,end));
[corrLib1,libSize1,finalCor1] = corrFunc(dataTempLib2,kClus1)
kClus2 = unique(dataTempOrg1(:,end));
[corrLib2,libSize2,finalCor2] = corrFunc(dataTempOrg1,kClus2)
kClus3 = unique(dataTempOrg2(:,end));
[corrLib3,libSize3,finalCor3] = corrFunc(dataTempOrg2,kClus3)



% WSEE
evalMerged1 = myInternalValidation(dataTempLib2(:,end),dataTempLib2(:,1:end-1),noClus);
evalNotMerged1 = myInternalValidation(dataTempOrg1(:,end),dataTempOrg1(:,1:end-1),noClus);
evalNotMerged_1 = myInternalValidation(dataTempOrg2(:,end),dataTempOrg2(:,1:end-1),10);
disp(['WSSE proposed: ',num2str(evalMerged1)])
disp(['WSSE benchmark: ',num2str(evalNotMerged1)])
disp(['WSSE benchmark K10: ',num2str(evalNotMerged_1)])

% DB
evalMerged2 = evalclusters(dataTempLib2(:,1:end-1),dataTempLib2(:,end),'DaviesBouldin');
evalNotMerged2 = evalclusters(dataTempOrg1(:,1:end-1),dataTempOrg1(:,end),'DaviesBouldin');
evalNotMerged_2 = evalclusters(dataTempOrg2(:,1:end-1),dataTempOrg2(:,end),'DaviesBouldin');
disp(['DB proposed: ',num2str(evalMerged2.CriterionValues)])
disp(['DB benchmark: ',num2str(evalNotMerged2.CriterionValues)])
disp(['DB benchmark K10: ',num2str(evalNotMerged_2.CriterionValues)])

% silhouette
evalMerged3 = evalclusters(dataTempLib2(:,1:end-1),dataTempLib2(:,end),'silhouette');
evalNotMerged3 = evalclusters(dataTempOrg1(:,1:end-1),dataTempOrg1(:,end),'silhouette');
evalNotMerged_3 = evalclusters(dataTempOrg2(:,1:end-1),dataTempOrg2(:,end),'silhouette');
disp(['Silhouette proposed: ',num2str(evalMerged3.CriterionValues)])
disp(['Silhouette benchmark: ',num2str(evalNotMerged3.CriterionValues)])
disp(['Silhouette benchmark K10: ',num2str(evalNotMerged_3.CriterionValues)])

% CalinskiHarabasz (select the maximum)
evalMerged4 = evalclusters(dataTempLib2(:,1:end-1),dataTempLib2(:,end),'CalinskiHarabasz');
evalNotMerged4 = evalclusters(dataTempOrg1(:,1:end-1),dataTempOrg1(:,end),'CalinskiHarabasz');
evalNotMerged_4 = evalclusters(dataTempOrg2(:,1:end-1),dataTempOrg2(:,end),'CalinskiHarabasz');

disp(['CH proposed: ',num2str(evalMerged4.CriterionValues)])
disp(['CH benchmark: ',num2str(evalNotMerged4.CriterionValues)])
disp(['CH benchmark K10: ',num2str(evalNotMerged_4.CriterionValues)])

% all
evalMerged1 = [evalMerged2,evalMerged2,evalMerged3,evalMerged4];
evalNotMerged1 = [evalNotMerged2,evalNotMerged2,evalNotMerged3,evalNotMerged4];
evalNotMerged2 = [evalNotMerged_2,evalNotMerged_2,evalNotMerged_3,evalNotMerged_4];

