
function [a, h, sin_fit_plot_name] = sin_fit(displacement_excel, bead_directory, condition, series, bead, orig_fin)
%    UNCOMMENT TO USE  SUMMARY_STATISTICS.m, LEAVE COMMENTED OUT TO USE AMPLITUDE_SUMMARY_STATISTICS.m      
%    delta_torque = h-0.25;
%    displacment_table = readtable(displacement_excel);
%    time_original = table2array(displacment_table(:, 1)); 
%    displacement_original = table2array(displacment_table(:, 2));
   
   time_noshift = (displacement_excel(:, 1)); 
   displacement = (displacement_excel(:, 2));
   
%    UNCOMMENT TO USE  SUMMARY_STATISTICS.m, LEAVE COMMENTED OUT TO USE AMPLITUDE_SUMMARY_STATISTICS.m      
%  delta_torque = h-0.25; 
%    time = repmat(time_original,1);
%    displacement = repmat(displacement_original,1) ;
%    
%    new_time_start = find (time_original < start_time);
%    new_time_end = find(time_original > end_time);
%    omit_inds_time = [new_time_start; new_time_end];
% 
%    time(omit_inds_time) = [];
%    displacement(omit_inds_time) = [];   
   
    
    % Initialize arrays to store fits and goodness-of-fit.
    time = time_noshift;
    fitresult = cell( 2, 1 );
    gof = struct( 'sse', cell( 2, 1 ), ...
        'rsquare', [], 'dfe', [], 'adjrsquare', [], 'rmse', [] );

    %Fit: 'Displacment_fit'.
    [xData, yData] = prepareCurveData(time, displacement );

    % Set up fittype and options.
    ft = fittype( 'a*sin(2*pi*(x-h+0.25))', 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.StartPoint = [0.5 0.25];
    
    opts.Lower = [0 -0.30];
    opts.StartPoint = [0.8 0.14 ];
    opts.Upper = [Inf 0.5 ];


    % Fit model to data.
    [fitresult{1}, gof(1)] = fit( xData, yData, ft, opts );
    
    fit_data = coeffvalues(fitresult{1});
    
    a = fit_data(1);
    h = fit_data(2);
%  UNCOMMENT TO USE  SUMMARY_STATISTICS.m, LEAVE COMMENTED OUT TO USE AMPLITUDE_SUMMARY_STATISTICS.m      
%  delta_torque = h-0.25;
    
% individual plots
    torque_data = 110*sin(2*pi*(time+0.25));
    
    
    maxval_fit = max(abs(yData));
    maxval_torque = max(abs(torque_data));
    
%   UNCOMMENT TO USE  SUMMARY_STATISTICS.m   
%   [x,y1,y2] = plotyy([time],[fit_curve],[torque_data]);

    % Plot fit with data.
    sin_fit_plot = figure( 'Name', strcat(series,"_" , bead,"_SIN_FIT_", orig_fin ));
    
    yyaxis left
    fit_curve = plot( fitresult{1}, 'k-', xData, yData, 'k.' );
    ylabel( 'distance (um)');
    ylim([-maxval_fit maxval_fit]);  % Mult by 1.1 to pad out a bit

    
    yyaxis right
    torque_curve = plot(xData,torque_data, 'r' )
    ylabel( 'torque' ); 
    ylim([(-maxval_torque*1.1) (maxval_torque*1.1)]);  % Mult by 1.1 to pad out a bit
   
    grid
    
    legend('displacement data','displacement fit', 'torque curve')  
     
    xlabel( 'time (s)', 'Interpreter', 'none' );

    xl = xlim;
    yl = ylim;
    xt = 0.05 * (xl(2)-xl(1)) + xl(1)
    yt = 0.90 * (yl(2)-yl(1)) + yl(1)
    
    equation = (strcat("y=", string(a), "*sin(2pi*(x-(", string(h), ")))"));
    caption = sprintf(equation);
    text(xt, yt, caption, 'FontSize', 12, 'Color', 'k');
    ax_sin = gca;
    
    sin_fit_plot_name = strcat(bead_directory, "/", orig_fin, "/", condition, "_", series, "_" , bead, "_SIN_FIT_", orig_fin, ".tif");
    saveas(sin_fit_plot, sin_fit_plot_name);
    
end