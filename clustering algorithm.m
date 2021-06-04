%2233732 Yeþim Kumbaracý CLUSTERING Coding #5 Part a & b
%PART A:    Row deletion for missing values is manipulated in excel.


OtelsData = Adgroupreportrevised(:,3:15);
Data = table2array(OtelsData); %answer of Part a.

%PART B
%normalizing the clean (removing missing records) data to apply kmeans
minall = min(Data); %min of all numeric columns
maxall = max(Data); %max of all numeric columns
ScaledData = zeros(length(Data), size(Data,2)); %to fill normalized table for numeric dataset
%scale 
for j = 1 : size(Data,2)
    for i = 1 : length(Data)
            ScaledData(i, j) = (Data(i, j) - minall(j)) / (maxall(j) - minall(j));
    end
end

%applying kmeans for different k values. maxK is decided as 25, since we
%have 206 records, 25 is a sufficient max limit.
maxK = 50;
sse = zeros(maxK, 1); %to fill sse values for different k
for k = 1 : maxK
    [Clusters, centroids] = kmeans(ScaledData, k,'Replicates',70); %kmeans algorithm, replicates needed since algorithm is sensitive to initializations.
    clusterDistanceSums = zeros(k, 1);
    
    for i = 1 : length(ScaledData)
        for j = 1 : size(ScaledData, 2) %columns of scaled data which is 20
            %SSE is the distances' square of points in cluster to cluster
            %centroid, below equation applies the rest of the algoritm.
            clusterDistanceSums(Clusters(i)) = clusterDistanceSums(Clusters(i)) + (centroids(Clusters(i), j) - ScaledData(i, j)) ^ 2;
        end
    end
    
    sse(k) = sum(clusterDistanceSums);
end
  %plot of SSE values with respect to k cluster options.         
  x = linspace(1,maxK,maxK); 
  plot(x, sse);
  xlabel('K values');
  ylabel('Sum of Squared Errors (SSE)');
  title('Error Values according to different k values');
          
 
    
    
    
    
    
    
    

