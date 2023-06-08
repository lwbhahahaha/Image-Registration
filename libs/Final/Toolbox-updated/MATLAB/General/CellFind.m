function matches = CellFind(cell_array, regex)
%CELLFIND Returns all entries that match the regular expression
%
% matches = CellFind(cell_array, regexp)
%
% Finds all elements of cell_array that have a match with regexp and
% returns the full element. Useful as a file filter after using {dir.name}.

inds = cellfun(@isempty, regexp(cell_array, regex));

matches = cell_array(~inds);