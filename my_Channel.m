% my_Channel
%        Name: Ahmet Fatih
%     Surname: ANKARALI
%  Student ID: 21527759

%%
function y = my_Channel(x, EbNo)
% As Es(Symbol Energy) is N*Eb which in this case 2*Eb so Es/No=2*Eb/No
% So our noise power level is 1/(Eb/No) as our symbol amplitudes are 1
% and received signal is r = N(sm,No/2)
y = awgn(x,EbNo+10*log(4),'measured');
%multiplied by for in linear 2 from Es/Eb 2 from No/2
end