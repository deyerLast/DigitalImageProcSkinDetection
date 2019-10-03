% David Meyer
% Homework 3: Skin Detection using YCrCb and Naive Bayes 
clc 
clear all
close all

picPathGood = './face_good.bmp';
picPathDark = './face_dark.bmp';
picGood = imread(picPathGood);
picDark = imread(picPathDark);
figure, montage({picGood,picPathDark})

goodSkin = skinDetect(picGood);
darkSkin = skinDetect(picDark);

%RGB values
R=picDark(:,:,1);
G=picDark(:,:,2);
B=picDark(:,:,3);
%"Transformation simplicity and explicit separation of luminance and
%chrominance componenets makes this colorspace attractive for skin color
%modelling"
%So, Convert to YCbCr color space.
Y = 0.299*R + 0.587*G + 0.114*B;%Here is the luminance.
Cr = R - Y;
Cb=B-Y;
figure, montage({Y,Cr,Cb})
%Start Bais P(A|C) =  (P(C|A)P(A))/P(C)  
% P(C) is the normalizing constant
%P(A) Prior Probability 
%P(C|A) Likelihood 
%P(A|C) How probabile it is what we think it is. 
%TO solve Zero Frequency: Laplace Estimation or adding 1 for simple cases
%to avoid dividing by zero
%Might be helpful to do Gaussin distribution.

%Just split the picture in half.
%Right Side
imhist(Y)
[row,col] = size(Y);
middleColumn = floor(col/2);
rightHalfIlluminate = Y(:,middleColumn+1:end);
[pixelCountR,grayLevelsR] = imhist(rightHalfIlluminate);
%Left side
leftHalfIlluminate = Y(:,1:middleColumn);
[pixelCountL,grayLevelsL] = imhist(leftHalfIlluminate);
figure, montage({rightHalfIlluminate,leftHalfIlluminate})

%Difference should equal the threshold
diffhist = pixelCountL - pixelCountR;
threshold = 255*graythresh(diffhist);
%Find pixels above the threshold
aboveThresh = Y >threshold;
figure,imshow(aboveThresh)%Well, this just got interesting...
%%
test1 = aboveThresh - darkSkin;%here is what I'm masking out 
test2 = aboveThresh+darkSkin;
figure,montage({test1,test2})

edgeLapTest = laplacianFilter2(test1);
figure,imshow(edgeLapTest)

skin = darkSkin+edgeLapTest;
figure,imshow(skin)


function skin = skinDetect(pic)
    %given code in the assignment details.
    %All this does is detect skin pixels using RGB
    ims1 = (pic(:,:,1)>95) & (pic(:,:,2)>40) & (pic(:,:,3)>20);
    ims2 = (pic(:,:,1)-pic(:,:,2)>15) | (pic(:,:,1)-pic(:,:,3)>15);
    ims3 = (pic(:,:,1)-pic(:,:,2)>15) & (pic(:,:,1)>pic(:,:,3));
    ims = ims1 & ims2 & ims3;
    figure,imshow(ims)
    skin = ims;
end
function lapLacian = laplacianFilter2(usePic)
    laplFilt=[-1 -1 -1; 
              -1 8 -1; 
              -1 -1 -1];
    %laplacianFilt = filter2(usePic,laplFilt,'self');
    lapLacian = conv2(usePic,laplFilt,'same');%This was lapLacianFilt
   
end


    
   
    


