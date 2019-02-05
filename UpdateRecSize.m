function UpdateRecSize(clickPoint_xy,vec_xy,axisNumber,rec_handles,lineStyle)
    if (~exist('lineStyle','var') || isempty(lineStyle))
        lineStyle = '-';
    end
    
    recPosZ_xy = get(rec_handles(1),'Position');
    recPosX_zy = get(rec_handles(2),'Position');
    
    ySize = recPosZ_xy(4);
    xSize = recPosZ_xy(3);
    zSize = recPosX_zy(3);
    
    yCenter = recPosZ_xy(2) + ySize/2;
    xCenter = recPosZ_xy(1) + xSize/2;
    zCenter = recPosX_zy(1) + zSize/2;
   
    switch axisNumber
        case 1
            clickVec_xy = clickPoint_xy - [xCenter,yCenter];
            sng = sign(clickVec_xy);
            sng(sng==0) = 1;
            vec_xy = sng.*vec_xy;
            xSize = xSize + vec_xy(1);
            ySize = ySize + vec_xy(2);
        case 2
            clickVec_zy = clickPoint_xy - [zCenter,yCenter];
            sng = sign(clickVec_zy);
            sng(sng==0) = 1;
            vec_zy = sng.*vec_xy;
            ySize = ySize + vec_zy(2);
            zSize = zSize + vec_zy(1);
        case 3
            clickVec_xz = clickPoint_xy - [xCenter,zCenter];
            sng = sign(clickVec_xz);
            sng(sng==0) = 1;
            vec_xz = sng.*vec_xy;
            xSize = xSize + vec_xz(1);
            zSize = zSize + vec_xz(2);
        otherwise
            warning('Tried to update the wrong axis');
    end
    
    ySize = max(1,ySize);
    xSize = max(1,xSize);
    zSize = max(1,zSize);
    
    recPosZ_xy = [xCenter-xSize/2, yCenter-ySize/2, xSize, ySize];
    recPosX_zy = [zCenter-zSize/2, yCenter-ySize/2, zSize, ySize];
    recPosY_xz = [xCenter-xSize/2, zCenter-zSize/2, xSize, zSize];
    
    set(rec_handles(1),'Position',recPosZ_xy,'lineStyle',lineStyle);
    set(rec_handles(2),'Position',recPosX_zy,'lineStyle',lineStyle);
    set(rec_handles(3),'Position',recPosY_xz,'lineStyle',lineStyle);
end
