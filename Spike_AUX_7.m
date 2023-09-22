function [SDS,SDS2]=Spike_AUX_7(AUX4,AUX3,AUX2,Spike_time,DelayCMD,Delay)

for k=1:size(AUX3,1)-1
    %Spike_num_1stim(k,1)=size(Spike_time(Spike_time>AUX3(k,1)&Spike_time<AUX3(k,1)+0.012),2); %0.1 for cmd value and 0.01 for stim
    %Spike_num_2stim(k,1)=size(Spike_time(Spike_time>AUX3(k,2)&Spike_time<AUX3(k,2)+0.03),2); % count spikes after last Stim and before 100ms
    Spike_num_1stim(k,1)=size(Spike_time(Spike_time>AUX3(k,1)&Spike_time<AUX3(k,2)),2)-1; %0.1 for cmd value and 0.01 for stim
    Spike_num_2stim(k,1)=size(Spike_time(Spike_time>AUX3(k,2)&Spike_time<AUX2(k+1,1)),2)-1;
    Spike_num_3stim(k,1)=size(Spike_time(Spike_time>AUX3(k,1)&Spike_time<AUX2(k+1,1)),2)-2;
end
% Spike_num_1stim(DelayCMD>0.005 | Delay==0)=[];  Spike_num_2stim(DelayCMD>0.005 | Delay==0)=[]; 
% AUX4(DelayCMD>0.005 | Delay==0,:)=[];
% Spike_num_3stim(DelayCMD>0.005 | Delay==0)=[];

Spike_num_1stim(DelayCMD(1:end-1)<0.005)=[];  Spike_num_2stim(DelayCMD(1:end-1)<0.005)=[]; 
AUX4(DelayCMD(1:end-1)<0.005,:)=[];
Spike_num_3stim(DelayCMD(1:end-1)<0.005)=[];


Spike_num_1stim(Spike_num_1stim>=15)=nan;
Spike_num_2stim(Spike_num_2stim>=15)=nan;
Spike_num_3stim(Spike_num_3stim>=15)=nan;
%     xbins=2:0.1:5.1;  % BinBorders for xDimension
%     sds=[]; sds2=[];
%     for x=1:size(xbins,2)-1
%         temp=Spike_num_2stim(AUX4(:,2)>=xbins(x) & AUX4(:,2)<xbins(x+1));
%         if length(temp)>=5
%             sds(x)= nanmean(temp(temp>=0));
%         else
%             sds(x)=NaN;
%         end
%         temp2=Spike_num_1stim(AUX4(:,1)>=xbins(x) & AUX4(:,1)<xbins(x+1));
%         if length(temp2)>=5
%             sds2(x)=nanmean(temp2(temp2>=0));
%         else
%             sds2(x)=NaN;
%         end
%     end
%     tbins=xbins(1:end-2);
%     Data_1=sds2(1:end-1); Data_2=sds(1:end-1);
%     [xData, yData] = prepareCurveData(tbins, Data_1 );
%     ft = fittype( 'poly2' ); opts = fitoptions( 'Method', 'LinearLeastSquares' ); opts.Robust = 'Bisquare'; [fitresult, gof] = fit( xData, yData, ft, opts );
%     figure; plot( fitresult,'-b',tbins,Data_1,'ob');
%     [xData, yData] = prepareCurveData(tbins, Data_2 );
%     ft = fittype( 'poly2' ); opts = fitoptions( 'Method', 'LinearLeastSquares' ); opts.Robust = 'Bisquare'; [fitresult, gof] = fit( xData, yData, ft, opts );
%     hold on; plot( fitresult,'-r',tbins,Data_2,'or');

