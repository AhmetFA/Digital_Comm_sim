% my_BER_graph
%        Name:
%     Surname:
%  Student ID:

%% Simulation Preferences
Pulse_Shaping = false;          %% Use raised cosine pulse shaping
N = 2e2;                        %% Number of bits used for visualizations
M = 4;                          %% Modulation order (4 for QPSK)
Mapping = 'Binary';             %% Symbol mapping ('Binary' or 'Gray')
PhaseOffset = pi/4;             %% Phase offset of constellation
TimeOffsetCoef = 0;             %% Time offset coefficient (ingeter)
EbNo = 0:10;                    %% Eb/No value in decibels
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
d = randi([0 1],N,1);
for i =1 :length(EbNo)
    s = my_Modulator(d);                                    %  <== REPLACEMENT
    x=s;
   
    y = my_Channel(x,EbNo(i));                                          %  <== REPLACEMENT

    y = [zeros(dt/Ts,1);y];
    y = y(1:end-dt/Ts);
    
    r = y;
    b = my_Demodulator(r); 
    
    ber(i) = sum(abs(d-b))/200;
end
berQ = berawgn(EbNo,'psk',M,'nondiff');
semilogy(EbNo,ber);
hold on
semilogy(EbNo,berQ)
xlabel('Eb/No (dB)')
ylabel('BER')
legend('QPSK','QPSK theoretical')
grid
%%