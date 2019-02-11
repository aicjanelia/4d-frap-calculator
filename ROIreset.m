function ROIreset(src,event)
    global REC_HANDLES IM_METADATA
    
    center_xyz = IM_METADATA.Dimensions./2;
    
    size_xy = [10,10];
    recPosZ_xy = [center_xyz(1:2)-size_xy, size_xy.*2];
    recPosX_zy = [center_xyz([3,2])-size_xy, size_xy.*2];
    recPosY_xz = [center_xyz([1,3])-size_xy, size_xy.*2];
    
    set(REC_HANDLES(1),'Position',recPosZ_xy,'Curvature',[1 1],'linewidth',2);
    set(REC_HANDLES(2),'Position',recPosX_zy,'Curvature',[1 1],'linewidth',2);
    set(REC_HANDLES(3),'Position',recPosY_xz,'Curvature',[1 1],'linewidth',2);
    
    UpdateFRAPplot();
end