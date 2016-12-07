function str = alterPath( str )

% 主要是为了fprintf地址到txt中，因此要把'\'写成'/'
str = strrep(str, '\', '/');