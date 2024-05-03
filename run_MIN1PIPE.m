clear
clc

addpath(genpath('C:\Users\BrandonLab\Documents\MATLAB\MIN1PIPE\'));
files_path = 'c:\Users\Javad\Data\cue_reset\cue_reset_0_0_0_120sec\RSC_4\2024_04_19\17_14_37\Miniscope\';
ismc = true;
flag = 1;
Fsi = 30;
Fsi_new = 30;
spatialr = 1;
se = 1;
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
[file_name_to_save, filename_raw, filename_reg] = min1pipe(Fsi, Fsi_new, spatialr, se, ismc, flag); 
toc;
%% plot some images %%
load(file_name_to_save)
figure(1)
clf
%%% raw max %%%
ax1 = subplot(2, 3, 1, 'align');
imagesc(imaxn)
axis square
title('Raw')
colormap('gray');
%%% neural enhanced before movement correction %%%
ax2 = subplot(2, 3, 2, 'align');
imagesc(imaxy)
axis square
title('Before MC')

%%% neural enhanced after movement correction %%%
ax3 = subplot(2, 3, 3, 'align');
imagesc(imax)
axis square
title('After MC')

%%% contour %%%
ax4 = subplot(2, 3, 4, 'align');
plot_contour(roifn, sigfn, seedsfn, imax, pixh, pixw)
axis square

linkaxes([ax2,ax3,ax4], 'xy');
%%% movement measurement %%%
subplot(2, 3, 5, 'align')
axis off
if ismc
    plot(raw_score); hold on; plot(corr_score); hold off;
    axis square
    title('MC Scores')
else
    title('MC skipped')
end

%%% all identified traces %%%
subplot(2, 3, 6, 'align')
sigt = sigfn;
for i = 1: size(sigt, 1)
    sigt(i, :) = normalize(sigt(i, :));
end
plot((sigt + (1: size(sigt, 1))')')
axis tight
axis square
title('Traces')