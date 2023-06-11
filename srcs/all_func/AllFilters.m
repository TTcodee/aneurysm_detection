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
        function res = imClose(img)
            img = AllFilters.imagePrepare(img);
            img = imbinarize(img);
            SE = strel('disk', 1);
            res = imclose(255 - img, SE);
            res = 255 - res;
        end

        % gaussian filter
        function res = gaussFilter(img)
            img = AllFilters.imagePrepare(img);
            res = imgaussfilt(img, 1);
        end

        % Wiener func
        function res = wienerFilter(img)
            img = AllFilters.imagePrepare(img);
            res = wiener2(img, [2, 1]);
        end
    end
end