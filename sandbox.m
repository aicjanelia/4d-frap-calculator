%% USER settings
rootDir = 'D:\Images\LLSM\Colin-York\Good_Data\Actin505_LP_10ugOKT3_FRAP31\CPPdeconKLB';
channel = 1;

%%
[im,imMeta] = LoadData(rootDir);

%%
CalculatePhotoBleaching(im,channel,imMeta);

%%
CreateFigure(im,channel);

%% Setup the 3D viewer
radX = recPosZ_rc(4)./2;
radY = recPosZ_rc(3)./2;
radZ = recPosX_rc(4)./2;
se = HIP.MakeEllipsoidMask([radY,radX,radZ]);
ind = find(se);
seCoord_rc = Utils.IndToCoord(size(se),ind);
seCoord_rc(:,4) = 1;

seCent_rc = round(size(se)./2);
seT_rc = eye(4,4);
seT_rc(4,1:3) = [-seCent_rc(1),-seCent_rc(2),-seCent_rc(3)];

recStart_rc = [recPosZ_rc(1:2),recPosX_rc(2)];
recCent_rc = recStart_rc + [radY,radX,radZ];
recT_rc = eye(4,4);
recT_rc(4,1:3) = [recCent_rc(1),recCent_rc(2),recCent_rc(3)];

pixelList_rc = seCoord_rc * seT_rc * recT_rc;
pixelList_rc = pixelList_rc(:,1:3);
maskInd = Utils.CoordToInd(size(im(:,:,:,1,1)),pixelList_rc);
pixelList_xy = Utils.SwapXY_RC(pixelList_rc);

poly = D3d.Polygon.Make(pixelList_xy, 1, '', 1,[1,0,0,1]);

D3d.Open(im,imMeta);
D3d.Polygon.Load(poly);

%% Calculate the FRAP curves
minRad = min([radX,radY,radZ]);
frapMean = zeros(imMeta.NumberOfFrames,1);
prg = Utils.CmdlnProgress(imMeta.NumberOfFrames,true,'Calculating Photobleaching',true);
for t=1:imMeta.NumberOfFrames
    curIm = im(:,:,:,channel,t);
    flourVals = curIm(maskInd);
    frapMean(t) = mean(flourVals(:));
    prg.PrintProgress(t);
end
prg.ClearProgress(true);
frapMean = ImUtils.ConvertType(frapMean,'double',true);
frapCorrected = frapMean./flourMean;


subplot(2,3,4:6)
hold off
plot(imMeta.TimeStampDelta,frapMean,'o','DisplayName','Raw FRAP data');
hold on
plot(imMeta.TimeStampDelta,frapCorrected,'o','DisplayName','Corrected FRAP data');
legend
