for i=1:4
    Ship_infer(i).original=[];
    Ship_infer(i).new=[];
end

for i=2:4
    j=1;
    for k=1:length(ship(i).infer)
        if ship(i).infer(k,1)==1
            Ship_infer(i).original(j,:)=ship(i).infer(k,1:3);
            j=j+1;
        end
    end
end

for i=2:4
    j=1;
    for k=1:3:length(Ship_infer(i).original)
        Ship_infer(i).new(j,1)=Ship_infer(i).original(k,3);
         Ship_infer(i).new(j,2)=Ship_infer(i).original(k+1,3);
          Ship_infer(i).new(j,3)=Ship_infer(i).original(k+2,3);
        j=j+1;
    end
    
end
x=1:length(Ship_infer(2).new);
scatter(x,Ship_infer(2).new(:,1),'filled')
hold on
scatter(x,Ship_infer(2).new(:,2),'filled')
hold on
scatter(x,Ship_infer(2).new(:,3),'filled')
hold off

legend('1-2','1-3','1-4','Location','northeast')
legend('boxoff')
            