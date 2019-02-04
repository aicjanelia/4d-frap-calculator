function MipButtonUp(src,event)
    global FIGURE_HANDLE REC_HANDLES AXES_HANDLES IM IM_METADATA FLOUR_MEAN_PER_T
    ud = get(FIGURE_HANDLE,'UserData');
    
    ud.IsDown = false;
    
    set(FIGURE_HANDLE,'UserData',ud);
    
    recPosZ_xy = get(REC_HANDLES(1),'Position');
    recPosX_zy = get(REC_HANDLES(2),'Position');
    
    yRad = recPosZ_xy(4)/2;
    xRad = recPosZ_xy(3)/2;
    zRad = recPosX_zy(3)/2;
    
    yCenter = recPosZ_xy(2) + yRad;
    xCenter = recPosZ_xy(1) + xRad;
    zCenter = recPosX_zy(1) + zRad;
    
    [frapCorrected, frapMean] = CalcFrapCurves([yCenter,xCenter,zCenter],[yRad,xRad,zRad],IM,IM_METADATA,FLOUR_MEAN_PER_T,IM_METADATA.FrapChannel);
    
    hold(AXES_HANDLES(4),'off');
    plot(IM_METADATA.TimeStampDelta,frapMean,'o','DisplayName','Raw FRAP data','parent',AXES_HANDLES(4));
    hold(AXES_HANDLES(4),'on');
    plot(IM_METADATA.TimeStampDelta,frapCorrected,'o','DisplayName','Corrected FRAP data','parent',AXES_HANDLES(4));
    legend(AXES_HANDLES(4))
end
