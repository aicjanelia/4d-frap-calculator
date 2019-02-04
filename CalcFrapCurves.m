function [frapCorrected, frapMean] = CalcFrapCurves(center_rcz,radius_rcz,im,imMetadata,flourMean,channel)   
    maskInd = GetPixelIndList(center_rcz,radius_rcz,imMetadata.Dimensions([2,1,3]));
    
    frapMean = zeros(imMetadata.NumberOfFrames,1);
    for t=1:imMetadata.NumberOfFrames
        curIm = im(:,:,:,channel,t);
        flourVals = curIm(maskInd);
        frapMean(t) = mean(flourVals(:));
    end
    
    frapMean = ImUtils.ConvertType(frapMean,'double',true);
    frapCorrected = frapMean./flourMean;
end
