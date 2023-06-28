classdef AllFilters
    %ALLFILTERS Summary of this class goes here
    %   Detailed explanation goes here

    methods(Static)
        % Function to conver img to grayscale and adjust contrast
        function res = imagePrepare(img)
            grayimg = im2gray(img);
            res = imadjust(grayimg);
        end

        % imclose func
        function res = imClose(img, disk_size)
            img = AllFilters.imagePrepare(img);
            img = imbinarize(img, 'adaptive');
            SE = strel('disk', disk_size);
            res = imclose(255 - img, SE);
            res = 255 - res;
        end

        % gaussian filter
        function res = gaussFilter(img)
            img = AllFilters.imagePrepare(img);
            res = imgaussfilt(img, 1);
        end

        % Wiener func
        function res = wienerFilter(img, size)
            img = AllFilters.imagePrepare(img);
            res = wiener2(img, size);
        end

        %Bilateral filtering of images with Gaussian kernels
        function res = bilateralFilter(img)
            img = AllFilters.imagePrepare(img);
            dgs = 0.01*diff(getrangefromclass(img)).^2;
            res = imbilatfilt(img, dgs, 4);
        end

        function res = medFilter(img, size)
            img = AllFilters.imagePrepare(img);
            res = medfilt2(img, size);
        end

        function res = KmeanFilter(img)
            img = AllFilters.wienerFilter(img, [5 5]);
            morph_img = AllFilters.imClose(img, 3);
            L = imsegkmeans(img, 3, NumAttempts=10);

            cluster_img = get_cluster(img, L, 1);
            min_diff = img_diffsq(cluster_img, morph_img);
            min_cluster = cluster_img;
            for i = 2 : 3
                cluster_img = get_cluster(img, L, i);
                dif = img_diffsq(cluster_img, morph_img);
                if dif < min_diff
                    min_diff = dif;
                    min_cluster = cluster_img;
                end
            end
            res = AllFilters.medFilter(min_cluster, [6 10]);
            
        end
    end
end

%Local Functions For K-Mean Filter
function res = get_cluster(img, L, i)
mask1 = L == i;
res = img.*uint8(mask1);
end

function diff = img_diffsq(a, b)
a = AllFilters.imagePrepare(a);
b = AllFilters.imagePrepare(b);
a = imbinarize(a, 'adaptive');
b = imbinarize(b, 'adaptive');
[m, n] = size(a);
diff = 0;
for i = 1 : m
    for j = 1 : n
        diff = diff + (a(i, j) - b(i,j))^2;
    end
end
end