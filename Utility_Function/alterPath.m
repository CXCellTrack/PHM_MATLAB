function str = alterPath( str )

% ��·���е�'\'�滻Ϊ'/'���Թ�logд��ʹ��
str = strrep(str, '\', '/');