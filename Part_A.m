%% i)
categories=dir('101_ObjectCategories');
%first two lines should be removed
categories(1:2)=[];
figure
[x,y]=meshgrid(.9:-.09:0,0:.1:.9);
for i=1:numel(categories)
    %using this syntax to have more distinguishable(bigger) images
    subplot('Position',[[y(i) x(i)] 0.07 0.07])
    imshow([cd '\101_ObjectCategories\' categories(i).name '\image_0001.jpg'])
    title(categories(i).name,'Interpreter','none','FontSize',9)
end

%% ii)
ann=load([cd '\Annotations\emu\annotation_0001.mat']);
disp('Box coordinates:')
disp(ann.box_coord)

disp('Object contour:')
disp(ann.obj_contour)

figure
imshow([cd '\101_ObjectCategories\emu\image_0001.jpg'])
hold on
scatter(ann.obj_contour(1,:)+ann.box_coord(3),ann.obj_contour(2,:)+ann.box_coord(1))

%% iii)
categories=dir('Annotations');
categories(1:2)=[];
figure
[x,y]=meshgrid(.9:-.09:0,0:.1:.9);
for i=1:numel(categories)
    [M,N,~]=size(imread([cd '\101_ObjectCategories\' categories(i).name '\image_0001.jpg']));
    ann=load([cd '\Annotations\' categories(i).name '\annotation_0001.mat']);
    A=poly2mask(ann.obj_contour(1,:)+ann.box_coord(3),ann.obj_contour(2,:)+ann.box_coord(1),M,N);
    subplot('Position',[[y(i) x(i)] 0.07 0.07])
    imshow(A)
    title(categories(i).name,'Interpreter','none','FontSize',9)
end