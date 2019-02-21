function ExportCSV(src,event)
    global REC_HANDLES IM IM_METADATA FLOUR_MEAN_PER_T FLOUR_RAW_PER_T
    
    [fName,fPath] = uiputfile('*.csv','Save file as...');
    if (fName==0)
        return
    end

    recPosZ_xy = get(REC_HANDLES(1),'Position');
    recPosX_zy = get(REC_HANDLES(2),'Position');
    
    yRad = recPosZ_xy(4)/2;
    xRad = recPosZ_xy(3)/2;
    zRad = recPosX_zy(3)/2;
    
    yCenter = recPosZ_xy(2) + yRad;
    xCenter = recPosZ_xy(1) + xRad;
    zCenter = recPosX_zy(1) + zRad;

    [frapCorrected, frapMean, fitMetrics, frapRAW] = CalcFrapCurves([yCenter,xCenter,zCenter],[yRad,xRad,zRad],IM,IM_METADATA,FLOUR_MEAN_PER_T,IM_METADATA.FrapChannel);
    
    fHandle = fopen(fullfile(fPath,fName),'wt');
    fprintf(fHandle,'Image Name,%s\n',IM_METADATA.DatasetName);
    fprintf(fHandle,'\n');
    
    fprintf(fHandle,'A,+/-,t1/2,+/-,R-Squared\n');
    fprintf(fHandle,'%f,%f,%f,%f,%f\n',fitMetrics.A,fitMetrics.A_confidance,fitMetrics.thalf,fitMetrics.thalf_confidance,fitMetrics.Rsquared);
    fprintf(fHandle,'\n');
    
    fprintf(fHandle,'Time (s), FRAP (original), FRAP (correct), FRAP (raw), Non-FRAP (raw)\n');
    for t=1:IM_METADATA.NumberOfFrames
        fprintf(fHandle,'%f,%f,%f,%f,%f\n',IM_METADATA.TimeStampDelta(t),frapMean(t),frapCorrected(t),double(frapRAW(t)),double(FLOUR_RAW_PER_T(t)));
    end
    
    fclose(fHandle);
end
