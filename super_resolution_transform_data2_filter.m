% ==========================================================================
% function  : super_resolution_transform_data2_filter
% --------------------------------------------------------------------------
% purpose   : put all data2 together    
% input     : struct sr
% output    : struct sr
% comment   :
% reference :   
% --------------------------------------------------------------------------
% 2017/10 - guillaume.madelin@nyulangone.org
% 2020/07 - gonzalo.rodriguez@nyulangone.org
% ==========================================================================


function [sr] = super_resolution_transform_data2_filter(sr)

    % ---- get data
    iter= sr.param.num_iter;
   
    if iter==1
        d0 = sr.data.img2_lr;
    else
       % ---- addition of previous results
        d0 = sr.data.img2_lr;
        img2_lr_sr = sr.result.img2_lr_sr;  
        n_d0 = length(d0);
        n_sr = length(img2_lr_sr);
       
       % ---- init counter
        n=1;
        for i = 1:n_d0
            d0{n} = d0{i};n=n+1;
        end
        for i = 1:n_sr
            d0{n} = img2_lr_sr{i};n=n+1;
        end

    end
    
   n_d0 = length(d0);
   d1 = d0;    
   sr.data.data22 = d1;                                                    % save for iteration
   sr.data.n_transform_filter_data2 = size(d1{1},3);
   
   % ---- combine all data together and multiply by mask
   d1_all = [];
   for i=1:n_d0
       d1_all = cat(3,d1_all,d1{i});  
   end
   n_d1_all = size(d1_all,3);

    % ---- save in sr struct
    sr.data.data2 = d1_all;
    sr.data.n_data2 = n_d1_all;
 
end


