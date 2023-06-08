function [ imfilt ] = MaskFilter( im, mask, nhood, func)
%MASKFILTER will filter im, using voxels from only the binary mask.
%
%   MaskFilter filters im using voxels from mask only.  It applies any
%   function that processes a vector of numbers (like mean, std, median,
%   mode, ect.).
%   Made only for 3D image volumes, but should be adapted to 2D.
%
%   INPUTS:
%
%   im                            Original image.
%
%
%   mask                          Binary mask of original image.
%
%
%   nhood                         Neighborhood of voxels to apply fitler
%                                 with.
%
%
%   func                          Function handle of any function that
%                                 takes an array of numbers as an input and
%                                 outputs a scalar.
%
%
%   OUTPUTS:
%
%   imfilt                        Filtered image.
%
%
%   AUTHOR:       Shant Malkasian
%   DATE CREATED: 26-Oct-2015
%

warning('This is decrepate, please use FastFilt3D.m\n type ''help FastFilt3D in console for more information''');
SIZE = size(im);
imfilt = im;

% Find all idx in mask that are equal to 1:
validIdx = find(mask ~= 0);

% Iterate over all validIdx and segment out volume, the size of nhood:
progressbar( 'This is going to take forever... use FastFilt3D instead!' )
for j = 1:length(validIdx)
    i = validIdx(j);
    [x,y,z] = ind2sub(SIZE,i);
    xRange = createBound(x, nhood, SIZE(1));
    yRange = createBound(y, nhood, SIZE(2));
    zRange = createBound(z, nhood, SIZE(3));
    tempblock = im(xRange, yRange, zRange);
    tempblockmask = mask(xRange, yRange, zRange);
    tempfilt = func(tempblock(tempblockmask ~= 0));
    imfilt(i) = tempfilt(:);
    progressbar( j/length(validIdx) )
end










%% Helper Functions
    function b2 = validateBound( b1, dim )
        % Returns a valid bound, if b1 is out of range of dim
        if (b1 < 1)
            b2 = 1;
            return
        end
        if (1 <= b1) & (b1 <= dim) 
            b2 = b1;
            return
        end
        if (b1 > dim)
            b2 = dim;
            return
        end
    end

    function nrange = createBound( b, n, dim )
        % Creates a valid bound, starting at b1, for n length
        indStart = validateBound(b - n, dim);
        indEnd = validateBound(b + n, dim);
        nrange = indStart:indEnd;
    end
  

end
