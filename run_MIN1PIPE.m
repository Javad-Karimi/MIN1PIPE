clear
clc
%%
mergeavi('c:\Users\Javad\Data\test_data\', 'Motion JPEG AVI');
%%
AVI2TIFF('c:\Users\Javad\Data\test_data\','concat');
%%
tic; 
[file_name_to_save, filename_raw, filename_reg] = min1pipe(30, 30, [], [], true, 1); 
toc;