interavl=0.25;
xbins=round(min(AUX4(:,1))):interavl:round(max(AUX4(:,1)))+interavl;
ybins=round(min(AUX4(:,1))):interavl:round(max(AUX4(:,1)))+interavl;% BinBorders for xDimension
sds=[]; sds2=[]; sds3=[];
for x=1:size(xbins,2)-1
    for y=1:size(ybins,2)-1
        temp=Spike_num_1stim(AUX4(1:end-1,2)>=xbins(x) & AUX4(1:end-1,2)<xbins(x+1) & AUX4(1:end-1,1)>=ybins(y) & AUX4(1:end-1,1)<ybins(y+1));
        if length(temp)>=3
            sds(x,y)= nanmean(temp(temp>=0));
        else
            sds(x,y)=NaN;
        end
        temp2=Spike_num_2stim(AUX4(1:end-1,2)>=xbins(x) & AUX4(1:end-1,2)<xbins(x+1) & AUX4(1:end-1,1)>=ybins(y) & AUX4(1:end-1,1)<ybins(y+1));
        if length(temp2)>=3
            sds2(x,y)=nanmean(temp2(temp2>=0));
        else
            sds2(x,y)=NaN;
        end
        temp3=Spike_num_3stim(AUX4(1:end-1,2)>=xbins(x) & AUX4(1:end-1,2)<xbins(x+1) & AUX4(1:end-1,1)>=ybins(y) & AUX4(1:end-1,1)<ybins(y+1));
        if length(temp3)>=3
            sds3(x,y)=nanmean(temp3(temp3>=0));
        else
            sds3(x,y)=NaN;
        end
        
    end
end





%     tbins=xbins(1:end-2);
%     Data_1=sds2(1:end-1); Data_2=sds(1:end-1);
%     [xData, yData] = prepareCurveData(tbins, Data_1 );
%     ft = fittype( 'poly2' ); opts = fitoptions( 'Method', 'LinearLeastSquares' ); opts.Robust = 'Bisquare'; [fitresult, gof] = fit( xData, yData, ft, opts );
%     figure; plot( fitresult,'-b',tbins,Data_1,'ob');
%     [xData, yData] = prepareCurveData(tbins, Data_2 );
%     ft = fittype( 'poly2' ); opts = fitoptions( 'Method', 'LinearLeastSquares' ); opts.Robust = 'Bisquare'; [fitresult, gof] = fit( xData, yData, ft, opts );
%     hold on; plot( fitresult,'-r',tbins,Data_2,'or');

% sds(isnan(sds))=0;
SDS_1=inpaint_nans(sds);
SDS2_1=inpaint_nans(sds2);
SDS3_1=inpaint_nans(sds3);

