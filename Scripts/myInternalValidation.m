function SSE = myInternalValidation(IDX,data,k)



%%%%%%%%%%%%%%
% SSE and RMSSTD elbow

SSE=[];
sqrtSSE =[];
features = size(data,2);
n = size(data,1);

tempCenterCluster = [];

% for each cluster
for i=1:k
    
    
    temp=find(IDX(:,1)==i);
    
    % data of each cluster
    temp_2=data(temp,:);
    
    for j=1:size(data,2)
        % temp_center: center of each cluster
        temp_center(j)=sum(temp_2(:,j)./size(temp_2,1));
    end
    
    tempCenterCluster = [tempCenterCluster; temp_center];
    
    % finding the SSE for each cluster
    add=0; 
    sqrtAdd=0;
    for j=1:size(temp_2,1)
       temp_3=pdist([temp_2(j,:); temp_center])^2;   
       add = temp_3 + add;
       sqrtAdd = sqrt(temp_3) + sqrtAdd;
    end
    
    SSE(i)=add;
    sqrtSSE(i)=sqrtAdd;
    
end


   SSE = sum(SSE);
   
end
   