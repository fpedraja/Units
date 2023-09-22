%% 2021-07-27
clearvars; cd('D:\KIT'); addpath('D:\KIT3'); addpath('D:\KIT2');
direfinal=uigetdir('Z:\locker\2FISH\'); %3D data
files2=dir([direfinal, '\*.mat']);
vidnum=[1 2 3 4 5]; j=3;
%% 2021-08-06
clearvars; cd('D:\KIT'); addpath('D:\KIT3'); addpath('D:\KIT2');
direfinal=uigetdir('Z:\locker\2FISH\'); %3D data
files2=dir([direfinal, '\*.mat']);
vidnum=[1 2 3 4 5]; j=5;
%%
load([direfinal, '\', files2(vidnum(j)).name])
EODtime=eval(['V',files2(vidnum(j)).name(1:end-4),'_Ch2.values']);
CMDtrig=eval(['V',files2(vidnum(j)).name(1:end-4),'_Ch1.times']);
Spikes=eval(['V',files2(vidnum(j)).name(1:end-4),'_Ch3.values']);
Events=eval(['V',files2(vidnum(j)).name(1:end-4),'_Ch31.times']);
Events_Name=eval(['V',files2(vidnum(j)).name(1:end-4),'_Ch31.codes']);
Stim=eval(['V',files2(vidnum(j)).name(1:end-4),'_Ch4.values']);
interval=eval(['V',files2(vidnum(j)).name(1:end-4),'_Ch3.interval']);
len=eval(['V',files2(vidnum(j)).name(1:end-4),'_Ch3.length']);
time=0:interval:len*interval-interval;

clearvars -except  EODtime CMDtrig Spikes Events Events_Name Stim time

[value1,sample1]=findpeaks(-Spikes ,'MINPEAKHEIGHT',5.2,'MINPEAKDISTANCE',20); %9.1, 6.8, 15 5.2 22
[value2,sample2]=findpeaks(Stim ,'MINPEAKHEIGHT',1,'MINPEAKDISTANCE',50);
% [value3,sample3]=findpeaks(-Spikes ,'MINPEAKHEIGHT',6.8,'MINPEAKDISTANCE',20); %9.1, 6.8, 15
% 
%   for k=1:size(sample1,1)
%      sample3(sample3(:)==sample1(k))=[];
%   end
figure; plot(time,Spikes,'-b'); hold on; plot(time(sample1),Spikes(sample1),'ok')
figure; plot(time,Stim,'-b'); hold on; plot(time(sample2),Stim(sample2),'ok')

Stim_time=time(sample2); Stim_val=Stim(sample2);
Spike_time=time(sample1);

STIMname=[66 67 68 84 85 86 71 74 78 79];
%%
for t=1:size(STIMname,2)
    %%
    [b,~]=find(Events_Name(:,1)==STIMname(t));
    AUX2=[];
    for i=1:size(b,1)
        AUX=[];
        if b(i)<size(Events,1)
            AUX=CMDtrig(CMDtrig>=Events(b(i))&CMDtrig<Events(b(i)+1));
        else
            AUX=CMDtrig(CMDtrig>=Events(b(i)));
        end
        AUX2=[AUX2;AUX]; %time of each cmd triger for the condition STIMname(t)
    end
    clear AUX
    
    if t==1
        for k=1:size(AUX2,1)-1
            Spike_CMD(1,k)=size(Spike_time(Spike_time>AUX2(k)+0.0008&Spike_time<AUX2(k+1)),2); % count spikes after last Stim and before 100ms
        end
        Spike_CMD(Spike_CMD>100)=[];
        Spike_justCMD=mean(Spike_CMD);
    end
   %%
        a=1; AUX3=[]; AUX4=[];
        for k=1:size(AUX2,1)
            try
                AUX3(a,1:2)=Stim_time(Stim_time>=AUX2(k)&Stim_time<=AUX2(k)+0.05); %check the time for first, second or both Stims
                AUX4(a,1:2)=Stim_val(Stim_time>=AUX2(k)&Stim_time<=AUX2(k)+0.05);  %check the amplitude for first, second or both Stims
                a=a+1;
            end
        end
        Delay=diff(AUX3(1:end-1,:)')'; DelayCMD=diff([AUX2(1:end-1,1), AUX3(1:end-1,1)]')';  Spike_num_2stim=[]; Spike_num_1stim=[]; AUX4(end,:)=[];
        
        if t==10
            for k=1:size(AUX3,1)-1
%                 Spike_num_1stim(k,1)=size(Spike_time(Spike_time>AUX3(k,1)&Spike_time<AUX3(k,1)+0.1),2); %0.1 for cmd value and 0.01 for stim
%                 Spike_num_2stim(k,1)=size(Spike_time(Spike_time>AUX3(k,1)&Spike_time<AUX3(k,1)+0.1),2); % count spikes after last Stim and before 100ms
                Spike_num_1stim(k,1)=size(Spike_time(Spike_time>AUX3(k,1)&Spike_time<AUX2(k+1,1)),2); %0.1 for cmd value and 0.01 for stim
                Spike_num_2stim(k,1)=size(Spike_time(Spike_time>AUX3(k,1)&Spike_time<AUX2(k+1,1)),2); % count spikes after last Stim and before 100ms
            end
           
        elseif t==7
            for k=1:size(AUX3,1)-1
                %Spike_num_1stim(k,1)=size(Spike_time(Spike_time>AUX3(k,1)&Spike_time<AUX3(k,1)+0.012),2); %0.1 for cmd value and 0.01 for stim
                %Spike_num_2stim(k,1)=size(Spike_time(Spike_time>AUX3(k,2)&Spike_time<AUX3(k,2)+0.03),2); % count spikes after last Stim and before 100ms
                Spike_num_1stim(k,1)=size(Spike_time(Spike_time>AUX3(k,1)&Spike_time<AUX3(k,2)),2); %0.1 for cmd value and 0.01 for stim
                Spike_num_2stim(k,1)=size(Spike_time(Spike_time>AUX3(k,2)&Spike_time<AUX2(k+1,1)),2);
            end
             Spike_num_1stim(DelayCMD>0.005 | Delay==0)=[];  Spike_num_2stim(DelayCMD>0.005 | Delay==0)=[]; AUX4(DelayCMD>0.005 | Delay==0,:)=[];
        else
            for k=1:size(AUX3,1)-1
                Spike_num_1stim(k,1)=size(Spike_time(Spike_time>AUX3(k,1)&Spike_time<AUX3(k+1,1)),2); %0.1 for cmd value and 0.01 for stim
                Spike_num_2stim(k,1)=size(Spike_time(Spike_time>AUX3(k,2)&Spike_time<AUX3(k+1,1)),2); % count spikes after last Stim and before 100ms
            end
        end
        
        
        %             figure; plot(AUX4(:,2),Spike_num,'.r'); hold on; plot(AUX4(:,1),Spike_num,'.b');
        figure; hist3([AUX4(:,2),Spike_num_2stim],'Nbins',[15 15],'CDataMode','auto','FaceColor','interp'); % for second stim if exist
        figure; hist3([AUX4(:,1),Spike_num_2stim],'Nbins',[15 15],'CDataMode','auto','FaceColor','interp'); % for first stim if exist (first stim, just second stim or both)
        
%         Spike_num_1stim(DelayCMD<0.005)=[];  Spike_num_2stim(DelayCMD<0.005)=[]; AUX4(DelayCMD<0.005,:)=[];
                
if t==10
    xbins=2:0.1:5.1;  % BinBorders for xDimension
    ybins=[0.004 0.005 0.012 0.014 0.025 0.035];
    sds=[]; sds2=[];
    for x=1:size(xbins,2)-1
        for y=1:size(ybins,2)
            temp=Spike_num_2stim(AUX4(:,2)>=xbins(x) & AUX4(:,2)<xbins(x+1) & Delay>=ybins(y) & Delay<=ybins(y)+0.0008);
            if length(temp)>=5
                sds(x,y)= nanmean(temp(temp>=0));
            else
                sds(x,y)=NaN;
            end
            temp2=Spike_num_1stim(AUX4(:,1)>=xbins(x) & AUX4(:,1)<xbins(x+1) & Delay>=ybins(y) & Delay<=ybins(y)+0.0008);
            if length(temp2)>=5
                sds2(x,y)=nanmean(temp2(temp2>=0));
            else
                sds2(x,y)=NaN;
            end
        end
    end
    %             Data_04=sds(1:end-1,1); Data_05=sds(1:end-1,2); Data_12=sds(1:end-1,3);
    %             Data_14=sds(1:end-1,4); Data_25=sds(1:end-1,5); Data_35=sds(1:end-1,6);
    tbins=xbins(1:end-2);
    
    figure;
    for i=1:6
        try
            [xData, yData] = prepareCurveData( tbins, sds(1:end-1,i) );
            
            % Set up fittype and options.
            ft = fittype( 'poly2' );
            opts = fitoptions( 'Method', 'LinearLeastSquares' );
            opts.Robust = 'Bisquare';
            
            % Fit model to data.
            [fitresult, gof] = fit( xData, yData, ft, opts );
            
            % Plot fit with data.
            %                     figure( 'Name', 'untitled fit 1' );
            h = plot( fitresult,'-k'); hold on; plot(xData, yData,'ok','MarkerFaceColor',[i/6,i/6,0])
        end
    end
else
    xbins=2:0.1:5.1;  % BinBorders for xDimension
    sds=[]; sds2=[];
    for x=1:size(xbins,2)-1
        temp=Spike_num_2stim(AUX4(:,2)>=xbins(x) & AUX4(:,2)<xbins(x+1));
        if length(temp)>=5
            sds(x)= nanmean(temp(temp>=0));
        else
            sds(x)=NaN;
        end
        temp2=Spike_num_1stim(AUX4(:,1)>=xbins(x) & AUX4(:,1)<xbins(x+1));
        if length(temp2)>=5
            sds2(x)=nanmean(temp2(temp2>=0));
        else
            sds2(x)=NaN;
        end
    end
    tbins=xbins(1:end-2);
    Data_1=sds2(1:end-1); Data_2=sds(1:end-1);
    [xData, yData] = prepareCurveData(tbins, Data_1 );
    ft = fittype( 'poly2' ); opts = fitoptions( 'Method', 'LinearLeastSquares' ); opts.Robust = 'Bisquare'; [fitresult, gof] = fit( xData, yData, ft, opts );
    figure; plot( fitresult,'-b',tbins,Data_1,'ob');
    [xData, yData] = prepareCurveData(tbins, Data_2 );
    ft = fittype( 'poly2' ); opts = fitoptions( 'Method', 'LinearLeastSquares' ); opts.Robust = 'Bisquare'; [fitresult, gof] = fit( xData, yData, ft, opts );
    hold on; plot( fitresult,'-r',tbins,Data_2,'or');
end
        
        %% raster plots
        xbins=1.8:1:4.8;  % BinBorders for xDimension
        sds=[]; sds2=[];
        for i=1:size(xbins,2)-1
            a=1; figure;
            temp3=[]; temp3=(AUX3(AUX4(:,2)>=xbins(i) & AUX4(:,2)<xbins(i)+0.1,2));
            for y=1:size(temp3,1)
                [idx2,idx]=min(abs(Spike_time-temp3(y)));
                try
                    Freq1post(a,:)=(Spike_time(idx-20:idx+20)-temp3(y));
                    plot(Freq1post(a,:),a,'.k'); xlim([-0.1 0.1]); hold on;
                    a=a+1;
                end
            end
            %         plot(Freq1(a-1,:),i,'.k'); hold on;
        end
    
end