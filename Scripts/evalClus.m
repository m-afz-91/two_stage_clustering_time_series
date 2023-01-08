function eval = evalClus(profLibTar,lastTime,ii)   


    % Davies Bouldin Indicator (DBI) <MIN>
    evaDB = evalclusters(profLibTar(:,1:lastTime),profLibTar(:,end),'DaviesBouldin');
    % Silhouette (SIL) <MAX>
    evaS = evalclusters(profLibTar(:,1:lastTime),profLibTar(:,end),'silhouette');   
    % CalinskiHarabasz (CH) <MAX>
    evaCH = evalclusters(profLibTar(:,1:lastTime),profLibTar(:,end),'CalinskiHarabasz');   
    % Within cluster sum of square (WCSS) <Elbow>
    WCSSE = myInternalValidation(profLibTar(:,end),profLibTar(:,1:lastTime),ii);
    
    eval = [evaDB.CriterionValues,evaS.CriterionValues,evaCH.CriterionValues, WCSSE,ii];
    
end