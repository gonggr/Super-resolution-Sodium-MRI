% ==========================================================================
% function  : super_resolution_cross_data_type_model_simple_compare
% --------------------------------------------------------------------------
% purpose   : compare generated LR with acquired LR  
% input     : struct sr
% output    : struct sr
% comment   :
% reference :   
% --------------------------------------------------------------------------
% 2017/10 - guillaume.madelin@nyulangone.org
% 2022/07 - gonzalo.rodriguez@nyulangone.org
% ==========================================================================


function [sr] = super_resolution_cross_model_compare(sr)
    
    % ---- get data
    img2_lr = sr.data.img2_lr;
    img2_hr_sr = sr.result.img2_hr_sr;
    n_img2 = sr.data.n_img2;
    
    % ---- image sr lr 
    img2_lr_sr = cell(n_img2);
    for i=1:n_img2
        switch sr.param.data_type
             case {'2D data' , '3D data'}
                % ---- fft recized
                img2_lr_sr{i} = fft_resize_lr(sr.param.original_lr_size_x,sr.param.original_lr_size_y,img2_hr_sr{i});
                img2_lr_sr{i} = img2_lr_sr{i}./max(img2_lr{i}(:));  
            case 'proton only data'
                img2_lr_sr{i} = imresize(img2_hr_sr{i},[sr.param.original_lr_size_x sr.param.original_lr_size_y],'bilinear');
        end          
    end
    
    % ---- dif lr 
    img2_lr_diff = cell(n_img2);
    for i=1:n_img2     
        img2_lr_diff{i} = (img2_lr{i} - img2_lr_sr{i}).*sr.mask.mask_data2_lr; 
    end
    
    % ---- save in sr struct
    n=sr.param.num_iter;
    sr.result.img2_lr_sr{n} = img2_lr_sr{1}; 
    sr.result.img2_lr_diff = img2_lr_diff; 

end
