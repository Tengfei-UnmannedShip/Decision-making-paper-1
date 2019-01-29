function t = computeTCPA(v_own,course_own,pos_own,v_target,course_target,pos_target)
%% ���ݻ�����CPA�����ó���TCPA
x_1 = v_own*sind(course_own);
y_1 = v_own*cosd(course_own);

x_2 = v_target*sind(course_target);
y_2 = v_target*cosd(course_target);

x = x_1-x_2;
y = y_1-y_2;  %��������ʾĿ�괬�뱾��������ٶ�

pos = pos_target-pos_own;

p_x = [y*(y*pos(1)-x*pos(2))/(x^2+y^2) -x*(y*pos(1)-x*pos(2))/(x^2+y^2)];

d = norm(p_x-pos,2);

if x*pos(1)+y*pos(2)<=0
    t = 2^20;
else
    t = d/sqrt(x^2+y^2);
end
end