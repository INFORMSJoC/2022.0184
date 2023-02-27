%% SCRIPT TO RUN THE IPM ON THE DOTMARK COLLECTION

%% USER CHOICE

% RESOLUTION 32, 64, 128, 256
resolution = 32;

%PROBLEM CLASS 1--10
Classid = 1; 

%PROBLEM IN THE CLASS 1--45 (0 TO SELECT ALL)
problem = 1;      

%COST FUNCTION 1 (1-NORM), 2 (2-NORM), 3 (INFTY-NORM)
distance = 1;

%% SET UP

m = resolution^2;
n = m;

addpath('../src/IPM');

%% GENERATE COST MATRIX C

%size of the images
ma = resolution;
nb = resolution;

C = zeros(m,n);

for i = 1:m
    for j = 1:n

        %compute row and column indices of the image
        Pir = mod_s(i,ma);
        Pic = ceil(i/ma);
        Pjr = mod_s(j,ma);
        Pjc = ceil(j/ma);
        
        switch distance
            case 1
                C(i,j) = abs(Pir-Pjr)+abs(Pic-Pjc);
            case 2
                C(i,j) = sqrt((Pir-Pjr)^2+(Pic-Pjc)^2); 
            case 3
                C(i,j) = max(abs(Pir-Pjr),abs(Pic-Pjc));
        end

    end
end

%reshape cost matrix into a vector
cost = reshape(C,m*n,1);


%% GENERATE PROBLEMS TO SOLVE

%generate list of images to transport
couples = nchoosek(1:10,2);
if problem>0
    couples = couples(problem,:);
end


%loop over classes
for classid = Classid
    
    %matrix to store results
    data = zeros(size(couples,1),7);

    %row of data where to write 
    data_row = 1;


    %generate path to images of the class
    switch classid
        case 1 
            class = 'WhiteNoise';
        case 2
            class = 'GRFrough';
        case 3
            class = 'GRFmoderate';
        case 4
            class = 'GRFsmooth';
        case 5
            class = 'LogGRF';
        case 6
            class = 'LogitGRF';
        case 7
            class = 'CauchyDensity';
        case 8
            class = 'Shapes';
        case 9
            class = 'ClassicImages';
        case 10
            class = 'MicroscopyImages';
    end
    path_to_images = sprintf('../data/dotmark_images/%s/picture%d_10',class,resolution);


    %loop over problems
    for i = 1:size(couples,1)  
    
        %images are all 512x512, sample them according to resolution
        step = 512/resolution;

        %load image 1
        Im1 = rgb2gray(imread(sprintf('%s%02d.png',path_to_images,couples(i,1))));
        Im1 = Im1(1:step:end,1:step:end);
        Im1 = double(Im1);
        Im1 = Im1/max(max(Im1));

        %load image 2
        Im2 = rgb2gray(imread(sprintf('%s%02d.png',path_to_images,couples(i,2))));
        Im2 = Im2(1:step:end,1:step:end);
        Im2 = double(Im2);
        Im2 = Im2/max(max(Im2));

        %impose same total mass on both images
        if sum(sum(Im1))<sum(sum(Im2))
            Im2 = Im2*sum(sum(Im1))/sum(sum(Im2));
        else
            Im1 = Im1*sum(sum(Im2))/sum(sum(Im1));
        end

        %reshape images as vectors
        supply_image = reshape(Im1,ma*ma,1);
        demand_image = reshape(Im2,nb*nb,1);


        %generate initial subset of nonzero variables
        index = distance_index(C,2.5);

        %generate input struct
        input = struct();
        input.m = m;
        input.print = true;

        %solve with OT_IPM
        output = OT_IPM([supply_image;demand_image],cost,input,index);

        % save results
        data(data_row,1) = output.iter;
        data(data_row,2) = output.CGiter/1000;
        data(data_row,3) = output.time;
        data(data_row,4) = output.maxfill;
        data(data_row,5) = output.iterativeiter;
        data(data_row,6) = output.directiter;
        data(data_row,7) = cost'*output.solution;
        data_row = data_row+1;

        fprintf('\nFinished class %d, problem %d\n',classid,i)
    end

    %create table with results and save it
    T = table(data(:,1),data(:,2),data(:,3),data(:,4),data(:,5),data(:,6),data(:,7));
    T.Properties.VariableNames = {'IPMiter','CGiterx1000','time','maxfill','ititer','diriter','objIPM'};
    writetable(T,sprintf('../results/IPM_results/ResultsClass%dRes%d_Infdist',classid,resolution))   

end



%special modulo function
function y=mod_s(x,m)

    if mod(x,m)==0
        y = m;
    else
        y = mod(x,m);
    end

end

