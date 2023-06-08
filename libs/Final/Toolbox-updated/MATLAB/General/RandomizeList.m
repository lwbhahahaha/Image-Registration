function randList = RandomizeList( list )
% RandomizeList randomizes the entries in a cell or numeric list.

isCell = iscell( list );
if ~ isCell
    list = num2cell( list );
end

randList = cell( size(list) );

% could use randsample to improve efficiency
for i = 1 : length(list)
   randIndex = randi( length(list) );
   randList(i) = list( randIndex );
   list( randIndex ) = [];
end

if ~ isCell
    randList = cell2mat( randList );
end