function str = mydeblank( str )
% ȥ���ַ���ǰ���ͺ󲿵Ŀո�
str = deblank(str);
if isempty(str)
    return;
end
while isspace(str(1))
    str(1) = [];
end

end
