% ==========================================================================
% function  : super_resolution_final_results
% --------------------------------------------------------------------------
% purpose   : show and save final results  
% input     : struct sr
% output    : struct sr
% comment   :
% reference :   
% --------------------------------------------------------------------------
% 2017/10 - guillaume.madelin@nyulangone.org
% 2022/07 - gonzalo.rodriguez@nyulangone.org
% ==========================================================================


function [sr] = super_resolution_final_results(sr)

n = sr.param.num_iter;

switch sr.param.data_type
    
    case '2D data'
        
         j=1;
         
         % ---- normalization    
         sr.data.img2_lr_original{1} = sr.data.img2_lr_original{1}./max(sr.data.img2_lr_original{1}(:));
         sr.data.img2_lr_original{1} = sr.data.img2_lr_original{1}.*sr.mask.mask_data2_lr;
         sr.data.img2_lr_original{1} = rot90(rot90(sr.data.img2_lr_original{1}));
         
         if (sr.param.ground_truth)
            sr.data.img2_hr_original{1} = sr.data.img2_hr_original{1}./max(sr.data.img2_hr_original{1}(:));
            sr.data.img2_hr_original{1} = sr.data.img2_hr_original{1}.*sr.mask.mask_data1_hr_final;
            sr.data.img2_hr_original{1} = rot90(rot90(sr.data.img2_hr_original{1}));
         end
        
         % ---- convolution
         sr.result.img2_lr_sr_conv{1} = convn(sr.result.img2_lr_sr{n},sr.data.PSF,'same');
         sr.result.img2_lr_sr_conv{1} = sr.result.img2_lr_sr_conv{1}./max(sr.result.img2_lr_sr_conv{1}(:));
         sr.result.img2_lr_sr_final{1} = sr.result.img2_lr_sr_conv{1}.*sr.mask.mask_data2_lr;
         sr.result.img2_lr_sr_final{1} = rot90(rot90(sr.result.img2_lr_sr_final{1}));

         sr.result.img2_hr_sr_conv{1} = convn(sr.result.img2_hr_sr{1},sr.data.PSF_Na_HR,'same');
         sr.result.img2_hr_sr_conv{1} = sr.result.img2_hr_sr_conv{1}./max(sr.result.img2_hr_sr_conv{1}(:));
         sr.result.img2_hr_sr_final{1} = sr.result.img2_hr_sr_conv{1}.*sr.mask.mask_data1_hr_final;
         sr.result.img2_hr_sr_final{1} = rot90(rot90(sr.result.img2_hr_sr_final{1}));
                  
         % ---- difference
         sr.result.img2_lr_diff_final{1} = (sr.result.img2_lr_sr_final{1} - sr.data.img2_lr_original{1}).* rot90(rot90(sr.mask.mask_data2_lr));
         if (sr.param.ground_truth)
         sr.result.img2_hr_diff_final{1} = (sr.result.img2_hr_sr_final{1} - sr.data.img2_hr_original{1}).*rot90(rot90(sr.mask.mask_data1_hr_final));
         end
         
    case'3D data' 
        
         j= 1 + sr.param.slice - sr.param.multiple_slice_init;
         
         % ---- normalization    
         sr.data.img2_lr_original{1} = sr.data.img2_lr_original{1}./max(sr.data.img2_lr_original{1}(:));
         sr.data.img2_lr_original{1} = sr.data.img2_lr_original{1}.*sr.mask.mask_data2_lr;

         if (sr.param.ground_truth)
          sr.data.img2_hr_original{1} = sr.data.img2_hr_original{1}./max(sr.data.img2_hr_original{1}(:));
          sr.data.img2_hr_original{1} = sr.data.img2_hr_original{1}.*sr.mask.mask_data1_hr_final;
         end
        
         % ---- convolution
         sr.result.img2_lr_sr_conv{1} = convn(sr.result.img2_lr_sr{n},sr.data.PSF,'same');
         sr.result.img2_lr_sr_conv{1} = sr.result.img2_lr_sr_conv{1}./max(sr.result.img2_lr_sr_conv{1}(:));
         sr.result.img2_lr_sr_final{1} = sr.result.img2_lr_sr_conv{1}.*sr.mask.mask_data2_lr;

         sr.result.img2_hr_sr_conv{1} = convn(sr.result.img2_hr_sr{1},sr.data.PSF_Na_HR,'same');
         sr.result.img2_hr_sr_conv{1} = sr.result.img2_hr_sr_conv{1}./max(sr.result.img2_hr_sr_conv{1}(:));
         sr.result.img2_hr_sr_final{1} = sr.result.img2_hr_sr_conv{1}.*sr.mask.mask_data1_hr_final;
         
         
         % ---- difference
         sr.result.img2_lr_diff_final{1} = (sr.result.img2_lr_sr_final{1} - sr.data.img2_lr_original{1}).* sr.mask.mask_data2_lr;
         if (sr.param.ground_truth)
         sr.result.img2_hr_diff_final{1} = (sr.result.img2_hr_sr_final{1} - sr.data.img2_hr_original{1}).*sr.mask.mask_data1_hr_final;
         end
         
    case 'proton only data'
        j= 1 + sr.param.slice - sr.param.multiple_slice_init;
        
        % ---- normalization    
        sr.data.img2_lr_original{1} = sr.data.img2_lr_original{1}./max(sr.data.img2_lr_original{1}(:));
        sr.data.img2_lr_original{1} = sr.data.img2_lr_original{1}.*sr.mask.mask_data2_lr;
        
        if (sr.param.ground_truth)
         sr.data.img2_hr_original{1} = sr.data.img2_hr_original{1}./max(sr.data.img2_hr_original{1}(:));
         sr.data.img2_hr_original{1} = sr.data.img2_hr_original{1}.*sr.mask.mask_data1_hr_final;
        end
        
        sr.result.img2_lr_sr_final{1} =  sr.result.img2_lr_sr{n};
        sr.result.img2_hr_sr_final{1} =  sr.result.img2_hr_sr{1}./max(sr.result.img2_hr_sr{1}(:));
        
        
        % ---- difference
        sr.result.img2_lr_diff_final{1} = (sr.result.img2_lr_sr_final{1} - sr.data.img2_lr_original{1}).* sr.mask.mask_data2_lr;
        if (sr.param.ground_truth)
            sr.result.img2_hr_diff_final{1} = (sr.result.img2_hr_sr_final{1} - sr.data.img2_hr_original{1}).*sr.mask.mask_data1_hr_final;
        end
        
