function pixelIndList = GetPixelIndList(center_rcz,radius_rcz,imSize_rcz)
    se = HIP.MakeEllipsoidMask(radius_rcz);
    ind = find(se);
    seCoord_rcz = Utils.IndToCoord(size(se),ind);
    seCoord_rcz(:,4) = 1;

    seCent_rcz = round(size(se)./2);
    seT_rcz = eye(4,4);
    seT_rcz(4,1:3) = [-seCent_rcz(1),-seCent_rcz(2),-seCent_rcz(3)];

    recT_rcz = eye(4,4);
    recT_rcz(4,1:3) = center_rcz;

    pixelList_rcz = seCoord_rcz * seT_rcz * recT_rcz;
    pixelList_rcz = pixelList_rcz(:,1:3);
    pixelIndList = Utils.CoordToInd(imSize_rcz,pixelList_rcz);
    pixelIndList = pixelIndList(pixelIndList>0);
    pixelIndList = pixelIndList(pixelIndList<=prod(imSize_rcz));
end
