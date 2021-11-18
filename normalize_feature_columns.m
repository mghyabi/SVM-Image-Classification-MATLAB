function [F_norm,mx,mn]=normalize_feature_columns(F,varargin)
switch nargin
    case 1
        mn=min(F);
        mx=max(F-repmat(mn,size(F,1),1));
        mx(mx==0)=1;
        F_norm=(F-repmat(mn,size(F,1),1))./repmat(mx,size(F,1),1);
    case 3
        F_norm=(F-repmat(varargin{2},size(F,1),1))./repmat(varargin{1},size(F,1),1);
    otherwise
        disp('Wrong function definition!')
end 
end