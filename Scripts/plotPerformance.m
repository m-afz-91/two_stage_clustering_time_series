function plotPerformance
clc;clear;close all;

dataChange1 = [];
dataChange2 = [];
dataChange3 = [];

listPlot = {'Dataset 1: SOM','Dataset 1: Kmeans','Dataset 2: SOM','Dataset 2: Kmeans','Dataset 3: SOM','Dataset 3: Kmeans'};
load('EvalCompare_dataset1_Kmeans_w2.mat')
figure(1); subplot(3,2,1)
pltPerfCor(grandFinalCor1,grandFinalCor2,listPlot(1))
figure(2); subplot(3,2,1)
pltPerfSSE(grandEvalMerged,grandEvalNotMerged,listPlot(1))
dataChange1 = [dataChange1;(grandEvalMerged(:,1)-grandEvalNotMerged(:,1))./grandEvalNotMerged(:,1)];



load('EvalCompare_dataset1_SOM_w2.mat')
figure(1); subplot(3,2,2)
pltPerfCor(grandFinalCor1,grandFinalCor2,listPlot(2))
figure(2); subplot(3,2,2)
pltPerfSSE(grandEvalMerged,grandEvalNotMerged,listPlot(2))
dataChange1 = [dataChange1;(grandEvalMerged(:,1)-grandEvalNotMerged(:,1))./grandEvalNotMerged(:,1)];
mean(dataChange1)


load('EvalCompare_dataset2_Kmeans_w2.mat')
figure(1); subplot(3,2,3)
pltPerfCor(grandFinalCor1,grandFinalCor2,listPlot(3))
figure(2); subplot(3,2,3)
pltPerfSSE(grandEvalMerged,grandEvalNotMerged,listPlot(3))
dataChange2 = [dataChange2;(grandEvalMerged(:,1)-grandEvalNotMerged(:,1))./grandEvalNotMerged(:,1)];


load('EvalCompare_dataset2_SOM_w2.mat')
figure(1); subplot(3,2,4)
pltPerfCor(grandFinalCor1,grandFinalCor2,listPlot(4))
figure(2); subplot(3,2,4)
pltPerfSSE(grandEvalMerged,grandEvalNotMerged,listPlot(4))
dataChange2 = [dataChange2;(grandEvalMerged(:,1)-grandEvalNotMerged(:,1))./grandEvalNotMerged(:,1)];
mean(dataChange2)


load('EvalCompare_dataset3_Kmeans_w2.mat')
figure(1); subplot(3,2,5)
pltPerfCor(grandFinalCor1,grandFinalCor2,listPlot(5))
figure(2); subplot(3,2,5)
pltPerfSSE(grandEvalMerged,grandEvalNotMerged,listPlot(5))
dataChange3 = [dataChange3;(grandEvalMerged(:,1)-grandEvalNotMerged(:,1))./grandEvalNotMerged(:,1)];


load('EvalCompare_dataset3_SOM_w2.mat')
figure(1); subplot(3,2,6)
pltPerfCor(grandFinalCor1,grandFinalCor2,listPlot(6))
figure(2); subplot(3,2,6)
pltPerfSSE(grandEvalMerged,grandEvalNotMerged,listPlot(6))
dataChange3 = [dataChange3;(grandEvalMerged(:,1)-grandEvalNotMerged(:,1))./grandEvalNotMerged(:,1)];
mean(dataChange3)


end

function pltPerfCor(grandFinalCor1,grandFinalCor2,strV)

b = bar([grandFinalCor1(:,1),grandFinalCor2(:,1)],1);
b(1).FaceColor = [0 0.4470 0.7410];
b(2).FaceColor = [1 .84 0];
b(1).EdgeColor = 'none';
b(2).EdgeColor = 'none';

ylabel('Average correlation');
xlabel('K (Number of clusters)')
set(gca,'XTick',[1:12])
set(gca,'XTickLabel',[10;20;30;40;10;20;30;40;10;20;30;40])
set(gca,'FontName','Times New Roman','FontSize',15)
legend('Two-stage','Benchmark')
hold on; plot([4.5 4.5],[0 1],'linestyle','--','linewidth',1.5,'color',[.25 .25 .25])
hold on; plot([8.5 8.5],[0 1],'linestyle','--','linewidth',1.5,'color',[.25 .25 .25])
ylim([min(grandFinalCor2(:,1))-.2 max(grandFinalCor1(:,1))+.1])
xlim([0 13])
title(strV)

end

function pltPerfSSE(grandEvalMerged,grandEvalNotMerged,strV)

b= bar([grandEvalMerged(:,1),grandEvalNotMerged(:,1)],1);
ylabel('WCSS (error)');
xlabel('K (Number of clusters)')
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
title(strV)

end