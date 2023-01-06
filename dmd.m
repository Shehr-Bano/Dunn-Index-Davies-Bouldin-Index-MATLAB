close all
clear
clc

%% Load file
prompt='Choose the data, Press 1 for Iris and 2 for Glass ';
choice=input(prompt);
if choice==1
    load fisheriris;
    X=meas;
    Y=categorical(species);
elseif choice==2
    [file,path] = uigetfile('*.*');
    filepath=strcat(path,file);
    Data=load(filepath);
    X=Data(:,1:end-1);
    Y=categorical(Data(:,end));
else
    disp('INVALID OPTION');
end

%% Notes
fprintf('Important variables are saved in: \n');
fprintf('Data with class in my_table \n');
fprintf('Data without class in data_table\n');
fprintf('Class in class\n');
fprintf('Data of each cluster in cluster_number \n');

%% K means clustering done in the veriavle k_means_cluster
prompt2='\nEnter the value of k';
k=input(prompt2);
if k<2
fprintf('Invalid value chosen for k');    
else
end

[clus,yin]= kmeans(X,k);

datacon=[X clus];
[~,c]=size(datacon);
for i=1:c
my_table(:,i)=table(datacon(:,i)); 
end
data_table=my_table(:,1:end-1);
class=my_table(:,end);
[G,no_of_groups] = findgroups(my_table(:,end));
Tc = splitapply( @(varargin) varargin, my_table, G);

%% Creating clusters
for i=1:k
v = genvarname(['cluster%d',i]);
value=cell2mat(Tc(i,1:end));
eval([v ' = value;'])
end

%% DB Index calculation
e= evalclusters(X,'kmeans','DaviesBouldin','kList',1:k);
fprintf('Davies Bouldin Index for respective values of k is\n');
disp(e.InspectedK);
disp(e.CriterionValues);
fprintf('Accorting to Davies Bouldin evaluation, Optimim value of k is');
disp(e.OptimalK);

%% Saving Dunn Index in the variable DI
inn= length(unique(G));
distM = squareform(pdist(X,'euclidean'));
ind = G;
denominator=[];
for i2=1:inn
    indi=find(ind==i2);
    indj=find(ind~=i2);
    x=indi;
    y=indj;
    temp=distM(x,y);
    denominator=[denominator;temp(:)];
end
num=min(min(denominator)); 
neg_obs=zeros(size(distM,1),size(distM,2));
for ix=1:inn
    indxs=find(ind==ix);
    neg_obs(indxs,indxs)=1;
end
dem=neg_obs.*distM;
dem=max(max(dem));
DI=num/dem;
fprintf('Dunn Index for this data is ');
disp(DI);

%% clearing variables
clear c datacon dem denominator distM G i i2 ind indi indj indxs 
clear choice inn ix neg_obs num prompt prompt2 temp v value x y yin