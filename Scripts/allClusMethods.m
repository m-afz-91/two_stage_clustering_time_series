clc;clear;
load('Data\dataset.mat')
profLib = dataset1;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
norm = 2; % normalization option
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% Benchmark clustering 

lowNum = 5; % minimum number of clusters
highNum = 120; % highest number of clusters
intv = 5; % interval for cluster
kRange = lowNum:intv:highNum; % k range
kRange = [kRange,6:9];
kRange = sort(kRange);

lastTime = 96;

% Matrix of CVI (cluster validation index)
evalSOM = [];
evalHC = [];
evalKmeans = [];
evalFCM = [];


%%%%%%%%%%%% Filtering
filtData = []; 
profLibTar = profLib;
profLibCop = profLib;
windowSize = 4;
b = (1/windowSize)*ones(1,windowSize);
a = 1;

for n = 1 : size(profLibTar,1)
    filtData = [filtData;filter(b,a,profLibTar(n,1:lastTime))];
end

profLibTar = []; profLibTar = [filtData,profLibCop(:,end-2:end)];

profLibTar(:,1:windowSize-1) = [];
lastTime = lastTime - (windowSize-1);
dataTemp = profLibTar;


if norm==1
    
    for i = 1:size(dataTemp,1)
        dataTemp(i,1:lastTime) = dataTemp(i,1:lastTime)./max(dataTemp(i,1:lastTime));
    end
end
%%%%%%%%%%%%%

        
for ii = 1:length(kRange)
    
    % Clustering with SOM and save results
    clusResSOM = mySOM(dataTemp(:,1:lastTime),kRange(ii)); % SOM
    clusResSOM = [clusResSOM(:,1:end-1),dataTemp(:,end-2:end-1),clusResSOM(:,end)];
    fileSave = strcat('ClusSOM_',num2str(kRange(ii)),'.mat');
    save(fileSave,'clusResSOM');
    evalSOM = [evalSOM;evalClus(clusResSOM,lastTime,kRange(ii))]; 
    
    % Clustering with Hierarchical Clustering and save results
    clusResHC = myHC(dataTemp(:,1:lastTime),kRange(ii)); % hierarchical clustering
    clusResHC = [clusResHC(:,1:end-1),dataTemp(:,end-2:end-1),clusResHC(:,end)];
    fileSave = strcat('ClusHC_',num2str(kRange(ii)),'.mat');
    save(fileSave,'clusResHC');
    evalHC = [evalHC;evalClus(clusResHC,lastTime,ii)]; 
    
    % Clustering with Kmeans and save results
    clusResKmeans = myKmeans(dataTemp(:,1:lastTime),kRange(ii)); % kmeans
    clusResKmeans = [clusResKmeans(:,1:end-1),dataTemp(:,end-2:end-1),clusResKmeans(:,end)];
    fileSave = strcat('ClusKmeans_',num2str(kRange(ii)),'.mat');
    save(fileSave,'clusResKmeans');
    evalKmeans = [evalKmeans;evalClus(clusResKmeans,lastTime,kRange(ii))]; 
    
    
    ii
    
end
