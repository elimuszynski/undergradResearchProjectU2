%ROI_OMTC_TFM: computes and plots the TFM-OMTC data for individual beads

%USER INPUT 1/8:OMTC data array name files

DU145_ARRAY = ["DH_DU145_1kpa_50kPa_TFM_OMTC/DU145_1kPa_TFM",...
               "DZ_DU145_3kPa_12kPa_TFM_OMTC/TFM_DU145_3kPa",...
               "DZ_DU145_3kPa_12kPa_TFM_OMTC/TFM_DU145_12kPa",...
               "DX_OMTC_DU145_22RV1_LNCaP_25kPa_2022_03_21/DX_TFM_DU145_25kPa"]
              
             
LNCaP_ARRAY = [ "DF_LNCaP_12kPa_1kPa_TFM_OMTC/TFM_LNCaP_1kPa",...
                "DJ_LNCaP_3kPa_50kPa_TFM_OMTC/TFM_LNCaP_3kPa",...
                "DF_LNCaP_12kPa_1kPa_TFM_OMTC/TFM_LNCaP_12kPa",...
                "DX_OMTC_DU145_22RV1_LNCaP_25kPa_2022_03_21/DX_TFM_LNCaP_25kPa"]
                  
PC3_ARRAY = [ "DP_OMTC_PC3_0.36_0.15_0.1/TFM_PC3_1kPa",...
              "DP_OMTC_PC3_0.36_0.15_0.1/TFM_PC3_3kPa",...
              "DP_OMTC_PC3_0.36_0.15_0.1/TFM_PC3_12kPa",...
              "DT_OMTC_PC3_0.5_0.85_130322/DT_TFM_PC3_25kPa"]

ttRV1_ARRAY = [ "DC_OMTC_TFM_22RV1_0.15_0/TFM_22RV1_12kPa",...
                "DC_OMTC_TFM_22RV1_0.15_0/TFM_22RV1_12kPa",...
                "DC_OMTC_TFM_22RV1_0.15_0/TFM_22RV1_12kPa",...
                "DX_OMTC_DU145_22RV1_LNCaP_25kPa_2022_03_21/DX_TFM_22RV1_25kPa",...
                "DL_22RV1_3_50_Du145_50_PC3_50/22RV1_TFM2_50kPa"]

FIFTY_OMTC_ARRAY =["DJ_LNCaP_3kPa_50kPa_TFM_OMTC/TFM_LNCaP_50kPa",...
                   "DL_22RV1_3_50_Du145_50_PC3_50/DU145_TFM2_50kPa",...
                   "DT_OMTC_PC3_0.5_0.85_130322/DT_TFM_PC3_50kPa"]
               
THREE_OMTC_ARRAY =  ["DJ_LNCaP_3kPa_50kPa_TFM_OMTC/TFM_LNCaP_3kPa",...
                   "DZ_DU145_3kPa_12kPa_TFM_OMTC/TFM_DU145_3kPa",...
                   "DP_OMTC_PC3_0.36_0.15_0.1/TFM_PC3_3kPa"]              
             
%USER INPUT 2/8:TFM data array name files            

DU145_TFM = ["DH_DU145_1kPa",...
             "DZ_DU145_3kPa",...
             "TFM_DU145_12kPa",...   
             "DX_DU145_25kPa"]
    
             
             
LNCaP_TFM = [ "DF_LNCaP_1kPa",...
              "DJ_LNCaP_3kPa",... 
              "DF_LNCaP_12kPa",...
              "DX_LNCaP_25kPa"]

                   
PC3_TFM = [ "DP_PC3_1kPa",...
            "DP_PC3_3kPa",...
            "DP_PC3_12kPa",...
            "DT_PC3_25kPa"]

ttRV1_TFM = [ "DC_22RV1_12kPa",...
              "DC_22RV1_12kPa",...
              "DC_22RV1_12kPa",...
              "DX_22RV1_25kPa",...
              "DL_22RV1_50kPa"]
            
FIFTY_TFM_ARRAY =["DJ_LNCaP_50kPa",...
                  "DL_DU145_50kPa",...
                  "DT_PC3_50kPa"]
              
THREE_TFM_ARRAY =["DJ_LNCaP_3kPa",... 
                  "DZ_DU145_3kPa",...
                  "DP_PC3_3kPa"]              
wantRMST = 1 
wantStrainEnergy = 2

TFM_ATTRIBUTE =1; % USER INPUT 3/8:to calculate ROI RMST input 1, Strain Energy input2

EXPAND_MARGIN = 50;% USER INPUT 4/8:Number of pixels by which we want to expand ROI

