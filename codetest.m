figure
ha = MarginEdit(3,2,[.01 .03],[.1 .01],[.01 .01])
for ii = 1:6; 
    axes(ha(ii)); 
%     plot(randn(10,ii)); 
end
set(ha(1:4),'XTickLabel',''); 
set(ha,'YTickLabel','')
