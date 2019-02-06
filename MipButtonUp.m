function MipButtonUp(src,event)
    global FIGURE_HANDLE REC_HANDLES
    ud = get(FIGURE_HANDLE,'UserData');

    ud.IsDown = false;

    set(FIGURE_HANDLE,'UserData',ud);

    set(REC_HANDLES(1),'lineStyle','-');
    set(REC_HANDLES(2),'lineStyle','-');
    set(REC_HANDLES(3),'lineStyle','-');

    UpdateFRAPplot();
end
