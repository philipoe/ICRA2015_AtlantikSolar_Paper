%%  Make Animation with Alpha, Roll, Pitch for AS ICRA Paper
%
%   Script to make the figures for the estimator video within the
%   AtlantikSolar ICRA paper video

Ts = AnalysisStruct.Parameters.Ts;
u = AnalysisStruct.Signals.BFFvelocities(:,1);
v = AnalysisStruct.Signals.BFFvelocities(:,2);
w = AnalysisStruct.Signals.BFFvelocities(:,3);
q_rate = AnalysisStruct.Signals.q_rate;
u_elev = AnalysisStruct.Signals.u_elev;
u_throt = AnalysisStruct.Signals.u_throttlepx4;
% u_elev = AnalysisStruct.Signals.u_elev_px4;
time_vec = Ts*(1:length(u)) - Ts;

aoa = atan2(w,u);
for i = 1:length(aoa)
    if isnan(aoa(i)) 
        aoa(i) = aoa(i-1);
    end
end

roll_resp = AnalysisStruct.Signals.roll_online;
pitch_resp = AnalysisStruct.Signals.pitch_online;

lpf = tf(4\2*pi,[1 4*pi]);
roll_resp = lsim(lpf,roll_resp,time_vec,roll_resp(1));
pitch_resp = lsim(lpf,pitch_resp,time_vec,pitch_resp(1));
aoa = lsim(lpf,aoa,time_vec,aoa(1));


vec_ind = floor(2800/Ts):floor(2820/Ts);
time_vec_ind = time_vec(vec_ind) - time_vec(vec_ind(1));
aoa_ind = aoa(vec_ind);
roll_resp_ind = roll_resp(vec_ind);
pitch_resp_ind = pitch_resp(vec_ind);

for i = 1:2:length(time_vec_ind)
close all;
subplot(3,1,1)
plot(time_vec_ind,rad2deg(aoa_ind),'b','LineWidth',1.5,'LineSmoothing','on'); grid on;
xlabel('Time (s)','Interpreter','LaTex','FontSize',20); ylabel('$$\alpha$$~(deg)','Interpreter','LaTex','FontSize',16);
subplot(3,1,2)
plot(time_vec_ind,rad2deg(roll_resp_ind),'k','LineWidth',1.5,'LineSmoothing','on');
xlabel('Time (s)','Interpreter','LaTex','FontSize',20); ylabel('$$\phi$$~(deg)','Interpreter','LaTex','FontSize',16);
grid on;
subplot(3,1,3)
plot(time_vec_ind,rad2deg(pitch_resp_ind),'k','LineWidth',1.5,'LineSmoothing','on');
xlabel('Time (s)','Interpreter','LaTex','FontSize',20); ylabel('$$\theta$$~(deg)','Interpreter','LaTex','FontSize',16);
grid on;
set(gcf,'units','normalized','outerposition',[0 0 1 1])
export_fig(['se_video_images_' num2str(i) '.jpg'],'-a2','-transparent','-jpg');%,'-m2','-transparent')
end