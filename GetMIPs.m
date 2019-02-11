function [zProj,xProj,yProj] = GetMIPs(im,channel,satLevel)
    im1 = mat2gray(im(:,:,:,channel,1));
    imEnd = mat2gray(im(:,:,:,channel,end));

    im1Z = ImUtils.BrightenImages(max(im1,[],3),'uint8',satLevel);
    imEndZ = ImUtils.BrightenImages(max(imEnd,[],3),'uint8',satLevel);

    im1X = ImUtils.BrightenImages(max(im1,[],2),'uint8',satLevel);
    im1X = permute(im1X,[1,3,2]);
    imEndX = ImUtils.BrightenImages(max(imEnd,[],2),'uint8',satLevel);
    imEndX = permute(imEndX,[1,3,2]);

    im1Y = ImUtils.BrightenImages(max(im1,[],1),'uint8',satLevel);
    im1Y = permute(im1Y,[3,2,1]);
    imEndY = ImUtils.BrightenImages(max(imEnd,[],1),'uint8',satLevel);
    imEndY = permute(imEndY,[3,2,1]);
    
    zProj = cat(3,im1Z,imEndZ);
    xProj = cat(3,im1X,imEndX);
    yProj = cat(3,im1Y,imEndY);
end
