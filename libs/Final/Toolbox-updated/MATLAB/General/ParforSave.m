function ParforSave(filename, var1, var2, var3, var4, var5 )
% PARFORSAVE Allows the use of save from within a parfor loop.
% ParforSave(filename, var1, var2, var3, var4, var5 )
% 
% Is simply a wrapper for save() to make the variable names transparent so
% that they can be used in a parallel loop.

switch(nargin-1) % -1 to remove the filename variable from the count
    case 5
        save(filename, 'var1', 'var2', 'var3', 'var4', 'var5');
    case 4
        save(filename, 'var1', 'var2', 'var3', 'var4');
    case 3
        save(filename, 'var1', 'var2', 'var3');
    case 2
        save(filename, 'var1', 'var2');
    case 1
        save(filename, 'var1');
    otherwise
        disp('ParforSave: number of arguments not supported, edit this function to add the capability.');
end