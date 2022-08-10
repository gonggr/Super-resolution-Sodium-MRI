% ==========================================================================
% function  : super_resolution_transform_data1_filter
% --------------------------------------------------------------------------
% purpose   : put all data1 together  
% input     : struct sr
% output    : struct sr
% comment   :
% reference :   
% --------------------------------------------------------------------------
% 2017/10 - guillaume.madelin@nyulangone.org
% 2020/07 - gonzalo.rodriguez@nyulangone.org
% ==========================================================================


function [sr] = super_resolution_transform_data1_filter(sr)

    % ---- get data
    if sr.param.transform_diff_mask == 0
       d0 = sr.data.img1_hr;
    else
       d0 = sr.data.data1_diff_mask;
    end
    n_d0 = length(d0);
   
    d1 = d0;
    sr.data.n_transform_filter_data1 = size(d1{1},3);
    
    % ---- combine all data together
    d1_all = [];
    for i=1:n_d0
        d1_all = cat(3,d1_all,d1{i});  
    end 
    n_d1_all = size(d1_all,3);

    % ---- save in sr struct
    sr.data.data1 = d1_all;
    sr.data.n_data1 = n_d1_all;

end


