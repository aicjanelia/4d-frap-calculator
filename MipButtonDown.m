function MipButtonDown(src,event)
    global FIGURE_HANDLE AXES_HANDLES REC_HANDLES
    
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
    
    if (~ud.IsDown)
        ud.IsDown = true;
        ud.PointDown_xy = pointDown_xy;
        set(FIGURE_HANDLE,'UserData',ud);            
        
        if (~ud.ShiftKey && ~ud.ControlKey && ~ud.AltKey)
            UpdateRecCenter(pointDown_xy,selectedAxes,REC_HANDLES,':');
        end
    end
end
