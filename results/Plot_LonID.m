%%  AtlantikSolar System Identification Validation Plots

h = gcf; %current figure handle   

axesObjs = get(h, 'Children');  %axes handles
dataObjs = get(axesObjs, 'Children'); %handles to low-level graphics objects in axes 
%%
objTypes = get(dataObjs{2}, 'Type');  %type of low-level graphics object   
%%
xdata = get(dataObjs{6}, 'XData');  %data from low-level grahics objects
ydata = get(dataObjs{6}, 'YData');
zdata = get(dataObjs{6}, 'ZData');

%%

time_vec = xdata{1};
alpha_exp = ydata{1};
alpha_resp = ydata{2};
%%
q_exp = ydata{1};
q_resp = ydata{2};
%%

theta_exp = ydata{1};
theta_resp = ydata{2};
%%
lpf = tf(3*pi,[1 3*pi]);
alpha_exp = lsim(lpf,alpha_exp,time_vec,alpha_exp(1));

alpha_resp = lsim(lpf,alpha_resp,time_vec,alpha_exp(1));
q_exp = lsim(lpf,q_exp,time_vec,alpha_exp(1));
q_resp = lsim(lpf,q_resp,time_vec,alpha_exp(1));
theta_exp = lsim(lpf,theta_exp,time_vec,alpha_exp(1));
theta_resp = lsim(lpf,theta_resp,time_vec,alpha_exp(1));
%%
q_exp = q_exp-mean(q_exp);
q_resp = q_resp - mean(q_resp);
%%
AS_P_Model_Valid.Longitudinal.Alpha.exp = alpha_exp;
AS_P_Model_Valid.Longitudinal.Alpha.resp = alpha_resp;
AS_P_Model_Valid.Longitudinal.Q_rate.exp = q_exp;
AS_P_Model_Valid.Longitudinal.Q_rate.resp = q_resp;
AS_P_Model_Valid.Longitudinal.Pitch.exp = theta_exp;
AS_P_Model_Valid.Longitudinal.Pitch.resp = theta_resp;
AS_P_Model_Valid.Longitudinal.time_vec = time_vec;

%%
Ts = time_vec(2) - time_vec(1);
Fs = 1/Ts;
sample_time = Ts;
Slowest_Oscillation = 10.5; % 10; % seconds
T_win = 2*Slowest_Oscillation;
Window_Length = floor(T_win/sample_time);
SISOoptions.FDmethod = 'etfe';
SISOoptions.N = 128;
SISOoptions.auto = 1;
SISOoptions.Fs = 1/Ts;
SISOoptions.f1 = .01;
SISOoptions.f2 = 2;
% SISOoptions.f1 = rad_s2Hz(0.01);  
% SISOoptions.f2 = rad_s2Hz(8.28); 
SISOoptions.a = exp(1i*2*pi*SISOoptions.f1/Fs);
SISOoptions.Ts = Ts; 
SISOoptions.Window = hanning(Window_Length); %1024
SISOoptions.Noverlap = floor(Window_Length/2); % 512
SISOoptions.NFFT = 1024*8; % 1024
SISOoptions.plot = 1;
SISOoptions.C_e = sqrt(0.55); 
SISOoptions.WindowLen = Window_Length;
SISOoptions.Resol = SISOoptions.NFFT;
SISOoptions.m = 1024;
SISOoptions.Bandwidth = 10;
SISOoptions.plot = 1;

[NomChecks_Alpha,FAChecks_Alpha] = ACX_Check_SISO_IO(AS_P_Model_Valid.Longitudinal.Alpha.exp,AS_P_Model_Valid.Longitudinal.Alpha.resp,Ts,SISOoptions);

[NomChecks_q,FAChecks_q] = ACX_Check_SISO_IO(AS_P_Model_Valid.Longitudinal.Q_rate.exp,AS_P_Model_Valid.Longitudinal.Q_rate.resp,Ts,SISOoptions);
[NomChecks_pitch,FAChecks_pitch] = ACX_Check_SISO_IO(AS_P_Model_Valid.Longitudinal.Pitch.exp,AS_P_Model_Valid.Longitudinal.Pitch.resp,Ts,SISOoptions);

