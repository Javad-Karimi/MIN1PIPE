function AVI2TIFF(file_path,file_name)

obj_avi= VideoReader([file_path,file_name,'.avi']);
vid = read(obj_avi);
%%
vid_squeezed = squeeze(vid(:,:,1,:));
%%
block_size = 1000;
block_quant = ceil(size(vid_squeezed,3) / block_size);
%%
Matlab_FastTiffReadWrite_path = 'c:\Users\Javad\Documents\MATLAB\Matlab_FastTiffReadWrite-main';
addpath(genpath(Matlab_FastTiffReadWrite_path));

% for ii = 1:block_quant
for ii = 1:block_quant
    if ii < block_quant
        stk_name = [file_path,file_name,'-', num2str(ii), '.tif'];

        FastTiffSave(vid_squeezed(:, :, (ii-1)*block_size+(1:block_size)),stk_name);
    else
        stk_name = [file_path,file_name,'-', num2str(ii), '.tif'];
        
        FastTiffSave(vid_squeezed(:,:, (ii-1)*block_size+1:end),stk_name);
    end
end

end