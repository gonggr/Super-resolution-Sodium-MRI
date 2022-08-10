% ==========================================================================
% function  : super_resolution_evaluate_hr
% --------------------------------------------------------------------------
% purpose   : calculate SAC and PRS HR    
% input     : struct sr
% output    : struct sr
% comment   :
% reference :   
% --------------------------------------------------------------------------
% 2017/10 - guillaume.madelin@nyulangone.org
% 2022/07 - gonzalo.rodriguez@nyulangone.org
% ==========================================================================


function [sr] = super_resolution_evaluate_hr(sr)
    
   % ---- get data
   switch sr.param.data_type
        case '2D data'
        j=1;
        case {'3D data', 'proton only data'}
        j= 1 + sr.param.slice - sr.param.multiple_slice_init;
    end
    
    data2_hr = sr.final_results.images.img2_hr_original{j};    
    data2_hr_sr = sr.final_results.images.img2_hr_sr_final{j};
    data2_hr_diff = sr.final_results.images.img2_hr_diff_final{j};
    n_data2 = 1; 
    mask_data2_hr = sr.mask.mask_data1_hr; 
    
    % ---- spatial autocorrelation score using moran's I (or geary contiguity ratio?)
    morans0 = zeros(size(data2_hr_diff));
    size_morans_grid = 3;
    for i=1:n_data2,  morans0(:,:,i) = super_resolution_function_morans_I(data2_hr_diff(:,:,i),ones(size_morans_grid,size_morans_grid));  end
    morans_vect0 = cell(1,n_data2); morans_vect1 = cell(1,n_data2);
    for i=1:n_data2
        aa = morans0(:,:,i);  morans_vect0{i} = aa(mask_data2_hr);
        morans_notnan = ~isnan(morans_vect0{i});
        if (sum(morans_notnan)==0),  morans_vect1{i} = zeros(size(morans_vect0{i})); 
        else
            morans_vect1{i} = morans_vect0{i}(morans_notnan);
        end
        clear aa;
    end 
    morans = cell2mat(morans_vect1);
    phi_sac_hr = mean(abs(morans),1);
    
   
    % ---- pattern reconstruction scoring score
    data2_hr_med = zeros(size(data2_hr)); data2_hr_sr_med = zeros(size(data2_hr_sr));
    for i=1:n_data2 
        data2_hr_med(:,:,i) = medfilt2(data2_hr(:,:,i));
        data2_hr_sr_med(:,:,i) = medfilt2(data2_hr_sr(:,:,i));
    end    
    data2_hr_med1 = cell(1,n_data2);  data2_hr_sr_med1 = cell(1,n_data2);
    for i=1:n_data2
        aa = data2_hr_med(:,:,i);         data2_hr_med1{i} = aa(mask_data2_hr);
        bb = data2_hr_sr_med(:,:,i);   data2_hr_sr_med1{i} = bb(mask_data2_hr);
        clear aa bb;
    end    
    data2_hr_med_corr = zeros(1,n_data2);
    for i=1:n_data2,  data2_hr_med_corr(i) = corr(data2_hr_med1{i},data2_hr_sr_med1{i});  end
    phi_prs_type = 1;
    switch phi_prs_type
        case 1,  phi_prs_hr = data2_hr_med_corr;
    end
           
    % ---- save in sr struct
    sr.final_results.statistics.sac_hr(j)  = phi_sac_hr;
    sr.final_results.statistics.prs_hr(j)  = phi_prs_hr;
        
end











