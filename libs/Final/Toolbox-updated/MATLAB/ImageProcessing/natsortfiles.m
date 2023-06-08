function [X,ndx] = natsortfiles(X,varargin)
% Natural-order sort of a cell array of filenames/fullpaths, with customizable numeric format.
%
% (c) 2014 Stephen Cobeldick
%
% Sort a cell array of filenames/fullpaths, sorting the strings by both character
% order and the values of any numeric substrings that occur within the strings.
%
% The constituent parts of each filename/fullpath are sorted separately: each level
% of the directory hierarchy (see "filesep"), the filenames and file extensions.
% This ensures that shorter filenames sort before longer: simply using a natural-
% order sort on filenames will incorrectly sort any of char(0:45), including
% [ !"#$%&'()*+,-], before the extension separator [.]. See the first example below.
%
% Similarly the file separator character within fullpaths can cause longer
% directory names to sort before short ones (char(0:46)<'/' and char(0:91)<'\').
% This submission splits fullpaths at each file separator characters and sorts
% every level of the directory hierarchy separately, so that shorter directory
% names come before longer and files in the same directory are grouped together.
%
% The natural-order sort is provided by the function "natsort" (File Exchange 34464).
% All optional inputs are passed directly to "natsort": see "natsort" for more
% information on case sensitivity, sort direction, and numeric substring matching.
%
% Syntax:
%   X = natsortfiles(X)
%  [X,ndx] = natsortfiles(...)
%  [...] = natsortfiles(X,xpr)
%  [...] = natsortfiles(X,xpr,<options>)
%
% To sort all of the strings in a cell array use "natsort" (File Exchange 34464).
% To sort the rows of a cell array of strings use "natsortrows" (File Exchange 47433).
%
% See also NATSORT NATSORTROWS SORT SORTROWS CELLSTR REGEXP FILEPARTS FILESEP FULLFILE PWD DIR
%
% ### Examples ###
%
% fnm = {'test2.m';'test.m';'test10.m';'test1.m';'test-A.m';'test_A.m';'test10-old.m'};
% % Numeric substrings in the wrong order:
% sort(fnm)
% ans = {...
%     'test-A.m'
%     'test.m'
%     'test1.m'
%     'test10-old.m'
%     'test10.m'
%     'test2.m'
%     'test_A.m'}
% % Correct numeric order, but '-' still sorts before '.':
% natsort(fnm)
% ans = {...
%     'test-A.m'
%     'test.m'
%     'test1.m'
%     'test2.m'
%     'test10-old.m'
%     'test10.m'
%     'test_A.m'}
% % Shorter filenames sort before longer:
% natsortfiles(fnm) % default = numeric treated as a digit character
%     'test.m'
%     'test-A.m'
%     'test1.m'
%     'test2.m'
%     'test10.m'
%     'test10-old.m'
%     'test_A.m'}
% natsortfiles(fnm,'\d+','beforechar') % see "natsort" for options list
% ans = {...
%     'test.m'
%     'test1.m'
%     'test2.m'
%     'test10.m'
%     'test10-old.m'
%     'test-A.m'
%     'test_A.m'}
%
% fpt = {...
%     'C:\Bob2\Work\test2.txt';...
%     'C:\info.log';...
%     'C:\Anna20\dir2\weigh.m';....
%     'C:\Bob10\article.doc';...
%     'C:\Anna_archive.zip';...
%     'C:\info1.log';...
%     'C:\Anna1\noise.mp3';...
%     'C:\Bob2\Work\test10.txt';...
%     'C:\info.txt';...
%     'C:\Anna3-all\archive.zip';...
%     'C:\Bob2\Work\test1.txt';...
%     'C:\Anna20\dir10\weigh.m';...
%     'C:\info10.log';...
%     'C:\Bob10_article.tex';...
%     'C:\Anna1\noise.mp10';...
%     'C:\info2.txt';...
%     'C:\Anna1archive.zip';...
%     'C:\Anna20\dir1\weigh.m';...
%     'C:\Anna3\budget.pdf';...
%     'C:\Bob1\menu.png';...
%     'C:\Anna1\noise.mpX';...
%     'C:\info2.log'};
% % Mixed subdirectory levels ('\' treated as a character):
% natsort(fpt)
% ans = {...
%     'C:\Anna1archive.zip'
%     'C:\Anna1\noise.mp3'
%     'C:\Anna1\noise.mp10'
%     'C:\Anna1\noise.mpX'
%     'C:\Anna3-all\archive.zip'
%     'C:\Anna3\budget.pdf'
%     'C:\Anna20\dir1\weigh.m'
%     'C:\Anna20\dir2\weigh.m'
%     'C:\Anna20\dir10\weigh.m'
%     'C:\Anna_archive.zip'
%     'C:\Bob1\menu.png'
%     'C:\Bob2\Work\test1.txt'
%     'C:\Bob2\Work\test2.txt'
%     'C:\Bob2\Work\test10.txt'
%     'C:\Bob10\article.doc'
%     'C:\Bob10_article.tex'
%     'C:\info.log'
%     'C:\info.txt'
%     'C:\info1.log'
%     'C:\info2.log'
%     'C:\info2.txt'
%     'C:\info10.log'}
% % Shorter directory names sort before longer:
% natsortfiles(fpt)
% ans = {...
%     'C:\Anna1archive.zip'
%     'C:\Anna_archive.zip'
%     'C:\Bob10_article.tex'
%     'C:\info.log'
%     'C:\info.txt'
%     'C:\info1.log'
%     'C:\info2.log'
%     'C:\info2.txt'
%     'C:\info10.log'
%     'C:\Anna1\noise.mp3'
%     'C:\Anna1\noise.mp10'
%     'C:\Anna1\noise.mpX'
%     'C:\Anna3\budget.pdf'
%     'C:\Anna3-all\archive.zip'
%     'C:\Anna20\dir1\weigh.m'
%     'C:\Anna20\dir2\weigh.m'
%     'C:\Anna20\dir10\weigh.m'
%     'C:\Bob1\menu.png'
%     'C:\Bob2\Work\test1.txt'
%     'C:\Bob2\Work\test2.txt'
%     'C:\Bob2\Work\test10.txt'
%     'C:\Bob10\article.doc'}
%
% ### Input and Output Arguments ###
%
% Please see "natsort" for a full description of <xpr> and the <options>.
%
% Inputs (*=default):
%  X   = CellOfStrings, with filenames/fullpaths to be sorted.
%  xpr = StringToken, regular expression to detect numeric substrings, '\d+'*.
%  <options> can be supplied in any order and are passed directly to "natsort".
%
% Outputs:
%  Y   = CellOfStrings, <X> with the filenames sorted according to <options>.
%  ndx = NumericMatrix, same size as <X>. Indices such that Y = X(ndx).
%
% [Y,ndx] = natsortrows(X,*xpr,<options>)

assert(iscellstr(X),'First input <X> must be a cell array of strings.')
%
% Split full filepaths into {path,name,extension}:
[pth,nam,ext] = cellfun(@fileparts,X(:),'UniformOutput',false);
% Split path into {root,subdir,subsubdir,...}
pth = regexp(pth,filesep,'split');
len = cellfun('length',pth);
vec(1:numel(len)) = {''};
%
% Natural-order sort of the extension, name and directories:
[~,ndx] = natsort(ext,varargin{:});
[~,ind] = natsort(nam(ndx),varargin{:});
ndx = ndx(ind);
for k = max(len):-1:1
    idx = len>=k;
    vec(~idx) = {''};
    vec(idx) = cellfun(@(c)c(k),pth(idx));
    [~,ind] = natsort(vec(ndx),varargin{:});
    ndx = ndx(ind);
end
%
% Return sorted array and indices:
ndx = reshape(ndx,size(X));
X = X(ndx);
%
end
%----------------------------------------------------------------------END:natsortfiles