% USER INPUT 5/8: selects which OMTC and TFM arrays to plot
MEGA_OMTC= {DU145_ARRAY}
MEGA_TFM = {DU145_TFM}

%USER INPUT 6/8: directory name where OMTC results are located
CONDITION_OMTC_FINAL = "/Volumes/Seagate/OMTC/experiments/"
%USER INPUT 7/8: directory name where TFM results are located
CONDITION_TFM_FINAL = "/Volumes/Seagate/OMTC/TFM_results/"
               
%USER INPUT 8/8: limit on OMTC attribute
G_limit = 3000

f1 = figure();
Ax(1) = axes(f1); 

colors = ['b','c','g','r','m']

labels = ['1  kPa'; '3  kPa'; '12 kPa'; '25 kPa' ;'50 kPa'];  
%% AVERAGES STRAIN ENERGY AND CORRESPONDING OMTC ATTRIBUTE
for j= 1:length(MEGA_OMTC)
    
    label_array = [];
    OMTC_array = [];
    mean_strain_array =[];
    condition_array= [];
    err_array= [];
    err_strain_array=[];
    filtered_attribute_column = [];
    strain_column=[];

    OMTC_column = MEGA_OMTC{j};
    TFM_column = MEGA_TFM{j};
    
    % averages OMTC data for given cell type on given modulus
    for i = 1:length(OMTC_column)
            
            G =[];
            OMTC_FOLDER = OMTC_column{i};
            TFM_FOLDER = TFM_column{i};

            [conditionStrainArray,conditionModulusArray] = ROISEAM (OMTC_FOLDER, TFM_FOLDER, EXPAND_MARGIN, TFM_ATTRIBUTE,G_limit,CONDITION_OMTC_FINAL,CONDITION_TFM_FINAL,factor)
          
            marker= ['o'];
            color = colors(i)
            label = labels(i)


            SE_nanAM = conditionStrainArray(~isnan(conditionModulusArray));
            AM_nanAM = conditionModulusArray(~isnan(conditionModulusArray));

            SE = SE_nanAM(~isnan(SE_nanAM));
            AM = AM_nanAM(~isnan(SE_nanAM));
            G = [i*ones(size(SE))];
            
            
            switch TFM_ATTRIBUTE
                case 1
                    TFMlabel = 'RMST (Pa)'
                    factor=1;
                    xplacement = 275
                    yplacement = 2750
                    location = 'southeast'
                case 2
                    TFMlabel ='Strain Energy (pJ)'
                    factor=1000000000000;
                    xplacement = 0.15
                    yplacement = 2400
                    location = 'east'
            end
      
            scatterplot = gscatter(SE,  AM, G, color, marker, 10,'doleg',TFMlabel,'Apparent Modulus');

%            to fill markers
            for n = 1:length(scatterplot)
                set(scatterplot(n), 'MarkerFaceColor', colors(i));
            end  
            
%           LINE OF BEST FIT  
            Fit1 = polyfit(SE,AM,1);
            rl(i) = refline(Fit1(1),Fit1(2));
            rl(i).Color = color;
            R=corrcoef(SE,AM);
            r=['',num2str(R(1,2))]
            R2 = R(2)^2;
            r2=['',num2str(R2)]
            eq = sprintf('R^2 = %.3f', R2);
            h=text(xplacement, yplacement-i*100, eq)
            set(h, 'Color',color)
         
            hold on
            leg = legend( '1 kPa','','3 kPa','', '12 kPa', '','25 kPa','', '50 kPa','','Location',location);
            title (leg, 'Substrate Stiffness' );
            ylim([0,3000]);
        end

