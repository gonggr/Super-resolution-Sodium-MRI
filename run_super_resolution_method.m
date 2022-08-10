% ==========================================================================
% script    : run_super_resolution_method
% --------------------------------------------------------------------------
% purpose   : generate a high resolution (HR)sodium image 
% input     : HR proton maps and low resolution (LR) sodium image  
% output    : HR resolution sodiun image
% comment   :
% reference : Gonzalo G Rodriguez,et al. A method to increase the resolution of sodium images 
%             from simultaneous 1H MRF/23Na MRI, ISMRM Annual Meeting, London, 2022.  
 
% --------------------------------------------------------------------------
% 2017/10 - guillaume.madelin@nyulangone.org
% 2022/07 - gonzalo.rodriguez@nyulangone.org
% ==========================================================================


%% - 1 - initialization

clear; clc; close all; 
disp(' '); disp(' run_super_resolution_method'); 
sr = struct;
t1 = tic;


%% - 2 -  preparation 

[sr] = super_resolution_prepare_parameters(sr); 

%% - 3 - data and slice selection                                          % this "for" super-resolve slice-by-slice

for j= sr.param.multiple_slice_init:sr.param.multiple_slice_end
        
    sr.param.slice = j;
    disp(['   Slice = ' num2str(j)]);

    [sr] = super_resolution_prepare_get_data(sr);                          % select input data
    [sr] = super_resolution_prepare_normalize_data(sr);
    [sr] = super_resolution_prepare_display_data(sr);

%% - 4 - iterative loop                                                   

    for i=1:sr.param.max_iter
    
        sr.param.num_iter = i;
        x =['   iter = ',num2str(i)]; disp(x);  
        
        if i == 1
            sr.param.transform_diff_mask = 0;
            condition_1 = 0.1;
            condition_2 = 0.1;
            condition_3 = 0.1;
            
        elseif i==2
            sr.param.transform_diff_mask = 1;
            condition_1 = 0.1;
            condition_2 = 0.1;
            condition_3 = 0.1;
            
        else
            sr.param.transform_diff_mask = 1;
            condition_1 = abs(sr.partial.result.ssim_lr{i-1}-sr.partial.result.ssim_lr{i-2});
            condition_2 = sr.partial.result.ssim_lr{i-1};
            condition_3 = abs(sr.partial.result.mean_lr{i-1});
        end
    
        if condition_1>sr.param.min_ssim_lr_grad || condition_2<sr.param.min_ssim_lr  || condition_3>sr.param.max_mean_diff_lr              % stop criterion 
      
    
        % ---- transformation
    
            [sr] = super_resolution_transform_data1_diff_mask(sr);
            [sr] = super_resolution_transform_data1_filter(sr);
            [sr] = super_resolution_transform_data2_filter(sr);

        % ---- mapping 

            [sr] = super_resolution_map_data(sr);
            [sr] = super_resolution_map_data_repetitions(sr);


        % ---- cross-modality model

            [sr] = super_resolution_cross_model_pls_run(sr);
            [sr] = super_resolution_cross_model_compare(sr);

        % ---- intermediate results
        
            [sr] = super_resolution_intermediate_results(sr); 

        else
            sr.param.num_iter = i - 1;
        break
        end

    end
    
% ---- results

[sr] = super_resolution_final_results(sr); 
[sr] = super_resolution_evaluate_lr(sr);

    if (sr.param.ground_truth)
        [sr] = super_resolution_evaluate_hr(sr);
    end

end

%% - 5 - the end

disp(['   Total time [s] = ' num2str(toc(t1))]); clear t1;
disp('   done!');


%%