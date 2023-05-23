# Super-resolution-Sodium-MRI

Purpose        : Generate a high-resolution sodium image from a low-resolution acquisition

Input          : 3 high-resolution proton maps (T1, T2, proton density) and 1 low-resolution sodium image (sodium density) 
  
Output         : 1 High resolution sodium image

Contact        : gonzalo.rodriguez@nyulangone.org / guillaume.madelin@nyulangone.org

Affiliation    : Center for Biomedical Imaging, Radiology Department, New York University Grossman School of Medicine

MATLAB version : R2021a 

Date           : 2022/08

References	   : G.G. Rodriguez,et al.  Super-resolution of sodium images from simultaneous 1 H MRF/23 Na MRI acquisition. NMR in Biomed. 2023. 
                
                 G.G Rodriguez,et al. A method to increase the resolution of sodium images  from simultaneous 1H MRF/23Na MRI, 2022 Joint Annual                        Meeting ISMRM-ESMRMB & ISMRT 31st Annual Meeting, London, 2022. 
             

The method was tested on 3 different types of data:

    '2D data': 2D simultaneously acquired high-resolution proton maps and a low-resolution sodium image.
    '3D data': 3D simultaneously acquired high-resolution proton maps and a low-resolution sodium image.
    'proton only data': 3D proton-only images where 3 images are high-resolution and 1 is resized to low resolution.	
    
To allow the correct performance of the method, all the images need to be coregistered. 
The 3D dataset examples were coregistered with SPM12 (UCL, London, UK).
The 3D super-resolution method is applied slice-by-slice. It is also possible to select only some specific slices to be processed.

For the data types '2D data' and '3D data', PSF deconvolution and the Fourier transform approach resize are implemented.
For the data type 'Proton only data', bilinear resize is implemented without PSF deconvolution. 

To run the algorithm:

1. In "super_resolution_prepare_parameters.m", specify the algorithm parameters, such as data type, the position of slices, original low-resolution size, and parameters for the stop criterion, among others.
2. In "super_resolution_prepare_get_data.m", specify the folder and file names of the images that will be processed.
3. Run "run_super_resolution_method.m"
4. The final results are saved in the structure sr.final_results.
