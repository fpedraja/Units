function Spike_AUX_1(AUX2,Spike_time)


for k=1:size(AUX2,1)-1
    Spike_CMD(1,k)=size(Spike_time(Spike_time>AUX2(k)+0.0008&Spike_time<AUX2(k)+0.1),2); % count spikes after last Stim and before 100ms
end
Spike_CMD(Spike_CMD>100)=[];
Spike_justCMD=mean(Spike_CMD); figure(100); subplot(6,8,[7 8]); boxplot(Spike_CMD);

figure(100); subplot(5,8,[1 2 3]);
a=1;
for k=1:size(AUX2,1)-1
    temp3=[]; temp3=Spike_time(Spike_time>AUX2(k)-0.4 & Spike_time<AUX2(k)+0.2);
    if isempty(temp3)==0
    plot(temp3-AUX2(k),a,'.k'); xlim([-0.02 0.1]); hold on;
    in=1; inter=0.002; Freq1post=temp3-AUX2(k);
    for p=-0.02:inter:0.1
        psth(a,in)=sum(Freq1post>=p & Freq1post<p+inter);
        in=in+1;
    end
    
    a=a+1; % count spikes after last Stim and before 100ms
    end
end

PSTH=sum(psth)/size(psth,1);
figure(100); subplot(6,8,[4 5 6]); area(-0.02:inter:0.1,PSTH); ylim([0 3])

end