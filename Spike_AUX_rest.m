function [sds]=Spike_AUX_rest(AUX4,AUX3,AUX2,Spike_time,DelayCMD,Delay,t)

Spike_num_1stim=nan(size(AUX3,1)-1,1); Spike_num_2stim=nan(size(AUX3,1)-1,1);
for k=1:size(AUX3,1)-1
    Spike_num_1stim(k,1)=size(Spike_time(Spike_time>AUX2(k,1)&Spike_time<AUX3(k+1,1)),2)-1; %0.1 for cmd value and 0.01 for stim
    Spike_num_2stim(k,1)=size(Spike_time(Spike_time>AUX2(k,1)&Spike_time<AUX2(k,1)+0.1),2)-1; % count spikes after last Stim and before 100ms
end
Spike_num_1stim(Spike_num_1stim>20)=NaN;
Spike_num_2stim(Spike_num_2stim>20)=NaN;
xbins=round(min(AUX4(:,2))):0.1:round(max(AUX4(:,2)))+.1;  % BinBorders for xDimension
sds=[]; sds2=[];
for x=1:size(xbins,2)-1
    temp=Spike_num_2stim(AUX4(1:end-1,2)>=xbins(x) & AUX4(1:end-1,2)<xbins(x+1));
    if length(temp)>=3
        sds(x)= nanmean(temp(temp>=0));
        sds1SD(x)=nanstd(temp(temp>=0))/sqrt(length(temp(temp>=0)));
    else
        sds(x)=NaN;
        sds1SD(x)=nan;
    end
    temp2=Spike_num_1stim(AUX4(1:end-1,1)>=xbins(x) & AUX4(1:end-1,1)<xbins(x+1));
    if length(temp2)>=3
        sds2(x)=nanmean(temp2(temp2>=0));
        sdsSD(x)=nanstd(temp2(temp2>=0))/sqrt(length(temp2(temp2>=0)));
    else
        sds2(x)=NaN;
        sdsSD(x)=NaN;
    end
end

PSTH=[]; inter=0.002;
for x=1:size(xbins,2)-1
    a=1; psth=[];
    temp3=[]; temp3=(AUX2(AUX4(1:end-1,2)>=xbins(x) & AUX4(1:end-1,2)<xbins(x)+0.1,1));
    for y=1:size(temp3,1)
        [idx2,idx]=min(abs(Spike_time-temp3(y)));
        try
            Freq1post(a,:)=(Spike_time(idx-20:idx+20)-temp3(y));
            in=1; 
            for p=-0.02:inter:0.1
                if t==3 && p==0.004
                    psth(a,in)=sum(Freq1post(a,:)>=p & Freq1post(a,:)<p+inter)-1;
                elseif t==6 && p==0.016
                    psth(a,in)=sum(Freq1post(a,:)>=p & Freq1post(a,:)<p+inter)-1;
                else
                    psth(a,in)=sum(Freq1post(a,:)>=p & Freq1post(a,:)<p+inter);
                end
                in=in+1;
            end
            a=a+1;
        end
        
    end
    [val,ind] = max(sum(psth)/size(psth,1)); ti=-0.02:inter:0.1;
    PSTH(x,1:2)=[ti(ind) val];
end

PSTH(PSTH<0)=0;

% if t==3
%     figure;
%     [xs, ys_virt90]=FitVal_EI(xbins(1:end-1), PSTH(:,1), [xbins(1) xbins(end-1)],0.99); subplot(2,1,1); plot(xs,ys_virt90,'-b'); ylim([0 0.1]);
%     [xs, ys_virt90]=FitVal_EI(xbins(1:end-1), PSTH(:,2), [xbins(1) xbins(end-1)],0.99); subplot(2,1,2); plot(xs,ys_virt90,'-b'); ylim([0 3]);
% 
% else
%     figure;
%     [xs, ys_virt90]=FitVal_EI(xbins(1:end-1), PSTH(:,1), [xbins(1) xbins(end-1)],0.99); subplot(2,1,1); plot(xs,ys_virt90,'-r'); ylim([0 0.1]);
%     [xs, ys_virt90]=FitVal_EI(xbins(1:end-1), PSTH(:,2), [xbins(1) xbins(end-1)],0.99); subplot(2,1,2); plot(xs,ys_virt90,'-r'); ylim([0 3]);
%     
% end
   

