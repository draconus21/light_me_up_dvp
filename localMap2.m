clear all;

a = [0 0.1 0.3 0.5 0.8 1.2 1.4 1.6];
b = [255 240 207 176 128 64 30 0];
     
b = b - 128; % gauss is centered at 128
mapGauss = fspecial('gauss', [256, 1], 128);
mapGauss = mapGauss/max(mapGauss);
mapGradient = 2*(1 - mapGauss);

lome = [1 5 10 20 24 30 50 100];
name = ['Church - Copy';  'DSC_0104     '; 'DSC_0275     '; 'DSC_0281     '; 'DSC_0313     '; 'DSC_0316     '; 'DSC_0326     '; 'DSC_0412     '; 'DSC_0444     '; 'DSC_0452 (2) '; 'DSC_0452     '; 'DSC_0460     '; 'DSC_0461     '; 'DSC_0463 (2) '; 'DSC_0463     '; 'DSC_0471     '; 'DSC_0577     '; 'DSC_0597     '; 'DSC_0599     '; 'DSC_0612     '; 'DSC_0629     '; 'DSC_0635     '; 'DSC_0640     '; 'DSC_0647     '; 'DSC_0879     '; 'DSC_0882     '; 'DSC_0914     '; 'DSC_0915     '; 'DSC_0959     '; 'DSC_0965     '; 'DSC_1471     '; 'DSC_2338     '; 'HDR 1        '; 'HDR 2        '; 'HDR 3        '; 'HDR 4        '; 'HDR 5        '; 'HDR 6        '; 'HDR 7        '; 'HDR 8        '; 'HDR 9        '; 'HDR 10       '; 'HDR 11       '; 'HDR 12       '; 'HDR 13       '; 'HDR1         '; 'HDR2         '; 'img4         '; 'night_street '; 'night2       '];
% name = ['DSC_0061     '; 'DSC_0362     '; 'DSC_0367     '; 'DSC_0369     '; 'DSC_0375     '; 'DSC_0407     '; 'DSC_0523     '; 'DSC_0562     '; 'DSC_0573     '; 'DSC_0585     ']
% name = ['DSC_0061     '; 'DSC_0815     '];
name = cellstr(name);



for ii=1:(length(name))
%   if(isempty(find(goSet == ii, 1)))
%       continue;
%   end
% 


tic
img_name = char(strcat('test images\', name(ii),'.jpg'));
out_name = char(strcat('output\', name(ii), 'LGM'));

progress = img_name

w_size = 3;
img = imread(img_name);

hsv = rgb2hsv(img);
if(size(hsv, 3)>1)
lum = hsv(:, :, 3);
else
lum = hsv;
end;
brite = log(lum);

tic
[aImg, bImg] = guidanceMap(brite, w_size);
toc
jImg = bImg .* brite + aImg;
progress = 'Map Generated...'

g = 6; %using 30
gauss = fspecial('gaussian', [256, 1], lome(g));
gauss = 0.75 * gauss/max(gauss);

gImg = zeros(size(img, 1), size(img, 2), size(img, 3));

newImg = rgb2hsv(img);
newImg(:, :, 3) = newImg(:, :, 3) * 255;

for i2=1:length(a)
     [gImg h] = localGuidanceMap(img_name, a(i2), jImg);
    
    adj = setGaussianAdjust(gImg, gauss, b(i2));
    
    disp = 128 - abs(b(i2));
    hsvMap = equalizeSub(newImg(:, :, 3), b(i2)+128, disp);
    hsvMap = hsvMap .* mapGradient;

    newImg(:, :, 3) = fakeAdjust(newImg(:, :, 3), hsvMap, adj);
end

newImg(:, :, 3) = newImg(:, :, 3) ./255;

out_name1 = char(strcat(out_name, 'FinalLome3', num2str(lome(g)), '.jpg'));
imwrite(hsv2rgb(newImg), out_name1);

% out_name2 = char(strcat(out_name, 'eq.jpg'));
% eqImg = hsv;
% eqImg(:, :, 3) = histeq(eqImg(:, :, 3));
% eqImg = hsv2rgb(eqImg);
% imwrite(eqImg, out_name2);

toc
end

