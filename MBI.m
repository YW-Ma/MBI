%Read File with UI
[fileName,filePath] = uigetfile({'*.tif';'*.*'},'Please Select Input Image');
fileNamePath=[filePath,fileName]; %acquire absolute dir
raw_img=imread(fileNamePath);
disp('Size of input image:');
[row,col,band]=size(raw_img);
disp([row,col,band]);

%Acquire Brightness:  The maximum value of a pixel at all the visible bands is recorded as brightness of the pixel.
