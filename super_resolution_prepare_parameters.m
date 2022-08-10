% ==========================================================================
% function  : super_resolution_prepare_parameters
% --------------------------------------------------------------------------
% purpose   : configurate parameters  
% input     : struct sr
% output    : struct sr
% comment   :
% reference :   
% --------------------------------------------------------------------------
% 2017/10 - guillaume.madelin@nyulangone.org
% 2022/07 - gonzalo.rodriguez@nyulangone.org
% ==========================================================================

function [sr] = super_resolution_prepare_parameters(sr)
    % ---- modality
    sr.param.data_type                                  = '3D data';            % [2D data, 3D data, proton only data]

    switch sr.param.data_type
    
        case '2D data'
            
            % ---- original in-plane low resolution size
            sr.param.original_lr_size_x                 = 42;                   % original size of x direction in LR image
            sr.param.original_lr_size_y                 = 42;                   % original size of y direction in LR image
       
            % ---- slice selection                                                
            % if sr.param.multiple_slice_init = sr.param.multiple_slice_end only one slice is super-resolved 
            sr.param.multiple_slice_init                = 1;                    % first slice to apply super_resolution method
            sr.param.multiple_slice_end                 = 1;                    % last slice to apply super_resolution method
        
        case '3D data'
       
            % ---- original in-plane low resolution size
            sr.param.original_lr_size_x                 = 84;                   % original size of x direction in LR image
            sr.param.original_lr_size_y                 = 84;                   % original size of y direction in LR image
      
            % ---- slice selection  
            % if sr.param.multiple_slice_init = sr.param.multiple_slice_end only one slice is super-resolved                                                             
            sr.param.multiple_slice_init                = 28;                   % first slice to apply super_resolution method
            sr.param.multiple_slice_end                 = 28;                   % last slice to apply super_resolution method
   
        case 'proton only data'
      
            % ---- original in-plane low resolution size
            sr.param.original_lr_size_x                 = 120;                  % original size of x direction in LR image
            sr.param.original_lr_size_y                 = 120;                  % original size of y direction in LR image
      
            % ---- slice selection                                                
            % if sr.param.multiple_slice_init = sr.param.multiple_slice_end only one slice is super-resolved
            sr.param.multiple_slice_init                = 78;                   % first slice to apply super_resolution method
            sr.param.multiple_slice_end                 = 78;                   % last slice to apply super_resolution method
    end
    
    % ---- ground truth
    sr.param.ground_truth                               = 1;                    % [0,1]=[no,yes] ground truth sodium HR    
        
    % ---- display data
    sr.param.display_original_data                      = 1;                    % [0,1]=[no,yes]
    sr.param.display_initial_deconvolved_data           = 0;                    % [0,1]=[no,yes]
    sr.param.display_intermediate_results_lr            = 0;                    % [0,1]=[no,yes]
    sr.param.display_final_results                      = 1;                    % [0,1]=[no,yes]
    
    % ---- iterative loop constrain
    sr.param.max_iter                                   = 30;                   % max iteration
    sr.param.min_ssim_lr                                = 0.98;                 % min ssim_lr to stop the iterations
    sr.param.min_ssim_lr_grad                           = 0.001;                % min gradient in ssim_lr to stop the iterations
    sr.param.max_mean_diff_lr                           = 0.025;                % max mean difference to stop the iterations
    
    % ---- cross-modality - PLS regression    
    sr.param.regression_type                            = 'pls';                % ['pls']
    sr.param.pls_resubstitution                         = 0;                    % [0,1]=[no,yes] 
    sr.param.pls_n_pls_components                       = 3;                    % []
    sr.param.pls_k_fold                                 = 10;                   % [] 
    sr.param.pls_monte_carlo_repetitions                = 5;                    % []

end





