% ==========================================================================
% function  : super_resolution_prepare_display_data
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

function [sr] = super_resolution_prepare_display_data(sr)
 
    switch sr.param.data_type
        
        case '2D data' 
            if (sr.param.ground_truth)    
                 if (sr.param.display_original_data)
                     figure; colormap gray;  sgtitle('Acquired Data'); 
                     subplot(2,3,1);  imshow(rot90(rot90(sr.data.img1_hr_original{1})),[]); axis image; title('Proton density');
                     subplot(2,3,2);  imshow(rot90(rot90(sr.data.img1_hr_original{2})),[]); axis image; title('T_{1} proton');
                     subplot(2,3,3);  imshow(rot90(rot90(sr.data.img1_hr_original{3})),[]); axis image; title('T_{2} proton');
                     subplot(2,3,4);  imshow(rot90(rot90(sr.data.img2_lr_original{1})),[]); axis image; title('^{23}Na - LR');   
                     subplot(2,3,5);  imshow(rot90(rot90(sr.data.img2_hr_original{1})),[]); axis image; title('Ground Truth - HR');
                 end

                 if (sr.param.display_initial_deconvolved_data)
                    figure;  colormap gray; sgtitle('Deconvolved Data');                   
                    subplot(2,3,1);  imshow(rot90(rot90(sr.data.img1_hr{1}))); axis image; title('Proton density');
                    subplot(2,3,2);  imshow(rot90(rot90(sr.data.img1_hr{2})),[0 0.4]); axis image; title(' T_{1} proton');
                    subplot(2,3,3);  imshow(rot90(rot90(sr.data.img1_hr{3})),[0 0.4]); axis image; title('T_{2} proton');
                    subplot(2,3,4);  imshow(rot90(rot90(sr.data.img2_lr{1})),[]); axis image; title('^{23}Na - LR');  
                    subplot(2,3,5);  imshow(rot90(rot90(sr.data.img2_hr{1})),[]); axis image; title('Ground Truth - HR');
                 end
                 
            else
       
                 if (sr.param.display_original_data)
                    figure; colormap gray; sgtitle('Acquired Data');
                    subplot(2,3,1);  imshow(rot90(rot90(sr.data.img1_hr_original{1})),[]); axis image; title('Proton density');
                    subplot(2,3,2);  imshow(rot90(rot90(sr.data.img1_hr_original{2})),[]); axis image; title('T_{1} proton');
                    subplot(2,3,3);  imshow(rot90(rot90(sr.data.img1_hr_original{3})),[]); axis image; title('T_{2} proton');
                    subplot(2,3,4);  imshow(rot90(rot90(sr.data.img2_lr_original{1})),[]); axis image; title('^{23}Na - LR'); 
                 end

                 if (sr.param.display_initial_deconvolved_data)
                    figure; colormap gray; sgtitle('Deconvolved Data');               
                    subplot(2,3,1);  imshow(rot90(rot90(sr.data.img1_hr{1}))); axis image; title('Proton density');
                    subplot(2,3,2);  imshow(rot90(rot90(sr.data.img1_hr{2})),[0 0.4]); axis image; title(' T_{1} proton');
                    subplot(2,3,3);  imshow(rot90(rot90(sr.data.img1_hr{3})),[0 0.4]); axis image; title('T_{2} proton');
                    subplot(2,3,4);  imshow(rot90(rot90(sr.data.img2_lr{1}))); axis image; title('^{23}Na - LR');        
                 end
            end
            
        case '3D data'
            if (sr.param.ground_truth)    
                 if (sr.param.display_original_data)
                     figure; colormap gray;  sgtitle('Acquired Data'); 
                     subplot(2,3,1);  imshow(sr.data.img1_hr_original{1},[]); axis image; title('Proton density');
                     subplot(2,3,2);  imshow(sr.data.img1_hr_original{2},[]); axis image; title('T_{1} proton');
                     subplot(2,3,3);  imshow(sr.data.img1_hr_original{3},[]); axis image; title('T_{2} proton');
                     subplot(2,3,4);  imshow(sr.data.img2_lr_original{1},[]); axis image; title('^{23}Na - LR');   
                     subplot(2,3,5);  imshow(sr.data.img2_hr_original{1},[]); axis image; title('Ground Truth - HR');
                 end

                 if (sr.param.display_initial_deconvolved_data)
                    figure; colormap gray; sgtitle('Deconvolved Data');                     
                    subplot(2,3,1);  imshow(sr.data.img1_hr{1}); axis image; title('Proton density');
                    subplot(2,3,2);  imshow(sr.data.img1_hr{2},[0 0.4]); axis image; title(' T_{1} proton');
                    subplot(2,3,3);  imshow(sr.data.img1_hr{3},[0 0.4]); axis image; title('T_{2} proton');
                    subplot(2,3,4);  imshow(sr.data.img2_lr{1},[]); axis image; title('^{23}Na - LR');  
                    subplot(2,3,5);  imshow(sr.data.img2_hr{1},[]); axis image; title('Ground Truth - HR');
                 end
                 
            else
       
                 if (sr.param.display_original_data)
                    figure; sgtitle('Acquired Data'); colormap gray;
                    subplot(2,3,1);  imshow(sr.data.img1_hr_original{1},[]); axis image; title('Proton density');
                    subplot(2,3,2);  imshow(sr.data.img1_hr_original{2},[]); axis image; title('T_{1} proton');
                    subplot(2,3,3);  imshow(sr.data.img1_hr_original{3},[]); axis image; title('T_{2} proton');
                    subplot(2,3,4);  imshow(sr.data.img2_lr_original{1},[]); axis image; title('^{23}Na - LR'); 
                 end

                 if (sr.param.display_initial_deconvolved_data)
                    figure; colormap gray; sgtitle('Deconvolved Data');               
                    subplot(2,3,1);  imshow(sr.data.img1_hr{1}); axis image; title('Proton density');
                    subplot(2,3,2);  imshow(sr.data.img1_hr{2},[0 0.4]); axis image; title(' T_{1} proton');
                    subplot(2,3,3);  imshow(sr.data.img1_hr{3},[0 0.4]); axis image; title('T_{2} proton');
                    subplot(2,3,4);  imshow(sr.data.img2_lr{1}); axis image; title('^{23}Na - LR');        
                 end
            end
          
        case 'proton only data'
       
            if (sr.param.ground_truth)    
                 if (sr.param.display_original_data)
                    figure; colormap gray;  sgtitle('Original Data');  
                    subplot(2,3,1);  imshow(sr.data.img1_hr_original{1},[]); axis image; title('FLAIR');
                    subplot(2,3,2);  imshow(sr.data.img1_hr_original{2},[]); axis image; title('T_{1} proton');
                    subplot(2,3,3);  imshow(sr.data.img1_hr_original{3},[]); axis image; title('T_{2} proton');
                    subplot(2,3,4);  imshow(sr.data.img2_lr_original{1},[]); axis image; title('T_{1}GD - LR');   
                    subplot(2,3,5);  imshow(sr.data.img2_hr_original{1},[]); axis image; title('Ground Truth - HR');
                 end

                 if (sr.param.display_initial_deconvolved_data)
                    figure; sgtitle('Deconvolved Data'); colormap gray; 
                    subplot(2,3,1);  imshow(sr.data.img1_hr{1}); axis image; title('FLAIR');
                    subplot(2,3,2);  imshow(sr.data.img1_hr{2},[]); axis image; title('T_{1} proton');
                    subplot(2,3,3);  imshow(sr.data.img1_hr{3},[]); axis image; title('T_{2} proton');
                    subplot(2,3,4);  imshow(sr.data.img2_lr{1},[]); axis image; title('T_{1}GD - LR');  
                    subplot(2,3,5);  imshow(sr.data.img2_hr{1},[]); axis image; title('Ground Truth - HR');
                 end
            else
                
                if (sr.param.display_original_data)
                    figure; sgtitle('Original Data');colormap gray; 
                    subplot(2,3,1);  imshow(sr.data.img1_hr_original{1},[]); axis image; title('FLAIR');
                    subplot(2,3,2);  imshow(sr.data.img1_hr_original{2},[]); axis image; title('T_{1} proton');
                    subplot(2,3,3);  imshow(sr.data.img1_hr_original{3},[]); axis image; title('T_{2} proton');
                    subplot(2,3,4);  imshow(sr.data.img2_lr_original{1},[]); axis image; title('T_{1}GD - LR'); 
                end

                if (sr.param.display_initial_deconvolved_data)
                    figure;colormap gray; sgtitle('Deconvolved Data');
                    subplot(2,3,1);  imshow(sr.data.img1_hr{1}); axis image; title('Proton density');
                    subplot(2,3,2);  imshow(sr.data.img1_hr{2},[]); axis image; title(' T_{1} proton');
                    subplot(2,3,3);  imshow(sr.data.img1_hr{3},[]); axis image; title('T_{2} proton');
                    subplot(2,3,4);  imshow(sr.data.img2_lr{1}); axis image; title('T_{1}GD - low res');        
                end
            end
     end
end