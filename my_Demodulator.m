% my_Demodulator
%        Name: Ahmet Fatih
%     Surname: ANKARALI
%  Student ID: 21527759

%%
function r = my_Demodulator(b)
%I used decesion regions directly as our signal is in baseband
%because of that I don't need to jultiply with cos(wt)
%By most likelyhood algorthm I will take real and imaginary 
%parts of the signal and by their sign I will assign bits
L = length(b);
r = zeros (2*L,1);%vector for output
a = 180*angle(b)/pi;% to find arguments of the complex numbers as Im going to 
%compare them by their regions
    for i = 1:1:L-1
        if a(i)<=90 & a(i)>0
            r(2*i-1)= 0;
            r(2*i)  = 0;
        elseif a(i)>90 & a(i)<=180
            r(2*i-1)= 0;
            r(2*i)  = 1 ;
        elseif a(i)>-180 & a(i)<= -90
            r(2*i-1)= 1;
            r(2*i)  = 0;
        else
            r(2*i-1)= 1;
            r(2*i)  = 1;
        end
    end
end