function [ Volume ] = Volume_inv( Points,fish_x,fish_y,fish_r,f )
% Computing the volume cue of line on viewing sphere
% Input:
%   Points is the three point of candidate line.
%   fish_x, fish_y, fish_r are the center and radius of fisheye image. 
%   f is the virtual focal length.
% Output:
%   Volume is the volume cue.


Forgery_points=3:3;% image (x, y, r, gamma)
 for i =1:3
     Forgery_points(i,1)=(Points(i, 1)-fish_x)/fish_r;
     Forgery_points(i,2)=(Points(i, 2)-fish_y)/fish_r;
     Forgery_points(i,3)=sqrt(Forgery_points(i,1)^2+Forgery_points(i,2)^2);
     if (f==1)
         theta(i)=2*atan(Forgery_points(i,3));
     else
         theta(i)=2*atan((f-sqrt(f^2+Forgery_points(i,3)^2-f^2 * Forgery_points(i,3)^2))...
        /(Forgery_points(i,3)*(f-1))) ;
     end
 end
%---------- calculate the spherical points of the forgery line-------
Sphere_points=3:3;% spherical points (x, y, z)
 for i =1:3
     Sphere_points(i,1)=Forgery_points(i,1) / Forgery_points(i,3) * sin(theta(i));
     Sphere_points(i,2)= Forgery_points(i,2)/ Forgery_points(i,3) * sin(theta(i));
     Sphere_points(i,3)=cos(theta(i));
 end

%----------- calculate spherical triangle volume-----------
angle=(Forgery_points(1,1)-Forgery_points(3,1))^2+(Forgery_points(1,2)-Forgery_points(3,2))^2;
Volume=abs(det(Sphere_points)) /((sqrt(angle))^3);
end

