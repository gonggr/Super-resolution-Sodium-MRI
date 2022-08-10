% ==========================================================================
% function  : super_resolution_transform_data1_diff_mask(sr)
% --------------------------------------------------------------------------
% purpose   : Create masks for data1  
% input     : struct sr
% output    : struct sr
% comment   :
% reference :   
% --------------------------------------------------------------------------
% 2017/10 - guillaume.madelin@nyulangone.org
% 2022/07 - gonzalo.rodriguez@nyulangone.org
% ==========================================================================


function [sr] = super_resolution_transform_data1_diff_mask(sr)

    if (sr.param.transform_diff_mask)
        % ---- get data    
        data_previous = sr.data.data1;
        n_dprevious = length(data_previous(1,1,:));
        data0 = sr.data.img1_hr;
        n_d0 = length(data0);  
        n_d02 = sr.data.n_img2;
        iter = sr.param.num_iter-1;
        mask0 = sr.mask.mask_data1_hr;
        diff_mask = sr.result.img2_lr_diff;
        img_lr_deconv = sr.data.img2_lr_original;
        mask2_hr = cell(n_d02);
        mask2_lr = cell(n_d02);
    
        if iter<5
           % ---- k_means filter
            switch sr.param.data_type
                case {'2D data', '3D data'}
                    k=3;
                    for i=1:n_d02
                         a = int16(img_lr_deconv{i}.*10000);
                         L = imsegkmeans(a,k);
                         mask2_lr{i}=(L==iter-1);
                         mask2_hr{i} = fft_resize_hr(sr.param.original_hr_size_x,sr.param.original_hr_size_y,mask2_lr{i}); 
                         mask2_hr{i} = mask2_hr{i}.* mask0 ;
                         mask2_hr{i} = mask2_hr{i}./max(mask2_hr{i}(:));
                         t =  graythresh(mask2_hr{i});
                         mask2_hr{i} = imbinarize(mask2_hr{i},t.*0.9);
                         mask2_hr{i} = logical(mask2_hr{i});
                     end   
                      
                 case 'proton only data' 
                     k=4;
                     for i=1:n_d02
                         a = int16(img_lr_deconv{i}.*10000);
                         L = imsegkmeans(a,k);
                         mask2_lr{i}=(L==iter-1);
                         mask2_hr{i} = imresize(mask2_lr{i}, [sr.param.original_hr_size_x sr.param.original_hr_size_y],'bilinear'); 
                     end  
            end 
            
         else
          % ---- diff_filter
             k=3;   
             for i=1:n_d02
                 a = diff_mask{i};
                 a = a.*imbinarize(a./max(a(:)),0.00); 
                 a =int16(a.*10000); 
                 L = imsegkmeans(a,k);                                     % kmeans used as filter
                 mask2_lr{i}=(L==2);
                 mask2_lr{i}=double(mask2_lr{i});
                 switch sr.param.data_type
                     case {'2D data', '3D data'}
                        mask2_hr{i} = fft_resize_hr(sr.param.original_hr_size_x,sr.param.original_hr_size_y,mask2_lr{i}); 
                        mask2_hr{i} = mask2_hr{i}.* mask0 ;
                        mask2_hr{i} = mask2_hr{i}./max(mask2_hr{i}(:));
                        t =  graythresh(mask2_hr{i});
                        mask2_hr{i} = imbinarize(mask2_hr{i},t.*0.9);
                        mask2_hr{i} = logical(mask2_hr{i});
                     case 'proton only data'
                        mask2_hr{i} = imresize(mask2_lr{i}, [sr.param.original_hr_size_x sr.param.original_hr_size_y],'bilinear');   
                 end
             end
         end
            
       % ---- initialize counter    
       n = 1; 
        
       % ---- original previous data
       for i=1:n_dprevious
           data1{n} = double(data_previous(:,:,i));   n = n+1;             %#ok
       end
         
       % ---- apply diff mask 
       data1_dif = cell(n_d0);
       for j = 1:(n_d0)
           a = data0{j}.*mask0;
             for i = 1:n_d02
                 data1_dif{i} = mask2_hr{i}.*a;
                 data1{n} = data1_dif{i}; n = n+1;
             end
       end

    % ---- save in sr struct
    sr.data.data1_diff_mask = data1;
             
    end
end


