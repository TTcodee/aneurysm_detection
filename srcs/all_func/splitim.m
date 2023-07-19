function imgs = splitim(img, window)
[w, h] = size(im2gray(img));
wdif = floor(w / window(1));
hdif = floor(h / window(2));
imgs = cell(1, window(1) * window(2));
count = 1;
for j = 0 : window(1) - 1
    for i = 0 : window(2) - 1
        up_x = i*wdif;
        up_y = j*hdif;
        low_x = wdif;
        low_y = hdif;
        rect = [up_x, up_y, low_x, low_y];
        imgs{1, count} = uint8(imcrop(img, rect));
        count = count + 1;
    end
end
end