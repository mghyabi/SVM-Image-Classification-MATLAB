function [f,fnames]=extract_color_features(im,mask)
% dealing with grayscale images
if size(im,3)==1
   im=repmat(im,1,1,3); 
end
f=nan(30,1);
fnames=cell(30,1);
% asigning names
txt1=cell(6,1);
txt2=cell(5,1);
txt2{1,1}='mean';txt2{2,1}='std';txt2{3,1}='median';txt2{4,1}='min';txt2{5,1}='max';
ch='RGBHSV';
for i=1:6
    txt1{i,1}=ch(i);
    for j=1:5
        fnames{(i-1)*5+j,1}=[txt1{i,1} '_' txt2{j,1}];
    end
end
im=cat(3,im,rgb2hsv(im));
% assigning data
for i=1:6
    data=im(:,:,i);
    data=data(mask==1);
    for j=1:5
        eval(['f((' num2str(i) '-1)*5+' num2str(j) ',1)=' eval(['txt2{' num2str(j) ',1}']) '(data);'])
    end
end
end