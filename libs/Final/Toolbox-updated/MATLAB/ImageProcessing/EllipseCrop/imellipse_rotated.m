function [xc, yc, a, b, phi] = imellipse_rotated(im_slice)
    %{
     This function allows the a user to draw a rotated ellipse by editted the length and position of two, always orthogonal, lines.
     This function takes as an argument, an image (not drawn, just the pixel-matrix)
     This function returns:
        xc -> x_center point of ellipse drawn
        yc -> y_center point of ellipse drawn
        a -> major axis of ellipse drawn
        b -> minor axis of ellipse drawn
        phi -> angle between the major axis of the ellipse drawn and the x-axis (in radians)
    %}
    f = figure('units', 'normalized', 'outerposition', [0 0 1 1]); hold on;
    ellips = plot(0,0);  %Initially define 'ellips' variable, so it can be deleted in draw_ellipse
    
    set(gcf,'color','w');
    imshow(im_slice,'DisplayRange',[0 500]); 
    hold on;
    line1 = imline(gca,[256 210; 256 302]);  %The initial position of both lines is set, assuming the size of the image is 512x512
    setColor(line1,'r');
    line2 = imline(gca,[208 256; 304 256]);
    setColor(line2,'g');
    hold on;
    pos_line1 = getPosition(line1);
    pos_line2 = getPosition(line2);
    
    %Define function to use for constrain (so user cannot drag outside the image)
    fcn = makeConstrainToRectFcn('imline',[0 512],...
        [0 512]);
    setPositionConstraintFcn(line1,@(pos)fcn(pos));
    setPositionConstraintFcn(line2,@(pos)fcn(pos));
    
  
    
    addNewPositionCallback(line2,@(pos)callback_line2(pos));
    addNewPositionCallback(line1,@(pos)callback_line1(pos));
    
    wait(line2);  % User must double click the green line to continue
    %Calculate output data one last time, to ensure the values outputted
    %are the most recent.
    [xc,yc,a,b,phi] = get_ellipse([pos_line1(1) pos_line1(3)],[pos_line1(2) pos_line1(4)],...
                         [pos_line2(1) pos_line2(3)], [pos_line2(2)
                         pos_line2(4)]);
    
                   
    function callback_line1(pos)
        %Ensures that line1 is always perpendicular to line2
        % Must update line2 based on line1's position
        pos_line1 = getPosition(line1);
        pos_line2 = getPosition(line2);
        
        [xc,yc,a,b,phi] = get_ellipse([pos_line1(1) pos_line1(3)],[pos_line1(2) pos_line1(4)],...
                         [pos_line2(1) pos_line2(3)], [pos_line2(2) pos_line2(4)]);
        
        % Get middle
        pos_center = [(pos_line1(1,1)+pos_line1(2,1))/2 (pos_line1(1,2)+pos_line1(2,2))/2];

        % Find displacement
        vec_disp = [pos_line1(2,1)-pos_line1(1,1) pos_line1(2,2)-pos_line1(1,2)];

        % Get normal unit vector
        vec_perp = [-vec_disp(2) vec_disp(1)]/norm(vec_disp);

        % Preserve length of line2
        length_line2 = norm([pos_line2(2,1)-pos_line2(1,1) pos_line2(2,2)-pos_line2(1,2)]);

        pos_line2_update = [-vec_perp*length_line2/2+pos_center;
                            vec_perp*length_line2/2+pos_center];
        % Set Position
        setPosition(line2,pos_line2_update);
       
        
       
    end
        
    function callback_line2(pos)
        %Ensures that line2 is always perpendicular to line1
        % Must update line1 based on line2's position
        pos_line1 = getPosition(line1);
        pos_line2 = getPosition(line2);
        
        [xc,yc,a,b,phi] = get_ellipse([pos_line1(1) pos_line1(3)],[pos_line1(2) pos_line1(4)],...
                         [pos_line2(1) pos_line2(3)], [pos_line2(2) pos_line2(4)]);

        % Get middle
        pos_center = [(pos_line2(1,1)+pos_line2(2,1))/2 (pos_line2(1,2)+pos_line2(2,2))/2];

        % Find displacement
        vec_disp = [pos_line2(2,1)-pos_line2(1,1) pos_line2(2,2)-pos_line2(1,2)];

        % Get normal unit vector
        vec_perp = [-vec_disp(2) vec_disp(1)]/norm(vec_disp);

        % Preserve length of line2
        length_line1 = norm([pos_line1(2,1)-pos_line1(1,1) pos_line1(2,2)-pos_line1(1,2)]);

        pos_line1_update = [-vec_perp*length_line1/2+pos_center;
                            vec_perp*length_line1/2+pos_center];

        % Set position
        setPosition(line1,pos_line1_update);
        
        
    end

    function [xc, yc, a, b, phi] = get_ellipse(p1,p2,p3,p4)
    % From the points of each line, this function calculates the ellipse
    a = (((p4(2)-p3(2))^2 + (p4(1)-p3(1))^2)^.5)/2; % Find a-axis of ellipse
    a = a + 15; % Increase the a axis by 5% to make it easier to grab line points
    b = (((p2(2)-p1(2))^2 + (p2(1)-p1(1))^2)^.5)/2;  % Find b-axis of ellipse
    b = b + 15; % Increase the b axis by 5% to make it easier to grab line points
        
        
    m_a = (p3(2) - p4(2))/(p3(1) - p4(1));  % Solve for the slope of second line input
    b_a = p3(2) - (m_a*p3(1));  % Get y-intercept of second line input (to get form y=m_a*x + b_a)
    m_b = (p1(2)-p2(2))/(p1(1)-p2(1)); % Solve for the slope of the first line input
    b_b = p1(2) - (m_b*p1(1));  % Get y-intercept of first line input (to get form y=m_b*x+b_b)
    
    
    
    xc = (b_b - b_a)/(m_a-m_b);  % Get x coordinate at which both lines intercept
    yc = m_a*xc + b_a;  % Get y coordinate at which both lines intercept
   
    axis = [a b];
    if max(axis) == a
        phi = atan(m_a);% Get angle of rotation (angle between the x-axis and the green line)
    elseif max(axis) == b
        phi = atan(m_b);
        temp_a = a;
        a = b;
        b = temp_a;
    end
    
    draw_ellipse(xc,yc,a,b,phi); % Draw the calculated ellipse
    end
    
    function draw_ellipse(xc, yc, a, b, phi)
       % This function draws the ellipse with center point (xc,yc)with a
       % major axis of a and minor axis of b, rotated phi radians between
       % the x-axis and the major axis
       
       hold on;  % So a new window won't be opened and the ellipse will be plotted over the current figure
       delete(ellips);  % Deletes the last ellipse drawn
       t = 0:.01:2*pi;  % Make range for parametric equations
       x = xc + a*cos(t)*cos(phi) - b*sin(t)*sin(phi);  % Parametric equation of ellipse
       y = yc + b*sin(t)*cos(phi) + a*cos(t)*sin(phi);
       ellips = plot(x,y,'c');  % Plot x and y
        
    end

        
end