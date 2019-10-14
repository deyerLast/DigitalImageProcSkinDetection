% David Meyer
% Homework 3: Skin Detection using YCrCb and Naive Bayes 
clc 
clear all
close all

picPathGood = './face_good.bmp';
picPathDark = './face_dark.bmp';
picGood = imread(picPathGood);
picDark = imread(picPathDark);
%figure, montage({picGood,picPathDark})
skinGood = skinDetect(picGood);
figure,imshow(skinGood)
skinGood = uint8(skinGood);

finalGood = picGood .* skinGood;
figure,imshow(finalGood)

%%
skin = skinDetect(picDark);
figure,imshow(skin)
%Invert for future use
%invertedSkin = invert(skin);
%figure,imshow(invertedSkin)
%%
%Convert to YCbCr
imYUV=colorspace('yuv<-rgb',picDark);

%Yone = imYUV(:,:,1);
%YCb = imYUV(:,:,2);
%YCr = imYUV(:,:,3);




%% 
%I'm doing this part incorrectly, and I'm unsure what to do.  I know i need
%the sum.
h = myhist(picDark);%imhist(Y)%myhist

figure,plot(h)
%Loop to find the threshold
var=zeros(256,1); 
index2=0;%Get sum.
for index = 20 : length(h)-20
    %text = length(h)-20;%Subtract 20 because I take off 10 from back and 10 from front
    index2 = index2 + h(index-1)+h(index-2)+h(index-4)+h(index-8) - h(index) +h(index+1)+h(index+2)+h(index+4)+h(index+8);
end
%%
threshold = index2/10;%I know that there has to be a better way.  But I'm unsure how to get a good threshold using the histogram information.

%%

[rowX, colY] = size(imYUV);
for row=1:rowX
    for col=1:colY 
        if imYUV(row,col)> threshold %textThat %I know that textThat needs to be (.6)
            imYUV(row,col) = 0;
        end
    end
end
figure,imshow(imYUV)
%%


im_new=colorspace('rgb<-yuv',imYUV);

finalFinal = im_new .* skin;
figure,imshow(finalFinal)





%% 
% Given Code From blackboard
function skin = skinDetect(pic)
    %given code in the assignment details.
    %All this does is detect skin pixels using RGB
    ims1 = (pic(:,:,1)>95) & (pic(:,:,2)>40) & (pic(:,:,3)>20);
    ims2 = (pic(:,:,1)-pic(:,:,2)>15) | (pic(:,:,1)-pic(:,:,3)>15);
    ims3 = (pic(:,:,1)-pic(:,:,2)>15) & (pic(:,:,1)>pic(:,:,3));
    ims = ims1 & ims2 & ims3;
    %figure,imshow(ims)
    skin = ims;
end

function sobelKernel = sobFilter(usePic)
    sobFiltOne=[-1 0 +1;
                -2 0 +2;
                -1 0 +1];%xDirection is done
    sobFiltTwo=[+1 +2 +1;
                 0 0 0;
                -1 -2 -1];%yDirection is done
    %sobelFiltOneImage = imfilter(usePic,sobFiltOne,'same');
    %sobelFiltTwoImage = imfilter(usePic,sobFiltTwo,'same');
        %Working is above.
    sobelFiltOneImage = conv2(usePic,sobFiltOne);%Another function to loop through picture to apply Kernel
    sobelFiltTwoImage = conv2(usePic,sobFiltTwo);
    %sobelFilt#Image = conv2(usePic,sobfilt#,'full');
        %Why does filter2 flip the image upside down?
            %conv2(pic, mask) = filter2(rot90(mask,2), pic)
            %conv2 is a bit faster than fitler, no reason for me to use
            %filter2 here.  
    
    sobelKernel = sqrt(sobelFiltOneImage.^2 + sobelFiltTwoImage.^2);
      %Edges detected better due to reading the image as a double from the
      %begging. 
end

function med = medFilter(usePic)%There has to be a better way to implement this...
    [rows, col] = size(usePic);%size of grayscale image
    picSalt = usePic;%Unsure why I did this, to lazy to change now. 
    pad=zeros(rows,col);
    for i=2:rows-1
        for j=2:col-1
            %Make 3x3 mask
            filter = [picSalt(i-1,j-1),picSalt(i-1,j),picSalt(i-1,j+1),picSalt(i,j-1),picSalt(i,j),picSalt(i,j+1),picSalt(i+1,j-1),picSalt(i+1,j),picSalt(i+1,j+1)];
            pad(i,j)= median(filter);%function that just return median value
        end
    end
    med = pad;
end




    
   
    


