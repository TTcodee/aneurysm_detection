% only test save filtered img into folder
clc
clear
addpath("srcs\all_func\");
dest_path1 = "srcs\Filtered\Fil_Normal\";
dest_path2 = "srcs\Filtered\Fil_Aneurysm\";

useFilter("srcs\imgs\Normal\", dest_path1);
useFilter("srcs\imgs\Aneurysm\", dest_path2);


function useFilter(srcs_path, dest_path)
% imgs = imageDatastore("local_srcs\normal\", "IncludeSubfolders", false);
imgs = imageDatastore(srcs_path, "IncludeSubfolders", false);
n = numel(imgs.Files);

for i = 1: n
    impath = char(imgs.Files(i));
    [~, name, extension] = fileparts(impath);
    name = strcat("F_", name);
    name = strcat(name, extension);
    savedPath = strcat(dest_path, name);
    img = imread(impath);
    res = myfilt(img);
    imwrite(res, savedPath);
end
end

function res = myfilt(img)
img = AllFilters.KmeanFilter(img);
img = AllFilters.rmlarger(img, 200);
img = imresize(img, [224, 224]);
res = cat(3, img, img ,img);
end