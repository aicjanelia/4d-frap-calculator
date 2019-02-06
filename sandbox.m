%% USER settings
rootDir = 'D:\Images\LLSM\Colin-York\Good_Data\Actin505_LP_10ugOKT3_FRAP31\CPPdeconKLB';
channel = 1;
[im,imMeta] = LoadData(rootDir);
CreateFigure(im,imMeta,channel);
