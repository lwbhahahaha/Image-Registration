figure(1)
filename = 'VESSEL.gif';
for n = 113:227
      imshow(imFinal(:,:,n),[.01 .55]);
      drawnow
      frame = getframe(1);
      im = frame2im(frame);
      [imind,cm] = rgb2ind(im,100);
      I=ind2gray(imind,cm);
      if n == 113;
          imwrite(imFinal(:,:,n) ,filename,'gif', 'Loopcount',.001, 'BackgroundColor',15);
      else
          imwrite(imFinal(:,:,n),filename,'gif','WriteMode','append');
      end
end
close
% figure(1)
% filename = 'Old_SEG.gif';
% for n = 1:189
%       imshow(heartBW(:,n,:));
%       drawnow
%       frame = getframe(1);
%       im = frame2im(frame);
%       [imind,cm] = rgb2ind(im,256);
%       if n == 1;
%           imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
%       else
%           imwrite(imind,cm,filename,'gif','WriteMode','append');
%       end
% end
