function hgram = genHist(img)

dims = size(img, 3);
hgram = zeros(256, dims);
vals = 0;
for i = 1:dims
    vals = max(vals, length(unique(img(:, :, i))));
end
temp = zeros(vals, dims);

for i = 1:dims
    sSpace = img(:, :, i);
    vals2 = length(unique(img(:, :, i)));
    temp2 = zeros(vals2);
    edges = zeros(vals2);
    edges = unique(img(:, :, i));
    temp2 = histc(sSpace(:), edges);
    
    l1 = length(temp2);
    dif = vals - l1;
    
    if(dif>0)
    for i2 = 1:dif
        idx = l1 + i2;
        temp2(idx) = 0;
    end
    end
    temp(:, i) = temp2;
end

for i = 1:dims
    edges = unique(img(:, :, i));
    for j = 1:size(temp,1)
        if(j>length(edges))
            break;
        end
    hgram(edges(j)+1, i) = temp(j, i);
    end
end
end
