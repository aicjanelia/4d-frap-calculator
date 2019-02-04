function MipButtonDown(src,event)
    global FIGURE_HANDLE AXES_HANDLES REC_HANDLES
    
    m = get(FIGURE_HANDLE,'CurrentModifier');
    selectedAxes = find(event.Source.CurrentAxes == AXES_HANDLES);
    if (selectedAxes>3)
        return
    end
    
    mousePos = get(AXES_HANDLES(selectedAxes),'currentPoint');
    pointDown_xy = round(mousePos(1,1:2));
    if (any(pointDown_xy<1))
        return
    end
    
    xL = get(AXES_HANDLES(selectedAxes),'xlim');
    if (xL(2)<pointDown_xy(1))
        return
    end
    yL = get(AXES_HANDLES(selectedAxes),'ylim');
    if (yL(2)<pointDown_xy(2))
        return
    end
    
    ud = get(FIGURE_HANDLE,'UserData');
    
    if (isempty(ud) || ~ud.IsDown)
        ud.IsDown = true;
        set(FIGURE_HANDLE,'UserData',ud);
        
        UpdateRecCenter(pointDown_xy,selectedAxes,REC_HANDLES);
    end
end