end


% ---- statistical parameters
mean_lr = abs(mean(sr.result.img2_lr_diff_final{1}(sr.mask.mask_data2_lr)));
std_lr = std(sr.result.img2_lr_diff_final{1}(sr.mask.mask_data2_lr));
ssim_lr = ssim(sr.result.img2_lr_sr_final{1},sr.data.img2_lr_original{1});
multi_ssim_lr = multissim(sr.result.img2_lr_sr_final{1},sr.data.img2_lr_original{1});

if (sr.param.ground_truth)
    mean_hr = abs(mean(sr.result.img2_hr_diff_final{1}(sr.mask.mask_data1_hr_final)));
    std_hr = std(sr.result.img2_hr_diff_final{1}(sr.mask.mask_data1_hr_final));
    ssim_hr = ssim(sr.result.img2_hr_sr_final{1},sr.data.img2_hr_original{1});
    multi_ssim_hr = multissim(sr.result.img2_hr_sr_final{1},sr.data.img2_hr_original{1});
end

% ---- save in sr struct
sr.final_results.images.img2_lr_original{j}     = sr.data.img2_lr_original{1};
sr.final_results.images.img2_lr_sr_final{j}     = sr.result.img2_lr_sr_final{1};
sr.final_results.images.img2_lr_diff_final{j}   = sr.result.img2_lr_diff_final{1};
sr.final_results.statistics.mean_lr(j)          = mean_lr;
sr.final_results.statistics.std_lr(j)           = std_lr;
sr.final_results.statistics.ssim_lr(j)          = ssim_lr;
sr.final_results.statistics.multi_ssim_lr(j)    = multi_ssim_lr;
sr.final_results.statistics.max_num_iter(j)     = sr.param.num_iter;


if (sr.param.ground_truth)
sr.final_results.images.img2_hr_original{j}     = sr.data.img2_hr_original{1};
sr.final_results.images.img2_hr_sr_final{j}     = sr.result.img2_hr_sr_final{1};
sr.final_results.images.img2_hr_diff_final{j}   = sr.result.img2_hr_diff_final{1};
sr.final_results.statistics.mean_hr(j)          = mean_hr;
sr.final_results.statistics.std_hr(j)           = std_hr;
sr.final_results.statistics.ssim_hr(j)          = ssim_hr;
sr.final_results.statistics.multi_ssim_hr(j)    = multi_ssim_hr;
end

% ---- display results
if (sr.param.display_final_results)    
    if (sr.param.ground_truth)
    figure; sgtitle('Final results'); colormap gray; 
                subplot(2,3,1);  imshow(sr.final_results.images.img2_hr_original{j}); axis image; title('Ground truth');
                subplot(2,3,2);  imshow(abs(sr.final_results.images.img2_hr_sr_final{j})); axis image; title('Generated ^{23}Na - HR');
                subplot(2,3,3);  imshow(abs(sr.final_results.images.img2_hr_diff_final{j})); axis image; title('Difference - HR');
                subplot(2,3,4);  imshow(sr.final_results.images.img2_lr_original{j}); axis image; title('Acquired Na - LR');
                subplot(2,3,5);  imshow(abs(sr.final_results.images.img2_lr_sr_final{j})); axis image; title('Generated ^{23}Na - LR');
                subplot(2,3,6);  imshow(abs(sr.final_results.images.img2_lr_diff_final{j}),[]); axis image; title('Difference - LR');
    else
    figure; sgtitle('Final results'); colormap gray; 
                subplot(2,3,2);  imshow(abs(sr.final_results.images.img2_hr_sr_final{j})); axis image; title('Generated ^{23}Na - HR');
                subplot(2,3,4);  imshow(sr.final_results.images.img2_lr_original{j}); axis image; title('Acquired ^{23}Na - LR');
                subplot(2,3,5);  imshow(abs(sr.final_results.images.img2_lr_sr_final{j})); axis image; title('Generated ^{23}Na - LR');
                subplot(2,3,6);  imshow(abs(sr.final_results.images.img2_lr_diff_final{j}),[]); axis image; title('Difference - LR');    
    end
end

end