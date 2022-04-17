
function [amplitude_array, ampltiude_excel_filename, x_vs_y_filename, a, G] = extract_amplitude(x_spots,y_spots,t_spots, bead_directory, condition, series, bead, start_time, end_time, internal_bead_folder,summary_folder)
    
    
    time_final = repmat(t_spots,1);
    x_final = repmat(x_spots,1) ;
    y_final = repmat(y_spots,1) ;
    
    
 
    new_time_start = find (t_spots < start_time);
    new_time_end = find(t_spots > end_time);
    omit_inds_time = [new_time_start; new_time_end];

    time_final(omit_inds_time) = [];
    x_final(omit_inds_time) = [];
    y_final(omit_inds_time) = [];
    
        
    x_vs_y = figure( 'Name', strcat(series,"_" , bead,"_TRAJECTORY" ));
  
    plot (x_final, y_final, 'color',[0.5,0.5,0.5]);
    hold on

    colour = linspace(min(time_final),max(time_final),length(time_final));

    scatter (x_final, y_final, 30, colour, 'filled')
    grid

    xlabel( 'x (um)');
    ylabel( 'y (um)' ); 
    
    colorbar
    
    ax_disp = gca;

    % only if bead ossiclates around same pt
    x_spots_zeroed = x_final - mean(x_final) ;
    
    y_spots_zeroed = y_final - mean(y_final);

    distance_spots = (x_spots_zeroed.^2 + y_spots_zeroed.^2).^(1/2); 
    a = mean(distance_spots);
    
    %calculate apparent modulus
    T = 110.11;
    
    G = (T/a*2.25)/0.6;
    
        amplitude_array = [a G];
        ampltiude_excel_filename = strcat (internal_bead_folder, "/", condition, "_", series, "_" , bead, "_AMPTLITUDE.xlsx" );
        x_vs_y_filename = strcat (summary_folder, "/", condition, "_", series, "_" , bead, ".tif" );
        writematrix(amplitude_array, ampltiude_excel_filename);
        saveas(x_vs_y, x_vs_y_filename);
        
        
    end