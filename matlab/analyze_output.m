
% Filename
VHDL_in_file_name = '../sim/data/input_file.dat';
VHDL_out_file_name = '../sim/data/output_file.dat';

% Signal Parameter
f = 100;
N = 10000;
fs = 100e3;
NBit = 12;

% Signal
in  = load(VHDL_in_file_name);
out = load(VHDL_out_file_name);
out = out /2.048*3.3;



Nin = length(in);
Nout = length(out);

tin = (0:Nin-1)'/fs;
tout = (0:Nout-1)'/fs;

figure(1)
plot(tin*1e3,in,tout*1e3,out)
%plot(tout*1e3,out)
xlabel('t   [ms]')
ylabel('Signal [V]')