if t==3
    [xs, ys_virt90]=FitVal_EI(xbins(1:end-1), sds2, [xbins(1) xbins(end-1)],0.99); [xs, ystd_virt90]=FitVal_EI(xbins(1:end-1), sdsSD, [xbins(1) xbins(end-1)],0.999);
    [xs, ys_virt]=FitVal_EI(xbins(1:end-1), sds, [xbins(1) xbins(end-1)],0.99); [xs, ystd]=FitVal_EI(xbins(1:end-1), sds1SD, [xbins(1) xbins(end-1)],0.99);
    figure(100); subplot(6,8,[9 10 17 18]); [hl, hp]=boundedline(xs', ys_virt90,ystd_virt90,'-b',xs', ys_virt,ystd,'-b');
    figure(100);
    xbins=round(min(AUX4(:,2))):0.5:round(max(AUX4(:,2)))+.1;  % BinBorders for xDimension  % BinBorders for xDimension
    sub=11;
    for i=[1 size(xbins,2)-1]
        %a=1; psth=[];subplot(size(xbins,2),2,sub);  PSTH=[];
        a=1; psth=[];subplot(6,8,sub);  PSTH=[];
        temp3=[]; temp3=(AUX3(AUX4(:,2)>=xbins(i) & AUX4(:,2)<xbins(i)+0.1,2));
        for y=1:size(temp3,1)
            [idx2,idx]=min(abs(Spike_time-temp3(y)));
            try
                Freq1post(a,:)=(Spike_time(idx-20:idx+20)-temp3(y));
                plot(Freq1post(a,:),a,'.k'); xlim([-0.02 0.1]); hold on;
                in=1; inter=0.002;
                for p=-0.02:inter:0.1
                    if p==0
                        psth(a,in)=sum(Freq1post(a,:)>=p & Freq1post(a,:)<p+inter)-1;
                    else
                        psth(a,in)=sum(Freq1post(a,:)>=p & Freq1post(a,:)<p+inter);
                    end
                    in=in+1;
                end 
                a=a+1;
            end
             
        end
        %         plot(Freq1(a-1,:),i,'.k'); hold on;
        try
            PSTH=sum(psth)/size(psth,1);
            subplot(6,8,sub+1); area(-0.02:inter:0.1,PSTH); ylim([0 3])
        end
        sub=sub+8;
    end
    
    
    
else
    [xs, ys_virt90]=FitVal_EI(xbins(1:end-1), sds2, [xbins(1) xbins(end-1)],0.99); [xs, ystd_virt90]=FitVal_EI(xbins(1:end-1), sdsSD, [xbins(1) xbins(end-1)],0.999);
    [xs, ys_virt]=FitVal_EI(xbins(1:end-1), sds, [xbins(1) xbins(end-1)],0.99); [xs, ystd]=FitVal_EI(xbins(1:end-1), sds1SD, [xbins(1) xbins(end-1)],0.99);
    figure(100); subplot(6,8,[25 26 33 34]); [hl, hp]=boundedline(xs', ys_virt90,ystd_virt90,'-r',xs', ys_virt,ystd,'-.r');
    
    figure(100);
    xbins=round(min(AUX4(:,2))):0.5:round(max(AUX4(:,2)))+.1;  % BinBorders for xDimension  % BinBorders for xDimension
    sub=27;
    for i=[1 size(xbins,2)-1]
%         a=1; psth=[];subplot(size(xbins,2),2,sub);  PSTH=[];
          a=1; psth=[];subplot(6,8,sub);  PSTH=[];
        temp3=[]; temp3=(AUX3(AUX4(:,2)>=xbins(i) & AUX4(:,2)<xbins(i)+0.1,2)-0.012);
        for y=1:size(temp3,1)
            [idx2,idx]=min(abs(Spike_time-temp3(y)));
            try
                Freq1post(a,:)=(Spike_time(idx-20:idx+20)-temp3(y));
                plot(Freq1post(a,:),a,'.k'); xlim([-0.02 0.1]); hold on;
                in=1; inter=0.002;
                for p=-0.02:inter:0.1
                    if p==0.012
                        psth(a,in)=sum(Freq1post(a,:)>=p & Freq1post(a,:)<p+inter)-1;
                    else
                        psth(a,in)=sum(Freq1post(a,:)>=p & Freq1post(a,:)<p+inter);
                    end
                    in=in+1;
                end 
                a=a+1;
            end
             
        end
        %         plot(Freq1(a-1,:),i,'.k'); hold on;
        try
            PSTH=sum(psth)/size(psth,1);
            subplot(6,8,sub+1); area(-0.02:inter:0.1,PSTH); ylim([0 3])
        end
        sub=sub+8;
    end
    
end

end