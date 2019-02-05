function MipKeyUp(src,event)
    global FIGURE_HANDLE
    
    ud = get(FIGURE_HANDLE,'UserData');
    
    switch event.Key
        case 'alt'
            ud.AltKey = false;
        case 'control'
            ud.ControlKey = false;
        case 'shift'
            ud.ShiftKey = false;
        otherwise
    end
    
    set(FIGURE_HANDLE,'UserData',ud);
end
