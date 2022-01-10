function [offsetgx,offsetgy,offsetrx,offsetry,ssd_image] = im_align1(imgR,imgG,imgB)
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
        align_R(x+dn+1,y+dn+1) = sum(sum((new_B - new_R).^2));
        align_G(x+dn+1,y+dn+1) = sum(sum((new_B - new_G).^2));
     end 
   end
   minval_R = min(min((align_R)));
   [offsetx_R,offsety_R]=find(align_R==minval_R);
   minval_G = min(min((align_G)));
   [offsetx_G,offsety_G]=find(align_G==minval_G);
   [offsetrx, offsetry, offsetgx, offsetgy] = deal(offsetx_R-dn, offsety_R-dn, offsetx_G-dn, offsety_G-dn);
   newb = imgB;
   newg = circshift(imgG, [offsetgx, offsetgy]);
   newr = circshift(imgR, [offsetrx, offsetry]);
   ssd_image = cat(3,newr,newg,newb);
   ssd_image = uint8(ssd_image);
end