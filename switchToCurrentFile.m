% ���ܣ�        �л�����ǰλ�� 

function varargout = switchToCurrentFile(fileName)
    location = which(fileName);
    i = strfind(location,'\');
    location = location(1:i(end));
    cd(location)
    varargout = {};
end