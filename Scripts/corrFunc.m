% correlation
function [corrLib,libSize,finalCor] = corrFunc(dataTempLib,kClus,lastTime)
corrLib = [];
libSize = [];

for ii = 1:numel(kClus)
    
    clusTemp = dataTempLib(dataTempLib(:,end)==kClus(ii),:);
    libSize = [libSize;size(clusTemp,1)];
    if size(clusTemp,1)>1
    clusTempMean = mean(clusTemp(:,1:lastTime));
    else
        clusTempMean = clusTemp(1:lastTime);
    end
    
    corrVal = [];
    for jj = 1:size(clusTemp,1)
        corrcoefVal = corrcoef(clusTemp(jj,1:lastTime),clusTempMean);
        corrVal = [corrVal;corrcoefVal(1,2)];
    end
    corrLib = [corrLib;nanmean(corrVal)];
end

finalCor = 0;
for ii = 1:numel(kClus)
finalCor = finalCor + corrLib(ii)*libSize(ii);
end
finalCor = finalCor./sum(libSize);
