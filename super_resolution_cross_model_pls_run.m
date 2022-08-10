% ==========================================================================
% function  : super_resolution_cross_modality_model_simple_run
% --------------------------------------------------------------------------
% purpose   : run PLS algorithm  
% input     : struct sr
% output    : struct sr
% comment   :
% reference :   
% --------------------------------------------------------------------------
% 2017/10 - guillaume.madelin@nyulangone.org
% 2022/07 - gonzalo.rodriguez@nyulangone.org
% ==========================================================================


function [sr] = super_resolution_cross_model_pls_run(sr)

    % ---- run regression
    switch sr.param.regression_type
        
        case 'pls'
            
            % ---- initialize pls parameters
            n_pls_components = sr.param.pls_n_pls_components+ floor(sqrt(sr.param.num_iter-1));
            k_fold = sr.param.pls_k_fold;
            monte_carlo_repetitions = sr.param.pls_monte_carlo_repetitions;

            % ---- initialize data
            x = sr.data.data1_map_rep; 
            y = sr.data.data2_map_rep;

            % ---- remove nan and inf
            x(isinf(x)) = 0; x(isnan(x)) = 0;
            y(isinf(y)) = 0; y(isnan(y)) = 0;

            % ---- pls regression
            tic; 
            if (sr.param.pls_resubstitution)
                cv = 'resubstitution';  
                monte_carlo_repetitions = 1;
            else
                cv = k_fold;
            end
            [xl,yl,xs,ys,beta,pctvar,mse,stats] = plsregress(x,y,n_pls_components,'cv',cv,'mcreps',monte_carlo_repetitions);
            y_fit0 = [ones(size(x,1),1) x]*beta;
            y_residuals = y - y_fit0;
                        
            % ---- mask
            mask_lr_map = sr.mask.mask_data2_lr_map;
            [x_mask,y_mask] = find(mask_lr_map);    
            n_mask = length(find(mask_lr_map));

             y_fit = y_fit0;
             
            % ---- data2 vector -> image (only mask pixels)
            data2_map_fit = zeros(size(sr.data.data2_map));
            for i=1:sr.data.n_data2
                for j=1:n_mask
                    data2_map_fit(x_mask(j),y_mask(j),i) = y_fit(j,i);            
                end
            end            
         
            % ---- sr data2 high resolution result -> select only original images of interest (not the transforms)
            n_data2_transf = sr.data.n_transform_filter_data2;
            img2_hr_sr = cell(1,sr.data.n_img2);
            for i=1:sr.data.n_img2
                img2_hr_sr{i} = squeeze(data2_map_fit(:,:,n_data2_transf*(i-1)+1)).*mask_lr_map;
            end
                  
            % ---- sr data2 high resolution result -> select all images (included the transforms)
            n_data2_transf = sr.data.n_data2;
            img2_hr_sr_all = cell(1,sr.data.n_transform_filter_data2);
            for i=1:n_data2_transf
                img2_hr_sr_all{i} = squeeze(data2_map_fit(:,:,i)).*mask_lr_map;
            end
            
            % ---- save pls results in sr struct
            sr.regression.type = sr.param.regression_type;                
            sr.regression.pls.resubstitution = sr.param.pls_resubstitution;                    
            sr.regression.pls.n_pls_components = sr.param.pls_n_pls_components;                  
            sr.regression.pls.k_fold = sr.param.pls_k_fold;                    
            sr.regression.pls.monte_carlo_repetitions = sr.param.pls_monte_carlo_repetitions;                    

            sr.model.pls.x = x;
            sr.model.pls.y = y;
            sr.model.pls.y_fit0 = y_fit0;
            sr.model.pls.y_fit = y_fit;
            sr.model.pls.y_residuals = y_residuals;
            sr.model.pls.xl = xl;
            sr.model.pls.yl = yl;
            sr.model.pls.xs = xs;
            sr.model.pls.ys = ys;
            sr.model.pls.beta = beta;
            sr.model.pls.pctvar = pctvar;
            sr.model.pls.mse = mse;
            sr.model.pls.stats = stats;
            sr.model.pls.cv = cv;
            sr.model.pls.data2_map_fit = data2_map_fit;
            
            sr.result.data2_hr_sr = data2_map_fit;
            sr.result.img2_hr_sr = img2_hr_sr;
            sr.result.data2_hr_sr_all = img2_hr_sr_all; %%% all images
                        
        otherwise
            error('unknown regression type');
            
    end

end




