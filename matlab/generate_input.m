
% Filename
VHDL_in_file_name = '../sim/data/input_file.dat';

% Signal Parameter
f = 100;
N = 10000;
fs = 100e3;
NBit = 12;
Vref = 3.3;

% Signal
ADCmax = 2^NBit-1;

t = (0:N-1)'/fs;
% Signal in Volt erzeugen
Signal_V = (Vref/2) + (Vref/2)*sin(2*pi*f*t) + 0.05*randn(N,1);  


% Begrenzen auf 0...Vref
Signal_V = max(0, min(Vref, Signal_V));


figure(1)
plot(t*1e3,Signal_V)
xlabel('t   [ms]')
ylabel('Signal [V]')

OutFileID = fopen(VHDL_in_file_name,'w');

fprintf(OutFileID, '%1.6f\n', Signal_V);

fclose(OutFileID);

