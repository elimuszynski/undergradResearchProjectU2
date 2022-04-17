%% extracts displacement from Image J spots file

function [displacement_array, displacement_excel_filename, x_vs_y_filename] = extract_displacement(x_spots,y_spots,t_spots, bead_directory, condition, series, bead, orig_fin, start_time, end_time, internal_bead_folder)
    
    
    time_final = repmat(t_spots,1);
    x_final = repmat(x_spots,1) ;
    y_final = repmat(y_spots,1) ;
    
    
 
    new_time_start = find (t_spots < start_time);
    new_time_end = find(t_spots > end_time);
    omit_inds_time = [new_time_start; new_time_end];

    time_final(omit_inds_time) = [];
    x_final(omit_inds_time) = [];
    y_final(omit_inds_time) = [];
    
        
    x_vs_y = figure( 'Name', strcat(series,"_" , bead,"_TRAJECTORY_", orig_fin ));
  
    plot (x_final, y_final, 'color',[0.5,0.5,0.5]);
    hold on

    colour = linspace(min(time_final),max(time_final),length(time_final));

    scatter (x_final, y_final, 30, colour, 'filled')
    grid

    xlabel( 'x (um)');
    ylabel( 'y (um)' ); 
    
    colorbar
    
    ax_disp = gca;
        

    x_spots_zeroed = x_final - mean(x_final) ;
    
    y_spots_zeroed = y_final - mean(y_final);

    distance_spots = (x_spots_zeroed.^2 + y_spots_zeroed.^2).^(1/2); 

    range_y = max(y_spots_zeroed)- min(y_spots_zeroed);
    range_x = max(x_spots_zeroed)- min(x_spots_zeroed);

        maxdistance = max(distance_spots);
        for i = 1:length(x_spots_zeroed)
   
            thres_distance_spots (i) = distance_spots(i);   
            if range_y > range_x
                if y_spots_zeroed(i) < 0
                    thres_distance_spots(i) = -distance_spots(i);
                end

            else
                if x_spots_zeroed(i) < 0
                    thres_distance_spots(i) = -distance_spots(i);
                end
                
            end 
                
        end 
        
        %transposition
        thres_distance_spots = thres_distance_spots';
        displacement_array = [time_final thres_distance_spots];
        displacement_excel_filename = strcat (internal_bead_folder, "/", condition, "_", series, "_" , bead, "_DISPLACEMENT_", orig_fin, ".xlsx" );
        x_vs_y_filename = strcat (internal_bead_folder, "/", condition, "_", series, "_" , bead, "_XYPLOT_", orig_fin, ".tif" );
        writematrix(displacement_array, displacement_excel_filename);
        saveas(x_vs_y, x_vs_y_filename);
        
        
    end