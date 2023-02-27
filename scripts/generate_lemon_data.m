%% USER CHOICE

% RESOLUTION 32, 64, 128, 256
resolution = 64;

%PROBLEM CLASS 1--10
Classid = 8; 

%PROBLEM IN THE CLASS 1--45 (0 TO SELECT ALL)
problem = 27;      

%% GENERATE PROBLEMS

m = resolution^2;
n = m;

%size of the images
ma = resolution;
nb = resolution;

%generate list of images to transport
couples = nchoosek(1:10,2);
if problem>0
    couples = couples(problem,:);
end


%loop over classes
for classid = Classid
    
    %matrix to store results
    data = zeros(size(couples,1)+1,7);

    %row of data where to write (row 1 contains the average)
    data_row = 2;


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

        %% write to file
        
        fileID = fopen(sprintf('../data/lemon_data/class_%d_prob_%d_res_%d.txt',classid,problem(i),resolution),'w+');
        for k=1:length(supply_image)
            fprintf(fileID,'%.16f\n',supply_image(k));
        end
        for k=1:length(demand_image)
            fprintf(fileID,'%.16f',-demand_image(k));
            if k~=length(demand_image)
                fprintf(fileID,'\n');
            end
        end
        fclose(fileID);

        fprintf('Finished class %d, problem %d, resolution %d\n',classid,problem(i),resolution);   
    end
end
