function UpdateRecCenter(pointDown_xy,axisNumber,rec_handles)    
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
            yCenter = pointDown_xy(2);
            xCenter = pointDown_xy(1);
        case 2
            yCenter = pointDown_xy(2);
            zCenter = pointDown_xy(1);
        case 3
            zCenter = pointDown_xy(2);
            xCenter = pointDown_xy(1);
        otherwise
            warning('Tried to update the wrong axis');
    end
    
    recPosZ_xy = [xCenter-xSize/2, yCenter-ySize/2, xSize, ySize];
    recPosX_zy = [zCenter-zSize/2, yCenter-ySize/2, zSize, ySize];
    recPosY_xz = [xCenter-xSize/2, zCenter-zSize/2, xSize, zSize];
    
    set(rec_handles(1),'Position',recPosZ_xy);
    set(rec_handles(2),'Position',recPosX_zy);
    set(rec_handles(3),'Position',recPosY_xz);
end
