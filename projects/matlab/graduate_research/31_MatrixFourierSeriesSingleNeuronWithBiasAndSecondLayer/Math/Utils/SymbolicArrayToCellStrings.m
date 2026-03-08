function cell_strs = SymbolicArrayToCellStrings(sym_array)

cell_strs = cell(size(sym_array));

for idx = 1:length(sym_array)
    temp = arrayfun(@char, sym_array(idx), 'uniform', 0);
    cell_strs{idx} = temp{1};
end

end

