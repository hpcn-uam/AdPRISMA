function sep = find_separator(X, ts)
    m = ts(1);
    M = ts(end);
    target = (M - m)/2;
    index = find(ts(ts > target));
    index = index(1);
    sep = index;
end

