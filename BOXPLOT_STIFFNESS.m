%BOXPLOT_STIFFNESS: Generates a boxplot of Apparent Modulus data grouped by substrate stiffness. 

%USER INPUT 1/3 : string of directory where all conditions inputed into...
%CONDITION_ARRAY are located
CONDITION_DIR = "/Volumes/Seagate/OMTC/compiled/"

%USER INPUT 2/3: OMTC data array name files, buffe after each cell type is required 
 CONDITION_ARRAY = [ "22RV1/1_kPa_TFM",...
                    "LNCaP/1_kPa_TFM_ONLY",...
                    "DU145/1_kPa",...
                    "PC3/1_kPa_2",...
                    "PC3/1_kPa_2",... %buffer
                    "22RV1/3_kPa_TFM",...
                    "LNCaP/3_kPa_TFM_ONLY",...
                    "DU145/3_kPa",...
                    "PC3/3_kPa_2",...
                    "PC3/1_kPa_2",... %buffer
                    "22RV1/12_kPa_TFM",...
                    "LNCaP/12_kPa_TFM_ONLY",...
                    "DU145/12_kPa",...
                    "PC3/12_kPa_2",...
                    "22RV1/25_kPa",... %buffer
                    "22RV1/25_kPa",...
                    "LNCaP/25_kPa",...
                    "DU145/25_kPa",...
                    "PC3/25_kPa",...
                    "PC3/25_kPa",... %buffer
                    "22RV1/50_kPa_TFM",... 
                    "LNCaP/50_kPa_TFM_ONLY",... 
                    "DU145/50_kPa",...
                    "PC3/50_complied"]
                    
a = 3
h = 45
GStar = 4                  
G1 = 9
G2 = 10
tan_delta = 11
trial = 5
G_limit = 4000
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
        y_title = 'Apparent Modulus (kPa)'
        y_scale = [0.0,6000];
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


FILE_PATTERN = ".xlsx"

attribute_column_array = []
group_array = []
label_array = []
mean_array =[]
mean_group_array= []

f1 = figure();
Ax(1) = axes(f1);     

for i = 1:length(CONDITION_ARRAY)
    condition_folder = CONDITION_ARRAY(i);
    condition = parse_out_condition(condition_folder, "_", "_");
    cell_type = parse_out_cell_type(condition_folder);
    file_search_pattern = strcat(CONDITION_DIR , condition_folder ,FILE_PATTERN);
    file_directory = dir(file_search_pattern);
    if (length(file_directory) ~= 1) 
        error ('Expected single excel file in ' + file_search_pattern +" number:"+length(file_directory));
        
    end
    file_string = strcat(file_directory(1).folder,"/", file_directory(1).name);
    condition_table = readtable(file_string);
    attribute_column = table2array(condition_table(:, ATTRIBUTE))
%     class = table2array(condition_table(:, trial))

    
    filtered_attribute_column = []
    for j = 1:length(attribute_column)
      
         cell = attribute_column(j);
         NaNCheck= isnan(cell);

         if NaNCheck == 0 && cell < G_limit;
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


newcolors_1= [0.0 0.0 0.0]
         
newcolors = [0.90 0.14 0.14
    1.00 0.54 0.00 
    0.25 0.80 0.54
    0.47 0.25 0.80  
    1 1 1

    

            ];  
         

                         
colororder(newcolors)


nice= boxplot(attribute_column_array, group_array, 'Colors',newcolors,'Symbol','w+')

set(nice,{'linew'},{1.5})
xlabel('Cell Type')
set(gca, "FontSize", 12);
ylabel(y_title)
set(gca, "FontSize", 12);
title(strcat(attribute_title, ": grouped by Stiffness Modulus"));
ylim(y_scale);

set(gca, "FontSize", 12);

set (gca, 'xtick' , [2.5,7.5,12.5,17.5,22.5], 'xticklabel', {"1 kPa", "3 kPa", "12 kPa", '25kPa',"50 kPa"})

hold on;

