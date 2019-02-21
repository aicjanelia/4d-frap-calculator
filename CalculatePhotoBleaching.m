function flourMeanPerT = CalculatePhotoBleaching(im,channel,imMeta)
    global FLOUR_MEAN_PER_T FLOUR_RAW_PER_T IM_METADATA IM
    if (~exist('channel','var') || isempty(channel))
        channel = 1;
    end
    
    IM = im;
    
    IM_METADATA = imMeta;
    IM_METADATA.FrapChannel = channel;
    
    %% Calculate photobleaching
    FLOUR_MEAN_PER_T = zeros(size(im,5),1);
    prg = Utils.CmdlnProgress(size(im,5),true,'Calculating Photobleaching',true);
    for t=1:size(im,5)
        curIm = im(:,:,:,channel,t);
        thresh = multithresh(curIm(:),1);
        curBW = curIm>thresh;
        flourVals = curIm(curBW);
        FLOUR_MEAN_PER_T(t) = mean(flourVals(:));
        prg.PrintProgress(t);
    end
    prg.ClearProgress(true);
    
    FLOUR_RAW_PER_T = FLOUR_MEAN_PER_T;
    FLOUR_MEAN_PER_T = FLOUR_MEAN_PER_T ./ max(FLOUR_MEAN_PER_T(:));
    
    flourMeanPerT = FLOUR_MEAN_PER_T;
end
