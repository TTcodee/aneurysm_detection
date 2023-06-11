% only test save filtered img into folder

clc
clear
addpath("srcs\all_func\");


imgs = imageDatastore("srcs\imgs", "IncludeSubfolders", false);
n = numel(imgs.Files);

for i = 1: n
    impath = char(imgs.Files(i));
    [~, name, extension] = fileparts(impath);
    name = strcat("F", name);
    name = strcat(name, extension);
    savedPath = strcat("srcs\imgs\Filtered\", name);
    img = imread(impath);
    res = AllFilters.wienerFilter(img);
    imwrite(res, savedPath);
end

rmpath("srcs\all_func\");

