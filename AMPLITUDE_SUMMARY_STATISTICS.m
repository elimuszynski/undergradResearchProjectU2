%AMPLITUDE_SUMMARY_STATISTICS: calculates complex modulus from a condition's spots file

clc; close all; 
clear all;

USERDIRECTORY = "/Volumes/Seagate/OMTC/experiments/" %USER INPUT 1/3, location of EXPERIMENT FOLDER
EXPERIMENT = "DT_OMTC_PC3_0.5_0.85_130322" %USER INPUT 2/3
CONDITION = "DT_TFM_PC3_25kPa" %USER INPUT 3/3


q = 1;
omit_inds = [];
for i = 1:length(SPOTS_FILES_ARRAY(:,1))
    if startsWith(SPOTS_FILES_ARRAY{i,1}, '.') ==1  
        omit_inds(q) = i; 
        q = q+1; 
    end 
end 

SPOTS_FILES_ARRAY(omit_inds,:) = [];

summary_folder =(strcat(CONDITION_DIR,  "/", CONDITION, "_amplitude"));
mkdir (summary_folder);

summary_stats = {'series', 'bead','a','apparent modulus';};

for i = 1:length(SPOTS_FILES_ARRAY)
    SPOTS_FILE = SPOTS_FILES_ARRAY{i,1};
    BEAD_DIRECTORY = SPOTS_FILES_ARRAY{i,2};
    SPOT_FILE_DIR = strcat(BEAD_DIRECTORY, "/" , SPOTS_FILE);

    [series, bead] = series_bead_nums(SPOT_FILE_DIR);
    
    spots_table = readtable(SPOT_FILE_DIR);

    x_spots = table2array(spots_table(:, 5)); 
    y_spots = table2array(spots_table(:, 6)); 
    t_spots = table2array(spots_table(:, 8)); 
    
    
    start_time = min(t_spots);
    end_time = max(t_spots);
    
    %makes directory for internal bead folder
    internal_bead_folder = (strcat (BEAD_DIRECTORY, "/AMPLITUDE"));
    mkdir (internal_bead_folder);
   
    %rainbow picture is saved in extract_amplitude
    [amp_array, amp_excel_fiilename, x_vs_y_filename, a, G] = extract_amplitude (x_spots, y_spots, t_spots, BEAD_DIRECTORY, CONDITION , series, bead, start_time, end_time, internal_bead_folder,summary_folder);

    
    summary_stats(i+1, :) = {series, bead, a, G};

      
    end
     close all;   

cell2table(summary_stats);
writecell(summary_stats, strcat(summary_folder, "/", CONDITION,  "_SUMMARY_STATS_AMPLITUDE.xlsx" ));
close all

function [series_num, bead_num] = series_bead_nums(SPOT_FILES_STRING)

    series_num_backslash = extractBetween(SPOT_FILES_STRING,'series','/','Boundaries','inclusive');
    series_num = erase( series_num_backslash , "/");
    
    bead_num_backslash = extractBetween(SPOT_FILES_STRING,'bead','/','Boundaries','inclusive');
    bead_num = erase( bead_num_backslash , "/");
    
end
