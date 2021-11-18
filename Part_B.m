%% i)
f=nan(30,1);
fnames=cell(30,1);
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

im=double(imread([cd '\101_ObjectCategories\dolphin\image_0001.jpg']))/255;
if size(im,3)==1
   im=repmat(im,1,1,3); 
end
[M,N,~]=size(im);
im=cat(3,im,rgb2hsv(im));
ann=load([cd '\Annotations\dolphin\annotation_0001.mat']);
mask=double(poly2mask(ann.obj_contour(1,:)+ann.box_coord(3),ann.obj_contour(2,:)+ann.box_coord(1),M,N));
for i=1:6
    data=im(:,:,i);
    data=data(mask==1);
    for j=1:5
        eval(['f((' num2str(i) '-1)*5+' num2str(j) ',1)=' eval(['txt2{' num2str(j) ',1}']) '(data);'])
    end
end

%% ii)
im=double(imread([cd '\101_ObjectCategories\flamingo\image_0001.jpg']));
[M,N,~]=size(im);
ann=load([cd '\Annotations\flamingo\annotation_0001.mat']);
mask=double(poly2mask(ann.obj_contour(1,:)+ann.box_coord(3),ann.obj_contour(2,:)+ann.box_coord(1),M,N));
[f,fnames]=extract_color_features(im,mask);
disp('f Vector:')
format shortE
disp(f')
disp('fnames Cell:')
disp(fnames')