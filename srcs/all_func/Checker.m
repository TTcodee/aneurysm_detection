classdef Checker
    %CHECKER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        groundTruth_path;
        masks_path;
    end
    
    methods
        function obj = Checker(groundTruth_path, target_rgb, masks_path)
            obj.groundTruth_path = groundTruth_path;
            obj.masks_path = masks_path;
            F = @(rgb) f(rgb, target_rgb);
            filt = @(img) imApplyFunc(img, F);
            useFilter(obj.groundTruth_path, masks_path, filt);
            % Nested Function
            function res = f(rgb, target_rgb)
                n_rgb = numel(rgb);
                n_tar = numel(target_rgb);
                if (n_rgb ~= n_tar)
                    fprintf("There is an error in image and targer rgb\n");
                    fprintf("\tIf image is rgb target rgb should be [r g b]\n");
                    fprintf("\tIf image is in grayscale target rgb should be [i]\n");
                    return
                elseif (n_rgb == 3)
                    res = [(sum(rgb == target_rgb) == 3), 0, 0];
                else
                    res = (rgb == target_rgb);
                end
            end
        end

        function result = check(obj, pred_path)
            groundTruth = imageDatastore(obj.masks_path);
            preds = imageDatastore(pred_path);
            n = numel(preds.Files);
            result = cell([n 4]);
            for i = 1:n
                gt_img = readimage(groundTruth, i);
                p_img = readimage(preds, i);
                [hit, miss, recall, hit_mask, miss_mask] = hit_miss_cal(gt_img, p_img);
                result{i, 1} = hit;
                result{i, 2} = miss;
                result{i, 3} = hit / (hit + miss);
                result{i, 4} = recall;
                

            end

        end
        
    end
end

%Local Function

function res = imApplyFunc(img, f)

[w, h, sz] = size(img);
res = uint8(zeros([w, h, sz]));
for i = 1 : w
    for j = 1 : h
        if (sz == 1)
            res(i, j) = f([res(i, j)]);
        else
            rgb = img(i, j, :);
            res(i, j, :) = f([rgb(1), rgb(2), rgb(3)]);
        end
         
    end
end

end

%====== Calculate hit and miss in the groundTruth image and precicted image
function [num_hit, num_miss, recall, hit_mask, miss_mask] = hit_miss_cal(org, pred)
%==== Find Connected Region ====
% Initialize size to be equal
[pred_w, pred_h, ~] = size(pred);
org = imresize(org, [pred_w, pred_h]);
orgBw= uint8(imbinarize(im2gray(org), 'adaptive'));
cc_org = bwconncomp(orgBw, 8);
predBw = uint8(imbinarize(im2gray(pred), 'adaptive'));
cc_pred = bwconncomp(predBw, 8);
n_org = cc_org.NumObjects;
n_pred = cc_pred.NumObjects;
l_org = labelmatrix(cc_org);
l_pred = labelmatrix(cc_pred);

%==== Check Hit and Miss ====
hit_mask = 0;
miss_mask = 0;
num_hit = 0;
for i = 1 : n_pred
    bef = hit_mask;
    mask_pred = l_pred == i;
    for j = 1 : n_org
        mask_org = l_org == j;
        hit_mat = mask_pred & mask_org;
        if (sum(sum(hit_mat)) ~= 0)
            num_hit = num_hit + 1;
            hit_mask = hit_mask + hit_mat;
            break;
        end
    end
    if (bef == hit_mask)
        miss_mask = miss_mask + mask_pred;
    end
end
num_miss = n_pred - num_hit;   
recall = countRecall(l_org, hit_mask) / n_org;

%==== Local function of hitmiss func ====
    function n_recall = countRecall(l_org, hit_mask)
        intercept = l_org & hit_mask;
        cc = bwconncomp(intercept, 8);
        n_recall = cc.NumObjects;
    end
end

%==== Function For applying filter ====
function useFilter(srcs_path, dest_path, myfilt)
imgs = imageDatastore(srcs_path, "IncludeSubfolders", false);
n = numel(imgs.Files);

for i = 1: n
    impath = char(imgs.Files(i));
    %====Part for initialize name==== 
    [~, name, extension] = fileparts(impath);
    name = strcat("", name);
    name = strcat(name, extension);
    savedPath = strcat(dest_path, name);

    %====Part for filtering===
    img = imread(impath);
    res = myfilt(img);
    imwrite(res.*255, savedPath);
end
end


