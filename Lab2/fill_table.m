function out = fill_table(data1, data2, data3, data4)

    mean1 = mean(data1)';
    mean2 = mean(data2)';
    mean3 = mean(data3)';
    mean4 = mean(data4)';
    x = [0.75 0.8 0.85 0.9 0.95]';
    name = {'x' 'saturated' 'bright' 'contrast' 'concurrent'};
    out = table(x, mean1, mean2, mean3, mean4, 'VariableNames', name);
    
end