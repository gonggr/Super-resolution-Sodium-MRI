% ==========================================================================
% function  : super_resolution_map_data
% --------------------------------------------------------------------------
% purpose   :   
% input     : struct sr
% output    : struct sr
% comment   :
% reference :   
% --------------------------------------------------------------------------
% 2017/10 - guillaume.madelin@nyulangone.org
% 2022/07 - gonzalo.rodriguez@nyulangone.org
% ==========================================================================


function [sr] = super_resolution_map_data_repetitions(sr)

    % ---- prepare 2d gaussian distribution
    hsize = round(sr.param.resolution_ratio); 
    sigma = hsize/4;    
    f1 = fspecial('gaussian',hsize,sigma); 
    f1 = f1-min(f1(:)); f1 = f1./max(f1(:));
    f1 = f1.*(hsize-1); f1 = f1+1;
    f1 = round(f1);    
    f1(isnan(f1)) = 1;
    sr.dist.distribution_gauss = f1;
       
    % ---- get data
    d1 = sr.data.data1;                                                    % hr data (reference)
    d2 = sr.data.data2_map;                                                % lr data mapped onto hr data

    % ---- get variables
    mask_lr_map = sr.mask.mask_data2_lr_map;    
    n_data1 = sr.data.n_data1;
    n_data2 = sr.data.n_data2;

    % ---- select pixels in within mask weighted with gaussian distribution
    f2 = double(ones(sr.param.original_hr_size_x,sr.param.original_hr_size_y)); 
    f2_mask = f2.*mask_lr_map; 
    f2_mask_select = f2(mask_lr_map);
    sr.dist.distribution_gauss_mask = f2_mask;
    sr.dist.distribution_gauss_select = f2_mask_select;

    % ---- get data1 values within mask only -> array to vector for each data
    d1_map0 = zeros(length(f2_mask_select),n_data1);
    for i=1:n_data1
        aa = d1(:,:,i); 
        d1_map0(:,i) = aa(mask_lr_map);
        clear aa;
    end

    % ---- get data2 values within mask only -> array to vector for each data
    d2_map0 = zeros(length(f2_mask_select),n_data2);
    for i=1:n_data2
        aa = d2(:,:,i); 
        d2_map0(:,i) = aa(mask_lr_map);
        clear aa;
    end    

    d1_map_rep = d1_map0;
    d2_map_rep = d2_map0;
 
    % ---- save in sr struct
    sr.data.data1_map_rep = d1_map_rep;
    sr.data.data2_map_rep = d2_map_rep;
    sr.data.data1_map_norep = d1_map0;
    sr.data.data2_map_norep = d2_map0;

end


    