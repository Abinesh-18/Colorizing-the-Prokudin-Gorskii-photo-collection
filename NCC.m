function [harris_corner] = im_align3(imgR,imgG,imgB)
offset = 30;
[px,py] = size(imgB);
[imgb, imgg, imgr] = deal(imgB(offset:px-offset,offset:py-offset), imgG(offset:px-offset,offset:py-offset), imgR(offset:px-offset,offset:py-offset));
[imgB, imgG, imgR] = deal(imgb,imgg,imgr); 

topf_B = harris(imgB);
topf_G = harris(imgG);
topf_R = harris(imgR);

   [Xb, Yb] = deal(topf_B(2,:), topf_B(3,:));
   [Xg, Yg] = deal(topf_G(2,:), topf_G(3,:));
   [Xr, Yr] = deal(topf_R(2,:), topf_R(3,:));
   inG =[];
   inR =[];
   for i = 1:200
    px_g = Xb(i)-Xg(i);
    py_g = Yb(i)-Yg(i);
    px_r = Xb(i)-Xr(i);
    py_r = Yb(i)-Yr(i);

    shift_g = circshift(imgG, [px_g, py_g]);
    shift_r = circshift(imgR, [px_r, py_r]);
    sg = uint8(shift_g);
    sr = uint8(shift_r);
    
    inlier_g = sum(sum((imgB - shift_g).^2));
    inlier_r = sum(sum((imgB - shift_r).^2));
    inG = [inG, inlier_g];
    inR = [inR, inlier_r];
   end
   harris_corner = "Harris corner implemented";
end