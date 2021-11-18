function [f,fnames]=extract_boundary_features(mask)
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
end