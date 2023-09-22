%% 2021-07-27
clearvars; cd('D:\KIT'); addpath('D:\KIT3'); addpath('D:\KIT2');
direfinal=uigetdir('Z:\locker\Fede\2FISH\'); %3D data
files2=dir([direfinal, '\*.mat']);
vidnum=[1 2 3 4 5]; j=1; th=9.1;% 1=9.1  3=6.8/11
%% 2021-08-06
clearvars; cd('D:\KIT'); addpath('D:\KIT3'); addpath('D:\KIT2');
direfinal=uigetdir('Z:\locker\Fede\2FISH\'); %3D data
files2=dir([direfinal, '\*.mat']);
vidnum=[1 2 3 4 5]; j=1; th=22;% 1=22 5=5.2
%% 2021-08-11
clearvars; cd('D:\KIT'); addpath('D:\KIT3'); addpath('D:\KIT2');
direfinal=uigetdir('Z:\locker\Fede\2FISH\'); %3D data
files2=dir([direfinal, '\*.mat']);
vidnum=[1 2 3 4 5 6 7]; j=6; th=7;% 1=10 3=7 4=7 6=7 7=7
%% 2021-08-19
clearvars; cd('D:\KIT'); addpath('D:\KIT3'); addpath('D:\KIT2');
direfinal=uigetdir('Z:\locker\Fede\2FISH\'); %3D data
files2=dir([direfinal, '\*.mat']);
vidnum=[1 2 3 4 5 6]; j=5; th=11.5;% 1=7 2=6 3=10 4=7 5=11.5 6=10
%% 2021-08-31
clearvars; cd('D:\KIT'); addpath('D:\KIT3'); addpath('D:\KIT2');
direfinal=uigetdir('Z:\locker\Fede\2FISH\'); %3D data
files2=dir([direfinal, '\*.mat']);
vidnum=[1 2 3]; j=2; th=7.5;% 1=6 2=7.5 
%% 2021-09-02
clearvars; cd('D:\KIT'); addpath('D:\KIT3'); addpath('D:\KIT2');
direfinal=uigetdir('Z:\locker\Fede\2FISH\'); %3D data
files2=dir([direfinal, '\*.mat']);
vidnum=[1 2 3 4 5 6 7 8 9]; j=3; th=15;% 1=8 2=7.5 3=15 4=6.5 5=6 6=8 7=8 8=6.2 9=9
%% 2021-10-14
clearvars; cd('D:\KIT'); addpath('D:\KIT3'); addpath('D:\KIT2');
direfinal=uigetdir('Z:\locker\Fede\2FISH\'); %3D data
files2=dir([direfinal, '\*.mat']);
vidnum=[1 2 3 4 5 6 7]; j=2; th=7;% 1=8.5 2=7 3=7.5 4=7 5=8 6=7 7=7
%% 2021-10-21
clearvars; cd('D:\KIT'); addpath('D:\KIT3'); addpath('D:\KIT2');
direfinal=uigetdir('Z:\locker\Fede\2FISH\'); %3D data
files2=dir([direfinal, '\*.mat']);
vidnum=[1 2 3 4 5 6 7 8 9 10 11]; j=11; th=15;% 1=8.5 2=8.5 3=11.5 4=7.2 5=8 6=6 7=6 8=12 9=13 10=15 11=15
%%
close all;
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

clearvars -except  EODtime CMDtrig Spikes Events Events_Name Stim time th files2 vidnum j

[value1,sample1]=findpeaks(-Spikes ,'MINPEAKHEIGHT',th,'MINPEAKDISTANCE',20); %9.1, 6.8, 15 5.2 22
[value2,sample2]=findpeaks(Stim ,'MINPEAKHEIGHT',0.1,'MINPEAKDISTANCE',50);
% [value3,sample3]=findpeaks(-Spikes ,'MINPEAKHEIGHT',6.8,'MINPEAKDISTANCE',20); %9.1, 6.8, 15
%
%   for k=1:size(sample1,1)
%      sample3(sample3(:)==sample1(k))=[];
%   end
figure; plot(time,Spikes,'-b'); hold on; plot(time(sample1),Spikes(sample1),'ok')
figure; plot(time,Stim,'-b'); hold on; plot(time(sample2),Stim(sample2),'ok')

Stim_time=time(sample2); Stim_val=Stim(sample2);
Spike_time=time(sample1);

STIMname=[66 67 68 84 85 86 71 74 78 79]; z=1; sds=[];
%%
for t=[1 3 6 7 10]
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
        Spike_AUX_1(AUX2,Spike_time)
    else
        %%
        %         pause(1)
        %         a=1; AUX3=[]; AUX4=[];
        %         for k=1:size(AUX2,1)
        %             try
        %                 AUX3(a,1:2)=Stim_time(Stim_time>=AUX2(k)&Stim_time<=AUX2(k)+0.05); %check the time for first, second or both Stims
        %                 AUX4(a,1:2)=Stim_val(Stim_time>=AUX2(k)&Stim_time<=AUX2(k)+0.05);  %check the amplitude for first, second or both Stims
        %                 a=a+1;
        %             catch
        %                 AUX3(a,1:2)=nan; %check the time for first, second or both Stims
        %                 AUX4(a,1:2)=nan;  %check the amplitude for first, second or both Stims
        %                 a=a+1;
        %             end
        %         end
        %         pause(0.1)
        %         Delay=diff(AUX3(1:end-1,:)')'; DelayCMD=diff([AUX2(1:end-1,1), AUX3(1:end-1,1)]')';  Spike_num_2stim=[]; Spike_num_1stim=[]; AUX4(end,:)=[];
        %         AUX2(isnan(DelayCMD)==1,1)=NaN; AUX2(isnan(AUX2))=[]; AUX3(isnan(AUX3))=[]; AUX4(isnan(AUX4))=[];
        
        pause(1)
        a=1; AUX3=[]; AUX4=[];
        for k=1:size(AUX2,1)
            try
                AUX3(a,1:2)=Stim_time(Stim_time>=AUX2(k)&Stim_time<=AUX2(k)+0.05); %check the time for first, second or both Stims
                AUX4(a,1:2)=Stim_val(Stim_time>=AUX2(k)&Stim_time<=AUX2(k)+0.05);  %check the amplitude for first, second or both Stims
                a=a+1;
            catch
                AUX3(a,1:2)=nan; %check the time for first, second or both Stims
                AUX4(a,1:2)=nan;  %check the amplitude for first, second or both Stims
                a=a+1;
            end
        end
        pause(0.1)
        Delay=diff(AUX3(1:end-1,:)')'; DelayCMD=diff([AUX2(1:end-1,1), AUX3(1:end-1,1)]')';  Spike_num_2stim=[]; Spike_num_1stim=[]; AUX4(end,:)=[];
        AUX2(isnan(DelayCMD)==1,1)=NaN; AUX2(isnan(AUX2))=[]; AUX3(isnan(AUX3))=[]; AUX4(isnan(AUX4))=[];
        
        if size(AUX3,1)==1
            AUX3=reshape(AUX3,[size(AUX3,2)/2 2]);
        end
        
        if size(AUX4,1)==1
            AUX4=reshape(AUX4,[size(AUX4,2)/2 2]);
        end
        
        pause(0.1)
        if t==10
            Spike_AUX_10(AUX4,AUX3,AUX2,Spike_time,DelayCMD,Delay)
        elseif t==7
            [SDS,SDS2]=Spike_AUX_7(AUX4,AUX3,AUX2,Spike_time,DelayCMD,Delay);
        else
            [sds(:,z)]=Spike_AUX_rest(AUX4,AUX3,AUX2,Spike_time,DelayCMD,Delay,t);
            z=z+1;
        end
    end
end
%%
m=sds(:,1)+ sds(:,2)'; MM=inpaint_nans(m);

w     = 5;                              % Size of the sliding window (same number of cols and rows in this case)
% Extrapolate values for current window
[Nr,Nc] = size(MM);
Nextra  = 0.5*(w-1);
Ap      = interp2(1:Nc,1:Nr,MM,-Nextra+1:Nc+Nextra,(-Nextra+1:Nr+Nextra).','makima');    % 2D extrapolation must use 'spline' or 'makima' interpolation
% Smooth data with sliding window
H  = ones(w)./w^2;                      % The 2D averaging filter
M  = filter2(H,Ap,'valid');             % The smooth resulting matrix

figure(100); ax3=subplot(6,8,16); contourf(2:0.1:5,2:0.1:5,M,100,'edgecolor','none'); axis equal; colormap(ax3,brewermap([],'Greys'));

savefig(figure(100),['C:\Users\fedu1\Dropbox\ELL\units\',files2(vidnum(j)).name(1:end-4),'.fig'],'compact')
saveas(figure(100),['C:\Users\fedu1\Dropbox\ELL\units\',files2(vidnum(j)).name(1:end-4)],'svg');
saveas(figure(100),['C:\Users\fedu1\Dropbox\ELL\units\',files2(vidnum(j)).name(1:end-4)],'tiff');

