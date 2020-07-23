% my_end_to_end_sim
%        Name: Ahmet Fatih
%     Surname: ANKARALI
%  Student ID: 21527759

%% Simulation Preferences
Pulse_Shaping = false;          %% Use raised cosine pulse shaping
N = 2e2;                        %% Number of bits used for visualizations
M = 4;                          %% Modulation order (4 for QPSK)
Mapping = 'Binary';             %% Symbol mapping ('Binary' or 'Gray')
PhaseOffset = pi/4;             %% Phase offset of constellation
TimeOffsetCoef = 0;             %% Time offset coefficient (ingeter)
EbNo = 5;                      %% Eb/No value in decibels
rf = 0.2;                       %% Rolloff Factor of Raised Cosine Filter
span = 10;                      %% Number of symbols spanned by Filter
sps = 16;                       %% Number of samples per symbol
Tsymbol = 1e-6;                 %% Symbol period in seconds

Ts = Tsymbol/sps;               %% Sampling period in the simulations
Fs = 1/Ts;                      %% Sampling frequency in the simulations
k = log2(M);                    %% Number of bits per symbol
dt = TimeOffsetCoef*Ts;         %% Latency in transmission

% Variable definitions:
% d     :           Random generated data, bit sequence.
% s     :           Symbols in which bits are mapped by modulator.
% x     :           Signal to be transmitted. May be symbol array s or
%                   output of pulse shaping filter.
% y     :           Received signal, output of the transmission channel.
% r     :           Received symbols. May be output of the channel or pulse
%                   shaping filter.
% b     :           Demodulated bit sequence.

%% Random Generated Data
d = randi([0 1],N,1); 

%% Modulation and Pulse Shaping
Modulator = comm.PSKModulator(M,PhaseOffset,...
	'BitInput',true,...
	'SymbolMapping',Mapping);

txFilter = comm.RaisedCosineTransmitFilter('RolloffFactor',rf,...
    'OutputSamplesPerSymbol',sps,...
    'FilterSpanInSymbols',span);

if Pulse_Shaping
   s = my_Modulator([d ; zeros(k*span,1)]);                %  <== REPLACEMENT
   x = txFilter(s);
else
   s = my_Modulator(d);                                    %  <== REPLACEMENT
   x = s;
end

%% Transmission of the Signal over AWGN Channel
channel = comm.AWGNChannel('BitsPerSymbol',k,...         %
    'NoiseMethod', 'Signal to noise ratio (Eb/No)',...   %
    'SamplesPerSymbol',sps,...                           %
    'EbNo',EbNo);                                        %
y = my_Channel(x,EbNo);                                          %  <== REPLACEMENT

y = [zeros(dt/Ts,1);y];
y = y(1:end-dt/Ts);


%% Reception and Demodulation
rxFilter = comm.RaisedCosineReceiveFilter('RolloffFactor',rf,...
    'InputSamplesPerSymbol',sps,...
    'FilterSpanInSymbols',span,...
    'DecimationFactor',sps);
Demodulator = comm.PSKDemodulator(M,PhaseOffset,...
    'BitOutput',true, ...
    'SymbolMapping',Mapping);
if Pulse_Shaping
    r = rxFilter(y);
    b = my_Demodulator(r);                                  %  <== REPLACEMENT
    b(1:k*span) = [];
else
    r = y;
    b = my_Demodulator(r);                                  %  <== REPLACEMENT
end

%% VISUALIZATIONS

% Transmitted and Received Symbols
constellation(Modulator);

% scatterplot(s);
scatterplot(r);grid on;hold on;
plot([0 0] ,[-1.6 1.6],'k');plot([-1.6 1.6],[0 0],'k');

% Transmitted and Received Signals in Time Domain
axTime = 0:Ts:Ts*numel(x)-Ts;
figure;
subplot(2,1,1);plot(axTime,x);
subplot(2,1,2);plot(axTime,y);

% Transmitted and Received Signals in Frequency Domain
axFreq = linspace(-Fs/2, Fs/2, numel(x));
figure;
subplot(2,1,1);plot(axFreq,abs(fftshift(fft(x))));
subplot(2,1,2);plot(axFreq,abs(fftshift(fft(y))));

%% Eye Diagram
if Pulse_Shaping
    eyeObj = comm.EyeDiagram(...
        'SampleRate',Fs,...
        'SamplesPerSymbol',sps,...
        'DisplayMode','Line plot',... % or '2D color histogram'
        'ShowImaginaryEye',true,... % In-Phase and Quadrature components
        'YLimits',[-max(abs(y)) max(abs(y))]);
    eyeObj(y);
end

%% Transmitter Raised Cosine Filter Characteristics
txfc = coeffs(txFilter);        %% Impulse response of the filter
txfc = txfc.Numerator;

figure;
subplot(2,1,1);
plot(-Tsymbol*span/2:Ts:Tsymbol*span/2, txfc);
title('Impulse Response of Transmitter Raised Cosine Filter');
xlabel('time (s)');ylabel('amplitude');grid on;

subplot(2,1,2);
plot(linspace(-Fs/2,Fs/2,length(txfc)),abs(fftshift(fft(txfc))));                                          %  <== FILL THIS LINE
title('Frequency Response of Transmitter Raised Cosine Filter');
xlabel('frequency (Hz)');ylabel('amplitude');grid on;

Etx = sum(txfc)^2;               %  <== FILL THIS LINE


%% Receiver Raised Cosine Filter Characteristics
rxfc = coeffs(rxFilter);        %% Impulse response of the filter
rxfc = rxfc.Numerator;
figure;
subplot(2,1,1);
plot(-Tsymbol*span/2:Ts:Tsymbol*span/2, rxfc);
title('Impulse Response of Receiver Raised Cosine Filter');
xlabel('time (s)');ylabel('amplitude');grid on;

subplot(2,1,2);
plot(linspace(-Fs/2,Fs/2,length(rxfc)),abs(fftshift(fft(rxfc))));    %  <== FILL THIS LINE
title('Frequency Response of Receiver Raised Cosine Filter');
xlabel('frequency (Hz)');ylabel('amplitude');grid on;

Erx =sum(rxfc)^2;                                          %  <== FILL THIS LINE

%% Bit Error Rate
% BER = ...;                                          %  <== FILL THIS LINE

%% END OF CODE