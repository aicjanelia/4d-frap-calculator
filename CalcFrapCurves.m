function [frapCorrected, frapMean, fitMetrics, frapRAW] = CalcFrapCurves(center_rcz,radius_rcz,im,imMetadata,flourMean,channel)   
    maskInd = GetPixelIndList(center_rcz,radius_rcz,imMetadata.Dimensions([2,1,3]));
    
    frapMean = zeros(imMetadata.NumberOfFrames,1);
    for t=1:imMetadata.NumberOfFrames
        curIm = im(:,:,:,channel,t);
        flourVals = curIm(maskInd);
        frapMean(t) = max(eps,mean(flourVals(:)));
    end
    
    frapRAW = frapMean;
    if (~any(frapMean==eps))
        frapMean = ImUtils.ConvertType(frapMean,'double',true);
    end

    frapCorrected = frapMean./flourMean;
    
    frapCorrected = frapCorrected./max(frapCorrected);% TODO: change this when we have a starting frame that is past the first frame
    
    ft = fittype('A*(1-exp(-tau*t))','independent','t','coefficients',{'A','tau'});
    [fm,gof] = fit(imMetadata.TimeStampDelta',frapCorrected,ft,'Startpoint',[0.5,0.05],'Lower',[0 0],'Upper',[inf inf]);

    coeffs = coeffvalues(fm);
    confints = confint(fm);
    A1conf = diff(confints(:,1))/2;
    thalf1 = log(2)/coeffs(2);
    thalf1confl = log(2)/confints(2,2);
    thalf1confu = log(2)/confints(1,2);
    thalf1conf = abs(thalf1confu - thalf1confl)/2;
    
    fitMetrics = struct('A',[],'A_confidance',[],'thalf',[],'thalf_confidance',[],'Rsquared',[]);
    fitMetrics.A = coeffs(1);
    fitMetrics.A_confidance = A1conf;
    fitMetrics.thalf = thalf1;
    fitMetrics.thalf_confidance = thalf1conf;
    fitMetrics.Rsquared = gof.adjrsquare;
    fitMetrics.fm = fm;
end
