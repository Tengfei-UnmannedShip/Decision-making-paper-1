function c=computeCI(pos1,pos2,v1,v2,course1,course2)

alpha = 0.2;

d=norm(pos1-pos2,2);
dcpa=InfercomputeCPA(v1,course1,pos1,v2,course2,pos2);

c=alpha*d+(1-alpha)*dcpa;
end