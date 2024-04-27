clear
clc

files_path = 'c:\Users\Javad\Data\cue_reset\cue_reset_0_0_0_120sec\RSC_7\2024_04_19\16_26_45\Miniscope\';
%%
tic
mergeavi(files_path, 'Motion JPEG AVI');
toc
%%
tic
AVI2TIFF(files_path,'concat');
toc
%%
tic; 
[file_name_to_save, filename_raw, filename_reg] = min1pipe(30, 15, 0.5, [], true, 1); 
toc;