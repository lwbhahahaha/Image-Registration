function ANormed = NormalizeGrayscale(A, type, mask)
% NORMALIZEGRAYSCALE Rescales an array to fill an integer type range 
%
% ANormed = NormalizeGrayscale(A, type)
%
% ANormed is a normalized representation of the input matrix A. It is
% returned as a double type for simplicity. Cast it to uint* after the call
% if you like. The range of values is specified by the type parameter:
%   uint8 0-255     uint16 0-65535      'uint32' 0-(2^32-1)
%
% ANormed = NormalizeGrayscale(A)
% type will default to 'uint16' if not specified
%
% ANormed = NormalizeGrayscale(A, type, mask) 
% If the third input, mask, exists, then only pixels within the mask are
% normalized and zeros are preserved

if nargin < 2
    type = 'uint16';
end
if nargin < 3
    mask = [];
end

switch type
    case 'uint8'
        new_max = 2^8-1;
    case 'uint16'
        new_max = 2^16-1;
    case 'uint32'
        new_max = 2^32-1;
    otherwise
        error('Unsupported conversion.');
end

ANormed = double( A );

if( ~isempty(mask) )
    % ensure that the mask is of the logical persuasion
    mask = logical(mask);
    values = ANormed(mask > 0);
    % Get the min (and max) of the nonzero values
    Min = min( values(:) );
    Max = max( values(:) );
    % Here we rescale the nonzero values to the range 0 to 2^16 -2 and then
    % add one to get the desired range, and then reapply the mask.
    % Make the mininum of what we want 0
    ANormed = ANormed - Min;
    % Make the maximum of what we want 1
    ANormed = ANormed / (Max - Min);
    % Scale to the new maximum (- 1)
    ANormed = ANormed .* (new_max-1);
    % Add one to get to the desired range
    ANormed = ANormed + 1;
    % reapply the mask
    ANormed = ANormed .* double(mask);

else % No mask, simply call mat2gray
    ANormed = mat2gray(ANormed) .* new_max;
end