for images = 1:6
   img = int16(imread(strcat('image',int2str(images),'.jpg')));
   [h,w] = size(img);
   imgsplitname = string({'imgR.jpg', 'imgG.jpg', 'imgB.jpg'});
   H=[1,(h-1)/3+1,2*(h-1)/3+1,h];
   R = w;
   dn = 15;
   imgnew=zeros(int32(h-4)/3, w, 3);
   imgB=img(H(1)+1:H(2), 1:R);
   imgG=img(H(2)+1:H(3), 1:R);
   imgR=img(H(3)+1:H(4), 1:R);
   disp(strcat('Image',int2str(images)));
   colorimg = cat(3,imgR,imgG,imgB);
   colorimg = uint8(colorimg);
   imwrite(colorimg, strcat('image',int2str(images),'-color.jpg'));

   [offsetgx,offsetgy,offsetrx,offsetry,ssd_image] = im_align1(imgR,imgG,imgB);
   disp(strcat('G channel alignment shift for SSD: [',int2str(offsetgx),',',int2str(offsetgy),']'));
   disp(strcat('R channel alignment shift for SSD: [',int2str(offsetrx),',',int2str(offsetry),']'));
   imwrite(ssd_image, strcat('image',int2str(images),'-ssd.jpg'));

   [offsetgx,offsetgy,offsetrx,offsetry,ncc_image] = im_align2(imgR,imgG,imgB);
   disp(strcat('G channel alignment shift for NCC: [',int2str(offsetgx),',',int2str(offsetgy),']'));
   disp(strcat('R channel alignment shift for NCC: [',int2str(offsetrx),',',int2str(offsetry),']'));
   imwrite(ncc_image, strcat('image',int2str(images),'-NCC.jpg'));      

   [harris] = im_align3(imgR,imgG,imgB);
   disp(strcat('Harris corner implemented for Image',int2str(images)));
%    disp(strcat('G channel alignment shift for harris-corner: [',int2str(offsetgx),',',int2str(offsetgy),']'));
%    disp(strcat('R channel alignment shift for harris-corner: [',int2str(offsetrx),',',int2str(offsetry),']'));
%    imwrite(ncc_image, strcat('image',int2str(images),'-harris.jpg'));
end

