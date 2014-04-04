function mapC = getMyMap(orig, img)

mapC  = zeros(256, size(img, 3));
mapC = mapC - 1;

new = double(orig) - double(img);

for i = 1:size(orig, 3)
    count = 0;
    for j = 1:size(orig, 1)
        for k = 1:size(orig, 2)
             if(mapC(orig(j, k, i)+1, i)==-1)
                count = count + 1;
                mapC(orig(j, k, i)+1, i) = new(j, k, i);
             end
             if(count==255)
                 break;
             end
        end
        
        if(count == 255)
            break;
        end
    end
end

end
