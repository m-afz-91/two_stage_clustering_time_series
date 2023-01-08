function dataSOM = mySOM(data,k,HM)

dataSOM=data';
sizeX = k; sizeY = 1;
net = selforgmap([sizeX sizeY]);
net = train(net,dataSOM);
view(net)
y = net(dataSOM);
classes = vec2ind(y);

dataSOM = [data,classes'];



if nargin > 2
    n = length(unique(dataSOM(:,end)));
    CM = jet(n);
    
    if ~HM
        
        for i = 1:n
            figure;
            plot(dataSOM(dataSOM(:,end)==i,1:end-1)','color',CM(i,:),...
                'LineStyle','-','LineWidth',2);
            hold on;
            plot(mean(dataSOM(dataSOM(:,end)==i,1:end-1))','k','LineWidth',2);
        end
        
    else
        for i = 1:n
            HeatMap(dataSOM(dataSOM(:,end)==i,1:96))
        end
        
    end
end