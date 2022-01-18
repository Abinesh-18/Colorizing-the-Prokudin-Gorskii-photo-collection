# Colorizing-the-Prokudin-Gorskii-photo-collection
image processing algorithms to detect features to frame alignment. The goal is to implement basic image processing algorithms (Sum of Squared Deviations (SSD) , Normalized Cross-Correlation (NCC) ) to detect features and use them for aligning the frames.

# Introduction:
A total of six images are given. Each image is a concatenation of three separate plate images, where each is for one color channel in the order (B, G and R). The task is to align the three plate images as three color channel images and save the resultant color image.
This is done using 4 different tasks:

 ![image](https://user-images.githubusercontent.com/91220352/150020266-a61c3830-9a7c-4088-a8f5-5a13a1b15faa.png)





## Task 1: Color Images
In this task each plate is calculated by splitting the given image into 3. It can be observed that the total size is 1024x400 is the size of one full image. The plates are concatenated in the order of Blue, Green and Red from top to bottom. So the whole image is divided into 3 across height and then are concatenated. 
### Code:

   imgB=img(H(1)+1:H(2), 1:R);
   imgG=img(H(2)+1:H(3), 1:R);
   imgR=img(H(3)+1:H(4), 1:R);
colorimg = cat(3,imgR,imgG,imgB);


where, H – height = 1024
R – Width = 400
 ![image](https://user-images.githubusercontent.com/91220352/150020050-d5ef92c2-5d07-440b-8ca9-2b7552d1d3a9.png)

Fig 2: Output of Task 1

## Task 2: Using SSD metrics
The easiest way to align the parts is to exhaustively search over a window of possible displacements (say [-15,15] pixels), score each one using some image matching metric, and take the displacement with the best score. There is a number of possible metrics that one could use to score how well the images match. The one used here is known as the Sum of Squared Differences (SSD) distance. This metric shows how different the 2 images are.
Here, one channel image among the three(R, G, B) is considered as reference (Blue channel in this case) and the remaining it (Red, Green) are compared with it. 
So by placing blue as the base the red channel image is taken and is windowed over the blue for a displacement size of [-15, 15]. At every location the SSD is calculated pixel by pixel. The position where the SSD value is minimum is considered as the point where the Blue and Red channel are closely matching. 
The formula used is:
 
### Code:
new_R =  circshift(imgr, [x y]); 
align_R(x+dn+1,y+dn+1) = sum(sum((new_B - new_R).^2));

The ‘align_R’ variable stores the value of SSD between blue and red at every position. Then the index of the minimum value of ‘align_R’ is taken. 
minval_R = min(min((align_R)));
[offsetx_R,offsety_R]=find(align_R==minval_R);

The index is subtracted by half of the slid window size which is equal to 15.
[offsetrx, offsetry, offsetgx, offsetgy] = deal(offsetx_R-dn, offsety_R-dn, offsetx_G-dn, offsety_G-dn); // dn = (window_size)/2

Circshift is used to move the Red Image by the offset calculated. Similar method is used to get offset for green. Now, the blue image, the shifted G, the shifted R are concatenated.
   ssd_image = cat(3,newr,newg,newb);

![image](https://user-images.githubusercontent.com/91220352/150020119-5f35a014-c2be-4458-9d1d-e78a7438a8c8.png)

 
Fig 2: SSD image output

## Task 3: Using NCC metrics
This task is similar to task 2. The steps are same until calculating the metric. The metric used here is Normalized Cross Correlation (NCC). This metric calculates how closely two images are. So to match the 2 image channels, the index of max value is used for shifting the images.
 
After the calculating 
### Code:
  avg1 = mean(im1, 'all');
  avg2 = mean(im2, 'all');
  [dev1, dev2] = deal((im1-avg1),(im2-avg2));
  num_sum = sum(dot(dev1,dev2));
  [denom1, denom2] = deal(sqrt(sum(sum(dev1.^2))), sqrt(sum(sum(dev2.^2))));
  denom = denom1*denom2;
  ncc_val = num_sum/denom;

The above code is used to calculate the NCC.
  maxval_R = max(max((align_R)));
  [offsetx_R,offsety_R]=find(align_R==maxval_R);

It finds the index of the maximum value.
Now the Red and Green Channels are shifted and then concatenated to produce the output.
  ncc_image = cat(3,newr,newg,newb);

![image](https://user-images.githubusercontent.com/91220352/150020156-f5f74caf-ec13-4de2-aa5f-e9393b12e2f2.png)

Fig 3: NCC metric output

## Task 4:
In this task, the features are aligned to get the close matching points. The features used here are called as the harris-corner detection features. This is successfully implemented and the top 200 feature vectors of the image is taken. So in this first step the harris-corner features are calculated for each color channel individually and then the highest 200 of them are taken. The code is implemented based on this resource: https://en.wikipedia.org/wiki/Harris_corner_detector.
 
![image](https://user-images.githubusercontent.com/91220352/150020172-16778c67-c483-42d5-b0f0-3ce7542fc8af.png)


