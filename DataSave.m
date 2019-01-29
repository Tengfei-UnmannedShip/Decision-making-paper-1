% load final(21 21 21 21,01-01)
% for i=1:4
%     DCPA2121(i).record=ship(i).DCPA_Record;
%     DCPA2121(i).min=ship(i).DCPAmin_Record;
%     
%     TCPA2010(i).record=ship(i).TCPA_Record;
%     TCPA2010(i).min=ship(i).TCPAmin_Record;
%     
%     Dis2010(i).record=ship(i).Dis_Record;
%     Dis2010(i).min=ship(i).Dismin_Record;
% end
% save ('record(01-01)','DCPA2121','TCPA2121','Dis2121')
load final(20 11 11 11,01-01)
for i=1:4
    DCPA2011(i).record=ship(i).DCPA_Record;
    DCPA2011(i).min=ship(i).DCPAmin_Record;
    
    TCPA2011(i).record=ship(i).TCPA_Record;
    TCPA2011(i).min=ship(i).TCPAmin_Record;
    
    Dis2011(i).record=ship(i).Dis_Record;
    Dis2011(i).min=ship(i).Dismin_Record;
end
save ('record(01-01)','DCPA2011','TCPA2011','Dis2011')
load final(20 10 10 10,01-01)
for i=1:4
    DCPA2010(i).record=ship(i).DCPA_Record;
    DCPA2010(i).min=ship(i).DCPAmin_Record;
    
    TCPA2010(i).record=ship(i).TCPA_Record;
    TCPA2010(i).min=ship(i).TCPAmin_Record;
    
    Dis2010(i).record=ship(i).Dis_Record;
    Dis2010(i).min=ship(i).Dismin_Record;
end
save ('record(01-01)','DCPA2010','TCPA2010','Dis2010','-append')
load final(11 11 11 11,01-01)
for i=1:4
    DCPA1111(i).record=ship(i).DCPA_Record;
    DCPA1111(i).min=ship(i).DCPAmin_Record;
    
    TCPA1111(i).record=ship(i).TCPA_Record;
    TCPA1111(i).min=ship(i).TCPAmin_Record;
    
    Dis1111(i).record=ship(i).Dis_Record;
    Dis1111(i).min=ship(i).Dismin_Record;
end
save ('record(01-01)','DCPA1111','TCPA1111','Dis1111','-append')
load final(10 10 10 10,01-01)
for i=1:4
    DCPA1010(i).record=ship(i).DCPA_Record;
    DCPA1010(i).min=ship(i).DCPAmin_Record;
    
    TCPA1010(i).record=ship(i).TCPA_Record;
    TCPA1010(i).min=ship(i).TCPAmin_Record;
    
    Dis1010(i).record=ship(i).Dis_Record;
    Dis1010(i).min=ship(i).Dismin_Record;
end
save ('record(01-01)','DCPA1010','TCPA1010','Dis1010','-append')
load final(00 11 11 11,01-01)
for i=1:4
    DCPA0011(i).record=ship(i).DCPA_Record;
    DCPA0011(i).min=ship(i).DCPAmin_Record;
    
    TCPA0011(i).record=ship(i).TCPA_Record;
    TCPA0011(i).min=ship(i).TCPAmin_Record;
    
    Dis0011(i).record=ship(i).Dis_Record;
    Dis0011(i).min=ship(i).Dismin_Record;
end
save ('record(01-01)','DCPA0011','TCPA0011','Dis0011','-append')
load final(00 10 10 10,01-01)
for i=1:4
    DCPA0010(i).record=ship(i).DCPA_Record;
    DCPA0010(i).min=ship(i).DCPAmin_Record;
    
    TCPA0010(i).record=ship(i).TCPA_Record;
    TCPA0010(i).min=ship(i).TCPAmin_Record;
    
    Dis0010(i).record=ship(i).Dis_Record;
    Dis0010(i).min=ship(i).Dismin_Record;
end
save ('record(01-01)','DCPA0010','TCPA0010','Dis0010','-append')