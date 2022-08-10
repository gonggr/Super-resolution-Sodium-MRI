% ==========================================================================
% function  : super_resolution_prepare_get_data
% --------------------------------------------------------------------------
% purpose   : load and prepare initial data   
% input     : struct sr
% output    : struct sr
% comment   :
% reference :   
% --------------------------------------------------------------------------
% 2017/10 - guillaume.madelin@nyulangone.org
% 2022/07 - gonzalo.rodriguez@nyulangone.org
% ==========================================================================

function [sr] = super_resolution_prepare_get_data(sr)
           
 % ---- load data 
 switch sr.param.data_type
    
       case '2D data'
            
            sr.data.folder_psf = 'PSF\';                                           % PSF folder
            load([sr.data.folder_psf 'PSF_Na_LR.mat'],'PSF_Na_LR');                % PSF sodium LR
            load([sr.data.folder_psf 'PSF_H.mat'],'PSF_H');                        % PSF protons HR
            load([sr.data.folder_psf 'PSF_Na_HR.mat'],'PSF_Na_HR');                % PSF sodium HR

            sr.data.folder_data = '2D simultaneous\Data1\';                        % data folder
            v1_1 = double(niftiread([sr.data.folder_data 'PD_2D.nii']));           % proton density HR
            v1_2 = double(niftiread([sr.data.folder_data 'T1_2D.nii']));           % T1 HR
            v1_3 = double(niftiread([sr.data.folder_data 'T2_2D.nii']));           % T2 HR
            v2_1 = double(niftiread([sr.data.folder_data 'Na_lr_2D.nii']));        % corregistered Na LR
            if (sr.param.ground_truth)
                v3_1 = double(niftiread([sr.data.folder_data 'Na_hr_2D.nii']));    % corregistered Na HR
            end
            
            % ---- matrix sizes 
            [size_x,size_y] = size(squeeze(v1_1(1,:,:)));
            sr.param.original_hr_size_x = size_x;
            sr.param.original_hr_size_y = size_y;
            size_x_na = sr.param.original_lr_size_x ;
            sr.param.resolution_ratio = size_x/size_x_na;
            sl = sr.param.slice; 
            
            % ---- PSF 
            PSF = squeeze(PSF_Na_LR(sl,:,:));
            PSF = PSF./sum(PSF(:));
            sr.data.PSF = PSF;
           
            PSF_H_2D = PSF_H(2:10,2:10);
            PSF_H_2D = PSF_H_2D./sum(PSF_H_2D(:)); 
            sr.data.PSF_H_2D = PSF_H_2D;
           
            PSF_Na_HR = PSF_Na_HR./sum( PSF_Na_HR(:)); 
            sr.data.PSF_Na_HR = PSF_Na_HR;
            
            % ---- HR pronton images     
            v1_1 = (squeeze(v1_1(sl,:,:)));
            v1_2 = (squeeze(v1_2(sl,:,:)));
            v1_3 = (squeeze(v1_3(sl,:,:)));
            
            v1_1(isnan(v1_1)) = 0;
            v1_2(isnan(v1_2)) = 0;
            v1_3(isnan(v1_3)) = 0;
            
            % ---- HR data deconvolution
            v1_1_dconv = deconvlucy(v1_1,PSF_H_2D);                              % data deconvolved by PSF
            v1_2_dconv = deconvlucy(v1_2,PSF_H_2D);                              % data deconvolved by PSF
            v1_3_dconv = deconvlucy(v1_3,PSF_H_2D);                              % data deconvolved by PSF
            
            % ---- LR Na image 
            v2_1 = (squeeze(v2_1(sl,:,:)));
            v2_1(isnan(v2_1)) = 0;
            v2_1_dconv = deconvlucy(v2_1,PSF);                                    % data deconvolved by PSF
            
            if (sr.param.ground_truth)  
            % ---- HR Na image 
                v3_1 = (squeeze(v3_1(sl,:,:)));
                v3_1(isnan(v3_1)) = 0;
                v3_1_dconv = deconvlucy(v3_1,PSF);                               % data deconvolved by PSF  
            end
            
            % ---- HR mask created from v1_1  
            t = graythresh(v1_1/max(v1_1(:)));
            mask = imbinarize(v1_1/max(v1_1(:)), t.*0.6);
            mask_hr = mask;
            sr.mask.mask_data1_hr = logical(mask_hr);                             % mask_hr used along the method
            sr.mask.mask_data1_hr_final = logical(mask);                          % final mask_hr to show clean results
          
            % ---- LR mask
            mask_lr = fft_resize_lr(sr.param.original_lr_size_x,sr.param.original_lr_size_y,mask_hr);
            mask_lr = mask_lr./max(mask_lr(:));
            t =  graythresh(mask_lr);
            mask_lr = imbinarize(mask_lr,t.*0.9);    
            sr.mask.mask_data2_lr = logical(mask_lr);
        
            % ---- save original and deconvolved data 
            sr.data.img1_hr_original{1} = v1_1.*mask_hr;
            sr.data.img1_hr_original{2} = v1_2.*mask_hr;
            sr.data.img1_hr_original{3} = v1_3.*mask_hr;
               
            sr.data.img1_hr{1} = v1_1_dconv.*mask_hr;
            sr.data.img1_hr{2} = v1_2_dconv.*mask_hr;
            sr.data.img1_hr{3} = v1_3_dconv.*mask_hr;
            
            sr.data.n_img1 = length(sr.data.img1_hr);
            
            sr.data.img2_lr_original{1} = v2_1.*mask_lr;
            sr.data.img2_lr{1} = v2_1_dconv.*mask_lr;
            
            sr.data.n_img2 = length(sr.data.img2_lr);
            
            if (sr.param.ground_truth)
            % ---- save original and deconvolved Na high resolution
             sr.data.img2_hr_original{1} = v3_1.*mask_hr;
             sr.data.img2_hr{1} = v3_1_dconv.*mask_hr;
            end
            
        case '3D data'   
             
            sr.data.folder_psf = 'PSF\';                                           % PSF folder
            load([sr.data.folder_psf 'PSF_Na_LR.mat'],'PSF_Na_LR');                % PSF sodium LR
            load([sr.data.folder_psf 'PSF_H.mat'],'PSF_H');                        % PSF protons HR
            load([sr.data.folder_psf 'PSF_Na_HR.mat'],'PSF_Na_HR');                % PSF sodium HR
    
            sr.data.folder_data = '3D simultaneous\Data1\';                        % data folder
            v1_1 = double(niftiread([sr.data.folder_data 'PD.nii']));              % proton density HR
            v1_2 = double(niftiread([sr.data.folder_data 'T1.nii']));              % T1 HR
            v1_3 = double(niftiread([sr.data.folder_data 'T2.nii']));              % T2 HR
            v2_1 = double(niftiread([sr.data.folder_data 'rNa_lr.nii']));          % corregistered Na LR
            if (sr.param.ground_truth)
                v3_1 = double(niftiread([sr.data.folder_data 'rNa_hr.nii']));      % corregistered Na HR
            end
            
            m1_1 = niftiread([sr.data.folder_data 'c1PD.nii']);                    % gray matter mask from SPM
            m1_2 = niftiread([sr.data.folder_data 'c2PD.nii']);                    % white matter mask from SPM
            m1_3 = niftiread([sr.data.folder_data 'c3PD.nii']);                    % CSF mask from SPM
            
            % ---- matrix sizes 
            [size_x,size_y] = size(squeeze(v1_1(1,:,:)));
            sr.param.original_hr_size_x = size_x;
            sr.param.original_hr_size_y = size_y;
            size_x_na = sr.param.original_lr_size_x ;
            sr.param.resolution_ratio = size_x/size_x_na;
            sl = sr.param.slice; 
            
            % ---- PSF 
            PSF = squeeze(PSF_Na_LR(sl,:,:));
            PSF = PSF./sum(PSF(:));
            sr.data.PSF = PSF;
           
            PSF_H_2D = PSF_H(2:10,2:10);
            PSF_H_2D = PSF_H_2D./sum(PSF_H_2D(:)); 
            sr.data.PSF_H_2D = PSF_H_2D;
           
            PSF_Na_HR = PSF_Na_HR./sum( PSF_Na_HR(:)); 
            sr.data.PSF_Na_HR = PSF_Na_HR;
            
            % ---- HR pronton images
            v1_1 = flip(rot90(squeeze(v1_1(sl,:,:))),2);
            v1_2 = flip(rot90(squeeze(v1_2(sl,:,:))),2);
            v1_3 = flip(rot90(squeeze(v1_3(sl,:,:))),2);
            
            v1_1(isnan(v1_1)) = 0;
            v1_2(isnan(v1_2)) = 0;
            v1_3(isnan(v1_3)) = 0;
            
            % ---- HR data deconvolution
            v1_1_dconv = deconvlucy(v1_1,PSF_H_2D);                              % data deconvolved by PSF
            v1_2_dconv = deconvlucy(v1_2,PSF_H_2D);                              % data deconvolved by PSF
            v1_3_dconv = deconvlucy(v1_3,PSF_H_2D);                              % data deconvolved by PSF
            
            % ---- LR Na image 
            v2_1 = flip(rot90(squeeze(v2_1(sl,:,:))),2);
            v2_1(isnan(v2_1)) = 0;
            v2_1 = fft_resize_lr(sr.param.original_lr_size_x,sr.param.original_lr_size_y,v2_1); % data resized to original size
            v2_1_dconv = deconvlucy(v2_1,PSF);                                    % data deconvolved by PSF
            
            if (sr.param.ground_truth)  
            % ---- HR Na image 
            v3_1 = flip(rot90(squeeze(v3_1(sl,:,:))),2);
            v3_1(isnan(v3_1)) = 0;
            v3_1_dconv = deconvlucy(v3_1,PSF);                                    % data deconvolved by PSF  
            end
            
            %---- HR mask created from SPM segmentation 
            mask = m1_1 + m1_2 + m1_3;     
            mask = flip(rot90(squeeze(mask(sl,:,:))),2); 
            mask = double(mask);
            mask_b = imresize(imresize(mask,1/2,'bicubic'),2,'bicubic');
            mask_hr = mask_b;  
            sr.mask.mask_data1_hr = logical(mask_hr);                              % mask_hr used along the method
            
            t = graythresh(mask/max(mask(:)));
            mask = imgaussfilt(mask,1.1);
            mask = imbinarize(mask/max(mask(:)), t.*0.6);
            sr.mask.mask_data1_hr_final = logical(mask);                           % final mask_hr to show clean results
            
            % ---- LR mask 
            mask_lr = fft_resize_lr(sr.param.original_lr_size_x,sr.param.original_lr_size_y,mask_hr);
            mask_lr = imgaussfilt(mask_lr,1);
            mask_lr = mask_lr./max(mask_lr(:));
            t =  graythresh(mask_lr);
            mask_lr = imbinarize(mask_lr,t);   
            sr.mask.mask_data2_lr = logical(mask_lr);    
            
            % ---- save original and deconvolved data 
            sr.data.img1_hr_original{1} = v1_1.*mask_hr;
            sr.data.img1_hr_original{2} = v1_2.*mask_hr;
            sr.data.img1_hr_original{3} = v1_3.*mask_hr;
               
            sr.data.img1_hr{1} = v1_1_dconv.*mask_hr;
            sr.data.img1_hr{2} = v1_2_dconv.*mask_hr;
            sr.data.img1_hr{3} = v1_3_dconv.*mask_hr;
            
            sr.data.n_img1 = length(sr.data.img1_hr);
            
            sr.data.img2_lr_original{1} = v2_1.*mask_lr;
            sr.data.img2_lr{1} = v2_1_dconv.*mask_lr;
            
            sr.data.n_img2 = length(sr.data.img2_lr);
            
             if (sr.param.ground_truth)
            % ---- save original and deconvolved Na high resolution
             sr.data.img2_hr_original{1} = v3_1.*mask_hr;
             sr.data.img2_hr{1} = v3_1_dconv.*mask_hr;
            end

        case 'proton only data'
             
            sr.data.folder_data = '3D proton only\BraTS20_Training_001\';                          % data folder
            v1_1 = double(niftiread([sr.data.folder_data 'BraTS20_Training_001_flair.nii']));      % FLAIR HR
            v1_2 = double(niftiread([sr.data.folder_data 'BraTS20_Training_001_t1.nii']));         % T1 HR
            v1_3 = double(niftiread([sr.data.folder_data 'BraTS20_Training_001_t2.nii']));         % T2 HR
            v3_1 = double(niftiread([sr.data.folder_data 'BraTS20_Training_001_t1ce.nii']));       % T1ce HR "sodium image" 
            
            % ---- matrix sizes 
            [size_x,size_y] = size(squeeze(v1_1(:,:,1)));
            sr.param.original_hr_size_x = size_x;
            sr.param.original_hr_size_y = size_y;
            size_x_na = sr.param.original_lr_size_x ;
            sr.param.resolution_ratio = size_x/size_x_na;
            sl = sr.param.slice; 
            
            % ---- HR pronton images
            v1_1  = rot90(rot90(rot90(v1_1(:,:,sl)))); 
            v1_2 = rot90(rot90(rot90(v1_2(:,:,sl))));
            v1_3 = rot90(rot90(rot90(v1_3(:,:,sl))));  
            
            v1_1(isnan(v1_1)) = 0;
            v1_2(isnan(v1_2)) = 0;
            v1_3(isnan(v1_3)) = 0;
            
            if (sr.param.ground_truth)  
            % ---- HR Na image 
            v3_1 = rot90(rot90(rot90(v3_1(:,:,sl)))); 
            v3_1(isnan(v3_1)) = 0;
            end
            
            % ---- LR Na image 
            v2_1 = imresize(v3_1,[sr.param.original_lr_size_x sr.param.original_lr_size_y],'bilinear'); 
            
            % ---- HR mask created from v1_1  
            t = graythresh(v1_1./max(v1_1(:)));
            mask = imbinarize(v1_1./max(v1_1(:)), t*0.6);
            mask = imgaussfilt(double(mask),1);
            mask_hr = mask;
            sr.mask.mask_data1_hr = logical(mask_hr);
            sr.mask.mask_data1_hr_final = logical(mask);
            
            % ---- LR mask
            mask_lr = imresize(mask_hr,[sr.param.original_lr_size_x sr.param.original_lr_size_y],'bilinear');
            sr.mask.mask_data2_lr = logical(mask_lr);
            
            % ---- save original and deconvolved data 
            sr.data.img1_hr_original{1} = v1_1;
            sr.data.img1_hr_original{2} = v1_2;
            sr.data.img1_hr_original{3} = v1_3;
               
            sr.data.img1_hr{1} = v1_1.*mask_hr;
            sr.data.img1_hr{2} = v1_2.*mask_hr;
            sr.data.img1_hr{3} = v1_3.*mask_hr;
            
            sr.data.n_img1 = length(sr.data.img1_hr);
            
            sr.data.img2_lr_original{1} = v2_1.*mask_lr;
            sr.data.img2_lr{1} = v2_1.*mask_lr;
            
            sr.data.n_img2 = length(sr.data.img2_lr);
            
             if (sr.param.ground_truth)
            % ---- save original and deconvolved Na high resolution
            sr.data.img2_hr_original{1} = v3_1.*mask_hr;
            sr.data.img2_hr{1} = v3_1.*mask_hr;
            end
 end                  
end









