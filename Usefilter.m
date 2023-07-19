% Use for apply filter and save imgs    
clc
clear 
addpath("srcs\all_func\");

%%Part for apply filter

% dest_path1 = "srcs\Filtered\k-mean\";
% dest_path2 = "srcs\Filtered\k-mean\";
% useFilter("srcs\imgs\Normal\", "srcs\Filtered\TestShit\nor_oldF\");
% useFilter("srcs\imgs\Aneurysm\", "srcs\Filtered\TestShit\aneu_oldF\");

%%Part for split img
% begin_split("srcs\imgs\Aneurysym\", "srcs\train&test_imgs\aneurysym\", [2 2]);
% begin_split("srcs\imgs\Normal\", "srcs\train&test_imgs\normal\", [4, 4]);

%% Part For K mean filter alone
% useFilter("srcs\imgs\Aneurysym\", "srcs\Filtered\k-mean\aneu_rm\", myfilt);
% useFilter("srcs\imgs\Normal\", "srcs\Filtered\k-mean\nor_rm\");

%% Part For test new Shit
useFilter("srcs\imgs\Aneurysym\", "srcs\Filtered\k-shit\aneu_rm\", @newfilt);
% useFilter("srcs\imgs\Normal\", "srcs\Filtered\k-shit\nor\");

%===============Local Function===============
function useFilter(srcs_path, dest_path, filt)
imgs = imageDatastore(srcs_path, "IncludeSubfolders", false);
n = numel(imgs.Files);

for i = 1: n
    impath = char(imgs.Files(i));
    %====Part for initialize name==== 
    [~, name, extension] = fileparts(impath);
    % name = strcat("newF_", name);
    name = strcat("", name);
    name = strcat(name, extension);
    savedPath = strcat(dest_path, name);

    %====Part for filtering===
    img = imread(impath);
    % res = adjustShit(img);
    % res = res * 255;
    res = filt(img);
    imwrite(res, savedPath);
end
end

function begin_split(srcs_path, dest_path, windows)

imgs = imageDatastore(srcs_path, "IncludeSubfolders", false);
n = numel(imgs.Files);

for i = 1: n
    impath = char(imgs.Files(i));
    [~, basename, extension] = fileparts(impath);
    img = imread(impath);
    img = rm_watermark(img);
    splited_im = splitim(img, windows);
    for j = 1 : windows(1) * windows(2)
        name = strcat(basename, strcat("_", int2str(j)));
        name = strcat(name, extension);
        savedPath = strcat(dest_path, name);
        imwrite(splited_im{1, j}, savedPath);
    end
end

end

function img = rm_watermark(img)
for i = 1:3
    img(906:1011, 803:1010, i) = 0;
end
end

function res = myfilt(img)
fimg = AllFilters.KmeanFilter(img);
fimg = AllFilters.medFilter(fimg, [6 6]);
fimg = AllFilters.rmlarger(fimg, 200);
fimg = AllFilters.rmsmaller(fimg, 40);
% fimg = uint8(imbinarize(fimg, 'adaptive'));
img = fimg;
% fimg = imresize(fimg, [224, 224]);
% img = imresize(img, [224, 224]);
% img = img.* fimg;
% img = img.*(25/255);
% img(:, :, 1) = img(:, :, 1) + fimg.*uint8(255);
% img(:, :, 2) = img(:, :, 2) - fimg.*uint8(255);
% img(:, :, 3) = img(:, :, 3) - fimg.*uint8(255);
res = img;
end

function res = newfilt(img)
splitted_img = splitim(img, [4 4]);
splitted_img = cellfun(@AllFilters.KmeanFilter, splitted_img, UniformOutput=false);
fimg = merge_splitted(splitted_img);
% se = strel('disk', 4);
% fimg= imtophat(fimg, se);
% fimg = AllFilters.imagePrepare(fimg);
fimg = AllFilters.medFilter(fimg, [6 6]);
fimg = AllFilters.rmlarger(fimg, 200);
fimg = AllFilters.rmsmaller(fimg, 40);
img = fimg;
% fimg = uint8(imbinarize(fimg, 'adaptive'));
% fimg = imresize(fimg, [224, 224]);
% img = imresize(img, [224, 224]);
% img = img.*(25/255);
% img(:, :, 1) = img(:, :, 1) + fimg.*uint8(255);
% img(:, :, 2) = img(:, :, 2) - fimg.*uint8(255);
% img(:, :, 3) = img(:, :, 3) - fimg.*uint8(255);
% img = cat(3, zeros(224), img ,zeros(224));
% fimg = imresize(fimg, [224, 224]);
res = img;
end

function res = extract_color(color, img) %color = 1, 2, 3(r , g, b)
    res = img(:, :, color);
    f = @(i) floor(i / 255) * 255;
    res = uint8(imApplyFunc(res, f));
end

function res = adjustShit(img)
[h, w, ~] = size(img);
for i = 1 : h
    for j = 1 : w
        rgb = img(i, j, :);
        if (sum([rgb(1), rgb(2), rgb(3)] == [255, 0, 0]) ~= 3)
            img(i, j, :) = [0, 0, 0];
        end
    end
end
res = img;
end