red=newcolors(1,:)
orange = newcolors(2,:)
green = newcolors(3,:)
purple = newcolors(4,:)
scatter_overlay = scatter(group_array(group_array ==1) ,attribute_column_array(group_array ==1),[], red,'o',"filled",'jitter','on','JitterAmount',0.1)
scatter_overlay.MarkerFaceAlpha = 0.2
scatter_overlay = scatter(group_array(group_array ==2) ,attribute_column_array(group_array ==2),[], orange,'o',"filled",'jitter','on','JitterAmount',0.1)
scatter_overlay.MarkerFaceAlpha = 0.2
scatter_overlay = scatter(group_array(group_array ==3) ,attribute_column_array(group_array ==3),[], green,'o',"filled",'jitter','on','JitterAmount',0.1)
scatter_overlay.MarkerFaceAlpha = 0.2
scatter_overlay = scatter(group_array(group_array ==4) ,attribute_column_array(group_array ==4),[], purple,'o',"filled",'jitter','on','JitterAmount',0.1)
scatter_overlay.MarkerFaceAlpha = 0.2
scatter_overlay = scatter(group_array(group_array ==6) ,attribute_column_array(group_array ==6),[], red,'o',"filled",'jitter','on','JitterAmount',0.1)
scatter_overlay.MarkerFaceAlpha = 0.2
scatter_overlay = scatter(group_array(group_array ==7) ,attribute_column_array(group_array ==7),[], orange,'o',"filled",'jitter','on','JitterAmount',0.1)
scatter_overlay.MarkerFaceAlpha = 0.2
scatter_overlay = scatter(group_array(group_array ==8) ,attribute_column_array(group_array ==8),[], green,'o',"filled",'jitter','on','JitterAmount',0.1)
scatter_overlay.MarkerFaceAlpha = 0.2
scatter_overlay = scatter(group_array(group_array ==9) ,attribute_column_array(group_array ==9),[], purple,'o',"filled",'jitter','on','JitterAmount',0.1)
scatter_overlay.MarkerFaceAlpha = 0.2
scatter_overlay = scatter(group_array(group_array ==11) ,attribute_column_array(group_array ==11),[], red,'o',"filled",'jitter','on','JitterAmount',0.1)
scatter_overlay.MarkerFaceAlpha = 0.2
scatter_overlay = scatter(group_array(group_array ==12) ,attribute_column_array(group_array ==12),[], orange,'o',"filled",'jitter','on','JitterAmount',0.1)
scatter_overlay.MarkerFaceAlpha = 0.2
scatter_overlay = scatter(group_array(group_array ==13) ,attribute_column_array(group_array ==13),[], green,'o',"filled",'jitter','on','JitterAmount',0.1)
scatter_overlay.MarkerFaceAlpha = 0.2
scatter_overlay = scatter(group_array(group_array ==14) ,attribute_column_array(group_array ==14),[], purple,'o',"filled",'jitter','on','JitterAmount',0.1)
scatter_overlay.MarkerFaceAlpha = 0.2
scatter_overlay = scatter(group_array(group_array ==16) ,attribute_column_array(group_array ==16),[], red,'o',"filled",'jitter','on','JitterAmount',0.1)
scatter_overlay.MarkerFaceAlpha = 0.2
scatter_overlay = scatter(group_array(group_array ==17) ,attribute_column_array(group_array ==17),[], orange,'o',"filled",'jitter','on','JitterAmount',0.1)
scatter_overlay.MarkerFaceAlpha = 0.2
scatter_overlay = scatter(group_array(group_array ==18) ,attribute_column_array(group_array ==18),[], green,'o',"filled",'jitter','on','JitterAmount',0.1)
scatter_overlay.MarkerFaceAlpha = 0.2
scatter_overlay = scatter(group_array(group_array ==19) ,attribute_column_array(group_array ==19),[], purple,'o',"filled",'jitter','on','JitterAmount',0.1)
scatter_overlay.MarkerFaceAlpha = 0.2
scatter_overlay = scatter(group_array(group_array ==21) ,attribute_column_array(group_array ==21),[], red,'o',"filled",'jitter','on','JitterAmount',0.1)
scatter_overlay.MarkerFaceAlpha = 0.2
scatter_overlay = scatter(group_array(group_array ==22) ,attribute_column_array(group_array ==22),[], orange,'o',"filled",'jitter','on','JitterAmount',0.1)
scatter_overlay.MarkerFaceAlpha = 0.2
scatter_overlay = scatter(group_array(group_array ==23) ,attribute_column_array(group_array ==23),[], green,'o',"filled",'jitter','on','JitterAmount',0.1)
scatter_overlay.MarkerFaceAlpha = 0.2
scatter_overlay = scatter(group_array(group_array ==24) ,attribute_column_array(group_array ==24),[], purple,'o',"filled",'jitter','on','JitterAmount',0.1)
scatter_overlay.MarkerFaceAlpha = 0.2
hold on;




