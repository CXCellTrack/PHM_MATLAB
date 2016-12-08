function str = alterPath( str )

% 将路径中的'\'替换为'/'，以供log写入使用
str = strrep(str, '\', '/');