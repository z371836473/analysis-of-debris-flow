% 功能：        切换到当前位置 

function varargout = switchToCurrentFile(fileName)
    location = which(fileName);
    i = strfind(location,'\');
    location = location(1:i(end));
    cd(location)
    varargout = {};
end