% ==========================================================================
% function  : fft_resize_lr
% --------------------------------------------------------------------------
% purpose   : resize with fft approach to a higher resolution   
% input     : desired size_hr_x and size_hr_y and low-resolution image
% output    : high-resolution image
% comment   :
% reference :   
% --------------------------------------------------------------------------
% 2022/07 - gonzalo.rodriguez@nyulangone.org
% ==========================================================================

function [img_hr] = fft_resize_hr(size_hr_x,size_hr_y,image)

[size_lr_x,size_lr_y] = size(image);


initial_size_x_lr = floor((size_hr_x - size_lr_x)./2)+ 1; 
initial_size_y_lr = floor((size_hr_y - size_lr_y)./2)+ 1; 
final_size_x_lr = floor((size_hr_x - size_lr_x)./2)+ size_lr_x; 
final_size_y_lr = floor((size_hr_y - size_lr_y)./2)+ size_lr_y;


fft_lr(:,:) = fftshift(fft2(image));
fft_hr(:,:)  = zeros(size_hr_x,size_hr_y);
fft_hr(initial_size_x_lr:final_size_x_lr,initial_size_y_lr:final_size_y_lr) = fft_lr(:,:);
img_hr = abs(ifft2(fft_hr(:,:)));


end