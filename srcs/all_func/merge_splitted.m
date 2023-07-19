function res = merge_splitted(imgs)
n = sqrt(numel(imgs));
rsz = 0;
csz = 0;
[~, ~, sz] = size(imgs{1});
for i = 1 : numel(imgs)
    [r, c, ~] = size(imgs{i});
    if r > rsz
        rsz = r;
    end
    if c > csz
        csz = c;
    end
end
res = zeros([rsz * n, csz * n, sz]);

count = 1;
r_ptr = 1;
for r = 1 : n
    max_rsize = 0;
    c_ptr = 1;
    for c = 1 : n
        im = imgs{count};
        [w, h, ~] = size(im);
        for i = 1 : sz
            % inspect = res(r_ptr : r_ptr + w-1, c_ptr : c_ptr + h, i)
            end1 = (r_ptr + w - 1);
            end2 = (c_ptr + h - 1);
            res(r_ptr : end1, c_ptr : end2, i) = im(1:w, 1:h, i);
        end
        c_ptr = c_ptr + w;
        if h > max_rsize
            max_rsize = h;
        end
        count = count + 1;
    end
    r_ptr = r_ptr + max_rsize;
end
res = uint8(res);
end
