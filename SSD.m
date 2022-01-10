function [offsetgx,offsetgy,offsetrx,offsetry,ncc_image] = im_align2(imgR,imgG,imgB)
    dn = 15;
    offset = 30;
    [px,py] = size(imgB);
    [imgb, imgg, imgr] = deal(imgB(offset:px-offset,offset:py-offset), imgG(offset:px-offset,offset:py-offset), imgR(offset:px-offset,offset:py-offset));
    [imgB, imgG, imgR] = deal(imgb,imgg,imgr);
    [align_R, align_G] = deal(zeros(2*dn, 2*dn),zeros(2*dn, 2*dn));
    [u,v] = deal(int16(size(imgB,1)/2),int16(size(imgB,2)/2));
    [new_B, imgg, imgr] = deal(imgB, imgG, imgR);
   %[new_B, imgg, imgr] = deal(imgB(u-n:u+n+1, v-n:v+n+1), imgG(u-n:u+n+1, v-n:v+n+1), imgR(u-n:u+n+1, v-n:v+n+1));
    for x = -dn:dn
        for y = -dn:dn
            new_R =  circshift(imgr, [x y]);
            new_G =  circshift(imgg, [x y]);
            align_R(x+dn+1,y+dn+1) = NCC_calc(new_B, new_R);
            align_G(x+dn+1,y+dn+1) = NCC_calc(new_B, new_G);
        end 
    end
    maxval_R = max(max((align_R)));
    [offsetx_R,offsety_R]=find(align_R==maxval_R);
    maxval_G = max(max((align_G)));
    [offsetx_G,offsety_G]=find(align_G==maxval_G);
    [offsetrx, offsetry, offsetgx, offsetgy] = deal(offsetx_R-dn, offsety_R-dn, offsetx_G-dn, offsety_G-dn);
    newb = imgB;
    newg = circshift(imgG, [offsetgx, offsetgy]);
    newr = circshift(imgR, [offsetrx, offsetry]);
    ncc_image = cat(3,newr,newg,newb);
    ncc_image = uint8(ncc_image);
end
function [ncc_val] = NCC_calc(im1, im2)
    im1 = double(im1);
    im2 = double(im2);
    avg1 = mean(im1, 'all');
    avg2 = mean(im2, 'all');
    [dev1, dev2] = deal((im1-avg1),(im2-avg2));
    num_sum = sum(dot(dev1,dev2));
    [denom1, denom2] = deal(sqrt(sum(sum(dev1.^2))), sqrt(sum(sum(dev2.^2))));
    denom = denom1*denom2;
    ncc_val = num_sum/denom;
end