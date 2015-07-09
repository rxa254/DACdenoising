fid=fopen('myFile.csv','wt');

x={'sin','cos','tan','log','exp'};

csvFun = @(str)sprintf('%s,',str);

xchar = cellfun(csvFun, x, 'UniformOutput', false);

xchar = strcat(xchar{:});

xchar = strcat(xchar(1:end-1),'\n');

fprintf(fid,xchar)
y={'siasan','coasas','taasn','loasg','exap'};


xchar = cellfun(csvFun, y, 'UniformOutput', false);

xchar = strcat(xchar{:});

xchar = strcat(xchar(1:end-1),'\n');

fprintf(fid,xchar)

fclose(fid);
