%Yeþim Kumbaracý CODING 5 BONUS PART G

load('centroidsfoundpartb.mat');

%Universities sheet imported (excel sheet name: original sheet )

WholeSet = Universities(:,4:23);
WholeArray = table2array(WholeSet);

%Now we need to find distances of points from WholeArray to CentroidsFound,
%according to full values in records in Wholearray. The proximity will be
%based on: 1-finding the closest cluster 2-average of 3 closest points in
%that cluster.

%to scale in this part of bonus, it is assumed that the whole dataset with
%missing values show same behavior with the cleaned dataset. Missing values
%will have again missing values. rest will be scaled.
minall = min(WholeArray); %min of all numeric columns
maxall = max(WholeArray); %max of all numeric columns
ScaledDataWithMissing = zeros(length(WholeArray), size(WholeArray,2)); %to fill normalized table for numeric dataset
%scale 
for j = 1 : size(WholeArray,2)
    for i = 1 : length(WholeArray)
            ScaledDataWithMissing(i, j) = (WholeArray(i, j) - minall(j)) / (maxall(j) - minall(j));
    end
end

%finding nearest centroid to each row in full(1302) row set
nearestCentroitArray = zeros(size(ScaledDataWithMissing, 1), 2) + 2147483647; %fill array with max int
for i = 1 : length(ScaledDataWithMissing)
    for k = 1 : size(centroids, 1)
        clusterDistance = 0;
        for j = 1 : size(ScaledDataWithMissing, 2) 
            if(isnan(ScaledDataWithMissing(i, j)) == false) %is that row and column combination is not blank(nan)
                clusterDistance = clusterDistance + (centroids(k,j) - ScaledDataWithMissing(i, j))^2  ; %distance to that centroid with non-missing attributes
            end
        end
        clusterDistance = sqrt(clusterDistance);
        if(clusterDistance < nearestCentroitArray(i, 2)) 
            nearestCentroitArray(i, 1) = k; %shows which cluster it is closest to
            nearestCentroitArray(i, 2) = clusterDistance; %shows distance to closest cluster's centroid for row i
        end
    end
end

%ClusTable found in part c is loaded
load('ClusTable');
ClustersArray = table2array(ClusTable);
ClusterNoArr = ClustersArray(:,21);
ClusterDataArr = ClustersArray(:,1:20); %cluster num is excluded

%scaling this cluster because there was no need to scale it in part c, only
%concern was to get statistics based on real values of the dataset, did not
%take it from part a because in part c k is used with value 4, new cluster
%assignment was done, since there is randomness in kmeans
ClusterDataArrScaled = zeros(size(ClusterDataArr,1),size(ClusterDataArr,2));


minclusterscaled = min(ClusterDataArr);
maxclusterscaled = max(ClusterDataArr);

for j = 1 : size(ClusterDataArr,2)
    for i = 1 : length(ClusterDataArr)
            ClusterDataArrScaled(i, j) = (ClusterDataArr(i, j) - minclusterscaled(j)) / (maxclusterscaled(j) - minclusterscaled(j));
    end
end

%scaled 206 row data with its cluster number
ScaledDataWithClusterNumber = [ClusterDataArrScaled ClusterNoArr];


%below, first part for every record in ScaledDataWithMissing, second part for nearest 3 record, last part for storing distance and index on ScaledDataWithClusterNumber
nearest3ElementInCluster = zeros(size(ScaledDataWithMissing, 1), 3, 2) + 2147483647; %fill array with max int
for i = 1 : size(ScaledDataWithMissing, 1) %1302
    for k = 1 : size(ScaledDataWithClusterNumber, 1) %206
        tempDistance = 0;
        for j = 1 : size(ScaledDataWithMissing, 2) %20
            if(nearestCentroitArray(i, 1) == ScaledDataWithClusterNumber(k, 21)) %if cluster numbers match, as found in finding closest cluster for loop
                tempDistance = tempDistance + (ScaledDataWithClusterNumber(k, j) - ScaledDataWithMissing(i, j))^2;  %distance between missing and complete(206) set, based on matching attributes
            end
        end
        tempDistance = sqrt(tempDistance);
        
        %check temp distance is lower than any elemnts in nearest3ElementInCluster
        %finding the 3 lowest distance 
        if(tempDistance < nearest3ElementInCluster(i, 1, 2)) 
            nearest3ElementInCluster(i, 1, 1) = k; %row index in ScaledDataWithClusterNumber
            nearest3ElementInCluster(i, 1, 2) = tempDistance;
        elseif(tempDistance < nearest3ElementInCluster(i, 2, 2))
            nearest3ElementInCluster(i, 2, 1) = k;
            nearest3ElementInCluster(i, 2, 2) = tempDistance;
        elseif(tempDistance < nearest3ElementInCluster(i, 3,2))
            nearest3ElementInCluster(i, 3, 1) = k;
            nearest3ElementInCluster(i, 3, 2) = tempDistance;
        end   
    end
    
    %fill missing values
    for j = 1 : size(ScaledDataWithMissing, 2)
        if(isnan(ScaledDataWithMissing(i, j))) %if record is missing, fill it with average of nearest 3 elements
            ScaledDataWithMissing(i, j) = (ScaledDataWithClusterNumber(nearest3ElementInCluster(i, 1, 1), j) ...
                + ScaledDataWithClusterNumber(nearest3ElementInCluster(i, 2, 1), j) ...
                + ScaledDataWithClusterNumber(nearest3ElementInCluster(i, 3, 1), j)) / 3;
        end
    end
end


%end 
