% ==========================================================================
% function  : super_resolution_prepare_normalize_data
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


function [sr] = super_resolution_prepare_normalize_data(sr)

        for i=1:sr.data.n_img1  
            sr.data.img1_hr_max(i) = max(abs( sr.data.img1_hr{i}(:)));
            sr.data.img1_hr{i} = sr.data.img1_hr{i}./sr.data.img1_hr_max(i);  
        end
        
        
        for i=1:sr.data.n_img2  
            sr.data.img2_lr_max(i) = max(abs( sr.data.img2_lr{i}(:)));
            sr.data.img2_lr{i} = sr.data.img2_lr{i}./sr.data.img2_lr_max(i);  
        end


end
