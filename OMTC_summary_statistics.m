
clc; close all; 
clear all;
% 
EXPERIMENT = "DT_OMTC_PC3_0.5_0.85_130322"
CONDITION = "DT_TFM_PC3_25kPa"


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

original_string = "ORIGINAL";
final_string = "FINAL";
    


summary_folder_original =(strcat(CONDITION_DIR,  "/", CONDITION, "_" , original_string));
mkdir (summary_folder_original);

summary_folder_final =(strcat(CONDITION_DIR,  "/", CONDITION, "_" , final_string));
mkdir (summary_folder_final);


summary_stats_orig = {'series', 'bead','a','h' ,  ...
'phi','apparent modulus', 'cos', 'sin', 'G1','G2', 'loss tangent';};

summary_stats_final = {'series', 'bead','a','h' ,  ...
'phi','apparent modulus', 'cos', 'sin', 'G1','G2', 'loss tangent';};

for i = 1:length(SPOTS_FILES_ARRAY)
    SPOTS_FILE = SPOTS_FILES_ARRAY{i,1};
    BEAD_DIRECTORY = SPOTS_FILES_ARRAY{i,2};
    SPOT_FILE_DIR = strcat(BEAD_DIRECTORY, "/" , SPOTS_FILE);

    [series, bead] = series_bead_nums(SPOT_FILE_DIR);
    
    spots_table = readtable(SPOT_FILE_DIR);

    x_spots = table2array(spots_table(:, 5)); 
    y_spots = table2array(spots_table(:, 6)); 
    t_spots = table2array(spots_table(:, 8)); 
    
    start_time_orig = min(t_spots);
    end_time_orig = max(t_spots);
    
    
    internal_bead_folder_orig = (strcat (BEAD_DIRECTORY, "/", original_string));
    mkdir (internal_bead_folder_orig);
    internal_bead_folder_final = (strcat (BEAD_DIRECTORY, "/", final_string));
    mkdir (internal_bead_folder_final);
%     %for checkpoint option 2 (omit)
%     x_vs_y_filename_orig = strcat (BEAD_DIRECTORY, "/ORIGINAL/", CONDITION, "_", series, "_" , bead, "_TRAJECTORY_ORIGINAL.tif" );
%     x_vs_y_filename_fin = strcat (BEAD_DIRECTORY, "/FINAL/", CONDITION, "_", series, "_" , bead, "_TRAJECTORY_FINAL.tif" );
    
    [displacement_array_orig, displacement_excel_filename_orig, x_vs_y_filename_orig] = extract_displacement (x_spots, y_spots, t_spots, BEAD_DIRECTORY, CONDITION , series, bead, original_string, start_time_orig, end_time_orig, internal_bead_folder_orig);
    [sin_fit_filename_orig, a_orig, h_orig, phi_orig, G_orig, cos_orig, sin_orig, G1_orig, G2_orig, tan_orig]...
        =extract_summary_statistics(displacement_array_orig,BEAD_DIRECTORY, CONDITION , series, bead, original_string);

    x_vs_y_orig = imread(x_vs_y_filename_orig);
    sin_fit_orig = imread(sin_fit_filename_orig);
    
    figure
    subplot(1,2,1),imshow(x_vs_y_orig)
    subplot(1,2,2),imshow(sin_fit_orig)

    summary_stats_orig(i+1, :) = {series, bead, a_orig, h_orig,  phi_orig, G_orig, cos_orig, sin_orig, G1_orig, G2_orig, tan_orig};
    
      
    while 1
        checkpoint = input (['input array of 3 variables:' newline '(1) 1 to truncated, 2 to save, 3 to omit' newline '(2) start time (s)' newline '(3) end time (s)']);
        enter = checkpoint(1);
        start_time_final = checkpoint(2);
        end_time_final  = checkpoint(3);
     
            
        if enter == 2
            summary_stats_final(i+1, :) = {series, bead, a_fin, h_fin, phi_fin, G_fin, cos_fin, sin_fin, G1_fin, G2_fin, tan_fin};  
            break
        end
        
        if enter == 3       
            rmdir(internal_bead_folder_final, 's');        
            break
        end 
        
        [displacement_array_fin, displacement_excel_filename_fin, x_vs_y_filename_fin] =extract_displacement...
                (x_spots, y_spots, t_spots, BEAD_DIRECTORY, CONDITION , series, bead, final_string, start_time_final, end_time_final, internal_bead_folder_final);

        [sin_fit_filename_fin, a_fin, h_fin, phi_fin, G_fin, cos_fin, sin_fin, G1_fin, G2_fin, tan_fin]...
                =extract_summary_statistics(displacement_array_fin,BEAD_DIRECTORY, CONDITION , series, bead, final_string);
                        
            x_vs_y_fin=imread(x_vs_y_filename_fin);
            sin_fit_fin=imread(sin_fit_filename_fin);

            figure
            subplot(2,2,1),imshow(x_vs_y_orig)
            subplot(2,2,2),imshow(sin_fit_orig)
            subplot(2,2,3),imshow(x_vs_y_fin)
            subplot(2,2,4),imshow(sin_fit_fin)
        
    end
    close all;   
end

cell2table(summary_stats_orig);
writecell(summary_stats_orig, strcat(summary_folder_original, "/", CONDITION,  "_SUMMARY_STATS_ORIG_GM.xlsx" ));
close all


cell2table(summary_stats_final);
writecell(summary_stats_final, strcat(summary_folder_final, "/", CONDITION,  "_SUMMARY_STATS_FINAL_GM.xlsx" ));
close all


function [series_num, bead_num] = series_bead_nums(SPOT_FILES_STRING)

    series_num_backslash = extractBetween(SPOT_FILES_STRING,'series','/','Boundaries','inclusive');
    series_num = erase( series_num_backslash , "/");
    
    bead_num_backslash = extractBetween(SPOT_FILES_STRING,'bead','/','Boundaries','inclusive');
    bead_num = erase( bead_num_backslash , "/");
    
end
