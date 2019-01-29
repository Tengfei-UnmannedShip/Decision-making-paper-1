function p=CollisionRisk0(ship1,ship2) %WTF:确定碰撞风险的函数，ship1为本船，ship2为目标船集合

d_thre = 3*1852;%WTF:风险阈值

p=0;


%%
for i=1:length(ship2)
    pos11=ship1.pos;
    pos21=ship2(i).pos;
    d1= computeCPA(ship1.speed*ship1.ratio,ship1.Course,pos11,...
            ship2(i).speed*ship2(i).ratio,ship2(i).Course,pos21,ship1.courseTime);

    if d1<=d_thre
        p=1;
        break;
    end
end
end
    
    