w     = 2;   % Size of the sliding window (same number of cols and rows in this case)
% Extrapolate values for current window
[Nr,Nc] = size(SDS_1);
Nextra  = 0.5*(w-1);
Ap      = interp2(1:Nc,1:Nr,SDS_1,-Nextra+1:Nc+Nextra,(-Nextra+1:Nr+Nextra).','makima');    % 2D extrapolation must use 'spline' or 'makima' interpolation
% Smooth data with sliding window
H  = ones(w)./w^2;                      % The 2D averaging filter
SDS  = filter2(H,Ap,'valid'); 

Ap      = interp2(1:Nc,1:Nr,SDS2_1,-Nextra+1:Nc+Nextra,(-Nextra+1:Nr+Nextra).','makima');    % 2D extrapolation must use 'spline' or 'makima' interpolation
SDS2  = filter2(H,Ap,'valid'); 
% The smooth resulting matrix

Ap      = interp2(1:Nc,1:Nr,SDS3_1,-Nextra+1:Nc+Nextra,(-Nextra+1:Nr+Nextra).','makima');    % 2D extrapolation must use 'spline' or 'makima' interpolation
SDS3  = filter2(H,Ap,'valid'); 

% figure; 
% ax1=subplot(3,1,1); contourf(xbins(1:end-1),ybins(1:end-1),sds,100,'edgecolor','none'); axis equal; colormap(ax1,brewermap([],'Blues')); %caxis([0 max(max(SDS))]);
% ax2=subplot(3,1,2); contourf(xbins(1:end-1),ybins(1:end-1),sds2,100,'edgecolor','none'); axis equal; colormap(ax2,brewermap([],'Reds')); %caxis([min() max(max(SDS2))]);
% ax3=subplot(3,1,3); contourf(xbins(1:end-1),ybins(1:end-1),sds3,100,'edgecolor','none'); axis equal; colormap(ax3,brewermap([],'Greys')); %caxis([0 max(max(SDS3))]);


figure(100); 
ax1=subplot(6,8,13); contourf(xbins(1:end-1),ybins(1:end-1),SDS,100,'edgecolor','none'); axis equal; colormap(ax1,brewermap([],'Blues')); %caxis([0 max(max(SDS))]);
ax2=subplot(6,8,14); contourf(xbins(1:end-1),ybins(1:end-1),SDS2,100,'edgecolor','none'); axis equal; colormap(ax2,brewermap([],'Reds')); %caxis([min() max(max(SDS2))]);
ax3=subplot(6,8,15); contourf(xbins(1:end-1),ybins(1:end-1),SDS3,100,'edgecolor','none'); axis equal; colormap(ax3,brewermap([],'Greys')); %caxis([0 max(max(SDS3))]);

subplot(6,8,21); area(xbins(1:end-1),mean(SDS,1)); ylim([min(mean(SDS,1))-0.5 max(mean(SDS,1))+0.5]); subplot(6,8,29); area(xbins(1:end-1),mean(SDS,2)); ylim([min(mean(SDS,2))-0.5 max(mean(SDS,2))+0.5]); 
subplot(6,8,22); area(xbins(1:end-1),mean(SDS2,1));ylim([min(mean(SDS2,1))-0.5 max(mean(SDS2,1))+0.5]); subplot(6,8,30); area(xbins(1:end-1),mean(SDS2,2)); ylim([min(mean(SDS2,2))-0.5 max(mean(SDS2,2))+0.5]);
subplot(6,8,23); area(xbins(1:end-1),mean(SDS3,1));ylim([min(mean(SDS3,1))-0.5 max(mean(SDS3,1))+0.5]); subplot(6,8,31); area(xbins(1:end-1),mean(SDS3,2));ylim([min(mean(SDS3,2))-0.5 max(mean(SDS3,2))+0.5]);


% for second stim

val0=0.1;
 xbins=[(min(AUX4(:,2))) (max(AUX4(:,2)))];  % BinBorders for xDimension  % BinBorders for xDimension
 ybins1=[min(AUX4(AUX4(:,2)>=xbins(1) & AUX4(:,2)<xbins(1)+val0,1)) max(AUX4(AUX4(:,2)>=xbins(1) & AUX4(:,2)<xbins(1)+val0,1))];
 ybins2=[min(AUX4(AUX4(:,2)>=xbins(2)-val0 & AUX4(:,2)<xbins(2),1)) max(AUX4(AUX4(:,2)>=xbins(2)-val0 & AUX4(:,2)<xbins(2),1))];
val=0.1;
 for i=1:2
     for j=1:2
         %a=1; psth=[];subplot(size(xbins,2),2,sub);  PSTH=[];
         a=1;
         if i==1
             temp3=[]; temp3=(AUX2(AUX4(:,2)>=xbins(i)-val & AUX4(:,2)<xbins(i)+val & AUX4(:,1)>=ybins1(j)-val & AUX4(:,1)<ybins1(j)+val ,1));
             if j==1
                 subplot(6,8,24);
             else
                 subplot(6,8,32);
             end
         else
             temp3=[]; temp3=(AUX2(AUX4(:,2)>=xbins(i)-val & AUX4(:,2)<xbins(i)+val & AUX4(:,1)>=ybins2(j)-val & AUX4(:,1)<ybins2(j)+val ,1));
             if j==1
                 subplot(6,8,38);
             else
                 subplot(6,8,39);
             end
             
         end
         for y=1:size(temp3,1)
             [idx2,idx]=min(abs(Spike_time-temp3(y)));
             try
                 Freq1post(a,:)=(Spike_time(idx-20:idx+20)-temp3(y));
                 plot(Freq1post(a,:)*1000,a,'.k');  hold on;
                 a=a+1;
             end
             axis equal; xlim([-20 100]); 
         end
     end
 end
end