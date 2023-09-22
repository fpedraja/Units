function Spike_AUX_10(AUX4,AUX3,AUX2,Spike_time,DelayCMD,Delay)
%different delays 

Spike_num_1stim=nan(size(AUX3,1)-1,1);
for k=1:size(AUX3,1)-1
    %                 Spike_num_1stim(k,1)=size(Spike_time(Spike_time>AUX3(k,1)&Spike_time<AUX3(k,1)+0.1),2); %0.1 for cmd value and 0.01 for stim
    %                 Spike_num_2stim(k,1)=size(Spike_time(Spike_time>AUX3(k,1)&Spike_time<AUX3(k,1)+0.1),2); % count spikes after last Stim and before 100ms
    Spike_num_1stim(k,1)=size(Spike_time(Spike_time>AUX3(k,1)&Spike_time<AUX2(k+1,1)),2)-1; %0.1 for cmd value and 0.01 for stim    
end
Spike_num_1stim(Spike_num_1stim>20)=NaN;

xbins=round(min(AUX4(:,2))):0.1:round(max(AUX4(:,2)))+.1;  % BinBorders for xDimension
ybins=[0.004 0.005 0.012 0.014 0.025 0.035 0.06];
  sds2=nan(size(xbins,2)-1,size(ybins,2)-1); sdsSD=nan(size(xbins,2)-1,size(ybins,2)-1);
    for x=1:size(xbins,2)-1
        for y=1:size(ybins,2)
            temp2=Spike_num_1stim(AUX4(:,2)>=xbins(x) & AUX4(:,2)<xbins(x+1) & Delay>=ybins(y) & Delay<=ybins(y)+0.0008);
            if length(temp2)>=5
                sds2(x,y)=nanmean(temp2(temp2>=0));
                sdsSD(x,y)=nanstd(temp2(temp2>=0));
            end
        end
    end  
%  figure;
%     for i=1:6
%         try     
%             [xs, ys_virt90]=FitVal_EI(xbins(1:end-1), sds2(:,i), [xbins(1) xbins(end-1)],0.9);
%             [xs, ystd_virt90]=FitVal_EI(xbins(1:end-1), sdsSD(:,i), [xbins(1) xbins(end-1)],0.9);
%             subplot(6,1,i); [hl, hp]=boundedline(xs', ys_virt90,ystd_virt90,'-k');
%         end
%     end
%%
Spike_num_1stim=nan(size(AUX3,1)-1,1);
for k=1:size(AUX3,1)-1
    %                 Spike_num_1stim(k,1)=size(Spike_time(Spike_time>AUX3(k,1)&Spike_time<AUX3(k,1)+0.1),2); %0.1 for cmd value and 0.01 for stim
    %                 Spike_num_2stim(k,1)=size(Spike_time(Spike_time>AUX3(k,1)&Spike_time<AUX3(k,1)+0.1),2); % count spikes after last Stim and before 100ms
    Spike_num_1stim(k,1)=size(Spike_time(Spike_time>AUX3(k,1)&Spike_time<AUX3(k,1)+0.1),2)-1; %0.1 for cmd value and 0.01 for stim    
end


xbins=round(min(AUX4(:,2))):0.1:round(max(AUX4(:,2)))+.1;  % BinBorders for xDimension
ybins=[0.004 0.005 0.012 0.014 0.025 0.035 0.060];
  sds2=nan(size(xbins,2)-1,size(ybins,2)-1); sdsSD=nan(size(xbins,2)-1,size(ybins,2)-1);
    for x=1:size(xbins,2)-1
        for y=1:size(ybins,2)
            temp2=Spike_num_1stim(AUX4(:,2)>=xbins(x) & AUX4(:,2)<xbins(x+1) & Delay>=ybins(y) & Delay<=ybins(y)+0.0008);
            if length(temp2)>=5
                sds2(x,y)=nanmean(temp2(temp2>=0));
                sdsSD(x,y)=nanstd(temp2(temp2>=0))/sqrt(length(temp2(temp2>=0))); %std(data)/sqrt(length(data));
            end
        end
    end
 figure(100);
    for i=1:6
        try     
            [xs, ys_virt90]=FitVal_EI(xbins(1:end-1), sds2(:,i), [xbins(1) xbins(end-1)],0.9);
            [xs, ystd_virt90]=FitVal_EI(xbins(1:end-1), sdsSD(:,i), [xbins(1) xbins(end-1)],0.9);
            ax=subplot(6,8,i+40); 
            [hl, hp]=boundedline(xs', ys_virt90,ystd_virt90,'k');  
        end
    end
    
    PSTH=[]; inter=0.005;
    for z=1:size(ybins,2)
        for x=1:size(xbins,2)-1
            a=1; psth=[];
            temp3=[]; temp3=(AUX3(AUX4(:,2)>=xbins(x) & AUX4(:,2)<xbins(x)+0.1 & Delay>=ybins(z) & Delay<=ybins(z)+0.0008,2));
            for y=1:size(temp3,1)
                [idx2,idx]=min(abs(Spike_time-temp3(y)));
                try
                    Freq1post(a,:)=(Spike_time(idx-20:idx+20)-temp3(y));
                    in=1;
                    for p=-0.02:inter:0.1
                        if p==0
                            psth(a,in)=sum(Freq1post(a,:)>=p & Freq1post(a,:)<p+inter)-1;
                        else
                            psth(a,in)=sum(Freq1post(a,:)>=p & Freq1post(a,:)<p+inter);
                        end
                        
                        if p>=ybins(z) && p<ybins(z)+0.0008
                            psth(a,in)=sum(Freq1post(a,:)>=p & Freq1post(a,:)<p+inter)-1;
                        else
                            psth(a,in)=sum(Freq1post(a,:)>=p & Freq1post(a,:)<p+inter);
                        end
                        
                        in=in+1;
                    end
                    a=a+1;
                end
                
            end
            
            if isnan(sum(psth)/size(psth,1))==0
                AUX23=sum(psth)/size(psth,1);
                [val,ind] = max(AUX23(6:end)); ti=0+inter:inter:0.1;
                PSTH(x,1:2,z)=[ti(ind) val];
            else
                PSTH(x,1:2,z)=0;
            end
        end
    end
    
    
%      figure;
%     for i=1:6
%         try     
%             [xs, ys_virt90]=FitVal_EI(xbins(1:end-1), PSTH(:,1,i), [xbins(1) xbins(end-1)],0.9);
% %             [xs, ystd_virt90]=FitVal_EI(xbins(1:end-1), sdsSD(:,i), [xbins(1) xbins(end-1)],0.9);
%             ax=subplot(1,6,i); 
%             plot(xs', ys_virt90,'k');  ylim([0 0.1]);
%         end
%     end
%     
%     
%     figure;
%     for i=1:6
%         try
%             [xs, ys_virt90]=FitVal_EI(xbins(1:end-1), PSTH(:,2,i), [xbins(1) xbins(end-1)],0.9);
%             %             [xs, ystd_virt90]=FitVal_EI(xbins(1:end-1), sdsSD(:,i), [xbins(1) xbins(end-1)],0.9);
%             ax=subplot(1,6,i);
%             plot(xs', ys_virt90,'k');  ylim([0 3]);
%         end
%     end
    
end