function status=defacto(pos1,course1,v1,pos2,course2,v2)

t=computeTCPA(v1,course1,pos1,v2,course2,pos2);

if t==2^20
    status=[0 0 0 0 0 0 0 0 0 0]; %0表示直航船，1表示让路船
else
    x1=pos1(1)+v1*t*sind(course1);
    y1=pos1(2)+v1*t*cosd(course1);
    
    x2=pos2(1)+v2*t*sind(course2);
    y2=pos2(2)+v2*t*cosd(course2);

    if course1==90 || course1==180
        x=x1;
        k2=tand(90-course2);
        y=k2*(x-x2)+y2;
    end
    if course2==90 || course2==180
        x=x2;
        k1=tand(90-course1);
        y=k1*(x-x1)+y1;
    end
    if course1~=90 && course1~=180 && course2~=90 && course2~=180
        k1=tand(90-course1);
        k2=tand(90-course2);
        x=(y2-y1+k1*x1-k2*x2)/(k1-k2);
        y=y1+k1*(x-x1);
    end
    
    if (x-x1)*sind(course1)+(y-y1)*cosd(course1)>0
        %(x-x1)*sind(course1)+(y-y1)*cosd(course2)
        status=[0 1 x1 y1 x2 y2 t x y (x-x1)*sind(course1)+(y-y1)*cosd(course1)];
    else
        %(x-x1)*sind(course1)+(y-y1)*cosd(course2)
        status=[1 0 x1 y1 x2 y2 t x y (x-x1)*sind(course1)+(y-y1)*cosd(course1)];
    end
end