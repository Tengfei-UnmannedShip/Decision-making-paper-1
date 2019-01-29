function p=CollisionRisk(ship1,ship2) %WTF:确定碰撞风险的函数，ship1为本船，ship2为目标船集合

d_thre = 1.2*1852;%WTF:风险阈值

p=0;


%%
for i=1:length(ship2)
    pos11=ship1.pos;
    pos21=ship2(i).pos;
    if ship1.courseTime>ship2(i).courseTime
       %% WTF:d1为
        d1= computeCPA(ship1.speed*ship1.ratio,ship1.initialCourse+ship1.courseAlter,pos11,...
            ship2(i).speed*ship2(i).ratio,ship2(i).initialCourse+ship2(i).courseAlter,pos21,ship2(i).courseTime);
       %% WTF:d2为 
        pos12=[ship1.pos(1)+ship1.speed*ship1.ratio*sind(ship1.initialCourse+ship1.courseAlter)*ship2(i).courseTime ...
            ship1.pos(2)+ship1.speed*ship1.ratio*cosd(ship1.initialCourse+ship1.courseAlter)*ship2(i).courseTime];
        pos22=[ship2(i).pos(1)+ship2(i).speed*ship2(i).ratio*sind(ship2(i).initialCourse+ship2(i).courseAlter)*ship2(i).courseTime ...
            ship2(i).pos(2)+ship2(i).speed*ship2(i).ratio*cosd(ship2(i).initialCourse+ship2(i).courseAlter)*ship2(i).courseTime];
        d2= computeCPA(ship1.speed*ship1.ratio,ship1.initialCourse+ship1.courseAlter,pos12,...
            ship2(i).speed*ship2(i).ratio,ship2(i).initialCourse,pos22,ship1.courseTime-ship2(i).courseTime);
        %% WTF:d3为
        pos13=[ship1.pos(1)+ship1.speed*ship1.ratio*sind(ship1.initialCourse+ship1.courseAlter)*ship1.courseTime ...
            ship1.pos(2)+ship1.speed*ship1.ratio*cosd(ship1.initialCourse+ship1.courseAlter)*ship1.courseTime];
        pos23=[pos22(1)+ship2(i).speed*ship2(i).ratio*sind(ship2(i).initialCourse)*(ship1.courseTime-ship2(i).courseTime) ...
            pos22(2)+ship2(i).speed*ship2(i).ratio*cosd(ship2(i).initialCourse)*(ship1.courseTime-ship2(i).courseTime)];
        d3= computeCPA(ship1.speed*ship1.ratio,ship1.initialCourse,pos13,...
            ship2(i).speed*ship2(i).ratio,ship2(i).initialCourse,pos23,5000);
    else
       %% WTF:d1为         
        d1= computeCPA(ship1.speed*ship1.ratio,ship1.initialCourse+ship1.courseAlter,pos11,...
        ship2(i).speed*ship2(i).ratio,ship2(i).initialCourse+ship2(i).courseAlter,pos21,ship1.courseTime);
       %% WTF:d2为   
        pos12=[ship1.pos(1)+ship1.speed*ship1.ratio*sind(ship1.initialCourse+ship1.courseAlter)*ship1.courseTime ...
            ship1.pos(2)+ship1.speed*ship1.ratio*cosd(ship1.initialCourse+ship1.courseAlter)*ship1.courseTime];
        pos22=[ship2(i).pos(1)+ship2(i).speed*ship2(i).ratio*sind(ship2(i).initialCourse+ship2(i).courseAlter)*ship1.courseTime ...
            ship2(i).pos(2)+ship2(i).speed*ship2(i).ratio*cosd(ship2(i).initialCourse+ship2(i).courseAlter)*ship1.courseTime];
        d2= computeCPA(ship1.speed*ship1.ratio,ship1.initialCourse,pos12,...
            ship2(i).speed*ship2(i).ratio,ship2(i).initialCourse+ship2(i).courseAlter,pos22,ship2(i).courseTime-ship1.courseTime);
        %% WTF:d3为        
        pos13=[pos12(1)+ship1.speed*ship1.ratio*sind(ship1.initialCourse)*(ship2(i).courseTime-ship1.courseTime) ...
            ship1.pos(2)+ship1.speed*ship1.ratio*cosd(ship1.initialCourse)*(ship2(i).courseTime-ship1.courseTime)];
        pos23=[ship2(i).pos(1)+ship2(i).speed*ship2(i).ratio*sind(ship2(i).initialCourse+ship2(i).courseAlter)*ship2(i).courseTime ...
            ship2(i).pos(2)+ship2(i).speed*ship2(i).ratio*cosd(ship2(i).initialCourse+ship2(i).courseAlter)*ship2(i).courseTime];
        d3= computeCPA(ship1.speed*ship1.ratio,ship1.initialCourse,pos13,...
            ship2(i).speed*ship2(i).ratio,ship2(i).initialCourse,pos23,5000);
    end
    d=min(d1,min(d2,d3));
    if d<=d_thre
        p=1;
        break;
    end
end
end
    
    