% Plot eval clustering
close all;clc;clear
load('Dataset 1\Normalized\eval.mat')

% Davies Bouldin Indicator (DBI) <MIN>
subplot(2,2,1);
plot(evalSOM(:,1),'o-','linewidth',1.5); 
hold on; plot(evalKmeans(:,1),'^-','linewidth',1.5);
hold on; plot(evalHC(:,1),'v-','linewidth',1.5);

% hold on; plot(evalFCM(:,1),'x-','linewidth',1.5);
legend('SOM','Kmeans','HC','FCM')
ylabel('DBI')
set(gca,'XTick',[1;2;3;4;5;6;8;10;12;14;16;18;20;22;24;26;28]);
set(gca,'XTickLabel',[5;6;7;8;9;10;20;30;40;50;60;70;80;90;100;110;120]);
set(gca,'XTickLabelRotation',90)
xlabel('K')
set(gca,'FontName','Times New Roman','FontSize',15)

% Silhouette (SIL) <MAX>
subplot(2,2,2);
plot(evalSOM(1:end,2),'o-','linewidth',1.5); 
hold on; plot(evalKmeans(1:end,2),'^-','linewidth',1.5);
hold on; plot(evalHC(1:end,2),'v-','linewidth',1.5);
hold on; plot(evalFCM(1:end,2),'x-','linewidth',1.5);
legend('SOM','Kmeans','HC','FCM')
ylabel('SIL')
set(gca,'XTick',[1;2;3;4;5;6;8;10;12;14;16;18;20;22;24;26;28]);
set(gca,'XTickLabel',[5;6;7;8;9;10;20;30;40;50;60;70;80;90;100;110;120]);
set(gca,'XTickLabelRotation',90)
xlabel('K')
set(gca,'FontName','Times New Roman','FontSize',15)

% CalinskiHarabasz (CH) <MAX>
subplot(2,2,3);
plot(evalSOM(1:end,3),'o-','linewidth',1.5); 
hold on; plot(evalKmeans(1:end,3),'^-','linewidth',1.5);
hold on; plot(evalHC(1:end,3),'v-','linewidth',1.5);
hold on; plot(evalFCM(1:end,3),'x-','linewidth',1.5);
legend('SOM','Kmeans','HC','FCM')
ylabel('CH')
set(gca,'XTick',[1;2;3;4;5;6;8;10;12;14;16;18;20;22;24;26;28]);
set(gca,'XTickLabel',[5;6;7;8;9;10;20;30;40;50;60;70;80;90;100;110;120]);
set(gca,'XTickLabelRotation',90)
xlabel('K')
set(gca,'FontName','Times New Roman','FontSize',15)

% Within cluster sum of square (WCSS) <Elbow>
subplot(2,2,4);
plot(evalSOM(1:end,4),'o-','linewidth',1.5); 
hold on; plot(evalKmeans(1:end,4),'^-','linewidth',1.5);
hold on; plot(evalHC(1:end,4),'v-','linewidth',1.5);
hold on; plot(evalFCM(1:end,4),'x-','linewidth',1.5);
legend('SOM','Kmeans','HC','FCM')
ylabel('WCSS')
set(gca,'XTick',[1;2;3;4;5;6;8;10;12;14;16;18;20;22;24;26;28]);
set(gca,'XTickLabel',[5;6;7;8;9;10;20;30;40;50;60;70;80;90;100;110;120]);
set(gca,'XTickLabelRotation',90)
xlabel('K')
set(gca,'fontname','times new roman','fontsize',15)

% suptitle('Dataset 1')
