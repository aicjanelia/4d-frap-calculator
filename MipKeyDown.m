function MipKeyDown(src,event)
    global FIGURE_HANDLE
    
    ud = get(FIGURE_HANDLE,'UserData');
    
    switch event.Key
        case 'alt'
            ud.AltKey = true;
        case 'control'
            ud.ControlKey = true;
        case 'shift'
            ud.ShiftKey = true;
        otherwise
    end
    
    set(FIGURE_HANDLE,'UserData',ud);
end
