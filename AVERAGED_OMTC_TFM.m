%AVERAGED_OMTC_TFM: computes and plots the averaged TFM-OMTC across one CONDITION

%USER INPUT 1/9:OMTC data array name files (lines 5-27)and TFM data name
%files (lines 31-53)

DU145_ARRAY = ["DU145/1_kPa",...
               "DU145/3_kPa",...
               "DU145/12_kPa",...
               "DU145/25_kPa",...
               "DU145/50kPa"]
                
LNCaP_ARRAY = [ "LNCaP/1_kPa_3000",...
                "LNCaP/3_kPa_TFM_ONLY",...
                "LNCaP/12_kPa_TFM_ONLY",...
                "LNCaP/25_kPa",...
                "LNCaP/50_kPa_TFM_ONLY"]

PC3_ARRAY = [ "PC3/1_kPa_2",...
              "PC3/3_kPa_2",...
              "PC3/12_kPa_1",...
              "PC3/25_kPa",...
              "PC3/50_kPa_NEW"]

ttRV1_ARRAY = [ "22RV1/1_kPa_TFM",...
                "22RV1/3_kPa_TFM",...
                "22RV1/12_kPa_TFM",...
                "22RV1/25_kPa",...
                "22RV1/50_kPa_TFM"]
         
            
%TFM Arrays             
DU145_TFM = ["DH_DU145_1kPa",...
             "DZ_DU145_3kPa",...
             "TFM_DU145_12kPa",...
             "DX_DU145_25kPa",...
             "DL_DU145_50kPa"]
                               
LNCaP_TFM = [ "DF_LNCaP_1kPa",...
                   "DJ_LNCaP_3kPa",... 
                   "DF_LNCaP_12kPa",...
                   "DX_LNCaP_25kPa",...
                   "DJ_LNCaP_50kPa"]
               
PC3_TFM = [ "DP_PC3_1kPa",...
            "DP_PC3_3kPa",...
            "DP_PC3_12kPa",...
            "DT_PC3_25kPa",...
            "DT_PC3_50kPa"]

ttRV1_TFM = [ "TFM_22RV1_1kPa",...
              "DC_22RV1_3kPa",...
              "DC_22RV1_12kPa",...
              "DX_22RV1_25kPa",...
              "DL_22RV1_50kPa"]
             

       
% USER INPUT 2/9: selects which OMTC and TFM arrays to plot
MEGA_OMTC= {ttRV1_ARRAY, LNCaP_ARRAY,DU145_ARRAY, PC3_ARRAY }
MEGA_TFM = {ttRV1_TFM, LNCaP_TFM,DU145_TFM,PC3_TFM,}
               

%selection of OMTC attributes to plot
a = 3
h = 5
GStar = 4                 
G1 = 9
G2 = 10
tan_delta = 11
ChooseMean = 12
ChooseMedian = 13

%USER INPUT 3/9: limit on OMTC attribute
G_limit = 100000


% USER INPUT 4/9: choose OMTC attribute to plot:
OMTC_ATTRIBUTE = GStar


% USER INPUT 5/9: TFM attribute: RMST 1, strain energy 2, avergade displacment 3
TFM_ATTRIBUTE = 1

%USER INPUT 6/9: input 12 for the mean OMTC attribute, 13 for the median OMTC aaattribute
%IMPORTANT: change line 179 function to median or mean 
MedianOrMean = 12

switch MedianOrMean
    case ChooseMean
        mean_title = "Mean"
    case ChooseMedian
        mean_title = "Median"
end

%switches plot setting parameters based on chosen attribute
switch OMTC_ATTRIBUTE
     case a
        edges= [0:0.1:2];
        attribute_title ='AMPLITUDE (um)'
        y_scale = [0.0,2];
        
     case h
        ylim= [0:0.01:0.25];
        attribute_title ='H VALUE (s)';
        y_scale = [0.0,0.25];
    case GStar
        edges = [0:25:1000];
        attribute_title ='Apparent Modulus (Pa)';
        y_scale = [0.0,1000];
    case G1
        edges = [0:25:1200];
        attribute_title ='Storage Modulus ';
        y_scale = [0.0,1200];
    case G2
        edges = [0:25:1200];
        attribute_title ='Loss Modulus ';
        y_scale = [0.0,1200];
    case tan_delta
        edges = [0:0.1:2.5];
        attribute_title ='Tan Delta'
        y_scale = [0.0,2.5];
end

%USER INPUT 7/9: directory name where OMTC results are located
CONDITION_OMTC_FINAL = '/Volumes/Seagate/OMTC/compiled'
%USER INPUT 8/9: directory name where TFM results are located
CONDITION_TFM_FINAL = '/Volumes/Seagate/OMTC/TFM_results'
FILE_PATTERN = ".xlsx"

f1 = figure();
Ax(1) = axes(f1); 

colors = [0.90 0.14 0.14

    1.00 0.54 0.00
    
    0.25 0.80 0.54

    0.47 0.25 0.80
     ];  
