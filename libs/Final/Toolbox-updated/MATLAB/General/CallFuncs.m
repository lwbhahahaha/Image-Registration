function CallFuncs(varargin)
%CALLFUNCS Simple utility function that calls each of its inputs
%
% CallFuncs(varargin)
%
% Essentially replaces a call to multiple functions with a single function
% call. This is useful in places where multiple statements are not allowed,
% such as for inline (anonymous) functions. Also can be used as the target
% of a callback.

for i = 1 : nargin
    varargin{i}();
end