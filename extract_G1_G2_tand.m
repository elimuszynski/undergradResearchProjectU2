
function[phi, G, cos_phi, sin_phi, G1, G2, tan_delta] = calculate_G1_G2_tand(a, h)
    
    
%     str_a = char(a);
%     str_h = char(h);
%     num_a = str2num(str_a);
    
%     a_new = str2num(a);
%     h_new = str2num(h);


    T = 110.11;
    phi = 2*pi*h;
    %phi is phase shift in radians , matlab's sin and cos function take
    %inputs in radians
    
    G = (T/a*2.25)/0.6;
    cos_phi = cos(phi)
    sin_phi = sin(phi)
    G1 = abs(cos_phi*G);
    G2 = abs(sin_phi*G);
    tan_delta = G2/G1;
    
end