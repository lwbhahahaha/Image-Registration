function [I] = ellipse_mask(xc,yc,a,b,phi,I)
%This function will create a ellipse mask using the following information
%about the ellipse:
%Center Point: (xc,yc)
%Major Axis:  a
%Minor Axis: b
%Angle Between Major Axis and X-Axis:  phi

%Using the standard form of an ellipse, rotated phi radians about the
%x-axis (from the major axis), a boolean expression is used to create a
%mask over all points that do not satisfy the standard form.
imSize = size(I);
for i=1:imSize(2)
    for j=1:imSize(1)
        if ((i-xc)*cos(phi)+(j-yc)*sin(phi))^2/a^2 ...
         + ((i-xc)*sin(phi)-(j-yc)*cos(phi))^2/b^2 >= 1
        I(j,i) = 0;
        end
    end
end


