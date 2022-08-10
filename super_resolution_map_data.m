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


function [sr] = super_resolution_map_data(sr)

    % ---- mask
    sr.mask.mask_data2_lr_map = logical(sr.mask.mask_data1_hr);
    
    % ---- data2 mapping onto data1 (same size)
    resolution_ratio = sr.param.resolution_ratio;
    data2_map = zeros(size(sr.data.data2,1)*resolution_ratio,size(sr.data.data2,2)*resolution_ratio,size(sr.data.data2,3));
    for i=1:sr.data.n_data2
        switch sr.param.data_type
             case {'2D data' , '3D data'}
                % ---- fft resized
                data2_map(:,:,i) = fft_resize_hr(sr.param.original_hr_size_x,sr.param.original_hr_size_y,sr.data.data2(:,:,i)); 
            case 'proton only data'
                data2_map(:,:,i) = imresize(sr.data.data2(:,:,i),[sr.param.original_hr_size_x sr.param.original_hr_size_y],'bilinear'); 
        end
        data2_map(:,:,i) = data2_map(:,:,i).*sr.mask.mask_data2_lr_map; 
    end
        
    % ---- save in sr struct
    sr.data.data2_map = data2_map;
    
end


