function NRIGhcalTest(year)
% this function check the existance of the information of lunar calendar
% in ghcal.xls

year = double(year);
name = ['ghcal.xls'];

cd('Calendar');

A = xlsread(name);
B = [];
[row,col] = size(A);
j = 1;
for i=1:row
    if(A(i,1)==year)
        B(j,:) = A(i,:);
        j = j+1;
    end
end
cd('..');

BB = isnan(B);
C = sum(BB,2);

cd('TestData');
M = [B C];
M = M';
fid=fopen('NRIGhcalTestOut.txt','wt');
fprintf(fid,'%u\t%u\t%u\t%u\t%u\n',M);
fclose(fid);
cd('..');
