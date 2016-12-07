function str = mydeblank( str )
% 去除字符串前部和后部的空格
str = deblank(str);
if isempty(str)
    return;
end
while isspace(str(1))
    str(1) = [];
end

end
