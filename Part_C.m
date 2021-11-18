%% i)
[M,N,~]=size(imread([cd '\101_ObjectCategories\flamingo\image_0001.jpg']));
ann=load([cd '\Annotations\flamingo\annotation_0001.mat']);
mask=poly2mask(ann.obj_contour(1,:)+ann.box_coord(3),ann.obj_contour(2,:)+ann.box_coord(1),M,N);
fnames=cell(10,1);
f=nan(10,1);
B=bwboundaries(mask,'noholes');
B=B{1,1};
B(end,:)=[];
clearvars i j
s=B(:,2)+1j*B(:,1);
Y=fft(s,10000);
for k=0:numel(fnames)-1
    eval(['fnames{k+1,1}=''Fourier_desc_a' num2str(k) ''';'])
    f(k+1) = abs(sum(Y(k*1000+1:(k+1)*1000)));
end

% %sanity check
% figure,
% imshow(mask)
% hold on
% scatter(B(:,2),B(:,1))

%% ii)
[M,N,~]=size(imread([cd '\101_ObjectCategories\flamingo\image_0001.jpg']));
ann=load([cd '\Annotations\flamingo\annotation_0001.mat']);
mask=double(poly2mask(ann.obj_contour(1,:)+ann.box_coord(3),ann.obj_contour(2,:)+ann.box_coord(1),M,N));
[f,fnames]=extract_boundary_features(mask);
disp('f Vector:')
format shortE
disp(f')
disp('fnames Cell:')
disp(fnames')