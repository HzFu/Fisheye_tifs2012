function [ Weight ] = Combine( V_point,D_point)
% Computing the combine cue.

 Weight=log(V_point*D_point+1);

end

