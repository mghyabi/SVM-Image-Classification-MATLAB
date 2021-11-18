%% i)
Cat=["emu" "flamingo"];
for k=1:numel(Cat)
    Directory=[char(Cat(k)) '\'];
    Names1=dir(['101_ObjectCategories\' Directory]);
    Names1(1:2)=[];
    Names2=dir(['Annotations\' Directory]);
    Names2(1:2)=[];
    F_train=nan(floor(numel(Names1)*.9),106);
    y_train=cell(size(F_train,1),1);
    F_test=nan(numel(Names1)-size(F_train,1),106);
    y_test=cell(size(F_test,1),1);
    for i=1:size(F_train,1)
        im=double(imread([cd '\101_ObjectCategories\' Directory Names1(i).name]))/255;
        [M,N,~]=size(im);
        ann=load([cd '\Annotations\' Directory Names2(i).name]);
        mask=double(poly2mask(ann.obj_contour(1,:)+ann.box_coord(3),ann.obj_contour(2,:)+ann.box_coord(1),M,N));
        F_train(i,1:30)=extract_color_features(im*255,mask);
        F_train(i,31:40)=extract_boundary_features(mask);
        F_train(i,41:47)=extract_hu_moments(mask);
        F_train(i,48:58)=extract_props(mask);
        F_train(i,59:end)=extract_texture_features(im,mask);
        y_train{i}=Directory(1:end-1);
    end
    for j=i+1:numel(Names1)
        im=double(imread([cd '\101_ObjectCategories\' Directory Names1(j).name]))/255;
        [M,N,~]=size(im);
        ann=load([cd '\Annotations\' Directory Names2(j).name]);
        mask=double(poly2mask(ann.obj_contour(1,:)+ann.box_coord(3),ann.obj_contour(2,:)+ann.box_coord(1),M,N));
        F_test(j-i,1:30)=extract_color_features(im*255,mask);
        F_test(j-i,31:40)=extract_boundary_features(mask);
        F_test(j-i,41:47)=extract_hu_moments(mask);
        F_test(j-i,48:58)=extract_props(mask);
        F_test(j-i,59:end)=extract_texture_features(im,mask);
        y_test{j-i}=Directory(1:end-1);
    end
    disp(['First column of F_test for ' char(Cat(k))])
    format shortE
    disp(F_test(:,1)')
    disp(['y_test for ' char(Cat(k))])
    disp(y_test')
end

%% ii)
Cat=["emu" "flamingo"];
for k=1:numel(Cat)
    Directory=[char(Cat(k)) '\'];
    Names1=dir(['101_ObjectCategories\' Directory]);
    Names1(1:2)=[];
    Names2=dir(['Annotations\' Directory]);
    Names2(1:2)=[];
    F_train=nan(floor(numel(Names1)*.9),106);
    y_train=cell(size(F_train,1),1);
    F_test=nan(numel(Names1)-size(F_train,1),106);
    y_test=cell(size(F_test,1),1);
    for i=1:size(F_train,1)
        im=double(imread([cd '\101_ObjectCategories\' Directory Names1(i).name]))/255;
        [M,N,~]=size(im);
        ann=load([cd '\Annotations\' Directory Names2(i).name]);
        mask=double(poly2mask(ann.obj_contour(1,:)+ann.box_coord(3),ann.obj_contour(2,:)+ann.box_coord(1),M,N));
        F_train(i,1:30)=extract_color_features(im*255,mask);
        F_train(i,31:40)=extract_boundary_features(mask);
        F_train(i,41:47)=extract_hu_moments(mask);
        F_train(i,48:58)=extract_props(mask);
        F_train(i,59:end)=extract_texture_features(im,mask);
        y_train{i}=Directory(1:end-1);
    end
    for j=i+1:numel(Names1)
        im=double(imread([cd '\101_ObjectCategories\' Directory Names1(j).name]))/255;
        [M,N,~]=size(im);
        ann=load([cd '\Annotations\' Directory Names2(j).name]);
        mask=double(poly2mask(ann.obj_contour(1,:)+ann.box_coord(3),ann.obj_contour(2,:)+ann.box_coord(1),M,N));
        F_test(j-i,1:30)=extract_color_features(im*255,mask);
        F_test(j-i,31:40)=extract_boundary_features(mask);
        F_test(j-i,41:47)=extract_hu_moments(mask);
        F_test(j-i,48:58)=extract_props(mask);
        F_test(j-i,59:end)=extract_texture_features(im,mask);
        y_test{j-i}=Directory(1:end-1);
    end
    [Fn_train,mx,mn]=normalize_feature_columns(F_train);
    format shortE
    disp(['every tenth entry in mx for ' char(Cat(k))])
    disp(mx(1:10:end))
    disp(['every tenth entry in mn for ' char(Cat(k))])
    disp(mn(1:10:end))
    Fn_test=normalize_feature_columns(F_test,mx,mn);
    disp(['First column of Fn_test for ' char(Cat(k))])
    disp(Fn_test(:,1)')
end