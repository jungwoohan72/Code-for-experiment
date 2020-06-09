clear all;

%% 
% 1. inputFreq 
% 2. filename  --> Exp#_##Hz   
%         Hz: 01, 1, 10     
% 3. iniLength 

%% Initial settings
%inputVolt = 4000/1000; %Actuation voltage
%inputFreq = 1; %Actuation frequency
measTime = 15; %1800; %Measuring duration
sampsec = 200; %Sampling rate

iniLength = '60';
%% Save settings
filename = '200117_Exp1_100Turn_135deg_150mm_linear_end.mat';

%% AcqCode

gap = linspace(0,1,sampsec*measTime);
voltage = [];
time = [];
Torque = [];
torq = [];
current = [];
data = [];

disp(datetime('now'));
disp('Experiment started.');

s = daq.createSession('ni');
addAnalogInputChannel(s,'Dev1','ai1','Voltage');
addAnalogInputChannel(s,'Dev1','ai2','Voltage');
addAnalogOutputChannel(s,'Dev1','ao1','Voltage');
s.Rate = sampsec;
%s.DurationInSeconds = 15;

% outputSignal = (-inputVolt * cos(2*pi*inputFreq*gap*measTime) + inputVolt)/2;
% queueOutputData(s,outputSignal');

%[data,time] = s.startForeground();
tic
while(1)
   timesec = toc;
   
    if timesec<5
        time = [time;timesec];
        outputSingleScan(s,0.001);
        input = inputSingleScan(s);
        torq = [torq; input(1)];
        data = [data;input];
    elseif timesec>5 && timesec<15
        time = [time;timesec];
        outputSingleScan(s,1.500);
        input = inputSingleScan(s);
        torq = [torq; input(1)];
        data = [data;input];
    else
        outputSingleScan(s,0.001);
        break;
    end
   
end

Torque = 0.4456*(torq-torq(1));

%procdata = -data + data(1);

%% Save
disp('Measurement completed.');

save('test.mat', 'time', 'data', 'Torque');

disp('Saving completed. Start next session.');
disp(datetime('now'));

figure(1)   
plot(time,data);

    