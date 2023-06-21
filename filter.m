% only test save filtered img into folder

clc
clear
addpath("srcs\all_func\");


imgs = imageDatastore("local_srcs\normal\", "IncludeSubfolders", false);
n = numel(imgs.Files);

for i = 1: n
    impath = char(imgs.Files(i));
    [~, name, extension] = fileparts(impath);
    name = strcat("F", name);
    name = strcat(name, extension);
    savedPath = strcat("srcs\imgs\Filtered\", name);
    img = imread(impath);
    res = AllFilters.bilateralFilter(img);
    res = AllFilters.imClose(res);
    imwrite(res, savedPath);
end
% 
% for i = 1: n
%     subplot(3, 5, i);
%     impath = char(imgs.Files(i));
%     img = imread(impath);
%     img = AllFilters.imagePrepare(img);
%     imhist(img);
% end

rmpath("srcs\all_func\");

