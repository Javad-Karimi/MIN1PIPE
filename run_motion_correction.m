clear
clc

addpath(genpath('C:\Users\BrandonLab\Documents\MATLAB\MIN1PIPE\'));
files_path = 'c:\Users\Javad\Data\cue_reset\cue_reset_0_0_0_120sec\RSC_14\2024_04_19\14_39_03\Miniscope\';
ismc = true;
flag = 1;
Fsi = 30;
Fsi_new = 30;
spatialr = 1;
se = 1;
%%
% tic
% mergeavi(files_path, 'Motion JPEG AVI');
% toc
%%
% tic
% AVI2TIFF(files_path,'concat');
% toc
%% configure paths %%
% cd('C:\Users\Javad\Documents\MATLAB\MIN1PIPE');
% min1pipe_init;
%% parameters 
%%% user defined parameters %%%                                    
Params.Fsi = Fsi;                                                  
Params.Fsi_new = Fsi_new;                                     
Params.spatialr = spatialr;                                         
Params.neuron_size = se; %%% half neuron size; 9 for Inscopix and 5 %%%
%%% for UCLA, with 0.5 spatialr separately  %%%

%%% fixed parameters (change not recommanded) %%%                  
Params.anidenoise_iter = 4;                   %%% denoise iteration %%%
Params.anidenoise_dt = 1/7;                   %%% denoise step size %%%
Params.anidenoise_kappa = 0.5;       %%% denoise gradient threshold %%%
Params.anidenoise_opt = 1;                %%% denoise kernel choice %%%
Params.anidenoise_ispara = 1;             %%% if parallel (denoise) %%%
Params.bg_remove_ispara = 1;    %%% if parallel (backgrond removal) %%%
Params.mc_scl = 0.004;      %%% movement correction threshold scale %%%
Params.mc_sigma_x = 5;  %%% movement correction spatial uncertainty %%%
Params.mc_sigma_f = 10;    %%% movement correction fluid reg weight %%%
Params.mc_sigma_d = 1; %%% movement correction diffusion reg weight %%%
Params.pix_select_sigthres = 0.8;     %%% seeds select signal level %%%
Params.pix_select_corrthres = 0.6; %%% merge correlation threshold1 %%%
Params.refine_roi_ispara = 1;          %%% if parallel (refine roi) %%%
Params.merge_roi_corrthres = 0.9;  %%% merge correlation threshold2 %%%
%% get dataset info %%
[path_name, file_base, file_fmt] = data_info;
%%
cd('C:\Users\Javad\Documents\MATLAB\MIN1PIPE');
tic;
for i = 1: length(file_base)
    %%% judge whether do the processing %%%
    filecur = [path_name, file_base{i}, '_data_processed.mat'];
    msg = 'Redo the analysis? (y/n)';
    overwrite_flag = judge_file(filecur, msg);

    if overwrite_flag
        % data cat %%
        %%% --------- 1st section ---------- %%%
        % if ~exist([path_name, file_base{i}, '_reg.mat'], 'file')
        [m, filename_raw, imaxn, imeanf, pixh, pixw, nf, imx1, imn1] = data_cat_modified(path_name, file_base{i}, file_fmt{i}, Fsi, Fsi_new, spatialr);
        % else
        %     m = matfile([path_name, file_base{i}, '_reg.mat']);
        % end
        m.Properties.Writable = true;

        %%% remove dead pixels %%%
        % [m, imaxn] = remove_dp(m, 'frame_allt');

        %%% spatial downsampling after auto-detection %%%
        % [m, Params, pixh, pixw] = downsamp(path_name, file_base{i}, m, Params, aflag, imaxn);

        % movement correction %%
        if ismc
            if overwrite_flag
                pixs = min(pixh, pixw);
                Params.mc_pixs = pixs;
                Fsi_new = Params.Fsi_new;
                scl = Params.neuron_size / (7 * pixs);
                sigma_x = Params.mc_sigma_x;
                sigma_f = Params.mc_sigma_f;
                sigma_d = Params.mc_sigma_d;
                se = Params.neuron_size;
                [m, corr_score, raw_score, scl, imaxy] = frame_reg_modified(m, imaxn, se, Fsi_new, pixs, scl, sigma_x, sigma_f, sigma_d);
                Params.mc_scl = scl; %%% update latest scl %%%

                save(m.Properties.Source, 'corr_score', 'raw_score', 'imaxy',  '-v7.3', '-append');
            else
                imaxy = m.imaxy;
            end
        else
            if overwrite_flag
                m = frame_stab(m); %%% spatiotemporal stabilization %%%
            end
            imaxy = imaxy1;
        end
    end
end
toc