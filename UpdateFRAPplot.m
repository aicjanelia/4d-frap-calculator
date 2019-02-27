function UpdateFRAPplot(~,~)
    y1Color = [0.5,0,0.25];
    y2Color = [0,0.6,0];

    global REC_HANDLES AXES_HANDLES IM IM_METADATA FLOUR_MEAN_PER_T TEXT_HANDLES BUSY_ANNOTATION OUTDATED_ANNOTATION FLOUR_RAW_PER_T

    recPosZ_xy = get(REC_HANDLES(1),'Position');
    recPosX_zy = get(REC_HANDLES(2),'Position');
    
    yRad = recPosZ_xy(4)/2;
    xRad = recPosZ_xy(3)/2;
    zRad = recPosX_zy(3)/2;
    
    yCenter = recPosZ_xy(2) + yRad;
    xCenter = recPosZ_xy(1) + xRad;
    zCenter = recPosX_zy(1) + zRad;

    BUSY_ANNOTATION.Visible = true;
    drawnow()
    
    [frapCorrected, frapMean, fitMetrics, frapRAW] = CalcFrapCurves([yCenter,xCenter,zCenter],[yRad,xRad,zRad],IM,IM_METADATA,FLOUR_MEAN_PER_T,IM_METADATA.FrapChannel);
    BUSY_ANNOTATION.Visible = false;
    
    legend off
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % HACK - PLEASE MAKE BETTER
    % I do not like the order of operations here, please fix (ECW 20190220)
    set(get(AXES_HANDLES(4),'parent'),'CurrentAxes',AXES_HANDLES(4))
    yyaxis right
    legend off
    
    h = get(AXES_HANDLES(4));
    h.YAxis(2).Limits = [min(frapRAW(:)),max(frapRAW(:))];
    h.YAxis(2).Color = y2Color;
    h.YAxis(1).Color = y1Color;
    ylabel('Intensity (raw)');
    yyaxis left
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    hold(AXES_HANDLES(4),'off');
    p1 = plot(IM_METADATA.TimeStampDelta,frapMean,'o','color',y2Color,'DisplayName','Raw FRAP data','parent',AXES_HANDLES(4));
    hold(AXES_HANDLES(4),'on');
    p2 = plot(IM_METADATA.TimeStampDelta,frapCorrected,'o','color',y1Color,'DisplayName','Corrected FRAP data','parent',AXES_HANDLES(4));
    title(AXES_HANDLES(4),'Frap Data');
    xlabel(AXES_HANDLES(4),'Time (s)')
    ylabel(AXES_HANDLES(4),'Intensity (au)','color',y1Color)
    p3 = plot(fitMetrics.fm);
    set(p3,'color','r','DisplayName','A*(1-exp(-tau*t))','parent',AXES_HANDLES(4));
    
    legend([p1,p2,p3],'location','southeast')
    
    set(TEXT_HANDLES(1),'string',sprintf('A=%.02f +/- %.02f   t1/2=%.02f +/- %.02f   R-squared:%.02f',fitMetrics.A,fitMetrics.A_confidance,fitMetrics.thalf,fitMetrics.thalf_confidance,fitMetrics.Rsquared));
    
    OUTDATED_ANNOTATION.Visible = false;
end
