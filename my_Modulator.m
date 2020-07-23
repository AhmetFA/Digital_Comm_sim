% my_Modulator
%        Name: Ahmet Fatih
%     Surname: ANKARALI
%  Student ID: 21527759

%%
function s = my_Modulator(d)
%%First Im goýng to make data have even numbered element as QPSK requýres 2
L = length (d);
m = mod (L,2);
    if m == 1
    d = [d ;0];%Even number of elements if it was not
    end
A = 2*d(1:2:end);% First digit numbers
%first digit has 2^1 as it is binary 
B = d(2:2:end); % Second digit numbers
C = A+B; %data to convert into symbols in decimal
w = i*(C*pi/2+pi/4);%angles for symbols
s = exp(w);
end