function [f,fnames]=extract_texture_features(im,mask)
if size(im,3)==3
    im=rgb2gray(im);
end
f=nan(48,1);
fnames=cell(48,1);

I_q=uint8(round(im*31));
I_q(mask==0)=32;
% Direction and distance definition
offset=[0 1;-1 1;-1 0;-1 -1];
D=[1 2 3 4];
for k=1:numel(D)
    % GLCM
    G=graycomatrix(I_q,'Offset',D(k)*offset,'NumLevels',33,'GrayLimits',[],'Symmetric',true);
    % Removing unwanted data from areas outside the mask
    G(33,:,:)=[];
    G(:,33,:)=[];
    % Normalize GLCM
    G=G./repmat(sum(sum(G)),size(G,1),size(G,2),1);
    % GLCM grid
    [j,i]=meshgrid(0:size(G,2)-1,0:size(G,1)-1);
    j=repmat(j,1,1,size(G,3));
    i=repmat(i,1,1,size(G,3));
    % Modifications and extra parameters
    LG=log(G)/log(2);
    LG(LG==-inf)=0;
    Mean=sum(sum(i.*G));
    Variance=sum(sum(((i-Mean).^2).*G));
    % Main Parameters
    Ene=sum(sum(G.^2));
    Ent=-sum(sum(G.*LG));
    Con=sum(sum(((i-j).^2).*G));
    Var=sum(sum(((i-Mean).^2).*G));
    Cor=sum(sum((i-Mean).*(j-Mean).*G./Variance));
    Idm=sum(sum((1./(1+(i-j).^2)).*G));
    % Putting mean and variance in place
    Parameters=[Ene;Ent;Con;Var;Cor;Idm];
    f(D(k):8:end)=mean(Parameters,3);
    f(D(k)+4:8:end)=std(Parameters,0,3);
end
Str1=["ene","ent","con","var","cor","idm"];
Str2=["d1","d2","d3","d4"];
Str3=["mean","std"];
l=1;
for i=1:numel(Str1)
    for j=1:numel(Str3)
        for k=1:numel(Str2)
            fnames{l}=['GLCM_' char(Str1(i)) '_' char(Str2(k)) '_' char(Str3(j))];
            l=l+1;
        end
    end
end
end