
clc; close all; 
clear all;

EXPERIMENT = "DW_OMTC_LNCaP_25kPa_2022_04_04"
CONDITION = "TFM_LNCaP_25kPa"

CONDITION_DIR = "/Volumes/Seagate/OMTC/experiments/" + EXPERIMENT + "/" + CONDITION ;
SPOTS_FILES_STRUCTURES = dir(CONDITION_DIR + "/**/*_SPOTS.csv");
SPOTS_FILES_ARRAY = struct2cell(SPOTS_FILES_STRUCTURES)';

q = 1;
omit_inds = [];
for i = 1:length(SPOTS_FILES_ARRAY(:,1))
    if startsWith(SPOTS_FILES_ARRAY{i,1}, '.') ==1  
        omit_inds(q) = i; 
        q = q+1; 
    end 
end 

SPOTS_FILES_ARRAY(omit_inds,:) = [];

% final_string = 'amplitude'    
% 
% summary_folder_final =(strcat(CONDITION_DIR,  "/", CONDITION, "_" , final_string));
% mkdir (summary_folder_final);
% 
% internal_bead_folder 

summary_folder =(strcat(CONDITION_DIR,  "/", CONDITION, "_amplitude_new"));
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
   

    %gives displacement array, should return just a, AND rainbow picture
    %rainbow picture is saved in extract displacement, poor design
    [amp_array, amp_excel_fiilename, x_vs_y_filename, a, G] = extract_amplitude (x_spots, y_spots, t_spots, BEAD_DIRECTORY, CONDITION , series, bead, start_time, end_time, internal_bead_folder,summary_folder);

    
    summary_stats(i+1, :) = {series, bead, a, G};
%     
%     while 1
%         checkpoint = input (['input array of 3 variables:' newline '(1) 1 to truncated, 2 to save, 3 to omit' newline '(2) start time (s)' newline '(3) end time (s)']);
%         enter = checkpoint(1);
%         start_time_final = checkpoint(2);
%         end_time_final  = checkpoint(3);
%      
%             
%         if enter == 2
%             summary_stats(i+1, :) = {series, bead, a_fin,G_fin} ;
%             break
%         end
%         
%         if enter == 3       
%             rmdir(internal_bead_folder, 's');        
%             break
%         end 
%         
%         [displacement_array_fin, displacement_excel_filename_fin, x_vs_y_filename_fin] =extract_displacement...
%                 (x_spots, y_spots, t_spots, BEAD_DIRECTORY, CONDITION , series, bead, start_time_final, end_time_final, internal_bead_folder);
%         x_vs_y_fin=imread(x_vs_y_filename_fin);
%             sin_fit_fin=imread(sin_fit_filename_fin);
% 
%             figure
%             subplot(2,2,1),imshow(x_vs_y_orig)
      
    end
     close all;   


  


cell2table(summary_stats);
writecell(summary_stats, strcat(summary_folder, "/", CONDITION,  "_SUMMARY_STATS_AMPLITUDE.xlsx" ));
close all

% cell2table(summary_stats_final);
% writecell(summary_stats_final, strcat(summary_folder_final, "/", CONDITION,  "_SUMMARY_STATS_FINAL_GM.xlsx" ));
% close all

function [series_num, bead_num] = series_bead_nums(SPOT_FILES_STRING)

    series_num_backslash = extractBetween(SPOT_FILES_STRING,'series','/','Boundaries','inclusive');
    series_num = erase( series_num_backslash , "/");
    
    bead_num_backslash = extractBetween(SPOT_FILES_STRING,'bead','/','Boundaries','inclusive');
    bead_num = erase( bead_num_backslash , "/");
    
end
