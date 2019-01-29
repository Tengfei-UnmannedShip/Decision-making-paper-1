function d = computeDCPA(v_own,course_own,pos_own,v_target,course_target,pos_target)
%% ������CPA���㣬ֻ�Ǹ��ݵ�ǰ��λ�úͺ��ٺ������CPA
x_1 = v_own*sind(course_own);
y_1 = v_own*cosd(course_own);

x_2 = v_target*sind(course_target);
y_2 = v_target*cosd(course_target);

x = x_1-x_2;
y = y_1-y_2;  %��������ʾĿ�괬�뱾��������ٶ�

pos = pos_target-pos_own;

if x*pos(1)+y*pos(2)<=0
    d=2^20;
else
    d = abs(x*pos(2)-y*pos(1))/sqrt(x^2+y^2);
end