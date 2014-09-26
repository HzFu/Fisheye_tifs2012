function [ fake_saliency ] = Line2image( fake_saliency,value,Points )
%Add saliency weight of a line into the fake saliency map.

y1=(Points(1, 1));
x1=(Points(1, 2));
y2=(Points(2, 1));
x2=(Points(2, 2));
y3=(Points(3, 1));
x3=(Points(3, 2));

x = linspace(x1,x2,10000);
y=(x-x1)*(y2-y1)/(x2-x1) +y1;
index = sub2ind(size(fake_saliency),round(x),round(y));
fake_saliency(index) = round(255*value); 

x = linspace(x3,x2,10000);
y=(x-x3)*(y2-y3)/(x2-x3) +y3;
index = sub2ind(size(fake_saliency),round(x),round(y));
fake_saliency(index) = round(255*value); 

end

