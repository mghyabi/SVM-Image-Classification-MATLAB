%% 
% this chunk of code prepares F_train, F_test y_train and y_test for all
% categories and save them in separate folders with class names
CD=cd;
categories=dir('101_ObjectCategories');
categories(1:2)=[];
for k=100%101:numel(categories)
    Directory=categories(k).name;
    Names1=dir(['101_ObjectCategories\' Directory '\']);
    Names1(1:2)=[];
    Names2=dir(['Annotations\' Directory '\']);
    Names2(1:2)=[];
    F_train=nan(floor(numel(Names1)*.9),106);
    y_train=cell(size(F_train,1),1);
    F_test=nan(numel(Names1)-size(F_train,1),106);
    y_test=cell(size(F_test,1),1);
    for i=1:size(F_train,1)
        im=double(imread([cd '\101_ObjectCategories\' Directory '\' Names1(i).name]))/255;
        [M,N,~]=size(im);
        ann=load([cd '\Annotations\' Directory '\' Names2(i).name]);
        mask=double(poly2mask(ann.obj_contour(1,:)+ann.box_coord(3),ann.obj_contour(2,:)+ann.box_coord(1),M,N));
        F_train(i,1:30)=extract_color_features(im*255,mask);
        F_train(i,31:40)=extract_boundary_features(mask);
        F_train(i,41:47)=extract_hu_moments(mask);
        F_train(i,48:58)=extract_props(mask);
        F_train(i,59:end)=extract_texture_features(im,mask);
        y_train{i}=Directory(1:end-1);
    end
    for j=i+1:numel(Names1)
        im=double(imread([cd '\101_ObjectCategories\' Directory '\' Names1(j).name]))/255;
        [M,N,~]=size(im);
        ann=load([cd '\Annotations\' Directory '\' Names2(j).name]);
        mask=double(poly2mask(ann.obj_contour(1,:)+ann.box_coord(3),ann.obj_contour(2,:)+ann.box_coord(1),M,N));
        F_test(j-i,1:30)=extract_color_features(im*255,mask);
        F_test(j-i,31:40)=extract_boundary_features(mask);
        F_test(j-i,41:47)=extract_hu_moments(mask);
        F_test(j-i,48:58)=extract_props(mask);
        F_test(j-i,59:end)=extract_texture_features(im,mask);
        y_test{j-i}=Directory(1:end-1);
    end
    [Fn_train,mx,mn]=normalize_feature_columns(F_train);
    Fn_test=normalize_feature_columns(F_test,mx,mn);
    mkdir([CD '\Features\' Directory])
    cd([CD '\Features\' Directory])
    save(['features_' Directory],'Fn_train','Fn_test','y_train','y_test')
    cd(CD)
end

%% i)
CD=cd;
Cat=["emu" "flamingo"];
F1=[];
y1=[];
F2=[];
y2=[];
for i=1:numel(Cat)
    cd([cd '\Features\' char(Cat(i)) '\'])
    load(['features_' char(Cat(i))])
    F1=[F1;Fn_train];
    F2=[F2;Fn_test];
    y1=[y1;y_train];
    y2=[y2;y_test];
    cd(CD)
end
Fn_train=F1;
Fn_test=F2;
y_train=y1;
y_test=y2;
clf=fitcsvm(Fn_train,y_train);
y_test_hat=clf.predict(Fn_test);
C=confusionmat(y_test,y_test_hat);
acc=sum(diag(C))/sum(sum(C));
disp('Confusion Matrix:')
disp(C)
disp('Accuracy (in percent):')
disp(acc*100)

%% ii)
CD=cd;
Cat=["emu" "flamingo" "strawberry"];
F1=[];
y1=[];
F2=[];
y2=[];
for i=1:numel(Cat)
    cd([cd '\Features\' char(Cat(i)) '\'])
    load(['features_' char(Cat(i))])
    F1=[F1;Fn_train];
    F2=[F2;Fn_test];
    y1=[y1;y_train];
    y2=[y2;y_test];
    cd(CD)
end
Fn_train=F1;
Fn_test=F2;
y_train=y1;
y_test=y2;
clf=fitcecoc(Fn_train,y_train);
y_test_hat=clf.predict(Fn_test);
C=confusionmat(y_test,y_test_hat);
acc=sum(diag(C))/sum(sum(C));
disp('Confusion Matrix:')
disp(C)
disp('Accuracy (in percent):')
disp(acc*100)

%% iii)
CD=cd;
Cat=["emu" "flamingo"];
F1=[];
y1=[];
F2=[];
y2=[];
for i=1:numel(Cat)
    cd([cd '\Features\' char(Cat(i)) '\'])
    load(['features_' char(Cat(i))])
    F1=[F1;Fn_train];
    F2=[F2;Fn_test];
    y1=[y1;y_train];
    y2=[y2;y_test];
    cd(CD)
end
Fn_train=F1(:,1:30);
Fn_test=F2(:,1:30);
y_train=y1;
y_test=y2;
clf=fitcecoc(Fn_train,y_train);
y_test_hat=clf.predict(Fn_test);
C=confusionmat(y_test,y_test_hat);
acc=sum(diag(C))/sum(sum(C));
disp('Confusion Matrix using only color features:')
disp(C)
disp('Accuracy using only color features (in percent):')
disp(acc*100)

Fn_train=F1(:,31:40);
Fn_test=F2(:,31:40);
clf=fitcecoc(Fn_train,y_train);
y_test_hat=clf.predict(Fn_test);
C=confusionmat(y_test,y_test_hat);
acc=sum(diag(C))/sum(sum(C));
disp('Confusion Matrix using only boundary features:')
disp(C)
disp('Accuracy using only boundary features (in percent):')
disp(acc*100)

Fn_train=F1(:,41:58);
Fn_test=F2(:,41:58);
clf=fitcecoc(Fn_train,y_train);
y_test_hat=clf.predict(Fn_test);
C=confusionmat(y_test,y_test_hat);
acc=sum(diag(C))/sum(sum(C));
disp('Confusion Matrix using only region features:')
disp(C)
disp('Accuracy using only region features (in percent):')
disp(acc*100)

Fn_train=F1(:,59:end);
Fn_test=F2(:,59:end);
clf=fitcecoc(Fn_train,y_train);
y_test_hat=clf.predict(Fn_test);
C=confusionmat(y_test,y_test_hat);
acc=sum(diag(C))/sum(sum(C));
disp('Confusion Matrix using only region features:')
disp(C)
disp('Accuracy using only region features (in percent):')
disp(acc*100)

%% iv)
CD=cd;
Cat=["emu" "flamingo"];
F1=[];
y1=[];
F2=[];
y2=[];
for i=1:numel(Cat)
    cd([cd '\Features\' char(Cat(i)) '\'])
    load(['features_' char(Cat(i))])
    F1=[F1;Fn_train];
    F2=[F2;Fn_test];
    y1=[y1;y_train];
    y2=[y2;y_test];
    cd(CD)
end
Fn_train=F1;
Fn_test=F2;
y_train=y1;
y_test=y2;
clf=fitcecoc(Fn_train,y_train);
y_test_hat=clf.predict(Fn_test);
C=confusionmat(y_test,y_test_hat);
acc=sum(diag(C))/sum(sum(C));
disp('Confusion Matrix using all features:')
disp(C)
disp('Accuracy using all features (in percent):')
disp(acc*100)

Fn_train=F1(:,1:30);
Fn_test=F2(:,1:30);
y_train=y1;
y_test=y2;
clf=fitcecoc(Fn_train,y_train);
y_test_hat=clf.predict(Fn_test);
C=confusionmat(y_test,y_test_hat);
acc=sum(diag(C))/sum(sum(C));
disp('Confusion Matrix using only color features:')
disp(C)
disp('Accuracy using only color features (in percent):')
disp(acc*100)

Fn_train=F1(:,31:40);
Fn_test=F2(:,31:40);
clf=fitcecoc(Fn_train,y_train);
y_test_hat=clf.predict(Fn_test);
C=confusionmat(y_test,y_test_hat);
acc=sum(diag(C))/sum(sum(C));
disp('Confusion Matrix using only boundary features:')
disp(C)
disp('Accuracy using only boundary features (in percent):')
disp(acc*100)

Fn_train=F1(:,41:58);
Fn_test=F2(:,41:58);
clf=fitcecoc(Fn_train,y_train);
y_test_hat=clf.predict(Fn_test);
C=confusionmat(y_test,y_test_hat);
acc=sum(diag(C))/sum(sum(C));
disp('Confusion Matrix using only region features:')
disp(C)
disp('Accuracy using only region features (in percent):')
disp(acc*100)

Fn_train=F1(:,59:end);
Fn_test=F2(:,59:end);
clf=fitcecoc(Fn_train,y_train);
y_test_hat=clf.predict(Fn_test);
C=confusionmat(y_test,y_test_hat);
acc=sum(diag(C))/sum(sum(C));
disp('Confusion Matrix using only region features:')
disp(C)
disp('Accuracy using only region features (in percent):')
disp(acc*100)

%% v)
CD=cd;
categories=dir('101_ObjectCategories');
categories(1:2)=[];
F1=[];
y1=[];
F2=[];
y2=[];
for i=1:numel(categories)
    cd([cd '\Features\' categories(i).name '\'])
    load(['features_' categories(i).name])
    F1=[F1;Fn_train];
    F2=[F2;Fn_test];
    y1=[y1;y_train];
    y2=[y2;y_test];
    cd(CD)
end
Fn_train=F1;
Fn_test=F2;
y_train=y1;
y_test=y2;
clf=fitcecoc(Fn_train,y_train);
y_test_hat=clf.predict(Fn_test);
C=confusionmat(y_test,y_test_hat);
acc=sum(diag(C))/sum(sum(C));
disp('Confusion Matrix using all features:')
disp(C)
disp('Accuracy using all features (in percent):')
disp(acc*100)
%Normalizing C
C=C./repmat(sum(C,2),1,size(C,2));
C=C/max(C(:));
figure,
imshow(C)