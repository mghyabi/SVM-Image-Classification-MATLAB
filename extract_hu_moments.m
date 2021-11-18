function [f,fnames]=extract_hu_moments(mask)
[M,N]=size(mask);
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
end