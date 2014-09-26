function [ Distance ] = Distance_inv( Points,fish_x,fish_y,fish_r,f )
% Computing the distance cue of line on viewing sphere
% Input:
%   Points is the three point of candidate line.
%   fish_x, fish_y, fish_r are the center and radius of fisheye image. 
%   f is the virtual focal length.
% Output:
%   Distance is the distance cue.

Forgery_points=3:3;% image (x, y, r, gamma)
 for i =1:3
     Forgery_points(i,1)=(Points(i, 1)-fish_x)/fish_r;
     Forgery_points(i,2)=(Points(i, 2)-fish_y)/fish_r;
     Forgery_points(i,3)=sqrt(abs(Forgery_points(i,1)^2+Forgery_points(i,2)^2));
     if (f==1)
         theta(i)=2*atan(Forgery_points(i,3));
     else
         theta(i)=2*atan((f-sqrt(abs(f^2+Forgery_points(i,3)^2-f^2 * Forgery_points(i,3)^2)))...
        /(Forgery_points(i,3)*(f-1))) ;
     end
 end
%---------- calculate the spherical points of the forgery line-------
Sphere_points=3:4;% spherical points (x, y, z)
 for i =1:3
     Sphere_points(i,1)=Forgery_points(i,1) / Forgery_points(i,3) * sin(theta(i));
     Sphere_points(i,2)= Forgery_points(i,2)/ Forgery_points(i,3) * sin(theta(i));
     Sphere_points(i,3)=cos(theta(i));
     Sphere_points(i,4)=1;
 end

%----------- calculate spherical triangle volume -----------
PlaneA=det([Sphere_points(:,2) Sphere_points(:,3) Sphere_points(:,4)]);
PlaneB=-det([Sphere_points(:,1) Sphere_points(:,3) Sphere_points(:,4)]);
PlaneC=det([Sphere_points(:,1) Sphere_points(:,2) Sphere_points(:,4)]);
PlaneD=-det([Sphere_points(:,1) Sphere_points(:,2) Sphere_points(:,3)]);

Distance=abs(PlaneD)/sqrt(PlaneA^2+PlaneB^2+PlaneC^2);

end


