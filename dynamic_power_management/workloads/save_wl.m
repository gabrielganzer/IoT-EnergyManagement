function wl = save_wl(active, idle, file, samples)
    wl_start = zeros(1, samples);
    wl_end = zeros(1, samples);
    wl_start(1) = active(1);
    wl_end(1) = active(1) + idle(1);
    for i = 2:samples
        wl_start(i) = wl_end(i-1) + active(i);
        wl_end(i) = wl_start(i) + idle(i);
    end
    wl = [wl_start' wl_end'];
    dlmwrite(file, wl, 'delimiter', ' ', 'precision', 8);
end