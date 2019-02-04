function [im,imMeta] = LoadData(rootDir)
    [im,imMeta] = MicroscopeData.Reader(rootDir,'prompt', false);
    if (isempty(im))
        resp = questdlg('Can I rename the KLB files for you?','Rename','Yes','No','Yes');
        if (isempty(resp) || ~strcmp(resp,'Yes'))
            return
        end
        LLSM.RenameKLBdirs(fullfile(rootDir,'..'));
        [im,imMeta] = MicroscopeData.Reader(rootDir,'prompt', false);
        if (isempty(im))
            error('Something is wrong with reading the KLB files!');
        end
    end
end
