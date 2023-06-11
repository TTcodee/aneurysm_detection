function compare_filt(filter1, filter2, img)
    res1 = filter1(img);
    res2 = filter2(img);
    imshowpair(res1, res2, 'montage');
end