fit_alpha = 100*(1 - norm(AS_P_Model_Valid.Longitudinal.Alpha.resp - AS_P_Model_Valid.Longitudinal.Alpha.exp)/norm(AS_P_Model_Valid.Longitudinal.Alpha.exp-mean(AS_P_Model_Valid.Longitudinal.Alpha.exp))); % ['ID - Fit = ' num2str(fit) '%']
fit_q_rate = 100*(1 - norm(AS_P_Model_Valid.Longitudinal.Q_rate.resp - AS_P_Model_Valid.Longitudinal.Q_rate.exp)/norm(AS_P_Model_Valid.Longitudinal.Q_rate.exp-mean(AS_P_Model_Valid.Longitudinal.Q_rate.exp))); % ['ID - Fit = ' num2str(fit) '%']
fit_pitch = 100*(1 - norm(AS_P_Model_Valid.Longitudinal.Pitch.resp - AS_P_Model_Valid.Longitudinal.Pitch.exp)/norm(AS_P_Model_Valid.Longitudinal.Pitch.exp-mean(AS_P_Model_Valid.Longitudinal.Pitch.exp))); % ['ID - Fit = ' num2str(fit) '%']

%%
close all;
color_value = [223 233 240]/255;
patch_vertices = [0.05 0.6; 0.05 .98; 3 .98; 3 0.6; 0.05 0.6];
patch_vertices_tp = [1560.5 -0.345; 1560.5 0.345; 1619.5 0.345; 1619.5 -0.345; 1560.5 -0.345];
figure;
subplot(4,3,[1 2])
plot(AS_P_Model_Valid.Longitudinal.time_vec,deg2rad(AS_P_Model_Valid.Longitudinal.Alpha.exp),'b'); hold on;
plot(AS_P_Model_Valid.Longitudinal.time_vec,deg2rad(AS_P_Model_Valid.Longitudinal.Alpha.resp),'r');
patch(patch_vertices_tp(:,1),patch_vertices_tp(:,2),1:length(patch_vertices_tp(:,1)),'FaceColor',color_value,'FaceAlpha',1,'EdgeColor','none')
hold on;
plot(AS_P_Model_Valid.Longitudinal.time_vec,deg2rad(AS_P_Model_Valid.Longitudinal.Alpha.exp),'b'); hold on;
plot(AS_P_Model_Valid.Longitudinal.time_vec,deg2rad(AS_P_Model_Valid.Longitudinal.Alpha.resp),'r');
ylabel('$$\alpha$$ (rad)','Interpreter','LaTex','FontSize',20); legend('Exp',['ID - Fit = ' num2str(fit_alpha)]); grid on;
xlim([0 3600]); vline(1560,'k--'); vline(1620,'k--');  ylim([-0.35 0.35]);
subplot(4,3,[4 5])
plot(AS_P_Model_Valid.Longitudinal.time_vec,deg2rad(AS_P_Model_Valid.Longitudinal.Q_rate.exp),'b'); hold on;
plot(AS_P_Model_Valid.Longitudinal.time_vec,deg2rad(AS_P_Model_Valid.Longitudinal.Q_rate.resp),'r');
patch(patch_vertices_tp(:,1),patch_vertices_tp(:,2),1:length(patch_vertices_tp(:,1)),'FaceColor',color_value,'FaceAlpha',1,'EdgeColor','none')
hold on;
plot(AS_P_Model_Valid.Longitudinal.time_vec,deg2rad(AS_P_Model_Valid.Longitudinal.Q_rate.exp),'b'); hold on;
plot(AS_P_Model_Valid.Longitudinal.time_vec,deg2rad(AS_P_Model_Valid.Longitudinal.Q_rate.resp),'r');
xlim([0 3600]); vline(1560,'k--'); vline(1620,'k--'); ylim([-0.35 0.35]);
ylabel('q (rad/s)','Interpreter','LaTex','FontSize',20); legend('Exp',['ID - Fit = ' num2str(fit_q_rate)]); grid on;
subplot(4,3,[7 8])
plot(AS_P_Model_Valid.Longitudinal.time_vec,deg2rad(AS_P_Model_Valid.Longitudinal.Pitch.exp),'b'); hold on;
plot(AS_P_Model_Valid.Longitudinal.time_vec,deg2rad(AS_P_Model_Valid.Longitudinal.Pitch.resp),'r');
patch(patch_vertices_tp(:,1),patch_vertices_tp(:,2),1:length(patch_vertices_tp(:,1)),'FaceColor',color_value,'FaceAlpha',1,'EdgeColor','none')
hold on;
plot(AS_P_Model_Valid.Longitudinal.time_vec,deg2rad(AS_P_Model_Valid.Longitudinal.Pitch.exp),'b'); hold on;
plot(AS_P_Model_Valid.Longitudinal.time_vec,deg2rad(AS_P_Model_Valid.Longitudinal.Pitch.resp),'r');
xlim([0 3600]); vline(1560,'k--'); vline(1620,'k--'); ylim([-0.35 0.35]);
ylabel('$$\theta$$ (rad)','Interpreter','LaTex','FontSize',20); legend('Exp',['ID - Fit = ' num2str(fit_pitch)]); grid on;
xlabel('Time (s)','Interpreter','LaTex','FontSize',20);
subplot(4,3,10)
patch(patch_vertices(:,1),patch_vertices(:,2),1:length(patch_vertices(:,1)),'FaceColor',color_value,'FaceAlpha',1,'EdgeColor','none')
hold on;
plot(NomChecks_Alpha.Coherence.freqs,NomChecks_Alpha.Coherence.coherence,'g','LineWidth',1.5); 
xlim([0 5]); xlabel('Freq (Hz)','Interpreter','LaTex','FontSize',20); grid on;
ylabel('$$\gamma_{\alpha,\hat{\alpha}}$$','Interpreter','LaTex','FontSize',20);
ylim([0 1]);
hline(0.6,'r--');
vline(3,'k--');  box on;
subplot(4,3,11)
patch(patch_vertices(:,1),patch_vertices(:,2),1:length(patch_vertices(:,1)),'FaceColor',color_value,'FaceAlpha',1,'EdgeColor','none')
hold on;
plot(NomChecks_q.Coherence.freqs,NomChecks_q.Coherence.coherence,'g','LineWidth',1.5); 
xlim([0 5]); xlabel('Freq (Hz)','Interpreter','LaTex','FontSize',20); grid on;
ylim([0 1])
ylabel('$$\gamma_{q,\hat{q}}$$','Interpreter','LaTex','FontSize',20);
hline(0.6,'r--');
vline(3,'k--');  box on;
subplot(4,3,12)
patch(patch_vertices(:,1),patch_vertices(:,2),1:length(patch_vertices(:,1)),'FaceColor',color_value,'FaceAlpha',1,'EdgeColor','none')
hold on;
plot(NomChecks_pitch.Coherence.freqs,NomChecks_pitch.Coherence.coherence,'g','LineWidth',1.5); 
xlim([0 5]); xlabel('Freq (Hz)','Interpreter','LaTex','FontSize',20); grid on;
ylabel('$$\gamma_{\theta,\hat{\theta}}$$','Interpreter','LaTex','FontSize',20);
ylim([0 1]);grid on;
hline(0.6,'r--');
vline(3,'k--'); box on;
subplot(4,3,[3])
plot(AS_P_Model_Valid.Longitudinal.time_vec,deg2rad(AS_P_Model_Valid.Longitudinal.Alpha.exp),'b'); hold on;
plot(AS_P_Model_Valid.Longitudinal.time_vec,deg2rad(AS_P_Model_Valid.Longitudinal.Alpha.resp),'r');
ylabel('$$\alpha$$ (rad)','Interpreter','LaTex','FontSize',20); % legend('Exp',['ID - Fit = ' num2str(fit_alpha)]); grid on;
xlim([1560 1620]); grid on;
subplot(4,3,[6])
plot(AS_P_Model_Valid.Longitudinal.time_vec,deg2rad(AS_P_Model_Valid.Longitudinal.Q_rate.exp),'b'); hold on;
plot(AS_P_Model_Valid.Longitudinal.time_vec,deg2rad(AS_P_Model_Valid.Longitudinal.Q_rate.resp),'r');
xlim([1560 1620]);
grid on;
ylabel('q (rad/s)','Interpreter','LaTex','FontSize',20); % legend('Exp',['ID - Fit = ' num2str(fit_q_rate)]); grid on;
subplot(4,3,[9])
plot(AS_P_Model_Valid.Longitudinal.time_vec,deg2rad(AS_P_Model_Valid.Longitudinal.Pitch.exp),'b'); hold on;
plot(AS_P_Model_Valid.Longitudinal.time_vec,deg2rad(AS_P_Model_Valid.Longitudinal.Pitch.resp),'r');
grid on;
xlim([1560 1620]);
ylabel('$$\theta$$ (rad)','Interpreter','LaTex','FontSize',20); % legend('Exp',['ID - Fit = ' num2str(fit_pitch)]); grid on;
xlabel('Time (s)','Interpreter','LaTex','FontSize',20);




