function CreateFigure(im,channel)
    global FIGURE_HANDLE AXES_HANDLES REC_HANDLES FLOUR_MEAN_PER_T

    im1 = mat2gray(im(:,:,:,channel,1));
    imEnd = mat2gray(im(:,:,:,channel,end));

    im1Z = ImUtils.BrightenImages(max(im1,[],3));
    imEndZ = ImUtils.BrightenImages(max(imEnd,[],3));
    sizeZ_rc = size(im1Z);
    midZ_rc = round(sizeZ_rc./2);
    radZ_rc = [10,10];
    recPosZ_rc = [midZ_rc-radZ_rc, radZ_rc.*2];

    im1X = ImUtils.BrightenImages(max(im1,[],2));
    im1X = permute(im1X,[1,3,2]);
    imEndX = ImUtils.BrightenImages(max(imEnd,[],2));
    imEndX = permute(imEndX,[1,3,2]);
    sizeX_rc = size(im1X);
    midX_rc = round(sizeX_rc./2);
    radX_rc = [10,10];
    recPosX_rc = [midX_rc-radX_rc, radX_rc.*2];

    im1Y = ImUtils.BrightenImages(max(im1,[],1));
    im1Y = permute(im1Y,[3,2,1]);
    imEndY = ImUtils.BrightenImages(max(imEnd,[],1));
    imEndY = permute(imEndY,[3,2,1]);
    sizeY_rc = size(im1Y);
    midY_rc = round(sizeY_rc./2);
    radY_rc = [10,10];
    recPosY_rc = [midY_rc-radY_rc, radY_rc.*2];
    
    yRatio = floor(size(im,1)/size(im,3));
    xRatio = floor(size(im,2)/size(im,3));
    
    numPlotY = yRatio +1;
    numPlotX = xRatio +1;
    
    plots_xy = [];
    for i=1:yRatio
        plots_xy = [plots_xy,[1:xRatio] + (i-1)*numPlotX];
    end
    
    plots_zy = [1:yRatio] * numPlotX;
    plots_xz = (numPlotY-1)*numPlotX+1:(numPlotY-1)*numPlotX+xRatio;
    plots_frap = (numPlotY-1)*numPlotX+xRatio+1:numPlotX*numPlotY;

    FIGURE_HANDLE = figure;
    AXES_HANDLES(1) = subplot(numPlotY,numPlotX,plots_xy);
    AXES_HANDLES(2) = subplot(numPlotY,numPlotX,plots_zy);
    AXES_HANDLES(3) = subplot(numPlotY,numPlotX,plots_xz);

    imshowpair(im1Z,imEndZ,'parent',AXES_HANDLES(1))
    hold(AXES_HANDLES(1),'on')
    REC_HANDLES(1) = rectangle('Position',recPosZ_rc([2,1,4,3]),'Curvature',[1 1],'edgecolor','m','linewidth',2,'parent',AXES_HANDLES(1));
    title(AXES_HANDLES(1),'Z Projection')

    imshowpair(im1X,imEndX,'parent',AXES_HANDLES(2))
    hold(AXES_HANDLES(2),'on');
    REC_HANDLES(2) = rectangle('Position',recPosX_rc([2,1,4,3]),'Curvature',[1 1],'edgecolor','m','linewidth',2,'parent',AXES_HANDLES(2));
    title(AXES_HANDLES(2),'X Projection')

    imshowpair(im1Y,imEndY,'parent',AXES_HANDLES(3))
    hold(AXES_HANDLES(3),'on');
    REC_HANDLES(3) = rectangle('Position',recPosY_rc([2,1,4,3]),'Curvature',[1 1],'edgecolor','m','linewidth',2,'parent',AXES_HANDLES(3));
    title(AXES_HANDLES(3),'Y Projection')

    AXES_HANDLES(4) = subplot(numPlotY,numPlotX,plots_frap);
    title(AXES_HANDLES(4),'Frap Data');

    set(FIGURE_HANDLE,'WindowButtonDownFcn',@MipButtonDown,...
        'WindowButtonMotionFcn',@MipButtonMotion,...
        'WindowButtonUpFcn',@MipButtonUp,...
        'WindowKeyPressFcn',@MipKeyDown,...
        'WindowKeyReleaseFcn',@MipKeyUp);
    
    ud.IsDown = false;
    ud.AltKey = false;
    ud.ControlKey = false;
    ud.ShiftKey = false;
    
    set(FIGURE_HANDLE,'UserData',ud);
end
