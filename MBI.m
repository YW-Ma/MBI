%1. Read File with UI

[fileName,filePath] = uigetfile({'*.tif';'*.*'},'Please Select Input Image');
fileNamePath=[filePath,fileName]; %acquire absolute dir
tic
raw_img=imread(fileNamePath);
disp('Size of input image:');
[row,col,band]=size(raw_img);
disp([row,col,band]);

%2. Calculation of brightness: The maximum of multispectral bands for pixel x is recorded as its brightness value
brightness_img=uint8(max(raw_img,[],3));%along the band dimension

%3. Construction of MBI: The spectral-structural characteristics of buildings
%3.1 White top-hat by reconstruction (W-TH):
length=2:5:52;%length of a linear Structure Element(SE)
S=size(length,2);%numbers of scale
direction=[0;45;90;135];%four directions are considered
D=size(direction,1);%numbers of directions

W_TH=zeros(S,D,row,col);%NOTIC: use 'squeeze' & 'imshow' func to see images seperately

for i=1:S
    for j=1:D
        SE=strel('line',length(i),direction(j));
        erosion_img=imerode(brightness_img,SE);
        reconstruct_img=imreconstruct(erosion_img,brightness_img);
        W_TH(i,j,:,:)=brightness_img-reconstruct_img;
    end
end

%3.2 DMPs & MBI
DMP=zeros(S-1,D,row,col);
MBIndex=zeros(row,col);
for i=1:(S-1)
    for j=1:D
        DMP(i,j,:,:)=abs(W_TH(i+1,j,:,:)-W_TH(i,j,:,:));
        MBIndex=MBIndex+double(squeeze(DMP(i,j,:,:)));
    end
end
MBIndex=uint8(MBIndex/(D*(S-1)));
imwrite(MBIndex,'MBI.tif');

eimg=imadjust(MBIndex);
imshow(eimg,'Colormap',jet(255));
t=toc;
display(t);

            