end
%%  main function : returns  conditionStrainArray and  conditionModulusArray
function [conditionStrainArray,conditionModulusArray] = ROISEAM (OMTC_FOLDER, TFM_FOLDER,EXPAND_MARGIN, TFM_ATTRIBUTE,G_limit,CONDITION_OMTC_FINAL,CONDITION_TFM_FINAL,factor)
    %TFM FOLDER/OMTC_FOLDER PAIR (same condition)
    %(each pair shares the same (1)results.mat and (2)apparent modulus excel)
    
    
    ORIGINAL_SIZE = 512;   % Number of pixels in image before ANY crop
    conditionStrainArray=[];
    conditionModulusArray =[];
    
    [WINDOW_SIZE, DEDRIFTED_SIZE, ps1, step_size] = importResultsMatValues(TFM_FOLDER,CONDITION_TFM_FINAL); %import results.mat values
    total_crop = calculateCropOffset(ORIGINAL_SIZE, DEDRIFTED_SIZE, WINDOW_SIZE); %calculate crop offset

    %create struc conataining filenames of all ROICoords tables of condition
    OMTC_CONDITION_DIR = CONDITION_OMTC_FINAL + OMTC_FOLDER ;
    ROICoordsStruc = dir(OMTC_CONDITION_DIR + "/**/RoiCoords.txt");
    ROIFilesArray= struct2cell(ROICoordsStruc)';
    
    %Dictionary is used so that apparent modulus and strain energy at given
    %index of conditionStrainArray/conditionModulusArray always share same series and bead
    [Dictionary, KeySet] = CreateApparentModulusDictionary(OMTC_CONDITION_DIR,OMTC_FOLDER) 
    
    %Each iteration (i) is one series 
    %(each serie shares the same (1) ROI Coords file and (2)traction/displacement arrays):
    for i = 1:length(ROICoordsStruc)     
        RoiCoordFileString = strcat(ROICoordsStruc(i).folder,"/", ROICoordsStruc(i).name);
        RoiCoordTable = readtable(RoiCoordFileString);       
     
        [u,v,tx,ty,series] = importDispTracArrays(TFM_FOLDER, RoiCoordFileString, OMTC_CONDITION_DIR,CONDITION_TFM_FINAL);

        [series_strain_array, series_AM_array] = ExtractRoiValues(RoiCoordTable, EXPAND_MARGIN ,total_crop, u, v, tx, ty, ps1, step_size,series,Dictionary, KeySet, TFM_ATTRIBUTE,G_limit,factor);
        conditionStrainArray = [conditionStrainArray; series_strain_array];
        conditionModulusArray = [conditionModulusArray; series_AM_array];
    end
end

%% SUBFUNCTIONS

% imports results.mat values
function [WINDOW_SIZE, DEDRIFTED_SIZE, ps1, step_size] = importResultsMatValues(TFM_FOLDER,CONDITION_TFM_FINAL)

    TFM_CONDITION_DIR = CONDITION_TFM_FINAL + TFM_FOLDER;
    resultsFileString = TFM_CONDITION_DIR +'/results.mat';
    resultsDirectory = dir(resultsFileString);
    resultsMat = load(resultsFileString);

    WINDOW_SIZE = (resultsMat.window_size);  % Number of pixels in traction window
    DEDRIFTED_SIZE_ARRAY = (resultsMat.im1_shape); % Number of pixels in image after Image_J dedrift 
    DEDRIFTED_SIZE = DEDRIFTED_SIZE_ARRAY(1);
    ps1 = (resultsMat.ps1);                  % Pixel size in microns
    step_size =(resultsMat.step_size_ppw);   % How many pixels window is moved per displacement calculation (e.g. 2 pixels)

end

%calculates the total crop offset
function total_crop = calculateCropOffset(ORIGINAL_SIZE, DEDRIFTED_SIZE, WINDOW_SIZE)

	dedrift_crop = (ORIGINAL_SIZE - DEDRIFTED_SIZE) / 2;       
	piv_crop = WINDOW_SIZE / 2;
 
	size_of_piv = ORIGINAL_SIZE - (dedrift_crop + piv_crop) * 2;
	ten_percent_crop = 0.10 * size_of_piv;
 
	total_crop = dedrift_crop + piv_crop + ten_percent_crop;
	
end

%imports u, v, tx, ty for given series
function [u,v,tx,ty,series] = importDispTracArrays(TFM_FOLDER, RoiCoordFileString, OMTC_CONDITION_DIR,CONDITION_TFM_FINAL)
    %find series number
    TFM_CONDITION_DIR = CONDITION_TFM_FINAL + TFM_FOLDER;
    series=parseOutSeries(RoiCoordFileString,OMTC_CONDITION_DIR);
    
    % IMPORT displacment and traction arrays for this series (seires i in loop)   
    TFMSeriesFolder = TFM_CONDITION_DIR + '/Series' + series;
    
    TFMDisplacementString = TFMSeriesFolder + '/Displacement/d_arrays_corrected/trim_displacement_mat001.mat';
    TFMTractionString = TFMSeriesFolder +'/Traction/t_arrays_corrected/trim_traction_mat001.mat';
    
    trim_displacement_mat001 = load(TFMDisplacementString);
    trim_traction_mat001 = load (TFMTractionString);
    
    u = (trim_displacement_mat001.u_filt);
    v = (trim_displacement_mat001.v_filt);
    tx = (trim_traction_mat001.tzx_filt);
    ty = (trim_traction_mat001.tzy);
end

