%GENRERAL_OMTC_BOXPLOT: the most general and flexible version; x number of...
%CONDITIONs may be inputted to generate a plot containing x number of boxplots.

%USER INPUT 1/3 : string of directory where all conditions inputed into CONDITION_ARRAY are located
CONDITION_DIR = "/Volumes/Seagate/OMTC/compiled/"

%USER INPUT 2/3: OMTC data array name files, buffe after each cell type is required
CONDITION_ARRAY = [ "DH_DU145_1kpa_50kPa_TFM_OMTC/DU145_1kPa_TFM",... 
                    "DZ_DU145_3kPa_12kPa_TFM_OMTC/TFM_DU145_3kPa",...
                    "DZ_DU145_3kPa_12kPa_TFM_OMTC/TFM_DU145_12kPa",...
                    "DL_22RV1_3_50_Du145_50_PC3_50/DU145_TFM2_50kPa"]

a = 3
h = 45
GStar = 4                  
G1 = 9
G2 = 10
tan_delta = 11

% USER INPUT 3/3: choose OMTC attribute to plot:
ATTRIBUTE = GStar

switch ATTRIBUTE
     case a
        edges= [0:0.1:2];
        attribute_title ='AMPLITUDE';
        y_title = '(microns)';
        y_scale = [0.0,2];
        
     case h
        ylim= [0:0.01:0.25];
        attribute_title ='H VALUE';
        y_title = '(s)';
        y_scale = [0.0,0.25];
    case GStar
        edges = [0:25:5000];
        attribute_title ='Apparent Modulus'
        y_title = '(kPa)'
        y_scale = [0.0,8000];
    case G1
        edges = [0:25:1200];
        attribute_title ='Storage Modulus';
        y_title = '(kPa)';
        y_scale = [0.0,1200];
    case G2
        edges = [0:25:1200];
        attribute_title ='Loss Modulus';
        y_title = '(kPa)';
        y_scale = [0.0,1200];
    case tan_delta
        edges = [0:0.1:2.5];
        attribute_title ='Tan Delta'
        y_title = ' ';
        y_scale = [0.0,2.5];
 end

CONDITION_DIR = "/Volumes/Seagate/OMTC/experiments/"

FILE_PATTERN = "_SUMMARY_STATS_AMPLITUDE.xlsx"
FOLDER_PATTERN = "_amplitude/"


attribute_column_array = []
group_array = []
label_array = []
mean_array =[]
mean_group_array =[]
for i = 1:length(CONDITION_ARRAY)
    condition_folder = CONDITION_ARRAY(i);
    condition = parse_out_condition(condition_folder, "_", "_")
    file_name = strcat(condition, FILE_PATTERN)
    file_search_pattern = strcat(CONDITION_DIR , condition_folder ,  "/", condition, FOLDER_PATTERN,  file_name);
    file_directory = dir(file_search_pattern);
    if (length(file_directory) ~= 1) 
        error ('Expected single excel file in ' + file_search_pattern +" number:"+length(file_directory));
        
    end
    file_string = strcat(file_directory(1).folder,"/", file_directory(1).name);
    condition_table = readtable(file_string);
    attribute_column = table2array(condition_table(:, ATTRIBUTE))

    
    filtered_attribute_column = []
    for j = 1:length(attribute_column)
      
         cell = attribute_column(j);
         NaNCheck= isnan(cell);

         if NaNCheck == 0;
           filtered_attribute_column =   [filtered_attribute_column; attribute_column(j)] ;
        end
     end
    
     if length(filtered_attribute_column) > 0
    
        attribute_column_array = [attribute_column_array; filtered_attribute_column ];
        group_array = [group_array; i*ones(size(filtered_attribute_column))];
        label_array = [label_array, parse_out_condition(condition_folder, "_", " ")];
        mean_array =[mean_array; mean(filtered_attribute_column)];
        
    end
end

label_cell_array =cellstr(label_array)

         
newcolors = [0.90 0.14 0.14
            
             1.00 0.54 0.00
            
             0.47 0.25 0.80
             
             0.25 0.80 0.54
             ];         


colororder(newcolors)

nice= boxplot(attribute_column_array, group_array, 'Colors',newcolors, 'Labels',label_cell_array)

set(nice,{'linew'},{1.5})
xlabel('Condition')
ylabel(y_title)
title(strcat( attribute_title));
ylim(y_scale);



hold on;
scatter_overlay = scatter(group_array,attribute_column_array,'k','o',"filled",'jitter','on','JitterAmount',0.1)
scatter_overlay.MarkerFaceAlpha = 0.7
hold on;

mean_group_array =[mean_group_array; unique(group_array)];

averge_overlay = plot(mean_group_array, mean_array, '*','MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =2

function condition_name_clean = parse_out_condition(condition, erase_string, replace_string)

    condition_name = extractAfter(condition, '/');
    condition_name_clean = strrep( condition_name , erase_string , replace_string)
end