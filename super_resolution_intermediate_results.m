% ==========================================================================
% function  : super_resolution_intermediate_results(sr)
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


function [sr] = super_resolution_intermediate_results(sr)

n = sr.param.num_iter;

% ---- normalization     
sr.data.img2_lr_original{1} = sr.data.img2_lr_original{1}./max(sr.data.img2_lr_original{1}(:));
sr.data.img2_lr_original{1} = sr.data.img2_lr_original{1}.*sr.mask.mask_data2_lr;

% ---- convolution
switch sr.param.data_type
     case {'2D data' , '3D data'}
         
         sr.result.img2_lr_sr_conv{1} = convn(sr.result.img2_lr_sr{n},sr.data.PSF,'same');
         sr.result.img2_lr_sr_conv{1} = sr.result.img2_lr_sr_conv{1}./max(sr.result.img2_lr_sr_conv{1}(:));
         sr.result.img2_lr_sr_int{1} = sr.result.img2_lr_sr_conv{1}.*sr.mask.mask_data2_lr;
         
     case 'proton only data'
         
         sr.result.img2_lr_sr_int{1} =  sr.result.img2_lr_sr{n};
         sr.result.img2_lr_sr_int{1} =  sr.result.img2_lr_sr_int{1}./max(sr.result.img2_lr_sr_int{1}(:));
        
end

% ---- difference
sr.result.img2_lr_diff_int{1} = (sr.result.img2_lr_sr_int{1} - sr.data.img2_lr_original{1}).* sr.mask.mask_data2_lr;

% ---- statistical parameters
mean_lr = abs(mean(sr.result.img2_lr_diff_int{1}(sr.mask.mask_data2_lr)));
sr.partial.result.mean_lr{n} = mean_lr;
ssim_lr = ssim(sr.result.img2_lr_sr_int{1},sr.data.img2_lr_original{1});
sr.partial.result.ssim_lr{n} = ssim_lr;

if (sr.param.display_intermediate_results_lr)
    
    figure; sgtitle('Intermediate results - low resolution');  colormap gray; 
            subplot(1,3,1);  imagesc(sr.data.img2_lr_original{1}); axis image; title('Acquired ^{23}Na LR');
            subplot(1,3,2);  imagesc(abs(sr.result.img2_lr_sr_int{1})); axis image; title('Generated ^{23}Na LR');
            subplot(1,3,3);  imshow(abs(sr.result.img2_lr_diff_int{1}),[]); axis image; title('Difference LR');
end

end