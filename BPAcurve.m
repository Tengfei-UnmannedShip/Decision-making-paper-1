% Tengfei Decision-Making1论文中使用的BPA函数的图形和算法
close all
x = 0:0.01:2;
y1 = zeros(1,length(x));
y2 = zeros(1,length(x));
for i=1:length(x)
     y1(i)=F0( 1.5*x(i),0.6,0.7 );
     
     y2(i)=F0( 2-1.5*x(i),0.6,0.7 );
end
ha = MarginEdit(1,1,[.05  0.05],[.05  0.05],[0.05  0.05],1);
axes(ha(1)); 
hold on;
plot(x,y1,'linewidth',1.5)
plot(x,y2,'linewidth',1.5)
plot(x,1-(y1+y2),'linewidth',1.5)
legend('m(\{NP\})','m(\{P\})','m(\{P,NP\})','Fontname', 'Times New Roman','FontSize',20.0);
legend('boxoff')
axis([0 1.8 0 1])
grid on;