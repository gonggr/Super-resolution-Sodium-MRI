% ==========================================================================
% function  : fft_resize_lr
% --------------------------------------------------------------------------
% purpose   : resize with fft approach to a lower resolution   
% input     : desired size_lr_x and size_lr_y and high-resolution image
% output    : low-resolution image
% comment   :
% reference :   
% --------------------------------------------------------------------------
% 2022/07 - gonzalo.rodriguez@nyulangone.org
% ==========================================================================

function [img_lr] = fft_resize_lr(size_lr_x,size_lr_y,image)

[size_x,size_y] = size(image);

initial_size_x_lr = floor((size_x - size_lr_x)./2)+ 1; 
initial_size_y_lr = floor((size_y - size_lr_y)./2)+ 1; 
final_size_x_lr   = floor((size_x - size_lr_x)./2)+ size_lr_x; 
final_size_y_lr   = floor((size_y - size_lr_y)./2)+ size_lr_y; 


fft_hr = fftshift(fft2(image));
fft_lr = fft_hr(initial_size_x_lr:final_size_x_lr,initial_size_y_lr:final_size_y_lr);
img_lr = abs(ifft2(fft_lr));
end