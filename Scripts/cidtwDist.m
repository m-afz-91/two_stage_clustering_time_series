function D2 = cidtwDist(XI,XJ)
D2 = [];
for i = 1:size(XJ,1)
    myDist = dtw(XI, XJ(i,:),'absolute' ,ceil(numel(XI)/8)); % constraint on the number of cluster based on length
    
    % normalize by amplitude
    xI = XI/max(XI);
    xJ = XJ(i,:)/max(XJ(i,:));
    
    CE_XI = sqrt(sum(diff(xI).^2)); % complexity estimate of XI
    CE_XJ = sqrt(sum(diff(xJ).^2)); % complexity estimate of XJ
    
    myDist = myDist * (max(CE_XI,CE_XJ)/min(CE_XI,CE_XJ));
    D2 = [D2;myDist];

end
end