mean_group_array =[mean_group_array; unique(group_array)];

averge_overlay = plot(mean_group_array (mean_group_array==1), mean_array(mean_group_array==1),  'o', 'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =1.5
% averge_overlay.Color = [0.90 0.14 0.14]
averge_overlay.Color = [0 0 0]
averge_overlay = plot(mean_group_array (mean_group_array==2), mean_array(mean_group_array==2), 'o', 'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =1.5
% averge_overlay.Color = [0.90 0.14 0.14]
averge_overlay.Color = [0 0 0]
averge_overlay = plot(mean_group_array (mean_group_array==3), mean_array(mean_group_array==3), 'o', 'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =1.5
% averge_overlay.Color = [0.90 0.14 0.14]
averge_overlay.Color = [0 0 0]
averge_overlay = plot(mean_group_array (mean_group_array==4), mean_array(mean_group_array==4), 'o', 'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =2
% averge_overlay.Color = [0.90 0.14 0.14]
averge_overlay.Color = [0 0 0]
averge_overlay = plot(mean_group_array (mean_group_array==5), mean_array(mean_group_array==5), 'o', 'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =1.5
% averge_overlay.Color = [1.00 0.54 0.00]
averge_overlay.Color = [1 1 1]
averge_overlay = plot(mean_group_array (mean_group_array==6), mean_array(mean_group_array==6), 's', 'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =1.5
% averge_overlay.Color = [1.00 0.54 0.00]
averge_overlay.Color = [0 0 0]
averge_overlay = plot(mean_group_array (mean_group_array==7), mean_array(mean_group_array==7), 's', 'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =1.5
% averge_overlay.Color = [1.00 0.54 0.00]
averge_overlay.Color = [0 0 0]
averge_overlay = plot(mean_group_array (mean_group_array==8), mean_array(mean_group_array==8), 's', 'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =1.5
% averge_overlay.Color = [1.00 0.54 0.00]
averge_overlay.Color = [0 0 0]
averge_overlay = plot(mean_group_array (mean_group_array==9), mean_array(mean_group_array==9), 's', 'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =1.5
% averge_overlay.Color = [0.47 0.25 0.80]
averge_overlay.Color = [0 0 0]
averge_overlay = plot(mean_group_array (mean_group_array==10), mean_array(mean_group_array==10), 'p', 'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =1.5
% averge_overlay.Color = [0.47 0.25 0.80]
averge_overlay.Color = [1 1 1]
averge_overlay = plot(mean_group_array (mean_group_array==11), mean_array(mean_group_array==11), 'p', 'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =1.5
% averge_overlay.Color = [0.47 0.25 0.80]
averge_overlay.Color = [0 0 0]
averge_overlay = plot(mean_group_array (mean_group_array==12), mean_array(mean_group_array==12), 'p', 'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =1.5
% averge_overlay.Color = [0.47 0.25 0.80]
averge_overlay.Color = [0 0 0]
averge_overlay = plot(mean_group_array (mean_group_array==13), mean_array(mean_group_array==13), 'p',  'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =1.5
averge_overlay.Color = [0 0 0]
% averge_overlay.Color = [0.25 0.80 0.54]
averge_overlay = plot(mean_group_array (mean_group_array==14), mean_array(mean_group_array==14), 'p', 'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =1.5
averge_overlay.Color = [0 0 0]
% averge_overlay.Color = [0.25 0.80 0.54]
averge_overlay = plot(mean_group_array (mean_group_array==15), mean_array(mean_group_array==15), '*', 'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =1.5
averge_overlay.Color = [1 1 1]
% averge_overlay.Color = [0.25 0.80 0.54]
averge_overlay = plot(mean_group_array (mean_group_array==16), mean_array(mean_group_array==16), 'd', 'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =1.5
averge_overlay.Color = [0 0 0]
% averge_overlay.Color = [0.25 0.80 0.54]
averge_overlay = plot(mean_group_array (mean_group_array==17), mean_array(mean_group_array==17), 'd', 'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =1.5
averge_overlay.Color = [0 0 0]
% averge_overlay.Color = [0.25 0.80 0.54]
averge_overlay = plot(mean_group_array (mean_group_array==18), mean_array(mean_group_array==18), 'd', 'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =1.5
averge_overlay.Color = [0 0 0]
% averge_overlay.Color = [0.25 0.80 0.54]
averge_overlay = plot(mean_group_array (mean_group_array==19), mean_array(mean_group_array==19), 'd', 'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =1.5
averge_overlay.Color = [0 0 0]
% averge_overlay.Color = [0.25 0.80 0.54]
averge_overlay = plot(mean_group_array (mean_group_array==20), mean_array(mean_group_array==20), '*', 'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =1.5
averge_overlay.Color = [1 1 1]
% averge_overlay.Color = [0.25 0.80 0.54]
averge_overlay = plot(mean_group_array (mean_group_array==21), mean_array(mean_group_array==21), '^', 'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =1.5
averge_overlay.Color = [0 0 0]
% averge_overlay.Color = [0.25 0.80 0.54]
averge_overlay = plot(mean_group_array (mean_group_array==22), mean_array(mean_group_array==22), '^', 'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =1.5
averge_overlay.Color = [0 0 0]
% averge_overlay.Color = [0.25 0.80 0.54]
averge_overlay = plot(mean_group_array (mean_group_array==23), mean_array(mean_group_array==23), '^', 'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =1.5
averge_overlay.Color = [0 0 0]
% averge_overlay.Color = [0.25 0.80 0.54]
averge_overlay = plot(mean_group_array (mean_group_array==24), mean_array(mean_group_array==24), '^', 'MarkerSize',12)
averge_overlay.MarkerHandle.LineWidth =1.5
averge_overlay.Color = [0 0 0]
% averge_overlay.Color = [0.25 0.80 0.54]



    mlabel1= scatter (100,1,'ko','Parent', Ax(1))
    mlabel2= scatter (100,1,'ks','Parent', Ax(1))
    mlabel3= scatter (100,1,'kp','Parent', Ax(1))
    mlabel4= scatter (100,1,'kd','Parent', Ax(1))
    mlabel5= scatter (100,1,'k^','Parent', Ax(1))
    
   
    set(Ax(1), 'Box','off')
    
    leg1= legend(Ax(1),[mlabel1,mlabel2,mlabel3,mlabel4],'1 kPa', '3 kPa', '12 kPa', '25 kPa', '50 kPa', 'Location', "northwest");set (leg1, "FontSize", 12, "LineWidth", 1.5);
    
    title (leg1, 'Modulus Mean' );
    Ax(2) = copyobj(Ax(1),gcf);
    delete(get(Ax(2),'Children') )
    
    mlabel1= plot (100,1,'_', 'MarkerSize',30,'Parent',Ax(2))
    mlabel1.Color = [ 0.90 0.14 0.14]
    mlabel2= plot (100,1,'_','MarkerSize',30,'Parent',Ax(2))
    mlabel2.Color = [ 1.00 0.54 0.00]
    mlabel3= plot (100,1,'_','MarkerSize',30,'Parent',Ax(2))
    mlabel3.Color = [0.25 0.80 0.54]
    mlabel4= plot (100,1,'_','MarkerSize',30,'Parent',Ax(2))
    mlabel4.Color = [ 0.47 0.25 0.80]
    mlabel4= plot (100,1,'_','MarkerSize',30,'Parent',Ax(2))
    mlabel4.Color = [ 0.47 0.25 0.80]
    
    
    set(Ax(2), 'Color', 'none', 'XTick', [], 'YAxisLocation', 'right', 'Box', 'Off', 'Visible', 'off')

    leg2 = legend([mlabel1,mlabel2,mlabel3,mlabel4],'22RV1', 'LNCaP', 'DU145', 'PC3', 'Location', "northeast");
    set (leg2, "FontSize", 15, "LineWidth", 1.5);
    title (leg2, 'Cell Type' );


function condition_name_clean = parse_out_condition(condition, erase_string, replace_string)

    condition_name = extractAfter(condition, '/');
    condition_name_clean = strrep( condition_name , erase_string , replace_string)
end

function cell_type_clean_name = parse_out_cell_type (condition);
    cell_type_clean_name = extractBefore(condition, '/');
end   