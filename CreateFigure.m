function CreateFigure(im,imMeta,channel,satLevel)
    global FIGURE_HANDLE AXES_HANDLES REC_HANDLES TEXT_HANDLES
    
    if (~exist('satLevel','var') || isempty(satLevel))
        satLevel = 0.95;
    end
    
    CalculatePhotoBleaching(im,channel,imMeta);

    im1 = mat2gray(im(:,:,:,channel,1));
    imEnd = mat2gray(im(:,:,:,channel,end));

    im1Z = ImUtils.BrightenImages(max(im1,[],3),'uint8',satLevel);
    imEndZ = ImUtils.BrightenImages(max(imEnd,[],3),'uint8',satLevel);
    sizeZ_rc = size(im1Z);
    midZ_rc = round(sizeZ_rc./2);
    radZ_rc = [10,10];
    recPosZ_rc = [midZ_rc-radZ_rc, radZ_rc.*2];

    im1X = ImUtils.BrightenImages(max(im1,[],2),'uint8',satLevel);
    im1X = permute(im1X,[1,3,2]);
    imEndX = ImUtils.BrightenImages(max(imEnd,[],2),'uint8',satLevel);
    imEndX = permute(imEndX,[1,3,2]);
    sizeX_rc = size(im1X);
    midX_rc = round(sizeX_rc./2);
    radX_rc = [10,10];
    recPosX_rc = [midX_rc-radX_rc, radX_rc.*2];

    im1Y = ImUtils.BrightenImages(max(im1,[],1),'uint8',satLevel);
    im1Y = permute(im1Y,[3,2,1]);
    imEndY = ImUtils.BrightenImages(max(imEnd,[],1),'uint8',satLevel);
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
    startPoint = [100,100];
    width = 1650;
    height = 1080;
    set(FIGURE_HANDLE,'name','FRAP ROI Selector','units','pixels','Position',[startPoint,width,height]);
%     AXES_HANDLES(1) = subplot(numPlotY,numPlotX,plots_xy);
    AXES_HANDLES(1) = subplot('Position',[5/width 200/height 500/width 850/height]);
%     AXES_HANDLES(2) = subplot(numPlotY,numPlotX,plots_zy);
    AXES_HANDLES(2) = subplot('Position',[510/width 200/height 150/width 850/height]);
%     AXES_HANDLES(3) = subplot(numPlotY,numPlotX,plots_xz);
    AXES_HANDLES(3) = subplot('Position',[5/width 10/height 500/width 160/height]);

    recColor = [0.3451, 0.5529, 1.0000];
%     recColor = [0.9255, 0.6275, 0.1176];
    imshowpair(im1Z,imEndZ,'parent',AXES_HANDLES(1))
    hold(AXES_HANDLES(1),'on')
    REC_HANDLES(1) = rectangle('Position',recPosZ_rc([2,1,4,3]),'Curvature',[1 1],'edgecolor',recColor,'linewidth',3,'parent',AXES_HANDLES(1));
    title(AXES_HANDLES(1),'Z Projection')
%     xlabel(AXES_HANDLES(1),'X'); %position needs to be fixed
%     ylabel(AXES_HANDLES(1),'Y')

    imshowpair(im1X,imEndX,'parent',AXES_HANDLES(2))
    hold(AXES_HANDLES(2),'on');
    REC_HANDLES(2) = rectangle('Position',recPosX_rc([2,1,4,3]),'Curvature',[1 1],'edgecolor',recColor,'linewidth',3,'parent',AXES_HANDLES(2));
    title(AXES_HANDLES(2),'X Projection')
%     xlabel(AXES_HANDLES(2),'Z'); %position needs to be fixed
%     ylabel(AXES_HANDLES(2),'Y')

    imshowpair(im1Y,imEndY,'parent',AXES_HANDLES(3))
    hold(AXES_HANDLES(3),'on');
    REC_HANDLES(3) = rectangle('Position',recPosY_rc([2,1,4,3]),'Curvature',[1 1],'edgecolor',recColor,'linewidth',3,'parent',AXES_HANDLES(3));
    title(AXES_HANDLES(3),'Y Projection')
%     xlabel(AXES_HANDLES(3),'X'); %position needs to be fixed
%     ylabel(AXES_HANDLES(3),'Z')

%     AXES_HANDLES(4) = subplot(numPlotY,numPlotX,plots_frap);
    AXES_HANDLES(4) = subplot('Position',[750/width 225/height 800/width 800/height]);
    title(AXES_HANDLES(4),'Frap Data');
    xlabel(AXES_HANDLES(4),'Time (s)')
    ylabel(AXES_HANDLES(4),'Intensity (au)')
    
    set(FIGURE_HANDLE,'WindowButtonDownFcn',@MipButtonDown,...
        'WindowButtonMotionFcn',@MipButtonMotion,...
        'WindowButtonUpFcn',@MipButtonUp,...
        'WindowKeyPressFcn',@MipKeyDown,...
        'WindowKeyReleaseFcn',@MipKeyUp);
    
    ud.IsDown = false;
    ud.AltKey = false;
    ud.ControlKey = false;
    ud.ShiftKey = false;
%     
    bh = uicontrol('Parent',FIGURE_HANDLE,'Style','pushbutton','String','Rest ROI','Units','normalized','Position',[545/width 50/height 100/width 22/height],'Visible','on','Callback',@ROIreset);
    bh2 = uicontrol('Parent',FIGURE_HANDLE,'Style','pushbutton','String','Export to file','Units','normalized','Position',[545/width 90/height 100/width 22/height],'Visible','on','Callback',@ExportCSV);
    TEXT_HANDLES(1) = uicontrol('Parent',FIGURE_HANDLE,'Style','edit','fontsize',14,...
        'String','A=0.00 +/-0.00  t1/2=0.00 +/-0.00  R-squared:0.00',...
        'Units','normalized','Position',[745/width  45/height 500/width 75/height],'Visible','on');
    
    t = annotation('textbox');
    t.Interpreter = 'none';
    t.Position = [1300/width  25/height 275/width 125/height];
    t.String = {...
        'Green is the first frame of the movie.';
        'Magenta is the last frame of the movie.';
        '';
        'Clicking & drag will move the ROI.';
        'Holding the shift key while clicking &';
        '    dragging will change the radius of the';
        '    ROI'};
%     
%     aH = uicontrol('Parent',FIGURE_HANDLE,'Style','text','String','A(1)','Units','normalized','position',[0.01 0.85 0.05 0.09]);
%     tH = uicontrol('Parent',FIGURE_HANDLE,'Style','text','String','t 1/2(1)','Units','normalized','position',[0.01 0.8 0.08 0.09]);
%     a2H = uicontrol('Parent',FIGURE_HANDLE,'Style','text','String','A(2)','Units','normalized','position',[0.01 0.75 0.05 0.09]);
%     t2H = uicontrol('Parent',FIGURE_HANDLE,'Style','text','String','t 1/2(2)','Units','normalized','position',[0.01 0.7 0.08 0.09]);
%     
    set(FIGURE_HANDLE,'UserData',ud);
end
