
function[sin_fit_plot_name, a, h, phi, G, cos_phi, sin_phi, G1, G2, tan_delta] = extract_summary_statistics (displacement_excel, bead_directory, condition, series, bead, orig_fin)


        [a, h, sin_fit_plot_name] = sin_fit(displacement_excel, bead_directory, condition, series, bead, orig_fin);
        

        [phi, G, cos_phi, sin_phi, G1, G2, tan_delta] = extract_G1_G2_tand(a, h);




 
end