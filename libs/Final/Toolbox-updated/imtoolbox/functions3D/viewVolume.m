function [figh] = viewVolume(vol, vol_mask, alpha, sm, figh)
            % viewVolume [ ] = viewVolume(vol, c, alpha, sm, figh
            %   VIEW VOLUME BY RENDERING EXTERIOR OF VOLUME
            %
            %	INPUTS:
            %	# vol - [MxNxL IMAGE VOLUME | 3D IMAGE VOLUME, BINARY IMAGE DEFINING VOLUME TO VIEW]
            %   # c - [3x1 DOUBLE | RGB COLOR OF VOLUME]
            %   # alpha - [DOBULE | TRANSPARENCY 0 - 1]
            %   # sm - [DOUBLE | SMOOTH FACTOR - MUST BE ODD NUMBERED]
            %   # figh - [FIGURE HANDLE | FIGURE HANDLE TO ADD NEW VOLUME
            %   TO]
            %	
            %	OUTPUTS:
            %
            
           
            if nargin == 5
                figh = figure;                
            end
            hold on;
            
            % Smooth volume
%             vol_perf_smoothed = FastFilt3D(vol, vol_mask == 1 & (vol > 0), 5, @mean);
            
            colormap(jet);
            vol_smooth = smooth3(vol_mask, 'box', [sm sm sm]);
            [faces, verts] = isosurface(vol_smooth);
           
            vert_indices = sub2ind(size(vol), round(verts(:,2)), round(verts(:,1)), round(verts(:,3)));
            colors = vol(vert_indices) ./ 100; % NOTE DIVIDE BY 100 IS TO UNDO SCALING DONE ELSE WHERE!!!!!!
            vol_iso = patch('Faces', faces, 'Vertices', verts, 'FaceVertexCData', colors,...
            'FaceColor', 'interp',...
            'EdgeColor', 'none',...
            'FaceAlpha', alpha,...
            'Parent', gca);
            isonormals(vol_smooth, vol_iso);
            
            caxis([0, 5]);

            colorbar;

            % SETUP VIEW IF NO FIGURE HANDLE
            % CHANGE TO DIFFERENT SETTINGS BY CREATING A FIGURE AND
            % PASSING THE HANDLE TO THIS FUNCTION
            view(3); 
            axis tight; 
            daspect([1 1 .858]);
            camlight left; 
            camlight;
            camproj perspective;
            lighting gouraud;
            rotate3d;
            axis(gca,'vis3d');
            axis off
            grid off
           
        end