%This function returns an array of strain energies of exactly the same length as the rois array, where the elements correspond to each other
function [strain_array, AM_array] = ExtractRoiValues(roi_array,EXPAND_MARGIN,crop_offset, u, v, tx, ty, ps1, step_size,series, Dictionary,KeySet, TFM_ATTRIBUTE,G_limit,factor)
	
    strain_energies_per_roi = [];
    apparent_modulus_per_roi = [];
	%Each iteration (j) is one bead 
    for j = 1:4:height(roi_array);
        
       % ROIs in RoiCoordTable are given in 4 lines per bead:
       % 1 - x,y of top left corner
       % 2 - x,y of top right corner
       % 3 - x,y of bottom right corner
       % 4 - x,y of bottom left corner
        roix1 = roi_array{j,2};      % pixel coord of ROI's left side
        roix2 = roi_array{j+1,2};    % pixel coord of ROI's right side
        roiy3 = roi_array{j,3};      % pixel coord of ROI's top side
        roiy4 = roi_array{j+2,3};    % pixel coord of ROI's bottom side
       
        
        beadUnparsed = roi_array{j,1};
        beadString = string(beadUnparsed);
        bead = parseOutAMKey (beadString, "bead ");
        SEKey = series+"."+bead;
        TF = isKey(Dictionary, SEKey);
        if TF == 1 && Dictionary(SEKey) < G_limit;
           Apparent_modulus = Dictionary(SEKey);
        else
            Apparent_modulus = NaN;
        end
        expandedRoi =calculateExpandedROIs(roix1,roix2,roiy3,roiy4,EXPAND_MARGIN);
        strain_energy_or_RMST = ExtractSingleRoiStrainEnergy(expandedRoi,crop_offset, u, v, tx, ty, ps1, step_size,TFM_ATTRIBUTE,factor);
        strain_energies_per_roi  = [strain_energies_per_roi; strain_energy_or_RMST];
        apparent_modulus_per_roi = [apparent_modulus_per_roi; Apparent_modulus];
        
    end
     strain_array = strain_energies_per_roi;
     AM_array = apparent_modulus_per_roi;
end

%extracts strain energy from a single Roi
function strain_energy_or_RMST = ExtractSingleRoiStrainEnergy(expandedRoi,crop_offset, u, v, tx, ty,  ps1_um, step_size,TFM_ATTRIBUTE,factor) 
    maxIndex=length(u);
   
	tileCoords = FindTileCoords(expandedRoi , crop_offset, step_size, maxIndex);
    
    if isempty(tileCoords)
        strain_energy_or_RMST = NaN;
        return
    else    
         xCoord = tileCoords(:,1);
         yCoord = tileCoords(:,2);
        
        switch TFM_ATTRIBUTE
            case 1
                STs=[]
                 for ii = 1:length(tileCoords) 
                    tileCoord = tileCoords(ii,:); % Each tileCoord is an array holding two numbers: [x, y]


                    xCoord = tileCoord(1);
                    yCoord = tileCoord(2);

                    uValue = u(xCoord,yCoord);		% uValue is a single value (scalar) from the u-array
                    vValue = v(xCoord,yCoord);		%  v…
                    txValue = tx(xCoord,yCoord);     % tx…
                    tyValue = ty(xCoord,yCoord); 	% ty…

                
                    ST = (tx(xCoord,yCoord)*tx(xCoord,yCoord)+ty(xCoord,yCoord)*ty(xCoord,yCoord)); %ST is an array
                    STs=[STs, ST];
                 end
                MST = mean(STs, 'all'); %MST is a single value
                RMST = sqrt(MST);
                strain_energy_or_RMST = RMST;
                
            case 2
                ps1_meters = ps1_um * 0.000001;
                ps2 = ps1_meters * double(step_size);
                energy_points = []

            
                for ii = 1:length(tileCoords) 
                    tileCoord = tileCoords(ii,:); % Each tileCoord is an array holding two numbers: [x, y]


                    xCoord = tileCoord(1);
                    yCoord = tileCoord(2);

                    uValue = u(xCoord,yCoord);		% uValue is a single value (scalar) from the u-array
                    vValue = v(xCoord,yCoord);		%  v…
                    txValue = tx(xCoord,yCoord);     % tx…
                    tyValue = ty(xCoord,yCoord); 	% ty…

                    energy_point = 0.5 * ps2*ps2 * (txValue * uValue * ps1_meters + tyValue * vValue * ps1_meters);
                    energy_points = [energy_points, energy_point];
                end
                   
