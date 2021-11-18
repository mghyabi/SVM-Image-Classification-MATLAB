%% i)
[M,N,~]=size(imread([cd '\101_ObjectCategories\emu\image_0001.jpg']));
ann=load([cd '\Annotations\emu\annotation_0001.mat']);
mask=poly2mask(ann.obj_contour(1,:)+ann.box_coord(3),ann.obj_contour(2,:)+ann.box_coord(1),M,N);
f=nan(7,1);
fnames=cell(7,1);
for i=1:numel(fnames)
    eval(['fnames{i,1}=''phi' num2str(i) ''';'])
end
[y,x]=meshgrid(N:-1:1,1:M);
m00=sum(sum(mask));
m10=sum(sum(x.*mask));
m01=sum(sum(y.*mask));
xbar=m10/m00;
ybar=m01/m00;

pq=[0 2 ; 2 0 ; 0 3 ; 3 0 ; 1 2 ; 2 1 ; 1 1];
eta=nan(size(pq,1),1);
for i=1:size(pq,1)
    p=pq(i,1);
    q=pq(i,2);
    mu=sum(sum(((x-xbar).^p).*((y-ybar).^q).*mask));
    gamma=(p+q)/2+1;
    eta(i,1)=mu/(m00^gamma);
end

f(1,1)=eta(1)+eta(2);
f(2,1)=(eta(2)-eta(1))^2+4*eta(7)^2;
f(3,1)=(eta(4)-3*eta(5))^2+(3*eta(6)-eta(3))^2;
f(4,1)=(eta(4)+eta(5))^2+(eta(6)+eta(3))^2;
f(5,1)=(eta(4)-3*eta(5))*(eta(4)+eta(5))*((eta(4)+eta(5))^2-3*(eta(6)+eta(3))^2) + (3*eta(6)-eta(3))*(eta(6)+eta(3))*(3*(eta(4)+eta(5))^2-(eta(6)+eta(3))^2);
f(6,1)=(eta(2)-eta(1))*((eta(4)+eta(5))^2-(eta(6)+eta(3))^2) + 4*eta(7)*(eta(4)+eta(5))*(eta(6)+eta(3));
f(7,1)=(3*eta(6)-eta(3))*(eta(4)+eta(5))*((eta(4)+eta(5))^2-3*(eta(6)+eta(3))^2) + (3*eta(5)-eta(4))*(eta(6)+eta(3))*(3*(eta(4)+eta(5))^2-(eta(6)+eta(3))^2);

%% ii)
[M,N,~]=size(imread([cd '\101_ObjectCategories\emu\image_0001.jpg']));
ann=load([cd '\Annotations\emu\annotation_0001.mat']);
mask=double(poly2mask(ann.obj_contour(1,:)+ann.box_coord(3),ann.obj_contour(2,:)+ann.box_coord(1),M,N));
[f,fnames]=extract_hu_moments(mask);
disp('f Vector:')
format shortE
disp(f')
disp('fnames Cell:')
disp(fnames')

%% iii)
[M,N,~]=size(imread([cd '\101_ObjectCategories\emu\image_0001.jpg']));
ann=load([cd '\Annotations\emu\annotation_0001.mat']);
mask=poly2mask(ann.obj_contour(1,:)+ann.box_coord(3),ann.obj_contour(2,:)+ann.box_coord(1),M,N);
Struct=regionprops(mask,'Area', 'ConvexArea', 'Eccentricity', 'EquivDiameter','EulerNumber', 'Extent', 'FilledArea', 'MajorAxisLength','MinorAxisLength', 'Perimeter', 'Solidity');
f=cell2mat(struct2cell(Struct));
f=[f(1);f(5);f(4);f(8);f(7);f(10);f(6);f(2);f(3);f(11);f(9)];
fnames=fieldnames(Struct);
fnames={fnames{1};fnames{5};fnames{4};fnames{8};fnames{7};fnames{10};fnames{6};fnames{2};fnames{3};fnames{11};fnames{9}};

%% iv)
tic
[M,N,~]=size(imread([cd '\101_ObjectCategories\flamingo\image_0001.jpg']));
ann=load([cd '\Annotations\flamingo\annotation_0001.mat']);
mask=double(poly2mask(ann.obj_contour(1,:)+ann.box_coord(3),ann.obj_contour(2,:)+ann.box_coord(1),M,N));
[f,fnames]=extract_props(mask);
disp('f Vector:')
format shortE
disp(f')
disp('fnames Cell:')
disp(fnames')
toc
