function [f,fnames]=extract_props(mask)
Struct=regionprops(mask,'Area', 'ConvexArea', 'Eccentricity', 'EquivDiameter','EulerNumber', 'Extent', 'FilledArea', 'MajorAxisLength','MinorAxisLength', 'Perimeter', 'Solidity');
f=cell2mat(struct2cell(Struct));
fnames=fieldnames(Struct);
f=[f(1);f(5);f(4);f(8);f(7);f(10);f(6);f(2);f(3);f(11);f(9)];
fnames={fnames{1};fnames{5};fnames{4};fnames{8};fnames{7};fnames{10};fnames{6};fnames{2};fnames{3};fnames{11};fnames{9}};
end