%              energy_points = 0.5 * ps2*ps2 * (tx(xCoord,yCoord) * u(xCoord,yCoord) * ps1_meters + ty(xCoord,yCoord)  * v(xCoord,yCoord) * ps1_meters);
% 
            background = prctile(energy_points,20);
            energy_points = energy_points-background;
            strain_energy = sum(energy_points, 'all');
            strain_energy_or_RMST = strain_energy*factor;
         
            
         end
        
    end
end


%This function finds the list of tile coordinates given an ROI.

function Coords = FindTileCoords(expandedRoi, crop_offset, step_size,maxIndex);
	Left   = PixelToTileIndex(expandedRoi(1), crop_offset, step_size,maxIndex); 
	Right  = PixelToTileIndex(expandedRoi(2), crop_offset, step_size,maxIndex);
	Top    = PixelToTileIndex(expandedRoi(3), crop_offset, step_size,maxIndex);
	Bottom = PixelToTileIndex(expandedRoi(4), crop_offset, step_size,maxIndex);
    
    Coords = [];
    
    if Left == 999 | Right == 999 | Top == 999 | Bottom == 999
        
        return;
     
    else  
        
        for x = Left:Right                        % In our example, this would be from index x = 1 to 3 INCLUSIVE (note <=)
                for y = Top:Bottom             % Our example, y = 1 to 3 INCLUSIVE
                    Coords=[Coords; x y ];      % Matlab syntax to create an array of two integers ???
                end 
        end
    end        

end

%Convert a pixel coordinate to tile index (works for both x and y, assuming tiles are square)
function tileCoord = PixelToTileIndex(pixel, crop_offset, step_size, maxIndex)
	tileCoord = ceil((pixel - crop_offset) / step_size)    % ceiling means to “round up” because Matlab indexes are one-based

% %include exception throw and catch for expanded ROIs out of (green) bounds
    if tileCoord < 1 | tileCoord > maxIndex
 		tileCoord = 999;	% protect from array out-of-bounds
    end
end

%creates apparent modulus dictionary, where values = apparent modulus and
%keys are series. bead
function [AMDictionary, keySet] = CreateApparentModulusDictionary(OMTC_CONDITION_DIR,OMTC_FOLDER) 
    condition = parse_out_condition(OMTC_FOLDER);
    AMTableString = OMTC_CONDITION_DIR + "/"+ condition + "_amplitude/" + condition+ "_SUMMARY_STATS_AMPLITUDE.xlsx";
    %AMTableString = strcat(AMTableStruc(1).folder,"/", AMTableStruc(1).name)
    AMTable = readtable(AMTableString);

    keySet = [];
    valueSet = [];
    
	for ii = 1:height(AMTable) 
        
		%Row = table(ii)
        
		SerieUnparsed = AMTable(ii,1);
        seriesCell=table2cell(SerieUnparsed);
        seriesString = string(seriesCell);
        Series = parseOutAMKey(seriesString,"_");
        
        BeadUnparsed = AMTable(ii,2);
        beadCell=table2cell(BeadUnparsed);
        beadString = string(beadCell);
        Bead = parseOutAMKey(beadString,"_");
        
		AMKey = Series + '. ' + Bead;   % series_1.bead_7
        keySet = [keySet AMKey];
        valueSet =[valueSet table2cell(AMTable(ii,4))];%Apparent Modulus
		
    end
  
    AMDictionary = containers.Map (keySet,valueSet);
end

%will expand the ROI coordinates given desired EXPAND_MARGIN
function expandedRoi = calculateExpandedROIs(roix1,roix2,roiy3,roiy4,EXPAND_MARGIN)
    expandedRoi = [
		roix1 - EXPAND_MARGIN,   % x-coord of Left side of ROI bounding box
		roix2 + EXPAND_MARGIN,   % x-coord of Right
		roiy3 - EXPAND_MARGIN,   % y-coord of Top side of ROI bounding box
		roiy4 + EXPAND_MARGIN,   % y-coord of Bottom
	];
end

%returns bead or series number, must input string, not cel, not table!
function beadOrSeries=parseOutAMKey (beadOrSeriesUnparsed, deliminter)
    beadOrSeries = extractAfter(beadOrSeriesUnparsed, deliminter);
end
%returns condition from OMTC_FOLDER
function condition = parse_out_condition(OMTC_FOLDER)
    condition= extractAfter(OMTC_FOLDER, '/');
end
%input RoiCoordFileString and outputs the series number
function series = parseOutSeries (FileString,OMTC_CONDITION_DIR)
    series= extractBetween(FileString, (strcat(OMTC_CONDITION_DIR, "/series_")), "/");
end