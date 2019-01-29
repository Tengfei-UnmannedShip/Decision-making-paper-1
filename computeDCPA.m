function d = computeDCPA(v_own,course_own,pos_own,v_target,course_target,pos_target)
%% 基本的CPA计算，只是根据当前的位置和航速航向计算CPA
x_1 = v_own*sind(course_own);
y_1 = v_own*cosd(course_own);

x_2 = v_target*sind(course_target);
y_2 = v_target*cosd(course_target);

x = x_1-x_2;
y = y_1-y_2;  %用向量表示目标船与本船的相对速度

pos = pos_target-pos_own;

if x*pos(1)+y*pos(2)<=0
    d=2^20;
else
    d = abs(x*pos(2)-y*pos(1))/sqrt(x^2+y^2);
end