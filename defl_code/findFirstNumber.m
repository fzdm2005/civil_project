function number = findFirstNumber(str)
num_str = [];
flag = 0;
for i = 1:length(str)
    if ~isempty(str2num(str(i)))
        flag = 1;
        num_str = [num_str, str(i)];
    else
        if flag == 1
            break
        end
    end
end
number = str2double(num_str);
    