% Demo for "Forgery Authentication in Extreme Wide-angle Lens Using Distortion Cue and Fake Saliency Map" 


close all; clear; clc;
% Read data
savefile = 'ForensicImage/PSTest-2';
orgimage = imread(strcat(savefile,'.jpg'));
load(strcat(savefile,'.mat'));
figure,imshow(orgimage);title('Forgery image');

% compute the measure cue
K_value=line_number:4;
fake_saliency=zeros(size(orgimage,1),size(orgimage,2),'uint8'); 
Grave_Point_x=0;
Grave_Point_y=0;
Grave_K=0;
for i=1:line_number   
    % the distance cue
    K_value(i,1)=Distance_inv(Points(((1+(i-1)*3):(3+(i-1)*3)),:),fish_x,fish_y,fish_r,1);
    % the volume cue
    K_value(i,2)=Volume_inv(Points(((1+(i-1)*3):(3+(i-1)*3)),:),fish_x,fish_y,fish_r,1);
    % the combine cue
    K_value(i,3)=Combine(K_value(i,2),K_value(i,1));
    % the untrustworthy likelihood
    K_value(i,4)=1-0.9*exp(-(K_value(i,3)*10)^2/((0.2^2)*2));
    % compute the center of gravity
    if K_value(i,4)>0.5
    Grave_Point_x=Grave_Point_x+1*(Points(1+(i-1)*3,1)...
        +Points(2+(i-1)*3,1)+Points(3+(i-1)*3,1));
    Grave_Point_y=Grave_Point_y+1*(Points(1+(i-1)*3,2)...
        +Points(2+(i-1)*3,2)+Points(3+(i-1)*3,2));
    Grave_K=Grave_K+1;
    end
    fake_saliency = Line2image(fake_saliency, K_value(i,4),...
        Points(((1+(i-1)*3):(3+(i-1)*3)),:));
end

I=rgb2gray(orgimage);
BW= edge(I,'canny',0.1);
figure,imshow(BW); title('Forgery line detection');
hold on;
for i=1:line_number  
    if K_value(i,4)>0.5 % line detection with S>0.5
        plot(Points((1+(i-1)*3),1),Points((1+(i-1)*3),2),'Color', [1,0,0]);
        plot(Points((2+(i-1)*3),1),Points((2+(i-1)*3),2),'Color', [1,0,0]);
        plot(Points((3+(i-1)*3),1),Points((3+(i-1)*3),2),'Color', [1,0,0]);
        line([Points((1+(i-1)*3),1) Points((2+(i-1)*3),1)], [Points((1+(i-1)*3),2) Points((2+(i-1)*3),2)],...
            'Color', [1,0,0], 'LineWidth', 3)
        line([Points((2+(i-1)*3),1) Points((3+(i-1)*3),1)], [Points((2+(i-1)*3),2) Points((3+(i-1)*3),2)],...
            'Color', [1,0,0], 'LineWidth', 3)
    else
        plot(Points((1+(i-1)*3),1),Points((1+(i-1)*3),2),'Color', [0,1,0]);
        plot(Points((2+(i-1)*3),1),Points((2+(i-1)*3),2),'Color', [0,1,0]);
        plot(Points((3+(i-1)*3),1),Points((3+(i-1)*3),2),'Color', [0,1,0]);
        line([Points((1+(i-1)*3),1) Points((2+(i-1)*3),1)], [Points((1+(i-1)*3),2) Points((2+(i-1)*3),2)],...
            'Color', [0,1,0], 'LineWidth', 3)
        line([Points((2+(i-1)*3),1) Points((3+(i-1)*3),1)], [Points((2+(i-1)*3),2) Points((3+(i-1)*3),2)],...
            'Color', [0,1,0], 'LineWidth', 3)
    end
end

% Generate the fake saliency map
if Grave_K~=0
    Grave_Point_x=round(Grave_Point_x/(Grave_K*3));
    Grave_Point_y=round(Grave_Point_y/(Grave_K*3));
    fake_saliency(Grave_Point_y-10:Grave_Point_y+10,...
        Grave_Point_x-10:Grave_Point_x+10)=255;
end

thick=max(size(fake_saliency,1),size(fake_saliency,2));
fake_saliency = imdilate(fake_saliency,strel('ball',round(thick/30),round(thick/30)));
fake_saliency = imfilter(fake_saliency,fspecial('gaussian', [round(thick/10) round(thick/10)], round(thick/10)));
fake_saliency=im2double(fake_saliency);
if Grave_K~=0
    fake_saliency=fake_saliency.*(0.9/max(max(fake_saliency)));
end
figure,imshow(fake_saliency), colormap(hot); title('Fake saliency map');