%% AVERAGES STRAIN ENERGY AND CORRESPONDING OMTC ATTRIBUTE
for j= 1:length(MEGA_OMTC)
    
    label_array = []
    OMTC_array = []
    mean_strain_array =[]
    condition_array= []
    err_array= []
    err_strain_array=[]
    filtered_attribute_column = []
    strain_column=[]

    OMTC_column = MEGA_OMTC{j}

    % averages OMTC data for given cell type on given modulus
    for i = 1:length(OMTC_column)
            

            stiffness = OMTC_column{i};

            
            file_search_pattern_OMTC = strcat(CONDITION_OMTC_FINAL ,"/", stiffness, FILE_PATTERN);
            file_directory = dir(file_search_pattern_OMTC);

            if (length(file_directory) ~= 1) 
                error ('Expected single excel file in ' + file_search_pattern_OMTC +" number:"+length(file_directory));
            end

            file_string = strcat(file_directory(1).folder,"/", file_directory(1).name);
            condition_table_NaN = readtable(file_string);

            condition_table = rmmissing(condition_table_NaN);

            attribute_column = table2array(condition_table(:, OMTC_ATTRIBUTE))
            for k = 1:length(attribute_column)
                if attribute_column(k) < G_limit;
                    filtered_attribute_column =   [filtered_attribute_column; attribute_column(k)] ;
                end
            end
            %USER INPUT 9/9: change function to median or mean 
            mean_G = median(filtered_attribute_column);
            stderror = std(filtered_attribute_column) / sqrt( length(filtered_attribute_column));
            
            
             err_array = [err_array, (stderror/2)];
             OMTC_array = [OMTC_array; mean_G'];
               

    end

    TFM_ARRAY = MEGA_TFM{j}
    
    % averages corresponding TFM data for given cell type on given modulus

    for i = 1:length(TFM_ARRAY)

            
        TFM_folder = TFM_ARRAY{i};
        file_search_pattern_TFM = strcat(CONDITION_TFM_FINAL, "/", TFM_folder,"/results.mat");
        file_directory = dir(file_search_pattern_TFM);

        if (length(file_directory) ~= 1) 
            error ('Expected single excel file in ' + file_search_pattern_TFM +" number:"+length(file_directory));
        end

        file_string = strcat(file_directory(1).folder,"/", file_directory(1).name);
        results_file = load(file_string);

        switch TFM_ATTRIBUTE
         case 1
            TFM_data = (results_file.rmst)'
            TFM_title ='RMST (Pa)'
            factor_variable = 1
         case 2
            TFM_data = (results_file.strain_energy)'
            TFM_title ='Strain Energy (pJ)'
            factor_variable = 1000000000000
         case 3
            TFM_data = (results_file.average_displacement)'
            TFM_title ='Average Displacement (um)'
            factor_variable = 1

        end


        strain_column = [strain_column ; TFM_data]

            
        factor_correction = repmat(factor_variable, length(strain_column), 1)
        strain_to_scale = (strain_column.*factor_correction)    
        
 
        mean_strain = mean(strain_to_scale);
        stderror = std(strain_to_scale) / sqrt( length(strain_to_scale));
        err_strain_array = [err_strain_array, (stderror/2)];
        mean_strain_array = [mean_strain_array; mean_strain'];


             
 
    end
%% PLOTS STRAIN ENERGY VS OMTC ATTRIBUTE 
    color = [ 0.0 0.0 0.0 ]
    labels = ['1  kPa'; '3  kPa'; '12 kPa'; '25 kPa' ;'50 kPa'];         
    markers='ospd^'
   
    
    scatterplot = gscatter(mean_strain_array,  OMTC_array, labels, color,markers, 10);
    
    %to fill markers
%     for g = 1:length(scatterplot)
%         scatterplot(g).MarkerFaceColor = scatterplot(g).Color;
%     end
    for n = 1:length(scatterplot)
        set(scatterplot(n), 'MarkerFaceColor', colors(j,:));
    end
    
    
    hold on
    lineplot = plot(mean_strain_array,OMTC_array, 'lineWidth', 2, 'Parent', Ax(1))
    lineplot.Color= colors(j,:)
 
    
    
    set(Ax(1), 'Box','off')
    errorplot = errorbar(mean_strain_array,OMTC_array,err_array,err_array,err_strain_array,err_strain_array,'LineStyle','none', 'Color', 'k','Parent',Ax(1))
    
    leg1= legend(Ax(1),[scatterplot],labels, 'Location', "southeast");set(leg1,'FontSize',12);
    title (leg1, strcat('Modulus ', mean_title) );
    leg1.TextColor= 'k'
    Ax(2) = copyobj(Ax(1),gcf);
    delete(get(Ax(2),'Children') )
    
    mlabel1= plot (1000,1,'_', 'MarkerSize',100,'Parent',Ax(2))
    mlabel1.Color = [ 0.90 0.14 0.14]
    mlabel2= plot (1000,1,'_','MarkerSize',100,'Parent',Ax(2))
    mlabel2.Color = [ 1.00 0.54 0.00]
    mlabel3= plot (1000,1,'_','MarkerSize',100,'Parent',Ax(2))
    mlabel3.Color = [0.25 0.80 0.54]
    mlabel4= plot (1000,1,'_','MarkerSize',100,'Parent',Ax(2))
    mlabel4.Color = [ 0.47 0.25 0.80]
    
    set(Ax(2), 'Color', 'none', 'XTick', [], 'YAxisLocation', 'right', 'Box', 'Off', 'Visible', 'off')

    leg2 = legend([mlabel1,mlabel2,mlabel3,mlabel4],'22RV1', 'LNCaP', 'DU145', 'PC3', 'Location', "southwest");
    set (leg2, "FontSize", 12, "LineWidth", 1.5);
    title (leg2, 'Cell Type' );

    xlabel(TFM_title)
    set (gca, "FontSize", 12, "LineWidth", 1.5);
    ylabel(attribute_title)
    
    set (gca, "FontSize", 12, "LineWidth", 1.5);
    
    title( strcat(TFM_title," v.s."," ", mean_title, " ", attribute_title));
    set (gca, "FontSize", 15, "LineWidth", 1.5);
    
    xlim([0,115])
    ylim([300,1800])


end 

%% TO OVERLAY IMAGE
%    mini=imread('mean_mini.tif'); axes('position',[.4 .45 .45 .45]); imagesc(mini);
%     
     hold on
